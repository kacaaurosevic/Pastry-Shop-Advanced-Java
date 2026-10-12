<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<style>
    .navbar .nav-link.active {
        background-color: rgba(255, 255, 255, 0.18);
        color: #fff;
        font-weight: 600;
        border-radius: 0.375rem;
    }
</style>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container">
        <a class="navbar-brand" href="/pocetna">🍰 Poslastičarnica</a>
        <div class="navbar-nav me-auto" id="glavniNav">
            <a class="nav-link" href="/pocetna">Početna</a>
        </div>
        <div class="navbar-nav" id="autentifikacijaNav">
            <a class="nav-link" href="/login">Prijavi se</a>
            <a class="nav-link" href="/registracija">Registruj se</a>
        </div>
    </div>
</nav>

<script>
    (function () {
        const token = localStorage.getItem('jwtToken');
        const username = localStorage.getItem('username');
        const uloga = localStorage.getItem('uloga');

        const glavniNav = document.getElementById('glavniNav');
        const autentifikacijaNav = document.getElementById('autentifikacijaNav');

        if (uloga === 'ADMIN') {
            glavniNav.innerHTML =
                    '<a class="nav-link" href="/pocetna">Početna</a>' +
                    '<a class="nav-link" href="/kategorije">Kategorije</a>' +
                    '<a class="nav-link" href="/admin-poslastice">Upravljanje poslasticama</a>' +
                    '<a class="nav-link" href="/korisnici">Korisnici</a>' +
                    '<a class="nav-link" href="/porudzbine">Porudžbine</a>';
        }

        if (token && username) {
            if (uloga !== 'ADMIN') {
                glavniNav.insertAdjacentHTML('beforeend',
                        '<a class="nav-link" href="/moje-porudzbine">Moje porudžbine</a>');
            }

            autentifikacijaNav.innerHTML =
                    '<span class="nav-link">Prijavljen/a: ' + username + '</span>' +
                    '<a class="nav-link" href="#" id="linkOdjava">Odjavi se</a>';

            document.getElementById('linkOdjava').addEventListener('click', function (e) {
                e.preventDefault();
                localStorage.removeItem('jwtToken');
                localStorage.removeItem('username');
                localStorage.removeItem('uloga');
                localStorage.removeItem('korisnikId');
                window.location.href = '/pocetna';
            });
        }

        // Označi stranicu na kojoj se korisnik trenutno nalazi
        const trenutnaPutanja = window.location.pathname;
        document.querySelectorAll('.navbar .nav-link[href]').forEach(function (link) {
            if (link.getAttribute('href') === trenutnaPutanja) {
                link.classList.add('active');
            }
        });
    })();
</script>
