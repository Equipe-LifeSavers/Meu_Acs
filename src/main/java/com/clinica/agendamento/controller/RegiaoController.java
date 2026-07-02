package com.clinica.agendamento.controller;

import com.clinica.agendamento.dto.RegiaoRequest;
import com.clinica.agendamento.model.Regiao;
import com.clinica.agendamento.model.Ubs;
import com.clinica.agendamento.repository.RegiaoRepository;
import com.clinica.agendamento.repository.UbsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/regioes")
@RequiredArgsConstructor
public class RegiaoController {

    private final RegiaoRepository regiaoRepository;
    private final UbsRepository ubsRepository;

    @PreAuthorize("hasAnyRole('ADMIN')")
    @PostMapping
    public ResponseEntity<Regiao> criar(@RequestBody RegiaoRequest request) {

        Ubs ubs = ubsRepository.findById(request.ubsId())
                .orElseThrow(() -> new RuntimeException("UBS não encontrada"));

        Regiao regiao = new Regiao();
        regiao.setNomeArea(request.nomeArea());
        regiao.setObservacao(request.observacao());
        regiao.setUbs(ubs);

        return ResponseEntity.ok(regiaoRepository.save(regiao));
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping
    public ResponseEntity<List<Regiao>> listarTodos() {
        return ResponseEntity.ok(regiaoRepository.findAll());
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping("/{id}")
    public ResponseEntity<Regiao> buscarPorId(@PathVariable Long id) {
        return regiaoRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        if (regiaoRepository.existsById(id)) {
            regiaoRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.notFound().build();
    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @PutMapping("/{regiaoId}/ubs/{ubsId}")
    public ResponseEntity<Regiao> associarUbs(
            @PathVariable Long regiaoId,
            @PathVariable Long ubsId) {

        Regiao regiao = regiaoRepository.findById(regiaoId)
                .orElseThrow(() -> new RuntimeException("Região não encontrada"));

        Ubs ubs = ubsRepository.findById(ubsId)
                .orElseThrow(() -> new RuntimeException("UBS não encontrada"));

        regiao.setUbs(ubs);

        return ResponseEntity.ok(regiaoRepository.save(regiao));
    }
}