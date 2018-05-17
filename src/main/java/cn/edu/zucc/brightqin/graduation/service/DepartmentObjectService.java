package cn.edu.zucc.brightqin.graduation.service;

import cn.edu.zucc.brightqin.graduation.dao.DepartmentObjectDAO;
import cn.edu.zucc.brightqin.graduation.entity.DepartmentObject;
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


    public void addDepartmentObject(DepartmentObject object) {
        objectDAO.saveDepartmentObject(object);
    }

    public void deleteDepartmentObjectById(Integer id) {
        objectDAO.deleteDepartmentObjectById(id);
    }

    public void updateDepartmentObject(DepartmentObject object) {
        objectDAO.updateDepartmentObject(object);
    }

    public DepartmentObject getDepartmentObjectById(Integer id) {
        return objectDAO.getDepartmentObjectById(id);
    }

    @SuppressWarnings("unchecked")
    public List<DepartmentObject> getDepartmentObjects() {
        return objectDAO.getDepartmentObjects();
    }

    @SuppressWarnings("unchecked")
    public List<DepartmentObject> getDepartmenttObjectsByDepartmentId(Integer id) {
        return objectDAO.getDepartmentObjectByDepartmentId(id);
    }

    public List<DepartmentObject> getDepartmenttObjectsByDepartmentId(Integer id, int month) {
        return objectDAO.getDepartmentObjectByDepartmentId(id, month);
    }
}
