package com.poslasticarnica.repository;

import com.poslasticarnica.model.Porudzbina;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class PorudzbinaRepository implements MyAppRepository<Porudzbina, Long> {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Porudzbina> findAll() {
        return entityManager.createQuery("SELECT p FROM Porudzbina p", Porudzbina.class)
                .getResultList();
    }

    @Override
    public Porudzbina findById(Long id) throws Exception {
        Porudzbina porudzbina = entityManager.find(Porudzbina.class, id);
        if (porudzbina == null) {
            throw new Exception("Porudžbina nije pronađena!");
        }
        return porudzbina;
    }

    @Override
    @Transactional
    public void save(Porudzbina entity) {
        if (entity.getId() == null) {
            entityManager.persist(entity);
        } else {
            entityManager.merge(entity);
        }
    }

    @Override
    @Transactional
    public void deleteById(Long id) {
        Porudzbina porudzbina = entityManager.find(Porudzbina.class, id);
        if (porudzbina != null) {
            entityManager.remove(porudzbina);
        }
    }

    public List<Porudzbina> findByKorisnik(Long korisnikId) {
        return entityManager.createQuery(
                "SELECT p FROM Porudzbina p WHERE p.korisnik.id = :korisnikId", Porudzbina.class)
                .setParameter("korisnikId", korisnikId)
                .getResultList();
    }
}
