package com.clinica.agendamento.service;

import com.clinica.agendamento.dto.HorarioRequest;
import com.clinica.agendamento.model.HorarioDisponivel;
import com.clinica.agendamento.model.Medico;
import com.clinica.agendamento.repository.HorarioDisponivelRepository;
import com.clinica.agendamento.repository.MedicoRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HorarioDisponivelService {

    private final HorarioDisponivelRepository horarioRepository;
    private final MedicoRepository medicoRepository;

    public HorarioDisponivelService(HorarioDisponivelRepository horarioRepository,
            MedicoRepository medicoRepository) {
        this.horarioRepository = horarioRepository;
        this.medicoRepository = medicoRepository;
    }

    public HorarioDisponivel cadastrar(HorarioRequest request) {
        Medico medico = medicoRepository.findById(request.getMedicoId())
                .orElseThrow(() -> new RuntimeException("Médico não encontrado"));

        HorarioDisponivel horario = new HorarioDisponivel();
        horario.setMedico(medico);
        horario.setData(request.getData());
        horario.setHora(request.getHora());
        horario.setDisponivel(true);

        return horarioRepository.save(horario);
    }

    public List<HorarioDisponivel> listarDisponiveis() {
        return horarioRepository.findByDisponivelTrue();
    }

    public List<HorarioDisponivel> listarPorMedico(Long medicoId) {
        return horarioRepository.findByMedicoIdAndDisponivelTrue(medicoId);
    }
}