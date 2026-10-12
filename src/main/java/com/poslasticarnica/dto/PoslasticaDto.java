package com.poslasticarnica.dto;

import com.poslasticarnica.model.JedinicaMere;
import jakarta.validation.constraints.*;
import org.hibernate.validator.constraints.URL;

public class PoslasticaDto implements Dto {

    private Long id;

    @NotEmpty(message = "Naziv je obavezan.")
    @Size(min = 2, max = 100, message = "Naziv mora imati između 2 i 100 karaktera.")
    private String naziv;

    @URL(message = "Slika mora biti ispravan URL.")
    private String slika;

    @Size(max = 500, message = "Opis može imati najviše 500 karaktera.")
    private String opis;

    @NotNull(message = "Cena je obavezna.")
    @Positive(message = "Cena mora biti veća od nule.")
    private Double cena;

    @NotNull(message = "Dostupnost je obavezna.")
    private Boolean dostupnost;

    @PositiveOrZero(message = "Kalorijska vrednost ne može biti negativna.")
    private Double kalorijskaVrednost;

    @NotNull(message = "Jedinica mere je obavezna.")
    private JedinicaMere jedinicaMere;

    @NotNull(message = "Kategorija je obavezna.")
    private Long kategorijaId;

    public PoslasticaDto() {}

    public PoslasticaDto(Long id, String naziv, String slika, String opis, Double cena,
                          Boolean dostupnost, Double kalorijskaVrednost,
                          JedinicaMere jedinicaMere, Long kategorijaId) {
        this.id = id;
        this.naziv = naziv;
        this.slika = slika;
        this.opis = opis;
        this.cena = cena;
        this.dostupnost = dostupnost;
        this.kalorijskaVrednost = kalorijskaVrednost;
        this.jedinicaMere = jedinicaMere;
        this.kategorijaId = kategorijaId;
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
    public Long getKategorijaId() { return kategorijaId; }
    public void setKategorijaId(Long kategorijaId) { this.kategorijaId = kategorijaId; }
}
