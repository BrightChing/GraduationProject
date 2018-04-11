package cn.edu.zucc.brightqin.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

import org.hibernate.annotations.GenericGenerator;
import org.hibernate.validator.constraints.Length;


/**
 * @author brightqin
 */
@Entity
@Table(name = "person")
public class Person {

    private String id;
    @Length( min = 1,max =16, message = "{error.name}")
    private String name;
    @Pattern(regexp = "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X|x)$", message = "{error.idCard}")
    private String idCard;
    @Pattern(regexp = "^(13[0-9]|14[579]|15[0-35-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$",message ="{error.phone}" )
    private String phone;
    @NotNull(message = "{error.address}")
    private String address;

    public Person()
    {
        super();
    }
    public Person(String name, String idCard, String phone, String address) {
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
