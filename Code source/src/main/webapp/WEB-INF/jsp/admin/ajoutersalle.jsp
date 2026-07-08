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
    <title>Ajouter une salle</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
	
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

<div class="container mt-4">
    <h3>Ajouter une salle</h3>

    <form method="post" action="${pageContext.request.contextPath}/admin/ajoutersalle">
        <div class="mb-3">
            <label for="nom" class="form-label">Nom de la salle</label>
            <input type="text" class="form-control" id="nom" name="nom" required>
        </div>
        <div class="mb-3">
            <label for="capacite" class="form-label">Capacité</label>
            <input type="number" class="form-control" id="capacite" name="capacite" required>
        </div>
		<div class="mb-3">
		            <label for="localisation" class="form-label">Localisation</label>
		            <input type="text" class="form-control" id="localisation" name="localisation" required>
		        </div>
		<div class="d-flex gap-3 mt-3">
				    <button type="submit" class="btn btn-primary">Ajouter</button>
				    
				    <a href="${pageContext.request.contextPath}/admin/voirsalles"
				       class="btn btn-secondary">
				       ⬅ Retour à la liste
				    </a>
				</div>
    </form>
</div>

</body>
</html>
