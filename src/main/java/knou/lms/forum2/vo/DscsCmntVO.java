package knou.lms.forum2.vo;

import java.util.Base64;

import knou.lms.common.vo.DefaultVO;

public class DscsCmntVO extends DefaultVO {

    private static final long serialVersionUID = 2302072652819647474L;

    private String dscsCmntId; // 토론댓글아이디
    private String dscsId; // 토론아이디
    private String dscsAtclId; // 토론게시글아이디
    private String rspnsReqyn; // 답변요청여부
    private String cmntCts; // 댓글내용
    private String emtTycd; // 이모티콘유형코드
    private String delyn; // 삭제여부
    private String upCmntId; // 상위댓글아이디
    private String upUsernm; // 상위댓글 작성자명
    private int cmntCtsLen; // 댓글내용길이
    private String usernm; // 사용자명
    private String stdntNo; // 학번
    private String stdId; // 학습자 아이디
    private int lvl; // 댓글 레벨
    private String mdfrId; // 수정자아이디
    private String modDttm; // 수정일시
    private String phtFile; // 프로필 사진 파일
    private byte[] phtFileByte; // 프로필 사진 파일 바이트

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

    public String getStdntNo() {
        return stdntNo;
    }

    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }

    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
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

}
