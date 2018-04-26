package cn.edu.zucc.brightqin.dao;

import cn.edu.zucc.brightqin.entity.KeyResult;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.CriteriaQuery;
import java.util.List;

/**
 * @author brightqin
 */
@Repository
public class KeyResultDAO {
    @Autowired
   private SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    public void saveKeyResult(KeyResult keyResult) {
        this.getSession().save(keyResult);
    }

    public void deleteKeyResult(KeyResult keyResult) {
        this.getSession().delete(keyResult);
    }

    public void updateKeyResult(KeyResult keyResult) {
        this.getSession().update(keyResult);
    }

    public KeyResult getKeyResultById(String id) {
        return (KeyResult) this.getSession().createQuery("from KeyResult where keyResultId = ?").setParameter(0,id).uniqueResult();
    }
    @SuppressWarnings("unchecked")
    public List<KeyResult> getKeyResults() {
        CriteriaQuery<KeyResult> criteriaQuery = this.getSession().getCriteriaBuilder().createQuery(KeyResult.class);
        criteriaQuery.from(KeyResult.class);
        return this.getSession().createQuery(criteriaQuery).getResultList();
    }
}
