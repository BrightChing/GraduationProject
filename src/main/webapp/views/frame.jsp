<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Manager</title>
    <script src="${pageContext.request.contextPath}/codebase/dhtmlx.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/codebase/dhtmlx.css">
    <style>
        body {
            width: 100%;
            height: 900px;
            overflow: hidden;
            margin: 0;
        }

        div#layoutObj {
            position: relative;
            margin: 10px;
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<header>

</header>
<body onload="doLoad()">
<script type="text/javascript">
    function doLoad() {
        var myLayout = new dhtmlXLayoutObject("layoutObj", "2U");
        /*左边的布局 部门树*/
        myLayout.cells("a").setWidth(260);
        myLayout.cells("a").setText("部门管理");
        var myToolbarLeft = myLayout.cells("a").attachToolbar();
        myToolbarLeft.setIconsPath("icons/");
        myToolbarLeft.loadStruct("data/toolbarStruct.xml");
        var myTree = myLayout.cells("a").attachTree();
        myTree.setImagesPath("codebase/images/");

        /*右边的的布局 人员表*/
        myLayout.cells("b").setText("人员管理");
        var myToolbarRight = myLayout.cells("b").attachToolbar();
        myToolbarRight.setIconsPath("icons/");
        myToolbarRight.loadStruct("data/toolbarStruct.xml");
        var myGrid = myLayout.cells("b").attachGrid();
        myGrid.setImagePath("codebase/images/");
        myGrid.setIconsPath("icons/");                //sets the path to custom images
        myGrid.setHeader("&nbsp;,部门,员工名,职位,邮箱,手机号,地址");
        myGrid.setColTypes("img,ro,ro,ro,ro,ro,ro");             //sets the types of columns
        myGrid.setInitWidths("70,0,100,100,150,120,*");   //sets the initial widths of columns
        myGrid.setColAlign("center,left,left,left,left,left");
        myGrid.init();

        /*给通过ToolbarRight操作人员表*/
        myToolbarRight.attachEvent("onClick", function (id) {
            switch (id) {
                case 'add':
                    alert("hello boy");
                    break;
                case 'delete':
                    if (myGrid.getSelectedRowId() == null) {
                        alert("请选中您将要删除的员工");
                        return;
                    }
                    if (confirm('主人，真的要狠心删除我吗')) {
                        myGrid.load("person/deletePersonById?id=" + myGrid.getSelectedRowId(), function () {
                        });
                        myGrid.deleteRow(myGrid.getSelectedRowId());
                    }
                    break;
                default:
                    alert("hello boy,this is edit button");
            }
        });
        myToolbarLeft.attachEvent("onClick", function (id) {
            switch (id) {
                case 'add':
                    alert("hello boy");
                    break;
                case 'delete':
                    if (myTree.hasChildren(myTree.getSelectedItemId()) === 0) {
                        if (myGrid.getRowsNum() === 0 && confirm('主人，真的要狠心删除我吗')) {
                            let sid = myTree.getSelectedItemId();
                            let pid = myTree.getParentId(sid);
                            myTree.load("department/departmentById?id=" + sid, function () {
                            });
                            myTree.deleteItem(myTree.getSelectedItemId(), true);
                            /*加载父级部门的员工*/
                            myGrid.load("person/getPeople?id=" + pid, function () {
                            });
                        } else {
                            alert("亲，该部门下还存在员工，先删除员工");
                        }
                    } else {
                        alert("亲，该部门下还存在子部门，请先删除子部门");
                    }
                    break;
                default:
                    alert("hello boy,this is edit button");
            }
        });

        myTree.attachEvent("onSelect", function (id) {
            myGrid.filterBy(1, id, false);
            return true;
        });
        /*加载部门树*/
        myTree.load("department/departmentTree", function () {
        });
        /*加载点击部门的员工表*/
        myTree.attachEvent("onClick", function () {
            myGrid.clearAll(false);
            myGrid.load("person/getPeople?id=" + myTree.getSelectedItemId(), function () {
            });
        });
    }
</script>
<div id="layoutObj"></div>
</body>
</html>