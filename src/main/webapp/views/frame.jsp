<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Manager</title>
    <script src="${pageContext.request.contextPath}/codebase/dhtmlx.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/codebase/dhtmlx.css">
    <style>
        html, body {
            width: 100%;
            height: 100%;
            overflow: hidden; /*hides the default body's space*/
            margin: 0; /*hides the body's scrolls*/
        }
    </style>
</head>
<header>

</header>
<body>
<script type="text/javascript">
    dhtmlxEvent(window, "load", function () {
        var myLayout = new dhtmlXLayoutObject(document.body, "2U");
        myLayout.cells("a").setWidth(260);
        myLayout.cells("a").setText("部门管理");
        myLayout.cells("b").setText("人员管理");
        var myToolbar = myLayout.cells("a").attachToolbar();
        myToolbar.setIconsPath("icons/");
        myToolbar.loadStruct("data/toolbarStruct.xml");
        var myTree = myLayout.cells("a").attachTree();
        myTree.setImagesPath("codebase/images/");
        var myGrid = myLayout.cells("b").attachGrid();
        myGrid.setImagePath("codebase/images/");
        myGrid.setIconsPath("icons/");                //sets the path to custom images
        myGrid.setHeader("&nbsp;,部门,员工名,邮箱,地址,手机号,职位");
        myGrid.setColTypes("img,ro,ro,ro,ro,ro,ro");             //sets the types of columns
        myGrid.setInitWidths("70,0,100,0,300,150,*");   //sets the initial widths of columns
        myGrid.setColAlign("center,left,left,left,left,left");
        myGrid.init();
        myTree.attachEvent("onSelect", function (id) {              //attaches a handler function to the 'onSelect' event that fires when the user clicks on a tree's item.
            myGrid.filterBy(1,id,false);                                 //filters the grid by the 5th data's property (the parent item of the file) and compares it with the item selected in the tree.
            return true;
        });
        myTree.loadXML("department/departmentTree", function () {           //adds the callback function to the loadXML method to select the item in the tree just after the data to the tree has been completely loaded
            myGrid.load("person/main", function () {           //adds the callback function to the load method to select the item in the tree just after the data to the grid has been completely loaded
                myTree.selectItem("1");                        //makes the 'books' folder selected initially
            })
        });
    });
</script>
</body>
</html>