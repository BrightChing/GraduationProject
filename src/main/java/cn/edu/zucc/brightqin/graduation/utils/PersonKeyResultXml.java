package cn.edu.zucc.brightqin.graduation.utils;

import cn.edu.zucc.brightqin.graduation.entity.PersonKeyResult;

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
        stringBuilder.append(result.getPersonKeyResultId());
        stringBuilder.append("\">");
        stringBuilder.append("<cell>");
        stringBuilder.append("../icons/keyResult.png");
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(result.getPersonObject().getPersonObjectId());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(result.getPersonKeyResultName());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(result.getWeight());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(result.getSelfScore());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(result.getUpstreamScore());
        stringBuilder.append("</cell>");
        stringBuilder.append("</row>");
    }
}

