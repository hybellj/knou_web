package knou.lms.log2.user.vo;

import knou.lms.common.vo.DefaultVO;

public class LogLrnActvInqHstryVO extends DefaultVO {

    /**
	 * 
	 */
	private static final long serialVersionUID = -1404937826438771410L;

	/**
     * 학습활동아이디
     */
    private String lrnActvId;

    /**
     * 학습활동유형코드
     */
    private String lrnActvTycd;
    
    public LogLrnActvInqHstryVO() {} // 기본생성자

    public LogLrnActvInqHstryVO(String lrnActvTycd, String rootAsmtId, String userId) { // 파라미터생성자
		this.lrnActvTycd = lrnActvTycd;
		this.lrnActvId = rootAsmtId;
		super.setUserId(userId);
	}

	public String getLrnActvId() {
        return lrnActvId;
    }

    public void setLrnActvId(String lrnActvId) {
        this.lrnActvId = lrnActvId;
    }

    public String getLrnActvTycd() {
        return lrnActvTycd;
    }

    public void setLrnActvTycd(String lrnActvTycd) {
        this.lrnActvTycd = lrnActvTycd;
    }
}
