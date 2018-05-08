package cn.edu.zucc.brightqin.dao;

import cn.edu.zucc.brightqin.entity.DepartmentObject;
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
public class DepartmentObjectDAO {
    private final SessionFactory sessionFactory;

    @Autowired
    public DepartmentObjectDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    public void saveDepartmentObject(DepartmentObject object) {
        this.getSession().save(object);
    }

    public void deleteDepartmentObjectById(Integer id) {
        this.getSession().createQuery("delete from DepartmentObject where departmentObjectId= ?").setParameter(0, id).executeUpdate();
    }

    public void updateDepartmentObject(DepartmentObject object) {
        this.getSession().update(object);
    }

    public DepartmentObject getDepartmentObjectById(Integer id) {
        return this.getSession().get(DepartmentObject.class, id);
    }

    @SuppressWarnings("unchecked")
    public List<DepartmentObject> getDepartmentObjects() {
        CriteriaQuery<DepartmentObject> criteriaQuery = this.getSession().getCriteriaBuilder().createQuery(DepartmentObject.class);
        criteriaQuery.from(DepartmentObject.class);
        return this.getSession().createQuery(criteriaQuery).getResultList();
    }

    public List<DepartmentObject> getDepartmentObjectByDepartmentId(Integer id) {
        List list = this.getSession().createQuery("from DepartmentObject where departmentId= ?").setParameter(0, id).getResultList();
        List<DepartmentObject> objects = new ArrayList<>();
        for (Object object : list) {
            objects.add((DepartmentObject) object);
        }
        return objects;
    }

    public List<DepartmentObject> getDepartmentObjectByDepartmentId(Integer id, int month) {
        List list = this.getSession().createQuery("from DepartmentObject where departmentId = ? and month = ?  order by month")
                .setParameter(0, id).setParameter(1, month).getResultList();
        List<DepartmentObject> objects = new ArrayList<>();
        for (Object object : list) {
            objects.add((DepartmentObject) object);
        }
        return objects;
    }
}
