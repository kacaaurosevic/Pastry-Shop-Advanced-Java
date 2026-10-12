package com.poslasticarnica.model;

import jakarta.persistence.*;

@Entity
@Table(name = "stavke_porudzbine")
public class StavkaPorudzbine implements MyEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Integer rb;
    private Integer kolicina;
    private Double cenaPoJedinici;
    private Double popust;

    @ManyToOne
    @JoinColumn(name = "porudzbina_id")
    private Porudzbina porudzbina;

    @ManyToOne
    @JoinColumn(name = "poslastica_id")
    private Poslastica poslastica;

    public StavkaPorudzbine() {}

    public StavkaPorudzbine(Long id, Integer rb, Integer kolicina, Double cenaPoJedinici,
                             Double popust, Porudzbina porudzbina, Poslastica poslastica) {
        this.id = id;
        this.rb = rb;
        this.kolicina = kolicina;
        this.cenaPoJedinici = cenaPoJedinici;
        this.popust = popust;
        this.porudzbina = porudzbina;
        this.poslastica = poslastica;
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
    public Porudzbina getPorudzbina() { return porudzbina; }
    public void setPorudzbina(Porudzbina porudzbina) { this.porudzbina = porudzbina; }
    public Poslastica getPoslastica() { return poslastica; }
    public void setPoslastica(Poslastica poslastica) { this.poslastica = poslastica; }

    @Override
    public String toString() {
        return "StavkaPorudzbine{id=" + id + ", kolicina=" + kolicina + "}";
    }
}
