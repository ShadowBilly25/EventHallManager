package com.app.eventhallmanager.repositories;


import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.app.eventhallmanager.models.Reservation;
import com.app.eventhallmanager.models.ReservationStatus;


public interface ReservationRepository extends JpaRepository<Reservation, Long> {
	
	List<Reservation> findByUtilisateurId(Long userId);
	
	@Query("""
			SELECT COUNT(r) > 0 FROM Reservation r
			WHERE r.salle.id = :salleId
			AND r.dateReservation = :date
			AND r.status = 'ACTIVE'
			AND (
			    (r.heureDebut < :heureFin AND r.heureFin > :heureDebut)
			)
			""")
			boolean existeChevauchement(
			    Long salleId,
			    LocalDate date,
			    LocalTime heureDebut,
			    LocalTime heureFin
			);
	
	@Query("""
		    SELECT r
		    FROM Reservation r
		    JOIN r.salle s
		    WHERE r.utilisateur.id = :userId
		      AND (
		           :nom IS NULL
		           OR LOWER(s.nom) LIKE LOWER(CONCAT('%', CAST(:nom AS string), '%'))
		      )
		""")
		Page<Reservation> findByUtilisateurAndSalleNom(
		        @Param("userId") Long userId,
		        @Param("nom") String nom,
		        Pageable pageable
		);
	
	
	List<Reservation> findByStatus(ReservationStatus status);
	
	Page<Reservation> findBySalleNomContainingIgnoreCase(
	        String nom,
	        Pageable pageable);

	Page<Reservation> findByStatus(
	        ReservationStatus status,
	        Pageable pageable);

	Page<Reservation> findBySalleNomContainingIgnoreCaseAndStatus(
	        String nom,
	        ReservationStatus status,
	        Pageable pageable);

	long countByStatus(ReservationStatus status);



}
