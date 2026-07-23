package com.clinica.agendamento.repository;

import com.clinica.agendamento.model.Regiao;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RegiaoRepository extends JpaRepository<Regiao, Long> {

    long countByUbsId(Long ubsId);

}