package com.clinica.agendamento.controller;

import java.util.List;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.clinica.agendamento.dto.CoberturaRegiaoResponse;
import com.clinica.agendamento.model.Regiao;
import com.clinica.agendamento.repository.AcsRepository;
import com.clinica.agendamento.repository.FamiliaRepository;
import com.clinica.agendamento.repository.MoradorRepository;
import com.clinica.agendamento.repository.RegiaoRepository;
import com.clinica.agendamento.repository.ResidenciaRepository;
import com.clinica.agendamento.repository.VisitaRepository;
import com.clinica.agendamento.service.PdfExportService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/cobertura")
@RequiredArgsConstructor
public class CoberturaController {

    private final RegiaoRepository regiaoRepository;
    private final AcsRepository acsRepository;
    private final ResidenciaRepository residenciaRepository;
    private final FamiliaRepository familiaRepository;
    private final MoradorRepository moradorRepository;
    private final VisitaRepository visitaRepository;
    private final PdfExportService pdfExportService;

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping("/regioes")
    public ResponseEntity<List<CoberturaRegiaoResponse>> coberturaGeral() {

        List<CoberturaRegiaoResponse> cobertura = regiaoRepository.findAll()
                .stream()
                .map(this::montarCobertura)
                .toList();

        return ResponseEntity.ok(cobertura);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping("/regioes/{regiaoId}")
    public ResponseEntity<CoberturaRegiaoResponse> coberturaPorRegiao(
            @PathVariable Long regiaoId) {

        Regiao regiao = regiaoRepository.findById(regiaoId)
                .orElseThrow(() -> new RuntimeException("Região não encontrada"));

        return ResponseEntity.ok(montarCobertura(regiao));
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping("/regioes/pdf")
    public ResponseEntity<byte[]> coberturaGeralPdf() {

        List<CoberturaRegiaoResponse> cobertura = regiaoRepository.findAll()
                .stream()
                .map(this::montarCobertura)
                .toList();

        byte[] pdf = pdfExportService.gerarPdfCobertura(cobertura);

        return responderPdf(pdf, "cobertura-territorial.pdf");
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping("/regioes/{regiaoId}/pdf")
    public ResponseEntity<byte[]> coberturaPorRegiaoPdf(@PathVariable Long regiaoId) {

        Regiao regiao = regiaoRepository.findById(regiaoId)
                .orElseThrow(() -> new RuntimeException("Região não encontrada"));

        byte[] pdf = pdfExportService.gerarPdfCobertura(List.of(montarCobertura(regiao)));

        return responderPdf(pdf, "cobertura-regiao-" + regiaoId + ".pdf");
    }

    private ResponseEntity<byte[]> responderPdf(byte[] pdf, String nomeArquivo) {
        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + nomeArquivo)
                .body(pdf);
    }

    private CoberturaRegiaoResponse montarCobertura(Regiao regiao) {

        Long regiaoId = regiao.getId();

        long totalAcs = acsRepository.countByRegiaoId(regiaoId);
        long totalFamilias = familiaRepository.findByResidenciaRegiaoId(regiaoId).size();
        long totalMoradores = moradorRepository.countByFamiliaResidenciaRegiaoId(regiaoId);

        long familiasComVisita = visitaRepository.countFamiliasComVisitaPorRegiao(regiaoId);
        long moradoresVisitados = visitaRepository.countMoradoresVisitadosPorRegiao(regiaoId);

        double percentualFamilias = totalFamilias == 0
                ? 0.0
                : (familiasComVisita * 100.0) / totalFamilias;

        double percentualMoradores = totalMoradores == 0
                ? 0.0
                : (moradoresVisitados * 100.0) / totalMoradores;

        double moradoresPorAcs = totalAcs == 0
                ? 0.0
                : (double) totalMoradores / totalAcs;

        return new CoberturaRegiaoResponse(

                regiaoId,

                regiao.getNomeArea(),

                totalAcs,

                (long) residenciaRepository.findByRegiaoId(regiaoId).size(),

                totalFamilias,

                familiasComVisita,

                arredondar(percentualFamilias),

                totalMoradores,

                moradoresVisitados,

                arredondar(percentualMoradores),

                arredondar(moradoresPorAcs)
        );
    }

    private double arredondar(double valor) {
        return Math.round(valor * 100.0) / 100.0;
    }

}