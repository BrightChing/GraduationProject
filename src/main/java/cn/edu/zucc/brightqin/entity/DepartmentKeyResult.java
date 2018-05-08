package cn.edu.zucc.brightqin.entity;

import javax.persistence.*;

/**
 * @author brightqin
 */
@Entity
@Table(name = "DepartmentKeyResult")
public class DepartmentKeyResult {
    private Integer departmentKeyResultId;
    private String departmentKeyResultName;
    private int selfScore;
    private int upstreamScore;
    private int totalScore;
    private float weight;
    private DepartmentObject departmentObject;


    public DepartmentKeyResult() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "departmentKeyResultId", nullable = false, unique = true, length = 16)
    public Integer getDepartmentKeyResultId() {
        return departmentKeyResultId;
    }

    public void setDepartmentKeyResultId(Integer departmentKeyResultId) {
        this.departmentKeyResultId = departmentKeyResultId;
    }

    @Column(name = "departmentKeyResultName", nullable = false, length = 16)
    public String getDepartmentKeyResultName() {
        return departmentKeyResultName;
    }

    public void setDepartmentKeyResultName(String departmentKeyResultName) {
        this.departmentKeyResultName = departmentKeyResultName;
    }

    @Column(name = "selfScore")
    public int getSelfScore() {
        return selfScore;
    }

    public void setSelfScore(int selfScore) {
        this.selfScore = selfScore;
    }

    @Column(name = "upstreamScore")
    public int getUpstreamScore() {
        return upstreamScore;
    }

    public void setUpstreamScore(int upstreamScore) {
        this.upstreamScore = upstreamScore;
    }

    @Column(name = "totalScore")
    public int getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(int totalScore) {
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
    @JoinColumn(name = "departmentObjectId")
    public DepartmentObject getDepartmentObject() {
        return departmentObject;
    }

    public void setDepartmentObject(DepartmentObject departmentObject) {
        this.departmentObject = departmentObject;
    }
}
