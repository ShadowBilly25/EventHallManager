package com.app.eventhallmanager.controller;

import com.app.eventhallmanager.models.Utilisateur;
import com.app.eventhallmanager.services.UtilisateurService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin")
public class ProfileAdminController {

    @Autowired
    private UtilisateurService utilisateurService;

    // ===============================
    // PAGE PROFIL ADMIN
    // ===============================
    @GetMapping("/profile")
    public String profile(HttpSession session, ModelMap model) {

        Utilisateur user = (Utilisateur) session.getAttribute("user");

        // Vérification connexion + rôle ADMIN
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            return "redirect:/login";
        }

        model.addAttribute("utilisateur", user);
        return "admin/profile-admin"; // JSP ADMIN
    }

    // ===============================
    // MODIFICATION PROFIL ADMIN
    // ===============================
    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute Utilisateur utilisateur,
                                HttpSession session,
                                ModelMap model) {

        Utilisateur userSession = (Utilisateur) session.getAttribute("user");

        if (userSession == null || !"ADMIN".equalsIgnoreCase(userSession.getRole())) {
            return "redirect:/login";
        }

        // Sécurisation : on garde ID et rôle
        utilisateur.setId(userSession.getId());
        utilisateur.setRole(userSession.getRole());

        Utilisateur updatedUser = utilisateurService.update(utilisateur);
        session.setAttribute("user", updatedUser);

        model.addAttribute("utilisateur", updatedUser);
        model.addAttribute("success", "Profil admin mis à jour avec succès");

        return "admin/profile-admin";
    }
}
