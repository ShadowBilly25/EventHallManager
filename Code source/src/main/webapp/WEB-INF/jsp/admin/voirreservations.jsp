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
    <title>Liste des réservations</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<!-- HEADER -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">
            EventHallManager
        </a>

        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
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
	
	<!-- BARRE DE RECHERCHE + FILTRE -->
	<form method="get" action="${pageContext.request.contextPath}/admin/voirreservations"
	      class="row g-2 mb-4 align-items-end">

	    <!-- Recherche salle -->
	    <div class="col-md-4">
	        <label class="form-label">Rechercher par salle</label>
	        <input type="text"
	               name="nomSalle"
	               class="form-control"
	               placeholder="Nom de la salle"
	               value="${nomSalle}">
	    </div>

	    <!-- Filtre statut -->
	    <div class="col-md-3">
	        <label class="form-label">Filtrer par statut</label>
	        <select name="status" class="form-select">
	            <option value="">Tous</option>
	            <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>
	                Active
	            </option>
	            <option value="TERMINEE" ${status == 'TERMINEE' ? 'selected' : ''}>
	                Terminée
	            </option>
	            <option value="ANNULEE" ${status == 'ANNULEE' ? 'selected' : ''}>
	                Annulée
	            </option>
	        </select>
	    </div>

	    <!-- Boutons -->
	    <div class="col-md-2">
	        <button class="btn btn-primary w-100">
	            🔍 Rechercher
	        </button>
	    </div>

	    <div class="col-md-2">
	        <a href="${pageContext.request.contextPath}/admin/voirreservations"
	           class="btn btn-secondary w-100">
	            Réinitialiser
	        </a>
	    </div>

	</form>
	
	
	<!-- COMPTEURS -->
	<div class="row text-center mb-4">

	    <div class="col-md-4">
	        <div class="card bg-success text-white shadow">
	            <div class="card-body">
	                <h5>Réservations Actives</h5>
	                <h2>${actives}</h2>
	            </div>
	        </div>
	    </div>

	    <div class="col-md-4">
	        <div class="card bg-secondary text-white shadow">
	            <div class="card-body">
	                <h5>Réservations Terminées</h5>
	                <h2>${terminees}</h2>
	            </div>
	        </div>
	    </div>

	    <div class="col-md-4">
	        <div class="card bg-danger text-white shadow">
	            <div class="card-body">
	                <h5>Réservations Annulées</h5>
	                <h2>${annulees}</h2>
	            </div>
	        </div>
	    </div>

	</div>


    <h3 class="mb-4">📅 Liste des réservations</h3>

    <!-- TABLE -->
    <table class="table table-hover table-bordered align-middle">
        <thead class="table-dark text-center">
        <tr>
            <th>Utilisateur</th>
            <th>Salle</th>
            <th>Date</th>
            <th>Heure début</th>
            <th>Heure fin</th>
			<th>Statut</th>
			<th>Actions</th>
        </tr>
        </thead>

        <tbody>
        <c:if test="${empty reservations}">
            <tr>
                <td colspan="5" class="text-center text-muted">
                    Aucune réservation trouvée
                </td>
            </tr>
        </c:if>

		<c:forEach var="res" items="${reservations}">
		    <tr>
		        <td>${res.utilisateur.nom} ${res.utilisateur.prenom}</td>
		        <td class="text-center">${res.salle.nom}</td>
		        <td class="text-center">${res.dateReservation}</td>
		        <td class="text-center">${res.heureDebut}</td>
		        <td class="text-center">${res.heureFin}</td>
		        <td class="text-center">
		            <span class="badge
		                ${res.status == 'ACTIVE' ? 'bg-success' :
		                  res.status == 'TERMINEE' ? 'bg-secondary' :
		                  'bg-danger'}">
		                ${res.status}
		            </span>
		        </td>

		        <td class="text-center">
		            <div class="btn-group btn-group-sm">

		                <!-- Annuler -->
		                <c:if test="${res.status == 'ACTIVE'}">
		                    <form action="${pageContext.request.contextPath}/admin/reservation/cancel/${res.id}"
		                          method="post" style="display:inline;">
		                        <button class="btn btn-outline-danger"
		                                onclick="return confirm('Annuler cette réservation ?');">
		                            ❌
		                        </button>
		                    </form>
		                </c:if>

		                <!-- Marquer comme terminée -->
		                <c:if test="${res.status == 'ACTIVE'}">
		                    <form action="${pageContext.request.contextPath}/admin/reservation/finish/${res.id}"
		                          method="post" style="display:inline;">
		                        <button class="btn btn-outline-secondary"
		                                onclick="return confirm('Marquer comme terminée ?');">
		                            ✔
		                        </button>
		                    </form>
		                </c:if>

		                <!-- Supprimer -->
		                <form action="${pageContext.request.contextPath}/admin/reservation/delete/${res.id}"
		                      method="post" style="display:inline;">
		                    <button class="btn btn-outline-dark"
		                            onclick="return confirm('Supprimer définitivement ?');">
		                        🗑
		                    </button>
		                </form>

		            </div>
		        </td>
		    </tr>
		</c:forEach>
        </tbody>
    </table>

    <!-- PAGINATION -->
    <c:if test="${totalPages > 1}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center">

                <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage - 1}">
                        Précédent
                    </a>
                </li>

                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}">
                            ${i + 1}
                        </a>
                    </li>
                </c:forEach>

                <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage + 1}">
                        Suivant
                    </a>
                </li>

            </ul>
        </nav>
    </c:if>
	
	<div class="d-flex gap-3 mt-3">
							    
					<a href="${pageContext.request.contextPath}/admin/dashboard"
					                       class="btn btn-secondary">
					                        ⬅ Accueil
					                    </a>
							</div>
		
	</div>

</div>

</body>
</html>
