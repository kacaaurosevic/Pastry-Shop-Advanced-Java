package com.poslasticarnica.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;

public class KategorijaDto implements Dto {

    private Long id;

    @NotEmpty(message = "Naziv je obavezan.")
    @Size(min = 2, max = 100, message = "Naziv mora imati između 2 i 100 karaktera.")
    private String naziv;

    @Size(max = 500, message = "Opis može imati najviše 500 karaktera.")
    private String opis;

    public KategorijaDto() {}

    public KategorijaDto(Long id, String naziv, String opis) {
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
}
