package cn.edu.zucc.brightqin.graduation.service;

import cn.edu.zucc.brightqin.graduation.dao.DepartmentDAO;
import cn.edu.zucc.brightqin.graduation.entity.Department;
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
public class DepartmentService {
    private final DepartmentDAO departmentDAO;

    @Autowired
    public DepartmentService(DepartmentDAO departmentDAO) {
        this.departmentDAO = departmentDAO;
    }


    /**
     * 添加
     *
     * @param department 部门
     */
    public void addDepartment(Department department) {
        departmentDAO.addDepartment(department);
    }

    /**
     * 根据id查询
     *
     * @param id 部门ID
     * @return Department
     */
    public Department getDepartmentById(Integer id) {
        return departmentDAO.getDepartmentById(id);
    }

    /**
     * getRootDepartment
     *
     * @return Department
     */
    public Department getRootDepartment() {
        return departmentDAO.getRootDepartment();
    }

    /**
     * 更新
     *
     * @param department 部门
     */
    public void updateDepartment(Department department) {
        departmentDAO.updateDepartment(department);
    }

    /**
     * 删除
     *
     * @param id 部门ID
     */
    public void deleteDepartmentById(Integer id) {
        departmentDAO.deleteDepartmentById(id);
    }

    /**
     * 查询所有
     *
     * @return 部门列表
     */
    public List<Department> getDepartments() {
        return departmentDAO.getDepartments();
    }

}
