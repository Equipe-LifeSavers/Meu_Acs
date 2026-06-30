package com.clinica.agendamento.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.clinica.agendamento.dto.MoradorRequest;
import com.clinica.agendamento.dto.MoradorResponse;
import com.clinica.agendamento.model.Familia;
import com.clinica.agendamento.model.Morador;
import com.clinica.agendamento.repository.FamiliaRepository;
import com.clinica.agendamento.repository.MoradorRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/moradores")
@RequiredArgsConstructor
public class MoradorController {

    private final MoradorRepository moradorRepository;
    private final FamiliaRepository familiaRepository;

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS', 'ACS')")
    @PostMapping
    public ResponseEntity<MoradorResponse> criar(@RequestBody MoradorRequest dto) {

        Familia familia = familiaRepository.findById(dto.familiaId())
                .orElseThrow(() -> new RuntimeException("Família não encontrada"));

        Morador morador = new Morador();

        morador.setNome(dto.nome());
        morador.setCpf(dto.cpf());
        morador.setDataNascimento(dto.dataNascimento());
        morador.setSexo(dto.sexo());
        morador.setTelefone(dto.telefone());
        morador.setFamilia(familia);

        morador = moradorRepository.save(morador);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(new MoradorResponse(
                        morador.getId(),
                        morador.getNome(),
                        morador.getCpf(),
                        morador.getDataNascimento(),
                        morador.getSexo(),
                        morador.getTelefone()));
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @GetMapping
    public List<Morador> listar() {
        return moradorRepository.findAll();
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @GetMapping("/{id}")
    public ResponseEntity<Morador> buscar(@PathVariable Long id) {

        return moradorRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS', 'ACS')")
    @PutMapping("/{id}")
    public ResponseEntity<Morador> atualizar(
            @PathVariable Long id,
            @RequestBody MoradorRequest dto) {

        return moradorRepository.findById(id)
                .map(morador -> {

                    Familia familia = familiaRepository.findById(dto.familiaId())
                            .orElseThrow(() -> new RuntimeException("Família não encontrada"));

                    morador.setNome(dto.nome());
                    morador.setCpf(dto.cpf());
                    morador.setDataNascimento(dto.dataNascimento());
                    morador.setSexo(dto.sexo());
                    morador.setTelefone(dto.telefone());
                    morador.setFamilia(familia);

                    return ResponseEntity.ok(moradorRepository.save(morador));

                }).orElse(ResponseEntity.notFound().build());
    }

    @PreAuthorize("hasRole('ADMIN', 'UBS', 'ACS')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable Long id) {

        if (!moradorRepository.existsById(id))
            return ResponseEntity.notFound().build();

        moradorRepository.deleteById(id);

        return ResponseEntity.noContent().build();
    }

}