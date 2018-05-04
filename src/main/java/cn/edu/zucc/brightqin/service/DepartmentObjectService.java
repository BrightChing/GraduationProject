package cn.edu.zucc.brightqin.service;

import cn.edu.zucc.brightqin.dao.DepartmentObjectDAO;
import cn.edu.zucc.brightqin.entity.DepartmentObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author brightqin
 */

@Service
@Transactional(rollbackFor = Exception.class)
public class DepartmentObjectService {
    private final DepartmentObjectDAO objectDAO;

    @Autowired
    public DepartmentObjectService(DepartmentObjectDAO objectDAO) {
        this.objectDAO = objectDAO;
    }


    public void addObject(DepartmentObject object) {
        objectDAO.saveObject(object);
    }

    public void deleteObject(Integer id) {
        objectDAO.deleteObject(id);
    }

    public void updateObject(DepartmentObject object) {
        objectDAO.updateObject(object);
    }

    public DepartmentObject getObjectById(Integer id) {
        return objectDAO.getObjectById(id);
    }

    @SuppressWarnings("unchecked")
    public List<DepartmentObject> getObjects() {
        return objectDAO.getObjects();
    }
}
