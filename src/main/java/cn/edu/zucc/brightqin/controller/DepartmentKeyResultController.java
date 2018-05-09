package cn.edu.zucc.brightqin.controller;


import cn.edu.zucc.brightqin.entity.DepartmentKeyResult;
import cn.edu.zucc.brightqin.entity.DepartmentObject;
import cn.edu.zucc.brightqin.service.DepartmentKeyResultService;
import cn.edu.zucc.brightqin.service.DepartmentObjectService;
import cn.edu.zucc.brightqin.utils.DepartmentKeyResultXml;
import cn.edu.zucc.brightqin.utils.WightUtil;
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
@RequestMapping(value = "departmentKeyResult")
public class DepartmentKeyResultController {
    private final DepartmentKeyResultService service;
    private final DepartmentObjectService objectService;

    @Autowired
    public DepartmentKeyResultController(DepartmentKeyResultService service, DepartmentObjectService objectService) {
        this.service = service;
        this.objectService = objectService;
    }


    /**
     * 保存添加的数据
     */
    @RequestMapping(value = "/addDepartmentKeyResult", method = RequestMethod.POST)
    public void addDepartmentKeyResult(HttpServletRequest request, HttpServletResponse response) {
        String oid = request.getParameter("objectId");
        String keyResultName = request.getParameter("keyResultName");
        String weight = request.getParameter("weight");
        try (PrintWriter pw = response.getWriter()) {
            oid = java.net.URLDecoder.decode(oid, "UTF-8");
            keyResultName = java.net.URLDecoder.decode(keyResultName, "UTF-8");
            weight = java.net.URLDecoder.decode(weight, "UTF-8");
            DepartmentObject object = objectService.getDepartmentObjectById(Integer.valueOf(oid));
            DepartmentKeyResult keyResult = new DepartmentKeyResult();
            keyResult.setDepartmentKeyResultName(keyResultName);
            keyResult.setWeight(Float.parseFloat(weight));
            keyResult.setDepartmentObject(object);
            service.addKeyResult(keyResult);
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除一条数据
     */
    @RequestMapping(value = "/deleteDepartmentKeyResultById")
    public void deleteDepartmentKeyResultById(HttpServletRequest request) {
        String id = request.getParameter("id");
        try {
            id = java.net.URLDecoder.decode(id, "UTF-8");
            service.deleteKeyResultById(Integer.valueOf(id));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

    }


    /**
     * 更新数据
     */
    @RequestMapping(value = "/updateDepartmentKeyResult", method = RequestMethod.POST)
    public void updateDepartmentKeyResult(HttpServletRequest request, HttpServletResponse response) {
        String keyResultName = request.getParameter("keyResultName");
        String keyResultId = request.getParameter("keyResultId");
        String weight = request.getParameter("weight");
        try (PrintWriter pw = response.getWriter()) {
            keyResultName = java.net.URLDecoder.decode(keyResultName, "UTF-8");
            keyResultId = java.net.URLDecoder.decode(keyResultId, "UTF-8");
            weight = java.net.URLDecoder.decode(weight, "UTF-8");
            DepartmentKeyResult keyResult = service.getKeyResultById(Integer.valueOf(keyResultId));
            keyResult.setDepartmentKeyResultName(keyResultName);
            keyResult.setWeight(Float.parseFloat(weight));
            service.updateKeyResult(keyResult);
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/getDepartmentKeyResultsByObjectId")
    public void getDepartmentKeyResultsByObjectId(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        PrintWriter pw = null;
        List<DepartmentKeyResult> keyResults = service.getDepartmentKeyResultsByDepartmentObjectId(Integer.valueOf(id));
        try {
            if (keyResults != null) {
                DepartmentKeyResultXml departmentObjectXml = new DepartmentKeyResultXml(keyResults);
                pw = response.getWriter();
                pw.print(departmentObjectXml.build());
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (pw != null) {
                pw.close();
            }
        }
    }


    @RequestMapping(value = "/checkWeight", method = RequestMethod.POST)
    public void checkWeight(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("objectId");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        float weightSum = 0;
        List<DepartmentKeyResult> results = service.getDepartmentKeyResultsByDepartmentObjectId(Integer.valueOf(id));
        for (DepartmentKeyResult result : results) {
            weightSum += result.getWeight();
        }
        WightUtil.print(weightSum, response, "关键结果");
    }
}
