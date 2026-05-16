package com.clinica.agendamento.repository;

import com.clinica.agendamento.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
}