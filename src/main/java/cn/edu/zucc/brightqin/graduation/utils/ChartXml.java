package cn.edu.zucc.brightqin.graduation.utils;


/**
 * @author brightqin
 */
public class ChartXml {
    private float[] scors;
    private StringBuilder stringBuilder = new StringBuilder(128);

    public ChartXml(float[] scores) {
        this.scors = scores;
    }

    public String build() {
        stringBuilder.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        stringBuilder.append("<data>");
        for (int i = 1; i < scors.length; i++) {
            buildXML(scors[i], i);
        }
        stringBuilder.append("</data>");
        return stringBuilder.toString();
    }

    /**
     * 构建XML文档
     */
    private void buildXML(float score, int position) {
        stringBuilder.append("<item id=\"");
        stringBuilder.append(position);
        stringBuilder.append("\">");
        stringBuilder.append("<sales>");
        stringBuilder.append(score);
        stringBuilder.append("</sales>");
        stringBuilder.append("<month>");
        stringBuilder.append(position);
        stringBuilder.append("</month>");
        stringBuilder.append("</item>");
    }
}
