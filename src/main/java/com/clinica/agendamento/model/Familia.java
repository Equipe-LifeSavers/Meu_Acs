package com.clinica.agendamento.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "familias")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Familia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "residencia_id", nullable = false)
    private Residencia residencia;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "responsavel_id")
    private Morador responsavel;

}
