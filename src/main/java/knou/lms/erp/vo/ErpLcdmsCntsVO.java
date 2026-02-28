package knou.lms.erp.vo;

import java.util.Date;

import knou.lms.common.vo.DefaultVO;

public class ErpLcdmsCntsVO extends DefaultVO {
	private static final long serialVersionUID = 1L;
	private String year;
    private String semester;
    private String gubun;
    private String courseCode;
    private String contCd;
    private int week;
    private String ltNo;
    private String seq;
    private String seqName;
    private String lbnTm;
    private String openYn;
    private String ltNote;
    private String wekClsfGbn;
    private String wekClsfGbnNm;
    private String ltNoteOfferYn;
    private Date insertAt;
    private Date modifyAt;

    public String getYear() {
        return year;
    }

    public String getSemester() {
        return semester;
    }

    public String getGubun() {
        return gubun;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public String getContCd() {
        return contCd;
    }

    public int getWeek() {
        return week;
    }

    public Date getInsertAt() {
        return insertAt;
    }

    public Date getModifyAt() {
        return modifyAt;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public void setGubun(String gubun) {
        this.gubun = gubun;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public void setContCd(String contCd) {
        this.contCd = contCd;
    }

    public void setWeek(int week) {
        this.week = week;
    }

    public void setLbnTm(String lbnTm) {
        this.lbnTm = lbnTm;
    }

    public void setInsertAt(Date insertAt) {
        this.insertAt = insertAt;
    }

    public void setModifyAt(Date modifyAt) {
        this.modifyAt = modifyAt;
    }

	public String getLtNo() {
		return ltNo;
	}

	public void setLtNo(String ltNo) {
		this.ltNo = ltNo;
	}

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public String getSeqName() {
		return seqName;
	}

	public void setSeqName(String seqName) {
		this.seqName = seqName;
	}

	public String getOpenYn() {
		return openYn;
	}

	public void setOpenYn(String openYn) {
		this.openYn = openYn;
	}

	public String getLtNote() {
		return ltNote;
	}

	public void setLtNote(String ltNote) {
		this.ltNote = ltNote;
	}

	public String getWekClsfGbn() {
		return wekClsfGbn;
	}

	public void setWekClsfGbn(String wekClsfGbn) {
		this.wekClsfGbn = wekClsfGbn;
	}

	public String getWekClsfGbnNm() {
		return wekClsfGbnNm;
	}

	public void setWekClsfGbnNm(String wekClsfGbnNm) {
		this.wekClsfGbnNm = wekClsfGbnNm;
	}

	public String getLtNoteOfferYn() {
		return ltNoteOfferYn;
	}

	public void setLtNoteOfferYn(String ltNoteOfferYn) {
		this.ltNoteOfferYn = ltNoteOfferYn;
	}

	public String getLbnTm() {
		return lbnTm;
	}
    
    
}
