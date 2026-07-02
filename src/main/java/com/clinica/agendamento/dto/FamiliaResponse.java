package com.clinica.agendamento.dto;

import java.util.List;

public record FamiliaResponse(
        Long id,
        Long residenciaId,
        Long responsavelId,
        List<MoradorResponse> moradores) {
}