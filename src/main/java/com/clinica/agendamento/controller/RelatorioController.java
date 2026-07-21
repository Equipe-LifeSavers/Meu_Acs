package com.clinica.agendamento.controller;

import java.util.Arrays;
import java.util.List;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
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
import com.clinica.agendamento.service.PdfExportService;

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
    private final PdfExportService pdfExportService;

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

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping("/regioes/pdf")
    public ResponseEntity<byte[]> relatorioGeralPdf() {

        List<RelatorioRegiaoResponse> relatorio = regiaoRepository.findAll()
                .stream()
                .map(this::montarRelatorio)
                .toList();

        byte[] pdf = pdfExportService.gerarPdfRelatorioRegioes(relatorio);

        return responderPdf(pdf, "relatorio-regioes.pdf");
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping("/regioes/{regiaoId}/pdf")
    public ResponseEntity<byte[]> relatorioPorRegiaoPdf(@PathVariable Long regiaoId) {

        Regiao regiao = regiaoRepository.findById(regiaoId)
                .orElseThrow(() -> new RuntimeException("Região não encontrada"));

        byte[] pdf = pdfExportService.gerarPdfRelatorioRegioes(List.of(montarRelatorio(regiao)));

        return responderPdf(pdf, "relatorio-regiao-" + regiaoId + ".pdf");
    }

    private ResponseEntity<byte[]> responderPdf(byte[] pdf, String nomeArquivo) {
        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + nomeArquivo)
                .body(pdf);
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