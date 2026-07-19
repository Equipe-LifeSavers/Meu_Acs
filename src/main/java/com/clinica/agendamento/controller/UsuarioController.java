package com.clinica.agendamento.controller;

import com.clinica.agendamento.dto.UsuarioRequest;
import com.clinica.agendamento.dto.UsuarioResponse;
import com.clinica.agendamento.enums.Perfil;
import com.clinica.agendamento.model.Usuario;
import com.clinica.agendamento.repository.UsuarioRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/usuarios")
@RequiredArgsConstructor
public class UsuarioController {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    @PreAuthorize("hasAnyRole('ADMIN')")
    @PostMapping
    public ResponseEntity<UsuarioResponse> criar(
            @RequestBody UsuarioRequest request) {

        if (usuarioRepository.existsByEmail(request.email())) {
            throw new RuntimeException("E-mail já cadastrado.");
        }

        Usuario usuario = new Usuario();

        usuario.setNome(request.nome());
        usuario.setEmail(request.email());
        usuario.setSenha(passwordEncoder.encode(request.senha()));
        usuario.setPerfil(request.perfil());

        usuario = usuarioRepository.save(usuario);

        return ResponseEntity.ok(toResponse(usuario));
    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @GetMapping
    public ResponseEntity<List<UsuarioResponse>> listarTodos() {
        return ResponseEntity.ok(
                usuarioRepository.findAll()
                        .stream()
                        .map(this::toResponse)
                        .toList());
    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @GetMapping("/{id}")
    public ResponseEntity<UsuarioResponse> buscarPorId(
            @PathVariable Long id) {

        return usuarioRepository.findById(id)
                .map(this::toResponse)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<UsuarioResponse> atualizar(
            @PathVariable Long id,
            @RequestBody UsuarioRequest request) {

        return usuarioRepository.findById(id)
                .map(usuario -> {

                    usuario.setNome(request.nome());
                    if (!usuario.getEmail().equals(request.email())
                            && usuarioRepository.existsByEmail(request.email())) {

                        throw new RuntimeException("E-mail já cadastrado.");
                    }
                    usuario.setEmail(request.email());

                    if (request.senha() != null && !request.senha().isBlank()) {
                        usuario.setSenha(
                                passwordEncoder.encode(request.senha()));
                    }

                    usuario.setPerfil(request.perfil());

                    return ResponseEntity.ok(
                            toResponse(
                                    usuarioRepository.save(usuario)));

                }).orElse(ResponseEntity.notFound().build());

    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(
            @PathVariable Long id) {

        if (usuarioRepository.existsById(id)) {

            usuarioRepository.deleteById(id);

            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.notFound().build();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PatchMapping("/{id}/ativar")
    public ResponseEntity<UsuarioResponse> ativar(
            @PathVariable Long id) {

        return usuarioRepository.findById(id)
                .map(usuario -> {

                    usuario.setAtivo(true);

                    return ResponseEntity.ok(
                            toResponse(
                                    usuarioRepository.save(usuario)));

                }).orElse(ResponseEntity.notFound().build());

    }

    @PreAuthorize("hasRole('ADMIN')")
    @PatchMapping("/{id}/desativar")
    public ResponseEntity<UsuarioResponse> desativar(
            @PathVariable Long id) {

        return usuarioRepository.findById(id)
                .map(usuario -> {

                    usuario.setAtivo(false);

                    return ResponseEntity.ok(
                            toResponse(
                                    usuarioRepository.save(usuario)));

                }).orElse(ResponseEntity.notFound().build());

    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/ativos")
    public ResponseEntity<List<UsuarioResponse>> listarAtivos() {

        return ResponseEntity.ok(

                usuarioRepository.findByAtivoTrue()

                        .stream()

                        .map(this::toResponse)

                        .toList()

        );

    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/perfil/{perfil}")
    public ResponseEntity<List<UsuarioResponse>> listarPorPerfil(
            @PathVariable Perfil perfil) {

        return ResponseEntity.ok(

                usuarioRepository.findByPerfil(perfil)

                        .stream()

                        .map(this::toResponse)

                        .toList()

        );

    }

    private UsuarioResponse toResponse(Usuario usuario) {

        return new UsuarioResponse(

                usuario.getId(),
                usuario.getNome(),
                usuario.getEmail(),
                usuario.getPerfil(),
                usuario.isAtivo()

        );

    }
}