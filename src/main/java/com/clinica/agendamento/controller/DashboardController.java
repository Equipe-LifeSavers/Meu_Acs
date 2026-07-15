package com.clinica.agendamento.controller;

import com.clinica.agendamento.dto.DashboardResponse;
import com.clinica.agendamento.dto.IndicadorDemandaResponse;
import com.clinica.agendamento.repository.AcsRepository;
import com.clinica.agendamento.repository.FamiliaRepository;
import com.clinica.agendamento.repository.MoradorRepository;
import com.clinica.agendamento.repository.RegiaoRepository;
import com.clinica.agendamento.repository.VisitaRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final RegiaoRepository regiaoRepository;
    private final AcsRepository acsRepository;
    private final FamiliaRepository familiaRepository;
    private final MoradorRepository moradorRepository;
    private final VisitaRepository visitaRepository;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','UBS')")
    public DashboardResponse dashboard() {

        return new DashboardResponse(

                regiaoRepository.count(),

                acsRepository.count(),

                familiaRepository.count(),

                moradorRepository.count(),

                visitaRepository.count(),

                visitaRepository.countByVisitaRealizadaTrue(),

                visitaRepository.countByVisitaRealizadaFalse()

        );

    }

    @GetMapping("/demandas")
    @PreAuthorize("hasAnyRole('ADMIN','UBS')")
    public List<IndicadorDemandaResponse> demandas() {

        return List.of(

                new IndicadorDemandaResponse(
                        "Visitas realizadas",
                        visitaRepository.countByVisitaRealizadaTrue()),

                new IndicadorDemandaResponse(
                        "Visitas pendentes",
                        visitaRepository.countByVisitaRealizadaFalse())

        );

    }

}