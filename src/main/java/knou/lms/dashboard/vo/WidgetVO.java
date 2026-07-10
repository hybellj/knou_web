package knou.lms.dashboard.vo;

import knou.lms.common.vo.DefaultVO;

import java.util.List;

public class WidgetVO  extends DefaultVO {

    // TB_LMS_WIDGET
    private String widgetId;        // 위젯아이디
    private String widgetUserGbncd; // 위젯사용자구분코드
    private String widgetnm;        // 위젯명
    private String widgetExpln;     // 위젯설명
    private String widgetVrsn;      // 위젯버전
    private String pvsnyn;          // 제공여부
    private String widgetStngCts;   // 위젯설정내용
    private List<WidgetDTO> widgetStngList; // widgetStngCts의 json형태 문자열 -> dto로 치환

    // TB_LMS_WIDGET_USE
    private String widgetUseId;         // 위젯사용 아이디
    private String widgetUserStngCts;   // 위젯사용자 설정내용

    // 위젯설정내용 json 데이터전송용
    private String profWidgetListJson;
    private String stdWidgetListJson;

    

    public String getWidgetId() {
        return widgetId;
    }

    public void setWidgetId(String widgetId) {
        this.widgetId = widgetId;
    }

    public String getWidgetUserGbncd() {
        return widgetUserGbncd;
    }

    public void setWidgetUserGbncd(String widgetUserGbncd) {
        this.widgetUserGbncd = widgetUserGbncd;
    }

    public String getWidgetnm() {
        return widgetnm;
    }

    public void setWidgetnm(String widgetnm) {
        this.widgetnm = widgetnm;
    }

    public String getWidgetExpln() {
        return widgetExpln;
    }

    public void setWidgetExpln(String widgetExpln) {
        this.widgetExpln = widgetExpln;
    }

    public String getWidgetVrsn() {
        return widgetVrsn;
    }

    public void setWidgetVrsn(String widgetVrsn) {
        this.widgetVrsn = widgetVrsn;
    }

    public String getPvsnyn() {
        return pvsnyn;
    }

    public void setPvsnyn(String pvsnyn) {
        this.pvsnyn = pvsnyn;
    }

    public String getWidgetStngCts() {
        return widgetStngCts;
    }

    public void setWidgetStngCts(String widgetStngCts) {
        this.widgetStngCts = widgetStngCts;
    }

    public List<WidgetDTO> getWidgetStngList() {
        return widgetStngList;
    }

    public void setWidgetStngList(List<WidgetDTO> widgetStngList) {
        this.widgetStngList = widgetStngList;
    }

    public String getProfWidgetListJson() {
        return profWidgetListJson;
    }

    public void setProfWidgetListJson(String profWidgetListJson) {
        this.profWidgetListJson = profWidgetListJson;
    }

    public String getStdWidgetListJson() {
        return stdWidgetListJson;
    }

    public void setStdWidgetListJson(String stdWidgetListJson) {
        this.stdWidgetListJson = stdWidgetListJson;
    }

    public String getWidgetUseId() {
        return widgetUseId;
    }

    public void setWidgetUseId(String widgetUseId) {
        this.widgetUseId = widgetUseId;
    }

    public String getWidgetUserStngCts() {
        return widgetUserStngCts;
    }

    public void setWidgetUserStngCts(String widgetUserStngCts) {
        this.widgetUserStngCts = widgetUserStngCts;
    }
}
