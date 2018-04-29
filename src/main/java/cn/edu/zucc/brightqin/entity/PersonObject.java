package cn.edu.zucc.brightqin.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;

/**
 * @author brightqin
 */
@Entity
@Table(name = "PersonObject")
public class PersonObject {
    private Integer personObjectId;
    private String personObjectName;

    public PersonObject() {
    }

    @Id
    @Column(name = "personObjectId", nullable = false, unique = true, length = 16)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Integer getPersonObjectId() {
        return personObjectId;
    }

    public void setPersonObjectId(Integer personObjectId) {
        this.personObjectId = personObjectId;
    }
    @Column(name = "personObjectName", nullable = false, unique = true, length = 16)
    public String getPersonObjectName() {
        return personObjectName;
    }

    public void setPersonObjectName(String personObjectName) {
        this.personObjectName = personObjectName;
    }
}
