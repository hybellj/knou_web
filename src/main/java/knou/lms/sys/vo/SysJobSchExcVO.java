package knou.lms.sys.vo;

import knou.lms.common.vo.DefaultVO;

public class SysJobSchExcVO extends DefaultVO {

	private static final long serialVersionUID = 5636984873701189268L;
	
	/** tb_sys_job_sch_exc */
    private String  sysjobSchdlExcpId;		// 시스템 작업일정예외 아이디
    private String  sysjobSchdlId;			// 시스템작업 일정 아이디
    private String  sysjobSchdlnm;			// 시스템작업 일정명
    
    private String	sbjctId;				// 과목 아이디
    
	private String  sysjobSchdlExcpProcRsnCn;	// 예외처리 사유
	
    private String  sysjobSchdlSymd;		// 시스템작업 일정 시작일자
    private String  sysjobSchdlEymd;		// 시스템작업 일정 종료일자
    
    private String  excpIdStr;				// 예외 아이디 | 과정 개설 코드 목록 split ,
    
    public String getSysjobSchdlExcpId() {
        return sysjobSchdlExcpId;
    }
    public void setSysjobSchdlExcpId(String jobExcSn) {
        this.sysjobSchdlExcpId = jobExcSn;
    }
    public String getSysjobSchdlId() {
        return sysjobSchdlId;
    }
    public void setSysjobSchdlId(String jobSchSn) {
        this.sysjobSchdlId = jobSchSn;
    }
    
    public String getSbjctId() {
		return sbjctId;
	}
	public void setSbjctId(String sbjctId) {
		this.sbjctId = sbjctId;
	}
	public String getSysjobSchdlSymd() {
        return sysjobSchdlSymd;
    }
    public void setSysjobSchdlSymd(String schStartDt) {
        this.sysjobSchdlSymd = schStartDt;
    }
    public String getSysjobSchdlEymd() {
        return sysjobSchdlEymd;
    }
    public void setSysjobSchdlEymd(String schEndDt) {
        this.sysjobSchdlEymd = schEndDt;
    }
    public String getSysjobSchdlExcpProcRsnCn() {
        return sysjobSchdlExcpProcRsnCn;
    }
    public void setSysjobSchdlExcpProcRsnCn(String excCmnt) {
        this.sysjobSchdlExcpProcRsnCn = excCmnt;
    }
    public String getExcpIdStr() {
        return excpIdStr;
    }
    public void setExcpIdStr(String excSnStr) {
        this.excpIdStr = excSnStr;
    }
    public String getSysjobSchdlnm() {
        return sysjobSchdlnm;
    }
    public void setSysjobSchdlnm(String jobSchNm) {
        this.sysjobSchdlnm = jobSchNm;
    }
}
