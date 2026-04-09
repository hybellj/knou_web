package knou.lms.mrk.vo;

import knou.lms.common.vo.DefaultVO;

public class MarkObjectionApplyVO extends DefaultVO {

    private String mrkObjctAplyId;  // 성적이의신청 아이디
    private String objctAplyrId;    // 이의신청자 아이디
    private String objctAplyCts;    // 이의신청 내용
    private String objctAplyDttm;   // 이의신청 일시
    private String objctAplyScr;    // 이의신청 점수
    private String objctAplyStscd;  // 이의신청 상태코드
    private String objctAplySts;    // 이의신청 상태

    private String chgbfrScr;       // 변경 전 점수
    private String chgbfrMrkGrdcd;  // 변경 전 성적등급코드
    private String chgaftScr;       // 변경 후 점수
    private String chgaftMrkGrdcd;  // 변경 후 성적등급코드
    private String chgRsn;          // 변경 사유
    private String chgrId;          // 변경자 아이디
    private String chgDttm;         // 변경일시


    private String deptnm;  // 학과부서명
    private String stdntNo; // 학번
    private String scyr;    // 학년

    public String getMrkObjctAplyId() {
        return mrkObjctAplyId;
    }

    public void setMrkObjctAplyId(String mrkObjctAplyId) {
        this.mrkObjctAplyId = mrkObjctAplyId;
    }

    public String getObjctAplyrId() {
        return objctAplyrId;
    }

    public void setObjctAplyrId(String objctAplyrId) {
        this.objctAplyrId = objctAplyrId;
    }

    public String getObjctAplyCts() {
        return objctAplyCts;
    }

    public void setObjctAplyCts(String objctAplyCts) {
        this.objctAplyCts = objctAplyCts;
    }

    public String getObjctAplyDttm() {
        return objctAplyDttm;
    }

    public void setObjctAplyDttm(String objctAplyDttm) {
        this.objctAplyDttm = objctAplyDttm;
    }

    public String getObjctAplyScr() {
        return objctAplyScr;
    }

    public void setObjctAplyScr(String objctAplyScr) {
        this.objctAplyScr = objctAplyScr;
    }

    public String getObjctAplyStscd() {
        return objctAplyStscd;
    }

    public void setObjctAplyStscd(String objctAplyStscd) {
        this.objctAplyStscd = objctAplyStscd;
    }

    public String getChgbfrScr() {
        return chgbfrScr;
    }

    public void setChgbfrScr(String chgbfrScr) {
        this.chgbfrScr = chgbfrScr;
    }

    public String getChgbfrMrkGrdcd() {
        return chgbfrMrkGrdcd;
    }

    public void setChgbfrMrkGrdcd(String chgbfrMrkGrdcd) {
        this.chgbfrMrkGrdcd = chgbfrMrkGrdcd;
    }

    public String getChgaftScr() {
        return chgaftScr;
    }

    public void setChgaftScr(String chgaftScr) {
        this.chgaftScr = chgaftScr;
    }

    public String getChgaftMrkGrdcd() {
        return chgaftMrkGrdcd;
    }

    public void setChgaftMrkGrdcd(String chgaftMrkGrdcd) {
        this.chgaftMrkGrdcd = chgaftMrkGrdcd;
    }

    public String getChgRsn() {
        return chgRsn;
    }

    public void setChgRsn(String chgRsn) {
        this.chgRsn = chgRsn;
    }

    public String getChgrId() {
        return chgrId;
    }

    public void setChgrId(String chgrId) {
        this.chgrId = chgrId;
    }

    public String getChgDttm() {
        return chgDttm;
    }

    public void setChgDttm(String chgDttm) {
        this.chgDttm = chgDttm;
    }

    public String getObjctAplySts() {
        return objctAplySts;
    }

    public void setObjctAplySts(String objctAplySts) {
        this.objctAplySts = objctAplySts;
    }

    public String getDeptnm() {
        return deptnm;
    }

    public void setDeptnm(String deptnm) {
        this.deptnm = deptnm;
    }

    public String getStdntNo() {
        return stdntNo;
    }

    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }

    public String getScyr() {
        return scyr;
    }

    public void setScyr(String scyr) {
        this.scyr = scyr;
    }
}
