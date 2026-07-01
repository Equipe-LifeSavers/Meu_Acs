package com.clinica.agendamento.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record VisitaResponse(

        Long id,

        Long moradorId,

        String nomeMorador,

        Long familiaId,

        Long acsId,

        String nomeAcs,

        LocalDate data,

        String observacoes,

        Boolean visitaRealizada,

        LocalDateTime dataCadastro,

        LocalDateTime ultimaAtualizacao

) {
}