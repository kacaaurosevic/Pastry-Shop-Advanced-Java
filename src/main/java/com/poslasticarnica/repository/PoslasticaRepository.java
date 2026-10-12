package com.poslasticarnica.repository;

import com.poslasticarnica.model.Poslastica;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class PoslasticaRepository implements MyAppRepository<Poslastica, Long> {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Poslastica> findAll() {
        return entityManager.createQuery("SELECT p FROM Poslastica p", Poslastica.class)
                .getResultList();
    }

    @Override
    public Poslastica findById(Long id) throws Exception {
        Poslastica poslastica = entityManager.find(Poslastica.class, id);
        if (poslastica == null) {
            throw new Exception("Poslastica nije pronađena!");
        }
        return poslastica;
    }

    @Override
    @Transactional
    public void save(Poslastica entity) {
        if (entity.getId() == null) {
            entityManager.persist(entity);
        } else {
            entityManager.merge(entity);
        }
    }

    @Override
    @Transactional
    public void deleteById(Long id) {
        Poslastica poslastica = entityManager.find(Poslastica.class, id);
        if (poslastica != null) {
            entityManager.remove(poslastica);
        }
    }

    public List<Poslastica> findByKategorija(Long kategorijaId) {
        return entityManager.createQuery(
                "SELECT p FROM Poslastica p WHERE p.kategorija.id = :kategorijaId", Poslastica.class)
                .setParameter("kategorijaId", kategorijaId)
                .getResultList();
    }
}
