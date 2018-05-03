<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Manager</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <script src="${pageContext.request.contextPath}/codebase/dhtmlx.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/codebase/dhtmlx.css">
    <style>
        html, body {
            width: 100%;
            height: 100%;
            overflow: hidden;
            margin: 0;
        }
    </style>
    <script type="text/javascript">
        let myLayout, myTabBar;

        function doOnLoad() {
            myTabBar = new dhtmlXTabBar("my_tabBar");
            myTabBar.addTab("tab1", "组织管理", null, null, true);
            myTabBar.addTab("a2", "", null, null);
            OrganizationManagement();
        }

        function OrganizationManagement() {
            myLayout = myTabBar.tabs("tab1").attachLayout("2U");
            /*左边的布局 部门树*/
            myLayout.cells("a").setWidth(260);
            myLayout.cells("a").setText("部门管理");
            let myToolbarLeft = myLayout.cells("a").attachToolbar();
            myToolbarLeft.setIconsPath("icons/");
            myToolbarLeft.loadStruct("data/toolbarStruct.xml", function () {
            });
            let myTree = myLayout.cells("a").attachTree();
            myTree.setImagesPath("codebase/images/");

            /*右边的的布局 人员表*/
            myLayout.cells("b").setText("人员管理");
            let myToolbarRight = myLayout.cells("b").attachToolbar();
            myToolbarRight.setIconsPath("icons/");
            myToolbarRight.loadStruct("data/toolbarStruct.xml", function () {
            });
            let myGrid = myLayout.cells("b").attachGrid();
            myGrid.setImagePath("codebase/images/");
            myGrid.setIconsPath("icons/");
            myGrid.setHeader("&nbsp;,部门,员工名,职位,邮箱,手机号,地址");
            myGrid.setColTypes("img,ro,ro,ro,ro,ro,ro");
            myGrid.setInitWidths("70,0,100,100,150,120,*");
            myGrid.setColAlign("center,left,left,left,left,left");
            myGrid.init();


            myTree.attachEvent("onSelect", function (id) {
                myGrid.filterBy(1, id, false);
                return true;
            });

            /*加载部门树*/
            myTree.load("department/departmentTree", function () {
            }, "xml");
            /*加载点击部门的员工表*/
            myTree.attachEvent("onClick", function () {
                myGrid.clearAll(false);
                myGrid.load("person/getPeople?id=" + myTree.getSelectedItemId(), function () {
                }, "xml");
            });


            /*添加人员*/
            function addPerson() {
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 60, inputWidth: 200, position: "label-left"},
                            {type: "input", name: "personName", label: "员工名", value: ""},
                            {type: "input", name: "position", label: "职位", value: ""},
                            {type: "input", name: "email", label: "邮箱", value: "", validate: "ValidEmail"},
                            {type: "input", name: "phone", label: "手机号", value: ""},
                            {type: "input", name: "address", label: "地址", value: ""}
                        ]
                    },
                    {
                        type: "checkbox", checked: 1, list: [
                            {type: "button", name: "OK", value: "确认", offsetLeft: 100, offsetTop: 10, inputWidth: 50},
                            {type: "newcolumn"},
                            {type: "button", name: "CANCEL", value: "取消", offsetLeft: 8, offsetTop: 10}
                        ]
                    }
                ];
                let did = myTree.getSelectedItemId();
                let dhxWins = new dhtmlXWindows();
                dhxWins.attachViewportTo("my_tabBar");
                let w1 = dhxWins.createWindow("w1", 0, 0, 380, 360);
                dhxWins.window("w1").center();
                w1.setText("添加人员");
                let myForm = w1.attachForm(formData);
                myForm.enableLiveValidation(true);
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let data = "personName=" + myForm.getItemValue("personName") + "&position="
                            + myForm.getItemValue("position") + "&email=" + myForm.getItemValue("email") + "&phone="
                            + myForm.getItemValue("phone") + "&address=" + myForm.getItemValue("address") + "&departmentId=" + did;
                        console.log(data);
                        dhx.ajax.post("person/addPerson", data, function () {
                            myGrid.clearAll(false);
                            myGrid.load("person/getPeople?id=" + did, function () {
                            }, "xml");
                        });
                    }
                    dhxWins.window("w1").hide();
                });
            }

            /*删除人员*/
            function deletePerson() {
                let sid = myGrid.getSelectedRowId();
                if (sid == null) {
                    dhtmlx.alert("请选中您将要删除的员工");
                    return;
                }
                dhtmlx.confirm('主人，真的要狠心删除我吗', function (result) {
                    if (result) {
                        myGrid.load("person/deletePersonById?id=" + sid, function () {
                            myGrid.deleteRow(sid);
                        });
                    } else {
                        dhtmlx.alert("已取消删除");
                    }
                });
            }

            /*编辑人员*/
            function editPerson() {
                let rid = myGrid.getSelectedRowId();
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 60, inputWidth: 200, position: "label-left"},
                            {type: "input", name: "personName", label: "员工名", value: myGrid.cells(rid, 2).getValue()},
                            {type: "input", name: "position", label: "职位", value: myGrid.cells(rid, 3).getValue()},
                            {type: "input", name: "email", label: "邮箱", value: myGrid.cells(rid, 4).getValue()},
                            {type: "input", name: "phone", label: "手机号", value: myGrid.cells(rid, 5).getValue()},
                            {type: "input", name: "address", label: "地址", value: myGrid.cells(rid, 6).getValue()}
                        ]
                    },
                    {
                        type: "checkbox", checked: 1, list: [
                            {type: "button", name: "OK", value: "确认", offsetLeft: 100, offsetTop: 10, inputWidth: 50},
                            {type: "newcolumn"},
                            {type: "button", name: "CANCEL", value: "取消", offsetLeft: 8, offsetTop: 10}
                        ]
                    }
                ];

                let dhxWins = new dhtmlXWindows();
                dhxWins.attachViewportTo("my_tabBar");
                let w1 = dhxWins.createWindow("w1", 0, 0, 380, 360);
                dhxWins.window("w1").center();
                w1.setText("编辑人员");
                let myForm = w1.attachForm(formData);
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let data = "personId=" + rid + "&personName=" + myForm.getItemValue("personName") + "&position="
                            + myForm.getItemValue("position") + "&email=" + myForm.getItemValue("email") + "&phone="
                            + myForm.getItemValue("phone") + "&address=" + myForm.getItemValue("address");
                        dhx.ajax.post("person/updatePerson", data, function () {
                            myGrid.clearAll(false);
                            myGrid.load("person/getPeople?id=" + myTree.getSelectedItemId(), function () {
                            }, "xml");
                        });
                    }
                    dhxWins.window("w1").hide();
                });

            }

            /*添加部门*/
            function addDepartment() {
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {type: "input", name: "departmentName", label: "部门名", value: ""},
                        ]
                    },
                    {
                        type: "checkbox", checked: 1, list: [
                            {type: "button", name: "OK", value: "确认", offsetLeft: 40, offsetTop: 10, inputWidth: 50},
                            {type: "newcolumn"},
                            {type: "button", name: "CANCEL", value: "取消", offsetLeft: 8, offsetTop: 10}
                        ]
                    }
                ];

                let dhxWins = new dhtmlXWindows();
                dhxWins.attachViewportTo("my_tabBar");
                let w1 = dhxWins.createWindow("w1", 0, 0, 300, 260);
                dhxWins.window("w1").center();
                w1.setText("添加部门");
                let myForm = w1.attachForm(formData);
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let pid = myTree.getSelectedItemId();
                        let data = "departmentName=" + encodeURI(encodeURI(myForm.getItemValue("departmentName")))
                            + "&parentId=" + pid;
                        dhx.ajax.post("department/addDepartment", data, function (result) {
                            let id = result.xmlDoc.responseText;
                            myTree.insertNewChild(pid, id, myForm.getItemValue("departmentName"), function () {
                            }, "folderClosed.gif")
                        });
                    }
                    dhxWins.window("w1").hide();
                });
            }

            /*删除部门*/
            function deleteDepartment() {
                let sid = myTree.getSelectedItemId();
                let pid = myTree.getParentId(sid);
                if (sid == null) {
                    dhtmlx.alert("请选中您将要删除的部门");
                    return;
                }
                if (myTree.hasChildren(sid) === 0) {
                    if (myGrid.getRowsNum() === 0) {
                        dhtmlx.confirm('主人，真的要狠心删除我吗', function (result) {
                            if (result) {
                                myTree.load("department/deleteDepartmentById?id=" + sid, function () {
                                    myTree.deleteItem(sid, true);
                                    /*加载父级部门的员工*/
                                    myGrid.load("person/getPeople?id=" + pid, function () {
                                    }, "xml");
                                }, "xml");
                            } else {
                                dhtmlx.alert("已取消删除");
                            }
                        });
                    } else {
                        dhtmlx.alert("亲，该部门下还存在员工，先删除员工");
                    }
                } else {
                    dhtmlx.alert("亲，该部门下还存在子部门，请先删除子部门");
                }
            }

            /*编辑部门*/
            function editDepartment() {

                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {type: "input", name: "departmentName", label: "部门名", value: myTree.getSelectedItemText()},
                        ]
                    },
                    {
                        type: "checkbox", checked: 1, list: [
                            {type: "button", name: "OK", value: "确认", offsetLeft: 40, offsetTop: 10, inputWidth: 50},
                            {type: "newcolumn"},
                            {type: "button", name: "CANCEL", value: "取消", offsetLeft: 8, offsetTop: 10}
                        ]
                    }
                ];
                let dhxWins = new dhtmlXWindows();
                dhxWins.attachViewportTo("my_tabBar");
                let w1 = dhxWins.createWindow("w1", 0, 0, 300, 260);
                dhxWins.window("w1").center();
                w1.setText("编辑部门");
                let myForm = w1.attachForm(formData);
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let id = myTree.getSelectedItemId();
                        let data = "departmentName=" + encodeURI(encodeURI(myForm.getItemValue("departmentName")))
                            + "&parentId=" + myTree.getParentId(id) + "&departmentId=" + id;
                        dhx.ajax.post("department/updateDepartment", data, function () {
                            myTree.setItemText(id, myForm.getItemValue("departmentName"), null);
                        });
                    }
                    dhxWins.window("w1").hide();
                });
            }


            /*给通过ToolbarLeft 部门操作*/
            myToolbarLeft.attachEvent("onClick", function (id) {
                switch (id) {
                    case 'add':
                        addDepartment();
                        break;
                    case 'delete':
                        deleteDepartment();
                        break;
                    default:
                        editDepartment();
                }
            });


            /*给通过ToolbarRight操作人员表*/
            myToolbarRight.attachEvent("onClick", function (id) {
                switch (id) {
                    case 'add':
                        addPerson();
                        break;
                    case 'delete':
                        deletePerson();
                        break;
                    default:
                        editPerson()
                }
            });
        }
    </script>
</head>
<body onload="doOnLoad();">
<div id="my_tabBar" style="width: 100%; height:100%;"></div>
</body>
</html>