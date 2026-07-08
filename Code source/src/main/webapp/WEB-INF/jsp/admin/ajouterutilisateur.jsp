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
    <title>Ajouter un utilisateur</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<!-- Header -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">

        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">
            EventHallManager
        </a>

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
    <h3>Ajouter un nouvel utilisateur</h3>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/admin/users/save">
        <div class="mb-3">
            <label for="nom" class="form-label">Nom</label>
            <input type="text" class="form-control" id="nom" name="nom" required>
        </div>
		
		<div class="mb-3">
		            <label for="prenom" class="form-label">Prénom</label>
		            <input type="text" class="form-control" id="prenom" name="prenom" required>
		        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>

        <div class="mb-3">
            <label for="role" class="form-label">Rôle</label>
            <select class="form-select" id="role" name="role" required>
                <option value="USER">USER</option>
                <option value="ADMIN">ADMIN</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="password" class="form-label">Mot de passe</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>

		<div class="d-flex gap-3 mt-3">
		    <button type="submit" class="btn btn-success">
		        Ajouter
		    </button>
		    
		    <a href="${pageContext.request.contextPath}/admin/voirutilisateurs"
		       class="btn btn-secondary">
		       ⬅ Retour à la liste
		    </a>
		</div>
    </form>
</div>

</body>
</html>
