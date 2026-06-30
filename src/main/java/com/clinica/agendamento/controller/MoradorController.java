package com.clinica.agendamento.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import com.clinica.agendamento.dto.MoradorRequest;
import com.clinica.agendamento.dto.MoradorResponse;
import com.clinica.agendamento.model.Familia;
import com.clinica.agendamento.model.Morador;
import com.clinica.agendamento.repository.FamiliaRepository;
import com.clinica.agendamento.repository.MoradorRepository;

import lombok.RequiredArgsConstructor;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/moradores")
@RequiredArgsConstructor
public class MoradorController {

    private final MoradorRepository moradorRepository;
    private final FamiliaRepository familiaRepository;

    private String getUsuarioLogado() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        return (auth != null && auth.isAuthenticated())
                ? auth.getName()
                : "desconhecido";
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @PostMapping
    public ResponseEntity<MoradorResponse> criar(@Valid @RequestBody MoradorRequest dto) {

        if (moradorRepository.existsByCpf(dto.cpf())) {
            throw new IllegalArgumentException("CPF já cadastrado.");
        }

        Familia familia = familiaRepository.findById(dto.familiaId())
                .orElseThrow(() -> new IllegalArgumentException("Família não encontrada"));

        Morador morador = new Morador();

        morador.setNome(dto.nome());
        morador.setCpf(dto.cpf());
        morador.setDataNascimento(dto.dataNascimento());
        morador.setSexo(dto.sexo());
        morador.setTelefone(dto.telefone());
        morador.setFamilia(familia);
        morador.setUltimaAtualizacao(LocalDateTime.now());
        morador.setAtualizadoPor(getUsuarioLogado());

        morador = moradorRepository.save(morador);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(toResponse(morador));
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @GetMapping
    public List<MoradorResponse> listar() {
        return moradorRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @GetMapping("/{id}")
    public ResponseEntity<MoradorResponse> buscar(@PathVariable Long id) {
        return moradorRepository.findById(id)
                .map(this::toResponse)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @PutMapping("/{id}")
    public ResponseEntity<MoradorResponse> atualizar(
            @PathVariable Long id,
            @Valid @RequestBody MoradorRequest dto) {

        return moradorRepository.findById(id)
                .map(morador -> {

                    Morador existente = moradorRepository.findByCpf(dto.cpf()).orElse(null);

                    if (existente != null && !existente.getId().equals(id)) {
                        throw new IllegalArgumentException("CPF já cadastrado.");
                    }

                    Familia familia = familiaRepository.findById(dto.familiaId())
                            .orElseThrow(() -> new IllegalArgumentException("Família não encontrada"));

                    morador.setNome(dto.nome());
                    morador.setCpf(dto.cpf());
                    morador.setDataNascimento(dto.dataNascimento());
                    morador.setSexo(dto.sexo());
                    morador.setTelefone(dto.telefone());
                    morador.setFamilia(familia);
                    morador.setUltimaAtualizacao(LocalDateTime.now());
                    morador.setAtualizadoPor(getUsuarioLogado());

                    Morador atualizado = moradorRepository.save(morador);

                    return ResponseEntity.ok(toResponse(atualizado));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable Long id) {

        if (!moradorRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }

        moradorRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @PreAuthorize("hasAnyRole('ADMIN','UBS','ACS')")
    @GetMapping("/familia/{familiaId}")
    public List<MoradorResponse> listarPorFamilia(@PathVariable Long familiaId) {
        return moradorRepository.findByFamiliaId(familiaId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    private MoradorResponse toResponse(Morador morador) {
        return new MoradorResponse(
                morador.getId(),
                morador.getNome(),
                morador.getCpf(),
                morador.getDataNascimento(),
                morador.getSexo(),
                morador.getTelefone(),
                morador.getFamilia().getId(),
                morador.getUltimaAtualizacao(),
                morador.getAtualizadoPor());
    }
}