package com.poslasticarnica.dto;

import com.poslasticarnica.model.StatusPorudzbine;
import jakarta.validation.constraints.*;
import java.time.LocalDate;

public class PorudzbinaDto implements Dto {

    private Long id;

    @NotNull(message = "Datum porudžbine je obavezan.")
    private LocalDate datumPorudzbine;

    private StatusPorudzbine statusPorudzbine;

    @PositiveOrZero(message = "Ukupan iznos ne može biti negativan.")
    private Double ukupanIznos;

    @NotEmpty(message = "Adresa dostave je obavezna.")
    @Size(max = 200, message = "Adresa dostave može imati najviše 200 karaktera.")
    private String adresaDostave;

    @Size(max = 500, message = "Napomena može imati najviše 500 karaktera.")
    private String napomena;

    @NotNull(message = "Korisnik je obavezan.")
    private Long korisnikId;

    public PorudzbinaDto() {}

    public PorudzbinaDto(Long id, LocalDate datumPorudzbine, StatusPorudzbine statusPorudzbine,
                          Double ukupanIznos, String adresaDostave, String napomena, Long korisnikId) {
        this.id = id;
        this.datumPorudzbine = datumPorudzbine;
        this.statusPorudzbine = statusPorudzbine;
        this.ukupanIznos = ukupanIznos;
        this.adresaDostave = adresaDostave;
        this.napomena = napomena;
        this.korisnikId = korisnikId;
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
    public Long getKorisnikId() { return korisnikId; }
    public void setKorisnikId(Long korisnikId) { this.korisnikId = korisnikId; }
}
