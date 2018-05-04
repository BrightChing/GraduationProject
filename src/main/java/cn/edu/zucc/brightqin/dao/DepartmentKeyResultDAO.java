package cn.edu.zucc.brightqin.dao;

import cn.edu.zucc.brightqin.entity.DepartmentKeyResult;
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
public class DepartmentKeyResultDAO {
    private final SessionFactory sessionFactory;

    @Autowired
    public DepartmentKeyResultDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    public void saveKeyResult(DepartmentKeyResult keyResult) {
        this.getSession().save(keyResult);
    }

    public void deleteKeyResult(DepartmentKeyResult keyResult) {
        this.getSession().delete(keyResult);
    }

    public void updateKeyResult(DepartmentKeyResult keyResult) {
        this.getSession().update(keyResult);
    }

    public DepartmentKeyResult getKeyResultById(Integer id) {
        return this.getSession().get(DepartmentKeyResult.class, id);
    }

    @SuppressWarnings("unchecked")
    public List<DepartmentKeyResult> getKeyResults() {
        CriteriaQuery<DepartmentKeyResult> criteriaQuery = this.getSession().getCriteriaBuilder().createQuery(DepartmentKeyResult.class);
        criteriaQuery.from(DepartmentKeyResult.class);
        return this.getSession().createQuery(criteriaQuery).getResultList();
    }
}
