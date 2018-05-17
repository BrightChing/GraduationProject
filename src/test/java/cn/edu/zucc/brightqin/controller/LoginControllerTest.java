package cn.edu.zucc.brightqin.controller;

import cn.edu.zucc.brightqin.graduation.entity.Person;
import cn.edu.zucc.brightqin.graduation.service.PersonService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.util.Scanner;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class LoginControllerTest {
    @Autowired
    private PersonService personService;


    @Test
    public void doLogin() {
        Person person;
        while (true) {
            Scanner scanner = new Scanner(System.in);
            String loginId = "login13";
            person = personService.getPersonByLoginId(loginId);
            System.out.println(person);
        }

    }
}