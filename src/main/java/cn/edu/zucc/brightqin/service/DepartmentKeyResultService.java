package cn.edu.zucc.brightqin.service;

import cn.edu.zucc.brightqin.dao.DepartmentKeyResultDAO;
import cn.edu.zucc.brightqin.entity.DepartmentKeyResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author brightqin
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class DepartmentKeyResultService {
    private final DepartmentKeyResultDAO keyResultDAO;

    @Autowired
    public DepartmentKeyResultService(DepartmentKeyResultDAO keyResultDAO) {
        this.keyResultDAO = keyResultDAO;
    }

    public void addKeyResult(DepartmentKeyResult keyResult) {
        keyResultDAO.saveKeyResult(keyResult);
    }

    public void deleteKeyResultById(Integer id) {
        keyResultDAO.deleteKeyResultById(id);
    }

    public void updateKeyResult(DepartmentKeyResult keyResult) {
        keyResultDAO.updateKeyResult(keyResult);
    }

    public DepartmentKeyResult getKeyResultById(Integer id) {
        return keyResultDAO.getKeyResultById(id);
    }

    public List<DepartmentKeyResult> getKeyResults() {
        return keyResultDAO.getKeyResults();
    }

    public List<DepartmentKeyResult> getDepartmentKeyResultsByDepartmentObjectId(Integer id) {
        return keyResultDAO.getDepartmentKeyResultsByDepartmentObjectId(id);
    }
}