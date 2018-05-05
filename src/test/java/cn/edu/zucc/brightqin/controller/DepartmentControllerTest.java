package cn.edu.zucc.brightqin.controller;

import cn.edu.zucc.brightqin.entity.Department;
import cn.edu.zucc.brightqin.service.DepartmentService;
import cn.edu.zucc.brightqin.utils.TreeBuilder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;


@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class DepartmentControllerTest {

    @Autowired
    private DepartmentService departmentService;

    @Test
    public void main() {
        Department department = departmentService.getRootDepartment();
        if (department != null) {
            department = departmentService.getDepartmentById(department.getDepartmentId());
            TreeBuilder builder = new TreeBuilder(department);
            System.out.println();
            System.out.println();
            System.out.println(builder.build());
            System.out.println();
            System.out.println();
        } else {
            System.out.println("department is null");
        }
    }

    @Test
    public void addDepartment() {
        Department department = new Department();
        department.setDepartmentName("hello");
        departmentService.addDepartment(department);
        Department parent = departmentService.getDepartmentById(Integer.valueOf(null));
        System.out.println(parent.getDepartmentName());
    }
}