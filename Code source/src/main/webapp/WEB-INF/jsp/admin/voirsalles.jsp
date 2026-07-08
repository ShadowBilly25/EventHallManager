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
    <title>Voir les salles</title>
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
	<form method="get"
	      action="${pageContext.request.contextPath}/admin/voirsalles"
	      class="row g-2 mb-3">

	    <div class="col-md-auto">
	        <input type="text"
	               name="nom"
	               class="form-control"
	               placeholder="Rechercher par nom"
	               value="${nom}">
	    </div>

	    <div class="col-md-auto">
	        <select name="disponible" class="form-select">
	            <option value="">-- Disponibilité --</option>
	            <option value="true" ${disponible == true ? "selected" : ""}>
	                Disponible
	            </option>
	            <option value="false" ${disponible == false ? "selected" : ""}>
	                Indisponible
	            </option>
	        </select>
	    </div>

	    <div class="col-md-auto">
	        <button class="btn btn-primary w-100">
	            Rechercher
	        </button>
	    </div>
		
		<div class="col-md-auto">
			        <a href="${pageContext.request.contextPath}/admin/voirsalles"
			           class="btn btn-secondary">
			            Réinitialiser
			        </a>
			    </div>
				
	</form>

    <h3> 🏢 Liste des salles</h3>

   <table class="table table-hover table-bordered align-middle mt-3">
    <thead class="table-dark text-center">
        <tr>
            <th>Nom</th>
            <th>Capacité</th>
			<th>Localisation</th>
            <th>Disponibilité</th>
            <th style="width: 180px;">Actions</th>
        </tr>
    </thead>
    <tbody>

        <c:if test="${empty salles}">
            <tr>
                <td colspan="4" class="text-center text-muted">
                    Aucune salle trouvée
                </td>
            </tr>
        </c:if>

        <c:forEach var="s" items="${salles}">
            <tr>
                <td class="fw-semibold">${s.nom}</td>

                <td class="text-center">
                    ${s.capacite}
                </td>
				
				<td class="text-center">
				                    ${s.localisation}
				                </td>

                <td class="text-center">
                    <c:choose>
                        <c:when test="${s.disponible}">
                            <span class="badge bg-success px-3">Disponible</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-danger px-3">Indisponible</span>
                        </c:otherwise>
                    </c:choose>
                </td>

                <td class="text-center">
                    <div class="btn-group btn-group-sm" role="group">
                        <a href="${pageContext.request.contextPath}/admin/salles/edit/${s.id}"
                           class="btn btn-outline-primary">
                            ✏
                        </a>

                        <form action="${pageContext.request.contextPath}/admin/salles/delete/${s.id}"
                              method="post">
							  <button class="btn btn-outline-danger btn-sm"
							  				onclick="return confirm('Voulez-vous vraiment supprimer cette réservation ?');">
							  							                                🗑️
							  							                            </button>
                        </form>
                    </div>
                </td>
            </tr>
        </c:forEach>

    </tbody>
</table>

	
<c:if test="${totalPages > 1}">
    <nav class="mt-4">
        <ul class="pagination justify-content-center">

            <!-- Précédent -->
            <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                <a class="page-link"
                   href="?page=${currentPage - 1}&nom=${nom}&disponible=${disponible}">
                    Précédent
                </a>
            </li>

            <!-- Pages -->
            <c:forEach begin="0" end="${totalPages - 1}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link"
                       href="?page=${i}&nom=${nom}&disponible=${disponible}">
                        ${i + 1}
                    </a>
                </li>
            </c:forEach>

            <!-- Suivant -->
            <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                <a class="page-link"
                   href="?page=${currentPage + 1}&nom=${nom}&disponible=${disponible}">
                    Suivant
                </a>
            </li>

        </ul>
    </nav>
</c:if>

	
	<div class="d-flex gap-3 mt-3">
		<a href="${pageContext.request.contextPath}/admin/ajoutersalle" class="btn btn-success">
		        Ajouter une salle
		    </a>
						    
				<a href="${pageContext.request.contextPath}/admin/dashboard"
				                       class="btn btn-secondary">
				                        ⬅ Accueil
				                    </a>
						</div>
	
</div>

</body>
</html>
