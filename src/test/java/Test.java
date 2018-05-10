import cn.edu.zucc.brightqin.utils.PasswordUtil;

import java.util.Scanner;
import java.util.regex.Pattern;

public class Test {
    public static void main(String[] args) {
        String pattern = "^[0-9a-zA-Z_]{6,32}$";
        while (true) {
            Scanner scanner = new Scanner(System.in);
            String content = scanner.nextLine();
            boolean isMatch = Pattern.matches(pattern, content);
            System.out.println(isMatch);
            System.out.println(PasswordUtil.MD5(content));
        }
    }
}
