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
        let myLayout1, myLayout2, myLayout3, myLayout4, myLayout5, myTabBar;

        function doOnLoad() {
            myTabBar = new dhtmlXTabBar("my_tabBar");
            myTabBar.addTab("tab1", "部门OKR管理", null, null, 1);
            myTabBar.addTab("tab2", "人员OKR审查", null, null);
            myTabBar.addTab("tab3", "部门OKR审查", null, null);
            myTabBar.addTab("tab4", "对员工评分", null, null);
            myTabBar.addTab("tab5", "对下级部门评分", null, null);
            DepartmentOKRManagement();
            myTabBar.attachEvent("onTabClick", function (id) {
                if (id === "tab2") {
                    PersonOKRReview();
                }
                else if (id === "tab3") {
                    DepartmentOKRReview();
                } else if (id === "tab4") {
                    PersonOKREvaluation();
                } else if (id === "tab5") {
                    DepartmentOKREvaluation();
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

        function DepartmentOKRManagement() {

            myLayout1 = myTabBar.tabs("tab1").attachLayout("3W");
            /*左边的布局 部门树*/
            myLayout1.cells("a").setWidth(260);
            myLayout1.cells("a").setText("部门");

            let myTree = myLayout1.cells("a").attachTree();
            myTree.setImagesPath("${pageContext.request.contextPath}/codebase/images/");

            /*右边的的布局目标表*/
            myLayout1.cells("b").setText("目标");
            myLayout1.cells("b").setWidth(500);
            let myToolbarLeft = myLayout1.cells("b").attachToolbar();
            myToolbarLeft.setIconsPath("${pageContext.request.contextPath}/icons/");
            myToolbarLeft.loadStruct("${pageContext.request.contextPath}/data/toolbar.xml", function () {
            });
            myToolbarLeft.addInput("time", 4, "", 150);
            $("input").replaceWith("月份&nbsp;" +
                "<select id='month1'  class='month1' style='height:25px'>"
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

            let objectGrid = myLayout1.cells("b").attachGrid();
            objectGrid.setHeader("&nbsp,departmentId,目标名,权重(%),所属月份");
            objectGrid.setInitWidths("70,0,120,90,90");
            objectGrid.setColAlign("center,left,left,left,left");
            objectGrid.setColTypes("img,ro,ro,ro,ro");
            objectGrid.init();

            myLayout1.cells("c").setText("关键结果管理");
            let myToolbarRight = myLayout1.cells("c").attachToolbar();
            myToolbarRight.setIconsPath("${pageContext.request.contextPath}/icons/");
            myToolbarRight.loadStruct("${pageContext.request.contextPath}/data/toolbar.xml", function () {
            });
            let keyResultGrid = myLayout1.cells("c").attachGrid();
            keyResultGrid.setImagePath("${pageContext.request.contextPath}/codebase/images/");
            keyResultGrid.setIconsPath("${pageContext.request.contextPath}/icons/");
            keyResultGrid.setHeader("&nbsp;,objectId,关键结果名,权重(%)");
            keyResultGrid.setColTypes("img,ro,ro,ro");
            keyResultGrid.setInitWidths("70,0,120,90");
            keyResultGrid.setColAlign("center,left,left,left");
            keyResultGrid.init();


            $(document).ready(function () {
                $(".month1").change(function () {
                    let did = myTree.getSelectedItemId();
                    if (did === "") {
                    } else {
                        loadObject(did)
                    }
                });
            });

            /*加载部门树*/
            myTree.load("${pageContext.request.contextPath}/department/departmentTreeTwo?id=" + '${sessionScope.departmentId}', function () {
            }, "xml");

            function loadObject(departmentId) {
                keyResultGrid.clearAll(false);
                objectGrid.clearAll(false);
                objectGrid.load("${pageContext.request.contextPath}/departmentObject/getDepartmentObjectsByDepartmentId?id="
                    + departmentId + "&month=" + document.getElementById('month1').selectedIndex, function () {
                }, "xml");
            }

            /*点击加载部门的目标表*/
            myTree.attachEvent("onClick", function (id) {
                document.getElementById('month1').selectedIndex = 0;
                loadObject(id);
            });

            function loadKeyResult(objectId) {
                keyResultGrid.clearAll(false);
                keyResultGrid.load("${pageContext.request.contextPath}/departmentKeyResult/getDepartmentKeyResultsByObjectId?id=" + objectId, function () {
                }, "xml");
            }

            /*当选择目标时加载关键目标*/
            objectGrid.attachEvent("onRowSelect", function (id, ind) {
                loadKeyResult(id);
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
                if (myTree.getSelectedItemId() === '') {
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
                        let data = "objectName=" + encodeURI(encodeURI(myForm.getItemValue("objectName")))
                            + "&month=" + document.getElementById('month1').selectedIndex
                            + "&weight=" + encodeURI(encodeURI(myForm.getItemValue("weight"))) + "&departmentId=" + did;
                        dhx.ajax.post("${pageContext.request.contextPath}/departmentObject/addDepartmentObject", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                loadObject(did);
                                checkWeight("${pageContext.request.contextPath}/departmentObject/checkWeight", data);
                            }
                        });
                    }
                    dhxWins.window("w1").close();
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
                            let data = "id=" + id;
                            dhx.ajax.post("${pageContext.request.contextPath}/departmentObject/deleteDepartmentObjectById", data, function () {
                                objectGrid.deleteRow(id);
                            });
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
                        let data1 = "departmentId=" + did + "&month=" + objectGrid.cells(rid, 4).getValue();
                        dhx.ajax.post("${pageContext.request.contextPath}/departmentObject/updateDepartmentObject", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                loadObject(did);
                                checkWeight("${pageContext.request.contextPath}/departmentObject/checkWeight", data1);
                            }
                        });
                    }
                    dhxWins.window("w1").close();
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
                let w1 = dhxWins.createWindow("w1", "0", "0", "300", "280");
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
                        dhx.ajax.post("${pageContext.request.contextPath}/departmentKeyResult/addDepartmentKeyResult", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                loadKeyResult(oid);
                                checkWeight("${pageContext.request.contextPath}/departmentKeyResult/checkWeight", data);
                            }
                        });
                    }
                    dhxWins.window("w1").close();
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
                        let data = "id=" + id;
                        dhx.ajax.post("${pageContext.request.contextPath}/departmentKeyResult/deleteDepartmentKeyResultById", data, function () {
                            keyResultGrid.deleteRow(id);
                        });
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
                let w1 = dhxWins.createWindow("w1", "0", "0", "300", "280");
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
                        dhx.ajax.post("${pageContext.request.contextPath}/departmentKeyResult/updateDepartmentKeyResult", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                loadKeyResult(oid);
                                checkWeight("${pageContext.request.contextPath}/departmentKeyResult/checkWeight", data1);
                            }
                        });
                    }
                    dhxWins.window("w1").close();
                });
            }
        }

        function PersonOKRReview() {
            myLayout2 = myTabBar.tabs("tab2").attachLayout("3W");
            /*左边的布局 部门树*/
            myLayout2.cells("a").setWidth(280);
            myLayout2.cells("a").setText("部门");

            let myTree = myLayout2.cells("a").attachTree();
            myTree.setImagesPath("${pageContext.request.contextPath}/codebase/images/");

            /*右边的的布局 人员表*/
            myLayout2.cells("b").setText("人员");
            myLayout2.cells("b").setWidth(200);
            let personGrid = myLayout2.cells("b").attachGrid();
            personGrid.setImagePath("${pageContext.request.contextPath}/codebase/images/");
            personGrid.setIconsPath("${pageContext.request.contextPath}/icons/");
            personGrid.setHeader("&nbsp;,departmentId,员工名");
            personGrid.setColTypes("img,ro,ro");
            personGrid.setInitWidths("70,0,*");
            personGrid.setColAlign("center,left,left");
            personGrid.init();

            myLayout2.cells("c").setText("目标");
            let myToolbarLeft = myLayout2.cells("c").attachToolbar();
            myToolbarLeft.addInput("time", 4, "", 150);
            $("input").replaceWith("月份&nbsp;" +
                "<select id='month2' class='month2' style='height:25px'>"
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
            myToolbarLeft.setIconsPath("${pageContext.request.contextPath}/icons/");
            myToolbarLeft.loadStruct("${pageContext.request.contextPath}/data/review.xml", function () {
            });


            let objectGrid = myLayout2.cells("c").attachGrid();
            objectGrid.setHeader("&nbsp,departmentId,目标名,权重(%),所属月份,是否已通过审查");
            objectGrid.setInitWidths("70,0,140,90,90,130");
            objectGrid.setColAlign("center,left,left,left,left,left");
            objectGrid.setColTypes("img,ro,ro,ro,ro,ro");
            objectGrid.init();

            /*加载部门树*/
            myTree.load("${pageContext.request.contextPath}/department/departmentTreeFour?id=" + "${sessionScope.departmentId}", function () {
            }, "xml");

            /*加载点击部门的员工表*/
            myTree.attachEvent("onClick", function (id) {
                personGrid.clearAll(false);
                objectGrid.clearAll(false);
                personGrid.load("${pageContext.request.contextPath}/person/getPersonDepartmentManager?id=" + id, function () {
                    personGrid.deleteRow('${sessionScope.userId}');
                }, "xml");

            });

            function loadObject(personId) {
                objectGrid.clearAll(false);
                objectGrid.load("${pageContext.request.contextPath}/personObject/getPersonObjects?id=" + personId
                    + "&month=" + document.getElementById('month2').selectedIndex, function () {
                }, "xml");
            }

            /*当选择人员时加载人员的目标*/
            personGrid.attachEvent("onRowSelect", function (id, ind) {
                document.getElementById('month2').selectedIndex = 0;
                loadObject(id);
            });


            $(document).ready(function () {
                $(".month2").change(function () {
                    let pid = personGrid.getSelectedRowId();
                    if (pid === "") {
                    } else {
                        loadObject(pid)
                    }
                });
            });

            /*给通过ToolbarLeft员工目标操作*/
            myToolbarLeft.attachEvent("onClick", function () {
                review();
            });


            /*审查目标*/
            function review() {
                let rid = objectGrid.getSelectedRowId();
                if (rid == null) {
                    dhtmlx.alert("请您选择要审查的目标");
                    return;
                }
                let pid = personGrid.getSelectedRowId();
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {
                                type: "select",
                                name: "review",
                                label: "审查",
                                options: [
                                    {text: "true", value: "true"},
                                    {text: "false", value: "false"}
                                ]
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
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let data = "review=" + encodeURI(encodeURI(myForm.getItemValue("review"))) + "&objectId=" + rid;
                        dhx.ajax.post("${pageContext.request.contextPath}/personObject/reviewPersonObject", data, function (result) {
                            loadObject(pid);
                        });
                    }
                    dhxWins.window("w1").close();
                });
            }
        }

        function DepartmentOKRReview() {

            myLayout3 = myTabBar.tabs("tab3").attachLayout("2U");
            /*左边的布局 部门树*/
            myLayout3.cells("a").setWidth(260);
            myLayout3.cells("a").setText("部门");

            let myTree = myLayout3.cells("a").attachTree();
            myTree.setImagesPath("${pageContext.request.contextPath}/codebase/images/");

            /*右边的的布局目标表*/
            myLayout3.cells("b").setText("目标");
            let myToolbarLeft = myLayout3.cells("b").attachToolbar();
            myToolbarLeft.setIconsPath("${pageContext.request.contextPath}/icons/");
            myToolbarLeft.loadStruct("${pageContext.request.contextPath}/data/review.xml", function () {
            });
            myToolbarLeft.addInput("time", 4, "", 150);
            $("input").replaceWith("月份&nbsp;" +
                "<select id='month3'  class='month3' style='height:25px'>"
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

            let objectGrid = myLayout3.cells("b").attachGrid();
            objectGrid.setHeader("&nbsp,departmentId,目标名,权重(%),所属月份,是否已通过审查");
            objectGrid.setInitWidths("70,0,120,90,90,130");
            objectGrid.setColAlign("center,left,left,left,left,left");
            objectGrid.setColTypes("img,ro,ro,ro,ro,ro");
            objectGrid.init();

            $(document).ready(function () {
                $(".month3").change(function () {
                    let did = myTree.getSelectedItemId();
                    loadObject(did);
                });
            });

            /*加载部门树*/
            myTree.load("${pageContext.request.contextPath}/department/departmentTreeThree?id=" + "${sessionScope.departmentId}", function () {
            }, "xml");

            function loadObject(departmentId) {
                objectGrid.clearAll(false);
                objectGrid.load("${pageContext.request.contextPath}/departmentObject/getDepartmentObjectsByDepartmentId?id="
                    + departmentId + "&month=" + document.getElementById('month3').selectedIndex, function () {
                }, "xml");
            }

            /*点击加载部门的目标表*/
            myTree.attachEvent("onClick", function (id) {
                document.getElementById('month3').selectedIndex = 0;
                loadObject(id);
            });


            /*给通过ToolbarLeft部门目标操作*/
            myToolbarLeft.attachEvent("onClick", function () {
                review();
            });

            /*审查目标*/
            function review() {
                let rid = objectGrid.getSelectedRowId();
                if (rid == null) {
                    dhtmlx.alert("请您选择要审查的目标");
                    return;
                }
                let pid = myTree.getSelectedItemId();
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {
                                type: "select",
                                name: "review",
                                label: "审查",
                                options: [
                                    {text: "true", value: "true"},
                                    {text: "false", value: "false"}
                                ]
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
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let data = "review=" + encodeURI(encodeURI(myForm.getItemValue("review"))) + "&objectId=" + rid;
                        dhx.ajax.post("${pageContext.request.contextPath}/departmentObject/reviewDepartmentObject", data, function (result) {
                            loadObject(pid);
                        });
                    }
                    dhxWins.window("w1").close();
                });
            }
        }

        function PersonOKREvaluation() {

            myLayout4 = myTabBar.tabs("tab4").attachLayout("4W");
            /*左边的布局 部门树*/
            myLayout4.cells("a").setWidth(280);
            myLayout4.cells("a").setText("部门");

            let myTree = myLayout4.cells("a").attachTree();
            myTree.setImagesPath("${pageContext.request.contextPath}/codebase/images/");

            /*右边的的布局 人员表*/
            myLayout4.cells("b").setText("人员");
            myLayout4.cells("b").setWidth(200);
            let personGrid = myLayout4.cells("b").attachGrid();
            personGrid.setImagePath("${pageContext.request.contextPath}/codebase/images/");
            personGrid.setIconsPath("${pageContext.request.contextPath}/icons/");
            personGrid.setHeader("&nbsp;,departmentId,员工名");
            personGrid.setColTypes("img,ro,ro");
            personGrid.setInitWidths("70,0,*");
            personGrid.setColAlign("center,left,left");
            personGrid.init();

            myLayout4.cells("c").setText("目标");
            let myToolbarLeft = myLayout4.cells("c").attachToolbar();
            myToolbarLeft.addInput("time", 4, "", 150);
            $("input").replaceWith("月份&nbsp;" +
                "<select id='month4' class='month4' style='height:25px'>"
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

            myLayout4.cells("c").setWidth(500);
            let objectGrid = myLayout4.cells("c").attachGrid();
            objectGrid.setHeader("&nbsp,departmentId,目标名,权重(%),所属月份,是否已通过审查");
            objectGrid.setInitWidths("70,0,140,90,90,130");
            objectGrid.setColAlign("center,left,left,left,left,left");
            objectGrid.setColTypes("img,ro,ro,ro,ro,ro");
            objectGrid.init();


            let keyResultGrid = myLayout4.cells("d").attachGrid();
            myLayout4.cells("d").setText("关键结果");
            keyResultGrid.setImagePath("${pageContext.request.contextPath}/codebase/images/");
            keyResultGrid.setIconsPath("${pageContext.request.contextPath}/icons/");
            keyResultGrid.setHeader("&nbsp;,objectId,关键结果名,权重(%),自评分数,上级评分");
            keyResultGrid.setColTypes("img,ro,ro,ro,ro,ro");
            keyResultGrid.setInitWidths("70,0,120,90,90,90");
            keyResultGrid.setColAlign("center,left,left,left,left,left");
            keyResultGrid.init();

            let resultToolBar = myLayout4.cells("d").attachToolbar();
            resultToolBar.setIconsPath("${pageContext.request.contextPath}/icons/");
            resultToolBar.loadStruct("${pageContext.request.contextPath}/data/evaluation.xml", function () {
            });
            /*加载部门树*/
            myTree.load("${pageContext.request.contextPath}/department/departmentTreeFour?id=" + "${sessionScope.departmentId}", function () {
            }, "xml");

            /*加载点击部门的员工表*/
            myTree.attachEvent("onClick", function (id) {
                personGrid.clearAll(false);
                objectGrid.clearAll(false);
                personGrid.load("${pageContext.request.contextPath}/person/getPersonDepartmentManager?id=" + id, function () {
                    personGrid.deleteRow('${sessionScope.userId}');
                }, "xml");

            });

            function loadObject(personId) {
                objectGrid.clearAll(false);
                objectGrid.load("${pageContext.request.contextPath}/personObject/getPersonObjects?id=" + personId
                    + "&month=" + document.getElementById('month4').selectedIndex, function () {
                }, "xml");
            }

            function loadKeyResult(objectId) {
                keyResultGrid.clearAll(false);
                keyResultGrid.load("${pageContext.request.contextPath}/personKeyResult/getPersonKeyResultsByObjectId?id=" + objectId, function () {
                }, "xml");
            }

            /*当选择人员时加载人员的目标*/
            personGrid.attachEvent("onRowSelect", function (id, ind) {
                document.getElementById('month4').selectedIndex = 0;
                loadObject(id);
            });


            objectGrid.attachEvent("onRowSelect", function (id, ind) {
                loadKeyResult(id);
            });


            $(document).ready(function () {
                $(".month4").change(function () {
                    let pid = personGrid.getSelectedRowId();
                    loadObject(pid);
                });
            });


            resultToolBar.attachEvent("onClick", function () {
                evaluation();
            });

            /*评价关键结果*/
            function evaluation() {
                let oid = objectGrid.getSelectedRowId();
                let rid = keyResultGrid.getSelectedRowId();
                if (rid == null) {
                    dhtmlx.alert("请选中要评价的关键结果");
                    return;
                }
                if (objectGrid.cells(oid, 5).getValue() === "false") {
                    dhtmlx.alert("目标还没有通过审查确认，关键结果不可评价");
                    return;
                }
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {
                                type: "input",
                                name: "evaluation",
                                label: "上级评分",
                                value: keyResultGrid.cells(rid, 5).getValue(),
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
                w1.setText("编辑关键结果");
                let myForm = w1.attachForm(formData);
                myForm.enableLiveValidation(true);

                myForm.attachEvent("onValidateSuccess", function (name, value, result) {
                    if (parseFloat(myForm.getItemValue("evaluation")) > 100) {
                        dhtmlx.alert(myForm.getItemLabel("evaluation") + ": 错误大于了100");
                        myForm.uncheckItem("check");
                        return;
                    }
                    myForm.checkItem("check");
                });
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let data = "evaluation=" + encodeURI(encodeURI(myForm.getItemValue("evaluation"))) + "&keyResultId=" + rid;
                        dhx.ajax.post("${pageContext.request.contextPath}/personKeyResult/upstreamEvaluation", data, function () {
                            loadKeyResult(objectGrid.getSelectedRowId());
                        });
                    }
                    dhxWins.window("w1").close();
                });
            }
        }

        function DepartmentOKREvaluation() {

            myLayout5 = myTabBar.tabs("tab5").attachLayout("3W");
            /*左边的布局 部门树*/
            myLayout5.cells("a").setWidth(260);
            myLayout5.cells("a").setText("部门");

            let myTree = myLayout5.cells("a").attachTree();
            myTree.setImagesPath("${pageContext.request.contextPath}/codebase/images/");

            /*右边的的布局目标表*/
            myLayout5.cells("b").setText("目标");
            let myToolbarLeft = myLayout5.cells("b").attachToolbar();
            myToolbarLeft.setIconsPath("${pageContext.request.contextPath}/icons/");
            myToolbarLeft.addInput("time", 4, "", 150);
            $("input").replaceWith("月份&nbsp;" +
                "<select id='month5'  class='month5' style='height:25px'>"
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

            let objectGrid = myLayout5.cells("b").attachGrid();
            objectGrid.setHeader("&nbsp,departmentId,目标名,权重(%),所属月份,是否已通过审查");
            objectGrid.setInitWidths("70,0,120,90,90,130");
            objectGrid.setColAlign("center,left,left,left,left,left");
            objectGrid.setColTypes("img,ro,ro,ro,ro,ro");
            objectGrid.init();

            myLayout5.cells("c").setText("关键结果");
            let keyResultGrid = myLayout5.cells("c").attachGrid();
            keyResultGrid.setImagePath("${pageContext.request.contextPath}/codebase/images/");
            keyResultGrid.setIconsPath("${pageContext.request.contextPath}/icons/");
            keyResultGrid.setHeader("&nbsp;,objectId,关键结果名,权重(%),自评分数,上级评分");
            keyResultGrid.setColTypes("img,ro,ro,ro,ro,ro");
            keyResultGrid.setInitWidths("70,0,120,90,90,90");
            keyResultGrid.setColAlign("center,left,left,left,left,left");
            keyResultGrid.init();

            let resultToolBar = myLayout5.cells("c").attachToolbar();
            resultToolBar.setIconsPath("${pageContext.request.contextPath}/icons/");
            resultToolBar.loadStruct("${pageContext.request.contextPath}/data/evaluation.xml", function () {
            });

            /*加载部门树*/
            myTree.load("${pageContext.request.contextPath}/department/departmentTreeThree?id=" + "${sessionScope.departmentId}", function () {
            }, "xml");

            $(document).ready(function () {
                $(".month5").change(function () {
                    let did = myTree.getSelectedItemId();
                    loadObject(did);
                });
            });


            function loadObject(departmentId) {
                objectGrid.clearAll(false);
                objectGrid.load("${pageContext.request.contextPath}/departmentObject/getDepartmentObjectsByDepartmentId?id="
                    + departmentId + "&month=" + document.getElementById('month5').selectedIndex, function () {
                }, "xml");
            }

            /*点击加载部门的目标表*/
            myTree.attachEvent("onClick", function (id) {
                document.getElementById('month5').selectedIndex = 0;
                loadObject(id);
            });

            function loadKeyResult(objectId) {
                keyResultGrid.clearAll(false);
                keyResultGrid.load("${pageContext.request.contextPath}/departmentKeyResult/getDepartmentKeyResultsByObjectId?id=" + objectId, function () {
                }, "xml");
            }

            objectGrid.attachEvent("onRowSelect", function (id, ind) {
                loadKeyResult(id);
            });

            resultToolBar.attachEvent("onClick", function () {
                evaluation();
            });


            function evaluation() {
                let kid = keyResultGrid.getSelectedRowId();
                if (kid == null) {
                    dhtmlx.alert("请选中您将要打分的关键结果");
                    return;
                }

                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 90, inputWidth: 200, position: "label-left"},
                            {
                                type: "input",
                                name: "evaluation",
                                label: "分数",
                                value: keyResultGrid.cells(kid, 4).getValue(),
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
                w1.setText("编辑关键结果");
                let myForm = w1.attachForm(formData);
                myForm.enableLiveValidation(true);
                myForm.attachEvent("onValidateError", function (name, value, result) {
                    dhtmlx.alert(myForm.getItemLabel(name) + ": 错误");
                    myForm.uncheckItem("check");
                });
                myForm.attachEvent("onValidateSuccess", function (name, value, result) {
                    if (parseFloat(myForm.getItemValue("evaluation")) > 100) {
                        dhtmlx.alert(myForm.getItemLabel("evaluation") + ": 错误大于了100");
                        myForm.uncheckItem("check");
                        return;
                    }
                    myForm.checkItem("check");
                });
                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let data = "evaluation=" + encodeURI(encodeURI(myForm.getItemValue("evaluation"))) + "&keyResultId=" + kid;
                        dhx.ajax.post("${pageContext.request.contextPath}/departmentKeyResult/upstreamEvaluationDepartmentKeyResult", data, function (result) {
                            loadKeyResult(objectGrid.getSelectedRowId());
                        });
                    }
                    dhxWins.window("w1").close();
                });
            }

        }

    </script>
</head>
<body onload="doOnLoad();">
<div id="my_tabBar" style="width: 100%; height:100%;"></div>
</body>
</html>