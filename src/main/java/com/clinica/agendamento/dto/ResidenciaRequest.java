package com.clinica.agendamento.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record ResidenciaRequest(
    @NotBlank String endereco,
    @NotNull Long regiaoId
){}