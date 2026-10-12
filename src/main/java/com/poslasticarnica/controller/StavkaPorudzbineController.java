package com.poslasticarnica.controller;

import com.poslasticarnica.dto.StavkaPorudzbineDto;
import com.poslasticarnica.service.StavkaPorudzbineServis;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@CrossOrigin(origins = "http://localhost:3000")
@RestController
@RequestMapping("/api/stavke-porudzbine")
public class StavkaPorudzbineController {

    private final StavkaPorudzbineServis stavkaPorudzbineServis;

    public StavkaPorudzbineController(StavkaPorudzbineServis stavkaPorudzbineServis) {
        this.stavkaPorudzbineServis = stavkaPorudzbineServis;
    }

    @GetMapping
    public ResponseEntity<List<StavkaPorudzbineDto>> getAll() {
        return new ResponseEntity<>(stavkaPorudzbineServis.findAll(), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<StavkaPorudzbineDto> getById(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(stavkaPorudzbineServis.findById(id), HttpStatus.OK);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                    "StavkaPorudzbineController exception: " + ex.getMessage());
        }
    }

    @GetMapping("/porudzbina/{porudzbinaId}")
    public ResponseEntity<List<StavkaPorudzbineDto>> getByPorudzbina(@PathVariable Long porudzbinaId) {
        return new ResponseEntity<>(stavkaPorudzbineServis.findByPorudzbina(porudzbinaId), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<StavkaPorudzbineDto> create(@Valid @RequestBody StavkaPorudzbineDto dto) {
        try {
            return new ResponseEntity<>(stavkaPorudzbineServis.create(dto), HttpStatus.CREATED);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Greška pri čuvanju stavke porudžbine: " + ex.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<StavkaPorudzbineDto> update(@PathVariable Long id, @Valid @RequestBody StavkaPorudzbineDto dto) {
        try {
            dto.setId(id);
            return new ResponseEntity<>(stavkaPorudzbineServis.update(dto), HttpStatus.OK);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Greška pri izmeni stavke porudžbine: " + ex.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        try {
            stavkaPorudzbineServis.deleteById(id);
            return new ResponseEntity<>("Stavka porudžbine je uspešno obrisana.", HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>("Stavka porudžbine ne postoji: " + id, HttpStatus.NOT_FOUND);
        }
    }
}
