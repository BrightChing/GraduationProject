package cn.edu.zucc.brightqin.dao;

import cn.edu.zucc.brightqin.entity.Company;
import cn.edu.zucc.brightqin.entity.Department;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import javax.persistence.criteria.CriteriaQuery;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * Description:
 * User: brightqin
 * Date: 2018-04-11
 * Time: 19:55
 * @author brightqin
 */
@Repository
public class DepartmentDAO {
    @Resource
    SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    public void addDepartment(Department department) {
        this.getSession().save(department);
    }


    public void deleteDepartmentById(String id) {
        this.getSession().createQuery("delete from Department where departmentId=?").setParameter(0, id).executeUpdate();
    }

    public void updateDepartment(Department department) {
        this.getSession().update(department);
    }

    @SuppressWarnings("unchecked")
    public List<Department> getDepartments() {
        CriteriaQuery<Department> criteriaQuery = this.getSession().getCriteriaBuilder().createQuery(Department.class);
        criteriaQuery.from(Department.class);
        return this.getSession().createQuery(criteriaQuery).getResultList();
    }

    public Department getDepartmentById(String id) {
        return (Department) this.getSession().createQuery("from Department where departmentId = ?").setParameter(0, id).uniqueResult();
    }
}
