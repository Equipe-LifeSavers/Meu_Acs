package com.clinica.agendamento.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "acs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Acs {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nome;

    @Column(nullable = false)
    private String telefone;

    @Column(nullable = false)
    private String microarea;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "regiao_id", nullable = false)
    private Regiao regiao;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

}
