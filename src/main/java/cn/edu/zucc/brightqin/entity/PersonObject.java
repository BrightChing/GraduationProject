package cn.edu.zucc.brightqin.entity;


import javax.persistence.*;
import java.util.Set;

/**
 * @author brightqin
 */
@Entity
@Table(name = "PersonObject")
public class PersonObject {
    private Integer personObjectId;
    private String personObjectName;
    private Set<PersonKeyResult> results;
    private Person person;

    public PersonObject() {
    }

    @Id
    @Column(name = "personObjectId")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Integer getPersonObjectId() {
        return personObjectId;
    }

    public void setPersonObjectId(Integer personObjectId) {
        this.personObjectId = personObjectId;
    }

    @Column(name = "personObjectName", nullable = false, unique = true, length = 32)
    public String getPersonObjectName() {
        return personObjectName;
    }

    public void setPersonObjectName(String personObjectName) {
        this.personObjectName = personObjectName;
    }

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "personObjectId")
    public Set<PersonKeyResult> getResults() {
        return results;
    }

    public void setResults(Set<PersonKeyResult> results) {
        this.results = results;
    }

    @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @JoinColumn(name = "personId")
    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }
}
