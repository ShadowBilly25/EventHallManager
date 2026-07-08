package com.app.eventhallmanager.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.ModelMap;

import com.app.eventhallmanager.models.Reservation;
import com.app.eventhallmanager.services.ReservationService;
import com.app.eventhallmanager.services.SalleService;
import com.app.eventhallmanager.services.UtilisateurService;

@Controller
@RequestMapping("/reservations")
public class WebappReservationController {

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private UtilisateurService utilisateurService;

    @Autowired
    private SalleService salleService;

    // Liste de toutes les réservations
    @GetMapping("/liste")
    public String liste(ModelMap modelMap) {
        modelMap.addAttribute("reservations", reservationService.getAll());
        return "reservations"; // reservations.jsp
    }

    // Formulaire pour créer une nouvelle réservation
    @GetMapping("/nouvelle")
    public String form(ModelMap modelMap) {
        modelMap.addAttribute("reservation", new Reservation());
        modelMap.addAttribute("utilisateurs", utilisateurService.getAll());
        modelMap.addAttribute("salles", salleService.getDisponibles());
        return "ajoutreservation"; // ajoutreservation.jsp
    }

    // Sauvegarde de la réservation
    @PostMapping("/save")
    public String save(@ModelAttribute Reservation reservation) {
        reservationService.save(reservation); // vérifie automatiquement la disponibilité
        return "redirect:/reservations/liste";
    }
}
