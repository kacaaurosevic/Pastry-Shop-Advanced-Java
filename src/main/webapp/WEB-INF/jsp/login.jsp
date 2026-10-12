<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="sr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Prijava - Poslastičarnica</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <div class="container" style="max-width: 400px;">
        <h2 class="mb-4">Prijava</h2>

        <form id="formLogin">
            <div class="mb-3">
                <input type="text" class="form-control" id="inputUsername" placeholder="Username" required>
            </div>
            <div class="mb-3">
                <input type="password" class="form-control" id="inputLozinka" placeholder="Lozinka" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">Prijavi se</button>
        </form>

        <div id="poruka" class="mt-3"></div>

        <p class="mt-3 text-center">Nemaš nalog? <a href="/registracija">Registruj se</a></p>
    </div>

    <script>
        document.getElementById('formLogin').addEventListener('submit', async function(e) {
            e.preventDefault();

            const telo = {
                username: document.getElementById('inputUsername').value,
                lozinka: document.getElementById('inputLozinka').value
            };

            const poruka = document.getElementById('poruka');

            try {
                const response = await fetch('/api/auth/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(telo)
                });

                if (!response.ok) {
                    const greska = await response.text();
                    poruka.innerHTML = '<div class="alert alert-danger">' + greska + '</div>';
                    return;
                }

                const podaci = await response.json();

                localStorage.setItem('jwtToken', podaci.token);
                localStorage.setItem('username', podaci.username);
                localStorage.setItem('uloga', podaci.uloga);
                localStorage.setItem('korisnikId', podaci.id);

                window.location.href = '/pocetna';
            } catch (error) {
                poruka.innerHTML = '<div class="alert alert-danger">Došlo je do greške pri prijavi.</div>';
            }
        });
    </script>
</body>
</html>
