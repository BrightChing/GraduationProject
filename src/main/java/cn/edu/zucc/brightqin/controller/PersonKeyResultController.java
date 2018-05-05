package cn.edu.zucc.brightqin.controller;


import cn.edu.zucc.brightqin.entity.PersonKeyResult;
import cn.edu.zucc.brightqin.entity.PersonObject;
import cn.edu.zucc.brightqin.service.PersonKeyResultService;
import cn.edu.zucc.brightqin.service.PersonObjectService;
import cn.edu.zucc.brightqin.utils.PersonKeyResultXml;
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
    public void addPersonKeyResult(HttpServletRequest request) {
        String pid = request.getParameter("personObjectId");
        String keyResultName = request.getParameter("keyResultName");
        System.out.println(pid + "  " + keyResultName);
        try {
            pid = java.net.URLDecoder.decode(pid, "UTF-8");
            keyResultName = java.net.URLDecoder.decode(keyResultName, "UTF-8");
            PersonKeyResult result = new PersonKeyResult();
            PersonObject object = objectService.getObjectById(Integer.valueOf(pid));
            result.setPersonObject(object);
            result.setKeyResultName(keyResultName);
            service.addKeyResult(result);
        } catch (UnsupportedEncodingException e) {
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
    public void updatePersonKeyResult(HttpServletRequest request) {
        String keyResultName = request.getParameter("keyResultName");
        String id = request.getParameter("keyResultId");

        try {
            id = java.net.URLDecoder.decode(id, "UTF-8");
            keyResultName = java.net.URLDecoder.decode(keyResultName, "UTF-8");
            PersonKeyResult keyResult = service.getKeyResultById(Integer.valueOf(id));
            keyResult.setKeyResultName(keyResultName);
            service.updateKeyResult(keyResult);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/getPersonKeyResultsByObjectId")
    public void getPersonKeyResultsByObjectId(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        PrintWriter pw = null;
        List<PersonKeyResult> personKeyResults = service.getKeyResultsByObjectId(Integer.valueOf(id));
        try {
            if (personKeyResults != null) {
                PersonKeyResultXml resultXml = new PersonKeyResultXml(personKeyResults);
                pw = response.getWriter();
                pw.print(resultXml.build());
                System.out.println(resultXml.build());
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
