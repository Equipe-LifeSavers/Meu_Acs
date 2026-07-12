package com.clinica.agendamento.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.clinica.agendamento.model.Familia;
import java.util.List;

public interface FamiliaRepository extends JpaRepository<Familia, Long> {

    List<Familia> findByResidenciaRegiaoId(Long regiaoId);

}