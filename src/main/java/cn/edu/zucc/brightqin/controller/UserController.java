package cn.edu.zucc.brightqin.controller;


import cn.edu.zucc.brightqin.entity.User;
import cn.edu.zucc.brightqin.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import java.util.Map;

@SessionAttributes(value = "username")
@Controller    //使用该注解标志它是一个控制器
@RequestMapping(value = "/user")
public class UserController {
    @Autowired
    private UserService userService;

    @RequestMapping("/login")
    public String doLogin(@Validated String id, String password, Map<String, Object> map) {
        User user = userService.getUserById(id);
        if (user != null && password.equals(user.getPassword())) {
            map.put("username", id);//存放在request请求域中
            return "frame";
        }
        return "error";
    }

    /**
     * 保存添加的数据
     *
     * @param user
     * @return
     */
    @RequestMapping(value = "/saveUser")
    public String savePerson(User user) {
        userService.addUser(user);
        return "redirect:main";
    }

    /**
     * 跳转到添加页面
     * savePage.jsp
     *
     * @return
     */
    @RequestMapping(value = "/addUser")
    public String saveUser() {
        return "savePage";
    }

    /**
     * 删除一条数据
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/deleteUserById")
    public String deleteUserById(@RequestParam(value = "id") String id) {
        System.out.println("删除单个");
        userService.deleteUserById(id);
        return "redirect:main";
    }

    /**
     * 跳转到更新页面，回显数据
     * editPage.jsp
     *
     * @param id
     * @param model 使用的Model保存回显数据
     * @return
     */
    @RequestMapping(value = "/doUpdate")
    public String doUpdate(@RequestParam(value = "id") String id, Model model) {
        model.addAttribute("user", userService.getUserById(id));
        return "editPage";
    }

    /**
     * 更新数据
     *
     * @param user
     * @return
     */
    @RequestMapping(value = "/updateUser")
    public String updateUser(User user) {
        userService.updateUser(user);
        return "redirect:main";
    }


}
