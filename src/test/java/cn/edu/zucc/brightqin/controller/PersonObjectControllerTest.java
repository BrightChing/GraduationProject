package cn.edu.zucc.brightqin.controller;

import cn.edu.zucc.brightqin.entity.PersonObject;
import cn.edu.zucc.brightqin.service.PersonObjectService;
import cn.edu.zucc.brightqin.utils.PersonObjectXml;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.util.List;


@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class PersonObjectControllerTest {
    @Autowired
    private PersonObjectService service;

    @Test
    public void addPersonObject() {
    }

    @Test
    public void deletePersonObjectById() {
    }

    @Test
    public void updatePersonObject() {
    }

    @Test
    public void getPersonObjects() {

        List<PersonObject> personObjects = service.getObjectsByPersonId(1);
        PersonObjectXml personObjectXml = new PersonObjectXml(personObjects);
        System.out.println("测试开始");
        System.out.println(personObjectXml.build());

    }
}