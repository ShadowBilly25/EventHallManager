package com.app.eventhallmanager.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.ModelMap;

import com.app.eventhallmanager.models.Salle;
import com.app.eventhallmanager.services.SalleService;

@Controller
@RequestMapping("/salles")
public class WebappSalleController {

    @Autowired
    private SalleService salleService;

    // Liste de toutes les salles
    @GetMapping("/liste")
    public String liste(ModelMap modelMap) {
        modelMap.addAttribute("salles", salleService.getAll());
        return "salles"; // salles.jsp
    }

    // Formulaire pour ajouter une nouvelle salle
    @GetMapping("/nouvelle")
    public String form(ModelMap modelMap) {
        modelMap.addAttribute("salle", new Salle());
        return "ajoutsalle"; // ajoutsalle.jsp
    }

    // Sauvegarde de la salle
    @PostMapping("/save")
    public String save(@ModelAttribute Salle salle) {
        salleService.save(salle);
        return "redirect:/salles/liste";
    }
}
