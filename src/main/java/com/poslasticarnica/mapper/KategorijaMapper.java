package com.poslasticarnica.mapper;

import com.poslasticarnica.dto.KategorijaDto;
import com.poslasticarnica.model.Kategorija;
import org.springframework.stereotype.Component;

@Component
public class KategorijaMapper implements DtoEntityMapper<KategorijaDto, Kategorija> {

    @Override
    public KategorijaDto toDto(Kategorija e) {
        return new KategorijaDto(e.getId(), e.getNaziv(), e.getOpis());
    }

    @Override
    public Kategorija toEntity(KategorijaDto t) {
        return new Kategorija(t.getId(), t.getNaziv(), t.getOpis());
    }
}
