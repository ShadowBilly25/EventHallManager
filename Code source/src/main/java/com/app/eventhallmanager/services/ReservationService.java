package com.app.eventhallmanager.services;

import java.nio.file.AccessDeniedException;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.app.eventhallmanager.models.Reservation;
import com.app.eventhallmanager.models.ReservationStatus;
import com.app.eventhallmanager.models.Salle;
import com.app.eventhallmanager.models.Utilisateur;
import com.app.eventhallmanager.repositories.ReservationRepository;
import com.app.eventhallmanager.repositories.SalleRepository;

@Service
public class ReservationService {

    @Autowired
    private ReservationRepository reservationRepo;

    @Autowired
    private SalleRepository salleRepo;

    // Enregistrer une réservation si la salle est disponible
    @Transactional
    public Reservation save(Reservation reservation) {

        Salle salle = salleRepo.findById(reservation.getSalle().getId())
                .orElseThrow(() -> new RuntimeException("Salle non trouvée"));

        // Vérification heures
        if (!reservation.getHeureFin().isAfter(reservation.getHeureDebut())) {
            throw new RuntimeException("L'heure de fin doit être après l'heure de début");
        }
        
        LocalDateTime now = LocalDateTime.now();

        LocalDateTime reservationStart =
                LocalDateTime.of(
                        reservation.getDateReservation(),
                        reservation.getHeureDebut()
                );

        // ❌ Date/heure passée
        if (reservationStart.isBefore(now)) {
            throw new RuntimeException(
                    "Impossible de réserver pour une date ou une heure passée."
            );
        }

        // ❌ Moins d'1 heure à l'avance
        if (reservationStart.isBefore(now.plusHours(1))) {
            throw new RuntimeException(
                    "La réservation doit être faite au moins 1 heure à l’avance."
            );
        }


        // Vérification chevauchement
        boolean chevauchement = reservationRepo.existeChevauchement(
                salle.getId(),
                reservation.getDateReservation(),
                reservation.getHeureDebut(),
                reservation.getHeureFin()
        );

        if (chevauchement) {
            throw new RuntimeException("Cette salle est déjà réservée pour cette plage horaire");
        }

        reservation.setSalle(salle);
        reservation.setStatus(ReservationStatus.ACTIVE);

        return reservationRepo.save(reservation);
    }



    // Récupérer toutes les réservations
    public List<Reservation> getAll() {
        return reservationRepo.findAll();
    }
    
    public List<Reservation> findByUtilisateur(Long userId) {
        return reservationRepo.findByUtilisateurId(userId);
    }


    // Compter le nombre de réservations
    public long count() {
        return reservationRepo.count();
    }
    
    public long countByStatus(ReservationStatus status) {
        return reservationRepo.countByStatus(status);
    }
    
