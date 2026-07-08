package com.app.eventhallmanager.services;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.app.eventhallmanager.models.Salle;
import com.app.eventhallmanager.repositories.SalleRepository;

@Service
public class SalleService {

    @Autowired
    private SalleRepository salleRepo;
    
    
    // Enregistrer une salle (disponible par défaut)
    public Salle save(Salle salle) {
        salle.setDisponible(true);
        return salleRepo.save(salle);
    }

    // Récupérer toutes les salles
    public List<Salle> getAll() {
        return salleRepo.findAll();
    }

    // Récupérer uniquement les salles disponibles
    public List<Salle> getDisponibles() {
        return salleRepo.findByDisponible(true);
    }

    // Compter le nombre total de salles
    public long count() {
        return salleRepo.count();
    }
    
    public Page<Salle> search(
            String nom,
            Boolean disponible,
            int page,
            int size
    ) {
        Pageable pageable = PageRequest.of(page, size);

        if (disponible == null) {
            return salleRepo.findByNomContainingIgnoreCase(nom, pageable);
        }

        return salleRepo.findByNomContainingIgnoreCaseAndDisponible(
                nom,
                disponible,
                pageable
        );
    }
    
    public Salle findById(Long id) {
        return salleRepo.findById(id).orElse(null);
    }

    public void deleteById(Long id) {
        salleRepo.deleteById(id);
    }
    
    //public List<Salle> findSallesDisponibles(
      //      LocalDate date,
        //    LocalTime heureDebut,
          //  LocalTime heureFin) {

        //List<Salle> salles = salleRepo.findByDisponibleTrue();

        //return salles.stream()
          //      .filter(salle ->
            //            !reservationRepo.existeChevauchement(
              //                  salle.getId(),
                //                date,
                  //              heureDebut,
                    //            heureFin
                      //  )
               // )
                //.toList();
    //}
    
    public List<Salle> getSallesDisponibles(
            LocalDate date,
            LocalTime heureDebut,
            LocalTime heureFin
    ) {

        if (date == null || heureDebut == null || heureFin == null) {
            throw new RuntimeException("Date ou heures manquantes");
        }

        if (!heureFin.isAfter(heureDebut)) {
            throw new RuntimeException("L'heure de fin doit être après l'heure de début");
        }

        return salleRepo.findSallesDisponibles(date, heureDebut, heureFin);
    }

    
}
