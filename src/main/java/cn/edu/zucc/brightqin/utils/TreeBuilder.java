package cn.edu.zucc.brightqin.utils;

import cn.edu.zucc.brightqin.entity.Department;

import java.util.Set;

/**
 * @author brightqin
 */
public class TreeBuilder {
    private Department root;
    private StringBuilder treeString = new StringBuilder(128);
    public TreeBuilder(Department root) {
        this.root = root;
    }

    /**
     * 构建树
     * @return
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
}
