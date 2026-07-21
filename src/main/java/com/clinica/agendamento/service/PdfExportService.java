package com.clinica.agendamento.service;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.stereotype.Service;

import com.clinica.agendamento.dto.CoberturaRegiaoResponse;
import com.clinica.agendamento.dto.RelatorioRegiaoResponse;
import com.clinica.agendamento.dto.UbsResumoResponse;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

@Service
public class PdfExportService {

    private static final Font FONTE_TITULO = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16);
    private static final Font FONTE_SUBTITULO = FontFactory.getFont(FontFactory.HELVETICA, 9, Color.DARK_GRAY);
    private static final Font FONTE_CABECALHO = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, Color.WHITE);
    private static final Font FONTE_CELULA = FontFactory.getFont(FontFactory.HELVETICA, 9);

    public byte[] gerarPdfRelatorioRegioes(List<RelatorioRegiaoResponse> dados) {

        String[] cabecalhos = {
                "Região", "UBS", "ACS", "Residências", "Famílias",
                "Moradores", "Visitas", "Realizadas", "Pendentes"
        };

        List<String[]> linhas = dados.stream()
                .map(r -> new String[]{
                        r.nomeArea(),
                        r.ubsNome(),
                        String.valueOf(r.totalAcs()),
                        String.valueOf(r.totalResidencias()),
                        String.valueOf(r.totalFamilias()),
                        String.valueOf(r.totalMoradores()),
                        String.valueOf(r.totalVisitas()),
                        String.valueOf(r.visitasRealizadas()),
                        String.valueOf(r.visitasPendentes())
                })
                .toList();

        return gerarPdf("Relatório Gerencial por Região", cabecalhos, linhas);
    }

    public byte[] gerarPdfDashboardGerencial(List<UbsResumoResponse> dados) {

        String[] cabecalhos = {
                "UBS", "Regiões", "ACS", "Residências", "Famílias",
                "Moradores", "Visitas", "Realizadas", "Pendentes", "Cobertura (%)"
        };

        List<String[]> linhas = dados.stream()
                .map(u -> new String[]{
                        u.nomeUbs(),
                        String.valueOf(u.totalRegioes()),
                        String.valueOf(u.totalAcs()),
                        String.valueOf(u.totalResidencias()),
                        String.valueOf(u.totalFamilias()),
                        String.valueOf(u.totalMoradores()),
                        String.valueOf(u.totalVisitas()),
                        String.valueOf(u.visitasRealizadas()),
                        String.valueOf(u.visitasPendentes()),
                        String.valueOf(u.percentualCobertura())
                })
                .toList();

        return gerarPdf("Dashboard Gerencial por UBS", cabecalhos, linhas);
    }

    public byte[] gerarPdfCobertura(List<CoberturaRegiaoResponse> dados) {

        String[] cabecalhos = {
                "Região", "ACS", "Famílias c/ visita", "Cobertura Famílias (%)",
                "Moradores visitados", "Cobertura Moradores (%)", "Moradores/ACS"
        };

        List<String[]> linhas = dados.stream()
                .map(c -> new String[]{
                        c.nomeArea(),
                        String.valueOf(c.totalAcs()),
                        c.familiasComVisita() + " / " + c.totalFamilias(),
                        String.valueOf(c.percentualCoberturaFamilias()),
                        c.moradoresVisitados() + " / " + c.totalMoradores(),
                        String.valueOf(c.percentualCoberturaMoradores()),
                        String.valueOf(c.moradoresPorAcs())
                })
                .toList();

        return gerarPdf("Cobertura Territorial por Região", cabecalhos, linhas);
    }

    private byte[] gerarPdf(String titulo, String[] cabecalhos, List<String[]> linhas) {

        try (ByteArrayOutputStream saida = new ByteArrayOutputStream()) {

            Document documento = new Document(PageSize.A4.rotate(), 30, 30, 40, 30);
            PdfWriter.getInstance(documento, saida);

            documento.open();

            documento.add(new Paragraph(titulo, FONTE_TITULO));

            String geradoEm = "Gerado em " + LocalDateTime.now()
                    .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
            documento.add(new Paragraph(geradoEm, FONTE_SUBTITULO));

            documento.add(new Paragraph(" "));

            PdfPTable tabela = new PdfPTable(cabecalhos.length);
            tabela.setWidthPercentage(100);

            for (String cabecalho : cabecalhos) {
                PdfPCell celula = new PdfPCell(new Paragraph(cabecalho, FONTE_CABECALHO));
                celula.setBackgroundColor(new Color(46, 125, 50));
                celula.setHorizontalAlignment(Element.ALIGN_CENTER);
                celula.setPadding(6);
                tabela.addCell(celula);
            }

            if (linhas.isEmpty()) {
                PdfPCell vazio = new PdfPCell(new Paragraph("Nenhum dado encontrado", FONTE_CELULA));
                vazio.setColspan(cabecalhos.length);
                vazio.setHorizontalAlignment(Element.ALIGN_CENTER);
                vazio.setPadding(10);
                tabela.addCell(vazio);
            } else {
                for (String[] linha : linhas) {
                    for (String valor : linha) {
                        PdfPCell celula = new PdfPCell(new Paragraph(valor, FONTE_CELULA));
                        celula.setPadding(5);
                        tabela.addCell(celula);
                    }
                }
            }

            documento.add(tabela);
            documento.close();

            return saida.toByteArray();

        } catch (DocumentException | IOException e) {
            throw new RuntimeException("Erro ao gerar PDF: " + e.getMessage(), e);
        }
    }

}