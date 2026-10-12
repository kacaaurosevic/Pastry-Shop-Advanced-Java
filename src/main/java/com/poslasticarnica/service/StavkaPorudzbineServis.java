package com.poslasticarnica.service;

import com.poslasticarnica.dto.StavkaPorudzbineDto;
import com.poslasticarnica.mapper.StavkaPorudzbineMapper;
import com.poslasticarnica.model.StavkaPorudzbine;
import com.poslasticarnica.repository.StavkaPorudzbineRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class StavkaPorudzbineServis {

    private final StavkaPorudzbineRepository stavkaPorudzbineRepository;
    private final StavkaPorudzbineMapper stavkaPorudzbineMapper;

    @Autowired
    public StavkaPorudzbineServis(StavkaPorudzbineRepository stavkaPorudzbineRepository,
                                   StavkaPorudzbineMapper stavkaPorudzbineMapper) {
        this.stavkaPorudzbineRepository = stavkaPorudzbineRepository;
        this.stavkaPorudzbineMapper = stavkaPorudzbineMapper;
    }

    public List<StavkaPorudzbineDto> findAll() {
        return stavkaPorudzbineRepository.findAll()
                .stream()
                .map(stavkaPorudzbineMapper::toDto)
                .collect(Collectors.toList());
    }

    public StavkaPorudzbineDto findById(Long id) throws Exception {
        return stavkaPorudzbineMapper.toDto(stavkaPorudzbineRepository.findById(id));
    }

    public StavkaPorudzbineDto create(StavkaPorudzbineDto dto) {
        StavkaPorudzbine stavka = stavkaPorudzbineMapper.toEntity(dto);
        stavkaPorudzbineRepository.save(stavka);
        return stavkaPorudzbineMapper.toDto(stavka);
    }

    public StavkaPorudzbineDto update(StavkaPorudzbineDto dto) {
        StavkaPorudzbine updated = stavkaPorudzbineMapper.toEntity(dto);
        stavkaPorudzbineRepository.save(updated);
        return stavkaPorudzbineMapper.toDto(updated);
    }

    public void deleteById(Long id) {
        stavkaPorudzbineRepository.deleteById(id);
    }

    public List<StavkaPorudzbineDto> findByPorudzbina(Long porudzbinaId) {
        return stavkaPorudzbineRepository.findByPorudzbina(porudzbinaId)
                .stream()
                .map(stavkaPorudzbineMapper::toDto)
                .collect(Collectors.toList());
    }
}
