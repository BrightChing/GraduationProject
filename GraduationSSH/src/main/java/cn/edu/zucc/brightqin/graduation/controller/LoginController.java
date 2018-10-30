package cn.edu.zucc.brightqin.graduation.controller;


import cn.edu.zucc.brightqin.graduation.entity.Person;
import cn.edu.zucc.brightqin.graduation.entity.User;
import cn.edu.zucc.brightqin.graduation.service.PersonService;
import cn.edu.zucc.brightqin.graduation.service.UserService;
import cn.edu.zucc.brightqin.graduation.utils.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

/**
 * @author brightqin
 */
@SessionAttributes(value = {"userId", "departmentId"})
@Controller
@RequestMapping(value = "/user")
public class LoginController {
    private final UserService userService;
    private final PersonService personService;

    @Autowired
    public LoginController(UserService userService, PersonService personService) {
        this.userService = userService;
        this.personService = personService;
    }

    @RequestMapping("/login")
    public String doLogin(@Validated String id, String password, ModelMap map) {
        password = PasswordUtil.MD5(password);
        User user = userService.getUserById(id);
        if (user != null && password.equals(user.getPassword())) {
            map.addAttribute("userId", id);
            return "frame";
        }
        Person person = personService.getPersonByLoginId(id);
        if (person != null && password.equals(person.getPassword())) {
            if (person.isManager()) {
                map.addAttribute("departmentId", person.getDepartment().getDepartmentId());
                map.addAttribute("userId", person.getPersonId());
                return "department";
            } else {
                map.addAttribute("userId", person.getPersonId());
                return "person";
            }
        }
        return "error";
    }
}
