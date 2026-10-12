package com.poslasticarnica.controller;

import com.poslasticarnica.dto.PoslasticaDto;
import com.poslasticarnica.service.PoslasticaServis;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@CrossOrigin(origins = "http://localhost:3000")
@RestController
@RequestMapping("/api/poslastice")
public class PoslasticaController {

    private final PoslasticaServis poslasticaServis;

    public PoslasticaController(PoslasticaServis poslasticaServis) {
        this.poslasticaServis = poslasticaServis;
    }

    @GetMapping
    public ResponseEntity<List<PoslasticaDto>> getAll() {
        return new ResponseEntity<>(poslasticaServis.findAll(), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PoslasticaDto> getById(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(poslasticaServis.findById(id), HttpStatus.OK);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                    "PoslasticaController exception: " + ex.getMessage());
        }
    }

    @GetMapping("/kategorija/{kategorijaId}")
    public ResponseEntity<List<PoslasticaDto>> getByKategorija(@PathVariable Long kategorijaId) {
        return new ResponseEntity<>(poslasticaServis.findByKategorija(kategorijaId), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<PoslasticaDto> create(@Valid @RequestBody PoslasticaDto dto) {
        try {
            return new ResponseEntity<>(poslasticaServis.create(dto), HttpStatus.CREATED);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Greška pri čuvanju poslastice: " + ex.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<PoslasticaDto> update(@PathVariable Long id, @Valid @RequestBody PoslasticaDto dto) {
        try {
            dto.setId(id);
            return new ResponseEntity<>(poslasticaServis.update(dto), HttpStatus.OK);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Greška pri izmeni poslastice: " + ex.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        try {
            poslasticaServis.deleteById(id);
            return new ResponseEntity<>("Poslastica je uspešno obrisana.", HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(
                "Ne može se obrisati poslastica sa id " + id + " - verovatno je povezana sa postojećom porudžbinom.",
                HttpStatus.CONFLICT);
        }
    }
}
