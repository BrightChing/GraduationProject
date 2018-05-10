<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        let phoneReg = "^((13[0-9])|(14[579])|(15([0-3]|[5-9]))|(17[35-8])|(18[0-9]))\\d{8}$";
        let emailReg = "^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
        let passwordReg = "^\\w{6,32}$";

        function doOnLoad() {
            myTabBar = new dhtmlXTabBar("my_tabBar");
            myTabBar.addTab("tab1", "人员OKR管理", null, null, 1);
            myTabBar.addTab("tab2", "自评", null, null);
            PersonOKRManagement();
            selfEvaluation();
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
            myLayout = myTabBar.tabs("tab1").attachLayout("3W");

            /*右边的的布局 人员表*/
            myLayout.cells("a").setText("人员");
            myLayout.cells("a").setWidth(700);
            let personButton = myLayout.cells("a").attachToolbar();
            personButton.setIconsPath("${pageContext.request.contextPath}/icons/");
            personButton.loadStruct("${pageContext.request.contextPath}/data/editButton.xml", function () {
            });
            let personGrid = myLayout.cells("a").attachGrid();
            personGrid.setImagePath("${pageContext.request.contextPath}/codebase/images/");
            personGrid.setIconsPath("${pageContext.request.contextPath}/icons/");
            personGrid.setHeader("&nbsp;,departmentId,loginId,password,员工名,职位,邮箱,手机号,地址");
            personGrid.setColTypes("img,ro,ro,ro,ro,ro,ro,ro,ro");
            personGrid.setInitWidths("70,0,0,0,100,100,150,120,*");
            personGrid.setColAlign("center,left,left,left,left,left,left,left,left");
            personGrid.init();

            myLayout.cells("b").setText("目标");
            myLayout.cells("b").setWidth(500);
            let objectToolBar = myLayout.cells("b").attachToolbar();
            objectToolBar.addInput("time", 4, "", 150);
            $("input").replaceWith("月份&nbsp;" +
                "<select id='month' class='month' style='height:25px'>"
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
            objectToolBar.setIconsPath("${pageContext.request.contextPath}/icons/");
            objectToolBar.loadStruct("${pageContext.request.contextPath}/data/toolbar.xml", function () {
            });

            let objectGrid = myLayout.cells("b").attachGrid();
            objectGrid.setHeader("&nbsp,departmentId,目标名,权重(%),所属月份,是否已通过审查");
            objectGrid.setInitWidths("70,0,120,90,90,130");
            objectGrid.setColAlign("center,left,left,left,left,left");
            objectGrid.setColTypes("img,ro,ro,ro,ro,ro");
            objectGrid.init();

            myLayout.cells("c").setText("关键结果管理");
            let resultToolBar = myLayout.cells("c").attachToolbar();
            resultToolBar.setIconsPath("${pageContext.request.contextPath}/icons/");
            resultToolBar.loadStruct("${pageContext.request.contextPath}/data/toolbar.xml", function () {
            });
            let keyResultGrid = myLayout.cells("c").attachGrid();
            keyResultGrid.setImagePath("${pageContext.request.contextPath}/codebase/images/");
            keyResultGrid.setIconsPath("${pageContext.request.contextPath}/icons/");
            keyResultGrid.setHeader("&nbsp;,objectId,关键结果名,权重(%),自评分数");
            keyResultGrid.setColTypes("img,ro,ro,ro,ro");
            keyResultGrid.setInitWidths("70,0,120,90,90");
            keyResultGrid.setColAlign("center,left,left,left,left");
            keyResultGrid.init();
            personGrid.load("${pageContext.request.contextPath}/person/getPersonById?id=" + '${sessionScope.userId}', function () {
            }, "xml");

            personButton.attachEvent("onClick", function (id) {
                editPerson();
            });

            function loadObject(personId) {
                keyResultGrid.clearAll(false);
                objectGrid.clearAll(false);
                objectGrid.load("${pageContext.request.contextPath}/personObject/getPersonObjects?id=" + personId
                    + "&month=" + document.getElementById('month').selectedIndex, function () {
                }, "xml");
            }


            function editPerson() {
                let rid = '${sessionScope.userId}';
                let formData = [
                    {
                        type: "checkbox", checked: true, list: [
                            {type: "settings", labelWidth: 60, inputWidth: 200, position: "label-left"},
                            {
                                type: "input",
                                name: "loginId",
                                label: "登录名",
                                value: personGrid.cells(rid, 2).getValue(),
                                required: true
                            },
                            {
                                type: "password",
                                name: "password",
                                label: "密码",
                                value: personGrid.cells(rid, 3).getValue(),
                                required: true
                            },
                            {
                                type: "input",
                                name: "personName",
                                label: "员工名",
                                value: personGrid.cells(rid, 4).getValue(),
                                required: true
                            },
                            {
                                type: "input",
                                name: "position",
                                label: "职位",
                                value: personGrid.cells(rid, 5).getValue(),
                                required: true
                            },
                            {
                                type: "input",
                                name: "email",
                                label: "邮箱",
                                value: personGrid.cells(rid, 6).getValue(),
                                validate: emailReg,
                                required: true
                            },
                            {
                                type: "input",
                                name: "phone",
                                label: "手机号",
                                value: personGrid.cells(rid, 7).getValue(),
                                validate: phoneReg,
                                required: true
                            },
                            {
                                type: "input",
                                name: "address",
                                label: "地址",
                                value: personGrid.cells(rid, 8).getValue(),
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
                let w1 = dhxWins.createWindow("w1", "0", "0", "380", "400");
                dhxWins.window("w1").center();
                w1.setText("编辑人员");

                let myForm = w1.attachForm(formData);
                myForm.enableLiveValidation(true);
                let loginIdFlag = true, passwordFlag = true, personNameFlag = true,
                    positionFlag = true, emailFlag = true, phoneFlag = true, addressFlag = true;
                myForm.attachEvent("onValidateError", function (name, value, result) {
                    switch (name) {
                        case "loginId" :
                            loginIdFlag = false;
                            break;
                        case "personName":
                            personNameFlag = false;
                            break;
                        case "position":
                            positionFlag = false;
                            break;
                        case "email":
                            emailFlag = false;
                            break;
                        case "phone":
                            phoneFlag = false;
                            break;
                        case "address":
                            addressFlag = false;
                            break;
                    }
                    dhtmlx.alert(myForm.getItemLabel(name) + ": 错误");
                    myForm.uncheckItem("check");
                });

                myForm.attachEvent("onValidateSuccess", function (name, value, result) {
                    switch (name) {
                        case "loginId" :
                            loginIdFlag = true;
                            break;
                        case "personName":
                            personNameFlag = true;
                            break;
                        case "position":
                            positionFlag = true;
                            break;
                        case "email":
                            emailFlag = true;
                            break;
                        case "phone":
                            phoneFlag = true;
                            break;
                        case "address":
                            addressFlag = true;
                            break;
                    }
                    if (name === "password") {
                        let rex = new RegExp(passwordReg);
                        if (!rex.test(value)) {
                            dhtmlx.alert("密码格式错误，长度应在6~32位之间，只能包含字母、数字和下划线");
                            myForm.uncheckItem("check");
                            passwordFlag = false;
                            return;
                        }
                        else {
                            passwordFlag = true;
                        }
                    }
                    if (loginIdFlag && passwordFlag && personNameFlag && positionFlag && emailFlag && phoneFlag && addressFlag) {
                        myForm.checkItem("check");
                    }

                });

                myForm.attachEvent("onButtonClick", function (name) {
                    if (name === "OK") {
                        let data = "personId=" + rid + "&personName=" + myForm.getItemValue("personName")
                            + "&position=" + myForm.getItemValue("position") + "&email=" + myForm.getItemValue("email")
                            + "&phone=" + myForm.getItemValue("phone") + "&password=" + myForm.getItemValue("password")
                            + "&address=" + myForm.getItemValue("address") + "&loginId=" + myForm.getItemValue("loginId");
                        dhx.ajax.post("${pageContext.request.contextPath}/person/updatePerson", data, function (result) {
                            if (result.xmlDoc.responseText === "loginIdNotNull") {
                                dhtmlx.alert("该登录名已存在，请您更换登录名！")
                            } else {
                                personGrid.clearAll(false);
                                personGrid.load("${pageContext.request.contextPath}/person/getPersonById?id=" + '${sessionScope.userId}', function () {
                                }, "xml");
                            }
                        });
                    }
                    dhxWins.window("w1").close();
                });
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
            objectToolBar.attachEvent("onClick", function (id) {
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
                        dhx.ajax.post("${pageContext.request.contextPath}/personObject/addPersonObject", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                loadObject(pid);
                                checkWeight("${pageContext.request.contextPath}/personObject/checkWeight", data);
                            }
                        });
                    }
                    dhxWins.window("w1").close();
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
                            let data = "id=" + id;
                            dhx.ajax.post("${pageContext.request.contextPath}/personObject/deletePersonObjectById", data, function () {
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
                        dhx.ajax.post("${pageContext.request.contextPath}/personObject/updatePersonObject", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                loadObject(pid);
                                checkWeight("${pageContext.request.contextPath}/personObject/checkWeight", data1)
                            }
                        });
                    }
                    dhxWins.window("w1").close();
                });
            }

            /*给通过resultToolBar对员工关键结果进行操作*/
            resultToolBar.attachEvent("onClick", function (id) {
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
                keyResultGrid.load("${pageContext.request.contextPath}/personKeyResult/getPersonKeyResultsByObjectId?id=" + objectId, function () {
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
                        let data = "keyResultName=" + encodeURI(encodeURI(myForm.getItemValue("keyResultName")))
                            + "&weight=" + encodeURI(encodeURI(myForm.getItemValue("weight"))) + "&personObjectId=" + oid;
                        dhx.ajax.post("${pageContext.request.contextPath}/personKeyResult/addPersonKeyResult", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                loadKeyResult(oid);
                                checkWeight("${pageContext.request.contextPath}/personKeyResult/checkWeight", data)
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
                    dhtmlx.alert("请选中您将要删除的关键结果");
                    return;
                }
                dhtmlx.confirm('主人，真的要狠心删除我吗', function (result) {
                    if (result) {
                        let data = "id=" + id;
                        dhx.ajax.post("${pageContext.request.contextPath}/personKeyResult/deletePersonKeyResultById", data, function () {
                            keyResultGrid.deleteRow(id);
                        });
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
                        let data = "keyResultName=" + encodeURI(encodeURI(myForm.getItemValue("keyResultName")))
                            + "&weight=" + encodeURI(encodeURI(myForm.getItemValue("weight"))) + "&keyResultId=" + rid;
                        let data1 = "personObjectId=" + oid;
                        dhx.ajax.post("${pageContext.request.contextPath}/personKeyResult/updatePersonKeyResult", data, function (result) {
                            if (result.xmlDoc.responseText === "true") {
                                loadKeyResult(oid);
                                checkWeight("${pageContext.request.contextPath}/personKeyResult/checkWeight", data1);
                            }
                        });
                    }
                    dhxWins.window("w1").close();
                });
            }
        }

        function selfEvaluation() {
            myLayout = myTabBar.tabs("tab2").attachLayout("2U");

            myLayout.cells("a").setText("目标");
            myLayout.cells("a").setWidth(500);
            let objectToolBar = myLayout.cells("a").attachToolbar();
            objectToolBar.addInput("time", 4, "", 150);
            $("input").replaceWith("月份&nbsp;" +
                "<select id='month1' class='month1' style='height:25px'>"
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

            let objectGrid = myLayout.cells("a").attachGrid();
            objectGrid.setHeader("&nbsp,departmentId,目标名,权重(%),所属月份,是否已通过审查");
            objectGrid.setInitWidths("70,0,120,90,90,130");
            objectGrid.setColAlign("center,left,left,left,left,left");
            objectGrid.setColTypes("img,ro,ro,ro,ro,ro");
            objectGrid.init();

            myLayout.cells("b").setText("关键结果管理");
            let resultToolBar = myLayout.cells("b").attachToolbar();
            resultToolBar.setIconsPath("${pageContext.request.contextPath}/icons/");
            resultToolBar.loadStruct("${pageContext.request.contextPath}/data/evaluation.xml", function () {
            });
            let keyResultGrid = myLayout.cells("b").attachGrid();
            keyResultGrid.setImagePath("${pageContext.request.contextPath}/codebase/images/");
            keyResultGrid.setIconsPath("${pageContext.request.contextPath}/icons/");
            keyResultGrid.setHeader("&nbsp;,objectId,关键结果名,权重(%),自评分数,上级评分");
            keyResultGrid.setColTypes("img,ro,ro,ro,ro,ro");
            keyResultGrid.setInitWidths("70,0,120,90,90,90");
            keyResultGrid.setColAlign("center,left,left,left,left,left");
            keyResultGrid.init();

            loadObject('${sessionScope.userId}');

            function loadObject(personId) {
                keyResultGrid.clearAll(false);
                objectGrid.clearAll(false);
                objectGrid.load("${pageContext.request.contextPath}/personObject/getPersonObjects?id=" + personId
                    + "&month=" + document.getElementById('month1').selectedIndex, function () {
                }, "xml");
            }


            /*当选择人员目标时加载关键目标*/
            objectGrid.attachEvent("onRowSelect", function (id, ind) {
                loadKeyResult(id);
            });

            $(document).ready(function () {
                $(".month1").change(function () {
                    loadObject('${sessionScope.userId}');
                });
            });


            /*给通过resultToolBar对员工关键结果进行操作*/
            resultToolBar.attachEvent("onClick", function (id) {
                evaluation()
            });

            function loadKeyResult(objectId) {
                keyResultGrid.clearAll(false);
                keyResultGrid.load("${pageContext.request.contextPath}/personKeyResult/getPersonKeyResultsByObjectId?id=" + objectId, function () {
                }, "xml");
            }

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
                                label: "得分",
                                value: keyResultGrid.cells(rid, 4).getValue(),
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
                        let data = "evaluation=" + encodeURI(encodeURI(myForm.getItemValue("evaluation"))) + "&keyResultId=" + rid;
                        dhx.ajax.post("${pageContext.request.contextPath}/personKeyResult/selfEvaluation", data, function () {
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
<div id="my_tabBar" style="width: 100%; height:100%;">
</div>
</body>
</html>