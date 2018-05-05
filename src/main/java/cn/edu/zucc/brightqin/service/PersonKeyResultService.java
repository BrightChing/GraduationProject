package cn.edu.zucc.brightqin.service;


import cn.edu.zucc.brightqin.dao.PersonKeyResultDAO;
import cn.edu.zucc.brightqin.entity.PersonKeyResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author brightqin
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class PersonKeyResultService {
    private final PersonKeyResultDAO keyResultDAO;

    @Autowired
    public PersonKeyResultService(PersonKeyResultDAO keyResultDAO) {
        this.keyResultDAO = keyResultDAO;
    }

    public void addKeyResult(PersonKeyResult keyResult) {
        keyResultDAO.saveKeyResult(keyResult);
    }

    public void deleteKeyResultById(Integer id) {
        keyResultDAO.deleteKeyResultById(id);
    }

    public void updateKeyResult(PersonKeyResult keyResult) {
        keyResultDAO.updateKeyResult(keyResult);
    }

    public PersonKeyResult getKeyResultById(Integer id) {
        return keyResultDAO.getKeyResultById(id);
    }

    public List<PersonKeyResult> getKeyResults() {
        return keyResultDAO.getKeyResults();
    }

    public List<PersonKeyResult> getKeyResultsByObjectId(Integer id) {
        return keyResultDAO.getKeyResultsByObjectId(id);
    }
}
