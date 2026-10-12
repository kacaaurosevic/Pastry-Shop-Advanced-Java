package com.poslasticarnica.mapper;

import com.poslasticarnica.dto.KorisnikDto;
import com.poslasticarnica.model.Korisnik;
import org.springframework.stereotype.Component;

@Component
public class KorisnikMapper implements DtoEntityMapper<KorisnikDto, Korisnik> {

    @Override
    public KorisnikDto toDto(Korisnik e) {
        return new KorisnikDto(e.getId(), e.getUsername(), e.getLozinka(), e.getEmail(),
                e.getIme(), e.getPrezime(), e.getUloga());
    }

    @Override
    public Korisnik toEntity(KorisnikDto t) {
        return new Korisnik(t.getId(), t.getUsername(), t.getLozinka(), t.getEmail(),
                t.getIme(), t.getPrezime(), t.getUloga());
    }
}
