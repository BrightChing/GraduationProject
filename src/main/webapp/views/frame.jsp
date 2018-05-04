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
        let myLayout1, myLayout2, myTabBar;

        function doOnLoad() {
            myTabBar = new dhtmlXTabBar("my_tabBar");
            myTabBar.addTab("tab1", "组织管理", null, null, true);
            myTabBar.addTab("tab2", "OKR管理", null, null);
            OrganizationManagement();
            DepartmentOKRManagement()
        }

        function OrganizationManagement() {
            myLayout1 = myTabBar.tabs("tab1").attachLayout("2U");
            /*左边的布局 部门树*/
            myLayout1.cells("a").setWidth(260);
            myLayout1.cells("a").setText("部门管理");
            let myToolbarLeft = myLayout1.cells("a").attachToolbar();
            myToolbarLeft.setIconsPath("icons/");
            myToolbarLeft.loadStruct("data/toolbarStruct.xml", function () {
            });
            let myTree = myLayout1.cells("a").attachTree();
            myTree.setImagesPath("codebase/images/");

            /*右边的的布局 人员表*/
            myLayout1.cells("b").setText("人员管理");
            let myToolbarRight = myLayout1.cells("b").attachToolbar();
            myToolbarRight.setIconsPath("icons/");
            myToolbarRight.loadStruct("data/toolbarStruct.xml", function () {
            });
            let myGrid = myLayout1.cells("b").attachGrid();
            myGrid.setImagePath("codebase/images/");
            myGrid.setIconsPath("icons/");
            myGrid.setHeader("&nbsp;,departmentId,员工名,职位,邮箱,手机号,地址");
            myGrid.setColTypes("img,ro,ro,ro,ro,ro,ro");
            myGrid.setInitWidths("70,0,100,100,150,120,*");
            myGrid.setColAlign("center,left,left,left,left,left");
            myGrid.init();

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
                if (myTree.getSelectedItemId() == null) {
                    dhtmlx.alert("请您选择要在哪个部门添加人员");
                    return;
                }
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
                if (myTree.getSelectedItemId() == null) {
                    dhtmlx.alert("请您选择要在哪个节点下添加部门");
                    return;
                }
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
                } else if (sid === "1") {
                    dhtmlx.alert("顶级公司不可删除的，您可以按需求修改");
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

        function DepartmentOKRManagement() {

            myLayout2 = myTabBar.tabs("tab2").attachLayout("4W");
            /*左边的布局 部门树*/
            myLayout2.cells("a").setWidth(260);
            myLayout2.cells("a").setText("部门");

            let myTree = myLayout2.cells("a").attachTree();
            myTree.setImagesPath("codebase/images/");

            /*右边的的布局 人员表*/
            myLayout2.cells("b").setText("人员");
            myLayout2.cells("b").setWidth(200);
            let personGrid = myLayout2.cells("b").attachGrid();
            personGrid.setImagePath("codebase/images/");
            personGrid.setIconsPath("icons/");
            personGrid.setHeader("&nbsp;,departmentId,员工名");
            personGrid.setColTypes("img,ro,ro");
            personGrid.setInitWidths("70,0,*");
            personGrid.setColAlign("center,left,left");
            personGrid.init();

            myLayout2.cells("c").setText("目标");
            myLayout2.cells("c").setWidth(500);
            let myToolbarLeft = myLayout2.cells("c").attachToolbar();
            myToolbarLeft.setIconsPath("icons/");
            myToolbarLeft.loadStruct("data/toolbarStruct.xml", function () {
            });
            let objectGrid = myLayout2.cells("c").attachGrid();
            // objectGrid.setHeader("&nbsp,Booktitle,Author");
            objectGrid.setHeader("&nbsp,personId,目标名");
            objectGrid.setInitWidths("70,0,180");
            objectGrid.setColAlign("center,left,left");
            objectGrid.setColTypes("img,ro,ro");

            objectGrid.init();


            myLayout2.cells("d").setText("关键结果管理");
            let myToolbarRight = myLayout2.cells("d").attachToolbar();
            myToolbarRight.setIconsPath("icons/");
            myToolbarRight.loadStruct("data/toolbarStruct.xml", function () {
            });
            let keyResultGrid = myLayout2.cells("d").attachGrid();
            keyResultGrid.setImagePath("codebase/images/");
            keyResultGrid.setIconsPath("icons/");
            keyResultGrid.setHeader("&nbsp;,objectId,关键结果名");
            keyResultGrid.setColTypes("img,ro,ro");
            keyResultGrid.setInitWidths("70,0,*");
            keyResultGrid.setColAlign("center,left,left");
            keyResultGrid.init();


            /*加载部门树*/
            myTree.load("department/departmentTree", function () {
            }, "xml");
            /*加载点击部门的员工表*/
            myTree.attachEvent("onClick", function (id) {
                personGrid.clearAll(false);
                objectGrid.clearAll(false);
                personGrid.load("person/getPeople?id=" + id, function () {
                }, "xml");
            });
            /*当选择人员时加载人员的目标*/
            personGrid.attachEvent("onRowSelect", function (id, ind) {
                objectGrid.clearAll(false);
                objectGrid.load("personObject/getPersonObjects?id=" + id, function () {
                }, "xml");
            });

            /*给通过ToolbarLeft员工目标操作*/
            myToolbarLeft.attachEvent("onClick", function (id) {
                switch (id) {
                    case 'add':
                        addPersonObject();
                        break;
                    case 'delete':
                        deletePersonObject();
                        break;
                    default:
                        editPersonObject();
                }
            });


            /*添加目标*/
            function addPersonObject() {
                if (personGrid.getSelectedRowId() == null) {
                    dhtmlx.alert("请您先选中，您要为哪个人添加目标");
                    return;
                }
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {type: "input", name: "objectName", label: "目标名", value: ""},
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
                let w1 = dhxWins.createWindow("w1", "0", "0", "300", "260");
                dhxWins.window("w1").center();
                w1.setText("添加目标");
                let myForm = w1.attachForm(formData);
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let pid = personGrid.getSelectedRowId();
                        let data = "objectName=" + encodeURI(encodeURI(myForm.getItemValue("objectName")))
                            + "&personId=" + pid;
                        dhx.ajax.post("personObject/addPersonObject", data, function () {
                            keyResultGrid.clearAll(false);
                            objectGrid.clearAll(false);
                            objectGrid.load("personObject/getPersonObjects?id=" + pid, function () {
                            }, "xml");
                        });
                    }
                    dhxWins.window("w1").hide();
                });
            }

            /*删除目标*/
            function deletePersonObject() {
                let id = objectGrid.getSelectedRowId();
                if (id == null) {
                    dhtmlx.alert("请选中您将要删除的目标");
                    return;
                }
                if (keyResultGrid.getRowsNum() === 0) {
                    dhtmlx.confirm('主人，真的要狠心删除我吗', function (result) {
                        if (result) {
                            myTree.load("personObject/deletePersonObjectById?id=" + id, function () {
                                keyResultGrid.clearAll(false);
                                objectGrid.deleteRow(id);
                            }, "xml");
                        } else {
                            dhtmlx.alert("已取消删除");
                        }
                    });
                } else {
                    dhtmlx.alert("亲，该目标下还存在关键结果");
                }
            }


            /*编辑目标*/
            function editPersonObject() {
                let rid = objectGrid.getSelectedRowId();
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {
                                type: "input",
                                name: "objectName",
                                label: "目标名",
                                value: objectGrid.cells(rid, 2).getValue()
                            },
                        ]
                    },
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "button", name: "OK", value: "确认", offsetLeft: 40, offsetTop: 10, inputWidth: 50},
                            {type: "newcolumn"},
                            {type: "button", name: "CANCEL", value: "取消", offsetLeft: 8, offsetTop: 10}
                        ]
                    }
                ];
                let dhxWins = new dhtmlXWindows();
                dhxWins.attachViewportTo("my_tabBar");
                let w1 = dhxWins.createWindow("w1", "0", "0", "300", "260");
                dhxWins.window("w1").center();
                w1.setText("编辑目标");
                let myForm = w1.attachForm(formData);
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let data = "objectName=" + encodeURI(encodeURI(myForm.getItemValue("objectName")))
                            + "&objectId=" + rid;
                        dhx.ajax.post("personObject/updatePersonObject", data, function () {
                            keyResultGrid.clearAll(false);
                            objectGrid.clearAll(false);
                            objectGrid.clearAll(false);
                            objectGrid.load("personObject/getPersonObjects?id=" + personGrid.getSelectedRowId(), function () {
                            }, "xml");
                        });
                    }
                    dhxWins.window("w1").hide();
                });
            }

            /*给通过ToolbarLeft员工目标操作*/
            myToolbarRight.attachEvent("onClick", function (id) {
                switch (id) {
                    case 'add':
                        addKeyResult();
                        break;
                    case 'delete':
                        deleteResult();
                        break;
                    default:
                        editResult();
                }
            });

            /*添加关键结果*/
            function addKeyResult() {
                if (objectGrid.getSelectedRowId() == null) {
                    dhtmlx.alert("请您先选中，您要为哪目标添加关键成果");
                    return;
                }
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {type: "input", name: "keyResultName", label: "目标名", value: ""},
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
                let w1 = dhxWins.createWindow("w1", "0", "0", "300", "260");
                dhxWins.window("w1").center();
                w1.setText("添加关键成果");
                let myForm = w1.attachForm(formData);
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let pid = objectGrid.getSelectedRowId();
                        let data = "keyResultName=" + encodeURI(encodeURI(myForm.getItemValue("keyResultName")))
                            + "&personObjectId=" + pid;
                        dhx.ajax.post("personKeyResult/addKeyObject", data, function () {
                            keyResultGrid.clearAll(false);
                            objectGrid.clearAll(false);
                            objectGrid.load("personKeyResult/getKeyResults?id=" + pid, function () {
                            }, "xml");
                        });
                    }
                    dhxWins.window("w1").hide();
                });
            }

            /*删除关键结果*/
            function deleteResult() {
                let id = keyResultGrid.getSelectedRowId();
                if (id == null) {
                    dhtmlx.alert("请选中您将要删除的目标");
                    return;
                }
                dhtmlx.confirm('主人，真的要狠心删除我吗', function (result) {
                    if (result) {
                        myTree.load("personKeyResult/deletePersonKeyResultById?id=" + id, function () {
                            keyResultGrid.clearAll(false);
                            objectGrid.deleteRow(id);
                        }, "xml");
                    } else {
                        dhtmlx.alert("已取消删除");
                    }
                });
            }

            /*编辑关键结果*/
            function editResult() {
                let rid = objectGrid.getSelectedRowId();
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {
                                type: "input",
                                name: "objectName",
                                label: "目标名",
                                value: objectGrid.cells(rid, 2).getValue()
                            },
                        ]
                    },
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "button", name: "OK", value: "确认", offsetLeft: 40, offsetTop: 10, inputWidth: 50},
                            {type: "newcolumn"},
                            {type: "button", name: "CANCEL", value: "取消", offsetLeft: 8, offsetTop: 10}
                        ]
                    }
                ];
                let dhxWins = new dhtmlXWindows();
                dhxWins.attachViewportTo("my_tabBar");
                let w1 = dhxWins.createWindow("w1", "0", "0", "300", "260");
                dhxWins.window("w1").center();
                w1.setText("编辑目标");
                let myForm = w1.attachForm(formData);
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let data = "objectName=" + encodeURI(encodeURI(myForm.getItemValue("objectName")))
                            + "&objectId=" + rid;
                        dhx.ajax.post("personObject/updatePersonObject", data, function () {
                            keyResultGrid.clearAll(false);
                            objectGrid.clearAll(false);
                            objectGrid.clearAll(false);
                            objectGrid.load("personObject/getPersonObjects?id=" + personGrid.getSelectedRowId(), function () {
                            }, "xml");
                        });
                    }
                    dhxWins.window("w1").hide();
                });
            }
        }
    </script>
</head>
<body onload="doOnLoad();">
<div id="my_tabBar" style="width: 100%; height:100%;"></div>
</body>
</html>