package cn.edu.zucc.brightqin.dao;


import javax.annotation.Resource;
import javax.persistence.criteria.CriteriaQuery;


import cn.edu.zucc.brightqin.entity.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public class UserDAO {

    @Resource
    private SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }
    /**
     * 根据id查询
     * @param id
     * @return
     */
    public User getUserById(String id) {
        return (User) this.getSession().createQuery("from User where id=?").setParameter(0, id).uniqueResult();
    }
    /**
     * 添加
     * @param User
     */
    public void addUser(User User) {
        this.getSession().save(User);
    }
    /**
     * 更新
     * @param User
     */
    public void updateUser(User User) {
        this.getSession().update(User);
    }
    /**
     * 删除
     * @param id
     */
    public void deleteUserById(String id) {
        this.getSession().createQuery("delete User where id=?").setParameter(0, id).executeUpdate();
    }
    /**
     * 查询所有
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<User> getUsers() {
        CriteriaQuery<User> UserCriteriaQuery = this.getSession().getCriteriaBuilder().createQuery(User.class);
        UserCriteriaQuery.from(User.class);
        return this.getSession().createQuery(UserCriteriaQuery).getResultList();
    }

}
