<!DOCTYPE html>
<html>
<head>
    <title>Ajouter Salle</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-4">
    <h3>Nouvelle salle</h3>

    <form method="post" action="/salles/save">
        <input class="form-control mb-2" name="nom" placeholder="Nom" required>
        <input type="number" class="form-control mb-2" name="capacite" placeholder="Capacité" required>
        <button class="btn btn-success">Enregistrer</button>
    </form>
</div>

</body>
</html>
