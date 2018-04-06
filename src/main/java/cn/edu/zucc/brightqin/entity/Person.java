package cn.edu.zucc.brightqin.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

/**
 * 个人信息实体类
 * 注解方式配置对应数据表
 *
 * @author brightqin
 *
 */
@Entity
@Table(name = "person")
public class Person {

    private String id;
    private String name;
    private String idCard;
    private String phone;
    private String address;

    public Person(String name, String idCard, String phone, String address) {
        super();
        this.name = name;
        this.idCard = idCard;
        this.phone = phone;
        this.address = address;
    }

    @Id
    @Column(name = "id", nullable = false, unique = true, length = 32)
    @GenericGenerator(name = "generator", strategy = "uuid")
    @GeneratedValue(generator = "generator")
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @Column(name = "name", nullable = false, length = 32)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name = "idCard", nullable = false, length = 32)
    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    @Column(name = "phone", nullable = false, length = 32)
    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    @Column(name = "address", nullable = false, length = 32)
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Override
    public String toString() {
        return "Person [id=" + id + ", name=" + name + ", idCard=" + idCard + ", phone=" + phone + ", address="
                + address + "]";
    }

}
