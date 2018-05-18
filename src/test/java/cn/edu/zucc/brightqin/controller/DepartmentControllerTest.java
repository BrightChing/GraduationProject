package cn.edu.zucc.brightqin.controller;

import cn.edu.zucc.brightqin.graduation.entity.Department;
import cn.edu.zucc.brightqin.graduation.entity.DepartmentKeyResult;
import cn.edu.zucc.brightqin.graduation.entity.DepartmentObject;
import cn.edu.zucc.brightqin.graduation.service.DepartmentKeyResultService;
import cn.edu.zucc.brightqin.graduation.service.DepartmentObjectService;
import cn.edu.zucc.brightqin.graduation.service.DepartmentService;
import cn.edu.zucc.brightqin.graduation.utils.ChartXml;
import cn.edu.zucc.brightqin.graduation.utils.TreeBuilder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.util.List;


@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class DepartmentControllerTest {

    @Autowired
    private DepartmentService departmentService;
    @Autowired
    private DepartmentObjectService departmentObjectService;

    @Autowired
    private DepartmentKeyResultService departmentKeyResultService;

    @Test
    public void main() {
        Department department = departmentService.getRootDepartment();
        if (department != null) {
            department = departmentService.getDepartmentById(department.getDepartmentId());
            TreeBuilder builder = new TreeBuilder(department);
            System.out.println();
            System.out.println();
            System.out.println(builder.build());
            System.out.println();
            System.out.println();
        } else {
            System.out.println("department is null");
        }
    }

    @Test
    public void addDepartment() {
        Department department = new Department();
        department.setDepartmentName("hello");
        departmentService.addDepartment(department);
        Department parent = departmentService.getDepartmentById(Integer.valueOf(null));
        System.out.println(parent.getDepartmentName());
    }


    public float score(Integer id, int month) {
        Integer did = departmentService.getDepartmentById(id).getDepartmentId();
        List<DepartmentObject> departmentObjects = departmentObjectService.getDepartmenttObjectsByDepartmentId(did, month);
        float objectScore = 0;
        for (DepartmentObject object : departmentObjects) {
            System.out.println(object.getDepartmentObjectName());
            List<DepartmentKeyResult> departmentKeyResults = departmentKeyResultService.getDepartmentKeyResultsByDepartmentObjectId(object.getDepartmentObjectId());
            float resultScore = 0;
            for (DepartmentKeyResult result : departmentKeyResults) {
                float i = (result.getSelfScore() + result.getUpstreamScore()) * result.getWeight() / 200;
                resultScore += i;
                System.out.println("(" + result.getSelfScore() + "+" + result.getUpstreamScore() + ")*" + result.getWeight() + "/" + 200 + "=" + i);
            }
            objectScore += resultScore * object.getWeight() / 100;
        }
        System.out.println(objectScore);
        return objectScore;
    }

    @Test
    public void score() {
        Integer id = 2;
        float[] month = new float[13];
        for (int i = 1; i < 13; i++) {
            month[i] = score(id, i);
        }
        ChartXml chartXml = new ChartXml(month);
        System.out.println(chartXml.build());
    }
}