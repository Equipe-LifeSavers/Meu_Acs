package com.clinica.agendamento.dto;

import java.time.LocalDate;

import com.clinica.agendamento.enums.Sexo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

public record MoradorRequest(

                @NotBlank(message = "Nome é obrigatório") String nome,

                @NotBlank(message = "CPF é obrigatório") @Pattern(regexp = "\\d{11}", message = "CPF deve conter 11 dígitos") String cpf,

                LocalDate dataNascimento,

                @NotNull(message = "Sexo é obrigatório") Sexo sexo,

                String telefone,

                @NotNull(message = "Família é obrigatória") Long familiaId) {
}