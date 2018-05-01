package cn.edu.zucc.brightqin.entity;

import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Pattern;


/**
 * @author brightqin
 */
@Entity
@Table(name = "Person")
public class Person {
    private Integer id;
    /**
     * 用户ID
     */
    @NotEmpty(message = "{error.personId}")
    private String personId;
    /**
     * 用户名
     */
    @Length(min = 1, max = 16, message = "{error.name}")
    private String personName;
    /**
     * 密码
     */

    private String password;
    /**
     * 邮箱
     */
    @Email(message = "邮箱格式不正确")
    private String email;
    /**
     * 部门
     */

    @NotEmpty(message = "职位不能为空")
    private String position;
    /**
     * 手机号
     */
    @Pattern(regexp = "^(13[0-9]|14[579]|15[0-35-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$", message = "{error.phone}")
    private String phone;
    /**
     * 地址
     */
    @NotEmpty(message = "{error.address}")
    private String address;

    private Department department;

    public Person() {
    }

    @Id
    @Column(name = "id", nullable = false, unique = true, length = 16)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @Column(name = "personId", nullable = false, length = 20)
    public String getPersonId() {
        return personId;
    }

    public void setPersonId(String personId) {
        this.personId = personId;
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
}
