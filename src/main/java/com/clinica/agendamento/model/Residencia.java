package com.clinica.agendamento.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "residencias")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Residencia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String endereco;

    private String tipoImovel;

    private boolean possuiAgua;

    private boolean possuiEnergia;

    private boolean possuiEsgoto;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "regiao_id", nullable = false)
    private Regiao regiao;

}
