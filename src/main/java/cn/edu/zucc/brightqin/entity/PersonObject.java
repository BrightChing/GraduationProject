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
    private float weight;
    private int month;
    private Person person;
    private boolean review;
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

    @Column(name = "personObjectName", nullable = false, length = 32)
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

    @Column(name = "weight", columnDefinition = "float default 0")
    public float getWeight() {
        return weight;
    }

    public void setWeight(float weight) {
        this.weight = weight;
    }

    @Column(name = "month", columnDefinition = "int default 0")
    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @JoinColumn(name = "personId")
    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    @Column(name = "review", columnDefinition = "bool default false")
    public boolean isReview() {
        return review;
    }

    public void setReview(boolean review) {
        this.review = review;
    }
}
