package com.app.eventhallmanager.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.eventhallmanager.models.Utilisateur;
import com.app.eventhallmanager.repositories.UtilisateurRepository;
import com.app.eventhallmanager.util.PasswordUtil;

@Service
public class AuthService {

    @Autowired
    private UtilisateurRepository repository;

    public Utilisateur authenticate(String email, String password) {
        return repository.findByEmail(email)
                .filter(u -> PasswordUtil.verify(password, u.getPassword()))
                .orElse(null);
    }

    public void register(Utilisateur utilisateur) {
        utilisateur.setPassword(PasswordUtil.hash(utilisateur.getPassword()));
        utilisateur.setRole("USER");
        repository.save(utilisateur);
    }
}
