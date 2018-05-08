<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>企业OKR管理系统</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script>
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
            myTabBar.addTab("tab2", "人员OKR管理", null, null);
            myTabBar.addTab("tab3", "部门OKR管理", null, null);
            // OrganizationManagement();
            myTabBar.attachEvent("onTabClick", function (id, lastId) {
                if (id === "tab3") {
                    // DepartmentOKRManagement();
                }
                else if (id === "tab2") {
                    PersonOKRManagement();
                }
            });
        }

        function checkWeight(url, data) {
            dhx.ajax.post(url, data, function (result) {
                let temp = result.xmlDoc.responseText;
                if (temp !== "") {
                    dhtmlx.alert({
                        title: "警告!⚠️",
                        type: "alert-error",
                        text: temp
                    });
                }
            });
        }

        function PersonOKRManagement() {

            myLayout = myTabBar.tabs("tab2").attachLayout("4W");
            /*左边的布局 部门树*/
            myLayout.cells("a").setWidth(260);
            myLayout.cells("a").setText("部门");

            let myTree = myLayout.cells("a").attachTree();
            myTree.setImagesPath("codebase/images/");

            /*右边的的布局 人员表*/
            myLayout.cells("b").setText("人员");
            myLayout.cells("b").setWidth(200);
            let personGrid = myLayout.cells("b").attachGrid();
            personGrid.setImagePath("codebase/images/");
            personGrid.setIconsPath("icons/");
            personGrid.setHeader("&nbsp;,departmentId,员工名");
            personGrid.setColTypes("img,ro,ro");
            personGrid.setInitWidths("70,0,*");
            personGrid.setColAlign("center,left,left");
            personGrid.init();

            myLayout.cells("c").setText("目标");
            myLayout.cells("c").setWidth(500);
            let myToolbarLeft = myLayout.cells("c").attachToolbar();
            myToolbarLeft.addInput("time", 4, "", 150);
            $("input").replaceWith("月份&nbsp;" +
                "<select id='month'  class='month' style='height:25px'>"
                + "<option ></option>"
                + "<option >1</option>"
                + "<option >2</option>"
                + "<option >3</option>"
                + "<option >4</option>"
                + "<option >5</option>"
                + "<option >6</option>"
                + "<option >7</option>"
                + "<option >8</option>"
                + "<option >9</option>"
                + "<option >10</option>"
                + "<option >11</option>"
                + "<option >12</option>"
                + "</select>");
            myToolbarLeft.setIconsPath("icons/");
            myToolbarLeft.loadStruct("data/toolbar.xml", function () {
            });


            let objectGrid = myLayout.cells("c").attachGrid();
            objectGrid.setHeader("&nbsp,departmentId,目标名,权重(%),所属月份");
            objectGrid.setInitWidths("70,0,120,90,90");
            objectGrid.setColAlign("center,left,left,left,left");
            objectGrid.setColTypes("img,ro,ro,ro,ro");
            objectGrid.init();

            myLayout.cells("d").setText("关键结果管理");
            let myToolbarRight = myLayout.cells("d").attachToolbar();
            myToolbarRight.setIconsPath("icons/");
            myToolbarRight.loadStruct("data/toolbar.xml", function () {
            });
            let keyResultGrid = myLayout.cells("d").attachGrid();
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

            function loadObject(personId) {
                keyResultGrid.clearAll(false);
                objectGrid.clearAll(false);
                objectGrid.load("personObject/getPersonObjects?id=" + personId
                    + "&month=" + document.getElementById('month').selectedIndex, function () {
                }, "xml");
            }

            /*当选择人员时加载人员的目标*/
            personGrid.attachEvent("onRowSelect", function (id, ind) {
                document.getElementById('month').selectedIndex = 0;
                loadObject(id)
            });

            /*当选择人员目标时加载关键目标*/
            objectGrid.attachEvent("onRowSelect", function (id, ind) {
                loadKeyResult(id);
            });

            $(document).ready(function () {
                $(".month").change(function () {
                    let pid = personGrid.getSelectedRowId();
                    if (pid === "") {
                    } else {
                        loadObject(pid)
                    }
                });
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
                    case 'edit':
                        editPersonObject();
                        break;
                }
            });

            /*添加目标*/
            function addPersonObject() {
                if (personGrid.getSelectedRowId() == null) {
                    dhtmlx.alert("请您先选中，您要为哪个人添加目标");
                    return;
                }
                if (document.getElementById("month").selectedIndex === 0) {
                    dhtmlx.alert("请您先选中，您要为哪个月添加添加目标");
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
                        let pid = personGrid.getSelectedRowId();
                        let data = "objectName=" + encodeURI(encodeURI(myForm.getItemValue("objectName")))
                            + "&month=" + document.getElementById('month').selectedIndex
                            + "&weight=" + encodeURI(encodeURI(myForm.getItemValue("weight")))
                            + "&personId=" + pid;
                        dhx.ajax.post("personObject/addPersonObject", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                loadObject(pid);
                                checkWeight("personObject/checkWeight", data);
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
                        let data = "objectName=" + encodeURI(encodeURI(myForm.getItemValue("objectName"))) +
                            "&weight=" + encodeURI(encodeURI(myForm.getItemValue("weight"))) + "&objectId=" + rid;
                        let data1 = "personId=" + pid + "&month=" + objectGrid.cells(rid, 4).getValue();
                        dhx.ajax.post("personObject/updatePersonObject", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                loadObject(pid);
                                checkWeight("personObject/checkWeight", data1)
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

            function loadKeyResult(objectId) {
                keyResultGrid.clearAll(false);
                keyResultGrid.load("personKeyResult/getPersonKeyResultsByObjectId?id=" + objectId, function () {
                }, "xml");
            }

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
                        let oid = objectGrid.getSelectedRowId();
                        let data = "keyResultName=" + encodeURI(encodeURI(myForm.getItemValue("keyResultName")))
                            + "&weight=" + encodeURI(encodeURI(myForm.getItemValue("weight"))) + "&personObjectId=" + oid;
                        dhx.ajax.post("personKeyResult/addPersonKeyResult", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                loadObject(oid);
                                checkWeight("personKeyResult/checkWeight", data)
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
                                loadKeyResult(oid);
                                checkWeight("personKeyResult/checkWeight", data1);
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

