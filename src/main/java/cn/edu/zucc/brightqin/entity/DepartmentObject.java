package cn.edu.zucc.brightqin.entity;


import javax.persistence.*;
import java.util.Set;

/**
 * @author brightqin
 */
@Entity
@Table(name = "DepartmentObject")
public class DepartmentObject {
    private Integer objectId;
    private String objectName;
    private Set<DepartmentKeyResult> results;

    public DepartmentObject() {

    }

    @Id
    @Column(name = "objectId", nullable = false, unique = true, length = 16)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Integer getObjectId() {
        return objectId;
    }

    public void setObjectId(Integer objectId) {
        this.objectId = objectId;
    }

    @Column(name = "objectName", nullable = false, unique = true, length = 16)
    public String getObjectName() {
        return objectName;
    }

    public void setObjectName(String objectName) {
        this.objectName = objectName;
    }

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "objectId")
    public Set<DepartmentKeyResult> getResults() {
        return results;
    }

    public void setResults(Set<DepartmentKeyResult> results) {
        this.results = results;
    }
}
