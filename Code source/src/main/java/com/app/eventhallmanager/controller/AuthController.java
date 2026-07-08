package com.app.eventhallmanager.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.app.eventhallmanager.models.Utilisateur;
import com.app.eventhallmanager.services.UtilisateurService;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class AuthController {

    @Autowired
    private UtilisateurService utilisateurService;

    // =========================
    // PAGE DE LOGIN
    // =========================
    @GetMapping("/login")
    public String loginForm(@RequestParam(required = false) String error, ModelMap model) {
        if (error != null) {
            model.addAttribute("error", "Email ou mot de passe incorrect");
        }
        return "login"; // retourne login.jsp
    }


    // =========================
    // TRAITEMENT LOGIN
    // =========================
    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        HttpSession session,
                        Model model) {

        Optional<Utilisateur> utilisateurOpt =
                utilisateurService.authenticate(username, password);

        if (utilisateurOpt.isPresent()) {

            Utilisateur utilisateur = utilisateurOpt.get();
            session.setAttribute("user", utilisateur);

            if ("ADMIN".equalsIgnoreCase(utilisateur.getRole())) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/user/dashboard";
            }
        }

        model.addAttribute("error", "Email ou mot de passe incorrect");
        return "login";
    }



    // =========================
    // PAGE D'INSCRIPTION
    // =========================
    @GetMapping("/register")
    public String registerForm(ModelMap model) {
        model.addAttribute("utilisateur", new Utilisateur());
        return "register"; // register.jsp
    }

    // =========================
    // TRAITEMENT INSCRIPTION
    // =========================
    @PostMapping("/register")
    public String register(@ModelAttribute Utilisateur utilisateur, ModelMap model) {

        // Vérifier si l'email existe déjà
        if (utilisateurService.getByEmail(utilisateur.getEmail()).isPresent()) {
            model.addAttribute("error", "Cet email est déjà utilisé");
            return "register";
        }

        // Définir le rôle par défaut si aucun n'est fourni
        if (utilisateur.getRole() == null || utilisateur.getRole().isEmpty()) {
            utilisateur.setRole("USER");
        }

        // Enregistrer l'utilisateur
        utilisateurService.register(utilisateur);

        // Redirection vers la page de connexion
        return "redirect:/login";
    }

    // =========================
    // LOGOUT
    // =========================
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
