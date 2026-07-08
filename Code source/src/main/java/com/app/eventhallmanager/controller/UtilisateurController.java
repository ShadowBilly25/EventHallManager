package com.app.eventhallmanager.controller;


import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.app.eventhallmanager.models.Utilisateur;
import com.app.eventhallmanager.repositories.UtilisateurRepository;

@RestController
@RequestMapping("/api/users")
public class UtilisateurController {
	
	@Autowired
	UtilisateurRepository utilisateurRepo;
	
	// Lister tous les utilisateurs
	@GetMapping("/all")
	public List<Utilisateur> getAllUsers() {
		
		List<Utilisateur> result = utilisateurRepo.findAll();
		
		return result;
		
	}
	
	// Créer un utilisateur
	@PostMapping("/add")
	public ResponseEntity<Utilisateur> create(@RequestBody Utilisateur util) {
		
		Utilisateur result = utilisateurRepo.save(util);
		
		return ResponseEntity.status(HttpStatus.CREATED)
                .body(result);
		
	}
	
	 // Récupérer un utilisateur par ID
    //@GetMapping("/{id}")
    //public ResponseEntity<Utilisateur> getUserById(@PathVariable Long id) {
    //    Optional<Utilisateur> userOpt = utilisateurRepo.findById(id);
    //    return userOpt
    //            .map(user -> ResponseEntity.ok(user))
    //            .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).build());
    //}
	
	// Mettre à jour un utilisateur
    @PutMapping("/{id}")
    public ResponseEntity<Utilisateur> updateUser(@PathVariable Long id, @RequestBody Utilisateur util) {
        Optional<Utilisateur> existingUser = utilisateurRepo.findById(id);
        if (existingUser.isPresent()) {
            Utilisateur user = existingUser.get();
            user.setNom(util.getNom());
            user.setEmail(util.getEmail());
            // Ajouter d'autres champs si nécessaire
            utilisateurRepo.save(user);
            return ResponseEntity.ok(user);
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }

    // Supprimer un utilisateur
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        Optional<Utilisateur> existingUser = utilisateurRepo.findById(id);
        if (existingUser.isPresent()) {
            utilisateurRepo.delete(existingUser.get());
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }
	

}
