package knou.lms.common.dto;

import knou.framework.context2.UserContext;
import knou.lms.schedule.vo.CalendarVO;

public class SubjectDTO extends CommonDTO {

	public SubjectDTO(UserContext userCtx) {
		super(userCtx);
	}
	
	public SubjectDTO(UserContext userCtx, String sbjctId) {
		super(userCtx);
		this.sbjctId = sbjctId;
	}
	
	public SubjectDTO( String sbjctId ) {
		this.sbjctId = sbjctId;
	}
	
	public SubjectDTO() {}
	
	public SubjectDTO(CalendarVO calVo) {
		this.sbjctId = calVo.getSbjctId();
	}

	private String	sbjctId;

	public String getSbjctId() {
		return sbjctId;
	}

	public void setSbjctId(String sbjctId) {
		this.sbjctId = sbjctId;
	}
}