package knou.lms.log.lesson.vo;

import knou.lms.common.vo.DefaultVO;

public class LogLessonActnHstyVO extends DefaultVO {
	private static final long serialVersionUID = 8241041923047040442L;

    private String  actnHstySn;     // 활동 이력 고유번호
    private String  actnHstyCd;     // 활동 이력 코드(TB_ORG_CODE 테이블의 CODE_CD)
    private String  actnHstyCts;    // 활동 이력 내용
    private String  deviceTypeCd;   // 접속 환경 코드
    
    public String getActnHstySn() {
        return actnHstySn;
    }
    public void setActnHstySn(String actnHstySn) {
        this.actnHstySn = actnHstySn;
    }
    public String getActnHstyCd() {
        return actnHstyCd;
    }
    public void setActnHstyCd(String actnHstyCd) {
        this.actnHstyCd = actnHstyCd;
    }
    public String getActnHstyCts() {
        return actnHstyCts;
    }
    public void setActnHstyCts(String actnHstyCts) {
        this.actnHstyCts = actnHstyCts;
    }
    public String getDeviceTypeCd() {
        return deviceTypeCd;
    }
    public void setDeviceTypeCd(String deviceTypeCd) {
        this.deviceTypeCd = deviceTypeCd;
    }

}
