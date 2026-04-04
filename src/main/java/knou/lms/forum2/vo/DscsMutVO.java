package knou.lms.forum2.vo;

import knou.lms.common.vo.DefaultVO;

import java.util.Base64;

public class DscsMutVO extends DefaultVO {

    private static final long serialVersionUID = -1116530926234534895L;

    private String stdId;     // 수강생 번호
    private String forumCd;   // 토론코드
    private String mutSn;     // 상호평가 고유번호
    private String parAtclSn; // 상위 게시글 고유번호
    private Double score;     // 점수
    private String cmnt;      // 평가 의견

    /* DB와 관계없는 파라미터 */
    private String userId; // 사용자 아이디
    private int    mutCnt; // 평가 인원
    private int    mutAvg; // 평균 별점
    private String phtFile;
    private byte[] phtFileByte;

    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getForumCd() {
        return forumCd;
    }

    public void setForumCd(String forumCd) {
        this.forumCd = forumCd;
    }
    public String getDscsId() {
        return forumCd;
    }

    public void setDscsId(String dscsId) {
        this.forumCd = dscsId;
    }

    public String getMutSn() {
        return mutSn;
    }

    public void setMutSn(String mutSn) {
        this.mutSn = mutSn;
    }

    public String getParAtclSn() {
        return parAtclSn;
    }

    public void setParAtclSn(String parAtclSn) {
        this.parAtclSn = parAtclSn;
    }

    public Double getScore() {
        return score;
    }

    public void setScore(Double score) {
        this.score = score;
    }

    public String getCmnt() {
        return cmnt;
    }

    public void setCmnt(String cmnt) {
        this.cmnt = cmnt;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public int getMutCnt() {
        return mutCnt;
    }

    public void setMutCnt(int mutCnt) {
        this.mutCnt = mutCnt;
    }

    public int getMutAvg() {
        return mutAvg;
    }

    public void setMutAvg(int mutAvg) {
        this.mutAvg = mutAvg;
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

}
