package knou.lms.forum.vo;

import java.util.Base64;
import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class ForumAtclVO extends DefaultVO {

    private String atclSn;          //  게시글 고유번호
    private String forumCd;         //  토론코드 
    private String parAtclSn;       //  상위 게시글 고유번호
    private int atclLvl;            //  게시글 레벨
    private int atclOdr;            //  게시글 순서
    private String atclTypeCd;      //  게시글 유형 코드
    private String prosConsTypeCd;  //  찬성 반대 유형 코드
    private String title;           //  제목
    private String cts;             //  내용
    private int ctsLen;             //  내용길이
    private int hits;               //  조회 수 
    private int likes;              //  좋아요 
    private String regNm;           //  등록자 이름
    private String rgtrId;           //  등록자번호
    private String regDttm;         //  등록 일시
    private String mdfrId;           //  수정자 번호
    private String modDttm;         //  수정 일시
    private String editorYn;        //  수정 여부
    private String delYn;           //  삭제여부

    private String recomStatus;

    private List<?> cmntList;       // 댓글 목록

    /* DB와 관계없는 파라미터 */
    private int forumAtclCnt;       //  게시글 갯수
    private int forumAtclPorsCnt;   //  찬성 게시글 갯수
    private int forumAtclConsCnt;   //  반대 게시글 갯수
    private int cmntCount;
    private int myCmntCount;    // 로그인 사용자의 댓글 수
    private int maxOdr;
    private int afterAtclCnt;
    private String userId;
    private String stdId;           //수강생 번호
    private String crsCreCd;        //개설과정 코드
    private String stdList;

    private boolean viewAll;         // 교수 권한: delYn 무관 전체 조회
    private String[] sqlForeach;    // WHERE IN을 위한 배열 파라미터
    private String phtFile;
    private byte[] phtFileByte;
    private String aplyAsnYn;
    private String konanMaxCopyRate;

    public String getAtclSn() {
        return atclSn;
    }
    public void setAtclSn(String atclSn) {
        this.atclSn = atclSn;
    }

    public String getForumCd() {
        return forumCd;
    }
    public void setForumCd(String forumCd) {
        this.forumCd = forumCd;
    }

    public String getParAtclSn() {
        return parAtclSn;
    }
    public void setParAtclSn(String parAtclSn) {
        this.parAtclSn = parAtclSn;
    }

    public int getAtclLvl() {
        return atclLvl;
    }
    public void setAtclLvl(int atclLvl) {
        this.atclLvl = atclLvl;
    }

    public int getAtclOdr() {
        return atclOdr;
    }
    public void setAtclOdr(int atclOdr) {
        this.atclOdr = atclOdr;
    }

    public String getAtclTypeCd() {
        return atclTypeCd;
    }
    public void setAtclTypeCd(String atclTypeCd) {
        this.atclTypeCd = atclTypeCd;
    }

    public String getProsConsTypeCd() {
        return prosConsTypeCd;
    }
    public void setProsConsTypeCd(String prosConsTypeCd) {
        this.prosConsTypeCd = prosConsTypeCd;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    public String getCts() {
        return cts;
    }
    public void setCts(String cts) {
        this.cts = cts;
    }

    public int getCtsLen() {
        return ctsLen;
    }
    public void setCtsLen(int ctsLen) {
        this.ctsLen = ctsLen;
    }
    
    public int getHits() {
        return hits;
    }
    public void setHits(int hits) {
        this.hits = hits;
    }

    public int getLikes() {
        return likes;
    }
    public void setLikes(int likes) {
        this.likes = likes;
    }

    public String getRegNm() {
        return regNm;
    }
    public void setRegNm(String regNm) {
        this.regNm = regNm;
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

    public String getEditorYn() {
        return editorYn;
    }
    public void setEditorYn(String editorYn) {
        this.editorYn = editorYn;
    }

    public String getDelYn() {
        return delYn;
    }
    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public int getForumAtclCnt() {
        return forumAtclCnt;
    }
    public void setForumAtclCnt(int forumAtclCnt) {
        this.forumAtclCnt = forumAtclCnt;
    }

    public int getForumAtclPorsCnt() {
        return forumAtclPorsCnt;
    }
    public void setForumAtclPorsCnt(int forumAtclPorsCnt) {
        this.forumAtclPorsCnt = forumAtclPorsCnt;
    }

    public int getForumAtclConsCnt() {
        return forumAtclConsCnt;
    }
    public void setForumAtclConsCnt(int forumAtclConsCnt) {
        this.forumAtclConsCnt = forumAtclConsCnt;
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

    public String getStdList() {
        return stdList;
    }
    public void setStdList(String stdList) {
        this.stdList = stdList;
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

    public List<?> getCmntList() {
        return cmntList;
    }
    public void setCmntList(List<?> cmntList) {
        this.cmntList = cmntList;
    }

    public String getRecomStatus() {
        return recomStatus;
    }
    public void setRecomStatus(String recomStatus) {
        this.recomStatus = recomStatus;
    }

    public String getPhtFile() {
        String phtFile = null;

        if(phtFileByte != null && phtFileByte.length > 0) {
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

}
