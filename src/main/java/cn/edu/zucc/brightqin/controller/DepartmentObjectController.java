package cn.edu.zucc.brightqin.controller;


import cn.edu.zucc.brightqin.entity.Department;
import cn.edu.zucc.brightqin.entity.DepartmentObject;
import cn.edu.zucc.brightqin.service.DepartmentObjectService;
import cn.edu.zucc.brightqin.service.DepartmentService;
import cn.edu.zucc.brightqin.utils.DepartmentObjectXml;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.List;

/**
 * @author brightqin
 */

@Controller
@RequestMapping(value = "departmentObject")
public class DepartmentObjectController {
    private final DepartmentObjectService service;
    private final DepartmentService departmentService;

    @Autowired
    public DepartmentObjectController(DepartmentObjectService service, DepartmentService departmentService) {
        this.service = service;
        this.departmentService = departmentService;
    }

    /**
     * 保存添加的数据
     */
    @RequestMapping(value = "/addDepartmentObject", method = RequestMethod.POST)
    public void addDepartmentObject(HttpServletRequest request, HttpServletResponse response) {
        String did = request.getParameter("departmentId");
        String objectName = request.getParameter("objectName");
        String weight = request.getParameter("weight");
        PrintWriter pw = null;
        try {
            did = java.net.URLDecoder.decode(did, "UTF-8");
            objectName = java.net.URLDecoder.decode(objectName, "UTF-8");
            weight = java.net.URLDecoder.decode(weight, "UTF-8");
            DepartmentObject object = new DepartmentObject();
            object.setDepartmentObjectName(objectName);
            object.setWeight(Float.parseFloat(weight));
            Department department = departmentService.getDepartmentById(Integer.valueOf(did));
            object.setDepartment(department);
            service.addDepartmentObject(object);
            pw = response.getWriter();
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (pw != null) {
                pw.close();
            }
        }


    }


    /**
     * 删除一条数据
     */
    @RequestMapping(value = "/deleteDepartmentObjectById")
    public void deletePersonObjectById(HttpServletRequest request) {
        String id = request.getParameter("id");
        try {
            id = java.net.URLDecoder.decode(id, "UTF-8");
            service.deleteDepartmentObjectById(Integer.valueOf(id));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }


    /**
     * 更新数据
     */
    @RequestMapping(value = "/updateDepartmentObject", method = RequestMethod.POST)
    public void updateDepartmentObject(HttpServletRequest request, HttpServletResponse response) {
        String objectName = request.getParameter("objectName");
        String objectId = request.getParameter("objectId");
        String weight = request.getParameter("weight");
        try {
            objectId = java.net.URLDecoder.decode(objectId, "UTF-8");
            objectName = java.net.URLDecoder.decode(objectName, "UTF-8");
            weight = java.net.URLDecoder.decode(weight, "UTF-8");
            DepartmentObject object = service.getDepartmentObjectById(Integer.valueOf(objectId));
            object.setDepartmentObjectName(objectName);
            service.updateDepartmentObject(object);
            object.setWeight(Float.parseFloat(weight));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        try (PrintWriter pw = response.getWriter()) {
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/getDepartmentObjectsByDepartmentId")
    public void getDepartmentObjectsByDepartmentId(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        List<DepartmentObject> objects = service.getDepartmenttObjectsByDepartmentId(Integer.valueOf(id));
        if (objects != null) {
            DepartmentObjectXml departmentObjectXml = new DepartmentObjectXml(objects);
            try (PrintWriter pw = response.getWriter()) {
                pw.print(departmentObjectXml.build());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @RequestMapping(value = "/checkWeight", method = RequestMethod.POST)
    public void checkWeight(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("departmentId");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        float weightSum = 0;
        List<DepartmentObject> objects = service.getDepartmenttObjectsByDepartmentId(Integer.valueOf(id));
        for (DepartmentObject object : objects) {
            weightSum += object.getWeight();
        }
        try (PrintWriter pw = response.getWriter()) {
            pw.print(weightSum);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
