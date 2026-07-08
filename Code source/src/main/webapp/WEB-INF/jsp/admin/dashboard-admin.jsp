<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin | EventHallManager</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
            background-color: #f8f9fa;
        }
        .header {
            background-color: #343a40;
            color: white;
            padding: 1rem 2rem;
        }
        .card {
            border-radius: 10px;
        }
    </style>
</head>
<body>

<!-- Header -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">

		<a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">
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
                    <a class="nav-link" href="/admin/profile">
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

<div class="container mt-5 text-center">
	
	<!-- Salutation -->
		    <h3 class="mb-4">
		        ${salutation},
		        <strong><c:out value="${sessionScope.user.role}"/></strong>
		    </h3>

    <!-- Statistiques -->
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card shadow p-3 text-center bg-primary text-white">
                <h5>Utilisateurs</h5>
                <h2>${nbUsers}</h2>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow p-3 text-center bg-success text-white">
                <h5>Salles</h5>
                <h2>${nbSalles}</h2>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow p-3 text-center bg-warning text-dark">
                <h5>Réservations</h5>
                <h2>${nbReservations}</h2>
            </div>
        </div>
    </div>

	<!-- Boutons ADMIN -->
	<div class="d-flex justify-content-center flex-wrap gap-3 mt-4">

	    <!-- UTILISATEURS -->
	    <a href="/admin/ajouterutilisateur"
	       class="btn btn-success btn-lg">
	        ➕ Ajouter un utilisateur
	    </a>

	    <a href="/admin/voirutilisateurs"
	       class="btn btn-primary btn-lg">
	        👥 Voir les utilisateurs
	    </a>

	    <!-- SALLES -->
	    <a href="/admin/ajoutersalle"
	       class="btn btn-warning btn-lg text-white">
	        ➕ Ajouter une salle
	    </a>

	    <a href="/admin/voirsalles"
	       class="btn btn-outline-warning btn-lg">
	        🏢 Voir les salles
	    </a>

	    <!-- RÉSERVATIONS -->
	    <a href="/admin/voirreservations"
	       class="btn btn-dark btn-lg">
	        📅 Voir les réservations
	    </a>

	</div>



</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
