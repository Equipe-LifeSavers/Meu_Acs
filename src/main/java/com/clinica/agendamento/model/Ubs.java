package com.clinica.agendamento.model;

import jakarta.persistence.*;
import lombok.*;
import java.util.List;

@Entity
@Table(name = "ubs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Ubs {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nome;

    @OneToMany(mappedBy = "ubs")
    private List<Regiao> regioes;

}
