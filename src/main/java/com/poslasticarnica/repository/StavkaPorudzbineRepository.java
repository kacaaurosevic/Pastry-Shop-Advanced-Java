package com.poslasticarnica.repository;

import com.poslasticarnica.model.StavkaPorudzbine;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class StavkaPorudzbineRepository implements MyAppRepository<StavkaPorudzbine, Long> {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<StavkaPorudzbine> findAll() {
        return entityManager.createQuery("SELECT s FROM StavkaPorudzbine s", StavkaPorudzbine.class)
                .getResultList();
    }

    @Override
    public StavkaPorudzbine findById(Long id) throws Exception {
        StavkaPorudzbine stavka = entityManager.find(StavkaPorudzbine.class, id);
        if (stavka == null) {
            throw new Exception("Stavka porudžbine nije pronađena!");
        }
        return stavka;
    }

    @Override
    @Transactional
    public void save(StavkaPorudzbine entity) {
        if (entity.getId() == null) {
            entityManager.persist(entity);
        } else {
            entityManager.merge(entity);
        }
    }

    @Override
    @Transactional
    public void deleteById(Long id) {
        StavkaPorudzbine stavka = entityManager.find(StavkaPorudzbine.class, id);
        if (stavka != null) {
            entityManager.remove(stavka);
        }
    }

    public List<StavkaPorudzbine> findByPorudzbina(Long porudzbinaId) {
        return entityManager.createQuery(
                "SELECT s FROM StavkaPorudzbine s WHERE s.porudzbina.id = :porudzbinaId", StavkaPorudzbine.class)
                .setParameter("porudzbinaId", porudzbinaId)
                .getResultList();
    }
}
