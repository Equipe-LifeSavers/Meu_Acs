package com.clinica.agendamento.dto;

public record UbsResumoResponse(

        Long ubsId,
 
        String nomeUbs,
 
        Long totalRegioes,
 
        Long totalAcs,
 
        Long totalResidencias,
 
        Long totalFamilias,
 
        Long totalMoradores,
 
        Long totalVisitas,
 
        Long visitasRealizadas,
 
        Long visitasPendentes,
 
        Double percentualCobertura

) {  
}
