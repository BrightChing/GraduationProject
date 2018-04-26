package cn.edu.zucc.brightqin.service;

import cn.edu.zucc.brightqin.dao.KeyResultDAO;
import cn.edu.zucc.brightqin.entity.KeyResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author brightqin
 */
@Transactional(rollbackFor = Exception.class)
@Service
public class KeyResultService {
    @Autowired
    KeyResultDAO keyResultDAO;

    public void addKeyeResult(KeyResult keyResult) {
        keyResultDAO.saveKeyResult(keyResult);
    }

    public void deleteKeyResult(KeyResult keyResult) {
        keyResultDAO.deleteKeyResult(keyResult);
    }

    public void updateKeyResult(KeyResult keyResult) {
        keyResultDAO.updateKeyResult(keyResult);
    }

    public KeyResult getKeyResultById(String id) {
        return keyResultDAO.getKeyResultById(id);
    }

    @SuppressWarnings("unchecked")
    public List<KeyResult> getKeyResults() {
        return keyResultDAO.getKeyResults();
    }
}