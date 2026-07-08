package com.app.eventhallmanager.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.app.eventhallmanager.models.Utilisateur;
import com.app.eventhallmanager.repositories.UtilisateurRepository;
import com.app.eventhallmanager.util.PasswordUtil;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UtilisateurRepository repository;

    @Override
    public void run(String... args) throws Exception {

        // Vérifier si admin existe déjà
        if (repository.findByEmail("admin@gmail.com").isEmpty()) {

            Utilisateur admin = new Utilisateur();
            admin.setNom("Super");
            admin.setPrenom("Admin");
            admin.setEmail("admin@gmail.com");

            // IMPORTANT : utiliser ton PasswordUtil
            admin.setPassword(PasswordUtil.hash("admin123"));

            admin.setRole("ADMIN");

            repository.save(admin);

            System.out.println("✅ Admin par défaut créé !");
        }
    }
}
