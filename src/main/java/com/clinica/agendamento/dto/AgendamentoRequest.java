package com.clinica.agendamento.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AgendamentoRequest {

    @NotNull
    private Long pacienteId;

    @NotNull
    private Long horarioId;
}