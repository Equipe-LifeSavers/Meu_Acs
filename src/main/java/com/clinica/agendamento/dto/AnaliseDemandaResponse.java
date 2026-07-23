package com.clinica.agendamento.dto;

import com.clinica.agendamento.enums.Demanda;

public record AnaliseDemandaResponse(

        Demanda demanda,

        Long quantidade

) {
}