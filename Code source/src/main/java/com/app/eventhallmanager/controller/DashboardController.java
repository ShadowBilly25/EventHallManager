package com.app.eventhallmanager.controller;

import com.app.eventhallmanager.models.Reservation;
import com.app.eventhallmanager.models.ReservationStatus;
import com.app.eventhallmanager.models.Salle;

import java.nio.file.AccessDeniedException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.app.eventhallmanager.models.Utilisateur;
import com.app.eventhallmanager.services.ReservationService;
import com.app.eventhallmanager.services.SalleService;
import com.app.eventhallmanager.services.UtilisateurService;
import com.app.eventhallmanager.util.PasswordUtil;

import jakarta.servlet.http.HttpSession;

@Controller
public class DashboardController {

    @Autowired
    private UtilisateurService utilisateurService;

    @Autowired
    private SalleService salleService;

    @Autowired
    private ReservationService reservationService;

    /* =======================
       DASHBOARD USER
       ======================= */
    @GetMapping("/user/dashboard")
    public String dashboard(HttpSession session, ModelMap model) {

        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("salutation", getSalutation());
        model.addAttribute("user", user);

        return "user/dashboard-user";
    }

    /* =======================
       PAGE FAIRE RESERVATION
       ======================= */
    @GetMapping("/user/faire_reservation")
    public String reservationPage(HttpSession session, ModelMap model) {

        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("user", user);
        model.addAttribute("salles", salleService.getAll());

        return "user/faire_reservation";
    }
    
    @PostMapping("/user/faire_reservation")
    public String saveReservation(
            @ModelAttribute Reservation reservation,
            HttpSession session,
            ModelMap model
    ) {
        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            reservation.setUtilisateur(user);
            reservationService.save(reservation);
            model.addAttribute("success", "Réservation effectuée avec succès");
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
        }

