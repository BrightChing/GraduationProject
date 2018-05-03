package cn.edu.zucc.brightqin.utils;

import cn.edu.zucc.brightqin.entity.Person;

import java.util.List;


/**
 * @author brightqin
 */
public class PersonXml {

    private List<Person> personList;
    private StringBuilder stringBuilder = new StringBuilder(128);

    public PersonXml(List<Person> personList) {
        this.personList = personList;
    }

    public String build() {
        stringBuilder.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        stringBuilder.append("<rows>");
        for (Person person : personList) {
            buildTree(person);
        }
        stringBuilder.append("</rows>");
        return stringBuilder.toString();
    }

    /**
     * 构建XML文档
     *
     * @param person
     */
    private void buildTree(Person person) {
        stringBuilder.append("<row id=\"");
        stringBuilder.append(person.getPersonId());
        stringBuilder.append("\">");
        stringBuilder.append("<cell>");
        stringBuilder.append("../icons/people.png");
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(person.getDepartment().getDepartmentId());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(person.getPersonName());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(person.getPosition());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(person.getEmail());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(person.getPhone());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(person.getAddress());
        stringBuilder.append("</cell>");
        stringBuilder.append("</row>");
    }
}
