package com.poslasticarnica.service;

import com.poslasticarnica.dto.KategorijaDto;
import com.poslasticarnica.mapper.KategorijaMapper;
import com.poslasticarnica.model.Kategorija;
import com.poslasticarnica.repository.KategorijaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class KategorijaServis {

    private final KategorijaRepository kategorijaRepository;
    private final KategorijaMapper kategorijaMapper;

    @Autowired
    public KategorijaServis(KategorijaRepository kategorijaRepository, KategorijaMapper kategorijaMapper) {
        this.kategorijaRepository = kategorijaRepository;
        this.kategorijaMapper = kategorijaMapper;
    }

    public List<KategorijaDto> findAll() {
        return kategorijaRepository.findAll()
                .stream()
                .map(kategorijaMapper::toDto)
                .collect(Collectors.toList());
    }

    public KategorijaDto findById(Long id) throws Exception {
        return kategorijaMapper.toDto(kategorijaRepository.findById(id));
    }

    public KategorijaDto create(KategorijaDto dto) {
        Kategorija kategorija = kategorijaMapper.toEntity(dto);
        kategorijaRepository.save(kategorija);
        return kategorijaMapper.toDto(kategorija);
    }

    public KategorijaDto update(KategorijaDto dto) {
        Kategorija updated = kategorijaMapper.toEntity(dto);
        kategorijaRepository.save(updated);
        return kategorijaMapper.toDto(updated);
    }

    public void deleteById(Long id) {
        kategorijaRepository.deleteById(id);
    }
}
