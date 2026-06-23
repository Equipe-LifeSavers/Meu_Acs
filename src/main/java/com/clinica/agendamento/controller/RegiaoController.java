package com.clinica.agendamento.controller;

import com.clinica.agendamento.dto.RegiaoRequest;
import com.clinica.agendamento.model.Regiao;
import com.clinica.agendamento.model.Ubs;
import com.clinica.agendamento.repository.RegiaoRepository;
import com.clinica.agendamento.repository.UbsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/regioes")
@RequiredArgsConstructor
public class RegiaoController {

    private final RegiaoRepository regiaoRepository;
    private final UbsRepository ubsRepository;

    @PostMapping
    public ResponseEntity<Regiao> criar(@RequestBody RegiaoRequest request) {

        Ubs ubs = ubsRepository.findById(request.ubsId())
                .orElseThrow(() -> new RuntimeException("UBS não encontrada"));

        Regiao regiao = new Regiao();
        regiao.setNomeArea(request.nomeArea());
        regiao.setUbs(ubs);

        return ResponseEntity.ok(regiaoRepository.save(regiao));
    }

    @GetMapping
    public ResponseEntity<List<Regiao>> listarTodos() {
        return ResponseEntity.ok(regiaoRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Regiao> buscarPorId(@PathVariable Long id) {
        return regiaoRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        if (regiaoRepository.existsById(id)) {
            regiaoRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.notFound().build();
    }

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