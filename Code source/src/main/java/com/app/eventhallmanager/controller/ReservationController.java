package com.app.eventhallmanager.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.app.eventhallmanager.models.Reservation;
import com.app.eventhallmanager.models.Salle;
import com.app.eventhallmanager.models.Utilisateur;
import com.app.eventhallmanager.repositories.ReservationRepository;
import com.app.eventhallmanager.repositories.SalleRepository;
import com.app.eventhallmanager.repositories.UtilisateurRepository;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/reservations")
public class ReservationController {

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private SalleRepository salleRepository;

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    // Lister toutes les réservations
    @GetMapping("/")
    public List<Reservation> getAll() {
        return reservationRepository.findAll();
    }

    // Récupérer une réservation par ID
    //@GetMapping("/{id}")
    //public ResponseEntity<Reservation> getById(@PathVariable Long id) {
    //    Optional<Reservation> reservationOpt = reservationRepository.findById(id);
    //    return reservationOpt
    //            .map(res -> ResponseEntity.ok(res))
    //            .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).build());
    //}

    // Créer une réservation
    @PostMapping("/")
    public ResponseEntity<Reservation> create(@RequestBody Reservation reservation) {

        // Vérifier que la salle existe
        Salle salle = salleRepository.findById(reservation.getSalle().getId())
                .orElseThrow(() -> new RuntimeException("Salle introuvable"));

        // Vérifier que l'utilisateur existe
        Utilisateur utilisateur = utilisateurRepository.findById(reservation.getUtilisateur().getId())
                .orElseThrow(() -> new RuntimeException("Utilisateur introuvable"));

        // Vérifier que la salle est disponible
        if (!salle.getDisponible()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(null);
        }

        // Lier les entités
        reservation.setSalle(salle);
        reservation.setUtilisateur(utilisateur);

        // Sauvegarder la réservation
        Reservation savedReservation = reservationRepository.save(reservation);

        // Marquer la salle comme non disponible
        salle.setDisponible(false);
        salleRepository.save(salle);

        return ResponseEntity.status(HttpStatus.CREATED).body(savedReservation);
    }

    // Mettre à jour une réservation
    @PutMapping("/{id}")
    public ResponseEntity<Reservation> update(@PathVariable Long id, @RequestBody Reservation reservation) {
        Optional<Reservation> existingReservation = reservationRepository.findById(id);

        if (existingReservation.isPresent()) {
            Reservation res = existingReservation.get();

            // Mettre à jour les champs
            res.setDateReservation(reservation.getDateReservation());
            res.setHeureDebut(reservation.getHeureDebut());
            res.setHeureFin(reservation.getHeureFin());

            // Optionnel : changer la salle ou l'utilisateur
            if (reservation.getSalle() != null) {
                Salle salle = salleRepository.findById(reservation.getSalle().getId())
                        .orElseThrow(() -> new RuntimeException("Salle introuvable"));
                res.setSalle(salle);
            }
            if (reservation.getUtilisateur() != null) {
                Utilisateur utilisateur = utilisateurRepository.findById(reservation.getUtilisateur().getId())
                        .orElseThrow(() -> new RuntimeException("Utilisateur introuvable"));
                res.setUtilisateur(utilisateur);
            }

            reservationRepository.save(res);
            return ResponseEntity.ok(res);
        }

        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }

    // Supprimer une réservation
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        Optional<Reservation> existingReservation = reservationRepository.findById(id);

        if (existingReservation.isPresent()) {
            Reservation res = existingReservation.get();
            
            // Marquer la salle comme disponible avant suppression
            Salle salle = res.getSalle();
            salle.setDisponible(true);
            salleRepository.save(salle);

            reservationRepository.delete(res);
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }

        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }
}
