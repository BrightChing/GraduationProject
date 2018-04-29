package cn.edu.zucc.brightqin.dao;

import cn.edu.zucc.brightqin.entity.DepartmentObject;
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
public class DepartmentObjectDAO {
    @Autowired
    private SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    public void saveObject(DepartmentObject object) {
        this.getSession().save(object);
    }

    public void deleteObject(String id) {
        this.getSession().createQuery("delete from Object where objectId = ?").setParameter(0, id).executeUpdate();
    }

    public void updateObject(DepartmentObject object) {
        this.getSession().update(object);
    }

    public DepartmentObject getObjectById(Integer id) {
        return this.getSession().get(DepartmentObject.class,id);
    }

    @SuppressWarnings("unchecked")
    public List<DepartmentObject> getObjects() {
        CriteriaQuery<DepartmentObject> criteriaQuery = this.getSession().getCriteriaBuilder().createQuery(DepartmentObject.class);
        criteriaQuery.from(DepartmentObject.class);
        return this.getSession().createQuery(criteriaQuery).getResultList();
    }
}
