package com.poslasticarnica.mapper;

import com.poslasticarnica.dto.PorudzbinaDto;
import com.poslasticarnica.model.Korisnik;
import com.poslasticarnica.model.Porudzbina;
import org.springframework.stereotype.Component;

@Component
public class PorudzbinaMapper implements DtoEntityMapper<PorudzbinaDto, Porudzbina> {

    @Override
    public PorudzbinaDto toDto(Porudzbina e) {
        Long korisnikId = e.getKorisnik() != null ? e.getKorisnik().getId() : null;
        return new PorudzbinaDto(e.getId(), e.getDatumPorudzbine(), e.getStatusPorudzbine(),
                e.getUkupanIznos(), e.getAdresaDostave(), e.getNapomena(), korisnikId);
    }

    @Override
    public Porudzbina toEntity(PorudzbinaDto t) {
        Korisnik korisnik = null;
        if (t.getKorisnikId() != null) {
            korisnik = new Korisnik();
            korisnik.setId(t.getKorisnikId());
        }
        return new Porudzbina(t.getId(), t.getDatumPorudzbine(), t.getStatusPorudzbine(),
                t.getUkupanIznos(), t.getAdresaDostave(), t.getNapomena(), korisnik);
    }
}