        return "user/faire_reservation";
    }

    
    @GetMapping("/user/api/salles-disponibles")
    @ResponseBody
    public List<Salle> sallesDisponibles(
            @RequestParam LocalDate date,
            @RequestParam LocalTime heureDebut,
            @RequestParam LocalTime heureFin
    ) {
        return salleService.getSallesDisponibles(date, heureDebut, heureFin);
    }




    /* =======================
       LISTE DES RESERVATIONS
       ======================= */
    @GetMapping("/user/reservations")
    public String reservations(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size,
            @RequestParam(required = false) String nom,
            @RequestParam(defaultValue = "desc") String sort,
            HttpSession session,
            ModelMap model
    ) {
        // Récupération de l'utilisateur connecté
        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Long userId = user.getId(); // ← correction : définir userId

        // Appel du service avec tri
        Page<Reservation> reservations =
                reservationService.search(userId, nom, page, size, sort);

        // Ajout des attributs pour la vue
        model.addAttribute("reservations", reservations.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", reservations.getTotalPages());
        model.addAttribute("nom", nom);
        model.addAttribute("sort", sort);

        return "user/reservations";
    }
    
    
 // Page d'édition
    @GetMapping("/user/reservation/edit/{id}")
    public String editForm(
            @PathVariable Long id,
            HttpSession session,
            ModelMap model,
            RedirectAttributes redirectAttributes) {

        Utilisateur user = (Utilisateur) session.getAttribute("user");

        // Vérifier connexion
        if (user == null) {
            redirectAttributes.addFlashAttribute(
                    "error", "Veuillez vous connecter pour modifier une réservation."
            );
            return "redirect:/login";
        }

        try {
            Reservation res = reservationService.getEditableReservation(id, user);
            model.addAttribute("reservation", res);
            return "user/edit_reservation"; // JSP d’édition

        } catch (AccessDeniedException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/user/reservations";
    }


    // Soumission du formulaire d'édition
    @PostMapping("/user/reservation/edit/{id}")
    public String submitEdit(@PathVariable Long id,
                             @ModelAttribute Reservation reservation,
                             HttpSession session,
                             ModelMap model) {
        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            reservation.setId(id); // s'assurer que l'ID est correct
            reservationService.editReservation(reservation, user);
            return "redirect:/user/reservations";
        } catch (RuntimeException | AccessDeniedException ex) {
            model.addAttribute("error", ex.getMessage());
            return "user/edit_reservation";
        }
    }

    // Suppression
    //@PostMapping("/user/reservation/delete/{id}")
    //public String deleteReservation(
    //        @PathVariable Long id,
    //        HttpSession session,
    //        RedirectAttributes redirectAttributes) {

    //    Utilisateur user = (Utilisateur) session.getAttribute("user");

      //  if (user == null) {
        //    redirectAttributes.addFlashAttribute("error",
          //          "Vous devez être connecté pour effectuer cette action.");
            //return "redirect:/login";
        //}

        //try {
          //  reservationService.deleteReservation(id, user);
            //redirectAttributes.addFlashAttribute("success",
              //      "Réservation supprimée avec succès.");
        //} catch (AccessDeniedException e) {
          //  redirectAttributes.addFlashAttribute("error", e.getMessage());
        //} catch (RuntimeException e) {
          //  redirectAttributes.addFlashAttribute("error", e.getMessage());
        //}

        //return "redirect:/user/reservations";
    //}
    
    
    
    @PostMapping("/user/reservation/cancel/{id}")
    public String cancelReservation(
            @PathVariable Long id,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Utilisateur user = (Utilisateur) session.getAttribute("user");

        if (user == null) {
            redirectAttributes.addFlashAttribute(
                "error",
                "Vous devez être connecté pour effectuer cette action."
            );
            return "redirect:/login";
        }

        try {
            reservationService.cancelReservation(id, user);
            redirectAttributes.addFlashAttribute(
                "success",
                "Réservation annulée avec succès."
            );
        } catch (AccessDeniedException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/user/reservations";
    }





    /* =======================
       DASHBOARD ADMIN
       ======================= */
    @GetMapping("/admin/dashboard")
    public String adminDashboard(HttpSession session, ModelMap model) {

        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            return "redirect:/login";
        }

        model.addAttribute("salutation", getSalutation());
        model.addAttribute("user", user);

        model.addAttribute("nbUsers", utilisateurService.countUsers());
        model.addAttribute("nbSalles", salleService.count());
        model.addAttribute("nbReservations", reservationService.count());

        return "admin/dashboard-admin";
    }

    /* =======================
       MÉTHODE UTILITAIRE
       ======================= */
    private String getSalutation() {
        int heure = LocalTime.now().getHour();

        if (heure >= 5 && heure < 12) {
            return "Bonjour";
        } else if (heure >= 12 && heure < 18) {
            return "Bon après-midi";
        } else {
            return "Bonsoir";
        }
    }
    
    
    /* =======================
    ADMIN - UTILISATEURS
    ======================= */
    @GetMapping("/admin/voirutilisateurs")
    public String adminUsers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size,
            @RequestParam(required = false) String email,
            HttpSession session,
            ModelMap model) {

        checkAdmin(session);

        Page<Utilisateur> usersPage;

        if (email != null && !email.trim().isEmpty()) {
            usersPage = utilisateurService.searchUsersByEmail(email, page, size);
            model.addAttribute("email", email);
        } else {
            usersPage = utilisateurService.findUsersPaginated(page, size);
        }

        model.addAttribute("users", usersPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", usersPage.getTotalPages());

        return "admin/voirutilisateurs";
    }




 @GetMapping("/admin/ajouterutilisateur")
 public String adminNewUser(HttpSession session, ModelMap model) {
     checkAdmin(session);
     model.addAttribute("utilisateur", new Utilisateur());
     return "admin/ajouterutilisateur";
 }

 /* =======================
    ADMIN - SALLES
    ======================= */
 @GetMapping("/admin/voirsalles")
 public String adminSalles(
         @RequestParam(defaultValue = "") String nom,
         @RequestParam(required = false) Boolean disponible,
         @RequestParam(defaultValue = "0") int page,
         HttpSession session,
         ModelMap model
 ) {
     checkAdmin(session);

     int size = 5; // nombre de lignes par page

     Page<Salle> sallePage =
             salleService.search(nom, disponible, page, size);

     model.addAttribute("salles", sallePage.getContent());
     model.addAttribute("currentPage", page);
     model.addAttribute("totalPages", sallePage.getTotalPages());

     model.addAttribute("nom", nom);
     model.addAttribute("disponible", disponible);

     return "admin/voirsalles";
 }
 
 @GetMapping("/admin/ajoutersalle")
 public String showAddSalle(HttpSession session, ModelMap model) {
     checkAdmin(session);
     model.addAttribute("salle", new Salle());
     return "admin/ajoutersalle";
 }



 @PostMapping("/admin/ajoutersalle")
 public String saveSalle(
         @ModelAttribute Salle salle,
         HttpSession session,
         RedirectAttributes redirectAttributes) {

     checkAdmin(session);

     salle.setDisponible(true); // salle dispo par défaut
     salleService.save(salle);

     redirectAttributes.addFlashAttribute(
         "success",
         "Salle ajoutée avec succès"
     );

     return "redirect:/admin/voirsalles";
 }


 
 /* =======================
 ADMIN - SALLES
 ======================= */
 @GetMapping("/admin/voirreservations")
 public String adminReservations(
         @RequestParam(defaultValue = "0") int page,
         @RequestParam(defaultValue = "5") int size,
         @RequestParam(required = false) String nomSalle,
         @RequestParam(required = false) String status,
         HttpSession session,
         ModelMap model) {

     Utilisateur user = (Utilisateur) session.getAttribute("user");
     if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
         return "redirect:/login";
     }

     Page<Reservation> reservationPage =
             reservationService.searchAdmin(nomSalle, status, page, size);
     
  // 👇 Compteurs
     long actives = reservationService.countByStatus(ReservationStatus.ACTIVE);
     long terminees = reservationService.countByStatus(ReservationStatus.TERMINEE);
     long annulees = reservationService.countByStatus(ReservationStatus.ANNULEE);

     model.addAttribute("user", user);
     model.addAttribute("reservations", reservationPage.getContent());
     model.addAttribute("currentPage", page);
     model.addAttribute("totalPages", reservationPage.getTotalPages());

     // garder les valeurs dans le formulaire
     model.addAttribute("nomSalle", nomSalle);
     model.addAttribute("status", status);
     
     model.addAttribute("actives", actives);
     model.addAttribute("terminees", terminees);
     model.addAttribute("annulees", annulees);

     return "admin/voirreservations";
 }


 
 private void checkAdmin(HttpSession session) {
	    Utilisateur user = (Utilisateur) session.getAttribute("user");
	    if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
	        throw new ResponseStatusException(
	            HttpStatus.FORBIDDEN,
	            "Accès refusé"
	        );
	    }
	}

 
 
 
 
