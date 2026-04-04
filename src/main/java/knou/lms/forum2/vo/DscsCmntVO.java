package knou.lms.forum2.vo;

import java.util.Base64;

import knou.lms.common.vo.DefaultVO;

public class DscsCmntVO extends DefaultVO {

    private static final long serialVersionUID = 2302072652819647474L;

    private String dscsCmntId;
    private String dscsId;
    private String dscsAtclId;
    private String rspnsReqyn;
    private String cmntCts;
    private String emtTycd;
    private String delyn;
    private String upCmntId;
    private String upUsernm;
    private int cmntCtsLen;
    private String usernm;
    private String stdId;
    private String crsCreCd;
    private int lvl;
    private String mdfrId;
    private String modDttm;
    private String phtFile;
    private byte[] phtFileByte;

    @Override
    public String getRgtrnm() {
        return usernm;
    }

    @Override
    public void setRgtrnm(String rgtrnm) {
        this.usernm = rgtrnm;
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

    public String getDscsCmntId() {
        return dscsCmntId;
    }

    public void setDscsCmntId(String dscsCmntId) {
        this.dscsCmntId = dscsCmntId;
    }

    public String getDscsId() {
        return dscsId;
    }

    public void setDscsId(String dscsId) {
        this.dscsId = dscsId;
    }

    public String getDscsAtclId() {
        return dscsAtclId;
    }

    public void setDscsAtclId(String dscsAtclId) {
        this.dscsAtclId = dscsAtclId;
    }

    public String getRspnsReqyn() {
        return rspnsReqyn;
    }

    public void setRspnsReqyn(String rspnsReqyn) {
        this.rspnsReqyn = rspnsReqyn;
    }

    public String getCmntCts() {
        return cmntCts;
    }

    public void setCmntCts(String cmntCts) {
        this.cmntCts = cmntCts;
    }

    public String getEmtTycd() {
        return emtTycd;
    }

    public void setEmtTycd(String emtTycd) {
        this.emtTycd = emtTycd;
    }

    public String getDelyn() {
        return delyn;
    }

    public void setDelyn(String delyn) {
        this.delyn = delyn;
    }

    public String getUpCmntId() {
        return upCmntId;
    }

    public void setUpCmntId(String upCmntId) {
        this.upCmntId = upCmntId;
    }

    public String getUpUsernm() {
        return upUsernm;
    }

    public void setUpUsernm(String upUsernm) {
        this.upUsernm = upUsernm;
    }

    public int getCmntCtsLen() {
        return cmntCtsLen;
    }

    public void setCmntCtsLen(int cmntCtsLen) {
        this.cmntCtsLen = cmntCtsLen;
    }

    public String getUsernm() {
        return usernm;
    }

    public void setUsernm(String usernm) {
        this.usernm = usernm;
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

    public int getLvl() {
        return lvl;
    }

    public void setLvl(int lvl) {
        this.lvl = lvl;
    }

    public String getPhtFile() {
        if (phtFileByte != null && phtFileByte.length > 0) {
            return "data:image/png;base64," + new String(Base64.getEncoder().encode(phtFileByte));
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

    public String getCmntSn() {
        return getDscsCmntId();
    }

    public void setCmntSn(String cmntSn) {
        setDscsCmntId(cmntSn);
    }

    public String getForumCd() {
        return getDscsId();
    }

    public void setForumCd(String forumCd) {
        setDscsId(forumCd);
    }

    public String getAtclSn() {
        return getDscsAtclId();
    }

    public void setAtclSn(String atclSn) {
        setDscsAtclId(atclSn);
    }

    public String getAnsReqYn() {
        return getRspnsReqyn();
    }

    public void setAnsReqYn(String ansReqYn) {
        setRspnsReqyn(ansReqYn);
    }

    public String getEmoticonNo() {
        return getEmtTycd();
    }

    public void setEmoticonNo(String emoticonNo) {
        setEmtTycd(emoticonNo);
    }

    public String getDelYn() {
        return getDelyn();
    }

    public void setDelYn(String delYn) {
        setDelyn(delYn);
    }

    public String getParCmntSn() {
        return getUpCmntId();
    }

    public void setParCmntSn(String parCmntSn) {
        setUpCmntId(parCmntSn);
    }

    public String getParRgtrNm() {
        return getUpUsernm();
    }

    public void setParRgtrNm(String parRgtrNm) {
        setUpUsernm(parRgtrNm);
    }

    public int getLevel() {
        return getLvl();
    }

    public void setLevel(int level) {
        setLvl(level);
    }
}
