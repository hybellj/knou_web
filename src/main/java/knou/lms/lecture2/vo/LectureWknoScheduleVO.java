package knou.lms.lecture2.vo;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

@Alias("lectureWknoScheduleVO")
public class LectureWknoScheduleVO  implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -624795244291882479L;

	int	lctrWkno;
	
	String	lctrWknoSymd;
	String	lctrWknoEymd;
	String	lctrWknoSchdlId;
	
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
	public String getLctrWknoSchdlId() {
		return this.lctrWknoSchdlId;
	}
}