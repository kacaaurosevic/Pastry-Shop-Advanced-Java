package com.poslasticarnica.service;

import com.poslasticarnica.dto.PorudzbinaDto;
import com.poslasticarnica.mapper.PorudzbinaMapper;
import com.poslasticarnica.model.Korisnik;
import com.poslasticarnica.model.Porudzbina;
import com.poslasticarnica.repository.KorisnikRepository;
import com.poslasticarnica.repository.PorudzbinaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class PorudzbinaServis {

    private final PorudzbinaRepository porudzbinaRepository;
    private final PorudzbinaMapper porudzbinaMapper;
    private final KorisnikRepository korisnikRepository;
    private final EmailServis emailServis;

    @Autowired
    public PorudzbinaServis(PorudzbinaRepository porudzbinaRepository, PorudzbinaMapper porudzbinaMapper,
            KorisnikRepository korisnikRepository, EmailServis emailServis) {
        this.porudzbinaRepository = porudzbinaRepository;
        this.porudzbinaMapper = porudzbinaMapper;
        this.korisnikRepository = korisnikRepository;
        this.emailServis = emailServis;
    }

    public List<PorudzbinaDto> findAll() {
        return porudzbinaRepository.findAll()
                .stream()
                .map(porudzbinaMapper::toDto)
                .collect(Collectors.toList());
    }

    public PorudzbinaDto findById(Long id) throws Exception {
        return porudzbinaMapper.toDto(porudzbinaRepository.findById(id));
    }

    public PorudzbinaDto create(PorudzbinaDto dto) {
        Porudzbina porudzbina = porudzbinaMapper.toEntity(dto);
        porudzbinaRepository.save(porudzbina);

        try {
            Korisnik korisnik = korisnikRepository.findById(dto.getKorisnikId());
            if (korisnik.getEmail() != null) {
                emailServis.posaljiPotvrduPorudzbine(korisnik.getEmail(), porudzbina.getId(), porudzbina.getUkupanIznos());
            }
        } catch (Exception ex) {
            System.out.println("Slanje mejla nije uspelo: " + ex.getMessage());
        }

        return porudzbinaMapper.toDto(porudzbina);
    }

    public PorudzbinaDto update(PorudzbinaDto dto) throws Exception {
        // Učitavamo postojeću porudžbinu da izmenom ne bismo obrisali njene stavke
        Porudzbina postojeca = porudzbinaRepository.findById(dto.getId());
        Porudzbina izmenjena = porudzbinaMapper.toEntity(dto);

        postojeca.setDatumPorudzbine(izmenjena.getDatumPorudzbine());
        postojeca.setStatusPorudzbine(izmenjena.getStatusPorudzbine());
        postojeca.setUkupanIznos(izmenjena.getUkupanIznos());
        postojeca.setAdresaDostave(izmenjena.getAdresaDostave());
        postojeca.setNapomena(izmenjena.getNapomena());
        if (izmenjena.getKorisnik() != null) {
            postojeca.setKorisnik(izmenjena.getKorisnik());
        }

        porudzbinaRepository.save(postojeca);
        return porudzbinaMapper.toDto(postojeca);
    }

    public void deleteById(Long id) {
        porudzbinaRepository.deleteById(id);
    }

    public List<PorudzbinaDto> findByKorisnik(Long korisnikId) {
        return porudzbinaRepository.findByKorisnik(korisnikId)
                .stream()
                .map(porudzbinaMapper::toDto)
                .collect(Collectors.toList());
    }
}
