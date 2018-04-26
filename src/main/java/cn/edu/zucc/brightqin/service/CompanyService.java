package cn.edu.zucc.brightqin.service;

import cn.edu.zucc.brightqin.dao.CompanyDAO;
import cn.edu.zucc.brightqin.entity.Company;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * Description:
 * User: brightqin
 * Date: 2018-04-03
 *
 * @author brightqin
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class CompanyService {
    private final CompanyDAO companyDAO;

    @Autowired
    public CompanyService(CompanyDAO companyDAO) {
        this.companyDAO = companyDAO;
    }

    /**
     * 添加
     *
     * @param company 公司
     */
    public void addCompany(Company company) {
        companyDAO.addCompany(company);
    }

    /**
     * 根据id查询
     *
     * @param id 公司ID
     * @return Company
     */
    public Company getCompanyById(String id) {
        return companyDAO.getCompanyById(id);
    }

    /**
     * 更新
     *
     * @param company 公司
     */
    public void updateCompany(Company company) {
        companyDAO.updateCompany(company);
    }

    /**
     * 删除
     *
     * @param id 公司ID
     */
    public void deleteCompanyById(String id) {
        companyDAO.deleteCompanyById(id);
    }

    /**
     * 查询
     *
     * @return List<Company>
     */
    public List<Company> getCompanies() {
        return companyDAO.getCompanies();
    }
}
