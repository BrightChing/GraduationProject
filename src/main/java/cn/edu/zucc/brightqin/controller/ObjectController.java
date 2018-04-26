package cn.edu.zucc.brightqin.controller;

import cn.edu.zucc.brightqin.entity.Object;
import cn.edu.zucc.brightqin.entity.Object;
import cn.edu.zucc.brightqin.service.ObjectService;
import cn.edu.zucc.brightqin.service.ObjectService;
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
 * @author brightqin
 */
@Controller
@RequestMapping(value = "/Object")
public class ObjectController {
    @Autowired
    ObjectService objectService;

    /**
     * 保存Company
     *
     * @param Object Object
     * @param result     result
     * @param map        map
     * @return ObjectSavePage|redirect:main
     */
    @RequestMapping(value = "/saveObject", method = RequestMethod.POST)
    public String saveObject(@Valid Object object, BindingResult result, ModelMap map) {
        if (result.hasErrors()) {
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error : errors) {
                map.put("ERROR_" + error.getField(), error.getDefaultMessage());
                System.out.println(error.getField() + "*" + error.getDefaultMessage());
            }
            return "objectSavePage";
        } else {
            objectService.addObject(object);
            return "redirect:main";
        }
    }

    /**
     * 跳转到添加页面
     *
     * @return ObjectSavePage
     */
    @RequestMapping(value = "/addObject")
    public String addObject() {
        return "objectSavePage";
    }

    /**
     * 删除一条数据
     *
     * @param id 部门ID
     * @return redirect:main
     */
    @RequestMapping(value = "/deleteObjectById")
    public String deleteObjectById(@RequestParam(value = "id") String id) {
        objectService.getObjectById(id);
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
        model.addAttribute("Object", objectService.getObjectById(id));
        return "objectEditPage";
    }


    /**
     * 更新数据
     *
     * @param object 目标
     * @param result error
     * @param map 回去传数据
     * @return ObjectEditPage|redirect:main
     */
    @RequestMapping(value = "/updateObject")
    public String updateObject(@Valid Object object, BindingResult result, ModelMap map) {
        if (result.hasErrors()) {
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error : errors) {
                map.put("ERROR_" + error.getField(), error.getDefaultMessage());
                System.out.println(error.getField() + "*" + error.getDefaultMessage());
            }
            return "objectEditPage";
        } else {
            objectService.updateObject(object);
            return "redirect:main";
        }
    }

    /**
     * 查询所有人员信息
     *
     * @param map 使用的是map保存回显数据
     * @return ObjectMain
     */
    @RequestMapping(value = "/main")
    public String main(Map<String, java.lang.Object> map) {
        map.put("objectList", objectService.getObjects());
        return "objectMain";
    }
}