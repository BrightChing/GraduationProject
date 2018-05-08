<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>企业OKR管理系统</title>
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
        let myLayout1, myLayout2, myLayout3, myTabBar;

        function doOnLoad() {
            myTabBar = new dhtmlXTabBar("my_tabBar");
            myTabBar.addTab("tab1", "组织管理", null, null, true);
            myTabBar.addTab("tab2", "人员OKR管理", null, null);
            myTabBar.addTab("tab3", "部门OKR管理", null, null);
            OrganizationManagement();
            myTabBar.attachEvent("onTabClick", function (id, lastId) {
                if (id === "tab3") {
                    DepartmentOKRManagement();
                }
                else if (id === "tab2") {
                    PersonOKRManagement();
                }
            });
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
                        }, "xml");
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
                let pid = myTree.getSelectedItemId();
                if (pid === '') {
                    dhtmlx.alert("请您选择要在哪个节点下添加部门");
                    return;
                }
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {type: "input", name: "departmentName", label: "部门名", value: ""}
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
                w1.setText("添加部门");
                let myForm = w1.attachForm(formData);
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
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
                if (sid === '') {
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
                let id = myTree.getSelectedItemId();
                if (id === '') {
                    dhtmlx.alert("请选中您将要编辑的部门");
                    return;
                }
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
                let w1 = dhxWins.createWindow("w1", "0", "0", "300", "260");
                dhxWins.window("w1").center();
                w1.setText("编辑部门");
                let myForm = w1.attachForm(formData);
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {

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

        function PersonOKRManagement() {

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
            objectGrid.setHeader("&nbsp,departmentId,目标名,权重(%)");
            objectGrid.setInitWidths("70,0,120,90");
            objectGrid.setColAlign("center,left,left,left");
            objectGrid.setColTypes("img,ro,ro,ro");
            objectGrid.init();

            myLayout2.cells("d").setText("关键结果管理");
            let myToolbarRight = myLayout2.cells("d").attachToolbar();
            myToolbarRight.setIconsPath("icons/");
            myToolbarRight.loadStruct("data/toolbarStruct.xml", function () {
            });
            let keyResultGrid = myLayout2.cells("d").attachGrid();
            keyResultGrid.setImagePath("codebase/images/");
            keyResultGrid.setIconsPath("icons/");
            keyResultGrid.setHeader("&nbsp;,objectId,关键结果名,权重(%)");
            keyResultGrid.setColTypes("img,ro,ro,ro");
            keyResultGrid.setInitWidths("70,0,120,90");
            keyResultGrid.setColAlign("center,left,left,left");
            keyResultGrid.init();


            /*加载部门树*/
            myTree.load("department/departmentTree", function () {
            }, "xml");

            /*加载点击部门的员工表*/
            myTree.attachEvent("onClick", function (id) {
                keyResultGrid.clearAll(false);
                personGrid.clearAll(false);
                objectGrid.clearAll(false);
                personGrid.load("person/getPeople?id=" + id, function () {
                }, "xml");
            });

            /*当选择人员时加载人员的目标*/
            personGrid.attachEvent("onRowSelect", function (id, ind) {
                keyResultGrid.clearAll(false);
                objectGrid.clearAll(false);
                objectGrid.load("personObject/getPersonObjects?id=" + id, function () {
                }, "xml");
            });

            /*当选择人员目标时加载关键目标*/
            objectGrid.attachEvent("onRowSelect", function (id, ind) {
                keyResultGrid.clearAll(false);
                keyResultGrid.load("personKeyResult/getPersonKeyResultsByObjectId?id=" + id, function () {
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
                            {
                                type: "input",
                                name: "weight",
                                label: "权重",
                                value: "",
                                validate: "^\\d+(\\.\\d+)?$",
                                required: true
                            }
                        ]
                    },
                    {
                        type: "checkbox", checked: 1, name: "check", list: [
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
                myForm.enableLiveValidation(true);
                myForm.attachEvent("onValidateError", function (name, value, result) {
                    dhtmlx.alert(myForm.getItemLabel(name) + ": 错误");
                    myForm.uncheckItem("check");
                });
                myForm.attachEvent("onValidateSuccess", function (name, value, result) {
                    if (parseFloat(myForm.getItemValue("weight")) > 100) {
                        dhtmlx.alert(myForm.getItemLabel("weight") + ": 错误大于了100");
                        myForm.uncheckItem("check");
                        return;
                    }
                    myForm.checkItem("check");
                });

                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let pid = personGrid.getSelectedRowId();
                        let data = "objectName=" + encodeURI(encodeURI(myForm.getItemValue("objectName"))) +
                            "&weight=" + encodeURI(encodeURI(myForm.getItemValue("weight"))) + "&personId=" + pid;
                        dhx.ajax.post("personObject/addPersonObject", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                keyResultGrid.clearAll(false);
                                objectGrid.clearAll(false);
                                objectGrid.load("personObject/getPersonObjects?id=" + pid, function () {
                                }, "xml");
                                dhx.ajax.post("personObject/checkWeight", data, function (result) {
                                    let weightSum = parseFloat(result.xmlDoc.responseText);
                                    if (weightSum > 100) {
                                        dhtmlx.alert("权重和为" + weightSum + "大于了100，请您修改权重，或删除目标");
                                    } else if (weightSum < 100) {
                                        dhtmlx.alert("权重和为" + weightSum + " 小于100,请您修改权重，或添加目标");
                                    }
                                });
                            }
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
                let pid = personGrid.getSelectedRowId();
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
                            {
                                type: "input",
                                name: "weight",
                                label: "权重",
                                value: objectGrid.cells(rid, 3).getValue(),
                                validate: "^\\d+(\\.\\d+)?$",
                                required: true
                            }

                        ]
                    },
                    {
                        type: "checkbox", checked: true, name: "check", list: [
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
                myForm.enableLiveValidation(true);
                myForm.attachEvent("onValidateError", function (name, value, result) {
                    dhtmlx.alert(myForm.getItemLabel(name) + ": 错误");
                    myForm.uncheckItem("check");
                });
                myForm.attachEvent("onValidateSuccess", function (name, value, result) {
                    if (parseFloat(myForm.getItemValue("weight")) > 100) {
                        dhtmlx.alert(myForm.getItemLabel("weight") + ": 错误大于了100");
                        myForm.uncheckItem("check");
                        return;
                    }
                    myForm.checkItem("check");
                });

                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let data = "objectName=" + encodeURI(encodeURI(myForm.getItemValue("objectName"))) +
                            "&weight=" + encodeURI(encodeURI(myForm.getItemValue("weight"))) + "&objectId=" + rid;
                        let data1 = "personId=" + pid;
                        dhx.ajax.post("personObject/updatePersonObject", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                keyResultGrid.clearAll(false);
                                objectGrid.clearAll(false);
                                objectGrid.load("personObject/getPersonObjects?id=" + pid, function () {
                                }, "xml");
                                dhx.ajax.post("personObject/checkWeight", data1, function (result) {
                                    let weightSum = parseFloat(result.xmlDoc.responseText);
                                    if (weightSum > 100) {
                                        dhtmlx.alert("权重和为" + weightSum + "大于了100，请您修改权重，或删除目标");
                                    } else if (weightSum < 100) {
                                        dhtmlx.alert("权重和为" + weightSum + " 小于100,请您修改权重，或添加目标");
                                    }
                                });
                            }
                        });
                    }
                    dhxWins.window("w1").hide();
                });
            }

            /*给通过ToolbarLeft对员工关键结果进行操作*/
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
                            {type: "input", name: "keyResultName", label: "关键结果名", value: "", required: true},
                            {
                                type: "input",
                                name: "weight",
                                label: "权重",
                                value: "",
                                validate: "^\\d+(\\.\\d+)?$",
                                required: true
                            }
                        ]
                    },
                    {
                        type: "checkbox", checked: 1, name: "check", list: [
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
                myForm.enableLiveValidation(true);
                myForm.attachEvent("onValidateError", function (name, value, result) {
                    dhtmlx.alert(myForm.getItemLabel(name) + ": 错误");
                    myForm.uncheckItem("check");
                });
                myForm.attachEvent("onValidateSuccess", function (name, value, result) {
                    if (parseFloat(myForm.getItemValue("weight")) > 100) {
                        dhtmlx.alert(myForm.getItemLabel("weight") + ": 错误大于了100");
                        myForm.uncheckItem("check");
                        return;
                    }
                    myForm.checkItem("check");
                });
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let pid = objectGrid.getSelectedRowId();
                        let data = "keyResultName=" + encodeURI(encodeURI(myForm.getItemValue("keyResultName")))
                            + "&weight=" + encodeURI(encodeURI(myForm.getItemValue("weight"))) + "&personObjectId=" + pid;
                        dhx.ajax.post("personKeyResult/addPersonKeyResult", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                keyResultGrid.clearAll(false);
                                keyResultGrid.load("personKeyResult/getPersonKeyResultsByObjectId?id=" + pid, function () {
                                }, "xml");
                                dhx.ajax.post("personKeyResult/checkWeight", data, function (result) {
                                    let weightSum = parseFloat(result.xmlDoc.responseText);
                                    if (weightSum > 100) {
                                        dhtmlx.alert("权重和为" + weightSum + "大于了100，请您修改权重，或删除目标");
                                    } else if (weightSum < 100) {
                                        dhtmlx.alert("权重和为" + weightSum + " 小于100,请您修改权重，或添加目标");
                                    }
                                });
                            }

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
                            keyResultGrid.deleteRow(id);
                        }, "xml");
                    } else {
                        dhtmlx.alert("已取消删除");
                    }
                });
            }

            /*编辑关键结果*/
            function editResult() {
                let rid = keyResultGrid.getSelectedRowId();
                let oid = objectGrid.getSelectedRowId();
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {
                                type: "input",
                                name: "keyResultName",
                                label: "关键结果名",
                                value: keyResultGrid.cells(rid, 2).getValue()
                            },
                            {
                                type: "input",
                                name: "weight",
                                label: "权重",
                                value: keyResultGrid.cells(rid, 3).getValue(),
                                validate: "^\\d+(\\.\\d+)?$",
                                required: true
                            }
                        ]
                    },
                    {
                        type: "checkbox", checked: 1, name: "check", list: [
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
                w1.setText("编辑关键结果");
                let myForm = w1.attachForm(formData);
                myForm.enableLiveValidation(true);
                myForm.attachEvent("onValidateError", function (name, value, result) {
                    dhtmlx.alert(myForm.getItemLabel(name) + ": 错误");
                    myForm.uncheckItem("check");
                });
                myForm.attachEvent("onValidateSuccess", function (name, value, result) {
                    if (parseFloat(myForm.getItemValue("weight")) > 100) {
                        dhtmlx.alert(myForm.getItemLabel("weight") + ": 错误大于了100");
                        myForm.uncheckItem("check");
                        return;
                    }
                    myForm.checkItem("check");
                });
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let data = "keyResultName=" + encodeURI(encodeURI(myForm.getItemValue("keyResultName")))
                            + "&weight=" + encodeURI(encodeURI(myForm.getItemValue("weight"))) + "&keyResultId=" + rid;
                        let data1 = "personObjectId=" + oid;
                        dhx.ajax.post("personKeyResult/updatePersonKeyResult", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                keyResultGrid.clearAll(false);
                                keyResultGrid.load("personKeyResult/getPersonKeyResultsByObjectId?id=" + oid, function () {
                                }, "xml");

                                dhx.ajax.post("personKeyResult/checkWeight", data1, function (result) {
                                    let weightSum = parseFloat(result.xmlDoc.responseText);
                                    if (weightSum > 100) {
                                        dhtmlx.alert("权重和为" + weightSum + "大于了100，请您修改权重，或删除目标");
                                    } else if (weightSum < 100) {
                                        dhtmlx.alert("权重和为" + weightSum + " 小于100,请您修改权重，或添加目标");
                                    }
                                });
                            }
                        });
                    }
                    dhxWins.window("w1").hide();
                });
            }
        }

        function DepartmentOKRManagement() {

            myLayout3 = myTabBar.tabs("tab3").attachLayout("3W");
            /*左边的布局 部门树*/
            myLayout3.cells("a").setWidth(260);
            myLayout3.cells("a").setText("部门");

            let myTree = myLayout3.cells("a").attachTree();
            myTree.setImagesPath("codebase/images/");

            /*右边的的布局目标表*/
            myLayout3.cells("b").setText("目标");
            myLayout3.cells("b").setWidth(500);
            let myToolbarLeft = myLayout3.cells("b").attachToolbar();
            myToolbarLeft.setIconsPath("icons/");
            myToolbarLeft.loadStruct("data/toolbarStruct.xml", function () {
            });
            let objectGrid = myLayout3.cells("b").attachGrid();
            objectGrid.setHeader("&nbsp,departmentId,目标名,权重(%)");
            objectGrid.setInitWidths("70,0,120,90");
            objectGrid.setColAlign("center,left,left,left");
            objectGrid.setColTypes("img,ro,ro,ro");
            objectGrid.init();


            myLayout3.cells("c").setText("关键结果管理");
            let myToolbarRight = myLayout3.cells("c").attachToolbar();
            myToolbarRight.setIconsPath("icons/");
            myToolbarRight.loadStruct("data/toolbarStruct.xml", function () {
            });
            let keyResultGrid = myLayout3.cells("c").attachGrid();
            keyResultGrid.setImagePath("codebase/images/");
            keyResultGrid.setIconsPath("icons/");
            keyResultGrid.setHeader("&nbsp;,objectId,关键结果名,权重(%)");
            keyResultGrid.setColTypes("img,ro,ro,ro");
            keyResultGrid.setInitWidths("70,0,120,90");
            keyResultGrid.setColAlign("center,left,left,left");
            keyResultGrid.init();


            /*加载部门树*/
            myTree.load("department/departmentTree", function () {
            }, "xml");

            /*点击加载部门的目标表*/
            myTree.attachEvent("onClick", function (id) {
                keyResultGrid.clearAll(false);
                objectGrid.clearAll(false);
                objectGrid.load("departmentObject/getDepartmentObjectsByDepartmentId?id=" + id, function () {
                }, "xml");
            });

            /*当选择目标时加载关键目标*/
            objectGrid.attachEvent("onRowSelect", function (id, ind) {
                keyResultGrid.clearAll(false);
                keyResultGrid.load("departmentKeyResult/getDepartmentKeyResultsByObjectId?id=" + id, function () {
                }, "xml");
            });

            /*给通过ToolbarLeft部门目标操作*/
            myToolbarLeft.attachEvent("onClick", function (id) {
                switch (id) {
                    case 'add':
                        addDepartmentObject();
                        break;
                    case 'delete':
                        deleteDepartmentObject();
                        break;
                    default:
                        editDepartmentObject();
                }
            });

            /*添加部门目标*/
            function addDepartmentObject() {
                if (myTree.getSelectedItemId() == '') {
                    dhtmlx.alert("请您先选中，您要为哪个部门人添加目标");
                    return;
                }
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {type: "input", name: "objectName", label: "目标名", value: "", required: true},
                            {
                                type: "input",
                                name: "weight",
                                label: "权重",
                                value: "",
                                validate: "^\\d+(\\.\\d+)?$",
                                required: true
                            }
                        ]
                    },
                    {
                        type: "checkbox", checked: 1, name: "check", list: [
                            {type: "button", name: "OK", value: "确认", offsetLeft: 40, offsetTop: 10, inputWidth: 50},
                            {type: "newcolumn"},
                            {type: "button", name: "CANCEL", value: "取消", offsetLeft: 8, offsetTop: 10}
                        ]
                    }
                ];

                let dhxWins = new dhtmlXWindows();
                dhxWins.attachViewportTo("my_tabBar");
                let w1 = dhxWins.createWindow("w1", "0", "0", "300", "280");
                dhxWins.window("w1").center();
                w1.setText("添加目标");
                let myForm = w1.attachForm(formData);
                myForm.enableLiveValidation(true);
                myForm.attachEvent("onValidateError", function (name, value, result) {
                    dhtmlx.alert(myForm.getItemLabel(name) + ": 错误");
                    myForm.uncheckItem("check");
                });
                myForm.attachEvent("onValidateSuccess", function (name, value, result) {
                    if (parseFloat(myForm.getItemValue("weight")) > 100) {
                        dhtmlx.alert(myForm.getItemLabel("weight") + ": 错误大于了100");
                        myForm.uncheckItem("check");
                        return;
                    }
                    myForm.checkItem("check");
                });

                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let did = myTree.getSelectedItemId();
                        let data = "objectName=" + encodeURI(encodeURI(myForm.getItemValue("objectName"))) +
                            "&weight=" + encodeURI(encodeURI(myForm.getItemValue("weight"))) + "&departmentId=" + did;
                        dhx.ajax.post("departmentObject/addDepartmentObject", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                keyResultGrid.clearAll(false);
                                objectGrid.clearAll(false);
                                objectGrid.load("departmentObject/getDepartmentObjectsByDepartmentId?id=" + did, function () {
                                }, "xml");
                                dhx.ajax.post("departmentObject/checkWeight", data, function (result) {
                                    let weightSum = parseFloat(result.xmlDoc.responseText);
                                    if (weightSum > 100) {
                                        dhtmlx.alert("权重和为" + weightSum + "大于了100，请您修改权重，或删除目标");
                                    } else if (weightSum < 100) {
                                        dhtmlx.alert("权重和为" + weightSum + " 小于100,请您修改权重，或添加目标");
                                    }
                                });
                            }
                        });
                    }
                    dhxWins.window("w1").hide();
                });
            }

            /*删除部门目标*/
            function deleteDepartmentObject() {
                let id = objectGrid.getSelectedRowId();
                if (id == null) {
                    dhtmlx.alert("请选中您将要删除的目标");
                    return;
                }
                if (keyResultGrid.getRowsNum() === 0) {
                    dhtmlx.confirm('主人，真的要狠心删除我吗', function (result) {
                        if (result) {
                            myTree.load("departmentObject/deleteDepartmentObjectById?id=" + id, function () {
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

            /*编辑部门目标*/
            function editDepartmentObject() {
                let rid = objectGrid.getSelectedRowId();
                let did = myTree.getSelectedItemId();
                if (rid == null) {
                    dhtmlx.alert("请选中您将要编辑的目标");
                    return;
                }
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
                            {
                                type: "input",
                                name: "weight",
                                label: "权重",
                                value: objectGrid.cells(rid, 3).getValue(),
                                validate: "^\\d+(\\.\\d+)?$",
                                required: true
                            }

                        ]
                    },
                    {
                        type: "checkbox", checked: true, name: "check", list: [
                            {type: "button", name: "OK", value: "确认", offsetLeft: 40, offsetTop: 10, inputWidth: 50},
                            {type: "newcolumn"},
                            {type: "button", name: "CANCEL", value: "取消", offsetLeft: 8, offsetTop: 10}
                        ]
                    }
                ];
                let dhxWins = new dhtmlXWindows();
                dhxWins.attachViewportTo("my_tabBar");
                let w1 = dhxWins.createWindow("w1", "0", "0", "300", "280");
                dhxWins.window("w1").center();
                w1.setText("编辑目标");
                let myForm = w1.attachForm(formData);
                myForm.enableLiveValidation(true);
                myForm.attachEvent("onValidateError", function (name, value, result) {
                    dhtmlx.alert(myForm.getItemLabel(name) + ": 错误");
                    myForm.uncheckItem("check");
                });
                myForm.attachEvent("onValidateSuccess", function (name, value, result) {
                    if (parseFloat(myForm.getItemValue("weight")) > 100) {
                        dhtmlx.alert(myForm.getItemLabel("weight") + ": 错误大于了100");
                        myForm.uncheckItem("check");
                        return;
                    }
                    myForm.checkItem("check");
                });

                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let data = "objectName=" + encodeURI(encodeURI(myForm.getItemValue("objectName"))) + "&weight="
                            + encodeURI(encodeURI(myForm.getItemValue("weight"))) + "&objectId=" + rid;
                        let data1 = "departmentId=" + did;
                        dhx.ajax.post("departmentObject/updateDepartmentObject", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                keyResultGrid.clearAll(false);
                                objectGrid.clearAll(false);
                                objectGrid.load("departmentObject/getDepartmentObjectsByDepartmentId?id=" + did, function () {
                                }, "xml");
                                dhx.ajax.post("departmentObject/checkWeight", data1, function (result) {
                                    let weightSum = parseFloat(result.xmlDoc.responseText);
                                    if (weightSum > 100) {
                                        dhtmlx.alert("权重和为" + weightSum + "大于了100，请您修改权重，或删除目标");
                                    } else if (weightSum < 100) {
                                        dhtmlx.alert("权重和为" + weightSum + " 小于100,请您修改权重，或添加目标");
                                    }
                                });
                            }
                        });
                    }
                    dhxWins.window("w1").hide();
                });
            }

            /*给通过ToolbarRight对部门关键结果进行处理*/
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

            /*添加部门关键结果*/
            function addKeyResult() {
                if (objectGrid.getSelectedRowId() == null) {
                    dhtmlx.alert("请您先选中，您要为哪目标添加关键成果");
                    return;
                }
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {type: "input", name: "keyResultName", label: "关键结果名", value: "", required: true},
                            {
                                type: "input",
                                name: "weight",
                                label: "权重",
                                value: "",
                                validate: "^\\d+(\\.\\d+)?$",
                                required: true
                            }
                        ]
                    },
                    {
                        type: "checkbox", checked: 1, name: "check", list: [
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
                myForm.enableLiveValidation(true);
                myForm.attachEvent("onValidateError", function (name, value, result) {
                    dhtmlx.alert(myForm.getItemLabel(name) + ": 错误");
                    myForm.uncheckItem("check");
                });
                myForm.attachEvent("onValidateSuccess", function (name, value, result) {
                    if (parseFloat(myForm.getItemValue("weight")) > 100) {
                        dhtmlx.alert(myForm.getItemLabel("weight") + ": 错误大于了100");
                        myForm.uncheckItem("check");
                        return;
                    }
                    myForm.checkItem("check");
                });
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let oid = objectGrid.getSelectedRowId();
                        let data = "keyResultName=" + encodeURI(encodeURI(myForm.getItemValue("keyResultName"))) + "&weight="
                            + encodeURI(encodeURI(myForm.getItemValue("weight"))) + "&objectId=" + oid;
                        dhx.ajax.post("departmentKeyResult/addDepartmentKeyResult", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                keyResultGrid.clearAll(false);
                                keyResultGrid.load("departmentKeyResult/getDepartmentKeyResultsByObjectId?id=" + oid, function () {
                                }, "xml");

                                dhx.ajax.post("departmentKeyResult/checkWeight", data, function (result) {
                                    let weightSum = parseFloat(result.xmlDoc.responseText);
                                    if (weightSum > 100) {
                                        dhtmlx.alert("权重和为" + weightSum + "大于了100，请您修改权重，或删除目标");
                                    } else if (weightSum < 100) {
                                        dhtmlx.alert("权重和为" + weightSum + " 小于100,请您修改权重，或添加目标");
                                    }
                                });
                            }
                        });
                    }
                    dhxWins.window("w1").hide();
                });
            }

            /*删除部门关键结果*/
            function deleteResult() {
                let id = keyResultGrid.getSelectedRowId();
                if (id == null) {
                    dhtmlx.alert("请选中您将要删除的关键结果");
                    return;
                }
                dhtmlx.confirm('主人，真的要狠心删除我吗', function (result) {
                    if (result) {
                        myTree.load("departmentKeyResult/deleteDepartmentKeyResultById?id=" + id, function () {
                            keyResultGrid.deleteRow(id);
                        }, "xml");
                    } else {
                        dhtmlx.alert("已取消删除");
                    }
                });
            }

            /*编辑部门关键结果*/
            function editResult() {
                let kid = keyResultGrid.getSelectedRowId();
                let oid = objectGrid.getSelectedRowId();
                if (kid == null) {
                    dhtmlx.alert("请选中您将要编辑的关键结果");
                    return;
                }

                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {
                                type: "input",
                                name: "keyResultName",
                                label: "关键结果名",
                                value: keyResultGrid.cells(kid, 2).getValue()
                            },
                            {
                                type: "input",
                                name: "weight",
                                label: "权重",
                                value: keyResultGrid.cells(kid, 3).getValue(),
                                validate: "^\\d+(\\.\\d+)?$",
                                required: true
                            }
                        ]
                    },
                    {
                        type: "checkbox", checked: 1, name: "check", list: [
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
                w1.setText("编辑关键结果");
                let myForm = w1.attachForm(formData);
                myForm.enableLiveValidation(true);
                myForm.attachEvent("onValidateError", function (name, value, result) {
                    dhtmlx.alert(myForm.getItemLabel(name) + ": 错误");
                    myForm.uncheckItem("check");
                });
                myForm.attachEvent("onValidateSuccess", function (name, value, result) {
                    if (parseFloat(myForm.getItemValue("weight")) > 100) {
                        dhtmlx.alert(myForm.getItemLabel("weight") + ": 错误大于了100");
                        myForm.uncheckItem("check");
                        return;
                    }
                    myForm.checkItem("check");
                });
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let data = "keyResultName=" + encodeURI(encodeURI(myForm.getItemValue("keyResultName"))) +
                            "&weight=" + encodeURI(encodeURI(myForm.getItemValue("weight"))) + "&keyResultId=" + kid;
                        let data1 = "objectId=" + oid;
                        dhx.ajax.post("departmentKeyResult/updateDepartmentKeyResult", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                keyResultGrid.clearAll(false);
                                keyResultGrid.load("departmentKeyResult/getDepartmentKeyResultsByObjectId?id=" + oid, function () {
                                }, "xml");
                                dhx.ajax.post("departmentKeyResult/checkWeight", data1, function (result) {
                                    let weightSum = parseFloat(result.xmlDoc.responseText);
                                    if (weightSum > 100) {
                                        dhtmlx.alert("权重和为" + weightSum + "大于了100，请您修改权重，或删除目标");
                                    } else if (weightSum < 100) {
                                        dhtmlx.alert("权重和为" + weightSum + " 小于100,请您修改权重，或添加目标");
                                    }
                                });
                            }
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