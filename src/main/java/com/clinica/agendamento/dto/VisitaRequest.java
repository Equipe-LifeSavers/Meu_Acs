package com.clinica.agendamento.dto;

import java.time.LocalDate;

import com.clinica.agendamento.enums.Demanda;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record VisitaRequest(

                @NotNull(message = "O morador é obrigatório") Long moradorId,

                @NotNull(message = "O ACS é obrigatório") Long acsId,

                @NotNull(message = "A data da visita é obrigatória") LocalDate data,

                @Size(max = 1000, message = "Observações podem ter no máximo 1000 caracteres") String observacoes,

                @NotNull(message = "A demanda é obrigatória") Demanda demanda,

                @NotNull(message = "Informe se a visita foi realizada") Boolean visitaRealizada

) {
}