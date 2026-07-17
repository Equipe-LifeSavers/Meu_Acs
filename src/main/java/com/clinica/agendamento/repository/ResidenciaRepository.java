package com.clinica.agendamento.repository;

import java.util.List;

import com.clinica.agendamento.model.Residencia;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ResidenciaRepository extends JpaRepository<Residencia, Long> {

    List<Residencia> findByRegiaoId(Long regiaoId);

}
