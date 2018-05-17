package cn.edu.zucc.brightqin.graduation.utils;

import cn.edu.zucc.brightqin.graduation.entity.PersonObject;

import java.util.List;

/**
 * @author brightqin
 */
public class PersonObjectXml {

    private final List<PersonObject> objects;
    private StringBuilder stringBuilder = new StringBuilder(128);

    public PersonObjectXml(List<PersonObject> objects) {
        this.objects = objects;
    }

    public String build() {
        stringBuilder.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        stringBuilder.append("<rows>");
        for (PersonObject object : objects) {
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
        stringBuilder.append("../icons/object.png");
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(object.getPerson().getPersonId());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(object.getPersonObjectName());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(object.getWeight());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(object.getMonth());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(object.isReview());
        stringBuilder.append("</cell>");
        stringBuilder.append("</row>");
    }
}
