package com.app.eventhallmanager.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Pageable;

import com.app.eventhallmanager.models.Utilisateur;
import com.app.eventhallmanager.repositories.UtilisateurRepository;
import com.app.eventhallmanager.util.PasswordUtil;

@Service
public class UtilisateurService {

    @Autowired
    private UtilisateurRepository utilisateurRepo;

    // =========================
    // INSCRIPTION
    // =========================
    public Utilisateur register(Utilisateur utilisateur) {

        // Hash du mot de passe
        utilisateur.setPassword(PasswordUtil.hash(utilisateur.getPassword()));

        // Rôle par défaut
        if (utilisateur.getRole() == null || utilisateur.getRole().isEmpty()) {
            utilisateur.setRole("USER");
        }

        return utilisateurRepo.save(utilisateur);
    }

    // =========================
    // AUTHENTIFICATION (LOGIN)
    // =========================
    public Optional<Utilisateur> authenticate(String email, String password) {

        Optional<Utilisateur> utilisateurOpt = utilisateurRepo.findByEmail(email);

        if (utilisateurOpt.isPresent()) {
            Utilisateur utilisateur = utilisateurOpt.get();
            // Vérifie le mot de passe
            if (PasswordUtil.verify(password, utilisateur.getPassword())) {
                return Optional.of(utilisateur);
            }
        }

        return Optional.empty();
    }
    
    public Optional<Utilisateur> getByEmail(String email) {
        return utilisateurRepo.findByEmail(email);
    }

    // =========================
    // SAUVEGARDE SIMPLE
    // =========================
    public Utilisateur save(Utilisateur utilisateur) {
        return utilisateurRepo.save(utilisateur);
    }

    // =========================
    // LISTE DES UTILISATEURS
    // =========================
    public List<Utilisateur> getAll() {
        return utilisateurRepo.findAll();
    }
    
 // =============================================
    // LISTE DES UTILISATEURS AVEC LE ROLE "USER"
    // ==========================================
    public List<Utilisateur> findAllUsers() {
        return utilisateurRepo.findByRole("USER");
    }

    
    public boolean emailExists(String email) {
        return utilisateurRepo.existsByEmail(email);
    }
    
    public Utilisateur update(Utilisateur utilisateur) {
    	
        return utilisateurRepo.save(utilisateur);
        
    }
    
    public Utilisateur findById(Long id) {
        return utilisateurRepo.findById(id)
                .orElse(null);
    }
    
    public void delete(Long id) {
        utilisateurRepo.deleteById(id);
    }
    
    public Page<Utilisateur> findUsersPaginated(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return utilisateurRepo.findByRole("USER", pageable);
    }
    
    public Page<Utilisateur> searchUsersByEmail(String email, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return utilisateurRepo
                .findByRoleAndEmailContainingIgnoreCase("USER", email, pageable);
    }



    // =========================
    // STATISTIQUES
    // =========================
    public long count() {
        return utilisateurRepo.count();
    }
    
    public long countUsers() {
        return utilisateurRepo.countByRole("USER");
    }
}
