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

/**
 * @author brightqin
 */
@SessionAttributes(value = "username")
@Controller
@RequestMapping(value = "/user")
public class UserController {
    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @RequestMapping("/login")
    public String doLogin(@Validated String id, String password, Map<String, Object> map) {
        User user = userService.getUserById(id);
        if (user != null && password.equals(user.getPassword())) {
            //存放在request请求域中
            map.put("username", id);
            return "framewew";
        }
        return "error";
    }

    /**
     * 保存添加的数据
     *
     * @param user 用户
     * @return redirect:main
     */
    @RequestMapping(value = "/saveUser")
    public String savePerson(User user) {
        userService.addUser(user);
        return "redirect:main";
    }

    /**
     * 跳转到添加页面
     * personSavePage.jsp
     * @return savePage
     */
    @RequestMapping(value = "/addUser")
    public String saveUser() {
        return "personSavePage";
    }

    /**
     * 删除一条数据
     * @param id 用户id
     * @return redirect:main
     */
    @RequestMapping(value = "/deleteUserById")
    public String deleteUserById(@RequestParam(value = "id") String id) {
        System.out.println("删除单个");
        userService.deleteUserById(id);
        return "redirect:main";
    }

    /**
     * 跳转到更新页面，回显数据
     * personEditPage.jsp
     *
     * @param id 用户ID
     * @param model 使用的Model保存回显数据
     * @return editPage
     */
    @RequestMapping(value = "/doUpdate")
    public String doUpdate(@RequestParam(value = "id") String id, Model model) {
        model.addAttribute("user", userService.getUserById(id));
        return "personEditPage";
    }

    /**
     * 更新数据
     * @param user 用户
     * @return redirect:main
     */
    @RequestMapping(value = "/updateUser")
    public String updateUser(User user) {
        userService.updateUser(user);
        return "redirect:main";
    }
}
