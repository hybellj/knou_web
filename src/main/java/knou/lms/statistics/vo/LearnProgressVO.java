package knou.lms.statistics.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * TB_LMS_LRN_PRGRT (학습진도율)
 */
public class LearnProgressVO extends DefaultVO {
	
	private static final long serialVersionUID = -410481457875728270L;
	
	private String smstrChrtId;
	private String CrsMstrId;
	private String sbjctOfrngId;
	private String dvclasNo;
	private String lrnWkno;
	private String lrnWkCnt;
	
	public String getSmstrChrtId() {
		return smstrChrtId;
	}
	public void setSmstrChrtId(String smstrChrtId) {
		this.smstrChrtId = smstrChrtId;
	}
	public String getCrsMstrId() {
		return CrsMstrId;
	}
	public void setCrsMstrId(String crsMstrId) {
		CrsMstrId = crsMstrId;
	}
	public String getSbjctOfrngId() {
		return sbjctOfrngId;
	}
	public void setSbjctOfrngId(String sbjctOfrngId) {
		this.sbjctOfrngId = sbjctOfrngId;
	}
	public String getDvclasNo() {
		return dvclasNo;
	}
	public void setDvclasNo(String dvclasNo) {
		this.dvclasNo = dvclasNo;
	}
	public String getLrnWkno() {
		return lrnWkno;
	}
	public void setLrnWkno(String lrnWkno) {
		this.lrnWkno = lrnWkno;
	}
	public String getLrnWkCnt() {
		return lrnWkCnt;
	}
	public void setLrnWkCnt(String lrnWkCnt) {
		this.lrnWkCnt = lrnWkCnt;
	}
}
