package knou.lms.subject.vo;

import java.io.Serializable;

public class LectureWknoScheduleVO  implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -624795244291882479L;

	int	lctrWkno;
	
	String	lctrWknoSymd;
	String	lctrWknoEymd;
	
	public int getLctrWkno() {
		return lctrWkno;
	}
	public void setLctrWkno(int lctrWkno) {
		this.lctrWkno = lctrWkno;
	}
	public String getLctrWknoSymd() {
		return lctrWknoSymd;
	}
	public void setLctrWknoSymd(String lctrWknoSymd) {
		this.lctrWknoSymd = lctrWknoSymd;
	}
	public String getLctrWknoEymd() {
		return lctrWknoEymd;
	}
	public void setLctrWknoEymd(String lctrWknoEymd) {
		this.lctrWknoEymd = lctrWknoEymd;
	}
}