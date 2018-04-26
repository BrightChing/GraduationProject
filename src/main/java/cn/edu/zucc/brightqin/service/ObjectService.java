package cn.edu.zucc.brightqin.service;

import cn.edu.zucc.brightqin.dao.ObjectDAO;
import cn.edu.zucc.brightqin.entity.Object;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author brightqin
 */
@Transactional(rollbackFor = Exception.class)
@Service
public class ObjectService {
    @Autowired
    private ObjectDAO objectDAO;

    public void addObject(Object object) {
        objectDAO.saveObject(object);
    }

    public void deleteObject(String id) {
        objectDAO.deleteObject(id);
    }

    public void updateObject(Object object) {
        objectDAO.updateObject(object);
    }

    public Object getObjectById(String id) {
        return objectDAO.getObjectById(id);
    }

    public List<Object> getObjects() {
       return objectDAO.getObjects();
    }
}