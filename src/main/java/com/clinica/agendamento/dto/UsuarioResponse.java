package com.clinica.agendamento.dto;

import com.clinica.agendamento.enums.Perfil;

public record UsuarioResponse(

        Long id,

        String nome,

        String cpf,

        String email,

        Perfil perfil,

        boolean ativo

) {
}