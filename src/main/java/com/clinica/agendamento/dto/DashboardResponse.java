package com.clinica.agendamento.dto;

public record DashboardResponse(

        Long totalRegioes,

        Long totalAcs,

        Long totalFamilias,

        Long totalMoradores,

        Long totalVisitas,

        Long visitasRealizadas,

        Long visitasPendentes

) {
}