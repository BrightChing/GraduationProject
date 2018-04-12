package cn.edu.zucc.brightqin.dao;


import javax.annotation.Resource;
import javax.persistence.criteria.CriteriaQuery;


import cn.edu.zucc.brightqin.entity.Person;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import java.util.List;


/**
 * @author brightqin
 */
@Repository
public class PersonDAO {

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
	public Person getPersonById(String id) {
		return (Person) this.getSession().createQuery("from Person where personId=?").setParameter(0, id).uniqueResult();
	}
	/**
	 * 添加
	 * @param person
	 */
	public void addPerson(Person person) {
		this.getSession().save(person);
	}
	/**
	 * 更新
	 * @param person
	 */
	public void updatePerson(Person person) {
		this.getSession().update(person);
	}
	/**
	 * 删除
	 * @param id
	 */
	public void deletePersonById(String id) {
		this.getSession().createQuery("delete from Person where personId=?").setParameter(0, id).executeUpdate();
	}
	/**
	 * 查询所有
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Person> getPersons() {
		CriteriaQuery<Person> personCriteriaQuery = this.getSession().getCriteriaBuilder().createQuery(Person.class);
		personCriteriaQuery.from(Person.class);
		return this.getSession().createQuery(personCriteriaQuery).getResultList();
	}
}
