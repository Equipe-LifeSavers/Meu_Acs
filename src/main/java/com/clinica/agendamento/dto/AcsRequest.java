package com.clinica.agendamento.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record AcsRequest (
    @NotBlank String nome,
    @NotNull Long regiaoId,
    @NotNull Long usuarioId
) {}
