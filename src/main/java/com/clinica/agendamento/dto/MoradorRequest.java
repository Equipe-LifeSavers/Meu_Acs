package com.clinica.agendamento.dto;

import java.time.LocalDate;

import com.clinica.agendamento.enums.Sexo;

public record MoradorRequest(
        String nome,
        String cpf,
        LocalDate dataNascimento,
        Sexo sexo,
        String telefone,
        Long familiaId) {
}