package com.app.eventhallmanager.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.app.eventhallmanager.models.Salle;
import com.app.eventhallmanager.repositories.SalleRepository;

@RestController
@RequestMapping("/api/rooms")
public class SalleController {
    
    @Autowired
    private SalleRepository salleRepo;
    
    // Lister toutes les salles
    @GetMapping("/all")
    public List<Salle> getAllRooms() {
        return salleRepo.findAll();
    }

    // Créer une salle
    @PostMapping("/add")
    public ResponseEntity<Salle> create(@RequestBody Salle sal) {
        Salle result = salleRepo.save(sal);
        return ResponseEntity.status(HttpStatus.CREATED).body(result);
    }

    // Récupérer une salle par ID
    //@GetMapping("/{id}")
    //public ResponseEntity<Salle> getRoomById(@PathVariable Long id) {
    //    Optional<Salle> salleOpt = salleRepo.findById(id);
    //    return salleOpt
    //            .map(salle -> ResponseEntity.ok(salle))
    //            .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).build());
    //}

    // Mettre à jour une salle
    @PutMapping("/{id}")
    public ResponseEntity<Salle> updateRoom(@PathVariable Long id, @RequestBody Salle sal) {
        Optional<Salle> existingSalle = salleRepo.findById(id);
        if (existingSalle.isPresent()) {
            Salle salle = existingSalle.get();
            salle.setNom(sal.getNom());
            salle.setCapacite(sal.getCapacite());
            salle.setDisponible(sal.getDisponible());
            salleRepo.save(salle);
            return ResponseEntity.ok(salle);
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }

    // Supprimer une salle
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteRoom(@PathVariable Long id) {
        Optional<Salle> existingSalle = salleRepo.findById(id);
        if (existingSalle.isPresent()) {
            salleRepo.delete(existingSalle.get());
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }
}
