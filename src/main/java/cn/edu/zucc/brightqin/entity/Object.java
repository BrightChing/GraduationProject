package cn.edu.zucc.brightqin.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;

/**
 * @author brightqin
 */
@Entity
@Table(name = "object")
public class Object {
    private String objectId;
    private String objectName;

    public Object() {

    }

    @Id
    @Column(name = "objectId", nullable = false, unique = true, length = 16)
    @GenericGenerator(name = "generator", strategy = "uuid")
    @GeneratedValue(generator = "generator")
    public String getObjectId() {
        return objectId;
    }

    public void setObjectId(String objectId) {
        this.objectId = objectId;
    }

    @Column(name = "objectName", nullable = false, unique = true, length = 16)
    public String getObjectName() {
        return objectName;
    }

    public void setObjectName(String objectName) {
        this.objectName = objectName;
    }
}
