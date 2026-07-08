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
    <title>Modifier utilisateur</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-light">

<!-- NAVBAR -->
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

<div class="container mt-5">
	
	<!-- MESSAGE SUCCÈS -->
	<c:if test="${not empty success}">
	    <div class="alert alert-success alert-dismissible fade show" role="alert">
	        ${success}
	        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
	    </div>
	</c:if>

	<!-- MESSAGE ERREUR -->
	<c:if test="${not empty error}">
	    <div class="alert alert-danger alert-dismissible fade show" role="alert">
	        ${error}
	        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
	    </div>
	</c:if>


    <div class="card shadow">
        <div class="card-header bg-warning text-dark fw-bold">
            Modifier l’utilisateur
        </div>

        <div class="card-body">

            <form method="post"
                  action="${pageContext.request.contextPath}/admin/users/edit">

                <!-- ID caché -->
                <input type="hidden" name="id" value="${utilisateur.id}" />

                <div class="mb-3">
                    <label class="form-label">Nom</label>
                    <input type="text"
                           name="nom"
                           class="form-control"
                           value="${utilisateur.nom}"
                           required />
                </div>
				
				<div class="mb-3">
				                    <label class="form-label">Prénoms</label>
				                    <input type="text"
				                           name="prenom"
				                           class="form-control"
				                           value="${utilisateur.prenom}"
				                           required />
				                </div>

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email"
                           name="email"
                           class="form-control"
                           value="${utilisateur.email}"
                           required />
                </div>

                <div class="d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/admin/voirutilisateurs"
                       class="btn btn-secondary">
                        Annuler
                    </a>

                    <button type="submit" class="btn btn-warning">
                        Enregistrer
                    </button>
                </div>

            </form>

        </div>
    </div>
</div>

</body>
</html>
