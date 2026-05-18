package com.clinica.agendamento.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalTime;

import jakarta.validation.constraints.NotNull;

@Getter
@Setter
public class HorarioRequest {

    @NotNull
    private Long medicoId;

    @NotNull
    private LocalDate data;

    @NotNull
    private LocalTime hora;
}