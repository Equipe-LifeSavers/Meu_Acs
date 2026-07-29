package com.clinica.agendamento.dto;

import com.clinica.agendamento.enums.Perfil;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public record UsuarioRequest(
                String nome,
                @NotBlank(message = "CPF é obrigatório") @Pattern(regexp = "\\d{11}", message = "CPF deve conter 11 dígitos") String cpf,
                String email,
                String senha,
                Perfil perfil) {
}