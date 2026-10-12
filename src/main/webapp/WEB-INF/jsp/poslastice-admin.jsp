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
        <title>Upravljanje poslasticama</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <style>
        /* Dok ništa nije izabrano, tekst u padajućim poljima je siv kao ostali opisi */
        #inputKategorija:invalid, #inputJedinica:invalid {
            color: var(--bs-secondary-color);
        }
        #inputKategorija option, #inputJedinica option {
            color: #212529;
        }
    </style>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="container">
            <h2 class="mb-4">Upravljanje poslasticama</h2>

            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title" id="naslovForme">Dodaj novu poslasticu</h5>
                    <form id="formPoslastica">
                        <input type="hidden" id="inputId">
                        <div class="row g-2 mb-2">
                            <div class="col-md-4">
                                <input type="text" class="form-control" id="inputNaziv" placeholder="Naziv" required>
                            </div>
                            <div class="col-md-4">
                                <input type="url" class="form-control" id="inputSlika" placeholder="URL slike (opciono)">
                            </div>
                            <div class="col-md-4">
                                <input type="text" class="form-control" id="inputOpis" placeholder="Opis (opciono)">
                            </div>
                        </div>
                        <div class="row g-2 mb-2">
                            <div class="col-md-3">
                                <input type="number" step="0.01" class="form-control" id="inputCena" placeholder="Cena" required>
                            </div>
                            <div class="col-md-3">
                                <input type="number" step="0.01" class="form-control" id="inputKalorije" placeholder="Kalorijska vrednost">
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" id="inputJedinica" required>
                                    <option value="" disabled selected hidden>Jedinica mere...</option>
                                    <option value="KOMAD">KOMAD</option>
                                    <option value="GRAM">GRAM</option>
                                    <option value="KILOGRAM">KILOGRAM</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" id="inputKategorija" required>
                                    <option value="" disabled selected hidden>Izaberi kategoriju...</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-check mb-2">
                            <input type="checkbox" class="form-check-input" id="inputDostupnost" checked>
                            <label class="form-check-label" for="inputDostupnost">Dostupno</label>
                        </div>
                        <button type="submit" class="btn btn-primary" id="btnSubmit">Dodaj</button>
                        <button type="button" class="btn btn-secondary d-none" id="btnOtkazi" onclick="otkaziIzmenu()">Otkaži izmenu</button>
                    </form>
                    <div id="poruka" class="mt-2"></div>
                </div>
            </div>

            <table class="table table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>Naziv</th>
                        <th>Cena</th>
                        <th>Kategorija</th>
                        <th>Dostupnost</th>
                        <th style="width: 160px;">Akcije</th>
                    </tr>
                </thead>
                <tbody id="tabelaPoslastica">
                    <tr><td colspan="5">Učitavanje...</td></tr>
                </tbody>
            </table>
        </div>

        <script>
            let kategorijeMapa = {};
            let svePoslasticeAdmin = [];

            async function ucitajKategorijeZaSelect() {
                const response = await fetch('/api/kategorije');
                const kategorije = await response.json();
                const select = document.getElementById('inputKategorija');

                kategorije.forEach(function (k) {
                    kategorijeMapa[k.id] = k.naziv;
                    const opcija = document.createElement('option');
                    opcija.value = k.id;
                    opcija.textContent = k.naziv;
                    select.appendChild(opcija);
                });
            }

            async function ucitajPoslastice() {
                const response = await fetch('/api/poslastice');
                const poslastice = await response.json();
                svePoslasticeAdmin = poslastice;

                const tabela = document.getElementById('tabelaPoslastica');
                tabela.innerHTML = '';

                if (poslastice.length === 0) {
                    tabela.innerHTML = '<tr><td colspan="5">Nema poslastica.</td></tr>';
                    return;
                }

                poslastice.forEach(function (p) {
                    const nazivKategorije = kategorijeMapa[p.kategorijaId] || ('#' + p.kategorijaId);
                    const red = document.createElement('tr');
                    red.innerHTML =
                            '<td>' + p.naziv + '</td>' +
                            '<td>' + p.cena + ' din</td>' +
                            '<td>' + nazivKategorije + '</td>' +
                            '<td>' + (p.dostupnost ? 'Da' : 'Ne') + '</td>' +
                            '<td>' +
                            '<button type="button" class="btn btn-sm btn-warning me-1 btn-izmeni" data-id="' + p.id + '">Izmeni</button>' +
                            '<button type="button" class="btn btn-sm btn-danger btn-obrisi" data-id="' + p.id + '">Obriši</button>' +
                            '</td>';
                    tabela.appendChild(red);
                });

                document.querySelectorAll('.btn-izmeni').forEach(function (dugme) {
                    dugme.addEventListener('click', function () {
                        const id = parseInt(this.getAttribute('data-id'));
                        const poslastica = svePoslasticeAdmin.find(function (x) {
                            return x.id === id;
                        });
                        if (poslastica)
                            izmeniPoslasticu(poslastica);
                    });
                });

                document.querySelectorAll('.btn-obrisi').forEach(function (dugme) {
                    dugme.addEventListener('click', function () {
                        obrisiPoslasticu(parseInt(this.getAttribute('data-id')));
                    });
                });
            }

            function izmeniPoslasticu(p) {
                document.getElementById('inputId').value = p.id;
                document.getElementById('inputNaziv').value = p.naziv;
                document.getElementById('inputSlika').value = p.slika || '';
                document.getElementById('inputOpis').value = p.opis || '';
                document.getElementById('inputCena').value = p.cena;
                document.getElementById('inputKalorije').value = p.kalorijskaVrednost || '';
                document.getElementById('inputJedinica').value = p.jedinicaMere;
                document.getElementById('inputKategorija').value = (p.kategorijaId != null) ? p.kategorijaId : '';
                document.getElementById('inputDostupnost').checked = p.dostupnost;

                document.getElementById('naslovForme').textContent = 'Izmeni poslasticu';
                document.getElementById('btnSubmit').textContent = 'Sačuvaj izmenu';
                document.getElementById('btnOtkazi').classList.remove('d-none');
                window.scrollTo(0, 0);
            }

            function otkaziIzmenu() {
                document.getElementById('formPoslastica').reset();
                document.getElementById('inputId').value = '';
                document.getElementById('naslovForme').textContent = 'Dodaj novu poslasticu';
                document.getElementById('btnSubmit').textContent = 'Dodaj';
                document.getElementById('btnOtkazi').classList.add('d-none');
            }

            async function obrisiPoslasticu(id) {
                if (!confirm('Da li sigurno želiš da obrišeš ovu poslasticu?')) {
                    return;
                }
                const response = await fetch('/api/poslastice/' + id, {method: 'DELETE'});
                if (!response.ok) {
                    const tekst = await response.text();
                    document.getElementById('poruka').innerHTML = '<div class="alert alert-danger">' + tekst + '</div>';
                    return;
                }
                ucitajPoslastice();
            }

            document.getElementById('formPoslastica').addEventListener('submit', async function (e) {
                e.preventDefault();

                const id = document.getElementById('inputId').value;
                const telo = {
                    naziv: document.getElementById('inputNaziv').value,
                    slika: document.getElementById('inputSlika').value || null,
                    opis: document.getElementById('inputOpis').value || null,
                    cena: parseFloat(document.getElementById('inputCena').value),
                    kalorijskaVrednost: parseFloat(document.getElementById('inputKalorije').value) || null,
                    jedinicaMere: document.getElementById('inputJedinica').value,
                    kategorijaId: parseInt(document.getElementById('inputKategorija').value),
                    dostupnost: document.getElementById('inputDostupnost').checked
                };

                const poruka = document.getElementById('poruka');
                const metoda = id ? 'PUT' : 'POST';
                const url = id ? '/api/poslastice/' + id : '/api/poslastice';

                try {
                    const response = await fetch(url, {
                        method: metoda,
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify(telo)
                    });

                    if (!response.ok) {
                        const greska = await response.text();
                        poruka.innerHTML = '<div class="alert alert-danger">Greška: ' + greska + '</div>';
                        return;
                    }

                    poruka.innerHTML = '<div class="alert alert-success">Uspešno sačuvano!</div>';
                    otkaziIzmenu();
                    ucitajPoslastice();
                } catch (error) {
                    poruka.innerHTML = '<div class="alert alert-danger">Došlo je do greške pri slanju.</div>';
                    console.error(error);
                }
            });

            window.onload = async function () {
                await ucitajKategorijeZaSelect();
                await ucitajPoslastice();
            };
        </script>
    </body>
</html>
