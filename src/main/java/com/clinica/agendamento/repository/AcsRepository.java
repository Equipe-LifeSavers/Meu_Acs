package com.clinica.agendamento.repository;

import com.clinica.agendamento.model.Acs;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AcsRepository extends JpaRepository<Acs, Long> {
    
}
