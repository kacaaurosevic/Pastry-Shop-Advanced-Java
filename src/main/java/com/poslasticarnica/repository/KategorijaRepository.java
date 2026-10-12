package com.poslasticarnica.repository;

import com.poslasticarnica.model.Kategorija;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class KategorijaRepository implements MyAppRepository<Kategorija, Long> {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Kategorija> findAll() {
        return entityManager.createQuery("SELECT k FROM Kategorija k", Kategorija.class)
                .getResultList();
    }

    @Override
    public Kategorija findById(Long id) throws Exception {
        Kategorija kategorija = entityManager.find(Kategorija.class, id);
        if (kategorija == null) {
            throw new Exception("Kategorija nije pronađena!");
        }
        return kategorija;
    }

    @Override
    @Transactional
    public void save(Kategorija entity) {
        if (entity.getId() == null) {
            entityManager.persist(entity);
        } else {
            entityManager.merge(entity);
        }
    }

    @Override
    @Transactional
    public void deleteById(Long id) {
        Kategorija kategorija = entityManager.find(Kategorija.class, id);
        if (kategorija != null) {
            entityManager.remove(kategorija);
        }
    }
}
