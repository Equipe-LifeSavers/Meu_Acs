package com.clinica.agendamento.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
public class UbsRequest {

        @NotBlank 
        private String nome;
        @NotBlank 
        private String endereco;
        @NotBlank 
        private String telefone;
        @NotBlank 
        private String email;

}
