package com.clinica.agendamento.repository;

import com.clinica.agendamento.model.Familia;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FamiliaRepository extends JpaRepository<Familia, Long> {
}