package com.clinica.agendamento.controller;

import com.clinica.agendamento.dto.AgendamentoRequest;
import com.clinica.agendamento.model.Consulta;
import com.clinica.agendamento.service.ConsultaService;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/consultas")
public class ConsultaController {

    private final ConsultaService service;

    public ConsultaController(ConsultaService service) {
        this.service = service;
    }

    @PostMapping("/agendar")
    public Consulta agendar(@RequestBody AgendamentoRequest request) {
        return service.agendar(request);
    }

    @PutMapping("/{id}/cancelar")
    public Consulta cancelar(@PathVariable Long id) {
        return service.cancelar(id);
    }

    @GetMapping("/paciente/{pacienteId}")
    public List<Consulta> listarPorPaciente(@PathVariable Long pacienteId) {
        return service.listarPorPaciente(pacienteId);
    }

    @GetMapping("/medico/{medicoId}")
    public List<Consulta> listarPorMedico(@PathVariable Long medicoId) {
        return service.listarPorMedico(medicoId);
    }

}