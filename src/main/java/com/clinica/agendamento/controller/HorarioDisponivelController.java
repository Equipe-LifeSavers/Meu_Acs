package com.clinica.agendamento.controller;

import com.clinica.agendamento.dto.HorarioRequest;
import com.clinica.agendamento.model.HorarioDisponivel;
import com.clinica.agendamento.service.HorarioDisponivelService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/horarios")
public class HorarioDisponivelController {

    private final HorarioDisponivelService service;

    public HorarioDisponivelController(HorarioDisponivelService service) {
        this.service = service;
    }

    @PostMapping
    public HorarioDisponivel cadastrar(@RequestBody HorarioRequest request) {
        return service.cadastrar(request);
    }

    @GetMapping("/disponiveis")
    public List<HorarioDisponivel> listarDisponiveis() {
        return service.listarDisponiveis();
    }

    @GetMapping("/medico/{medicoId}")
    public List<HorarioDisponivel> listarPorMedico(@PathVariable Long medicoId) {
        return service.listarPorMedico(medicoId);
    }
}