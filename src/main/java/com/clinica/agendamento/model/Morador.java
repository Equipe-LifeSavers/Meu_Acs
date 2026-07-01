package com.clinica.agendamento.model;

import com.clinica.agendamento.enums.Sexo;
import com.fasterxml.jackson.annotation.JsonIgnore;

import java.time.LocalDate;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "moradores")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Morador {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nome;

    @Column(nullable = false, unique = true, length = 14)
    private String cpf;

    @Column(name = "data_nascimento")
    private LocalDate dataNascimento;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Sexo sexo;

    @Column(length = 20)
    private String telefone;

    @Column(name = "ultima_atualizacao")
    private LocalDateTime ultimaAtualizacao;

    @Column(name = "atualizado_por")
    private String atualizadoPor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "familia_id", nullable = false)
    private Familia familia;

    @JsonIgnore
    @OneToMany(mappedBy = "morador", cascade = CascadeType.ALL)
    private List<Visita> visitas = new ArrayList<>();

}