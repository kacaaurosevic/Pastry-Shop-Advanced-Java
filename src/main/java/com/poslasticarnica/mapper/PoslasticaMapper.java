package com.poslasticarnica.mapper;

import com.poslasticarnica.dto.PoslasticaDto;
import com.poslasticarnica.model.Kategorija;
import com.poslasticarnica.model.Poslastica;
import org.springframework.stereotype.Component;

@Component
public class PoslasticaMapper implements DtoEntityMapper<PoslasticaDto, Poslastica> {

    @Override
    public PoslasticaDto toDto(Poslastica e) {
        Long kategorijaId = e.getKategorija() != null ? e.getKategorija().getId() : null;
        return new PoslasticaDto(
                e.getId(), e.getNaziv(), e.getSlika(), e.getOpis(), e.getCena(),
                e.getDostupnost(), e.getKalorijskaVrednost(), e.getJedinicaMere(), kategorijaId
        );
    }

    @Override
    public Poslastica toEntity(PoslasticaDto t) {
        Kategorija kategorija = null;
        if (t.getKategorijaId() != null) {
            kategorija = new Kategorija();
            kategorija.setId(t.getKategorijaId());
        }
        return new Poslastica(
                t.getId(), t.getNaziv(), t.getSlika(), t.getOpis(), t.getCena(),
                t.getDostupnost(), t.getKalorijskaVrednost(), t.getJedinicaMere(), kategorija
        );
    }
}
