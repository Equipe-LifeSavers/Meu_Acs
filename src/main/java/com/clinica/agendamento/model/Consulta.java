package com.clinica.agendamento.model;

import com.clinica.agendamento.enums.StatusConsulta;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Consulta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private Paciente paciente;

    @ManyToOne
    private Medico medico;

    @ManyToOne
    private HorarioDisponivel horarioDisponivel;

    private LocalDate data;

    private LocalTime hora;

    @Enumerated(EnumType.STRING)
    private StatusConsulta status;
}