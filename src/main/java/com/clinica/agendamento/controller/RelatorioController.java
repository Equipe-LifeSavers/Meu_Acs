package com.clinica.agendamento.controller;

import java.util.Arrays;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.clinica.agendamento.dto.IndicadorDemandaResponse;
import com.clinica.agendamento.dto.RelatorioRegiaoResponse;
import com.clinica.agendamento.enums.Demanda;
import com.clinica.agendamento.model.Regiao;
import com.clinica.agendamento.repository.AcsRepository;
import com.clinica.agendamento.repository.FamiliaRepository;
import com.clinica.agendamento.repository.MoradorRepository;
import com.clinica.agendamento.repository.RegiaoRepository;
import com.clinica.agendamento.repository.ResidenciaRepository;
import com.clinica.agendamento.repository.VisitaRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/relatorios")
@RequiredArgsConstructor
public class RelatorioController {

    private final RegiaoRepository regiaoRepository;
    private final AcsRepository acsRepository;
    private final ResidenciaRepository residenciaRepository;
    private final FamiliaRepository familiaRepository;
    private final MoradorRepository moradorRepository;
    private final VisitaRepository visitaRepository;

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping("/regioes")
    public ResponseEntity<List<RelatorioRegiaoResponse>> relatorioGeral() {

        List<RelatorioRegiaoResponse> relatorio = regiaoRepository.findAll()
                .stream()
                .map(this::montarRelatorio)
                .toList();

        return ResponseEntity.ok(relatorio);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping("/regioes/{regiaoId}")
    public ResponseEntity<RelatorioRegiaoResponse> relatorioPorRegiao(
            @PathVariable Long regiaoId) {

        Regiao regiao = regiaoRepository.findById(regiaoId)
                .orElseThrow(() -> new RuntimeException("Região não encontrada"));

        return ResponseEntity.ok(montarRelatorio(regiao));
    }

    private RelatorioRegiaoResponse montarRelatorio(Regiao regiao) {

        Long regiaoId = regiao.getId();

        List<IndicadorDemandaResponse> demandas = Arrays.stream(Demanda.values())
                .map(demanda -> new IndicadorDemandaResponse(
                        demanda.name(),
                        visitaRepository.countByAcsRegiaoIdAndDemanda(regiaoId, demanda)))
                .toList();

        return new RelatorioRegiaoResponse(

                regiaoId,

                regiao.getNomeArea(),

                regiao.getUbs().getNome(),

                acsRepository.countByRegiaoId(regiaoId),

                (long) residenciaRepository.findByRegiaoId(regiaoId).size(),

                (long) familiaRepository.findByResidenciaRegiaoId(regiaoId).size(),

                moradorRepository.countByFamiliaResidenciaRegiaoId(regiaoId),

                visitaRepository.countByAcsRegiaoId(regiaoId),

                visitaRepository.countByAcsRegiaoIdAndVisitaRealizadaTrue(regiaoId),

                visitaRepository.countByAcsRegiaoIdAndVisitaRealizadaFalse(regiaoId),

                demandas
        );
    }

}