package cn.edu.zucc.brightqin.utils;

import cn.edu.zucc.brightqin.entity.DepartmentKeyResult;

import java.util.List;

public class DepartmentKeyResultXml {
    private final List<DepartmentKeyResult> keyResults;
    private StringBuilder stringBuilder = new StringBuilder(128);

    public DepartmentKeyResultXml(List<DepartmentKeyResult> keyResults) {
        this.keyResults = keyResults;
    }

    public String build() {
        stringBuilder.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        stringBuilder.append("<rows>");
        for (DepartmentKeyResult keyResult : keyResults) {
            buildXML(keyResult);
        }
        stringBuilder.append("</rows>");
        return stringBuilder.toString();
    }

    /**
     * 构建XML文档
     */
    private void buildXML(DepartmentKeyResult keyResult) {
        stringBuilder.append("<row id=\"");
        stringBuilder.append(keyResult.getDepartmentKeyResultId());
        stringBuilder.append("\">");
        stringBuilder.append("<cell>");
        stringBuilder.append("../icons/keyResult.png");
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(keyResult.getDepartmentObject().getDepartmentObjectId());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(keyResult.getDepartmentKeyResultName());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(keyResult.getWeight());
        stringBuilder.append("</cell>");
        stringBuilder.append("</row>");
    }
}
