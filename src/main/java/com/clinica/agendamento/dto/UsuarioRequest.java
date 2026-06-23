package com.clinica.agendamento.dto;

import com.clinica.agendamento.enums.Perfil;

public record UsuarioRequest(
        String nome,
        String email,
        String senha,
        Perfil perfil) {
}