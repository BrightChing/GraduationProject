package cn.edu.zucc.brightqin.graduation.utils;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * @author brightqin
 */
public class WightUtil {
    static final float sum = 100;

    public static void print(float weightSum, HttpServletResponse response, String str) {
        try (PrintWriter pw = response.getWriter()) {
            if (weightSum > sum) {
                pw.print(str + "的权重和为" + weightSum + "大于了100%，请您修改权重，或删除" + str);
            } else if (weightSum < sum) {
                pw.print(str + "权重和为" + weightSum + " 小于100%,请您修改权重，或添加" + str);
            } else {
                pw.print("");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
