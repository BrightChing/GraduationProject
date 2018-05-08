package cn.edu.zucc.brightqin.controller;


import cn.edu.zucc.brightqin.entity.PersonKeyResult;
import cn.edu.zucc.brightqin.entity.PersonObject;
import cn.edu.zucc.brightqin.service.PersonKeyResultService;
import cn.edu.zucc.brightqin.service.PersonObjectService;
import cn.edu.zucc.brightqin.utils.PersonKeyResultXml;
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
@RequestMapping(value = "/personKeyResult")
public class PersonKeyResultController {
    private final PersonKeyResultService service;
    private final PersonObjectService objectService;

    @Autowired
    public PersonKeyResultController(PersonKeyResultService service, PersonObjectService objectService) {
        this.service = service;
        this.objectService = objectService;
    }

    /**
     * 保存添加的数据
     */
    @RequestMapping(value = "/addPersonKeyResult", method = RequestMethod.POST)
    public void addPersonKeyResult(HttpServletRequest request, HttpServletResponse response) {
        String pid = request.getParameter("personObjectId");
        String keyResultName = request.getParameter("keyResultName");
        String weight = request.getParameter("weight");
        try {
            pid = java.net.URLDecoder.decode(pid, "UTF-8");
            weight = java.net.URLDecoder.decode(weight, "UTF-8");
            keyResultName = java.net.URLDecoder.decode(keyResultName, "UTF-8");
            PersonKeyResult result = new PersonKeyResult();
            PersonObject object = objectService.getObjectById(Integer.valueOf(pid));
            result.setPersonObject(object);
            result.setWeight(Float.parseFloat(weight));
            result.setKeyResultName(keyResultName);
            service.addKeyResult(result);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        try (PrintWriter pw = response.getWriter()) {
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除一条数据
     */
    @RequestMapping(value = "/deletePersonKeyResultById")
    public void deletePersonKeyResultById(HttpServletRequest request) {
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
    @RequestMapping(value = "/updatePersonKeyResult", method = RequestMethod.POST)
    public void updatePersonKeyResult(HttpServletRequest request, HttpServletResponse response) {
        String keyResultName = request.getParameter("keyResultName");
        String id = request.getParameter("keyResultId");
        String weight = request.getParameter("weight");
        try {
            weight = java.net.URLDecoder.decode(weight, "UTF-8");
            id = java.net.URLDecoder.decode(id, "UTF-8");
            keyResultName = java.net.URLDecoder.decode(keyResultName, "UTF-8");
            PersonKeyResult result = service.getKeyResultById(Integer.valueOf(id));
            result.setKeyResultName(keyResultName);
            result.setWeight(Float.parseFloat(weight));
            service.updateKeyResult(result);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        try (PrintWriter pw = response.getWriter()) {
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/getPersonKeyResultsByObjectId")
    public void getPersonKeyResultsByObjectId(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        List<PersonKeyResult> personKeyResults = service.getKeyResultsByObjectId(Integer.valueOf(id));
        if (personKeyResults != null) {
            PersonKeyResultXml resultXml = new PersonKeyResultXml(personKeyResults);
            try (PrintWriter pw = response.getWriter()) {
                pw.print(resultXml.build());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @RequestMapping(value = "/checkWeight", method = RequestMethod.POST)
    public void checkWeight(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("personObjectId");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        float weightSum = 0;
        List<PersonKeyResult> results = service.getKeyResultsByObjectId(Integer.valueOf(id));
        for (PersonKeyResult result : results) {
            weightSum += result.getWeight();
        }
        WightUtil.print(weightSum, response, "关键结果");
    }
}
