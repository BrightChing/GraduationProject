package cn.edu.zucc.brightqin.dao;


import cn.edu.zucc.brightqin.entity.PersonKeyResult;
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
public class PersonKeyResultDAO {
    @Autowired
    private SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    public void saveKeyResult(PersonKeyResult keyResult) {
        this.getSession().save(keyResult);
    }

    public void deleteKeyResult(PersonKeyResult keyResult) {
        this.getSession().delete(keyResult);
    }

    public void updateKeyResult(PersonKeyResult keyResult) {
        this.getSession().update(keyResult);
    }

    public PersonKeyResult getKeyResultById(Integer id) {
        return this.getSession().get(PersonKeyResult.class, id);
    }

    @SuppressWarnings("unchecked")
    public List<PersonKeyResult> getKeyResults() {
        CriteriaQuery<PersonKeyResult> criteriaQuery = this.getSession().getCriteriaBuilder().createQuery(PersonKeyResult.class);
        criteriaQuery.from(PersonKeyResult.class);
        return this.getSession().createQuery(criteriaQuery).getResultList();
    }
}