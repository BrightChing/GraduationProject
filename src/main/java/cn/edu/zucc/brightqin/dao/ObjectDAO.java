package cn.edu.zucc.brightqin.dao;

import cn.edu.zucc.brightqin.entity.Object;
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
public class ObjectDAO {
    @Autowired
    private SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    public void saveObject(Object object) {
        this.getSession().save(object);
    }

    public void deleteObject(String id) {
        this.getSession().createQuery("delete from Object where objectId = ?").setParameter(0, id).executeUpdate();
    }

    public void updateObject(Object object) {
        this.getSession().update(object);
    }

    public Object getObjectById(String id) {
        return (Object) this.getSession().createQuery("from Object where objectId = ?").setParameter(0, id).uniqueResult();
    }

    @SuppressWarnings("unchecked")
    public List<Object> getObjects() {
        CriteriaQuery<Object> criteriaQuery = this.getSession().getCriteriaBuilder().createQuery(Object.class);
        criteriaQuery.from(Object.class);
        return this.getSession().createQuery(criteriaQuery).getResultList();
    }
}
