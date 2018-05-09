package cn.edu.zucc.brightqin.controller;

import cn.edu.zucc.brightqin.entity.Department;
import cn.edu.zucc.brightqin.entity.Person;
import cn.edu.zucc.brightqin.service.DepartmentService;
import cn.edu.zucc.brightqin.service.PersonService;
import cn.edu.zucc.brightqin.utils.PersonXml;
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
 * controller
 *
 * @author brightqin
 */
@Controller
@RequestMapping(value = "/person")
public class PersonController {
    private final DepartmentService departmentService;
    private final PersonService personService;

    @Autowired
    public PersonController(DepartmentService departmentService, PersonService personService) {
        this.departmentService = departmentService;
        this.personService = personService;
    }

    /**
     * 保存添加的数据
     */
    @RequestMapping(value = "/addPerson", method = RequestMethod.POST)
    public void addPerson(HttpServletRequest request) {
        String personName = request.getParameter("personName");
        String email = request.getParameter("email");
        String position = request.getParameter("position");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String did = request.getParameter("departmentId");

        try {
            personName = java.net.URLDecoder.decode(personName, "UTF-8");
            email = java.net.URLDecoder.decode(email, "UTF-8");
            position = java.net.URLDecoder.decode(position, "UTF-8");
            phone = java.net.URLDecoder.decode(phone, "UTF-8");
            address = java.net.URLDecoder.decode(address, "UTF-8");
            did = java.net.URLDecoder.decode(did, "UTF-8");
            Person person = new Person();
            person.setPersonName(personName);
            person.setEmail(email);
            person.setPosition(position);
            person.setPhone(phone);
            person.setAddress(address);
            person.setPassword("123456");
            Department department = departmentService.getDepartmentById(Integer.valueOf(did));
            person.setDepartment(department);
            personService.addPerson(person);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }


    /**
     * 删除一条数据
     */
    @RequestMapping(value = "/deletePersonById")
    public void deletePersonById(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        try (PrintWriter pw = response.getWriter()) {
            personService.deletePersonById(Integer.valueOf(id));
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    /**
     * 更新数据
     */
    @RequestMapping(value = "/updatePerson", method = RequestMethod.POST)
    public void updatePerson(HttpServletRequest request, HttpServletResponse response) {
        String personId = request.getParameter("personId");
        String personName = request.getParameter("personName");
        String email = request.getParameter("email");
        String position = request.getParameter("position");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        try (PrintWriter pw = response.getWriter()) {
            personId = java.net.URLDecoder.decode(personId, "UTF-8");
            personName = java.net.URLDecoder.decode(personName, "UTF-8");
            email = java.net.URLDecoder.decode(email, "UTF-8");
            position = java.net.URLDecoder.decode(position, "UTF-8");
            phone = java.net.URLDecoder.decode(phone, "UTF-8");
            address = java.net.URLDecoder.decode(address, "UTF-8");
            Person person = personService.getPersonById(Integer.valueOf(personId));
            person.setPersonName(personName);
            person.setEmail(email);
            person.setPosition(position);
            person.setPhone(phone);
            person.setAddress(address);
            personService.updatePerson(person);
            pw.print(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/getPeople")
    public void getPeople(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        List<Person> people = personService.getPersonByDepartmentId(Integer.valueOf(id));
        try (PrintWriter pw = response.getWriter()) {
            PersonXml personXML = new PersonXml(people);
            pw.print(personXML.build());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
