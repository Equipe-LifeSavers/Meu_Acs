package com.clinica.agendamento.dto;

import com.clinica.agendamento.enums.Perfil;
import lombok.*;

@Getter
@Setter
public class UsuarioRequest {
        private String nome;

        private String email;

        private String senha;

        private Perfil perfil;
}