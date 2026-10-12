package com.poslasticarnica.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "porudzbine")
public class Porudzbina implements MyEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDate datumPorudzbine;

    @Enumerated(EnumType.STRING)
    private StatusPorudzbine statusPorudzbine;

    private Double ukupanIznos;
    private String adresaDostave;
    private String napomena;

    @ManyToOne
    @JoinColumn(name = "korisnik_id")
    private Korisnik korisnik;

    @OneToMany(mappedBy = "porudzbina", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<StavkaPorudzbine> stavke;

    public Porudzbina() {}

    public Porudzbina(Long id, LocalDate datumPorudzbine, StatusPorudzbine statusPorudzbine,
                       Double ukupanIznos, String adresaDostave, String napomena, Korisnik korisnik) {
        this.id = id;
        this.datumPorudzbine = datumPorudzbine;
        this.statusPorudzbine = statusPorudzbine;
        this.ukupanIznos = ukupanIznos;
        this.adresaDostave = adresaDostave;
        this.napomena = napomena;
        this.korisnik = korisnik;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public LocalDate getDatumPorudzbine() { return datumPorudzbine; }
    public void setDatumPorudzbine(LocalDate datumPorudzbine) { this.datumPorudzbine = datumPorudzbine; }
    public StatusPorudzbine getStatusPorudzbine() { return statusPorudzbine; }
    public void setStatusPorudzbine(StatusPorudzbine statusPorudzbine) { this.statusPorudzbine = statusPorudzbine; }
    public Double getUkupanIznos() { return ukupanIznos; }
    public void setUkupanIznos(Double ukupanIznos) { this.ukupanIznos = ukupanIznos; }
    public String getAdresaDostave() { return adresaDostave; }
    public void setAdresaDostave(String adresaDostave) { this.adresaDostave = adresaDostave; }
    public String getNapomena() { return napomena; }
    public void setNapomena(String napomena) { this.napomena = napomena; }
    public Korisnik getKorisnik() { return korisnik; }
    public void setKorisnik(Korisnik korisnik) { this.korisnik = korisnik; }
    public List<StavkaPorudzbine> getStavke() { return stavke; }
    public void setStavke(List<StavkaPorudzbine> stavke) { this.stavke = stavke; }

    @Override
    public String toString() {
        return "Porudzbina{id=" + id + ", status=" + statusPorudzbine + ", ukupanIznos=" + ukupanIznos + "}";
    }
}
