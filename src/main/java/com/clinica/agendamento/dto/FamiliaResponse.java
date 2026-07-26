package com.clinica.agendamento.dto;

import java.util.List;

public record FamiliaResponse(
        Long id,
        ResidenciaResponse residencia,
        MoradorResponse responsavel,
        List<MoradorResponse> moradores
) {}