<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Salles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-4">
    <h3>Liste des salles</h3>
    <a href="/salles/nouvelle" class="btn btn-primary mb-3">Nouvelle salle</a>

    <table class="table table-bordered">
        <tr>
            <th>Nom</th>
            <th>Capacité</th>
            <th>Disponible</th>
        </tr>
        <c:forEach items="${salles}" var="s">
            <tr>
                <td>${s.nom}</td>
                <td>${s.capacite}</td>
                <td>${s.disponible ? "Oui" : "Non"}</td>
            </tr>
        </c:forEach>
    </table>
</div>

</body>
</html>
