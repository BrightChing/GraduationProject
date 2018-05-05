package cn.edu.zucc.brightqin.controller;


import cn.edu.zucc.brightqin.entity.Person;
import cn.edu.zucc.brightqin.entity.PersonObject;
import cn.edu.zucc.brightqin.service.PersonObjectService;
import cn.edu.zucc.brightqin.service.PersonService;
import cn.edu.zucc.brightqin.utils.PersonObjectXml;
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
@RequestMapping(value = "/personObject")
public class PersonObjectController {
    private final PersonObjectService service;
    private final PersonService personService;

    @Autowired
    public PersonObjectController(PersonObjectService service, PersonService personService) {
        this.service = service;
        this.personService = personService;
    }

    /**
     * 保存添加的数据
     */
    @RequestMapping(value = "/addPersonObject", method = RequestMethod.POST)
    public void addPersonObject(HttpServletRequest request) {
        String pid = request.getParameter("personId");
        String objectName = request.getParameter("objectName");
        try {
            pid = java.net.URLDecoder.decode(pid, "UTF-8");
            objectName = java.net.URLDecoder.decode(objectName, "UTF-8");
            PersonObject object = new PersonObject();
            Person person = personService.getPersonById(Integer.valueOf(pid));
            object.setPerson(person);
            object.setPersonObjectName(objectName);
            service.addObject(object);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
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
    public void updatePersonObject(HttpServletRequest request) {
        String id = request.getParameter("objectId");
        String objectName = request.getParameter("objectName");
        try {
            objectName = java.net.URLDecoder.decode(objectName, "UTF-8");
            id = java.net.URLDecoder.decode(id, "UTF-8");
            PersonObject object = service.getObjectById(Integer.valueOf(id));
            object.setPersonObjectName(objectName);
            service.updateObject(object);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

    }

    @RequestMapping(value = "/getPersonObjects")
    public void getPersonObjects(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        PrintWriter pw = null;
        List<PersonObject> objects = service.getObjectsByPersonId(Integer.valueOf(id));
        try {
            if (objects != null) {
                PersonObjectXml personObjectXml = new PersonObjectXml(objects);
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
