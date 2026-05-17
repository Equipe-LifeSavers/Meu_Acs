package com.clinica.agendamento.controller;

import com.clinica.agendamento.dto.AgendamentoRequest;
import com.clinica.agendamento.model.Consulta;
import com.clinica.agendamento.service.ConsultaService;
import org.springframework.web.bind.annotation.*;

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
}