package com.clinica.agendamento.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AcsRequest {
    
        @NotBlank 
        private String nome;

        @NotBlank 
        private String telefone;

        @NotBlank 
        private String microarea;

        @NotNull 
        private Long regiaoId;

        @NotNull 
        private Long usuarioId;
}
