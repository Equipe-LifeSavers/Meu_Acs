package com.clinica.agendamento.model;

import jakarta.persistence.*;
import lombok.*;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "regioes")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Regiao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nome_area", nullable = false)
    private String nomeArea;

    @Column(length = 500)
    private String observacao;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ubs_id", nullable = false)
    private Ubs ubs;

    @JsonIgnore
    @OneToMany(mappedBy = "regiao")
    private List<Acs> agentes;
}