//=======================
 // Sauvegarde d'un nouvel utilisateur
 // =======================

@PostMapping("/admin/users/save")
public String saveUser(@ModelAttribute Utilisateur utilisateur,
                       HttpSession session,
                       ModelMap model) {

    checkAdmin(session);

    // Vérifier email existant
    if (utilisateurService.emailExists(utilisateur.getEmail())) {
        model.addAttribute("error", "Un utilisateur avec cet email existe déjà");
        return "admin/ajouterutilisateur";
    }

    // Hash du mot de passe
    utilisateur.setPassword(
        PasswordUtil.hash(utilisateur.getPassword())
    );

    // Rôle par défaut
    //utilisateur.setRole("USER");

    utilisateurService.save(utilisateur);

    return "redirect:/admin/voirutilisateurs";
}


//=======================
// Suppression d'un utilisateur
// =======================

@PostMapping("/admin/users/delete/{id}")
public String deleteUser(@PathVariable Long id, HttpSession session) {

    checkAdmin(session);

    Utilisateur user = utilisateurService.findById(id);

    if (user == null) {
        throw new RuntimeException("Utilisateur introuvable");
    }

    // Sécurité : empêcher suppression d’un ADMIN
    //if ("ADMIN".equalsIgnoreCase(user.getRole())) {
    //    throw new RuntimeException("Impossible de supprimer un administrateur");
    //}

    utilisateurService.delete(id);

    return "redirect:/admin/voirutilisateurs";
}


