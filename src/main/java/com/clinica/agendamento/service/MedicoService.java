package com.clinica.agendamento.service;

import com.clinica.agendamento.model.Medico;
import com.clinica.agendamento.repository.MedicoRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MedicoService {

    private final MedicoRepository repository;

    public MedicoService(MedicoRepository repository) {
        this.repository = repository;
    }

    public Medico salvar(Medico medico) {
        return repository.save(medico);
    }

    public List<Medico> listar() {
        return repository.findAll();
    }

    public Medico buscarPorId(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Médico não encontrado"));
    }

    public Medico atualizar(Long id, Medico dados) {
        Medico medico = buscarPorId(id);

        medico.setNome(dados.getNome());
        medico.setCrm(dados.getCrm());
        medico.setEspecialidade(dados.getEspecialidade());
        medico.setTelefone(dados.getTelefone());

        return repository.save(medico);
    }

    public void deletar(Long id) {
        Medico medico = buscarPorId(id);
        repository.delete(medico);
    }
}