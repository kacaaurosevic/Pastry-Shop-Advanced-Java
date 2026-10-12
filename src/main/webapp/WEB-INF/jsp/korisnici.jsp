<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="sr">
<head>
    <script>
        if (localStorage.getItem('uloga') !== 'ADMIN') {
            window.location.href = '/login';
        }
    </script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Korisnici - Poslastičarnica</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <div class="container">
        <h2 class="mb-4">Korisnici</h2>

        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title" id="naslovForme">Dodaj novog korisnika</h5>
                <form id="formKorisnik">
                    <input type="hidden" id="inputId">
                    <div class="row g-2 mb-2">
                        <div class="col-md-3">
                            <input type="text" class="form-control" id="inputUsername" placeholder="Username" required>
                        </div>
                        <div class="col-md-3">
                            <input type="password" class="form-control" id="inputLozinka" placeholder="Lozinka (min 6 karaktera)" required>
                        </div>
                        <div class="col-md-3">
                            <input type="email" class="form-control" id="inputEmail" placeholder="Email" required>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="inputUloga">
                                <option value="KORISNIK">KORISNIK</option>
                                <option value="ADMIN">ADMIN</option>
                            </select>
                        </div>
                    </div>
                    <div class="row g-2 mb-2">
                        <div class="col-md-3">
                            <input type="text" class="form-control" id="inputIme" placeholder="Ime" required>
                        </div>
                        <div class="col-md-3">
                            <input type="text" class="form-control" id="inputPrezime" placeholder="Prezime" required>
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-primary w-100" id="btnSubmit">Dodaj</button>
                        </div>
                        <div class="col-md-3">
                            <button type="button" class="btn btn-secondary w-100 d-none" id="btnOtkazi">Otkaži izmenu</button>
                        </div>
                    </div>
                </form>
                <div id="poruka" class="mt-2"></div>
            </div>
        </div>

        <table class="table table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>Username</th>
                    <th>Ime i prezime</th>
                    <th>Email</th>
                    <th>Uloga</th>
                    <th style="width: 160px;">Akcije</th>
                </tr>
            </thead>
            <tbody id="tabelaKorisnika">
                <tr><td colspan="5">Učitavanje...</td></tr>
            </tbody>
        </table>
    </div>

    <script>
        let sviKorisnici = [];

        async function ucitajKorisnike() {
            const response = await fetch('/api/korisnici');
            sviKorisnici = await response.json();

            const tabela = document.getElementById('tabelaKorisnika');
            tabela.innerHTML = '';

            if (sviKorisnici.length === 0) {
                tabela.innerHTML = '<tr><td colspan="5">Nema korisnika.</td></tr>';
                return;
            }

            sviKorisnici.forEach(function(k) {
                const red = document.createElement('tr');
                red.innerHTML =
                    '<td>' + k.username + '</td>' +
                    '<td>' + k.ime + ' ' + k.prezime + '</td>' +
                    '<td>' + k.email + '</td>' +
                    '<td>' + (k.uloga || '') + '</td>' +
                    '<td>' +
                        '<button type="button" class="btn btn-sm btn-warning me-1 btn-izmeni" data-id="' + k.id + '">Izmeni</button>' +
                        '<button type="button" class="btn btn-sm btn-danger btn-obrisi" data-id="' + k.id + '">Obriši</button>' +
                    '</td>';
                tabela.appendChild(red);
            });

            document.querySelectorAll('.btn-izmeni').forEach(function(dugme) {
                dugme.addEventListener('click', function() {
                    const id = parseInt(this.getAttribute('data-id'));
                    const k = sviKorisnici.find(function(x) { return x.id === id; });
                    if (k) izmeniKorisnika(k);
                });
            });

            document.querySelectorAll('.btn-obrisi').forEach(function(dugme) {
                dugme.addEventListener('click', function() {
                    obrisiKorisnika(parseInt(this.getAttribute('data-id')));
                });
            });
        }

        function izmeniKorisnika(k) {
            document.getElementById('inputId').value = k.id;
            document.getElementById('inputUsername').value = k.username;
            document.getElementById('inputLozinka').value = k.lozinka;
            document.getElementById('inputEmail').value = k.email;
            document.getElementById('inputUloga').value = k.uloga || 'KORISNIK';
            document.getElementById('inputIme').value = k.ime;
            document.getElementById('inputPrezime').value = k.prezime;

            document.getElementById('naslovForme').textContent = 'Izmeni korisnika';
            document.getElementById('btnSubmit').textContent = 'Sačuvaj izmenu';
            document.getElementById('btnOtkazi').classList.remove('d-none');
            window.scrollTo(0, 0);
        }

        function otkaziIzmenu() {
            document.getElementById('formKorisnik').reset();
            document.getElementById('inputId').value = '';
            document.getElementById('naslovForme').textContent = 'Dodaj novog korisnika';
            document.getElementById('btnSubmit').textContent = 'Dodaj';
            document.getElementById('btnOtkazi').classList.add('d-none');
        }

        document.getElementById('btnOtkazi').addEventListener('click', otkaziIzmenu);

        async function obrisiKorisnika(id) {
            if (!confirm('Da li sigurno želiš da obrišeš ovog korisnika?')) {
                return;
            }
            const response = await fetch('/api/korisnici/' + id, { method: 'DELETE' });
            if (!response.ok) {
                const tekst = await response.text();
                document.getElementById('poruka').innerHTML = '<div class="alert alert-danger">' + tekst + '</div>';
                return;
            }
            ucitajKorisnike();
        }

        document.getElementById('formKorisnik').addEventListener('submit', async function(e) {
            e.preventDefault();

            const id = document.getElementById('inputId').value;
            const telo = {
                username: document.getElementById('inputUsername').value,
                lozinka: document.getElementById('inputLozinka').value,
                email: document.getElementById('inputEmail').value,
                ime: document.getElementById('inputIme').value,
                prezime: document.getElementById('inputPrezime').value,
                uloga: document.getElementById('inputUloga').value
            };

            const poruka = document.getElementById('poruka');
            const metoda = id ? 'PUT' : 'POST';
            const url = id ? '/api/korisnici/' + id : '/api/korisnici';

            const token = localStorage.getItem('jwtToken');
            const headers = { 'Content-Type': 'application/json' };
            if (token) {
                headers['Authorization'] = 'Bearer ' + token;
            }

            try {
                const response = await fetch(url, {
                    method: metoda,
                    headers: headers,
                    body: JSON.stringify(telo)
                });

                if (!response.ok) {
                    const greska = await response.text();
                    poruka.innerHTML = '<div class="alert alert-danger">Greška: ' + greska + '</div>';
                    return;
                }

                poruka.innerHTML = '<div class="alert alert-success">Uspešno sačuvano!</div>';
                otkaziIzmenu();
                ucitajKorisnike();
            } catch (error) {
                poruka.innerHTML = '<div class="alert alert-danger">Došlo je do greške pri slanju.</div>';
            }
        });

        window.onload = ucitajKorisnike;
    </script>
</body>
</html>
