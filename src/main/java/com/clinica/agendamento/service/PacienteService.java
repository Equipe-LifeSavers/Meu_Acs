package com.clinica.agendamento.service;

import com.clinica.agendamento.model.Paciente;
import com.clinica.agendamento.repository.PacienteRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PacienteService {

    private final PacienteRepository repository;

    public PacienteService(PacienteRepository repository) {
        this.repository = repository;
    }

    public Paciente salvar(Paciente paciente) {
        return repository.save(paciente);
    }

    public List<Paciente> listar() {
        return repository.findAll();
    }

    public Paciente buscarPorId(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Paciente não encontrado"));
    }

    public Paciente atualizar(Long id, Paciente dados) {
        Paciente paciente = buscarPorId(id);

        paciente.setNome(dados.getNome());
        paciente.setCpf(dados.getCpf());
        paciente.setTelefone(dados.getTelefone());
        paciente.setEmail(dados.getEmail());

        return repository.save(paciente);
    }

    public void deletar(Long id) {
        Paciente paciente = buscarPorId(id);
        repository.delete(paciente);
    }
}