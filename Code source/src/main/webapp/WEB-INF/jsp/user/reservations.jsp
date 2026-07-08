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
    <title>Mes réservations</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/user/dashboard">
            EventHallManager
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarContent">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item me-2">
                    <a class="nav-link" href="/user/profile">Profil</a>
                </li>
                <li class="nav-item">
                    <a class="btn btn-outline-light btn-sm" href="/logout">Déconnexion</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
	
	<!-- Messages d'erreur -->
	<c:if test="${not empty error}">
	    <div class="alert alert-danger alert-dismissible fade show" role="alert">
	        <strong>⛔ Action refusée :</strong> ${error}
	        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
	    </div>
	</c:if>

	<!-- Message de succès -->
	<c:if test="${not empty success}">
	    <div class="alert alert-success alert-dismissible fade show" role="alert">
	        <strong>✅ Succès :</strong> ${success}
	        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
	    </div>
	</c:if>


    <!-- Barre de recherche -->
    <form method="get" action="${pageContext.request.contextPath}/user/reservations" class="row g-2 mb-3">
        <div class="col-md-auto">
            <input type="text" name="nom" class="form-control" placeholder="Rechercher par nom" value="${nom}">
        </div>
		<div class="col-md-auto">
		    <label for="sortSelect" class="form-label">Trier par :</label>
		    <select id="sortSelect" name="sort" class="form-select form-select-sm">
		        <option value="desc" ${sort == 'desc' ? 'selected' : ''}>
		            Plus récentes
		        </option>
		        <option value="asc" ${sort == 'asc' ? 'selected' : ''}>
		            Plus anciennes
		        </option>
		    </select>
		</div>
        <div class="col-md-auto">
            <button class="btn btn-primary w-100">Rechercher</button>
        </div>
        <div class="col-md-auto">
            <a href="${pageContext.request.contextPath}/user/reservations" class="btn btn-secondary">Réinitialiser</a>
        </div>
    </form>


    <h4 class="mb-4">📅 Liste de vos réservations</h4>

    <table class="table table-hover table-bordered align-middle mt-3">
        <thead class="table-dark text-center">
            <tr>
                <th>Salle</th>
				<th>Localisation</th>
                <th>Date</th>
                <th>Début</th>
                <th>Fin</th>
				<th>Statut</th>
                <th style="width: 180px;">Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${empty reservations}">
                <tr>
                    <td colspan="5" class="text-center text-muted">Aucune réservation trouvée</td>
                </tr>
            </c:if>

            <c:forEach var="res" items="${reservations}">
                <tr>
                    <td class="fw-semibold">${res.salle.nom}</td>
					<td class="text-center">${res.salle.localisation}</td>
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
					<c:if test="${res.status == 'ACTIVE'}">
						<td class="text-center">
						                        <div class="btn-group btn-group-sm" role="group">
						                            <a href="${pageContext.request.contextPath}/user/reservation/edit/${res.id}"
						                               class="btn btn-outline-primary">✏️</a>

						                            <form action="${pageContext.request.contextPath}/user/reservation/cancel/${res.id}"
						                                  method="post" style="display:inline;">
						                                <button class="btn btn-outline-danger btn-sm"
						                                        onclick="return confirm('Voulez-vous vraiment annuler cette réservation ?');">
						                                    🗑️
						                                </button>
						                            </form>
						                        </div>
						                    </td>
					</c:if>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/user/reservations?page=${currentPage - 1}&nom=${nom}">Précédent</a>
                </li>

                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/user/reservations?page=${i}&nom=${nom}">${i + 1}</a>
                    </li>
                </c:forEach>

                <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/user/reservations?page=${currentPage + 1}&nom=${nom}">Suivant</a>
                </li>
            </ul>
        </nav>
    </c:if>
	
	<div class="d-flex gap-3 mt-3">
							    <a href="${pageContext.request.contextPath}/user/faire_reservation" class="btn btn-success">➕ Faire une réservation</a>
							    
								<a href="${pageContext.request.contextPath}/user/dashboard"
													                       class="btn btn-secondary">
													                        ⬅ Accueil
													                    </a>
															</div>
							</div>
	    </form>

    
</div>

</body>
</html>
