package cn.edu.zucc.brightqin.service;

import cn.edu.zucc.brightqin.dao.DepartmentDAO;
import cn.edu.zucc.brightqin.entity.Department;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * Description:
 * User: brightqin
 * Date: 2018-04-03
 * @author brightqin
 */
@Service
@Transactional(rollbackFor=Exception.class)
public class DepartmentService {
    @Autowired
    public final DepartmentDAO departmentDAO;

    public DepartmentService(DepartmentDAO departmentDAO) {
        this.departmentDAO = departmentDAO;
    }
    /**
     * 添加
     * @param company
     */
    public void addDepartment(Department department) {
        departmentDAO.addDepartment(department);
    }
    /**
     * 根据id查询
     * @param id
     * @return
     */
    public Department getDepartmentById(String id){
        return departmentDAO.getDepartmentById(id);
    }
    /**
     * 更新
     * @param company
     */
    public void updateDepartment(Department department) {
        departmentDAO.updateDepartment(department);
    }
    /**
     * 删除
     * @param id
     */
    public void deleteDepartmentById(String  id) {
        departmentDAO.deleteDepartmentById(id);
    }
    /**
     * 查询所有
     * @return
     */
    public List<Department> getDepartments() {
        return departmentDAO.getDepartments();
    }

}
