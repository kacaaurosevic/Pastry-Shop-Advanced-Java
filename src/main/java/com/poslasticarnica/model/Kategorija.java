package com.poslasticarnica.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "kategorije")
public class Kategorija implements MyEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String naziv;
    private String opis;

    @OneToMany(mappedBy = "kategorija", cascade = CascadeType.ALL)
    private List<Poslastica> poslastice;

    public Kategorija() {}

    public Kategorija(Long id, String naziv, String opis) {
        this.id = id;
        this.naziv = naziv;
        this.opis = opis;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNaziv() { return naziv; }
    public void setNaziv(String naziv) { this.naziv = naziv; }
    public String getOpis() { return opis; }
    public void setOpis(String opis) { this.opis = opis; }
    public List<Poslastica> getPoslastice() { return poslastice; }
    public void setPoslastice(List<Poslastica> poslastice) { this.poslastice = poslastice; }

    @Override
    public String toString() {
        return "Kategorija{id=" + id + ", naziv='" + naziv + "'}";
    }
}
