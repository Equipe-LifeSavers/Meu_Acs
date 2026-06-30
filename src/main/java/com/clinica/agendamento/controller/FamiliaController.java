package com.clinica.agendamento.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.clinica.agendamento.dto.FamiliaRequest;
import com.clinica.agendamento.model.Familia;
import com.clinica.agendamento.model.Morador;
import com.clinica.agendamento.model.Residencia;
import com.clinica.agendamento.repository.FamiliaRepository;
import com.clinica.agendamento.repository.MoradorRepository;
import com.clinica.agendamento.repository.ResidenciaRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/familias")
@RequiredArgsConstructor
public class FamiliaController {

    private final FamiliaRepository familiaRepository;
    private final ResidenciaRepository residenciaRepository;
    private final MoradorRepository moradorRepository;

    @PreAuthorize("hasAnyRole('ADMIN','UBS', 'ACS')")
    @PostMapping
    public ResponseEntity<Familia> criar(@RequestBody FamiliaRequest dto) {

        Residencia residencia = residenciaRepository.findById(dto.residenciaId())
                .orElseThrow(() -> new RuntimeException("Residência não encontrada"));

        Morador responsavel = moradorRepository.findById(dto.responsavelId())
                .orElseThrow(() -> new RuntimeException("Morador não encontrado"));

        Familia familia = new Familia();

        familia.setResidencia(residencia);
        familia.setResponsavel(responsavel);

        familia = familiaRepository.save(familia);

        return ResponseEntity.status(HttpStatus.CREATED).body(familia);
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @GetMapping
    public List<Familia> listar() {
        return familiaRepository.findAll();
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @GetMapping("/{id}")
    public ResponseEntity<Familia> buscar(@PathVariable Long id) {

        return familiaRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS', 'ACS')")
    @PutMapping("/{id}")
    public ResponseEntity<Familia> atualizar(
            @PathVariable Long id,
            @RequestBody FamiliaRequest dto) {

        return familiaRepository.findById(id)
                .map(familia -> {

                    Residencia residencia = residenciaRepository.findById(dto.residenciaId())
                            .orElseThrow(() -> new RuntimeException("Residência não encontrada"));

                    Morador responsavel = moradorRepository.findById(dto.responsavelId())
                            .orElseThrow(() -> new RuntimeException("Morador não encontrado"));

                    familia.setResidencia(residencia);
                    familia.setResponsavel(responsavel);

                    return ResponseEntity.ok(familiaRepository.save(familia));

                }).orElse(ResponseEntity.notFound().build());
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS', 'ACS')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable Long id) {

        if (!familiaRepository.existsById(id))
            return ResponseEntity.notFound().build();

        familiaRepository.deleteById(id);

        return ResponseEntity.noContent().build();
    }

}