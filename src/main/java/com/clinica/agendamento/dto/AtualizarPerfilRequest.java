package com.clinica.agendamento.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record AtualizarPerfilRequest(

    @NotBlank(message = "Nome é obrigatório")
    String nome,

    @NotBlank(message = "E-mail é obrigatório")
    @Email(message = "E-mail invalido")
    String email
    
) {

}  
    

