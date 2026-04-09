package knou.lms.forum2.vo;

import java.util.Base64;
import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class DscsAtclVO extends DefaultVO {

    private String dscsAtclId;
    private String dscsId;
    private String upDscsAtclId;
    private int atclLv;
    private int atclSeqno;
    private String dscsAtclTycd;
    private String oknokGbncd;
    private String atclTtl;
    private String atclCts;
    private int atclCtsLen;
    private int inqCnt;
    private int likes;
    private String usernm;
    private String rgtrId;
    private String regDttm;
    private String mdfrId;
    private String modDttm;
    private String edtrUseyn;
    private String delyn;

    private String recomStatus;
    private List<?> cmntList;

    private int dscsAtclCnt;
    private int dscsAtclPorsCnt;
    private int dscsAtclConsCnt;
    private int cmntCount;
    private int myCmntCount;
    private int maxOdr;
    private int afterAtclCnt;
    private String userId;
    private String stdId;
    private String stdList;

    private boolean viewAll;
    private String[] sqlForeach;
    private String phtFile;
    private byte[] phtFileByte;
    private String aplyAsnYn;
    private String konanMaxCopyRate;

    public String getDscsAtclId() {
        return dscsAtclId;
    }

    public void setDscsAtclId(String dscsAtclId) {
        this.dscsAtclId = dscsAtclId;
    }

    public String getDscsId() {
        return dscsId;
    }

    public void setDscsId(String dscsId) {
        this.dscsId = dscsId;
    }

    public String getUpDscsAtclId() {
        return upDscsAtclId;
    }

    public void setUpDscsAtclId(String upDscsAtclId) {
        this.upDscsAtclId = upDscsAtclId;
    }

    public int getAtclLv() {
        return atclLv;
    }

    public void setAtclLv(int atclLv) {
        this.atclLv = atclLv;
    }

    public int getAtclSeqno() {
        return atclSeqno;
    }

    public void setAtclSeqno(int atclSeqno) {
        this.atclSeqno = atclSeqno;
    }

    public String getDscsAtclTycd() {
        return dscsAtclTycd;
    }

    public void setDscsAtclTycd(String dscsAtclTycd) {
        this.dscsAtclTycd = dscsAtclTycd;
    }

    public String getOknokGbncd() {
        return oknokGbncd;
    }

    public void setOknokGbncd(String oknokGbncd) {
        this.oknokGbncd = oknokGbncd;
    }

    public String getAtclTtl() {
        return atclTtl;
    }

    public void setAtclTtl(String atclTtl) {
        this.atclTtl = atclTtl;
    }

    public String getAtclCts() {
        return atclCts;
    }

    public void setAtclCts(String atclCts) {
        this.atclCts = atclCts;
    }

    public int getAtclCtsLen() {
        return atclCtsLen;
    }

    public void setAtclCtsLen(int atclCtsLen) {
        this.atclCtsLen = atclCtsLen;
    }

    public int getInqCnt() {
        return inqCnt;
    }

    public void setInqCnt(int inqCnt) {
        this.inqCnt = inqCnt;
    }

    public int getLikes() {
        return likes;
    }

    public void setLikes(int likes) {
        this.likes = likes;
    }

    public String getUsernm() {
        return usernm;
    }

    public void setUsernm(String usernm) {
        this.usernm = usernm;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getRegDttm() {
        return regDttm;
    }

    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
    }

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    public String getModDttm() {
        return modDttm;
    }

    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }

    public String getEdtrUseyn() {
        return edtrUseyn;
    }

    public void setEdtrUseyn(String edtrUseyn) {
        this.edtrUseyn = edtrUseyn;
    }

    public String getDelyn() {
        return delyn;
    }

    public void setDelyn(String delyn) {
        this.delyn = delyn;
    }

    public String getRecomStatus() {
        return recomStatus;
    }

    public void setRecomStatus(String recomStatus) {
        this.recomStatus = recomStatus;
    }

    public List<?> getCmntList() {
        return cmntList;
    }

    public void setCmntList(List<?> cmntList) {
        this.cmntList = cmntList;
    }

    public int getDscsAtclCnt() {
        return dscsAtclCnt;
    }

    public void setDscsAtclCnt(int dscsAtclCnt) {
        this.dscsAtclCnt = dscsAtclCnt;
    }

    public int getDscsAtclPorsCnt() {
        return dscsAtclPorsCnt;
    }

    public void setDscsAtclPorsCnt(int dscsAtclPorsCnt) {
        this.dscsAtclPorsCnt = dscsAtclPorsCnt;
    }

    public int getDscsAtclConsCnt() {
        return dscsAtclConsCnt;
    }

    public void setDscsAtclConsCnt(int dscsAtclConsCnt) {
        this.dscsAtclConsCnt = dscsAtclConsCnt;
    }

    public int getCmntCount() {
        return cmntCount;
    }

    public void setCmntCount(int cmntCount) {
        this.cmntCount = cmntCount;
    }

    public int getMyCmntCount() {
        return myCmntCount;
    }

    public void setMyCmntCount(int myCmntCount) {
        this.myCmntCount = myCmntCount;
    }

    public int getMaxOdr() {
        return maxOdr;
    }

    public void setMaxOdr(int maxOdr) {
        this.maxOdr = maxOdr;
    }

    public int getAfterAtclCnt() {
        return afterAtclCnt;
    }

    public void setAfterAtclCnt(int afterAtclCnt) {
        this.afterAtclCnt = afterAtclCnt;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getStdList() {
        return stdList;
    }

    public void setStdList(String stdList) {
        this.stdList = stdList;
    }

    public boolean isViewAll() {
        return viewAll;
    }

    public void setViewAll(boolean viewAll) {
        this.viewAll = viewAll;
    }

    public String[] getSqlForeach() {
        return sqlForeach;
    }

    public void setSqlForeach(String[] sqlForeach) {
        this.sqlForeach = sqlForeach;
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

    public String getAplyAsnYn() {
        return aplyAsnYn;
    }

    public void setAplyAsnYn(String aplyAsnYn) {
        this.aplyAsnYn = aplyAsnYn;
    }

    public String getKonanMaxCopyRate() {
        return konanMaxCopyRate;
    }

    public void setKonanMaxCopyRate(String konanMaxCopyRate) {
        this.konanMaxCopyRate = konanMaxCopyRate;
    }

    public String getAtclSn() {
        return getDscsAtclId();
    }

    public void setAtclSn(String atclSn) {
        setDscsAtclId(atclSn);
    }

    public String getParAtclSn() {
        return getUpDscsAtclId();
    }

    public void setParAtclSn(String parAtclSn) {
        setUpDscsAtclId(parAtclSn);
    }

    public int getAtclLvl() {
        return getAtclLv();
    }

    public void setAtclLvl(int atclLvl) {
        setAtclLv(atclLvl);
    }

    public int getAtclOdr() {
        return getAtclSeqno();
    }

    public void setAtclOdr(int atclOdr) {
        setAtclSeqno(atclOdr);
    }

    public String getAtclTypeCd() {
        return getDscsAtclTycd();
    }

    public void setAtclTypeCd(String atclTypeCd) {
        setDscsAtclTycd(atclTypeCd);
    }

    public String getProsConsTypeCd() {
        return getOknokGbncd();
    }

    public void setProsConsTypeCd(String prosConsTypeCd) {
        setOknokGbncd(prosConsTypeCd);
    }

    public String getTitle() {
        return getAtclTtl();
    }

    public void setTitle(String title) {
        setAtclTtl(title);
    }

    public String getCts() {
        return getAtclCts();
    }

    public void setCts(String cts) {
        setAtclCts(cts);
    }

    public int getCtsLen() {
        return getAtclCtsLen();
    }

    public void setCtsLen(int ctsLen) {
        setAtclCtsLen(ctsLen);
    }

    public int getHits() {
        return getInqCnt();
    }

    public void setHits(int hits) {
        setInqCnt(hits);
    }

    public String getRegNm() {
        return getUsernm();
    }

    public void setRegNm(String regNm) {
        setUsernm(regNm);
    }

    public String getEditorYn() {
        return getEdtrUseyn();
    }

    public void setEditorYn(String editorYn) {
        setEdtrUseyn(editorYn);
    }

    public String getDelYn() {
        return getDelyn();
    }

    public void setDelYn(String delYn) {
        setDelyn(delYn);
    }
}
