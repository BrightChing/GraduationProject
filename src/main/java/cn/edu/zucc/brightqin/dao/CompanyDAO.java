package cn.edu.zucc.brightqin.dao;

import cn.edu.zucc.brightqin.entity.Company;
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
 *
 * @author brightqin
 */
@Repository
public class CompanyDAO {
    @Resource
    private SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    public void addCompany(Company company) {
        this.getSession().save(company);
    }

    public void deleteCompanyById(String id) {
        this.getSession().createQuery("delete from Company where companyId=?").setParameter(0, id).executeUpdate();
    }

    public void updateCompany(Company company) {
        this.getSession().update(company);
    }

    public Company getCompanyById(String id) {
        return (Company) this.getSession().createQuery("from Company where companyId = ?").setParameter(0, id).uniqueResult();
    }

    @SuppressWarnings("unchecked")
    public List<Company> getCompanies() {
        CriteriaQuery<Company> criteriaQuery = this.getSession().getCriteriaBuilder().createQuery(Company.class);
        criteriaQuery.from(Company.class);
        return this.getSession().createQuery(criteriaQuery).getResultList();
    }
}
