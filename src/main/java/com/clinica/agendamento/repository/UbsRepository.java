package com.clinica.agendamento.repository;

import com.clinica.agendamento.model.Ubs;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UbsRepository extends JpaRepository<Ubs, Long> {
}
