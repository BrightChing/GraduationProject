package cn.edu.zucc.brightqin.dao;

import cn.edu.zucc.brightqin.entity.PersonObject;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.CriteriaQuery;
import java.util.ArrayList;
import java.util.List;

/**
 * @author brightqin
 */
@Repository
public class PersonObjectDAO {
    private final SessionFactory sessionFactory;

    @Autowired
    public PersonObjectDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    public void saveObject(PersonObject object) {
        this.getSession().save(object);
    }

    public void deleteObject(Integer id) {
        this.getSession().createQuery("delete from PersonObject where personObjectId = ?").setParameter(0, id).executeUpdate();
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

    @SuppressWarnings("unchecked")
    public List<PersonObject> getObjectsByPersonId(Integer id) {
        List list = this.getSession().createQuery("from PersonObject where personId = ?").setParameter(0, id).getResultList();
        List<PersonObject> list1 = new ArrayList<>();
        for (Object object : list) {
            list1.add((PersonObject) object);
        }
        return list1;
    }
}
