package com.clinica.agendamento.controller;

import com.clinica.agendamento.dto.DashboardResponse;
import com.clinica.agendamento.dto.IndicadorDemandaResponse;
import com.clinica.agendamento.dto.UbsResumoResponse;
import com.clinica.agendamento.model.Ubs;
import com.clinica.agendamento.repository.AcsRepository;
import com.clinica.agendamento.repository.FamiliaRepository;
import com.clinica.agendamento.repository.MoradorRepository;
import com.clinica.agendamento.repository.RegiaoRepository;
import com.clinica.agendamento.repository.ResidenciaRepository;
import com.clinica.agendamento.repository.UbsRepository;
import com.clinica.agendamento.repository.VisitaRepository;
import com.clinica.agendamento.service.PdfExportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final UbsRepository ubsRepository;
    private final RegiaoRepository regiaoRepository;
    private final AcsRepository acsRepository;
    private final ResidenciaRepository residenciaRepository;
    private final FamiliaRepository familiaRepository;
    private final MoradorRepository moradorRepository;
    private final VisitaRepository visitaRepository;
    private final PdfExportService pdfExportService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','UBS')")
    public DashboardResponse dashboard() {

        return new DashboardResponse(

                ubsRepository.count(),

                regiaoRepository.count(),

                acsRepository.count(),

                residenciaRepository.count(),

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
                        visitaRepository.countByVisitaRealizadaTrue()
                ),

                new IndicadorDemandaResponse(
                        "Visitas pendentes",
                        visitaRepository.countByVisitaRealizadaFalse()
                )

        );
    }

    @GetMapping("/gerencial")
    @PreAuthorize("hasAnyRole('ADMIN','UBS')")
    public ResponseEntity<List<UbsResumoResponse>> dashboardGerencial() {

        List<UbsResumoResponse> resumo = ubsRepository.findAll()
                .stream()
                .map(this::montarResumo)
                .toList();

        return ResponseEntity.ok(resumo);
    }

    @GetMapping("/gerencial/{ubsId}")
    @PreAuthorize("hasAnyRole('ADMIN','UBS')")
    public ResponseEntity<UbsResumoResponse> dashboardGerencialPorUbs(
            @PathVariable Long ubsId) {

        Ubs ubs = ubsRepository.findById(ubsId)
                .orElseThrow(() -> new RuntimeException("UBS não encontrada"));

        return ResponseEntity.ok(montarResumo(ubs));
    }

    @GetMapping("/gerencial/pdf")
    @PreAuthorize("hasAnyRole('ADMIN','UBS')")
    public ResponseEntity<byte[]> dashboardGerencialPdf() {

        List<UbsResumoResponse> resumo = ubsRepository.findAll()
                .stream()
                .map(this::montarResumo)
                .toList();

        byte[] pdf = pdfExportService.gerarPdfDashboardGerencial(resumo);

        return responderPdf(pdf, "dashboard-gerencial.pdf");
    }

    @GetMapping("/gerencial/{ubsId}/pdf")
    @PreAuthorize("hasAnyRole('ADMIN','UBS')")
    public ResponseEntity<byte[]> dashboardGerencialPorUbsPdf(@PathVariable Long ubsId) {

        Ubs ubs = ubsRepository.findById(ubsId)
                .orElseThrow(() -> new RuntimeException("UBS não encontrada"));

        byte[] pdf = pdfExportService.gerarPdfDashboardGerencial(List.of(montarResumo(ubs)));

        return responderPdf(pdf, "dashboard-gerencial-ubs-" + ubsId + ".pdf");
    }

    private ResponseEntity<byte[]> responderPdf(byte[] pdf, String nomeArquivo) {
        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + nomeArquivo)
                .body(pdf);
    }

    private UbsResumoResponse montarResumo(Ubs ubs) {

        Long ubsId = ubs.getId();

        long totalVisitas = visitaRepository.countByAcsRegiaoUbsId(ubsId);
        long visitasRealizadas = visitaRepository.countByAcsRegiaoUbsIdAndVisitaRealizadaTrue(ubsId);
        long visitasPendentes = visitaRepository.countByAcsRegiaoUbsIdAndVisitaRealizadaFalse(ubsId);

        double percentualCobertura = totalVisitas == 0
                ? 0.0
                : (visitasRealizadas * 100.0) / totalVisitas;

        return new UbsResumoResponse(

                ubsId,

                ubs.getNome(),

                regiaoRepository.countByUbsId(ubsId),

                acsRepository.countByRegiaoUbsId(ubsId),

                residenciaRepository.countByRegiaoUbsId(ubsId),

                familiaRepository.countByResidenciaRegiaoUbsId(ubsId),

                moradorRepository.countByFamiliaResidenciaRegiaoUbsId(ubsId),

                totalVisitas,

                visitasRealizadas,

                visitasPendentes,

                Math.round(percentualCobertura * 100.0) / 100.0

        );
    }
}