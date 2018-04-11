package cn.edu.zucc.brightqin.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import javax.validation.constraints.Size;

/**
 * @author brightqin
 */
@Entity
@Table(name = "user")
public class User {

    private String id;
    private String password;

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

    @Column(name = "password", nullable = false, unique = true, length = 32)
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "Person [id=" + id + ", password=" + password + "]";
    }
}
