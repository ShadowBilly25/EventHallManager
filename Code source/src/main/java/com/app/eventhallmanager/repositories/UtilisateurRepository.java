package com.app.eventhallmanager.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.app.eventhallmanager.models.Utilisateur;

public interface UtilisateurRepository extends JpaRepository<Utilisateur, Long> {

    // Spring Data JPA va générer automatiquement la requête
    Optional<Utilisateur> findByEmail(String email);
    
    long countByRole(String role);
    
    List<Utilisateur> findByRole(String role);
    
    boolean existsByEmail(String email);
    
    Page<Utilisateur> findByRole(String role, Pageable pageable);
    
    Page<Utilisateur> findByRoleAndEmailContainingIgnoreCase(
            String role,
            String email,
            Pageable pageable
    );

}
