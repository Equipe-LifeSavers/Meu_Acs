package com.clinica.agendamento.repository;

import com.clinica.agendamento.model.HorarioDisponivel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface HorarioDisponivelRepository extends JpaRepository<HorarioDisponivel, Long> {

    List<HorarioDisponivel> findByDisponivelTrue();

    List<HorarioDisponivel> findByMedicoIdAndDisponivelTrue(Long medicoId);
}