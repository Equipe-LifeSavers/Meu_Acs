package com.clinica.agendamento.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@Setter
public class HorarioRequest {

    private Long medicoId;
    private LocalDate data;
    private LocalTime hora;
}