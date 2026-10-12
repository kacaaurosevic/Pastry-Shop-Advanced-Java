<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="sr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Poslastičarnica</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

    <%@ include file="navbar.jsp" %>

    <div class="container">
        <div class="row">
            <div class="col-md-8">
                <h2 class="mb-4">Naše poslastice</h2>

                <div class="row mb-4 g-2">
                    <div class="col-md-6">
                        <input type="text" class="form-control" id="inputPretraga" placeholder="Pretraži po nazivu...">
                    </div>
                    <div class="col-md-4">
                        <select class="form-select" id="selectSortiranje">
                            <option value="naziv-asc">Naziv (A-Z)</option>
                            <option value="naziv-desc">Naziv (Z-A)</option>
                            <option value="cena-asc">Cena (najjeftinije prvo)</option>
                            <option value="cena-desc">Cena (najskuplje prvo)</option>
                        </select>
                    </div>
                </div>

                <div id="poslasticeContainer" class="row">
                    <p>Učitavanje...</p>
                </div>
                <div id="paginacijaContainer" class="mt-3"></div>
            </div>

            <div class="col-md-4">
                <div class="card sticky-top" style="top: 20px;">
                    <div class="card-body">
                        <h5 class="card-title">🛒 Korpa</h5>

                        <div id="korpaContainer">
                            <p>Korpa je prazna.</p>
                        </div>
                        <p class="fw-bold">Ukupno: <span id="ukupno">0</span> din</p>

                        <hr>

                        <div id="korpaAkcije">
                            <button type="button" class="btn btn-success w-100" id="btnNastaviNaPorudzbinu">Nastavi na porudžbinu</button>
                        </div>

                        <div id="neprijavljenBlok" class="d-none">
                            <div class="alert alert-warning">
                                Da bi napravio/la porudžbinu, moraš biti prijavljen/a.<br>
                                <a href="/login">Prijavi se</a> ili <a href="/registracija">registruj se</a>.
                            </div>
                            <button type="button" class="btn btn-secondary w-100" id="btnNazadIzNeprijavljen">Nazad</button>
                        </div>

                        <div id="potvrdaBlok" class="d-none">
                            <h6>Potvrda porudžbine</h6>
                            <p class="mb-1"><strong>Ime:</strong> <span id="potvrdaIme"></span></p>
                            <p class="mb-2"><strong>Email:</strong> <span id="potvrdaEmail"></span></p>

                            <div class="mb-2">
                                <input type="text" class="form-control" id="inputAdresaDostave" placeholder="Adresa dostave">
                            </div>
                            <div class="mb-2">
                                <input type="text" class="form-control" id="inputNapomenaPorudzbina" placeholder="Napomena (opciono)">
                            </div>

                            <button type="button" class="btn btn-secondary w-100 mb-2" id="btnNazadNaKupovinu">Nazad na kupovinu</button>
                            <button type="button" class="btn btn-success w-100" id="btnPotvrdiPorudzbinu">Potvrdi porudžbinu</button>
                        </div>

                        <div id="porukaPorudzbina" class="mt-2"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let svePoslastice = [];
        let korpa = JSON.parse(localStorage.getItem('korpa') || '[]');

        let stranicaTrenutna = 1;
        const brojPoStranici = 6;

        function prikaziPoslastice(lista) {
            const container = document.getElementById('poslasticeContainer');
            container.innerHTML = '';

            if (lista.length === 0) {
                container.innerHTML = '<p>Nema poslastica koje odgovaraju pretrazi.</p>';
                return;
            }

            lista.forEach(function(p) {
                const kolona = document.createElement('div');
                kolona.className = 'col-md-4 mb-4';

                const dostupnostBadge = p.dostupnost
                    ? '<span class="badge bg-success">Dostupno</span>'
                    : '<small class="text-danger fw-bold">⚠ Trenutno nije dostupno</small>';

                const slikaHtml = p.slika
                    ? '<img src="' + p.slika + '" class="card-img-top" style="height: 180px; object-fit: cover;" alt="' + p.naziv + '">'
                    : '<div class="bg-light d-flex align-items-center justify-content-center" style="height: 180px;"><span class="text-muted">Nema slike</span></div>';

                const dugmeKorpa = p.dostupnost
                    ? '<button type="button" class="btn btn-sm btn-primary mt-2 d-block btn-dodaj-korpu" data-id="' + p.id + '">Dodaj u korpu</button>'
                    : '<button type="button" class="btn btn-sm btn-secondary mt-2 d-block" disabled>Nedostupno</button>';

                kolona.innerHTML =
                    '<div class="card h-100 shadow-sm">' +
                        slikaHtml +
                        '<div class="card-body">' +
                            '<h5 class="card-title">' + p.naziv + '</h5>' +
                            '<p class="card-text">' + (p.opis || '') + '</p>' +
                            '<p class="card-text fw-bold">' + p.cena + ' din / ' + p.jedinicaMere + '</p>' +
                            dostupnostBadge +
                            dugmeKorpa +
                        '</div>' +
                    '</div>';

                container.appendChild(kolona);
            });

            document.querySelectorAll('.btn-dodaj-korpu').forEach(function(dugme) {
                dugme.addEventListener('click', function() {
                    const id = parseInt(this.getAttribute('data-id'));
                    const p = svePoslastice.find(function(x) { return x.id === id; });
                    if (p) dodajUKorpu(p);
                });
            });
        }

        function primeniPretraguISortiranje() {
            stranicaTrenutna = 1;
            prikaziTrenutnuStranicu();
        }

        function prikaziTrenutnuStranicu() {
            const tekstPretrage = document.getElementById('inputPretraga').value.toLowerCase();
            const sortiranje = document.getElementById('selectSortiranje').value;

            let filtrirano = svePoslastice.filter(function(p) {
                return p.naziv.toLowerCase().includes(tekstPretrage);
            });

            filtrirano.sort(function(a, b) {
                if (sortiranje === 'naziv-asc') return a.naziv.localeCompare(b.naziv);
                if (sortiranje === 'naziv-desc') return b.naziv.localeCompare(a.naziv);
                if (sortiranje === 'cena-asc') return a.cena - b.cena;
                if (sortiranje === 'cena-desc') return b.cena - a.cena;
                return 0;
            });

            const ukupnoStranica = Math.max(1, Math.ceil(filtrirano.length / brojPoStranici));
            if (stranicaTrenutna > ukupnoStranica) {
                stranicaTrenutna = ukupnoStranica;
            }

            const pocetak = (stranicaTrenutna - 1) * brojPoStranici;
            const kraj = pocetak + brojPoStranici;
            const stranicaPodaci = filtrirano.slice(pocetak, kraj);

            prikaziPoslastice(stranicaPodaci);
            prikaziPaginaciju(ukupnoStranica);
        }

        function prikaziPaginaciju(ukupnoStranica) {
            const container = document.getElementById('paginacijaContainer');

            if (ukupnoStranica <= 1) {
                container.innerHTML = '';
                return;
            }

            let html = '<nav><ul class="pagination justify-content-center">';
            for (let i = 1; i <= ukupnoStranica; i++) {
                html += '<li class="page-item' + (i === stranicaTrenutna ? ' active' : '') + '">' +
                    '<button type="button" class="page-link btn-stranica" data-stranica="' + i + '">' + i + '</button>' +
                    '</li>';
            }
            html += '</ul></nav>';
            container.innerHTML = html;

            document.querySelectorAll('.btn-stranica').forEach(function(dugme) {
                dugme.addEventListener('click', function() {
                    stranicaTrenutna = parseInt(this.getAttribute('data-stranica'));
                    prikaziTrenutnuStranicu();
                });
            });
        }

        async function ucitajPoslastice() {
            try {
                const response = await fetch('/api/poslastice');
                svePoslastice = await response.json();
                primeniPretraguISortiranje();
            } catch (error) {
                console.error('Greška pri učitavanju poslastica:', error);
            }
        }

        function dodajUKorpu(p) {
            const postojeca = korpa.find(function(item) { return item.poslasticaId === p.id; });
            if (postojeca) {
                postojeca.kolicina++;
            } else {
                korpa.push({ poslasticaId: p.id, naziv: p.naziv, cena: p.cena, kolicina: 1 });
            }
            prikaziKorpu();
        }

        function ukloniIzKorpe(poslasticaId) {
            korpa = korpa.filter(function(item) { return item.poslasticaId !== poslasticaId; });
            prikaziKorpu();
        }

        function prikaziKorpu() {
            localStorage.setItem('korpa', JSON.stringify(korpa));

            const container = document.getElementById('korpaContainer');

            if (korpa.length === 0) {
                container.innerHTML = '<p>Korpa je prazna.</p>';
                document.getElementById('ukupno').textContent = '0';
                return;
            }

            let html = '<ul class="list-group mb-2">';
            let ukupno = 0;

            korpa.forEach(function(item) {
                const suma = item.cena * item.kolicina;
                ukupno += suma;
                html += '<li class="list-group-item d-flex justify-content-between align-items-center p-2">' +
                    '<span>' + item.naziv + ' x ' + item.kolicina + '<br><small class="text-muted">' + suma + ' din</small></span>' +
                    '<button type="button" class="btn btn-sm btn-outline-danger btn-ukloni" data-id="' + item.poslasticaId + '">X</button>' +
                    '</li>';
            });

            html += '</ul>';
            container.innerHTML = html;
            document.getElementById('ukupno').textContent = ukupno;

            document.querySelectorAll('.btn-ukloni').forEach(function(dugme) {
                dugme.addEventListener('click', function() {
                    ukloniIzKorpe(parseInt(this.getAttribute('data-id')));
                });
            });
        }

        function prikaziAkcije() {
            document.getElementById('korpaAkcije').classList.remove('d-none');
            document.getElementById('neprijavljenBlok').classList.add('d-none');
            document.getElementById('potvrdaBlok').classList.add('d-none');
        }

        document.getElementById('btnNastaviNaPorudzbinu').addEventListener('click', async function() {
            const poruka = document.getElementById('porukaPorudzbina');
            poruka.innerHTML = '';

            if (korpa.length === 0) {
                poruka.innerHTML = '<div class="alert alert-warning">Korpa je prazna.</div>';
                return;
            }

            const korisnikId = localStorage.getItem('korisnikId');

            if (!korisnikId) {
                document.getElementById('korpaAkcije').classList.add('d-none');
                document.getElementById('neprijavljenBlok').classList.remove('d-none');
                return;
            }

            try {
                const response = await fetch('/api/korisnici/' + korisnikId);
                if (!response.ok) {
                    poruka.innerHTML = '<div class="alert alert-danger">Greška pri učitavanju podataka.</div>';
                    return;
                }
                const korisnik = await response.json();

                document.getElementById('potvrdaIme').textContent = korisnik.ime + ' ' + korisnik.prezime;
                document.getElementById('potvrdaEmail').textContent = korisnik.email;

                document.getElementById('korpaAkcije').classList.add('d-none');
                document.getElementById('potvrdaBlok').classList.remove('d-none');
            } catch (error) {
                poruka.innerHTML = '<div class="alert alert-danger">Došlo je do greške.</div>';
            }
        });

        document.getElementById('btnNazadIzNeprijavljen').addEventListener('click', prikaziAkcije);
        document.getElementById('btnNazadNaKupovinu').addEventListener('click', prikaziAkcije);

        document.getElementById('btnPotvrdiPorudzbinu').addEventListener('click', napraviPorudzbinu);

        async function napraviPorudzbinu() {
            const poruka = document.getElementById('porukaPorudzbina');
            const korisnikId = localStorage.getItem('korisnikId');

            if (!korisnikId) {
                poruka.innerHTML = '<div class="alert alert-warning">Moraš biti prijavljen/a. <a href="/login">Prijavi se</a> ili <a href="/registracija">registruj se</a>.</div>';
                return;
            }

            if (korpa.length === 0) {
                poruka.innerHTML = '<div class="alert alert-warning">Korpa je prazna.</div>';
                return;
            }

            const adresa = document.getElementById('inputAdresaDostave').value;
            const napomena = document.getElementById('inputNapomenaPorudzbina').value;

            if (!adresa) {
                poruka.innerHTML = '<div class="alert alert-warning">Unesi adresu dostave.</div>';
                return;
            }

            const ukupanIznos = korpa.reduce(function(zbir, item) {
                return zbir + item.cena * item.kolicina;
            }, 0);

            const danas = new Date().toISOString().split('T')[0];

            const telo = {
                datumPorudzbine: danas,
                statusPorudzbine: 'NA_CEKANJU',
                ukupanIznos: ukupanIznos,
                adresaDostave: adresa,
                napomena: napomena,
                korisnikId: parseInt(korisnikId)
            };

            try {
                const odgovorPorudzbina = await fetch('/api/porudzbine', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(telo)
                });

                if (!odgovorPorudzbina.ok) {
                    const greska = await odgovorPorudzbina.text();
                    poruka.innerHTML = '<div class="alert alert-danger">Greška pri kreiranju porudžbine: ' + greska + '</div>';
                    return;
                }

                const porudzbina = await odgovorPorudzbina.json();
                let rb = 1;

                for (const item of korpa) {
                    await fetch('/api/stavke-porudzbine', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            rb: rb,
                            kolicina: item.kolicina,
                            cenaPoJedinici: item.cena,
                            popust: 0,
                            porudzbinaId: porudzbina.id,
                            poslasticaId: item.poslasticaId
                        })
                    });
                    rb++;
                }

                poruka.innerHTML = '<div class="alert alert-success">Porudžbina uspešno napravljena!</div>';
                korpa = [];
                prikaziKorpu();
                document.getElementById('inputAdresaDostave').value = '';
                document.getElementById('inputNapomenaPorudzbina').value = '';
                prikaziAkcije();
            } catch (error) {
                poruka.innerHTML = '<div class="alert alert-danger">Došlo je do greške pri slanju porudžbine.</div>';
                console.error(error);
            }
        }

        document.getElementById('inputPretraga').addEventListener('input', primeniPretraguISortiranje);
        document.getElementById('selectSortiranje').addEventListener('change', primeniPretraguISortiranje);

        window.onload = async function() {
            await ucitajPoslastice();
            prikaziKorpu();
        };
    </script>

</body>
</html>
