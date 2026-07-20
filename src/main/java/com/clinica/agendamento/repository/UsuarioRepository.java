package com.clinica.agendamento.repository;

import com.clinica.agendamento.enums.Perfil;
import com.clinica.agendamento.model.Usuario;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    Optional<Usuario> findByEmail(String email);

    boolean existsByEmail(String email);

    List<Usuario> findByPerfil(Perfil perfil);

    List<Usuario> findByAtivoTrue();

}