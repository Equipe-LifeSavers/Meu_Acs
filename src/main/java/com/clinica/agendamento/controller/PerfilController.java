package com.clinica.agendamento.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import com.clinica.agendamento.dto.PerfilRequest;
import com.clinica.agendamento.dto.UsuarioResponse;
import com.clinica.agendamento.model.Usuario;
import com.clinica.agendamento.repository.UsuarioRepository;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/perfil")
@RequiredArgsConstructor
public class PerfilController {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    @PreAuthorize("isAuthenticated()")
    @GetMapping
    public ResponseEntity<UsuarioResponse> meuPerfil(
            Authentication authentication) {

        Usuario usuario = usuarioRepository
                .findByEmail(authentication.getName())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado."));

        return ResponseEntity.ok(toResponse(usuario));
    }

    @PreAuthorize("isAuthenticated()")
    @PutMapping
    public ResponseEntity<UsuarioResponse> atualizarPerfil(
            Authentication authentication,
            @Valid @RequestBody PerfilRequest request) {

        Usuario usuario = usuarioRepository
                .findByEmail(authentication.getName())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado."));

        if (!usuario.getEmail().equals(request.email())
                && usuarioRepository.existsByEmail(request.email())) {

            throw new RuntimeException("E-mail já cadastrado.");
        }

        usuario.setNome(request.nome());
        usuario.setEmail(request.email());

        if (request.senha() != null && !request.senha().isBlank()) {
            usuario.setSenha(passwordEncoder.encode(request.senha()));
        }

        usuario = usuarioRepository.save(usuario);

        return ResponseEntity.ok(toResponse(usuario));
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