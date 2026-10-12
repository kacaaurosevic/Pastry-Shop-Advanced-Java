package com.poslasticarnica.dto;

import jakarta.validation.constraints.*;

public class StavkaPorudzbineDto implements Dto {

    private Long id;
    private Integer rb;

    @NotNull(message = "Količina je obavezna.")
    @Positive(message = "Količina mora biti veća od nule.")
    private Integer kolicina;

    @NotNull(message = "Cena po jedinici je obavezna.")
    @Positive(message = "Cena po jedinici mora biti veća od nule.")
    private Double cenaPoJedinici;

    @PositiveOrZero(message = "Popust ne može biti negativan.")
    private Double popust;

    private Long porudzbinaId;

    @NotNull(message = "Poslastica je obavezna.")
    private Long poslasticaId;

    public StavkaPorudzbineDto() {}

    public StavkaPorudzbineDto(Long id, Integer rb, Integer kolicina, Double cenaPoJedinici,
                                Double popust, Long porudzbinaId, Long poslasticaId) {
        this.id = id;
        this.rb = rb;
        this.kolicina = kolicina;
        this.cenaPoJedinici = cenaPoJedinici;
        this.popust = popust;
        this.porudzbinaId = porudzbinaId;
        this.poslasticaId = poslasticaId;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Integer getRb() { return rb; }
    public void setRb(Integer rb) { this.rb = rb; }
    public Integer getKolicina() { return kolicina; }
    public void setKolicina(Integer kolicina) { this.kolicina = kolicina; }
    public Double getCenaPoJedinici() { return cenaPoJedinici; }
    public void setCenaPoJedinici(Double cenaPoJedinici) { this.cenaPoJedinici = cenaPoJedinici; }
    public Double getPopust() { return popust; }
    public void setPopust(Double popust) { this.popust = popust; }
    public Long getPorudzbinaId() { return porudzbinaId; }
    public void setPorudzbinaId(Long porudzbinaId) { this.porudzbinaId = porudzbinaId; }
    public Long getPoslasticaId() { return poslasticaId; }
    public void setPoslasticaId(Long poslasticaId) { this.poslasticaId = poslasticaId; }
}
