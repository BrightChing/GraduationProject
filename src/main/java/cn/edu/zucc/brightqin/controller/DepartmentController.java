package cn.edu.zucc.brightqin.controller;

import cn.edu.zucc.brightqin.entity.Department;
import cn.edu.zucc.brightqin.service.DepartmentService;
import cn.edu.zucc.brightqin.utils.TreeBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * @author brightqin
 */
@Controller
@RequestMapping(value = "/department")
public class DepartmentController {
    private final DepartmentService service;

    @Autowired
    public DepartmentController(DepartmentService service) {
        this.service = service;
    }


    /**
     * 保存部门
     */
    @RequestMapping(value = "/addDepartment", method = RequestMethod.POST)
    public void addDepartment(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("departmentName");
        String pid = request.getParameter("parentId");
        try (PrintWriter pw = response.getWriter()) {
            name = java.net.URLDecoder.decode(name, "UTF-8");
            pid = java.net.URLDecoder.decode(pid, "UTF-8");
            Department department = new Department();
            Department parent = service.getDepartmentById(Integer.valueOf(pid));
            department.setDepartment(parent);
            department.setDepartmentName(name);
            service.addDepartment(department);
            pw.print(department.getDepartmentId());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    /**
     * 删除一条数据
     */
    @RequestMapping(value = "/deleteDepartmentById")
    public void deleteDepartmentById(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        try (PrintWriter pw = response.getWriter()) {
            service.deleteDepartmentById(Integer.valueOf(id));
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    /**
     * 更新数据
     */
    @RequestMapping(value = "/updateDepartment", method = RequestMethod.POST)
    public void updateDepartment(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("departmentName");
        String id = request.getParameter("departmentId");
        try (PrintWriter pw = response.getWriter()) {
            name = java.net.URLDecoder.decode(name, "UTF-8");
            id = java.net.URLDecoder.decode(id, "UTF-8");
            Department department = service.getDepartmentById(Integer.valueOf(id));
            department.setDepartmentName(name);
            service.updateDepartment(department);
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 发送部门树
     */
    @RequestMapping(value = "/departmentTree")
    public void buildTree(HttpServletResponse response) {
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        Department department = service.getRootDepartment();
        if (department != null) {
            department = service.getDepartmentById(department.getDepartmentId());
            TreeBuilder treeBuilder = new TreeBuilder(department);
            try (PrintWriter pw = response.getWriter()) {
                pw.print(treeBuilder.build());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}

