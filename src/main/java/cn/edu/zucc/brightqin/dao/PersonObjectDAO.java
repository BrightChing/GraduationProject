package cn.edu.zucc.brightqin.dao;

import cn.edu.zucc.brightqin.entity.PersonObject;
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
public class PersonObjectDAO {
    @Autowired
    private SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    public void saveObject(PersonObject object) {
        this.getSession().save(object);
    }

    public void deleteObject(String id) {
        this.getSession().createQuery("delete from Object where objectId = ?").setParameter(0, id).executeUpdate();
    }

    public void updateObject(PersonObject object) {
        this.getSession().update(object);
    }

    public PersonObject getObjectById(Integer id) {
        return this.getSession().get(PersonObject.class, id);
    }

    @SuppressWarnings("unchecked")
    public List<PersonObject> getObjects() {
        CriteriaQuery<PersonObject> criteriaQuery = this.getSession().getCriteriaBuilder().createQuery(PersonObject.class);
        criteriaQuery.from(PersonObject.class);
        return this.getSession().createQuery(criteriaQuery).getResultList();
    }
}
