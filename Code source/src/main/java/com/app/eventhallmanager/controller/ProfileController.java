package com.app.eventhallmanager.controller;

import com.app.eventhallmanager.models.Utilisateur;
import com.app.eventhallmanager.services.UtilisateurService;
import com.app.eventhallmanager.util.PasswordUtil;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/user")
public class ProfileController {

    @Autowired
    private UtilisateurService utilisateurService;

    // PAGE PROFIL
    @GetMapping("/profile")
    public String profile(HttpSession session, ModelMap model) {

        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("utilisateur", user);
        return "user/profile-user"; // JSP
    }

    // MODIFICATION PROFIL
    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute Utilisateur formUser,
                                HttpSession session,
                                ModelMap model) {

        Utilisateur userSession = (Utilisateur) session.getAttribute("user");
        if (userSession == null) {
            return "redirect:/login";
        }

        // 🔥 récupérer l'utilisateur réel depuis la DB
        Utilisateur userDb = utilisateurService.findById(userSession.getId());

        userDb.setNom(formUser.getNom());
        userDb.setPrenom(formUser.getPrenom());
        userDb.setEmail(formUser.getEmail());

        if (formUser.getPassword() != null && !formUser.getPassword().isBlank()) {
            userDb.setPassword(PasswordUtil.hash(formUser.getPassword()));
        }

        Utilisateur updatedUser = utilisateurService.update(userDb);
        session.setAttribute("user", updatedUser);

        model.addAttribute("success", "Profil mis à jour avec succès");
        model.addAttribute("utilisateur", updatedUser);

        return "user/profile-user";
    }


}
