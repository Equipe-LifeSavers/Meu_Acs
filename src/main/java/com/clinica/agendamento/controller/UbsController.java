package com.clinica.agendamento.controller;

import com.clinica.agendamento.dto.UbsRequest;
import com.clinica.agendamento.model.Ubs;
import com.clinica.agendamento.repository.UbsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/ubs")
@RequiredArgsConstructor
public class UbsController {

    private final UbsRepository ubsRepository;

    @PreAuthorize("hasAnyRole('ADMIN')")
    @PostMapping
    public ResponseEntity<Ubs> criar(@RequestBody UbsRequest request) {
        Ubs ubs = new Ubs();
        ubs.setNome(request.getNome());
        ubs.setEndereco(request.getEndereco());
        ubs.setTelefone(request.getTelefone());
        ubs.setEmail(request.getEmail());
        return ResponseEntity.ok(ubsRepository.save(ubs));
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping
    public ResponseEntity<List<Ubs>> listarTodos() {
        return ResponseEntity.ok(ubsRepository.findAll());
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping("/{id}")
    public ResponseEntity<Ubs> buscarPorId(@PathVariable Long id) {
        return ubsRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        if (ubsRepository.existsById(id)) {
            ubsRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}
