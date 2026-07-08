<%@ page contentType="text/html;charset=UTF-8" %>
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
    <title>Mon Profil</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>

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

	                <!-- Nom utilisateur -->
	                <li class="nav-item me-3">
	                    <span class="navbar-text text-white">
	                        Bonjour, <strong><c:out value="${sessionScope.user.nom}"/></strong>
	                    </span>
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

	<div class="container mt-5">
		    <div class="row justify-content-center">
		        <div class="col-md-6">

		            <div class="card shadow-sm border-0">
		                
		                <!-- Header -->
		                <div class="card-header bg-primary text-white text-center">
		                    <h5 class="mb-0 fw-semibold">
		                        👤 Mon Profil
		                    </h5>
		                </div>

		                <!-- Body -->
		                <div class="card-body px-4 py-4">

		                    <div class="d-flex align-items-center mb-4">
		                        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
		                             style="width: 50px; height: 50px; font-size: 1.4rem;">
		                            ${utilisateur.nom.substring(0,1)}
		                        </div>
		                        <div>
		                            <h6 class="mb-0 fw-bold">
		                                ${utilisateur.prenom} ${utilisateur.nom}
		                            </h6>
		                            <small class="text-muted">
		                                Compte utilisateur
		                            </small>
		                        </div>
		                    </div>

		                    <hr>

		                    <div class="mb-3">
		                        <span class="text-muted small">Nom</span>
		                        <p class="fw-semibold mb-0">
		                            ${utilisateur.nom}
		                        </p>
		                    </div>

		                    <div class="mb-3">
		                        <span class="text-muted small">Prénom</span>
		                        <p class="fw-semibold mb-0">
		                            ${utilisateur.prenom}
		                        </p>
		                    </div>

		                    <div class="mb-3">
		                        <span class="text-muted small">Email</span>
		                        <p class="fw-semibold mb-0">
		                            ${utilisateur.email}
		                        </p>
		                    </div>

		                </div>

		            </div>

		        </div>
		    </div>
		</div>


</body>
</html>
