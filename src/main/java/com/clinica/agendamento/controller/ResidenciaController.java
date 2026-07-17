package com.clinica.agendamento.controller;

import com.clinica.agendamento.dto.ResidenciaRequest;
import com.clinica.agendamento.model.Regiao;
import com.clinica.agendamento.model.Residencia;
import com.clinica.agendamento.repository.RegiaoRepository;
import com.clinica.agendamento.repository.ResidenciaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

import java.util.List;

@RestController
@RequestMapping("/residencias")
@RequiredArgsConstructor
public class ResidenciaController {

    private final ResidenciaRepository residenciaRepository;
    private final RegiaoRepository regiaoRepository;

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS', 'ACS')")
    @PostMapping
    public ResponseEntity<Residencia> criar(@Valid @RequestBody ResidenciaRequest dto) {

        Regiao regiao = regiaoRepository.findById(dto.regiaoId())
                .orElseThrow(() -> new RuntimeException("Região não encontrada"));

        Residencia residencia = new Residencia();
        residencia.setEndereco(dto.endereco());
        residencia.setRegiao(regiao);

        residencia = residenciaRepository.save(residencia);

        return ResponseEntity.status(HttpStatus.CREATED).body(residencia);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS', 'ACS')")
    @GetMapping
    public ResponseEntity<List<Residencia>> listarTodos() {
        return ResponseEntity.ok(residenciaRepository.findAll());
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS', 'ACS')")
    @GetMapping("/{id}")
    public ResponseEntity<Residencia> buscarPorId(@PathVariable Long id) {
        return residenciaRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS', 'ACS')")
    @PutMapping("/{id}")
    public ResponseEntity<Residencia> atualizar(
            @PathVariable Long id,
            @Valid @RequestBody ResidenciaRequest dto) {

        return residenciaRepository.findById(id)
                .map(residencia -> {

                    Regiao regiao = regiaoRepository.findById(dto.regiaoId())
                            .orElseThrow(() -> new RuntimeException("Região não encontrada"));

                    residencia.setEndereco(dto.endereco());
                    residencia.setRegiao(regiao);

                    return ResponseEntity.ok(residenciaRepository.save(residencia));

                }).orElse(ResponseEntity.notFound().build());
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        if (residenciaRepository.existsById(id)) {
            residenciaRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS', 'ACS')")
    @GetMapping("/regiao/{regiaoId}")
    public ResponseEntity<List<Residencia>> listarPorRegiao(@PathVariable Long regiaoId) {
        return ResponseEntity.ok(residenciaRepository.findByRegiaoId(regiaoId));
    }

}
