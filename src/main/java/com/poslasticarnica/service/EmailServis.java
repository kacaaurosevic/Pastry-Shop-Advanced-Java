package com.poslasticarnica.service;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailServis {

    private final JavaMailSender mailSender;

    public EmailServis(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void posaljiPotvrduPorudzbine(String primaocEmail, Long brojPorudzbine, Double ukupanIznos) {
        SimpleMailMessage poruka = new SimpleMailMessage();
        poruka.setTo(primaocEmail);
        poruka.setFrom("porudzbine@poslasticarnica.rs");
        poruka.setSubject("Potvrda porudžbine #" + brojPorudzbine);
        poruka.setText(
                "Poštovani,\n\n" +
                "Vaša porudžbina broj " + brojPorudzbine + " je uspešno primljena.\n" +
                "Ukupan iznos: " + ukupanIznos + " din.\n\n" +
                "Hvala Vam na poverenju!\nPoslastičarnica"
        );
        mailSender.send(poruka);
    }
}
