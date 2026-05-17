package com.clinica.agendamento.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AgendamentoRequest {

    private Long pacienteId;
    private Long horarioId;
}