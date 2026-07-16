package com.clinica.agendamento.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.*;

import com.clinica.agendamento.enums.Demanda;

@Entity
@Table(name = "visitas")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Visita {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "morador_id", nullable = false)
    private Morador morador;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "acs_id", nullable = false)
    private Acs acs;

    @Column(nullable = false)
    private LocalDate data;

    @Column(length = 1000)
    private String observacoes;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Demanda demanda;

    @Column(nullable = false)
    private Boolean visitaRealizada;

    @Column(name = "data_cadastro", nullable = false)
    private LocalDateTime dataCadastro;

    @Column(name = "ultima_atualizacao")
    private LocalDateTime ultimaAtualizacao;
}