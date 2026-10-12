package com.poslasticarnica.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PocetnaController {

    @GetMapping("/pocetna")
    public String pocetna() {
        return "pocetna";
    }

    @GetMapping("/kategorije")
    public String kategorije() {
        return "kategorije";
    }

    @GetMapping("/admin-poslastice")
    public String adminPoslastice() {
        return "poslastice-admin";
    }

    @GetMapping("/korisnici")
    public String korisnici() {
        return "korisnici";
    }

    @GetMapping("/porudzbine")
    public String porudzbine() {
        return "porudzbine";
    }

    @GetMapping("/moje-porudzbine")
    public String mojePorudzbine() {
        return "moje-porudzbine";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/registracija")
    public String registracija() {
        return "registracija";
    }
}
