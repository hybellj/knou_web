package knou.lms.schedule.vo;

import java.io.Serializable;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import org.apache.ibatis.type.Alias;

/**
 * 수업일정 관리를 위한 Value Object (VO)
 */
@Alias("classScheduleVO")
public class ClassScheduleVO implements Serializable {

    private static final long serialVersionUID = 1L;
    
    // 검증 그룹을 위한 마커 인터페이스 정의
    public interface OnCreate {} // 등록용 그룹
    public interface OnUpdate {} // 수정용 그룹
    
    // 💡 수정할 때만(OnUpdate) 필수값으로 검증합니다.
    @NotBlank(message = "수정 시 일정 ID는 필수입니다.", groups = OnUpdate.class)
    private String clasSchdlId;

    // SMSTR_CHRT_ID (학기차수 ID) - 필수
    @NotBlank(message = "학기차수 ID는 필수 입력 값입니다.", groups = {OnCreate.class})
    private String smstrChrtId;   
    
    // SBJCT_ID (과목 ID) - 필수
    @NotBlank(message = "과목 ID는 필수 입력 값입니다.", groups = {OnCreate.class})
    private String sbjctId;       
    
    // CLAS_SCHDL_TTL (수업일정 제목) - 필수, 최대 100자 자릿수 제한(예시)
    @NotBlank(message = "수업일정 제목은 필수 입력 값입니다.")
    @Size(max = 100, message = "제목은 최대 100자까지 입력 가능합니다.", groups = {OnCreate.class, OnUpdate.class})
    private String clasSchdlTtl;  
    
    // CLAS_SCHDL_SDTTM (수업일정 시작일시) - 필수, YYYYMMDDHHMM 12자리 규격 가정
    @NotBlank(message = "시작일시는 필수 입력 값입니다.")
    @Size(min = 8, max = 14, message = "올바른 시작일시 형식이 아닙니다.", groups = {OnCreate.class, OnUpdate.class})
    private String clasSchdlSdttm;
    
    // CLAS_SCHDL_EDTTM (수업일정 종료일시) - 필수
    @NotBlank(message = "종료일시는 필수 입력 값입니다.")
    @Size(min = 8, max = 14, message = "올바른 종료일시 형식이 아닙니다.", groups = {OnCreate.class, OnUpdate.class})
    private String clasSchdlEdttm;
    
    // 빈 값은 허용하되, 입력 시 등록/수정 모두 최대 4000자 제한
    @Size(max = 4000, message = "상세 설명은 최대 2000자까지 입력 가능합니다.", groups = {OnCreate.class, OnUpdate.class})
    private String clasSchdlExpln;
    
    private String 	rgtrId;        // RGTR_ID (등록자 ID)
    private	String	userId;
    private String 	regDttm;       // REG_DTTM (등록 일시)
    private String 	mdfrId;        // MDFR_ID (수정자 ID)
    private String 	mdfrDttm;      // MDFR_DTTM (수정 일시)

    // 기본 생성자
    public ClassScheduleVO() {
    }

    public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	// Getter & Setter 메서드
    public String getClasSchdlId() {
        return clasSchdlId;
    }

    public void setClasSchdlId(String clasSchdlId) {
        this.clasSchdlId = clasSchdlId;
    }

    public String getSmstrChrtId() {
        return smstrChrtId;
    }

    public void setSmstrChrtId(String smstrChrtId) {
        this.smstrChrtId = smstrChrtId;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getClasSchdlTtl() {
        return clasSchdlTtl;
    }

    public void setClasSchdlTtl(String clasSchdlTtl) {
        this.clasSchdlTtl = clasSchdlTtl;
    }

    public String getClasSchdlSdttm() {
        return clasSchdlSdttm;
    }

    public void setClasSchdlSdttm(String clasSchdlSdttm) {
        this.clasSchdlSdttm = clasSchdlSdttm;
    }

    public String getClasSchdlEdttm() {
        return clasSchdlEdttm;
    }

    public void setClasSchdlEdttm(String clasSchdlEdttm) {
        this.clasSchdlEdttm = clasSchdlEdttm;
    }

    public String getClasSchdlExpln() {
        return clasSchdlExpln;
    }

    public void setClasSchdlExpln(String clasSchdlExpln) {
        this.clasSchdlExpln = clasSchdlExpln;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getRegDttm() {
        return regDttm;
    }

    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    public String getMdfrDttm() {
        return mdfrDttm;
    }

    public void setMdfrDttm(String mdfrDttm) {
        this.mdfrDttm = mdfrDttm;
    }

    // toString() 오버라이드 (디버깅 및 로그 출력용)
    @Override
    public String toString() {
        return "ClassScheduleVO [" +
                "clasSchdlId=" + clasSchdlId + 
                ", smstrChrtId=" + smstrChrtId + 
                ", sbjctId=" + sbjctId + 
                ", clasSchdlTtl=" + clasSchdlTtl + 
                ", clasSchdlSdttm=" + clasSchdlSdttm + 
                ", clasSchdlEdttm=" + clasSchdlEdttm + 
                ", clasSchdlExpln=" + clasSchdlExpln + 
                ", rgtrId=" + rgtrId + 
                ", regDttm=" + regDttm + 
                ", mdfrId=" + mdfrId + 
                ", mdfrDttm=" + mdfrDttm + 
                "]";
    }
}