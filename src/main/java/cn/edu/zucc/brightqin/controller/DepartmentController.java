package cn.edu.zucc.brightqin.controller;

import cn.edu.zucc.brightqin.entity.Department;
import cn.edu.zucc.brightqin.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.validation.Valid;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * Description:
 * User: brightqin
 * Date: 2018-04-03
 *
 * @author brightqin
 */
@Controller
@RequestMapping(value = "/department")
public class DepartmentController {
    private final DepartmentService departmentService;

    @Autowired
    public DepartmentController(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }


    /**
     * 保存Department
     *
     * @param department department
     * @param result     result
     * @param map        map
     * @return departmentSavePage|redirect:main
     */
    @RequestMapping(value = "/saveDepartment", method = RequestMethod.POST)
    public String saveDepartment(@Valid Department department, BindingResult result, ModelMap map) {
        if (result.hasErrors()) {
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error : errors) {
                map.put("ERROR_" + error.getField(), error.getDefaultMessage());
                System.out.println(error.getField() + "*" + error.getDefaultMessage());
            }
            return "departmentSavePage";
        } else {
            departmentService.addDepartment(department);
            return "redirect:main";
        }
    }

    /**
     * 跳转到添加页面
     *
     * @return departmentSavePage
     */
    @RequestMapping(value = "/addDepartment")
    public String addDepartment() {
        return "departmentSavePage";
    }

    /**
     * 删除一条数据
     *
     * @param id 部门ID
     * @return redirect:main
     */
    @RequestMapping(value = "/deleteDepartmentById")
    public String deleteDepartmentById(@RequestParam(value = "id") String id) {
        departmentService.deleteDepartmentById(id);
        return "redirect:main";
    }

    /**
     * 跳转到更新页面，回显数据
     *
     * @param id    部门ID
     * @param model 使用的Model保存回显数据
     * @return personEditPage.jsp
     */
    @RequestMapping(value = "/doUpdate")
    public String doUpdate(@RequestParam(value = "id") String id, Model model) {
        model.addAttribute("department", departmentService.getDepartmentById(id));
        return "departmentEditPage";
    }


    /**
     * 更新数据
     *
     * @param department 部门
     * @param result error
     * @param map 回去传数据
     * @return departmentEditPage|redirect:main
     */
    @RequestMapping(value = "/updateDepartment")
    public String updateDepartment(@Valid Department department, BindingResult result, ModelMap map) {
        if (result.hasErrors()) {
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error : errors) {
                map.put("ERROR_" + error.getField(), error.getDefaultMessage());
                System.out.println(error.getField() + "*" + error.getDefaultMessage());
            }
            return "departmentEditPage";
        } else {
            departmentService.updateDepartment(department);
            return "redirect:main";
        }
    }

    /**
     * 查询所有人员信息
     *
     * @param map 使用的是map保存回显数据
     * @return departmentMain
     */
    @RequestMapping(value = "/main")
    public String main(Map<String, Object> map) {
        map.put("departmentList", departmentService.getDepartments());
        return "departmentMain";
    }
}
