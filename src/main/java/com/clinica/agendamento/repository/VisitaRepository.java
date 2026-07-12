package com.clinica.agendamento.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.clinica.agendamento.model.Visita;

public interface VisitaRepository extends JpaRepository<Visita, Long> {

    List<Visita> findByMoradorId(Long moradorId);

    List<Visita> findByAcsId(Long acsId);

    List<Visita> findByData(LocalDate data);

    List<Visita> findByVisitaRealizada(Boolean visitaRealizada);

    List<Visita> findByMoradorFamiliaId(Long familiaId);

    List<Visita> findAllByOrderByDataDesc();

    List<Visita> findByMoradorIdOrderByDataDesc(Long moradorId);

    List<Visita> findByAcsIdOrderByDataDesc(Long acsId);

    List<Visita> findByMoradorFamiliaIdOrderByDataDesc(Long familiaId);

    List<Visita> findByAcsRegiaoId(Long regiaoId);

    List<Visita> findByAcsRegiaoUbsId(Long ubsId);

    List<Visita> findByDataBetween(LocalDate inicio, LocalDate fim);

}