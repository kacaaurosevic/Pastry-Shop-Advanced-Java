package com.poslasticarnica.controller;

import com.poslasticarnica.dto.KorisnikDto;
import com.poslasticarnica.model.Korisnik;
import com.poslasticarnica.repository.KorisnikRepository;
import com.poslasticarnica.security.JwtUtil;
import com.poslasticarnica.service.KorisnikServis;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@CrossOrigin(origins = "http://localhost:3000")
@RestController
@RequestMapping("/api/korisnici")
public class KorisnikController {

    private final KorisnikServis korisnikServis;
    private final KorisnikRepository korisnikRepository;
    private final JwtUtil jwtUtil;

    public KorisnikController(KorisnikServis korisnikServis, KorisnikRepository korisnikRepository, JwtUtil jwtUtil) {
        this.korisnikServis = korisnikServis;
        this.korisnikRepository = korisnikRepository;
        this.jwtUtil = jwtUtil;
    }

    private boolean pozivalacJeAdmin(String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return false;
        }
        String token = authHeader.substring(7);
        if (!jwtUtil.jeValidan(token)) {
            return false;
        }
        String username = jwtUtil.izvuciUsername(token);
        Korisnik korisnik = korisnikRepository.findByUsername(username);
        return korisnik != null && "ADMIN".equals(korisnik.getUloga());
    }

    @GetMapping
    public ResponseEntity<List<KorisnikDto>> getAll() {
        return new ResponseEntity<>(korisnikServis.findAll(), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<KorisnikDto> getById(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(korisnikServis.findById(id), HttpStatus.OK);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                    "KorisnikController exception: " + ex.getMessage());
        }
    }

    @PostMapping
    public ResponseEntity<KorisnikDto> create(@Valid @RequestBody KorisnikDto dto,
                                               @RequestHeader(value = "Authorization", required = false) String authHeader) {
        if ("ADMIN".equals(dto.getUloga()) && !pozivalacJeAdmin(authHeader)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "Samo administrator može da kreira drugog administratora.");
        }
        try {
            return new ResponseEntity<>(korisnikServis.create(dto), HttpStatus.CREATED);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Greška pri čuvanju korisnika: " + ex.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<KorisnikDto> update(@PathVariable Long id, @Valid @RequestBody KorisnikDto dto,
                                               @RequestHeader(value = "Authorization", required = false) String authHeader) {
        if ("ADMIN".equals(dto.getUloga()) && !pozivalacJeAdmin(authHeader)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "Samo administrator može da postavi ADMIN ulogu.");
        }
        try {
            dto.setId(id);
            return new ResponseEntity<>(korisnikServis.update(dto), HttpStatus.OK);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Greška pri izmeni korisnika: " + ex.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        try {
            korisnikServis.deleteById(id);
            return new ResponseEntity<>("Korisnik je uspešno obrisan.", HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>("Korisnik ne postoji: " + id, HttpStatus.NOT_FOUND);
        }
    }
}
