package com.poslasticarnica.service;

import com.poslasticarnica.dto.PoslasticaDto;
import com.poslasticarnica.mapper.PoslasticaMapper;
import com.poslasticarnica.model.Poslastica;
import com.poslasticarnica.repository.PoslasticaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class PoslasticaServis {

    private final PoslasticaRepository poslasticaRepository;
    private final PoslasticaMapper poslasticaMapper;

    @Autowired
    public PoslasticaServis(PoslasticaRepository poslasticaRepository, PoslasticaMapper poslasticaMapper) {
        this.poslasticaRepository = poslasticaRepository;
        this.poslasticaMapper = poslasticaMapper;
    }

    public List<PoslasticaDto> findAll() {
        return poslasticaRepository.findAll()
                .stream()
                .map(poslasticaMapper::toDto)
                .collect(Collectors.toList());
    }

    public PoslasticaDto findById(Long id) throws Exception {
        return poslasticaMapper.toDto(poslasticaRepository.findById(id));
    }

    public PoslasticaDto create(PoslasticaDto dto) {
        Poslastica poslastica = poslasticaMapper.toEntity(dto);
        poslasticaRepository.save(poslastica);
        return poslasticaMapper.toDto(poslastica);
    }

    public PoslasticaDto update(PoslasticaDto dto) {
        Poslastica updated = poslasticaMapper.toEntity(dto);
        poslasticaRepository.save(updated);
        return poslasticaMapper.toDto(updated);
    }

    public void deleteById(Long id) {
        poslasticaRepository.deleteById(id);
    }

    public List<PoslasticaDto> findByKategorija(Long kategorijaId) {
        return poslasticaRepository.findByKategorija(kategorijaId)
                .stream()
                .map(poslasticaMapper::toDto)
                .collect(Collectors.toList());
    }
}
