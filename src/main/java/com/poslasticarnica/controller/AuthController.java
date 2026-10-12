package com.poslasticarnica.controller;

import com.poslasticarnica.dto.KorisnikDto;
import com.poslasticarnica.dto.LoginZahtev;
import com.poslasticarnica.model.Korisnik;
import com.poslasticarnica.repository.KorisnikRepository;
import com.poslasticarnica.security.JwtUtil;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@CrossOrigin(origins = "http://localhost:3000")
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final KorisnikRepository korisnikRepository;
    private final JwtUtil jwtUtil;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public AuthController(KorisnikRepository korisnikRepository, JwtUtil jwtUtil) {
        this.korisnikRepository = korisnikRepository;
        this.jwtUtil = jwtUtil;
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@Valid @RequestBody KorisnikDto dto) {
        if (korisnikRepository.findByUsername(dto.getUsername()) != null) {
            return new ResponseEntity<>("Korisničko ime je već zauzeto.", HttpStatus.CONFLICT);
        }

        Korisnik korisnik = new Korisnik();
        korisnik.setUsername(dto.getUsername());
        korisnik.setLozinka(passwordEncoder.encode(dto.getLozinka()));
        korisnik.setEmail(dto.getEmail());
        korisnik.setIme(dto.getIme());
        korisnik.setPrezime(dto.getPrezime());
        korisnik.setUloga("KORISNIK");

        korisnikRepository.save(korisnik);

        Map<String, Object> odgovor = new HashMap<>();
        odgovor.put("poruka", "Registracija uspešna! Sada se možeš prijaviti.");
        return new ResponseEntity<>(odgovor, HttpStatus.CREATED);
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginZahtev zahtev) {
        Korisnik korisnik = korisnikRepository.findByUsername(zahtev.getUsername());

        boolean lozinkaTacna = korisnik != null && (
                passwordEncoder.matches(zahtev.getLozinka(), korisnik.getLozinka())
                        || zahtev.getLozinka().equals(korisnik.getLozinka())
        );

        if (!lozinkaTacna) {
            return new ResponseEntity<>("Pogrešno korisničko ime ili lozinka.", HttpStatus.UNAUTHORIZED);
        }

        String token = jwtUtil.generisiToken(korisnik.getUsername());

        Map<String, Object> odgovor = new HashMap<>();
        odgovor.put("token", token);
        odgovor.put("id", korisnik.getId());
        odgovor.put("username", korisnik.getUsername());
        odgovor.put("uloga", korisnik.getUloga());

        return new ResponseEntity<>(odgovor, HttpStatus.OK);
    }
}
