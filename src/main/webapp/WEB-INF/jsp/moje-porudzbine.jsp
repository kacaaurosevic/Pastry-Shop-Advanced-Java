<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="sr">
<head>
    <script>
        if (!localStorage.getItem('jwtToken') || !localStorage.getItem('korisnikId')) {
            window.location.href = '/login';
        }
    </script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Moje porudžbine - Poslastičarnica</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <div class="container">
        <h2 class="mb-4">Moje porudžbine</h2>

        <div id="poruka"></div>

        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>Broj</th>
                        <th>Datum</th>
                        <th>Adresa dostave</th>
                        <th>Ukupno</th>
                        <th>Status</th>
                        <th style="width: 110px;">Akcije</th>
                    </tr>
                </thead>
                <tbody id="tabelaPorudzbina">
                    <tr><td colspan="6">Učitavanje...</td></tr>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        let poslasticeMapa = {};

        const NAZIVI_STATUSA = {
            'NA_CEKANJU': 'Na čekanju',
            'PRIHVACENA': 'Prihvaćena',
            'U_PRIPREMI': 'U pripremi',
            'ZAVRSENA': 'Završena',
            'OTKAZANA': 'Otkazana'
        };

        const BOJE_STATUSA = {
            'NA_CEKANJU': 'bg-secondary',
            'PRIHVACENA': 'bg-primary',
            'U_PRIPREMI': 'bg-warning text-dark',
            'ZAVRSENA': 'bg-success',
            'OTKAZANA': 'bg-danger'
        };

        async function ucitajPoslastice() {
            const response = await fetch('/api/poslastice');
            const poslastice = await response.json();
            poslastice.forEach(function(p) { poslasticeMapa[p.id] = p.naziv; });
        }

        async function ucitajMojePorudzbine() {
            const korisnikId = localStorage.getItem('korisnikId');
            const tabela = document.getElementById('tabelaPorudzbina');

            try {
                const response = await fetch('/api/porudzbine/korisnik/' + korisnikId);
                if (!response.ok) {
                    throw new Error('Status ' + response.status);
                }
                const porudzbine = await response.json();

                tabela.innerHTML = '';

                if (porudzbine.length === 0) {
                    tabela.innerHTML = '<tr><td colspan="6">Još uvek nemaš nijednu porudžbinu.</td></tr>';
                    return;
                }

                // Najnovije porudžbine prve
                porudzbine.sort(function(a, b) { return b.id - a.id; });

                porudzbine.forEach(function(p) {
                    const red = document.createElement('tr');
                    const nazivStatusa = NAZIVI_STATUSA[p.statusPorudzbine] || p.statusPorudzbine || '-';
                    const boja = BOJE_STATUSA[p.statusPorudzbine] || 'bg-secondary';
                    red.innerHTML =
                        '<td>' + p.id + '</td>' +
                        '<td>' + p.datumPorudzbine + '</td>' +
                        '<td>' + p.adresaDostave + '</td>' +
                        '<td>' + p.ukupanIznos + ' din</td>' +
                        '<td><span class="badge ' + boja + '">' + nazivStatusa + '</span></td>' +
                        '<td><button type="button" class="btn btn-sm btn-info btn-stavke" data-id="' + p.id + '">Stavke</button></td>';
                    tabela.appendChild(red);

                    const redStavki = document.createElement('tr');
                    redStavki.id = 'stavke-' + p.id;
                    redStavki.className = 'd-none';
                    redStavki.innerHTML = '<td colspan="6"><div class="p-2 bg-light" id="stavke-sadrzaj-' + p.id + '">Učitavanje stavki...</div></td>';
                    tabela.appendChild(redStavki);
                });

                document.querySelectorAll('.btn-stavke').forEach(function(dugme) {
                    dugme.addEventListener('click', function() {
                        prikaziStavke(parseInt(this.getAttribute('data-id')));
                    });
                });
            } catch (error) {
                console.error(error);
                tabela.innerHTML = '';
                document.getElementById('poruka').innerHTML =
                    '<div class="alert alert-danger">Greška pri učitavanju porudžbina.</div>';
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
            sadrzaj.innerHTML = 'Učitavanje stavki...';

            const response = await fetch('/api/stavke-porudzbine/porudzbina/' + porudzbinaId);
            const stavke = await response.json();

            if (stavke.length === 0) {
                sadrzaj.innerHTML = '<em>Nema stavki.</em>';
                return;
            }

            let html = '<table class="table table-sm mb-0"><thead><tr><th>Poslastica</th><th>Količina</th><th>Cena po jedinici</th></tr></thead><tbody>';
            stavke.forEach(function(s) {
                const nazivPoslastice = poslasticeMapa[s.poslasticaId] || 'Poslastica';
                html += '<tr><td>' + nazivPoslastice + '</td><td>' + s.kolicina + '</td><td>' + s.cenaPoJedinici + ' din</td></tr>';
            });
            html += '</tbody></table>';

            sadrzaj.innerHTML = html;
        }

        window.onload = async function() {
            await ucitajPoslastice();
            await ucitajMojePorudzbine();
        };
    </script>
</body>
</html>