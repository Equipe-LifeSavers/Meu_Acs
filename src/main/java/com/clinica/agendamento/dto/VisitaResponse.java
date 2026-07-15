package com.clinica.agendamento.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import com.clinica.agendamento.enums.Demanda;

public record VisitaResponse(

                Long id,

                Long moradorId,

                String nomeMorador,

                Long familiaId,

                Long acsId,

                String nomeAcs,

                LocalDate data,

                String observacoes,

                Demanda demanda,

                Boolean visitaRealizada,

                LocalDateTime dataCadastro,

                LocalDateTime ultimaAtualizacao

) {
}