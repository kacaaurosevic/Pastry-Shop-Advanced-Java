package com.poslasticarnica.controller;

import com.poslasticarnica.dto.KategorijaDto;
import com.poslasticarnica.service.KategorijaServis;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@CrossOrigin(origins = "http://localhost:3000")
@RestController
@RequestMapping("/api/kategorije")
public class KategorijaController {

    private final KategorijaServis kategorijaServis;

    public KategorijaController(KategorijaServis kategorijaServis) {
        this.kategorijaServis = kategorijaServis;
    }

    @GetMapping
    public ResponseEntity<List<KategorijaDto>> getAll() {
        return new ResponseEntity<>(kategorijaServis.findAll(), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<KategorijaDto> getById(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(kategorijaServis.findById(id), HttpStatus.OK);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                    "KategorijaController exception: " + ex.getMessage());
        }
    }

    @PostMapping
    public ResponseEntity<KategorijaDto> create(@Valid @RequestBody KategorijaDto dto) {
        try {
            return new ResponseEntity<>(kategorijaServis.create(dto), HttpStatus.CREATED);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Greška pri čuvanju kategorije: " + ex.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<KategorijaDto> update(@PathVariable Long id, @Valid @RequestBody KategorijaDto dto) {
        try {
            dto.setId(id);
            return new ResponseEntity<>(kategorijaServis.update(dto), HttpStatus.OK);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Greška pri izmeni kategorije: " + ex.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        try {
            kategorijaServis.deleteById(id);
            return new ResponseEntity<>("Kategorija je uspešno obrisana.", HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>("Kategorija ne postoji: " + id, HttpStatus.NOT_FOUND);
        }
    }
}
