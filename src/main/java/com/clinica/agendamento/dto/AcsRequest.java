package com.clinica.agendamento.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.NotBlank;

public record AcsRequest(@NotBlank String nome, @NotBlank String telefone, @NotBlank String microarea,
                @NotNull Long regiaoId, @NotNull Long usuarioId) {
}
