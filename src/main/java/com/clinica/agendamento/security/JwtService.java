package com.clinica.agendamento.security;

import java.util.Date;

import org.springframework.stereotype.Service;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;

@Service
public class JwtService {

        private static final String SECRET = "MeuACS2026JwtSecretKeyMuitoSegura123456789";

        public String generateToken(String email) {

                return Jwts.builder()
                                .setSubject(email)
                                .setIssuedAt(new Date())
                                .setExpiration(
                                                new Date(
                                                                System.currentTimeMillis()
                                                                                + 86400000))
                                .signWith(
                                                Keys.hmacShaKeyFor(
                                                                SECRET.getBytes()),
                                                SignatureAlgorithm.HS256)
                                .compact();
        }

        public String extractUsername(String token) {

                return Jwts.parserBuilder()
                                .setSigningKey(
                                                Keys.hmacShaKeyFor(
                                                                SECRET.getBytes()))
                                .build()
                                .parseClaimsJws(token)
                                .getBody()
                                .getSubject();
        }

        public boolean isTokenValid(String token) {

                try {

                        Jwts.parserBuilder()
                                        .setSigningKey(
                                                        Keys.hmacShaKeyFor(
                                                                        SECRET.getBytes()))
                                        .build()
                                        .parseClaimsJws(token);

                        return true;

                } catch (Exception e) {

                        return false;
                }
        }
}