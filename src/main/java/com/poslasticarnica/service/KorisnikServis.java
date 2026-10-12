package com.poslasticarnica.service;

import com.poslasticarnica.dto.KorisnikDto;
import com.poslasticarnica.mapper.KorisnikMapper;
import com.poslasticarnica.model.Korisnik;
import com.poslasticarnica.repository.KorisnikRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class KorisnikServis {

    private final KorisnikRepository korisnikRepository;
    private final KorisnikMapper korisnikMapper;

    @Autowired
    public KorisnikServis(KorisnikRepository korisnikRepository, KorisnikMapper korisnikMapper) {
        this.korisnikRepository = korisnikRepository;
        this.korisnikMapper = korisnikMapper;
    }

    public List<KorisnikDto> findAll() {
        return korisnikRepository.findAll()
                .stream()
                .map(korisnikMapper::toDto)
                .collect(Collectors.toList());
    }

    public KorisnikDto findById(Long id) throws Exception {
        return korisnikMapper.toDto(korisnikRepository.findById(id));
    }

    public KorisnikDto create(KorisnikDto dto) {
        Korisnik korisnik = korisnikMapper.toEntity(dto);
        korisnikRepository.save(korisnik);
        return korisnikMapper.toDto(korisnik);
    }

    public KorisnikDto update(KorisnikDto dto) {
        Korisnik updated = korisnikMapper.toEntity(dto);
        korisnikRepository.save(updated);
        return korisnikMapper.toDto(updated);
    }

    public void deleteById(Long id) {
        korisnikRepository.deleteById(id);
    }
}
