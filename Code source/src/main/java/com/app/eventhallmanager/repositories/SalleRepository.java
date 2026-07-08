package com.app.eventhallmanager.repositories;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.app.eventhallmanager.models.Salle;


public interface SalleRepository extends JpaRepository<Salle, Long> {
	
	List<Salle> findByDisponible(boolean disponible);
	
	Page<Salle> findByNomContainingIgnoreCaseAndDisponible(
            String nom,
            boolean disponible,
            Pageable pageable
    );

    Page<Salle> findByNomContainingIgnoreCase(
            String nom,
            Pageable pageable
    );
    
    List<Salle> findByDisponibleTrue();
    
    @Query("""
            SELECT s
            FROM Salle s
            WHERE s.id NOT IN (
                SELECT r.salle.id
                FROM Reservation r
                WHERE r.dateReservation = :date
                  AND :heureDebut < r.heureFin
                  AND :heureFin > r.heureDebut
            )
        """)
        List<Salle> findSallesDisponibles(
            @Param("date") LocalDate date,
            @Param("heureDebut") LocalTime heureDebut,
            @Param("heureFin") LocalTime heureFin
        );

	
}

