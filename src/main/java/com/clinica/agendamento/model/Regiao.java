package com.clinica.agendamento.model;

import jakarta.persistence.*;
import lombok.*;
import java.util.List;

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ubs_id", nullable = false)
    private Ubs ubs;

    @OneToMany(mappedBy = "regiao")
    private List<Acs> agentes;
}
