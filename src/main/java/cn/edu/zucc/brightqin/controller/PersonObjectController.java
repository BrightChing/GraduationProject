package cn.edu.zucc.brightqin.controller;


import cn.edu.zucc.brightqin.entity.Person;
import cn.edu.zucc.brightqin.entity.PersonObject;
import cn.edu.zucc.brightqin.service.PersonObjectService;
import cn.edu.zucc.brightqin.service.PersonService;
import cn.edu.zucc.brightqin.utils.PersonObjectXml;
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
    public void addPersonObject(HttpServletRequest request, HttpServletResponse response) {
        String pid = request.getParameter("personId");
        String objectName = request.getParameter("objectName");
        String weight = request.getParameter("weight");
        String month = request.getParameter("month");
        try {
            pid = java.net.URLDecoder.decode(pid, "UTF-8");
            objectName = java.net.URLDecoder.decode(objectName, "UTF-8");
            weight = java.net.URLDecoder.decode(weight, "UTF-8");
            month = java.net.URLDecoder.decode(month, "UTF-8");
            PersonObject object = new PersonObject();
            Person person = personService.getPersonById(Integer.valueOf(pid));
            object.setPerson(person);
            object.setMonth(Integer.parseInt(month));
            object.setWeight(Float.parseFloat(weight));
            object.setPersonObjectName(objectName);
            service.addObject(object);
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
        String id = request.getParameter("objectId");
        String objectName = request.getParameter("objectName");
        String weight = request.getParameter("weight");
        try {
            objectName = java.net.URLDecoder.decode(objectName, "UTF-8");
            id = java.net.URLDecoder.decode(id, "UTF-8");
            weight = java.net.URLDecoder.decode(weight, "UTF-8");
            PersonObject object = service.getObjectById(Integer.valueOf(id));
            object.setPersonObjectName(objectName);
            object.setWeight(Float.parseFloat(weight));
            service.updateObject(object);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        try (PrintWriter pw = response.getWriter()) {
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/reviewPersonObject", method = RequestMethod.POST)
    public void reviewPersonObject(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("objectId");
        String review = request.getParameter("review");
        try {
            id = java.net.URLDecoder.decode(id, "UTF-8");
            review = java.net.URLDecoder.decode(review, "UTF-8");
            PersonObject object = service.getObjectById(Integer.valueOf(id));
            object.setReview(Boolean.parseBoolean(review));
            service.updateObject(object);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        try (PrintWriter pw = response.getWriter()) {
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/getPersonObjects")
    public void getPersonObjects(HttpServletResponse response, HttpServletRequest request) {
        Integer id = Integer.valueOf(request.getParameter("id"));
        int month = Integer.parseInt(request.getParameter("month"));
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        List<PersonObject> objects;
        if (month == 0) {
            objects = service.getObjectsByPersonId(id);
        } else {
            objects = service.getObjectsByPersonIdAndMonth(id, month);
        }
        if (objects != null) {
            PersonObjectXml personObjectXml = new PersonObjectXml(objects);
            try (PrintWriter pw = response.getWriter()) {
                pw.print(personObjectXml.build());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @RequestMapping(value = "/checkWeight", method = RequestMethod.POST)
    public void checkWeight(HttpServletResponse response, HttpServletRequest request) {
        float weightSum = 0;
        String id = request.getParameter("personId");
        String month = request.getParameter("month");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        List<PersonObject> objects = service.getObjectsByPersonIdAndMonth(Integer.valueOf(id), Integer.parseInt(month));
        for (PersonObject object : objects) {
            weightSum += object.getWeight();
        }
        WightUtil.print(weightSum, response, "目标");
    }
}
