package cn.edu.zucc.brightqin.graduation.dao;

import cn.edu.zucc.brightqin.graduation.entity.DepartmentKeyResult;
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

    public void deleteKeyResultById(Integer id) {
        this.getSession().createQuery("delete DepartmentKeyResult where departmentKeyResultId = ?").setParameter(0, id).executeUpdate();
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

    @SuppressWarnings("unchecked")
    public List<DepartmentKeyResult> getDepartmentKeyResultsByDepartmentObjectId(Integer id) {
        List list = this.getSession().createQuery("from DepartmentKeyResult  where departmentObjectId = ?").setParameter(0, id).getResultList();
        List<DepartmentKeyResult> keyResults = new ArrayList<>();
        for (Object result : list) {
            keyResults.add((DepartmentKeyResult) result);
        }
        return keyResults;
    }
}
