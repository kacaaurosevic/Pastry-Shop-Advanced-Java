package com.poslasticarnica.mapper;

import com.poslasticarnica.dto.StavkaPorudzbineDto;
import com.poslasticarnica.model.Porudzbina;
import com.poslasticarnica.model.Poslastica;
import com.poslasticarnica.model.StavkaPorudzbine;
import org.springframework.stereotype.Component;

@Component
public class StavkaPorudzbineMapper implements DtoEntityMapper<StavkaPorudzbineDto, StavkaPorudzbine> {

    @Override
    public StavkaPorudzbineDto toDto(StavkaPorudzbine e) {
        Long porudzbinaId = e.getPorudzbina() != null ? e.getPorudzbina().getId() : null;
        Long poslasticaId = e.getPoslastica() != null ? e.getPoslastica().getId() : null;
        return new StavkaPorudzbineDto(e.getId(), e.getRb(), e.getKolicina(),
                e.getCenaPoJedinici(), e.getPopust(), porudzbinaId, poslasticaId);
    }

    @Override
    public StavkaPorudzbine toEntity(StavkaPorudzbineDto t) {
        Porudzbina porudzbina = null;
        if (t.getPorudzbinaId() != null) {
            porudzbina = new Porudzbina();
            porudzbina.setId(t.getPorudzbinaId());
        }
        Poslastica poslastica = null;
        if (t.getPoslasticaId() != null) {
            poslastica = new Poslastica();
            poslastica.setId(t.getPoslasticaId());
        }
        return new StavkaPorudzbine(t.getId(), t.getRb(), t.getKolicina(),
                t.getCenaPoJedinici(), t.getPopust(), porudzbina, poslastica);
    }
}
