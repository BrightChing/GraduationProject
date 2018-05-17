package cn.edu.zucc.brightqin.graduation.controller;


import cn.edu.zucc.brightqin.graduation.entity.Department;
import cn.edu.zucc.brightqin.graduation.entity.DepartmentObject;
import cn.edu.zucc.brightqin.graduation.service.DepartmentObjectService;
import cn.edu.zucc.brightqin.graduation.service.DepartmentService;
import cn.edu.zucc.brightqin.graduation.utils.DepartmentObjectXml;
import cn.edu.zucc.brightqin.graduation.utils.WightUtil;
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
        String month = request.getParameter("month");
        try (PrintWriter pw = response.getWriter()) {
            did = java.net.URLDecoder.decode(did, "UTF-8");
            objectName = java.net.URLDecoder.decode(objectName, "UTF-8");
            weight = java.net.URLDecoder.decode(weight, "UTF-8");
            month = java.net.URLDecoder.decode(month, "UTF-8");
            DepartmentObject object = new DepartmentObject();
            object.setDepartmentObjectName(objectName);
            object.setWeight(Float.parseFloat(weight));
            object.setMonth(Integer.parseInt(month));
            Department department = departmentService.getDepartmentById(Integer.valueOf(did));
            object.setDepartment(department);
            service.addDepartmentObject(object);
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
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
        try (PrintWriter pw = response.getWriter()) {
            objectId = java.net.URLDecoder.decode(objectId, "UTF-8");
            objectName = java.net.URLDecoder.decode(objectName, "UTF-8");
            weight = java.net.URLDecoder.decode(weight, "UTF-8");
            DepartmentObject object = service.getDepartmentObjectById(Integer.valueOf(objectId));
            object.setDepartmentObjectName(objectName);
            object.setWeight(Float.parseFloat(weight));
            service.updateDepartmentObject(object);
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/reviewDepartmentObject", method = RequestMethod.POST)
    public void reviewDepartmentObject(HttpServletRequest request, HttpServletResponse response) {
        String objectId = request.getParameter("objectId");
        String review = request.getParameter("review");
        try (PrintWriter pw = response.getWriter()) {
            objectId = java.net.URLDecoder.decode(objectId, "UTF-8");
            review = java.net.URLDecoder.decode(review, "UTF-8");
            DepartmentObject object = service.getDepartmentObjectById(Integer.valueOf(objectId));
            object.setReview(Boolean.parseBoolean(review));
            service.updateDepartmentObject(object);
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/getDepartmentObjectsByDepartmentId")
    public void getDepartmentObjectsByDepartmentId(HttpServletResponse response, HttpServletRequest request) {

        String id = request.getParameter("id");
        int month = Integer.parseInt(request.getParameter("month"));

        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        List<DepartmentObject> objects;

        if (month == 0) {
            objects = service.getDepartmenttObjectsByDepartmentId(Integer.valueOf(id));
        } else {
            objects = service.getDepartmenttObjectsByDepartmentId(Integer.valueOf(id), month);
        }
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
        int month = Integer.parseInt(request.getParameter("month"));
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        float weightSum = 0;
        List<DepartmentObject> objects = service.getDepartmenttObjectsByDepartmentId(Integer.valueOf(id), month);
        for (DepartmentObject object : objects) {
            weightSum += object.getWeight();
        }
        WightUtil.print(weightSum, response, "目标");
    }
}
