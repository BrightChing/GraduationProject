package cn.edu.zucc.brightqin.entity;


import javax.persistence.*;
import java.util.Set;


/**
 * @author brightqin
 */
@Entity
@Table(name = "Person")
public class Person {
    /**
     * 用户ID
     */
    private Integer personId;

    private String loginId;
    /**
     * 用户名
     */
    private String personName;
    /**
     * 密码
     */
    private String password;
    /**
     * 邮箱
     */
    private String email;
    /**
     * 部门
     */
    private String position;
    /**
     * 手机号
     */
    private String phone;
    /**
     * 地址
     */
    private String address;

    private Department department;

    private Set<PersonObject> personObjects;

    public Person() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "personId", nullable = false)
    public Integer getPersonId() {
        return personId;
    }

    public void setPersonId(Integer personId) {
        this.personId = personId;
    }

    @Column(name = "loginId", nullable = false, length = 32)
    public String getLoginId() {
        return loginId;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    @Column(name = "personName", nullable = false, length = 16)
    public String getPersonName() {
        return personName;
    }

    public void setPersonName(String personName) {
        this.personName = personName;
    }

    @Column(name = "password", nullable = false, length = 32)
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Column(name = "email", nullable = false, length = 32)
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Column(name = "position", nullable = false, length = 16)
    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    @Column(name = "phone", nullable = false, length = 16)
    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    @Column(name = "address", nullable = false, length = 48)
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @ManyToOne(cascade = {CascadeType.ALL}, fetch = FetchType.EAGER)
    @JoinColumn(name = "departmentId")
    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "personId")
    public Set<PersonObject> getPersonObjects() {
        return personObjects;
    }

    public void setPersonObjects(Set<PersonObject> personObjects) {
        this.personObjects = personObjects;
    }

}
