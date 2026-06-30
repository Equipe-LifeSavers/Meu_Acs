package com.clinica.agendamento.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.clinica.agendamento.model.Morador;

public interface MoradorRepository extends JpaRepository<Morador, Long> {

}