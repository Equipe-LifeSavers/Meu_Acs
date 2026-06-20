package com.clinica.agendamento.controller;

import com.clinica.agendamento.dto.UbsRequest;
import com.clinica.agendamento.model.Ubs;
import com.clinica.agendamento.repository.UbsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/ubs")
@RequiredArgsConstructor
public class UbsController {
    
    private final UbsRepository ubsRepository;

    @PostMapping
    public ResponseEntity<Ubs> criar(@RequestBody UbsRequest request){
        Ubs ubs = new Ubs();
        ubs.setNome(request.nome());
        return ResponseEntity.ok(ubsRepository.save(ubs));
    }

    @GetMapping
    public ResponseEntity<List<Ubs>> listarTodos() {
        return ResponseEntity.ok(ubsRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Ubs> buscarPorId(@PathVariable Long id) {
        return ubsRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        if (ubsRepository.existsById(id)) {
            ubsRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}
