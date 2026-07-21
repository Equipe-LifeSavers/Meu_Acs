package com.clinica.agendamento.repository;

import com.clinica.agendamento.model.Acs;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface AcsRepository extends JpaRepository<Acs, Long> {

    Optional<Acs> findByUsuarioEmail(String email);

    long countByRegiaoId(Long regiaoId);

    long countByRegiaoUbsId(Long ubsId);

}