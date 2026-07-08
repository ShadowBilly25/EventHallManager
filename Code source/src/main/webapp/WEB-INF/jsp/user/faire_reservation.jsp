<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Réserver une salle</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<script>
document.addEventListener("DOMContentLoaded", function () {
	
	    const contextPath = "${pageContext.request.contextPath}";

	    const dateInput = document.querySelector('input[name="dateReservation"]');
	    const heureDebutInput = document.querySelector('input[name="heureDebut"]');
	    const heureFinInput = document.querySelector('input[name="heureFin"]');
	    const salleSelect = document.getElementById('salleSelect');
	    const noSalleMsg = document.getElementById('noSalleMsg');

	    function chargerSalles() {
	        const date = dateInput.value;
	        const debut = heureDebutInput.value;
	        const fin = heureFinInput.value;
			if (fin <= debut) {
			    salleSelect.innerHTML = `<option value="">Heures invalides</option>`;
			    return;
			}


	        if (!date || !debut || !fin) return;

	        fetch(contextPath + "/user/api/salles-disponibles?date=" + date +
	              "&heureDebut=" + debut + "&heureFin=" + fin)
	            .then(res => res.json())
	            .then(data => {
	                salleSelect.innerHTML = "";

	                if (data.length === 0) {
	                    noSalleMsg.classList.remove("d-none");
	                    salleSelect.innerHTML = `<option value="">Aucune salle disponible</option>`;
	                    return;
	                }

	                noSalleMsg.classList.add("d-none");

	                data.forEach(salle => {
	                    const option = document.createElement("option");
	                    option.value = salle.id;
	                    option.textContent = salle.nom + " - Capacité " + salle.capacite;
	                    salleSelect.appendChild(option);
	                });
	            })
	            .catch(err => console.error("Erreur chargement salles :", err));
	    }

	    dateInput.addEventListener("change", chargerSalles);
	    heureDebutInput.addEventListener("change", chargerSalles);
	    heureFinInput.addEventListener("change", chargerSalles);
});
</script>

<body class="bg-light">

	<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	    <div class="container-fluid">

			<a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/user/dashboard">
			    EventHallManager
			</a>

	        <!-- Bouton mobile -->
	        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
	                data-bs-target="#navbarContent">
	            <span class="navbar-toggler-icon"></span>
	        </button>

	        <div class="collapse navbar-collapse" id="navbarContent">
	            <ul class="navbar-nav ms-auto align-items-center">
					
	                <!-- Profil -->
	                <li class="nav-item me-2">
	                    <a class="nav-link" href="/user/profile">
	                        Profil
	                    </a>
	                </li>

	                <!-- Déconnexion -->
	                <li class="nav-item">
	                    <a class="btn btn-outline-light btn-sm" href="/logout">
	                        Déconnexion
	                    </a>
	                </li>

	            </ul>
	        </div>
	    </div>
	</nav>


<div class="container mt-4">

    <h5 class="mb-3">Réserver une salle</h5>
	


	<!-- Afficher message de succès ou erreur -->
	<c:if test="${not empty success}">
	    <div class="alert alert-success">${success}</div>
	</c:if>
	<c:if test="${not empty error}">
	    <div class="alert alert-danger">${error}</div>
	</c:if>

    <form method="post" action="${pageContext.request.contextPath}/user/faire_reservation">

		<div class="mb-3">
		    <label class="form-label">Date</label>
			<input type="date"
			       id="dateReservation"
			       name="dateReservation"
			       class="form-control"
			       min="<%= java.time.LocalDate.now() %>"
			       required>
		</div>

		<div class="mb-3">
		    <label class="form-label">Heure début</label>
		    <input type="time" name="heureDebut" class="form-control" required>
		</div>

		<div class="mb-3">
		    <label class="form-label">Heure fin</label>
		    <input type="time" name="heureFin" class="form-control" required>
		</div>

		<div class="mb-3">
		    <label class="form-label">Salle disponible</label>
		    <select class="form-select" name="salle.id" id="salleSelect" required>
		        <option value="">-- Choisissez une date et des horaires --</option>
		    </select>

		    <div id="noSalleMsg" class="text-danger mt-2 d-none">
		        Aucune salle disponible pour ce créneau.
		    </div>
		</div>
		
		<div class="d-flex gap-3 mt-3">
						    <button type="submit" class="btn btn-primary">Réserver</button>
						    
						    <a href="${pageContext.request.contextPath}/user/reservations"
						       class="btn btn-secondary">
						       ⬅ Retour à la liste
						    </a>
						</div>
    </form>

</div>


<script>
document.querySelector("form").addEventListener("submit", function(e) {

    const date = document.getElementById("dateReservation").value;
    const heureDebut = document.getElementById("heureDebut").value;

    if (!date || !heureDebut) return;

    const reservationDateTime = new Date(date + "T" + heureDebut);
    const now = new Date();

    // Interdire passé
    if (reservationDateTime < now) {
        e.preventDefault();
        alert("⛔ Impossible de réserver une date ou heure passée.");
        return;
    }

    // Ajouter 1h
    const oneHourLater = new Date(now.getTime() + 60 * 60 * 1000);

    if (reservationDateTime < oneHourLater) {
        e.preventDefault();
        alert("⛔ La réservation doit être faite au moins 1 heure à l’avance.");
    }
});
</script>



</body>

</html>
