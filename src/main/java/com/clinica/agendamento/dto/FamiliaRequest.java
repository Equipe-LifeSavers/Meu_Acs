package com.clinica.agendamento.dto;

import jakarta.validation.constraints.NotNull;

public record FamiliaRequest(

        @NotNull(message = "O ID da residência é obrigatório") Long residenciaId,

        Long responsavelId

) {
}