package cn.edu.zucc.brightqin.graduation.controller;

import cn.edu.zucc.brightqin.graduation.entity.Department;
import cn.edu.zucc.brightqin.graduation.entity.DepartmentKeyResult;
import cn.edu.zucc.brightqin.graduation.entity.DepartmentObject;
import cn.edu.zucc.brightqin.graduation.service.DepartmentKeyResultService;
import cn.edu.zucc.brightqin.graduation.service.DepartmentObjectService;
import cn.edu.zucc.brightqin.graduation.service.DepartmentService;
import cn.edu.zucc.brightqin.graduation.utils.ChartXml;
import cn.edu.zucc.brightqin.graduation.utils.TreeBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * @author brightqin
 */
@Controller
@RequestMapping(value = "/department")
public class DepartmentController {
    private final DepartmentService service;
    private final DepartmentObjectService departmentObjectService;
    private final DepartmentKeyResultService departmentKeyResultService;

    @Autowired
    public DepartmentController(DepartmentService service, DepartmentObjectService departmentObjectService,
                                DepartmentKeyResultService departmentKeyResultService) {
        this.service = service;
        this.departmentObjectService = departmentObjectService;
        this.departmentKeyResultService = departmentKeyResultService;
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
            TreeBuilder treeBuilder = new TreeBuilder(department);
            try (PrintWriter pw = response.getWriter()) {
                pw.print(treeBuilder.build());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @RequestMapping(value = "/departmentTreeTwo")
    public void departmentTreeTwo(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        Department department = service.getDepartmentById(Integer.valueOf(id));
        TreeBuilder treeBuilder = new TreeBuilder(department);
        try (PrintWriter pw = response.getWriter()) {
            pw.print(treeBuilder.buildTwo());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/departmentTreeThree")
    public void departmentTreeThree(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        Department department = service.getDepartmentById(Integer.valueOf(id));
        TreeBuilder treeBuilder = new TreeBuilder(department);
        try (PrintWriter pw = response.getWriter()) {
            pw.print(treeBuilder.buildThree());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/departmentTreeFour")
    public void departmentTreeFour(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        Department department = service.getDepartmentById(Integer.valueOf(id));
        TreeBuilder treeBuilder = new TreeBuilder(department);
        try (PrintWriter pw = response.getWriter()) {
            pw.print(treeBuilder.buildFour());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/departmentChart")
    public void departmentChart(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        float[] month = new float[13];
        for (int i = 1; i < month.length; i++) {
            month[i] = score(Integer.valueOf(id), i);
        }
        ChartXml chartXml = new ChartXml(month);
        try (PrintWriter pw = response.getWriter()) {
            pw.print(chartXml.build());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private float score(Integer id, int month) {
        List<DepartmentObject> departmentObjects = departmentObjectService.getDepartmenttObjectsByDepartmentId(id, month);
        float objectScore = 0;
        for (DepartmentObject object : departmentObjects) {
            List<DepartmentKeyResult> departmentKeyResults = departmentKeyResultService.getDepartmentKeyResultsByDepartmentObjectId(object.getDepartmentObjectId());
            float resultScore = 0;
            for (DepartmentKeyResult result : departmentKeyResults) {
                resultScore += (result.getSelfScore() + result.getUpstreamScore()) * result.getWeight() / 200;
            }
            objectScore += resultScore * object.getWeight() / 100;
        }
        return objectScore;
    }
}

