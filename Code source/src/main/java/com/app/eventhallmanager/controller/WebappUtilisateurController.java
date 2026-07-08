package com.app.eventhallmanager.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.ModelMap;

import com.app.eventhallmanager.models.Utilisateur;
import com.app.eventhallmanager.services.UtilisateurService;

@Controller
@RequestMapping("/utilisateurs")
public class WebappUtilisateurController {

    @Autowired
    private UtilisateurService utilisateurService;

    // Liste de tous les utilisateurs
    @GetMapping("/liste")
    public String liste(ModelMap modelMap) {
        modelMap.addAttribute("utilisateurs", utilisateurService.getAll());
        return "utilisateurs"; // utilisateurs.jsp
    }

    // Formulaire pour ajouter un nouvel utilisateur
    @GetMapping("/nouveau")
    public String form(ModelMap modelMap) {
        modelMap.addAttribute("utilisateur", new Utilisateur());
        return "ajoututilisateur"; // ajoututilisateur.jsp
    }

    // Sauvegarde de l'utilisateur
    @PostMapping("/save")
    public String save(@ModelAttribute Utilisateur utilisateur) {
        // On peut définir un rôle USER par défaut si non défini
        if (utilisateur.getRole() == null || utilisateur.getRole().isEmpty()) {
            utilisateur.setRole("ROLE_USER");
        }
        utilisateurService.save(utilisateur);
        return "redirect:/utilisateurs/liste";
    }
}
