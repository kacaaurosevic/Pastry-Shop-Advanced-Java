package com.poslasticarnica.repository;

import com.poslasticarnica.model.Korisnik;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class KorisnikRepository implements MyAppRepository<Korisnik, Long> {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Korisnik> findAll() {
        return entityManager.createQuery("SELECT k FROM Korisnik k", Korisnik.class)
                .getResultList();
    }

    @Override
    public Korisnik findById(Long id) throws Exception {
        Korisnik korisnik = entityManager.find(Korisnik.class, id);
        if (korisnik == null) {
            throw new Exception("Korisnik nije pronađen!");
        }
        return korisnik;
    }

    @Override
    @Transactional
    public void save(Korisnik entity) {
        if (entity.getId() == null) {
            entityManager.persist(entity);
        } else {
            entityManager.merge(entity);
        }
    }

    @Override
    @Transactional
    public void deleteById(Long id) {
        Korisnik korisnik = entityManager.find(Korisnik.class, id);
        if (korisnik != null) {
            entityManager.remove(korisnik);
        }
    }

    public Korisnik findByUsername(String username) {
        List<Korisnik> rezultat = entityManager.createQuery(
                "SELECT k FROM Korisnik k WHERE k.username = :username", Korisnik.class)
                .setParameter("username", username)
                .getResultList();
        return rezultat.isEmpty() ? null : rezultat.get(0);
    }
}
