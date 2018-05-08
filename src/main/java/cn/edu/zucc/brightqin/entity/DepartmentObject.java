package cn.edu.zucc.brightqin.entity;


import javax.persistence.*;
import java.util.Set;

/**
 * @author brightqin
 */
@Entity
@Table(name = "DepartmentObject")
public class DepartmentObject {
    private Integer departmentObjectId;
    private String departmentObjectName;
    private float weight;
    private Set<DepartmentKeyResult> departmentKeyResults;
    private Department department;

    public DepartmentObject() {

    }

    @Id
    @Column(name = "departmentObjectId", nullable = false, unique = true, length = 16)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Integer getDepartmentObjectId() {
        return departmentObjectId;
    }

    public void setDepartmentObjectId(Integer departmentObjectId) {
        this.departmentObjectId = departmentObjectId;
    }

    @Column(name = "departmentObjectName", nullable = false, unique = true, length = 16)
    public String getDepartmentObjectName() {
        return departmentObjectName;
    }

    public void setDepartmentObjectName(String departmentObjectName) {
        this.departmentObjectName = departmentObjectName;
    }

    @Column(name = "weight")
    public float getWeight() {
        return weight;
    }

    public void setWeight(float weight) {
        this.weight = weight;
    }

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "departmentObjectId")
    public Set<DepartmentKeyResult> getDepartmentKeyResults() {
        return departmentKeyResults;
    }

    public void setDepartmentKeyResults(Set<DepartmentKeyResult> departmentKeyResults) {
        this.departmentKeyResults = departmentKeyResults;
    }

    @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @JoinColumn(name = "departmentId")
    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }
}
