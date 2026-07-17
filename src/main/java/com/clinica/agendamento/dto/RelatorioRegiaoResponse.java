package com.clinica.agendamento.dto;

import java.util.List;

public record RelatorioRegiaoResponse(

        Long regiaoId,

        String nomeArea,

        String ubsNome,

        Long totalAcs,

        Long totalResidencias,

        Long totalFamilias,

        Long totalMoradores,

        Long totalVisitas,

        Long visitasRealizadas,

        Long visitasPendentes,

        List<IndicadorDemandaResponse> demandas

) {
}
