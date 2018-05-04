package cn.edu.zucc.brightqin.dao;


import cn.edu.zucc.brightqin.entity.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.CriteriaQuery;
import java.util.List;


/**
 * @author brightqin
 */
@Repository
public class UserDAO {

    private final SessionFactory sessionFactory;

    @Autowired
    public UserDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }
    /**
     * 根据id查询
     * @param id ID
     * @return user
     */
    public User getUserById(String id) {
        return (User) this.getSession().createQuery("from User where id= ?").setParameter(0, id).uniqueResult();
    }
    /**
     * 添加
     * @param user user
     */
    public void addUser(User user) {
        this.getSession().save(user);
    }
    /**
     * 更新
     * @param user user
     */
    public void updateUser(User user) {
        this.getSession().update(user);
    }
    /**
     * 删除
     * @param id ID
     */
    public void deleteUserById(String id) {
        this.getSession().createQuery("DELETE FROM User WHERE id=?").setParameter(0, id).executeUpdate();
    }
    /**
     * 查询所有
     * @return List<User>
     */
    @SuppressWarnings("unchecked")
    public List<User> getUsers() {
        CriteriaQuery<User> userCriteriaQuery = this.getSession().getCriteriaBuilder().createQuery(User.class);
        userCriteriaQuery.from(User.class);
        return this.getSession().createQuery(userCriteriaQuery).getResultList();
    }

}
