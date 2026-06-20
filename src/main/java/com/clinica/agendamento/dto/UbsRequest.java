package com.clinica.agendamento.dto;

import jakarta.validation.constraints.NotBlank;
public record UbsRequest (
    @NotBlank String nome
    
) {}
