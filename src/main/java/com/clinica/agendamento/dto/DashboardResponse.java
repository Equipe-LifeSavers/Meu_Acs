package com.clinica.agendamento.dto;

public record DashboardResponse(

        Long totalUbs,

        Long totalRegioes,

        Long totalAcs,

        Long totalResidencias,

        Long totalFamilias,

        Long totalMoradores,

        Long totalVisitas,

        Long visitasRealizadas,

        Long visitasPendentes

) {
}