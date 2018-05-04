package cn.edu.zucc.brightqin.utils;

import cn.edu.zucc.brightqin.entity.PersonObject;

import java.util.List;

/**
 * @author brightqin
 */
public class PersonObjectXml {

    private final List<PersonObject> personObjects;
    private StringBuilder stringBuilder = new StringBuilder(128);

    public PersonObjectXml(List<PersonObject> personObjects) {
        this.personObjects = personObjects;
    }

    public String build() {
        stringBuilder.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        stringBuilder.append("<rows>");
        for (PersonObject object : personObjects) {
            buildXML(object);
        }
        stringBuilder.append("</rows>");
        return stringBuilder.toString();
    }

    /**
     * 构建XML文档
     */
    private void buildXML(PersonObject object) {
        stringBuilder.append("<row id=\"");
        stringBuilder.append(object.getPersonObjectId());
        stringBuilder.append("\">");
        stringBuilder.append("<cell>");
        stringBuilder.append("../icons/people.png");
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(object.getPerson().getPersonId());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(object.getPersonObjectName());
        stringBuilder.append("</cell>");
        stringBuilder.append("</row>");
    }
}
