package com.clinica.agendamento.dto;

import com.clinica.agendamento.enums.Perfil;

public record UsuarioResponse(

        Long id,
        String nome,
        String email,
        Perfil perfil,
        Boolean ativo

) {
}