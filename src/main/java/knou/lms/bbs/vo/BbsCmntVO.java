package knou.lms.bbs.vo;

import java.util.Base64;

import knou.lms.common.vo.DefaultVO;

public class BbsCmntVO extends DefaultVO {
    private static final long serialVersionUID = -1750542059300427475L;

    private String		orgId;
    private String		bbsId;
    private String		cmntId;
    private String		atclId;
    private String		parCmntId;
    private String		cmntCts;
    private int		emoticonNo;
    private String		delYn;
    private int		level;

    private String		userId;
    private String		userNm;
    private String		toUserNm;
    private String		viewerNo;
    private String		editAuthYn;
    private String		deleteAuthYn;
    private String		noDeleteViewModeYn; // 삭제댓글 제외 여부
    private String		phtFile;
    private byte[]		phtFileByte;

    private int		    atclLv;
    private String		upAtclCmntId;
    private String		atclCmntId;
    private String		atclCmntCts;
    private int         emticnNo;

    public String getCmntId() {
        return cmntId;
    }

    public void setCmntId(String cmntId) {
        this.cmntId = cmntId;
    }

    public String getAtclId() {
        return atclId;
    }

    public void setAtclId(String atclId) {
        this.atclId = atclId;
    }

    public String getParCmntId() {
        return parCmntId;
    }

    public void setParCmntId(String parCmntId) {
        this.parCmntId = parCmntId;
    }

    public String getCmntCts() {
        return cmntCts;
    }

    public void setCmntCts(String cmntCts) {
        this.cmntCts = cmntCts;
    }

    public int getEmoticonNo() {
        return emoticonNo;
    }

    public void setEmoticonNo(int emoticonNo) {
        this.emoticonNo = emoticonNo;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    public String getToUserNm() {
        return toUserNm;
    }

    public void setToUserNm(String toUserNm) {
        this.toUserNm = toUserNm;
    }

    public String getViewerNo() {
        return viewerNo;
    }

    public void setViewerNo(String viewerNo) {
        this.viewerNo = viewerNo;
    }

    public String getEditAuthYn() {
        return editAuthYn;
    }

    public void setEditAuthYn(String editAuthYn) {
        this.editAuthYn = editAuthYn;
    }

    public String getNoDeleteViewModeYn() {
        return noDeleteViewModeYn;
    }

    public void setNoDeleteViewModeYn(String noDeleteViewModeYn) {
        this.noDeleteViewModeYn = noDeleteViewModeYn;
    }

    public String getPhtFile() {
        if(phtFile == null && phtFileByte != null && phtFileByte.length > 0) {
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

    public String getDeleteAuthYn() {
        return deleteAuthYn;
    }

    public void setDeleteAuthYn(String deleteAuthYn) {
        this.deleteAuthYn = deleteAuthYn;
    }

	public String getOrgId() {
		return orgId;
	}

	public String getBbsId() {
		return bbsId;
	}

	public int getAtclLv() {
		return atclLv;
	}

	public String getUpAtclCmntId() {
		return upAtclCmntId;
	}

	public String getAtclCmntId() {
		return atclCmntId;
	}

	public String getAtclCmntCts() {
		return atclCmntCts;
	}

	public int getEmticnNo() {
		return emticnNo;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public void setBbsId(String bbsId) {
		this.bbsId = bbsId;
	}

	public void setAtclLv(int atclLv) {
		this.atclLv = atclLv;
	}

	public void setUpAtclCmntId(String upAtclCmntId) {
		this.upAtclCmntId = upAtclCmntId;
	}

	public void setAtclCmntId(String atclCmntId) {
		this.atclCmntId = atclCmntId;
	}

	public void setAtclCmntCts(String atclCmntCts) {
		this.atclCmntCts = atclCmntCts;
	}

	public void setEmticnNo(int emticnNo) {
		this.emticnNo = emticnNo;
	}

}