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
    <title>Modifier la réservation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<script>
document.addEventListener("DOMContentLoaded", function () {

    const contextPath = "${pageContext.request.contextPath}";

    const dateInput = document.querySelector('input[name="dateReservation"]');
    const heureDebutInput = document.querySelector('input[name="heureDebut"]');
    const heureFinInput = document.querySelector('input[name="heureFin"]');
    const salleSelect = document.getElementById('salleSelect');
    const noSalleMsg = document.getElementById('noSalleMsg');

    function chargerSalles() {
        const date = dateInput.value;
        const debut = heureDebutInput.value;
        const fin = heureFinInput.value;

        if (!date || !debut || !fin) return;

        if (fin <= debut) {
            salleSelect.innerHTML = `<option value="">Heures invalides</option>`;
            return;
        }

        fetch(contextPath + "/user/api/salles-disponibles?date=" + date +
              "&heureDebut=" + debut + "&heureFin=" + fin)
            .then(res => res.json())
            .then(data => {
                salleSelect.innerHTML = "";

                if (data.length === 0) {
                    noSalleMsg.classList.remove("d-none");
                    salleSelect.innerHTML = `<option value="">Aucune salle disponible</option>`;
                    return;
                }

                noSalleMsg.classList.add("d-none");

                data.forEach(salle => {
                    const option = document.createElement("option");
                    option.value = salle.id;
                    option.textContent = salle.nom + " - Capacité " + salle.capacite;

                    if (salle.id == "${reservation.salle.id}") {
                        option.selected = true;
                    }

                    salleSelect.appendChild(option);
                });
            })
            .catch(err => console.error("Erreur chargement salles :", err));
    }

    dateInput.addEventListener("change", chargerSalles);
    heureDebutInput.addEventListener("change", chargerSalles);
    heureFinInput.addEventListener("change", chargerSalles);

    // Chargement initial
    chargerSalles();
});
</script>

<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/user/dashboard">
            EventHallManager
        </a>

        <div class="collapse navbar-collapse">
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

    <h5 class="mb-3">✏️ Modifier la réservation</h5>

    <!-- Messages -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form method="post"
          action="${pageContext.request.contextPath}/user/reservation/edit/${reservation.id}">

        <input type="hidden" name="id" value="${reservation.id}"/>

        <div class="mb-3">
            <label class="form-label">Date</label>
            <input type="date"
                   name="dateReservation"
                   class="form-control"
                   value="${reservation.dateReservation}"
                   required>
        </div>

        <div class="mb-3">
            <label class="form-label">Heure début</label>
            <input type="time"
                   name="heureDebut"
                   class="form-control"
                   value="${reservation.heureDebut}"
                   required>
        </div>

        <div class="mb-3">
            <label class="form-label">Heure fin</label>
            <input type="time"
                   name="heureFin"
                   class="form-control"
                   value="${reservation.heureFin}"
                   required>
        </div>

        <div class="mb-3">
            <label class="form-label">Salle</label>
            <select class="form-select" name="salle.id" id="salleSelect" required>
                <option value="">Chargement...</option>
            </select>

            <div id="noSalleMsg" class="text-danger mt-2 d-none">
                Aucune salle disponible pour ce créneau.
            </div>
        </div>

        <div class="d-flex gap-2">
            <button class="btn btn-primary">💾 Enregistrer</button>
            <a href="${pageContext.request.contextPath}/user/reservations"
               class="btn btn-secondary">Annuler</a>
        </div>
    </form>

</div>

</body>
</html>
