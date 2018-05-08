package cn.edu.zucc.brightqin.controller;

import cn.edu.zucc.brightqin.entity.Person;
import cn.edu.zucc.brightqin.service.PersonService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.util.List;
import java.util.regex.Pattern;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class PersonControllerTest {
    @Autowired
    private PersonService personService;

    @Test
    public void main() {
        String content = "554.99";
        String pattern = "^\\d{1,2}(\\.\\d+)?$";
        boolean isMatch = Pattern.matches(pattern, content);
        System.out.println(isMatch);
    }

    @Test
    public void getPeople() {
        List<Person> people = personService.getPersonByDepartmentId(5);
        for (Person p : people) {
            System.out.println(p.getPersonName());
        }
    }
}