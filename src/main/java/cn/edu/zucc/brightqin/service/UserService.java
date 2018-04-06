package cn.edu.zucc.brightqin.service;

import cn.edu.zucc.brightqin.dao.UserDAO;
import cn.edu.zucc.brightqin.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author brightqin
 */
@Transactional(rollbackFor=Exception.class)
@Service
public class UserService {

	@Autowired
	public final UserDAO userDAO;

	public UserService(UserDAO userDAO) {
		this.userDAO = userDAO;
	}


	/**
	 * 添加
	 * @param user
	 */
	public void addUser(User user) {
		userDAO.addUser(user);
	}
	/**
	 * 根据id查询
	 * @param id
	 * @return
	 */
	public User getUserById(String id){
		return userDAO.getUserById(id);
	}
	/**
	 * 更新
	 * @param user
	 */
	public void updateUser(User user) {
		userDAO.updateUser(user);
	}
	/**
	 * 删除
	 * @param id
	 */
	public void deleteUserById(String  id) {
		userDAO.deleteUserById(id);
	}
	/**
	 * 查询所有
	 * @return
	 */
	public List<User> getUsers() {
		return userDAO.getUsers();
	}
}
