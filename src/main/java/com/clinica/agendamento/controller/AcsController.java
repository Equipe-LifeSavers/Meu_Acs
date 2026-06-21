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
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/acs")
@RequiredArgsConstructor
public class AcsController {
    
    private final AcsRepository acsRepository;
    private final RegiaoRepository regiaoRepository;
    private final UsuarioRepository usuarioRepository;

    @PostMapping
    public ResponseEntity<Acs> criar(@RequestBody Acs request) {
        Regiao regiao = regiaoRepository.findById(request.regiaoId())
                .orElseThrow(() -> new RuntimeException("Região não encontrada"));

        Usuario usuario = usuarioRepository.findById(request.usuarioId())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        Acs acs = new Acs();
        acs.setNome(request.nome());
        acs.setRegiao(regiao);
        acs.setUsuario(usuario);

        return ResponseEntity.ok(acsRepository.save(acs));
    }

    @GetMapping
    public ResponseEntity<List<Acs>> listarTodos() {
        return ResponseEntity.ok(acsRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Acs> buscarPorId(@PathVariable Long id) {
        return acsRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        if (acsRepository.existsById(id)) {
            acsRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}
