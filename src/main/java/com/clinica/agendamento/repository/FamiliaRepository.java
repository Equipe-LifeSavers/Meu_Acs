package com.clinica.agendamento.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.clinica.agendamento.model.Familia;

public interface FamiliaRepository extends JpaRepository<Familia, Long> {

}