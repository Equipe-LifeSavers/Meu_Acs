package com.clinica.agendamento.dto;

import java.time.LocalDate;

import com.clinica.agendamento.enums.Sexo;
import java.time.LocalDateTime;

public record MoradorResponse(

        Long id,
        String nome,
        String cpf,
        LocalDate dataNascimento,
        Sexo sexo,
        String telefone,
        Long familiaId,
        LocalDateTime ultimaAtualizacao,
        String atualizadoPor) {
}