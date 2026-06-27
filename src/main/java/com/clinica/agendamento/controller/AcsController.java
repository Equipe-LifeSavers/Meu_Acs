package com.clinica.agendamento.controller;

import com.clinica.agendamento.dto.AcsRequest;
import com.clinica.agendamento.model.Acs;
import com.clinica.agendamento.model.Regiao;
import com.clinica.agendamento.model.Usuario;
import com.clinica.agendamento.repository.AcsRepository;
import com.clinica.agendamento.repository.RegiaoRepository;
import com.clinica.agendamento.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/acs")
@RequiredArgsConstructor
public class AcsController {

    private final AcsRepository acsRepository;
    private final RegiaoRepository regiaoRepository;
    private final UsuarioRepository usuarioRepository;

    @PreAuthorize("hasAnyRole('ADMIN')")
    @PostMapping
    public ResponseEntity<Acs> criar(@RequestBody AcsRequest request) {
        Regiao regiao = regiaoRepository.findById(request.getRegiaoId())
                .orElseThrow(() -> new RuntimeException("Região não encontrada"));

        Usuario usuario = usuarioRepository.findById(request.getUsuarioId())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        Acs acs = new Acs();
        acs.setNome(request.getNome());
        acs.setTelefone(request.getTelefone());
        acs.setMicroarea(request.getMicroarea());
        acs.setRegiao(regiao);
        acs.setUsuario(usuario);

        return ResponseEntity.ok(acsRepository.save(acs));
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping
    public ResponseEntity<List<Acs>> listarTodos() {
        return ResponseEntity.ok(acsRepository.findAll());
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @GetMapping("/{id}")
    public ResponseEntity<Acs> buscarPorId(@PathVariable Long id) {
        return acsRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        if (acsRepository.existsById(id)) {
            acsRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'UBS')")
    @PutMapping("/{acsId}/regiao/{regiaoId}")
    public ResponseEntity<Acs> associarRegiao(
            @PathVariable Long acsId,
            @PathVariable Long regiaoId) {

        Acs acs = acsRepository.findById(acsId)
                .orElseThrow(() -> new RuntimeException("ACS não encontrado"));

        Regiao regiao = regiaoRepository.findById(regiaoId)
                .orElseThrow(() -> new RuntimeException("Região não encontrada"));

        acs.setRegiao(regiao);

        return ResponseEntity.ok(acsRepository.save(acs));
    }

}
