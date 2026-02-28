package knou.framework.context2;

import knou.lms.crs.semester.vo.SmstrChrtVO;

public class AcademyContext {

	String	drgrYr; // 학위연도
	String	dgrsSmstrChrt; //학위학기기수
	
	
	public AcademyContext(SmstrChrtVO smstrChrtVO) {
		this.drgrYr = smstrChrtVO.getDgrsYr();
		this.dgrsSmstrChrt = smstrChrtVO.getDgrsSmstrChrt();
	}
	public String getDrgrYr() {
		return drgrYr;
	}
	public void setDrgrYr(String drgrYr) {
		this.drgrYr = drgrYr;
	}
	public String getDgrsSmstrChrt() {
		return dgrsSmstrChrt;
	}
	public void setDgrsSmstrChrt(String dgrsSmstrChrt) {
		this.dgrsSmstrChrt = dgrsSmstrChrt;
	}
	
}