package cn.edu.zucc.brightqin.dao;


import cn.edu.zucc.brightqin.entity.Person;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.CriteriaQuery;
import java.util.ArrayList;
import java.util.List;


/**
 * @author brightqin
 */
@Repository
public class PersonDAO {

    @Autowired
    private SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    /**
     * 根据id查询
     *
     * @param id ID
     * @return Person
     */
    public Person getPersonById(Integer id) {
        return this.getSession().get(Person.class,id);
    }

    /**
     * 添加
     *
     * @param person person
     */
    public void addPerson(Person person) {
        this.getSession().save(person);
    }

    /**
     * 更新
     *
     * @param person person
     */
    public void updatePerson(Person person) {
        this.getSession().update(person);
    }

    /**
     * 删除
     *
     * @param id id
     */
    public void deletePersonById(Integer id) {
        this.getSession().createQuery("delete from Person where id= ?").setParameter(0, id).executeUpdate();
    }

    /**
     * 查询所有
     *
     * @return person List
     */
    @SuppressWarnings("unchecked")
    public List<Person> getPersons() {
        CriteriaQuery<Person> personCriteriaQuery = this.getSession().getCriteriaBuilder().createQuery(Person.class);
        personCriteriaQuery.from(Person.class);
        return this.getSession().createQuery(personCriteriaQuery).getResultList();
    }

    public List<Person> getPersonByDepartmentId(Integer id) {
        List list = this.getSession().createQuery("from Person where departmentId = ?").setParameter(0, id).getResultList();
        List<Person> people = new ArrayList<>();
        for (Object o : list) {
            people.add((Person) o);
        }
        return people;
    }
}
