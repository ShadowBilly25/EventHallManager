<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Inscription | EventHallManager</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
        }
        .register-card {
            border-radius: 10px;
        }
    </style>
</head>

<body class="d-flex align-items-center justify-content-center">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow register-card p-4">

                <h4 class="text-center mb-4 fw-bold">
                    Création de compte
                </h4>

                <!-- Message erreur -->
                <c:if test="${error != null}">
                    <div class="alert alert-danger text-center">
                        ${error}
                    </div>
                </c:if>

                <!-- Message succès -->
                <c:if test="${success != null}">
                    <div class="alert alert-success text-center">
                        ${success}
                    </div>
                </c:if>

                <form method="post" action="/register">

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Nom</label>
                            <input
                                type="text"
                                name="nom"
                                class="form-control"
                                placeholder="Votre nom"
                                required
                            >
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Prénom</label>
                            <input
                                type="text"
                                name="prenom"
                                class="form-control"
                                placeholder="Votre prénom"
                                required
                            >
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Adresse email</label>
                        <input
                            type="email"
                            name="email"
                            class="form-control"
                            placeholder="ex: utilisateur@email.com"
                            required
                        >
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Mot de passe</label>
                        <input
                            type="password"
                            name="password"
                            class="form-control"
                            placeholder="Minimum 6 caractères"
                            minlength="6"
                            required
                        >
                    </div>

                    <div class="d-grid">
                        <button class="btn btn-success fw-bold">
                            S'inscrire
                        </button>
                    </div>

                </form>

                <hr class="my-4">

                <p class="text-center mb-0">
                    Déjà un compte ?
                    <a href="/login" class="fw-semibold">
                        Se connecter
                    </a>
                </p>

            </div>
        </div>
    </div>
</div>

</body>
</html>
