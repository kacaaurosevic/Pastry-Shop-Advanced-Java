package com.poslasticarnica.model;

import jakarta.persistence.*;

@Entity
@Table(name = "poslastice")
public class Poslastica implements MyEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String naziv;
    private String slika;
    private String opis;
    private Double cena;
    private Boolean dostupnost;
    private Double kalorijskaVrednost;

    @Enumerated(EnumType.STRING)
    private JedinicaMere jedinicaMere;

    @ManyToOne
    @JoinColumn(name = "kategorija_id")
    private Kategorija kategorija;

    public Poslastica() {}

    public Poslastica(Long id, String naziv, String slika, String opis, Double cena,
                       Boolean dostupnost, Double kalorijskaVrednost,
                       JedinicaMere jedinicaMere, Kategorija kategorija) {
        this.id = id;
        this.naziv = naziv;
        this.slika = slika;
        this.opis = opis;
        this.cena = cena;
        this.dostupnost = dostupnost;
        this.kalorijskaVrednost = kalorijskaVrednost;
        this.jedinicaMere = jedinicaMere;
        this.kategorija = kategorija;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNaziv() { return naziv; }
    public void setNaziv(String naziv) { this.naziv = naziv; }
    public String getSlika() { return slika; }
    public void setSlika(String slika) { this.slika = slika; }
    public String getOpis() { return opis; }
    public void setOpis(String opis) { this.opis = opis; }
    public Double getCena() { return cena; }
    public void setCena(Double cena) { this.cena = cena; }
    public Boolean getDostupnost() { return dostupnost; }
    public void setDostupnost(Boolean dostupnost) { this.dostupnost = dostupnost; }
    public Double getKalorijskaVrednost() { return kalorijskaVrednost; }
    public void setKalorijskaVrednost(Double kalorijskaVrednost) { this.kalorijskaVrednost = kalorijskaVrednost; }
    public JedinicaMere getJedinicaMere() { return jedinicaMere; }
    public void setJedinicaMere(JedinicaMere jedinicaMere) { this.jedinicaMere = jedinicaMere; }
    public Kategorija getKategorija() { return kategorija; }
    public void setKategorija(Kategorija kategorija) { this.kategorija = kategorija; }

    @Override
    public String toString() {
        return "Poslastica{id=" + id + ", naziv='" + naziv + "', cena=" + cena + "}";
    }
}
