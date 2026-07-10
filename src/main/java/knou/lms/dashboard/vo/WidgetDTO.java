package knou.lms.dashboard.vo;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL) // 데이터가 null인 필드는 JSON 결과에서 제외함
public class WidgetDTO {

    private String widgetId;
    private String widgetNm;
    private String pvsnyn;
    private Integer posX;
    private Integer posY;
    private Integer posW;
    private Integer posH;
    private String userId;
    private String visibleYn;

    // 학생용 위젯에만 있는 필드들
    private Integer minW;
    private Integer minH;
    private Integer maxW;
    private Integer maxH;

    public WidgetDTO() {
    }

    public WidgetDTO(String widgetId, String widgetNm, String pvsnyn,
                     Integer posX, Integer posY,
                     Integer posW, Integer posH,
                     Integer minW, Integer minH,
                     Integer maxW, Integer maxH) {
        this.widgetId = widgetId;
        this.widgetNm = widgetNm;
        this.pvsnyn = pvsnyn;
        this.posX = posX;
        this.posY = posY;
        this.posW = posW;
        this.posH = posH;
        this.minW = minW;
        this.minH = minH;
        this.maxW = maxW;
        this.maxH = maxH;
    }

    public String getWidgetId() {
        return widgetId;
    }

    public void setWidgetId(String widgetId) {
        this.widgetId = widgetId;
    }

    public String getWidgetNm() {
        return widgetNm;
    }

    public void setWidgetNm(String widgetNm) {
        this.widgetNm = widgetNm;
    }

    public String getPvsnyn() {
        return pvsnyn;
    }

    public void setPvsnyn(String pvsnyn) {
        this.pvsnyn = pvsnyn;
    }

    public Integer getPosX() {
        return posX;
    }

    public void setPosX(Integer posX) {
        this.posX = posX;
    }

    public Integer getPosY() {
        return posY;
    }

    public void setPosY(Integer posY) {
        this.posY = posY;
    }

    public Integer getPosW() {
        return posW;
    }

    public void setPosW(Integer posW) {
        this.posW = posW;
    }

    public Integer getPosH() {
        return posH;
    }

    public void setPosH(Integer posH) {
        this.posH = posH;
    }

    public Integer getMinW() {
        return minW;
    }

    public void setMinW(Integer minW) {
        this.minW = minW;
    }

    public Integer getMinH() {
        return minH;
    }

    public void setMinH(Integer minH) {
        this.minH = minH;
    }

    public Integer getMaxW() {
        return maxW;
    }

    public void setMaxW(Integer maxW) {
        this.maxW = maxW;
    }

    public Integer getMaxH() {
        return maxH;
    }

    public void setMaxH(Integer maxH) {
        this.maxH = maxH;
    }
}