    public Page<Reservation> getAllPaginated(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("id").descending());
        return reservationRepo.findAll(pageable);
    }
    
    public Page<Reservation> search(
            Long userId,
            String nom,
            int page,
            int size,
            String sortDirection
    ) {

        // Nettoyage du champ nom
        if (nom != null && nom.trim().isEmpty()) {
            nom = null;
        }

        // Définition du tri
        Sort sort = Sort.by("dateReservation");

        if ("asc".equalsIgnoreCase(sortDirection)) {
            sort = sort.ascending();
        } else {
            sort = sort.descending(); // par défaut
        }

        Pageable pageable = PageRequest.of(page, size, sort);

        return reservationRepo.findByUtilisateurAndSalleNom(userId, nom, pageable);
    }



 // Vérifie si l'utilisateur peut modifier une réservation
    public Reservation getEditableReservation(Long reservationId, Utilisateur user)
            throws AccessDeniedException {

        if (user == null) {
            throw new AccessDeniedException("Utilisateur non authentifié.");
        }

        Reservation res = reservationRepo.findById(reservationId)
                .orElseThrow(() -> new RuntimeException("Réservation non trouvée"));

        if (!res.getUtilisateur().getId().equals(user.getId())) {
            throw new AccessDeniedException("Vous n'êtes pas autorisé à modifier cette réservation.");
        }

        if (res.getStatus() != ReservationStatus.ACTIVE) {
            throw new RuntimeException("Cette réservation n'est plus modifiable.");
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime start =
                LocalDateTime.of(res.getDateReservation(), res.getHeureDebut());

        if (start.isBefore(now.plusHours(1))) {
            throw new RuntimeException("Impossible de modifier une réservation imminente.");
        }

        return res;
    }


    // Modifier une réservation
    @Transactional
    public Reservation editReservation(Reservation updated, Utilisateur user)
            throws AccessDeniedException {

        Reservation res = getEditableReservation(updated.getId(), user);

        boolean chevauchement = reservationRepo.existeChevauchement(
                updated.getSalle().getId(),
                updated.getDateReservation(),
                updated.getHeureDebut(),
                updated.getHeureFin()
        );

        if (chevauchement) {
            throw new RuntimeException("Salle indisponible pour ce créneau");
        }

        res.setDateReservation(updated.getDateReservation());
        res.setHeureDebut(updated.getHeureDebut());
        res.setHeureFin(updated.getHeureFin());
        res.setSalle(updated.getSalle());

        return reservationRepo.save(res);
    }


    // Supprimer une réservation
    //public void deleteReservation(Long reservationId, Utilisateur user) throws AccessDeniedException {
      //  Reservation res = getEditableReservation(reservationId, user);
        //reservationRepo.delete(res);
//    }

    
    @Transactional
    public void cancelReservation(Long reservationId, Utilisateur user)
            throws AccessDeniedException {

        Reservation res = getEditableReservation(reservationId, user);

        res.setStatus(ReservationStatus.ANNULEE);
        reservationRepo.save(res);
    }

    
    @Transactional
    public void terminerReservationsExpirees() {

        LocalDateTime now = LocalDateTime.now();

        List<Reservation> actives =
                reservationRepo.findByStatus(ReservationStatus.ACTIVE);

        for (Reservation res : actives) {
            LocalDateTime fin =
                    LocalDateTime.of(res.getDateReservation(), res.getHeureFin());

            if (fin.isBefore(now)) {
                res.setStatus(ReservationStatus.TERMINEE);
                reservationRepo.save(res); // IMPORTANT
            }
        }
    }
    
    @Scheduled(fixedRate = 60000) // toutes les minutes
    public void autoTerminerReservations() {
        terminerReservationsExpirees();
    }
    
    
    public void cancelByAdmin(Long id) {
        Reservation res = reservationRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Réservation introuvable"));

        res.setStatus(ReservationStatus.ANNULEE);
        reservationRepo.save(res);
    }

    public void finishByAdmin(Long id) {
        Reservation res = reservationRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Réservation introuvable"));

        res.setStatus(ReservationStatus.TERMINEE);
        reservationRepo.save(res);
    }

    public void deleteById(Long id) {
        reservationRepo.deleteById(id);
    }
    
    public Page<Reservation> searchAdmin(
            String nomSalle,
            String status,
            int page,
            int size) {

        Pageable pageable = PageRequest.of(
                page,
                size,
                Sort.by("dateReservation").descending()
        );

        if (nomSalle != null && nomSalle.trim().isEmpty()) {
            nomSalle = null;
        }

        if (status != null && status.trim().isEmpty()) {
            status = null;
        }

        if (nomSalle == null && status == null) {
            return reservationRepo.findAll(pageable);
        }

        if (nomSalle != null && status == null) {
            return reservationRepo
                    .findBySalleNomContainingIgnoreCase(nomSalle, pageable);
        }

        if (nomSalle == null) {
            return reservationRepo
                    .findByStatus(ReservationStatus.valueOf(status), pageable);
        }

        return reservationRepo
                .findBySalleNomContainingIgnoreCaseAndStatus(
                        nomSalle,
                        ReservationStatus.valueOf(status),
                        pageable);
    }


    
    
}
