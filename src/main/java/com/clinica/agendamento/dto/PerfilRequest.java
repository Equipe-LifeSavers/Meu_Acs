package com.clinica.agendamento.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record PerfilRequest(

        @NotBlank(message = "Nome é obrigatório") String nome,

        @Email(message = "E-mail inválido") @NotBlank(message = "E-mail é obrigatório") String email,

        String senha

) {
}