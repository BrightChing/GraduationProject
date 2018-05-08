package cn.edu.zucc.brightqin.utils;

import cn.edu.zucc.brightqin.entity.DepartmentObject;

import java.util.List;

/**
 * @author brightqin
 */
public class DepartmentObjectXml {
    private final List<DepartmentObject> objects;
    private StringBuilder stringBuilder = new StringBuilder(128);

    public DepartmentObjectXml(List<DepartmentObject> objects) {
        this.objects = objects;
    }

    public String build() {
        stringBuilder.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        stringBuilder.append("<rows>");
        for (DepartmentObject object : objects) {
            buildXML(object);
        }
        stringBuilder.append("</rows>");
        return stringBuilder.toString();
    }

    /**
     * 构建XML文档
     */
    private void buildXML(DepartmentObject object) {
        stringBuilder.append("<row id=\"");
        stringBuilder.append(object.getDepartmentObjectId());
        stringBuilder.append("\">");
        stringBuilder.append("<cell>");
        stringBuilder.append("../icons/object.png");
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(object.getDepartment().getDepartmentId());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(object.getDepartmentObjectName());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(object.getWeight());
        stringBuilder.append("</cell>");
        stringBuilder.append("<cell>");
        stringBuilder.append(object.getMonth());
        stringBuilder.append("</cell>");
        stringBuilder.append("</row>");
    }
}
