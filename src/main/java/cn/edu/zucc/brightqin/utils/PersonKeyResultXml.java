package cn.edu.zucc.brightqin.utils;

import cn.edu.zucc.brightqin.entity.PersonKeyResult;

import java.util.List;

/**
 * @author brightqin
 */
public class PersonKeyResultXml {

    private final List<PersonKeyResult> keyResults;
    private StringBuilder stringBuilder = new StringBuilder(128);

    public PersonKeyResultXml(List<PersonKeyResult> keyResults) {
        this.keyResults = keyResults;

    }

    public String build() {
        stringBuilder.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        stringBuilder.append("<rows>");
        for (PersonKeyResult result : keyResults) {
            buildXML(result);
        }
        stringBuilder.append("</rows>");
        return stringBuilder.toString();
    }

    /**
     * 构建XML文档
     */
    private void buildXML(PersonKeyResult result) {
        stringBuilder.append("<row id=\"");
        stringBuilder.append(result.getKeyResultId());
        stringBuilder.append("\">");
        stringBuilder.append("<cell>");
        stringBuilder.append("../icons/people.png");
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(result.getPersonObject().getPersonObjectId());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(result.getKeyResultName());
        stringBuilder.append("</cell>");
        stringBuilder.append("</row>");
    }
}

