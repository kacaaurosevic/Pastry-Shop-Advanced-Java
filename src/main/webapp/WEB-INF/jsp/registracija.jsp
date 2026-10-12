<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="sr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Registracija - Poslastičarnica</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <div class="container" style="max-width: 500px;">
        <h2 class="mb-4">Registracija</h2>

        <form id="formRegistracija">
            <div class="mb-3">
                <input type="text" class="form-control" id="inputUsername" placeholder="Username" required>
            </div>
            <div class="mb-3">
                <input type="password" class="form-control" id="inputLozinka" placeholder="Lozinka (min 6 karaktera)" required>
            </div>
            <div class="mb-3">
                <input type="email" class="form-control" id="inputEmail" placeholder="Email" required>
            </div>
            <div class="mb-3">
                <input type="text" class="form-control" id="inputIme" placeholder="Ime" required>
            </div>
            <div class="mb-3">
                <input type="text" class="form-control" id="inputPrezime" placeholder="Prezime" required>
            </div>
            <button type="submit" class="btn btn-success w-100">Registruj se</button>
        </form>

        <div id="poruka" class="mt-3"></div>

        <p class="mt-3 text-center">Već imaš nalog? <a href="/login">Prijavi se</a></p>
    </div>

    <script>
        document.getElementById('formRegistracija').addEventListener('submit', async function(e) {
            e.preventDefault();

            const telo = {
                username: document.getElementById('inputUsername').value,
                lozinka: document.getElementById('inputLozinka').value,
                email: document.getElementById('inputEmail').value,
                ime: document.getElementById('inputIme').value,
                prezime: document.getElementById('inputPrezime').value
            };

            const poruka = document.getElementById('poruka');

            try {
                const response = await fetch('/api/auth/register', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(telo)
                });

                if (!response.ok) {
                    const greska = await response.text();
                    poruka.innerHTML = '<div class="alert alert-danger">' + greska + '</div>';
                    return;
                }

                poruka.innerHTML = '<div class="alert alert-success">Registracija uspešna! Preusmeravam na prijavu...</div>';
                document.getElementById('formRegistracija').reset();

                setTimeout(function() {
                    window.location.href = '/login';
                }, 1500);
            } catch (error) {
                poruka.innerHTML = '<div class="alert alert-danger">Došlo je do greške pri registraciji.</div>';
            }
        });
    </script>
</body>
</html>
