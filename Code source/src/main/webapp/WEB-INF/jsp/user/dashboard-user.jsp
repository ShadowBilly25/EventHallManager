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
    <title>Tableau de bord utilisateur</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<!-- HEADER -->

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


<div class="container mt-5 text-center">

	<!-- Salutation -->
	    <h3 class="mb-4">
	        ${salutation},
			<strong>
			    <c:out value="${sessionScope.user.prenom}" />
			    <c:out value=" " />
			    <c:out value="${sessionScope.user.nom}" />
			</strong>
	    </h3>

		<!-- Boutons -->
		<div class="d-flex justify-content-center gap-3 mt-4">

		    <a href="/user/faire_reservation"
		       class="btn btn-primary btn-lg">
		         ➕ Réserver une salle
		    </a>

		    <a href="/user/reservations"
		       class="btn btn-outline-primary btn-lg">
		        📅 Liste des réservations
		    </a>

		</div>


	</div>

</body>
</html>
