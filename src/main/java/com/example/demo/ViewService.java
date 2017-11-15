package com.example.demo;

import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by toktar.
 */
@Service
public class ViewService {


    public String generateAnswerForUser(List<Plane> resultPlanes, List<Plane> allPlanes) {
        StringBuilder out = new StringBuilder();
        out.append(getPageBegin())
                .append(generatePlaneTeble(resultPlanes, "Вам подходят рейсы", false))
                .append(generatePlaneTeble(allPlanes, "Все рейсы", true))
                .append(getPageEnd());

        return out.toString();
    }

    private String generatePlaneTeble(List<Plane> allPlanes, String title, boolean changeble) {
        StringBuilder out = new StringBuilder();
        out.append("<div style=\"display: inline-block; margin: 50px;\"><h2>"+title+":</h2>")
        .append("<table><tr><td><b>Вылет</b></td><td><b>Прилёт</b></td><td><b>Грузоподъёмность</b></td><td><b>Цена</b></td><tr>");
        for (Plane plane : allPlanes) {
            out.append("<tr><td>")
                    .append(plane.getStart())
                    .append("</td><td>")
                    .append(plane.getEnd())
                    .append("</td><td>")
                    .append(plane.getWeight())
                    .append("</td><td>")
                    .append(plane.getCost());
            if(changeble) {
                out.append("</td><td>")
                        .append("<form><input type=\"hidden\" name=\"operation\" value=\"DELETE\">\n" +
                                "    <input type=\"hidden\" name=\"id\" value=\""+plane.getFactId()+"\">\n" +
                                "<input id=\"saveForm\" class=\"button_text\" type=\"submit\" name=\"submit\" value=\"Удалить\">\n" +
                                "</form>");
            }

                    out.append("</td></tr>");
        }
        out.append("</table></div>");
        return out.toString();
    }

    public String getPageBegin() {
        StringBuffer out = new StringBuffer();
        out.append("<html>")
                .append("<meta http-equiv=\"Content-Type\" content=\"text/html\" >")
                .append("<head><title>Перевозка грузов</title>")
                .append("<style>li {\n" +
                        "    list-style-type: none;\n" +
                        "    padding: 5px;\n" +
                        "}"+
                        "td {\n" +
                        "    padding: 10px;\n" +
                        "    border: solid 1px;\n" +
                        "}</style></head>")
                .append("<body bgcolor=\"#E3CA95\" text=\"#000000\" link=\"#800000\" vlink=\"#666633\" alink=\"#1445A1\">")
                .append("<h1 style=\"text-align: center;padding: 20px;\">Перевозка грузов</h1>")
                .append("<div style=\"\n" +
                        "    margin: 50px;\n" +
                        "    padding: 20px;\n" +
                        "    background: #e8ddc3;\n" +
                        "    -webkit-box-shadow: 0px 0px 45px 6px rgba(0,0,0,0.75);\n" +
                        "    -moz-box-shadow: 0px 0px 45px 6px rgba(0,0,0,0.75);\n" +
                        "    box-shadow: 0px 0px 45px 6px rgba(0,0,0,0.75);\n" +
                        "\">")
                .append("<form style=\"display: inline-block;margin: 50px;\" class=\"appnitro\" method=\"get\" action=\"\">\n" +
                        "<h2>Найти подходящий рейс</h2>"+
                        "<ul>\n" +
                        "<li id=\"li_1\" class=\"\">\n" +
                        "<label class=\"description\" for=\"element_1\">Доставить из </label>\n" +
                        "<div>\n" +
                        "<input id=\"element_1\" name=\"start\" class=\"element text medium\" type=\"text\" maxlength=\"255\" value=\"\"> \n" +
                        "</div> \n" +
                        "</li><li id=\"li_2\" class=\"\">\n" +
                        "<label class=\"description\" for=\"element_2\">Доставить в </label>\n" +
                        "<div>\n" +
                        "<input id=\"element_2\" name=\"end\" class=\"element text medium\" type=\"text\" maxlength=\"255\" value=\"\"> \n" +
                        "</div> \n" +
                        "</li><li id=\"li_3\" class=\"\">\n" +
                        "<label class=\"description\" for=\"element_3\">Посылку весом (т) </label>\n" +
                        "<div>\n" +
                        "<input id=\"element_3\" name=\"weight\" class=\"element text medium\" type=\"text\" maxlength=\"255\" value=\"\"> \n" +
                        "</div> \n" +
                        "</li>\n" +
                        "<li class=\"buttons\">\n" +
                        "    <input type=\"hidden\" name=\"form_id\" value=\"58682\">\n" +
                        "<input id=\"saveForm\" class=\"button_text\" type=\"submit\" name=\"submit\" value=\"Найти рейсы\">\n" +
                        "</li>\n" +
                        "</ul>\n" +
                        "<br></form>")
        .append("<form style=\"margin-left: 130px; display: inline-block;\" class=\"appnitro\" method=\"get\" action=\"\">\n" +
                "<h2 style=\"padding-left: 49px;\"> Добавить рейс</h2>"+
                "<ul>\n" +
                "<li id=\"li_1\" class=\"\">\n" +
                "<label class=\"description\" for=\"element_1\">Аэропорт вылета</label>\n" +
                "<div>\n" +
                "<input id=\"element_1\" name=\"start\" class=\"element text medium\" type=\"text\" maxlength=\"255\" value=\"\"> \n" +
                "</div> \n" +
                "</li><li id=\"li_2\" class=\"\">\n" +
                "<label class=\"description\" for=\"element_2\">Аэропорт прилёта</label>\n" +
                "<div>\n" +
                "<input id=\"element_2\" name=\"end\" class=\"element text medium\" type=\"text\" maxlength=\"255\" value=\"\"> \n" +
                "</div> \n" +
                "</li><li id=\"li_3\" class=\"\">\n" +
                "<label class=\"description\" for=\"element_3\">Грузоподъёмность (т) </label>\n" +
                "<div>\n" +
                "<input id=\"element_3\" name=\"weight\" class=\"element text medium\" type=\"text\" maxlength=\"255\" value=\"\"> \n" +
                "</div> \n" +
                "</li><li id=\"li_3\" class=\"\">\n" +
                "<label class=\"description\" for=\"element_3\">Цена перевозки</label>\n" +
                "<div>\n" +
                "<input id=\"element_3\" name=\"cost\" class=\"element text medium\" type=\"text\" maxlength=\"255\" value=\"\"> \n" +
                "</div> \n" +
                "</li>\n" +
                "<li class=\"buttons\">\n" +
                "    <input type=\"hidden\" name=\"id\" value=\"\">\n" +
                "    <input type=\"hidden\" name=\"operation\" value=\"NEW\">\n" +
                "    <input type=\"hidden\" name=\"form_id\" value=\"58682\">\n" +
                "<input id=\"saveForm\" class=\"button_text\" type=\"submit\" name=\"submit\" value=\"Добавить\">\n" +
                "</li>\n" +
                "</ul>\n" +
                "</form><br>"
                );

        return out.toString();
    }

    public String getPageEnd() {
        StringBuffer out = new StringBuffer();
        out
        .append("</div>")
        .append("</body>")
                .append("</html>");
        return out.toString();
    }
}
