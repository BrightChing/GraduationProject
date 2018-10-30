package cn.edu.zucc.brightqin.graduation.entity;


import javax.persistence.*;

/**
 * @author brightqin
 */
@Entity
@Table(name = "PersonKeyResult")
public class PersonKeyResult {
    private Integer personKeyResultId;
    private String personKeyResultName;
    private float selfScore;
    private float upstreamScore;
    private float totalScore;
    private float weight;
    private PersonObject personObject;

    public PersonKeyResult() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "personKeyResultId")
    public Integer getPersonKeyResultId() {
        return personKeyResultId;
    }

    public void setPersonKeyResultId(Integer personKeyResultId) {
        this.personKeyResultId = personKeyResultId;
    }

    @Column(name = "personKeyResultName", nullable = false, length = 32)
    public String getPersonKeyResultName() {
        return personKeyResultName;
    }

    public void setPersonKeyResultName(String personKeyResultName) {
        this.personKeyResultName = personKeyResultName;
    }

    @Column(name = "selfScore", columnDefinition = "float default 0")
    public float getSelfScore() {
        return selfScore;
    }

    public void setSelfScore(float selfScore) {
        this.selfScore = selfScore;
    }

    @Column(name = "upstreamScore", columnDefinition = "float default 0")
    public float getUpstreamScore() {
        return upstreamScore;
    }

    public void setUpstreamScore(float upstreamScore) {
        this.upstreamScore = upstreamScore;
    }

    @Column(name = "totalScore", columnDefinition = "float default 0")
    public float getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(float totalScore) {
        this.totalScore = totalScore;
    }

    @Column(name = "weight", columnDefinition = "float default 0")
    public float getWeight() {
        return weight;
    }

    public void setWeight(float weight) {
        this.weight = weight;
    }

    @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @JoinColumn(name = "personObjectId")
    public PersonObject getPersonObject() {
        return personObject;
    }

    public void setPersonObject(PersonObject personObject) {
        this.personObject = personObject;
    }
}
