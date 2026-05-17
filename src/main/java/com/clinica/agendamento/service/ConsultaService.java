package com.clinica.agendamento.service;

import com.clinica.agendamento.dto.AgendamentoRequest;
import com.clinica.agendamento.enums.StatusConsulta;
import com.clinica.agendamento.model.Consulta;
import com.clinica.agendamento.model.HorarioDisponivel;
import com.clinica.agendamento.model.Paciente;
import com.clinica.agendamento.repository.ConsultaRepository;
import com.clinica.agendamento.repository.HorarioDisponivelRepository;
import com.clinica.agendamento.repository.PacienteRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ConsultaService {

    private final ConsultaRepository consultaRepository;
    private final PacienteRepository pacienteRepository;
    private final HorarioDisponivelRepository horarioRepository;

    public ConsultaService(ConsultaRepository consultaRepository,
            PacienteRepository pacienteRepository,
            HorarioDisponivelRepository horarioRepository) {
        this.consultaRepository = consultaRepository;
        this.pacienteRepository = pacienteRepository;
        this.horarioRepository = horarioRepository;
    }

    @Transactional
    public Consulta agendar(AgendamentoRequest request) {
        Paciente paciente = pacienteRepository.findById(request.getPacienteId())
                .orElseThrow(() -> new RuntimeException("Paciente não encontrado"));

        HorarioDisponivel horario = horarioRepository.findById(request.getHorarioId())
                .orElseThrow(() -> new RuntimeException("Horário não encontrado"));

        if (!Boolean.TRUE.equals(horario.getDisponivel())) {
            throw new RuntimeException("Horário já está ocupado");
        }

        Consulta consulta = new Consulta();
        consulta.setPaciente(paciente);
        consulta.setMedico(horario.getMedico());
        consulta.setHorarioDisponivel(horario);
        consulta.setData(horario.getData());
        consulta.setHora(horario.getHora());
        consulta.setStatus(StatusConsulta.AGENDADA);

        horario.setDisponivel(false);
        horarioRepository.save(horario);

        return consultaRepository.save(consulta);
    }

    @Transactional
    public Consulta cancelar(Long consultaId) {
        Consulta consulta = consultaRepository.findById(consultaId)
                .orElseThrow(() -> new RuntimeException("Consulta não encontrada"));

        if (consulta.getStatus() == StatusConsulta.CANCELADA) {
            throw new RuntimeException("Consulta já está cancelada");
        }

        consulta.setStatus(StatusConsulta.CANCELADA);

        HorarioDisponivel horario = consulta.getHorarioDisponivel();
        horario.setDisponivel(true);
        horarioRepository.save(horario);

        return consultaRepository.save(consulta);
    }

}