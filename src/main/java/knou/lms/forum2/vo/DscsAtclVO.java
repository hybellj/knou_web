package knou.lms.forum2.vo;

import java.util.Base64;
import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class DscsAtclVO extends DefaultVO {

    private String dscsAtclId; // 토론게시글아이디
    private String dscsId; // 토론아이디
    private String upDscsAtclId; // 상위토론게시글아이디
    private int atclLv; // 게시글레벨
    private int atclSeqno; // 게시글순번
    private String dscsAtclTycd; // 토론게시글유형코드
    private String oknokGbncd; // 찬성반대구분코드
    private String atclTtl; // 게시글제목
    private String atclCts; // 게시글내용
    private int atclCtsLen; // 게시글내용길이
    private int inqCnt; // 조회수
    private String usernm; // 사용자명
    private String rgtrId; // 등록자아이디
    private String regDttm; // 등록일시
    private String mdfrId; // 수정자아이디
    private String modDttm; // 수정일시
    private String edtrUseyn; // 에디터사용여부
    private String delyn; // 삭제여부

    private List<?> cmntList; // 댓글 목록

    private int dscsAtclCnt; // 게시글 갯수
    private int cmntCount; // 댓글 갯수
    private int writerCmntCount; // 작성자 댓글 갯수
    private int viewerCmntCount; // 조회자 댓글 갯수
    private int maxOdr; // 최대 게시글 순번
    private String userId; // 사용자아이디
    private String stdntNo; // 학번
    private String stdId; // 학습자 아이디
    private String stdList; // 학습자 목록

    private boolean viewAll; // 전체 조회 여부
    private String[] sqlForeach; // WHERE IN 배열 파라미터
    private String phtFile; // 프로필 사진 파일
    private byte[] phtFileByte; // 프로필 사진 파일 바이트

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

    public int getCmntCount() {
        return cmntCount;
    }

    public void setCmntCount(int cmntCount) {
        this.cmntCount = cmntCount;
    }

    public int getWriterCmntCount() {
        return writerCmntCount;
    }

    public void setWriterCmntCount(int writerCmntCount) {
        this.writerCmntCount = writerCmntCount;
    }

    public int getViewerCmntCount() {
        return viewerCmntCount;
    }

    public void setViewerCmntCount(int viewerCmntCount) {
        this.viewerCmntCount = viewerCmntCount;
    }

    public int getMaxOdr() {
        return maxOdr;
    }

    public void setMaxOdr(int maxOdr) {
        this.maxOdr = maxOdr;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
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
}
