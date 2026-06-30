package com.clinica.agendamento.dto;

import java.time.LocalDate;

import com.clinica.agendamento.enums.Sexo;

public record MoradorResponse(
        Long id,
        String nome,
        String cpf,
        LocalDate dataNascimento,
        Sexo sexo,
        String telefone) {
}