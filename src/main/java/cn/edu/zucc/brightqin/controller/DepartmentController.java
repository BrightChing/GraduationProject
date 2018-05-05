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
import java.io.UnsupportedEncodingException;

/**
 * Created with IntelliJ IDEA.
 * Description:
 * User: brightqin
 * Date: 2018-04-03
 *
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
        try {
            name = java.net.URLDecoder.decode(name, "UTF-8");
            pid = java.net.URLDecoder.decode(pid, "UTF-8");
            Department department = new Department();
            String flag = "null";
            if (!pid.equals(flag)) {
                Department parent = service.getDepartmentById(Integer.valueOf(pid));
                department.setDepartment(parent);
            }
            department.setDepartmentName(name);
            service.addDepartment(department);
            response.getWriter().print(department.getDepartmentId());
            System.out.println(department.getDepartmentId());
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
        service.deleteDepartmentById(Integer.valueOf(id));
    }


    /**
     * 更新数据
     */
    @RequestMapping(value = "/updateDepartment", method = RequestMethod.POST)
    public void updateDepartment(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("departmentName");
        String id = request.getParameter("departmentId");
        System.out.println("name" + name + " id:" + id);
        try {
            name = java.net.URLDecoder.decode(name, "UTF-8");
            id = java.net.URLDecoder.decode(id, "UTF-8");
            Department department = service.getDepartmentById(Integer.valueOf(id));
            department.setDepartmentName(name);
            service.updateDepartment(department);
            System.out.println("name" + name + " id:" + id);
        } catch (UnsupportedEncodingException e) {
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
        PrintWriter pw = null;
        Department department = service.getRootDepartment();
        try {
            if (department != null) {
                department = service.getDepartmentById(department.getDepartmentId());
                TreeBuilder treeBuilder = new TreeBuilder(department);
                pw = response.getWriter();
                pw.print(treeBuilder.build());
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (pw != null) {
                pw.close();
            }
        }
    }
}

