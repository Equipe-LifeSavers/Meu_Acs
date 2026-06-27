package com.clinica.agendamento.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
public class ResidenciaRequest {

    @NotBlank 
    private String endereco;

    @NotNull 
    private Long regiaoId;
}