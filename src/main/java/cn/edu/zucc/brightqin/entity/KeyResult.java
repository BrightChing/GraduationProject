package cn.edu.zucc.brightqin.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;

/**
 * @author brightqin
 */
@Entity
@Table(name = "KeyResult")
public class KeyResult {
    private String keyResultId;
    private String keyResultName;

    public KeyResult() {
    }

    @Id
    @GenericGenerator(name = "generator", strategy = "uuid")
    @GeneratedValue(generator = "generator")
    @Column(name = "keyResultId", nullable = false, unique = true, length = 16)
    public String getKeyResultId() {
        return keyResultId;
    }

    public void setKeyResultId(String keyResultId) {
        this.keyResultId = keyResultId;
    }
    @Column(name = "keyResultName", nullable = false, length = 16)
    public String getKeyResultName() {
        return keyResultName;
    }

    public void setKeyResultName(String keyResultName) {
        this.keyResultName = keyResultName;
    }
}
