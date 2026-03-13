package knou.lms.forum.vo;

import java.util.Base64;

import knou.lms.common.vo.DefaultVO;

public class ForumCmntVO extends DefaultVO{
    
	private static final long serialVersionUID = 2302072652819647474L;
	
	private String cmntSn;      //  댓글 고유번호
    private String forumCd;     //  토론 코드
    private String atclSn;      //  게시글 고유번호
    
    private String ansReqYn;    // 답변요청 여부
    private String cmntCts;     //  댓글 내용
    private String emoticonNo;     //  이모티콘 번호
    
    private String delYn;       // 삭제여부
    private String parCmntSn;   // 상위 댓글 고유번호
    private String parRgtrNm;    // 상위 댓글 등록자 이름
    private int cmntCtsLen;     // 내용길이

    private String rgtrnm;       //등록자 이름
    private String stdId;       //수강생 번호
    private String crsCreCd;    //개설과정 코드

    private int level;          // 댓글 레벨
    private String mdfrId;
    private String modDttm;

    private String phtFile;
    private byte[] phtFileByte;

    @Override
    public String getRgtrnm() {
        return rgtrnm;
    }

    @Override
    public void setRgtrnm(String rgtrnm) {
        this.rgtrnm = rgtrnm;
    }

    @Override
    public String getMdfrId() {
        return mdfrId;
    }

    @Override
    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    @Override
    public String getModDttm() {
        return modDttm;
    }

    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public String getCmntSn() {
        return cmntSn;
    }
    public void setCmntSn(String cmntSn) {
        this.cmntSn = cmntSn;
    }
    public String getForumCd() {
        return forumCd;
    }
    public void setForumCd(String forumCd) {
        this.forumCd = forumCd;
    }
    public String getAtclSn() {
        return atclSn;
    }
    public void setAtclSn(String atclSn) {
        this.atclSn = atclSn;
    }
    public String getCmntCts() {
        return cmntCts;
    }
    public void setCmntCts(String cmntCts) {
        this.cmntCts = cmntCts;
    }
    public String getEmoticonNo() {
        return emoticonNo;
    }
    public void setEmoticonNo(String emoticonNo) {
        this.emoticonNo = emoticonNo;
    }
    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
    public String getParCmntSn() {
        return parCmntSn;
    }
    public void setParCmntSn(String parCmntSn) {
        this.parCmntSn = parCmntSn;
    }
    public String getStdId() {
        return stdId;
    }
    public void setStdId(String stdId) {
        this.stdId = stdId;
    }
    public String getCrsCreCd() {
        return crsCreCd;
    }
    public void setCrsCreCd(String crsCreCd) {
        this.crsCreCd = crsCreCd;
    }
    public String getAnsReqYn() {
        return ansReqYn;
    }
    public void setAnsReqYn(String ansReqYn) {
        this.ansReqYn = ansReqYn;
    }
	public int getCmntCtsLen() {
		return cmntCtsLen;
	}
	public void setCmntCtsLen(int cmntCtsLen) {
		this.cmntCtsLen = cmntCtsLen;
	}
	public String getParRgtrNm() {
		return parRgtrNm;
	}
	public void setParRgtrNm(String parRgtrNm) {
		this.parRgtrNm = parRgtrNm;
	}
	public String getPhtFile() {
        String phtFile = null;

        if (phtFileByte != null && phtFileByte.length > 0) {
            phtFile = "data:image/png;base64," + new String(Base64.getEncoder().encode(phtFileByte));
        }

        return phtFile;
    }
    public void setPhtFile(String phtFile) {
        this.phtFile = phtFile;
    }
    public byte[] getPhtFileByte() {
        return phtFileByte;
    }
    public void setPhtFileByte(byte[] phtFileByte) {
        this.phtFileByte = phtFileByte;
    }

}
