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
    <title>Kategorije - Poslastičarnica</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <div class="container">
        <h2 class="mb-4">Kategorije</h2>

        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title" id="naslovForme">Dodaj novu kategoriju</h5>
                <form id="formKategorija">
                    <input type="hidden" id="inputId">
                    <div class="row g-2">
                        <div class="col-md-4">
                            <input type="text" class="form-control" id="inputNaziv" placeholder="Naziv" required>
                        </div>
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="inputOpis" placeholder="Opis (opciono)">
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100" id="btnSubmit">Dodaj</button>
                        </div>
                    </div>
                    <button type="button" class="btn btn-secondary mt-2 d-none" id="btnOtkazi">Otkaži izmenu</button>
                </form>
                <div id="poruka" class="mt-2"></div>
            </div>
        </div>

        <table class="table table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>Naziv</th>
                    <th>Opis</th>
                    <th style="width: 160px;">Akcije</th>
                </tr>
            </thead>
            <tbody id="tabelaKategorija">
                <tr><td colspan="3">Učitavanje...</td></tr>
            </tbody>
        </table>
    </div>

    <script>
        let sveKategorije = [];

        async function ucitajKategorije() {
            const response = await fetch('/api/kategorije');
            sveKategorije = await response.json();

            const tabela = document.getElementById('tabelaKategorija');
            tabela.innerHTML = '';

            if (sveKategorije.length === 0) {
                tabela.innerHTML = '<tr><td colspan="3">Nema kategorija.</td></tr>';
                return;
            }

            sveKategorije.forEach(function(k) {
                const red = document.createElement('tr');
                red.innerHTML =
                    '<td>' + k.naziv + '</td>' +
                    '<td>' + (k.opis || '') + '</td>' +
                    '<td>' +
                        '<button type="button" class="btn btn-sm btn-warning me-1 btn-izmeni" data-id="' + k.id + '">Izmeni</button>' +
                        '<button type="button" class="btn btn-sm btn-danger btn-obrisi" data-id="' + k.id + '">Obriši</button>' +
                    '</td>';
                tabela.appendChild(red);
            });

            document.querySelectorAll('.btn-izmeni').forEach(function(dugme) {
                dugme.addEventListener('click', function() {
                    const id = parseInt(this.getAttribute('data-id'));
                    const k = sveKategorije.find(function(x) { return x.id === id; });
                    if (k) izmeniKategoriju(k);
                });
            });

            document.querySelectorAll('.btn-obrisi').forEach(function(dugme) {
                dugme.addEventListener('click', function() {
                    obrisiKategoriju(parseInt(this.getAttribute('data-id')));
                });
            });
        }

        function izmeniKategoriju(k) {
            document.getElementById('inputId').value = k.id;
            document.getElementById('inputNaziv').value = k.naziv;
            document.getElementById('inputOpis').value = k.opis || '';

            document.getElementById('naslovForme').textContent = 'Izmeni kategoriju';
            document.getElementById('btnSubmit').textContent = 'Sačuvaj izmenu';
            document.getElementById('btnOtkazi').classList.remove('d-none');
            window.scrollTo(0, 0);
        }

        function otkaziIzmenu() {
            document.getElementById('formKategorija').reset();
            document.getElementById('inputId').value = '';
            document.getElementById('naslovForme').textContent = 'Dodaj novu kategoriju';
            document.getElementById('btnSubmit').textContent = 'Dodaj';
            document.getElementById('btnOtkazi').classList.add('d-none');
        }

        document.getElementById('btnOtkazi').addEventListener('click', otkaziIzmenu);

        async function obrisiKategoriju(id) {
            if (!confirm('Da li sigurno želiš da obrišeš ovu kategoriju?')) {
                return;
            }
            const response = await fetch('/api/kategorije/' + id, { method: 'DELETE' });
            if (!response.ok) {
                const tekst = await response.text();
                document.getElementById('poruka').innerHTML = '<div class="alert alert-danger">' + tekst + '</div>';
                return;
            }
            ucitajKategorije();
        }

        document.getElementById('formKategorija').addEventListener('submit', async function(e) {
            e.preventDefault();

            const id = document.getElementById('inputId').value;
            const telo = {
                naziv: document.getElementById('inputNaziv').value,
                opis: document.getElementById('inputOpis').value
            };

            const poruka = document.getElementById('poruka');
            const metoda = id ? 'PUT' : 'POST';
            const url = id ? '/api/kategorije/' + id : '/api/kategorije';

            try {
                const response = await fetch(url, {
                    method: metoda,
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(telo)
                });

                if (!response.ok) {
                    const greska = await response.text();
                    poruka.innerHTML = '<div class="alert alert-danger">Greška: ' + greska + '</div>';
                    return;
                }

                poruka.innerHTML = '<div class="alert alert-success">Uspešno sačuvano!</div>';
                otkaziIzmenu();
                ucitajKategorije();
            } catch (error) {
                poruka.innerHTML = '<div class="alert alert-danger">Došlo je do greške pri slanju.</div>';
            }
        });

        window.onload = ucitajKategorije;
    </script>
</body>
</html>
