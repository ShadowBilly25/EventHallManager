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
    <title>Voir les utilisateurs</title>
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
	      action="${pageContext.request.contextPath}/admin/voirutilisateurs"
	      class="row g-2 align-items-center mt-3">

	    <div class="col-md-4">
	        <input type="text"
	               name="email"
	               class="form-control"
	               placeholder="Rechercher par email"
	               value="${email}">
	    </div>

	    <div class="col-md-auto">
	        <button class="btn btn-primary">
	            Rechercher
	        </button>
	    </div>

	    <div class="col-md-auto">
	        <a href="${pageContext.request.contextPath}/admin/voirutilisateurs"
	           class="btn btn-secondary">
	            Réinitialiser
	        </a>
	    </div>
	</form>

    <h3>👥 Liste des utilisateurs</h3>

	<table class="table table-hover table-bordered align-middle mt-3">
	    <thead class="table-dark text-center">
	                <tr>
	                    <th>Nom</th>
	                    <th>Prénoms</th>
	                    <th>Email</th>
	                    <th style="width: 180px;">Actions</th>
	                </tr>
	            </thead>
	            <tbody>
	                <c:forEach var="u" items="${users}">
	                    <tr>
	                        <td class="fw-semibold">${u.nom}</td>
	                        <td class="text-center">${u.prenom}</td>
	                        <td class="text-center">${u.email}</td>
	                        <td class="text-center">
								<div class="btn-group btn-group-sm" role="group">

	                            <!-- Modifier -->
	                            <a href="${pageContext.request.contextPath}/admin/users/edit/${u.id}"
	                               class="btn btn-outline-primary btn-sm me-1">
	                                ✏
	                            </a>

	                            <!-- Supprimer -->
	                            <form action="${pageContext.request.contextPath}/admin/users/delete/${u.id}"
	                                  method="post"
	                                  class="d-inline">
									  <button class="btn btn-outline-danger btn-sm"
									  			onclick="return confirm('Voulez-vous vraiment supprimer cet utilisateur  ?');">
									  							  							   🗑️
									  	                         </button>
	                            </form>
								</td>
	                        </td>
	                    </tr>
	                </c:forEach>

	                <!-- Cas liste vide -->
	                <c:if test="${empty users}">
	                    <tr>
	                        <td colspan="4" class="text-center text-muted py-4">
	                            Aucun utilisateur trouvé
	                        </td>
	                    </tr>
	                </c:if>
	            </tbody>
	        </table>

	<c:if test="${totalPages > 1}">
	    <nav class="mt-4">
	        <ul class="pagination justify-content-center">

	            <!-- Précédent -->
	            <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
	                <a class="page-link"
	                   href="${pageContext.request.contextPath}/admin/voirutilisateurs?page=${currentPage - 1}">
	                    Précédent
	                </a>
	            </li>

	            <!-- Pages -->
	            <c:forEach begin="0" end="${totalPages - 1}" var="i">
	                <li class="page-item ${i == currentPage ? 'active' : ''}">
	                    <a class="page-link"
	                       href="${pageContext.request.contextPath}/admin/voirutilisateurs?page=${i}">
	                        ${i + 1}
	                    </a>
	                </li>
	            </c:forEach>

	            <!-- Suivant -->
	            <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
	                <a class="page-link"
	                   href="${pageContext.request.contextPath}/admin/voirutilisateurs?page=${currentPage + 1}">
	                    Suivant
	                </a>
	            </li>

	        </ul>
	    </nav>
	</c:if>
	
	<div class="d-flex gap-3 mt-3">
		<a href="${pageContext.request.contextPath}/admin/ajouterutilisateur" class="btn btn-success">
		        Ajouter un utilisateur
		    </a>
					    
			<a href="${pageContext.request.contextPath}/admin/dashboard"
			                       class="btn btn-secondary">
			                        ⬅ Accueil
			                    </a>
					</div>
</div>

</body>
</html>
