package cn.edu.zucc.brightqin.controller;

import cn.edu.zucc.brightqin.entity.Department;
import cn.edu.zucc.brightqin.entity.Person;
import cn.edu.zucc.brightqin.service.DepartmentService;
import cn.edu.zucc.brightqin.service.PersonService;
import cn.edu.zucc.brightqin.utils.PasswordUtil;
import cn.edu.zucc.brightqin.utils.PersonXml;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;


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
    public void addPerson(HttpServletRequest request, HttpServletResponse response) {
        String personName = request.getParameter("personName");
        String email = request.getParameter("email");
        String position = request.getParameter("position");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String did = request.getParameter("departmentId");
        String loginId = request.getParameter("loginId");
        try {
            personName = java.net.URLDecoder.decode(personName, "UTF-8");
            email = java.net.URLDecoder.decode(email, "UTF-8");
            position = java.net.URLDecoder.decode(position, "UTF-8");
            phone = java.net.URLDecoder.decode(phone, "UTF-8");
            address = java.net.URLDecoder.decode(address, "UTF-8");
            did = java.net.URLDecoder.decode(did, "UTF-8");
            loginId = java.net.URLDecoder.decode(loginId, "UTF-8");
            if (personService.getPersonByLoginId(loginId) != null) {
                response.getWriter().print("loginIdNotNull");
                return;
            }
            Person person = new Person();
            person.setPersonName(personName);
            person.setEmail(email);
            person.setPosition(position);
            person.setPhone(phone);
            person.setAddress(address);
            person.setPassword("25DBB8365K5K5KK71324K68093EEEDED");
            person.setLoginId(loginId);
            Department department = departmentService.getDepartmentById(Integer.valueOf(did));
            person.setDepartment(department);
            personService.addPerson(person);
        } catch (IOException e) {
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
        String password = request.getParameter("password");
        String loginId = request.getParameter("loginId");
        String manager = request.getParameter("manager");
        try (PrintWriter pw = response.getWriter()) {
            personId = java.net.URLDecoder.decode(personId, "UTF-8");
            personName = java.net.URLDecoder.decode(personName, "UTF-8");
            email = java.net.URLDecoder.decode(email, "UTF-8");
            position = java.net.URLDecoder.decode(position, "UTF-8");
            phone = java.net.URLDecoder.decode(phone, "UTF-8");
            address = java.net.URLDecoder.decode(address, "UTF-8");
            password = java.net.URLDecoder.decode(password, "UTF-8");
            loginId = java.net.URLDecoder.decode(loginId, "UTF-8");
            manager = java.net.URLDecoder.decode(manager, "UTF-8");
            Person person = personService.getPersonByLoginId(loginId);
            System.out.println("personController" + manager);
            if (person != null && !person.getPersonId().equals(Integer.valueOf(personId))) {
                pw.print("loginIdNotNull");
                return;
            }
            person = personService.getPersonById(Integer.valueOf(personId));
            if (Boolean.parseBoolean(manager)) {
                List<Person> people = personService.getPersonByDepartmentId(person.getDepartment().getDepartmentId());
                for (Person person1 : people) {
                    if (person1.isManager() && !person1.getPersonId().equals(person.getPersonId())) {
                        pw.print("ManagerIsExist");
                        return;
                    }
                }
            }
            if (!password.equals(person.getPassword())) {
                password = PasswordUtil.MD5(password);
                person.setPassword(password);
            }

            Department department = person.getDepartment();
            if (!Boolean.parseBoolean(manager)) {
                if (department.getManagerId().equals(Integer.valueOf(personId))) {
                    department.setManagerId(null);
                }
            } else {
                department.setManagerId(Integer.valueOf(personId));
            }
            departmentService.updateDepartment(department);
            person.setManager(Boolean.parseBoolean(manager));
            person.setLoginId(loginId);
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

    @RequestMapping(value = "/getPersonById")
    public void getPersonById(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        List<Person> people = new ArrayList<>();
        people.add(personService.getPersonById(Integer.valueOf(id)));
        try (PrintWriter pw = response.getWriter()) {
            PersonXml personXML = new PersonXml(people);
            pw.print(personXML.build());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/getPersonDepartmentManager")
    public void getPersonDepartmentManager(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");
        List<Person> people = personService.getPersonByDepartmentId(Integer.valueOf(id));
        Department department = departmentService.getDepartmentById(Integer.valueOf(id));
        Set<Department> departments = department.getChildDepartments();
        for (Department department1 : departments) {
            if (department1.getManagerId() != null) {
                people.add(personService.getPersonById(department1.getManagerId()));
            }
        }
        try (PrintWriter pw = response.getWriter()) {
            PersonXml personXML = new PersonXml(people);
            pw.print(personXML.build());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
