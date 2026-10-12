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
        <title>Porudžbine - Poslastičarnica</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="container">
            <h2 class="mb-4">Porudžbine</h2>
            <a href="/api/porudzbine/izvoz-excel" class="btn btn-outline-success mb-3">📊 Izvezi u Excel</a>

            <table class="table table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>Broj</th>
                        <th>Datum</th>
                        <th>Korisnik</th>
                        <th>Adresa dostave</th>
                        <th>Ukupno</th>
                        <th>Status</th>
                        <th style="width: 180px;">Akcije</th>
                    </tr>
                </thead>
                <tbody id="tabelaPorudzbina">
                    <tr><td colspan="7">Učitavanje...</td></tr>
                </tbody>
            </table>
        </div>

        <script>
            let korisniciMapa = {};
            let poslasticeMapa = {};
            let svePorudzbine = [];

            async function ucitajPomocnePodatke() {
                const [odgovorKorisnici, odgovorPoslastice] = await Promise.all([
                    fetch('/api/korisnici'),
                    fetch('/api/poslastice')
                ]);
                const korisnici = await odgovorKorisnici.json();
                const poslastice = await odgovorPoslastice.json();

                korisnici.forEach(function (k) {
                    korisniciMapa[k.id] = k.username;
                });
                poslastice.forEach(function (p) {
                    poslasticeMapa[p.id] = p.naziv;
                });
            }

            async function ucitajPorudzbine() {
                const response = await fetch('/api/porudzbine');
                svePorudzbine = await response.json();

                const tabela = document.getElementById('tabelaPorudzbina');
                tabela.innerHTML = '';

                if (svePorudzbine.length === 0) {
                    tabela.innerHTML = '<tr><td colspan="7">Nema porudžbina.</td></tr>';
                    return;
                }

                svePorudzbine.forEach(function (p) {
                    const nazivKorisnika = korisniciMapa[p.korisnikId] || ('#' + p.korisnikId);

                    const red = document.createElement('tr');
                    red.innerHTML =
                            '<td>' + p.id + '</td>' +
                            '<td>' + p.datumPorudzbine + '</td>' +
                            '<td>' + nazivKorisnika + '</td>' +
                            '<td>' + p.adresaDostave + '</td>' +
                            '<td>' + p.ukupanIznos + ' din</td>' +
                            '<td>' +
                            '<select class="form-select form-select-sm select-status" data-id="' + p.id + '">' +
                            '<option value="NA_CEKANJU"' + (p.statusPorudzbine === 'NA_CEKANJU' ? ' selected' : '') + '>Na čekanju</option>' +
                            '<option value="PRIHVACENA"' + (p.statusPorudzbine === 'PRIHVACENA' ? ' selected' : '') + '>Prihvaćena</option>' +
                            '<option value="U_PRIPREMI"' + (p.statusPorudzbine === 'U_PRIPREMI' ? ' selected' : '') + '>U pripremi</option>' +
                            '<option value="ZAVRSENA"' + (p.statusPorudzbine === 'ZAVRSENA' ? ' selected' : '') + '>Završena</option>' +
                            '<option value="OTKAZANA"' + (p.statusPorudzbine === 'OTKAZANA' ? ' selected' : '') + '>Otkazana</option>' +
                            '</select>' +
                            '</td>' +
                            '<td>' +
                            '<button type="button" class="btn btn-sm btn-primary me-1 btn-sacuvaj-status" data-id="' + p.id + '">Sačuvaj status</button>' +
                            '<button type="button" class="btn btn-sm btn-info btn-stavke" data-id="' + p.id + '">Stavke</button>' +
                            '</td>';
                    tabela.appendChild(red);

                    const redStavki = document.createElement('tr');
                    redStavki.id = 'stavke-' + p.id;
                    redStavki.className = 'd-none';
                    redStavki.innerHTML = '<td colspan="7"><div class="p-2 bg-light" id="stavke-sadrzaj-' + p.id + '">Učitavanje stavki...</div></td>';
                    tabela.appendChild(redStavki);
                });

                document.querySelectorAll('.btn-sacuvaj-status').forEach(function (dugme) {
                    dugme.addEventListener('click', function () {
                        sacuvajStatus(parseInt(this.getAttribute('data-id')));
                    });
                });

                document.querySelectorAll('.btn-stavke').forEach(function (dugme) {
                    dugme.addEventListener('click', function () {
                        prikaziStavke(parseInt(this.getAttribute('data-id')));
                    });
                });
            }

            async function sacuvajStatus(id) {
                const porudzbina = svePorudzbine.find(function (p) {
                    return p.id === id;
                });
                const noviStatus = document.querySelector('.select-status[data-id="' + id + '"]').value;

                const telo = {
                    datumPorudzbine: porudzbina.datumPorudzbine,
                    statusPorudzbine: noviStatus,
                    ukupanIznos: porudzbina.ukupanIznos,
                    adresaDostave: porudzbina.adresaDostave,
                    napomena: porudzbina.napomena,
                    korisnikId: porudzbina.korisnikId
                };

                const response = await fetch('/api/porudzbine/' + id, {
                    method: 'PUT',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify(telo)
                });

                if (response.ok) {
                    alert('Status uspešno sačuvan!');
                    ucitajPorudzbine();
                } else {
                    alert('Greška pri čuvanju statusa.');
                }
            }

            async function prikaziStavke(porudzbinaId) {
                const red = document.getElementById('stavke-' + porudzbinaId);
                const sadrzaj = document.getElementById('stavke-sadrzaj-' + porudzbinaId);

                if (!red.classList.contains('d-none')) {
                    red.classList.add('d-none');
                    return;
                }

                red.classList.remove('d-none');
                sadrzaj.innerHTML = 'Učitavanje...';

                const response = await fetch('/api/stavke-porudzbine/porudzbina/' + porudzbinaId);
                const stavke = await response.json();

                if (stavke.length === 0) {
                    sadrzaj.innerHTML = '<em>Nema stavki.</em>';
                    return;
                }

                let html = '<table class="table table-sm mb-0"><thead><tr><th>Poslastica</th><th>Količina</th><th>Cena po jedinici</th><th>Popust</th></tr></thead><tbody>';
                stavke.forEach(function (s) {
                    const nazivPoslastice = poslasticeMapa[s.poslasticaId] || ('#' + s.poslasticaId);
                    html += '<tr><td>' + nazivPoslastice + '</td><td>' + s.kolicina + '</td><td>' + s.cenaPoJedinici + ' din</td><td>' + (s.popust || 0) + '</td></tr>';
                });
                html += '</tbody></table>';

                sadrzaj.innerHTML = html;
            }

            window.onload = async function () {
                await ucitajPomocnePodatke();
                await ucitajPorudzbine();
            };
        </script>
    </body>
</html>
