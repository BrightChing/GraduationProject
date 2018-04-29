package cn.edu.zucc.brightqin.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;

/**
 * @author brightqin
 */
@Entity
@Table(name = "DepartmentKeyResult")
public class DepartmentKeyResult {
    private Integer keyResultId;
    private String keyResultName;

    public DepartmentKeyResult() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "keyResultId", nullable = false, unique = true, length = 16)
    public Integer getKeyResultId() {
        return keyResultId;
    }

    public void setKeyResultId(Integer keyResultId) {
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
