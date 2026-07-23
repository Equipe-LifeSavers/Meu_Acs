package com.clinica.agendamento.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import com.clinica.agendamento.dto.AlterarSenhaRequest;
import com.clinica.agendamento.dto.AtualizarPerfilRequest;
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

    @GetMapping
    public ResponseEntity<UsuarioResponse> meuPerfil(
            @AuthenticationPrincipal Usuario usuarioLogado) {

        return ResponseEntity.ok(paraResponse(usuarioLogado));
    }

    @PutMapping
    public ResponseEntity<?> atualizarPerfil(
            @AuthenticationPrincipal Usuario usuarioLogado,
            @Valid @RequestBody AtualizarPerfilRequest dto) {

        boolean emailEmUso = usuarioRepository.findByEmail(dto.email())
                .map(u -> !u.getId().equals(usuarioLogado.getId()))
                .orElse(false);

        if (emailEmUso) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body("Este e-mail já está em uso por outro usuário");
        }

        Usuario usuario = usuarioRepository.findById(usuarioLogado.getId())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        usuario.setNome(dto.nome());
        usuario.setEmail(dto.email());

        usuario = usuarioRepository.save(usuario);

        return ResponseEntity.ok(paraResponse(usuario));
    }

    @PutMapping("/senha")
    public ResponseEntity<?> alterarSenha(
            @AuthenticationPrincipal Usuario usuarioLogado,
            @Valid @RequestBody AlterarSenhaRequest dto) {

        Usuario usuario = usuarioRepository.findById(usuarioLogado.getId())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        if (!passwordEncoder.matches(dto.senhaAtual(), usuario.getSenha())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body("Senha atual incorreta");
        }

        usuario.setSenha(passwordEncoder.encode(dto.novaSenha()));

        usuarioRepository.save(usuario);

        return ResponseEntity.noContent().build();
    }

    private UsuarioResponse paraResponse(Usuario usuario) {
        return new UsuarioResponse(
                usuario.getId(),
                usuario.getNome(),
                usuario.getEmail(),
                usuario.getPerfil(),
                usuario.isAtivo());
    }

}