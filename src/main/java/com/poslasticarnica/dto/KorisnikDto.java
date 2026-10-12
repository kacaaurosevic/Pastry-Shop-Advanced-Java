package com.poslasticarnica.dto;

import jakarta.validation.constraints.*;

public class KorisnikDto implements Dto {

    private Long id;

    @NotEmpty(message = "Korisničko ime je obavezno.")
    @Size(min = 3, max = 50, message = "Korisničko ime mora imati između 3 i 50 karaktera.")
    private String username;

    @NotEmpty(message = "Lozinka je obavezna.")
    @Size(min = 6, message = "Lozinka mora imati najmanje 6 karaktera.")
    private String lozinka;

    @NotEmpty(message = "Email je obavezan.")
    @Email(message = "Email nije u ispravnom formatu.")
    private String email;

    @NotEmpty(message = "Ime je obavezno.")
    private String ime;

    @NotEmpty(message = "Prezime je obavezno.")
    private String prezime;

    private String uloga;

    public KorisnikDto() {}

    public KorisnikDto(Long id, String username, String lozinka, String email,
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
}
