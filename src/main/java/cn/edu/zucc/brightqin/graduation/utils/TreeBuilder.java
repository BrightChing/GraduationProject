package cn.edu.zucc.brightqin.graduation.utils;

import cn.edu.zucc.brightqin.graduation.entity.Department;

import java.util.Set;

/**
 * @author brightqin
 */
public class TreeBuilder {
    private final Department root;
    private StringBuilder treeString = new StringBuilder(128);

    public TreeBuilder(Department root) {
        this.root = root;
    }

    /**
     * 构建树
     */
    public String build() {
        treeString.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        treeString.append("<tree id=\"0\">");
        buildTree(root);
        treeString.append("</tree>");
        return treeString.toString();
    }

    /**
     * 构建树形节点的内容
     */
    private void buildTree(Department department) {
        treeString.append("<item text=\"");
        treeString.append(department.getDepartmentName());
        treeString.append("\" id=\"");
        treeString.append(department.getDepartmentId());
        treeString.append("\" im0=\"");
        treeString.append("folderClosed.gif");
        treeString.append("\">");
        Set<Department> set = department.getChildDepartments();
        for (Department obj : set) {
            buildTree(obj);
        }
        treeString.append("</item>");
    }

    public String buildTwo() {
        treeString.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        treeString.append("<tree id=\"0\">");
        buildTreeTwo(root);
        treeString.append("</tree>");
        return treeString.toString();
    }

    public String buildThree() {
        treeString.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        treeString.append("<tree id=\"0\">");
        Set<Department> set = root.getChildDepartments();
        for (Department obj : set) {
            buildTreeThree(obj);
        }
        treeString.append("</tree>");
        return treeString.toString();
    }

    public String buildFour() {
        treeString.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        treeString.append("<tree id=\"0\">");
        buildTreeThree(root);
        treeString.append("</tree>");
        return treeString.toString();
    }

    private void buildTreeTwo(Department department) {
        treeString.append("<item text=\"");
        treeString.append(department.getDepartmentName());
        treeString.append("\" id=\"");
        treeString.append(department.getDepartmentId());
        treeString.append("\" im0=\"");
        treeString.append("folderClosed.gif");
        treeString.append("\">");
        Set<Department> set = department.getChildDepartments();
        for (Department obj : set) {
            buildTreeThree(obj);
        }
        treeString.append("</item>");
    }

    private void buildTreeThree(Department department) {
        treeString.append("<item text=\"");
        treeString.append(department.getDepartmentName());
        treeString.append("\" id=\"");
        treeString.append(department.getDepartmentId());
        treeString.append("\" im0=\"");
        treeString.append("folderClosed.gif");
        treeString.append("\">");
        treeString.append("</item>");
    }

}
