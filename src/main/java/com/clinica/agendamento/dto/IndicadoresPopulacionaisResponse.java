package com.clinica.agendamento.dto;

public record IndicadoresPopulacionaisResponse(

        long totalMoradores,
        long totalFamilias,
        long totalResidencias,

        double mediaMoradoresPorFamilia,

        long homens,
        long mulheres,
        long outros,

        long criancas,
        long adultos,
        long idosos

) {
}