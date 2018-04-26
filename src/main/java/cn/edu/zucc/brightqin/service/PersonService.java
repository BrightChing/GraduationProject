package cn.edu.zucc.brightqin.service;

import cn.edu.zucc.brightqin.dao.PersonDAO;
import cn.edu.zucc.brightqin.entity.Person;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author brightqin
 */
@Transactional(rollbackFor=Exception.class)
@Service
public class PersonService {
	private final PersonDAO personDAO;

	@Autowired
	public PersonService(PersonDAO personDAO) {
		this.personDAO = personDAO;
	}


	/**
	 * 添加
	 * @param person person
	 */
	public void addPerson(Person person) {
		personDAO.addPerson(person);
	}
	/**
	 * 根据id查询
	 * @param id ID
	 * @return Person
	 */
	public Person getPersonById(String id){
		return personDAO.getPersonById(id);
	}
	/**
	 * 更新
	 * @param person person
	 */
	public void updatePerson(Person person) {
		personDAO.updatePerson(person);
	}
	/**
	 * 删除
	 * @param id ID
	 */
	public void deletePersonById(String  id) {
		personDAO.deletePersonById(id);
	}
	/**
	 * 查询所有
	 * @return Person List
	 */
	public List<Person> getPersons() {
		return personDAO.getPersons();
	}
}
