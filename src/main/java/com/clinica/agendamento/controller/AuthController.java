package com.clinica.agendamento.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.clinica.agendamento.dto.LoginRequest;
import com.clinica.agendamento.dto.LoginResponse;
import com.clinica.agendamento.model.Usuario;
import com.clinica.agendamento.repository.UsuarioRepository;
import com.clinica.agendamento.security.JwtService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        Usuario usuario = usuarioRepository.findByEmail(request.email()).orElseThrow();

        if (!passwordEncoder.matches(request.senha(), usuario.getSenha())) {
            return ResponseEntity.badRequest().build();
        }

        String token = jwtService.generateToken(usuario.getEmail());

        return ResponseEntity.ok(new LoginResponse(token, usuario.getPerfil().name()));

    }

    @GetMapping("/hash")
    public String gerarHash() {
        return passwordEncoder.encode("123456");
    }

}
