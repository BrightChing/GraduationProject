package cn.edu.zucc.brightqin.entity;


import javax.persistence.*;

/**
 * @author brightqin
 */
@Entity
@Table(name = "PersonKeyResult")
public class PersonKeyResult {
    private Integer keyResultId;
    private String keyResultName;
    private float selfScore;
    private float upstreamScore;
    private float totalScore;
    private float weight;
    private PersonObject personObject;

    public PersonKeyResult() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "keyResultId")
    public Integer getKeyResultId() {
        return keyResultId;
    }

    public void setKeyResultId(Integer keyResultId) {
        this.keyResultId = keyResultId;
    }

    @Column(name = "keyResultName", nullable = false, length = 32)
    public String getKeyResultName() {
        return keyResultName;
    }

    public void setKeyResultName(String keyResultName) {
        this.keyResultName = keyResultName;
    }

    @Column(name = "selfScore")
    public float getSelfScore() {
        return selfScore;
    }

    public void setSelfScore(float selfScore) {
        this.selfScore = selfScore;
    }

    @Column(name = "upstreamScore")
    public float getUpstreamScore() {
        return upstreamScore;
    }

    public void setUpstreamScore(float upstreamScore) {
        this.upstreamScore = upstreamScore;
    }

    @Column(name = "totalScore")
    public float getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(float totalScore) {
        this.totalScore = totalScore;
    }

    @Column(name = "weight")
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
