package cn.edu.zucc.brightqin.graduation.entity;

import javax.persistence.*;
import java.util.Set;

/**
 * @author brightqin
 */
@Entity
@Table(name = "department")
public class Department {
    private Integer departmentId;
    private String departmentName;
    private Integer managerId;
    private Set<Person> persons;
    private Department department;
    private Set<Department> childDepartments;
    private Set<DepartmentObject> departmentObjects;

    public Department() {
    }

    @Id
    @Column(name = "departmentId", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Integer getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Integer departmentId) {
        this.departmentId = departmentId;
    }

    @Column(name = "departmentName", nullable = false, length = 16)
    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    @OneToMany(cascade = {CascadeType.ALL}, fetch = FetchType.LAZY)
    @JoinColumn(name = "departmentId")
    public Set<Person> getPersons() {
        return persons;
    }

    public void setPersons(Set<Person> persons) {
        this.persons = persons;
    }

    @ManyToOne(cascade = {CascadeType.ALL}, fetch = FetchType.EAGER)
    @JoinColumn(name = "parentId")
    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    @OneToMany(cascade = {CascadeType.ALL}, fetch = FetchType.EAGER)
    @JoinColumn(name = "parentId")
    public Set<Department> getChildDepartments() {
        return childDepartments;
    }

    public void setChildDepartments(Set<Department> childDepartments) {
        this.childDepartments = childDepartments;
    }

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "departmentId")
    public Set<DepartmentObject> getDepartmentObjects() {
        return departmentObjects;
    }

    public void setDepartmentObjects(Set<DepartmentObject> departmentObjects) {
        this.departmentObjects = departmentObjects;
    }

    @Column(name = "managerId", columnDefinition = "int default null ")
    public Integer getManagerId() {
        return managerId;
    }

    public void setManagerId(Integer managerId) {
        this.managerId = managerId;
    }
}
