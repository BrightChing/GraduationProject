package cn.edu.zucc.brightqin.service;

import cn.edu.zucc.brightqin.dao.PersonObjectDAO;
import cn.edu.zucc.brightqin.entity.PersonObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author brightqin
 */
@Service
public class PersonObjectService {
    private final PersonObjectDAO objectDAO;

    @Autowired
    public PersonObjectService(PersonObjectDAO objectDAO) {
        this.objectDAO = objectDAO;
    }

    public void addObject(PersonObject object) {
        objectDAO.saveObject(object);
    }

    public void deleteObject(Integer id) {
        objectDAO.deleteObject(id);
    }

    public void updateObject(PersonObject object) {
        objectDAO.updateObject(object);
    }

    public PersonObject getObjectById(Integer id) {
        return objectDAO.getObjectById(id);
    }

    public List<PersonObject> getObjects() {
        return objectDAO.getObjects();
    }

    public List<PersonObject> getObjectsByPersonId(Integer id) {
        return objectDAO.getObjectsByPersonId(id);
    }

    public List<PersonObject> getObjectsByPersonIdAndMonth(Integer id, int month) {
        return objectDAO.getObjectsByPersonIdAndMonth(id, month);
    }
}
