package com.clinica.agendamento.dto;

import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
public class FamiliaRequest {

    @NotNull(message = "O ID da residencia é obrigatório")
    private Long residenciaId;
    
    private Long responsavelId;
}