@GetMapping("/admin/users/edit/{id}")
public String editUser(@PathVariable Long id,
                       HttpSession session,
                       ModelMap model) {

    checkAdmin(session);

    Utilisateur utilisateur = utilisateurService.findById(id);

    if (utilisateur == null) {
        throw new RuntimeException("Utilisateur introuvable");
    }

    // Sécurité : on n'édite pas un ADMIN
    //if ("ADMIN".equalsIgnoreCase(utilisateur.getRole())) {
    //    throw new RuntimeException("Impossible de modifier un administrateur");
    //}

    model.addAttribute("utilisateur", utilisateur);

    return "admin/modifierutilisateur";
}


@PostMapping("/admin/users/edit")
public String updateUser(@ModelAttribute Utilisateur utilisateur,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {

    checkAdmin(session);

    Utilisateur existing = utilisateurService.findById(utilisateur.getId());

    if (existing == null) {
        redirectAttributes.addFlashAttribute(
            "error",
            "Utilisateur introuvable."
        );
        return "redirect:/admin/voirutilisateurs";
    }

    // Empêcher modification d'un ADMIN
    //if ("ADMIN".equalsIgnoreCase(existing.getRole())) {
    //    redirectAttributes.addFlashAttribute(
    //       "error",
    //       "Impossible de modifier un administrateur."
    // ////   );
    // return "redirect:/admin/voirutilisateurs";
        //}

    // Conserver champs sensibles
    utilisateur.setPassword(existing.getPassword());
    utilisateur.setRole(existing.getRole());

    utilisateurService.update(utilisateur);

    redirectAttributes.addFlashAttribute(
        "success",
        "Utilisateur modifié avec succès."
    );

    return "redirect:/admin/voirutilisateurs";
}

@GetMapping("/admin/salles/edit/{id}")
public String editSalle(@PathVariable Long id,
                        HttpSession session,
                        ModelMap model) {

    checkAdmin(session);

    Salle salle = salleService.findById(id);
    if (salle == null) {
        model.addAttribute("error", "Salle introuvable");
        return "redirect:/admin/voirsalles";
    }

    model.addAttribute("salle", salle);
    return "admin/modifiersalle";
}


@PostMapping("/admin/salles/edit")
public String updateSalle(HttpSession session,
                          @ModelAttribute Salle salle,
                          ModelMap model) {

    checkAdmin(session);

    Salle existingSalle = salleService.findById(salle.getId());
    if (existingSalle == null) {
        model.addAttribute("error", "Salle introuvable");
        return "admin/modifiersalle";
    }

    existingSalle.setNom(salle.getNom());
    existingSalle.setCapacite(salle.getCapacite());
    existingSalle.setLocalisation(salle.getLocalisation());
    existingSalle.setDisponible(salle.getDisponible());

    salleService.save(existingSalle);

    model.addAttribute("success", "Salle modifiée avec succès");
    model.addAttribute("salle", existingSalle);

    return "admin/modifiersalle";
}



@PostMapping("/admin/salles/delete/{id}")
public String deleteSalle(@PathVariable Long id,
                          HttpSession session) {

    checkAdmin(session);

    salleService.deleteById(id);

    return "redirect:/admin/voirsalles";
}


@PostMapping("/admin/reservation/cancel/{id}")
public String cancelReservation(@PathVariable Long id, HttpSession session) {

    checkAdmin(session);

    reservationService.cancelByAdmin(id);

    return "redirect:/admin/voirreservations";
}

@PostMapping("/admin/reservation/finish/{id}")
public String finishReservation(@PathVariable Long id, HttpSession session) {

    checkAdmin(session);

    reservationService.finishByAdmin(id);

    return "redirect:/admin/voirreservations";
}

@PostMapping("/admin/reservation/delete/{id}")
public String deleteReservationAdmin(@PathVariable Long id, HttpSession session) {
    checkAdmin(session);
    reservationService.deleteById(id);
    return "redirect:/admin/voirreservations";
}








    
    
}
