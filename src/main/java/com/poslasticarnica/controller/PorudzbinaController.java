package com.poslasticarnica.controller;

import com.poslasticarnica.dto.PorudzbinaDto;
import com.poslasticarnica.service.PorudzbinaServis;
import jakarta.validation.Valid;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.io.ByteArrayOutputStream;
import java.util.List;

@CrossOrigin(origins = "http://localhost:3000")
@RestController
@RequestMapping("/api/porudzbine")
public class PorudzbinaController {

    private final PorudzbinaServis porudzbinaServis;

    public PorudzbinaController(PorudzbinaServis porudzbinaServis) {
        this.porudzbinaServis = porudzbinaServis;
    }

    @GetMapping
    public ResponseEntity<List<PorudzbinaDto>> getAll() {
        return new ResponseEntity<>(porudzbinaServis.findAll(), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PorudzbinaDto> getById(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(porudzbinaServis.findById(id), HttpStatus.OK);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                    "PorudzbinaController exception: " + ex.getMessage());
        }
    }

    @GetMapping("/korisnik/{korisnikId}")
    public ResponseEntity<List<PorudzbinaDto>> getByKorisnik(@PathVariable Long korisnikId) {
        return new ResponseEntity<>(porudzbinaServis.findByKorisnik(korisnikId), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<PorudzbinaDto> create(@Valid @RequestBody PorudzbinaDto dto) {
        try {
            return new ResponseEntity<>(porudzbinaServis.create(dto), HttpStatus.CREATED);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Greška pri čuvanju porudžbine: " + ex.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<PorudzbinaDto> update(@PathVariable Long id, @Valid @RequestBody PorudzbinaDto dto) {
        try {
            dto.setId(id);
            return new ResponseEntity<>(porudzbinaServis.update(dto), HttpStatus.OK);
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Greška pri izmeni porudžbine: " + ex.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        try {
            porudzbinaServis.deleteById(id);
            return new ResponseEntity<>("Porudžbina je uspešno obrisana.", HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>("Porudžbina ne postoji: " + id, HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/izvoz-excel")
    public ResponseEntity<byte[]> izvezuExcel() {
        try {
            List<PorudzbinaDto> sve = porudzbinaServis.findAll();

            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Porudžbine");

            Row zaglavlje = sheet.createRow(0);
            String[] kolone = {"Broj", "Datum", "ID korisnika", "Adresa dostave", "Ukupan iznos", "Status"};
            for (int i = 0; i < kolone.length; i++) {
                zaglavlje.createCell(i).setCellValue(kolone[i]);
            }

            int redBroj = 1;
            for (PorudzbinaDto p : sve) {
                Row red = sheet.createRow(redBroj++);
                red.createCell(0).setCellValue(p.getId());
                red.createCell(1).setCellValue(p.getDatumPorudzbine().toString());
                red.createCell(2).setCellValue(p.getKorisnikId());
                red.createCell(3).setCellValue(p.getAdresaDostave());
                red.createCell(4).setCellValue(p.getUkupanIznos());
                red.createCell(5).setCellValue(p.getStatusPorudzbine().toString());
            }

            for (int i = 0; i < kolone.length; i++) {
                sheet.autoSizeColumn(i);
            }

            ByteArrayOutputStream out = new ByteArrayOutputStream();
            workbook.write(out);
            workbook.close();

            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=porudzbine.xlsx");

            return ResponseEntity.ok()
                    .headers(headers)
                    .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                    .body(out.toByteArray());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
