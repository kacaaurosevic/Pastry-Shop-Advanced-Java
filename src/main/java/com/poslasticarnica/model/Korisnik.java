package com.poslasticarnica.model;

import jakarta.persistence.*;

@Entity
@Table(name = "korisnici")
public class Korisnik implements MyEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;

    private String lozinka;
    private String email;
    private String ime;
    private String prezime;
    private String uloga;

    public Korisnik() {}

    public Korisnik(Long id, String username, String lozinka, String email,
                     String ime, String prezime, String uloga) {
        this.id = id;
        this.username = username;
        this.lozinka = lozinka;
        this.email = email;
        this.ime = ime;
        this.prezime = prezime;
        this.uloga = uloga;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getLozinka() { return lozinka; }
    public void setLozinka(String lozinka) { this.lozinka = lozinka; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getIme() { return ime; }
    public void setIme(String ime) { this.ime = ime; }
    public String getPrezime() { return prezime; }
    public void setPrezime(String prezime) { this.prezime = prezime; }
    public String getUloga() { return uloga; }
    public void setUloga(String uloga) { this.uloga = uloga; }

    @Override
    public String toString() {
        return "Korisnik{id=" + id + ", username='" + username + "'}";
    }
}
