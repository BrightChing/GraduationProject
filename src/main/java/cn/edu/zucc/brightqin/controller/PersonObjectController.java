package cn.edu.zucc.brightqin.controller;


import cn.edu.zucc.brightqin.entity.PersonObject;
import cn.edu.zucc.brightqin.service.PersonObjectService;
import cn.edu.zucc.brightqin.utils.PersonObjectXml;
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
@RequestMapping(value = "/personObject")
public class PersonObjectController {
    @Autowired
    private PersonObjectService service;

    /**
     * 保存添加的数据
     */
    @RequestMapping(value = "/addPersonObject", method = RequestMethod.POST)
    public void addPersonObject(HttpServletRequest request) {

    }


    /**
     * 删除一条数据
     */
    @RequestMapping(value = "/deletePersonObjectById")
    public void deletePersonObjectById(HttpServletRequest request) {
        String id = request.getParameter("id");
        service.deleteObject(Integer.valueOf(id));
    }


    /**
     * 更新数据
     */
    @RequestMapping(value = "/updatePersonObject", method = RequestMethod.POST)
    public void updatePersonObject(HttpServletRequest request, HttpServletResponse response) {

    }

    @RequestMapping(value = "/getPersonObjects")
    public void getPersonObjects(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        PrintWriter pw = null;
        List<PersonObject> personObjects = service.getObjectsByPersonId(Integer.valueOf(id));
        try {
            if (personObjects != null) {
                PersonObjectXml personObjectXml = new PersonObjectXml(personObjects);
                pw = response.getWriter();
                pw.print(personObjectXml.build());
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
