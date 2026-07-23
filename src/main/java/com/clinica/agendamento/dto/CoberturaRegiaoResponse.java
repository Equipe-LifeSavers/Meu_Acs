package com.clinica.agendamento.dto;

public record CoberturaRegiaoResponse(

        Long regiaoId,
 
        String nomeArea,
 
        Long totalAcs,
 
        Long totalResidencias,
 
        Long totalFamilias,
 
        Long familiasComVisita,
 
        Double percentualCoberturaFamilias,
 
        Long totalMoradores,
 
        Long moradoresVisitados,
 
        Double percentualCoberturaMoradores,
 
        Double moradoresPorAcs

){
    
}
