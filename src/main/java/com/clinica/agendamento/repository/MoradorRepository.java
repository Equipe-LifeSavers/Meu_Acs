package com.clinica.agendamento.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.clinica.agendamento.enums.Sexo;
import com.clinica.agendamento.model.Morador;

public interface MoradorRepository extends JpaRepository<Morador, Long> {

    boolean existsByCpf(String cpf);

    Optional<Morador> findByCpf(String cpf);

    List<Morador> findByFamiliaId(Long familiaId);

    long countByFamiliaResidenciaRegiaoId(Long regiaoId);

    long countByFamiliaResidenciaRegiaoUbsId(Long ubsId);

    long countBySexo(Sexo sexo);

    @Query("""
            SELECT COUNT(m)
            FROM Morador m
            WHERE m.dataNascimento > :data
            """)
    long countByDataNascimentoAfter(
            @Param("data") LocalDate data);

    @Query("""
            SELECT COUNT(m)
            FROM Morador m
            WHERE m.dataNascimento BETWEEN :inicio AND :fim
            """)
    long countByDataNascimentoBetween(
            @Param("inicio") LocalDate inicio,
            @Param("fim") LocalDate fim);

    @Query("""
            SELECT COUNT(m)
            FROM Morador m
            WHERE m.dataNascimento < :data
            """)
    long countByDataNascimentoBefore(
            @Param("data") LocalDate data);

}