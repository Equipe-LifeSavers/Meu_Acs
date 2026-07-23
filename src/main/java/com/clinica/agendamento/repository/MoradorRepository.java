package com.clinica.agendamento.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.clinica.agendamento.model.Morador;

public interface MoradorRepository extends JpaRepository<Morador, Long> {

    boolean existsByCpf(String cpf);

    Optional<Morador> findByCpf(String cpf);

    List<Morador> findByFamiliaId(Long familiaId);

    long countByFamiliaResidenciaRegiaoId(Long regiaoId);

    long countByFamiliaResidenciaRegiaoUbsId(Long ubsId);

}