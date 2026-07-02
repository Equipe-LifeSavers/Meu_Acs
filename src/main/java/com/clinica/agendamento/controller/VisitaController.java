package com.clinica.agendamento.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.clinica.agendamento.dto.VisitaRequest;
import com.clinica.agendamento.dto.VisitaResponse;
import com.clinica.agendamento.model.Acs;
import com.clinica.agendamento.model.Morador;
import com.clinica.agendamento.model.Visita;
import com.clinica.agendamento.repository.AcsRepository;
import com.clinica.agendamento.repository.MoradorRepository;
import com.clinica.agendamento.repository.VisitaRepository;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/visitas")
@RequiredArgsConstructor
public class VisitaController {

    private final VisitaRepository visitaRepository;
    private final MoradorRepository moradorRepository;
    private final AcsRepository acsRepository;

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @PostMapping
    public ResponseEntity<VisitaResponse> criar(
            @Valid @RequestBody VisitaRequest dto) {

        Morador morador = moradorRepository.findById(dto.moradorId())
                .orElseThrow(() -> new RuntimeException("Morador não encontrado"));

        Acs acs = acsRepository.findById(dto.acsId())
                .orElseThrow(() -> new RuntimeException("ACS não encontrado"));

        Visita visita = new Visita();

        visita.setMorador(morador);
        visita.setAcs(acs);
        visita.setData(dto.data());
        visita.setObservacoes(dto.observacoes());
        visita.setVisitaRealizada(dto.visitaRealizada());
        visita.setDataCadastro(LocalDateTime.now());
        visita.setUltimaAtualizacao(LocalDateTime.now());

        visita = visitaRepository.save(visita);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(toResponse(visita));
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @GetMapping
    public List<VisitaResponse> listar() {

        return visitaRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @GetMapping("/{id}")
    public ResponseEntity<VisitaResponse> buscar(
            @PathVariable Long id) {

        return visitaRepository.findById(id)
                .map(this::toResponse)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());

    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @PutMapping("/{id}")
    public ResponseEntity<VisitaResponse> atualizar(
            @PathVariable Long id,
            @Valid @RequestBody VisitaRequest dto) {

        return visitaRepository.findById(id)
                .map(visita -> {

                    Morador morador = moradorRepository.findById(dto.moradorId())
                            .orElseThrow(() -> new RuntimeException("Morador não encontrado"));

                    Acs acs = acsRepository.findById(dto.acsId())
                            .orElseThrow(() -> new RuntimeException("ACS não encontrado"));

                    visita.setMorador(morador);
                    visita.setAcs(acs);
                    visita.setData(dto.data());
                    visita.setObservacoes(dto.observacoes());
                    visita.setVisitaRealizada(dto.visitaRealizada());
                    visita.setUltimaAtualizacao(LocalDateTime.now());

                    return ResponseEntity.ok(
                            toResponse(
                                    visitaRepository.save(visita)));

                }).orElse(ResponseEntity.notFound().build());

    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(
            @PathVariable Long id) {

        if (!visitaRepository.existsById(id)) {

            return ResponseEntity.notFound().build();

        }

        visitaRepository.deleteById(id);

        return ResponseEntity.noContent().build();

    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @GetMapping("/morador/{id}")
    public List<VisitaResponse> historicoMorador(
            @PathVariable Long id) {

        return visitaRepository.findByMoradorId(id)
                .stream()
                .map(this::toResponse)
                .toList();

    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @GetMapping("/acs/{id}")
    public List<VisitaResponse> listarPorAcs(
            @PathVariable Long id) {

        return visitaRepository.findByAcsId(id)
                .stream()
                .map(this::toResponse)
                .toList();

    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @GetMapping("/familia/{id}")
    public List<VisitaResponse> listarPorFamilia(
            @PathVariable Long id) {

        return visitaRepository.findByMoradorFamiliaId(id)
                .stream()
                .map(this::toResponse)
                .toList();

    }

    private VisitaResponse toResponse(Visita visita) {

        return new VisitaResponse(

                visita.getId(),

                visita.getMorador().getId(),

                visita.getMorador().getNome(),

                visita.getMorador().getFamilia().getId(),

                visita.getAcs().getId(),

                visita.getAcs().getNome(),

                visita.getData(),

                visita.getObservacoes(),

                visita.getVisitaRealizada(),

                visita.getDataCadastro(),

                visita.getUltimaAtualizacao());

    }

}