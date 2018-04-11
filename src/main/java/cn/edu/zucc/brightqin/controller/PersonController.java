package cn.edu.zucc.brightqin.controller;

import java.util.List;
import java.util.Map;

import cn.edu.zucc.brightqin.entity.Person;
import cn.edu.zucc.brightqin.service.PersonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;


/**
 * controller
 * @author brightqin
 */
@SessionAttributes(value = "username")
@Controller
@RequestMapping(value = "/person")
public class PersonController {

    @Autowired
    public PersonService personService;

    /**
     * 保存添加的数据
     * @param person person
     * @return
     */
    @RequestMapping(value = "/savePerson", method = RequestMethod.POST)
    public String savePerson(@Valid Person person, BindingResult result, ModelMap map) {
        if (result.hasErrors()) {
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error : errors) {
                map.put("ERROR_" + error.getField(), error.getDefaultMessage());
                 System.out.println(error.getField() + "*" + error.getDefaultMessage());
            }
            return "savePage";
        }
        else {
            personService.addPerson(person);
            return "redirect:main";
        }
    }

    /**
     * 跳转到添加页面
     * savePage.jsp
     *
     * @return
     */
    @RequestMapping(value = "/addPerson")
    public String savePerson() {
        return "savePage";
    }

    /**
     * 删除一条数据
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/deletePersonById")
    public String deletePersonById(@RequestParam(value = "id") String id) {
        personService.deletePersonById(id);
        return "redirect:main";
    }

    /**
     * 跳转到更新页面，回显数据
     * editPage.jsp
     *
     * @param id
     * @param model 使用的Model保存回显数据
     * @return
     */
    @RequestMapping(value = "/doUpdate")
    public String doUpdate(@RequestParam(value = "id") String id, Model model) {
        model.addAttribute("person", personService.getPersonById(id));
        return "editPage";
    }

    /**
     * 更新数据
     *
     * @param person
     * @return
     */
    @RequestMapping(value = "/updatePerson")
    public String updatePerson(Person person) {
        System.out.println(person.toString());
        personService.updatePerson(person);
        return "redirect:main";
    }

    /**
     * 查询所有人员信息
     *
     * @param map 使用的是map保存回显数据
     * @return
     */
    @RequestMapping(value = "/main")
    public String main(Map<String, Object> map) {
        map.put("personList", personService.getPersons());
        return "main";
    }
}
