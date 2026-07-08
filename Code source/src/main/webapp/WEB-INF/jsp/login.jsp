<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion | EventHallManager</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
        }
        .login-card {
            border-radius: 10px;
        }
    </style>
</head>

<body class="d-flex align-items-center justify-content-center">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <div class="card shadow login-card p-4">

                <h4 class="text-center mb-4 fw-bold">
                    Connexion
                </h4>

                <!-- Message d’erreur -->
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

                <form method="post" action="/login">

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input
                            type="email"
                            name="username"
                            class="form-control"
                            placeholder="ex: utilisateur@email.com"
                            required
                        >
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Mot de passe</label>
                        <input
                            type="password"
                            name="password"
                            class="form-control"
                            placeholder="••••••••"
                            required
                        >
                    </div>

                    <div class="d-grid">
                        <button class="btn btn-primary fw-bold">
                            Se connecter
                        </button>
                    </div>

                </form>

                <hr class="my-4">

                <p class="text-center mb-0">
                    Pas encore de compte ?
                    <a href="/register" class="fw-semibold">
                        Créer un compte
                    </a>
                </p>

            </div>
        </div>
    </div>
</div>

</body>
</html>
