package knou.lms.msg.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;
import knou.lms.file.vo.AtflVO;

public class MsgShrtntVO extends DefaultVO {
    private static final long serialVersionUID = 1L;

    // === TB_LMS_MSG ===
    private String msgId;
    private String msgTmpltId;
    private String msgTycd;
    private String msgCtsGbncd;
    private String ttl;
    private String txtCts;
    private String htmlCts;
    private String sndngOnlyyn;
    private String rsrvSndngSdttm;
    private String dgrsYr;
    private String smstr;
    private String rsrvSndngCnclDttm;

    // === TB_LMS_MSG_SHRTNT_SNDNG ===
    private String msgShrtntSndngId;
    private String upMsgShrtntSndngId;
    private String sndngTtl;
    private String sndngCts;
    private String sndngDttm;
    private String sndngrId;
    private String sndngnm;
    private String rcvrId;
    private String rcvrnm;
    private String readDttm;
    private String sndngrDelyn;
    private String rcvrDelyn;

    // === 검색 조건 ===
    private String sbjctYr;
    private String sbjctSmstr;
    private String deptId;
    private String sndngSdttm;
    private String sndngEdttm;
    private String ownSndngYn;
    private String listType;

    // === 목록/상세 표시용 (가공 데이터) ===
    private String efctvSndngDttm;

    // === 목록 표시용 ===
    private int rnum;
    private String orgnm;
    private String deptnm;
    private String sbjctnm;
    private String dvclasNo;
    private String readYn;
    private int rcvrCnt;
    private String rsrvYn;
    private String sndngYn;
    private int sndngSuccCnt;
    private int fileCnt;

    // === 발신 폼용 ===
    private String rcvrListJson;
    private String sndngrPhnno;

    // === 엑셀 업로드용 ===
    private List<String> userIdList;

    // === 사용자 검색용 ===
    private String adminYn;
    private String userTycd;
    private String stdntNo;
    private String usernm;
    private String mblPhn;
    private String eml;
    private String userRprsId2;

    // === 첨부파일 ===
    private List<AtflVO> atflList;

    // Getter/Setter

    public String getMsgId() {
        return msgId;
    }

    public void setMsgId(String msgId) {
        this.msgId = msgId;
    }

    public String getMsgTmpltId() {
        return msgTmpltId;
    }

    public void setMsgTmpltId(String msgTmpltId) {
        this.msgTmpltId = msgTmpltId;
    }

    public String getMsgTycd() {
        return msgTycd;
    }

    public void setMsgTycd(String msgTycd) {
        this.msgTycd = msgTycd;
    }

    public String getMsgCtsGbncd() {
        return msgCtsGbncd;
    }

    public void setMsgCtsGbncd(String msgCtsGbncd) {
        this.msgCtsGbncd = msgCtsGbncd;
    }

    public String getTtl() {
        return ttl;
    }

    public void setTtl(String ttl) {
        this.ttl = ttl;
    }

    public String getTxtCts() {
        return txtCts;
    }

    public void setTxtCts(String txtCts) {
        this.txtCts = txtCts;
    }

    public String getHtmlCts() {
        return htmlCts;
    }

    public void setHtmlCts(String htmlCts) {
        this.htmlCts = htmlCts;
    }

    public String getSndngOnlyyn() {
        return sndngOnlyyn;
    }

    public void setSndngOnlyyn(String sndngOnlyyn) {
        this.sndngOnlyyn = sndngOnlyyn;
    }

    public String getRsrvSndngSdttm() {
        return rsrvSndngSdttm;
    }

    public void setRsrvSndngSdttm(String rsrvSndngSdttm) {
        this.rsrvSndngSdttm = rsrvSndngSdttm;
    }

    public String getDgrsYr() {
        return dgrsYr;
    }

    public void setDgrsYr(String dgrsYr) {
        this.dgrsYr = dgrsYr;
    }

    public String getSmstr() {
        return smstr;
    }

    public void setSmstr(String smstr) {
        this.smstr = smstr;
    }

    public String getRsrvSndngCnclDttm() {
        return rsrvSndngCnclDttm;
    }

    public void setRsrvSndngCnclDttm(String rsrvSndngCnclDttm) {
        this.rsrvSndngCnclDttm = rsrvSndngCnclDttm;
    }

    public String getMsgShrtntSndngId() {
        return msgShrtntSndngId;
    }

    public void setMsgShrtntSndngId(String msgShrtntSndngId) {
        this.msgShrtntSndngId = msgShrtntSndngId;
    }

    public String getUpMsgShrtntSndngId() {
        return upMsgShrtntSndngId;
    }

    public void setUpMsgShrtntSndngId(String upMsgShrtntSndngId) {
        this.upMsgShrtntSndngId = upMsgShrtntSndngId;
    }

    public String getSndngTtl() {
        return sndngTtl;
    }

    public void setSndngTtl(String sndngTtl) {
        this.sndngTtl = sndngTtl;
    }

    public String getSndngCts() {
        return sndngCts;
    }

    public void setSndngCts(String sndngCts) {
        this.sndngCts = sndngCts;
    }

    public String getSndngDttm() {
        return sndngDttm;
    }

    public void setSndngDttm(String sndngDttm) {
        this.sndngDttm = sndngDttm;
    }

    public String getSndngrId() {
        return sndngrId;
    }

    public void setSndngrId(String sndngrId) {
        this.sndngrId = sndngrId;
    }

    public String getSndngnm() {
        return sndngnm;
    }

    public void setSndngnm(String sndngnm) {
        this.sndngnm = sndngnm;
    }

    public String getRcvrId() {
        return rcvrId;
    }

    public void setRcvrId(String rcvrId) {
        this.rcvrId = rcvrId;
    }

    public String getRcvrnm() {
        return rcvrnm;
    }

    public void setRcvrnm(String rcvrnm) {
        this.rcvrnm = rcvrnm;
    }

    public String getReadDttm() {
        return readDttm;
    }

    public void setReadDttm(String readDttm) {
        this.readDttm = readDttm;
    }

    public String getSndngrDelyn() {
        return sndngrDelyn;
    }

    public void setSndngrDelyn(String sndngrDelyn) {
        this.sndngrDelyn = sndngrDelyn;
    }

    public String getRcvrDelyn() {
        return rcvrDelyn;
    }

    public void setRcvrDelyn(String rcvrDelyn) {
        this.rcvrDelyn = rcvrDelyn;
    }

    public String getSbjctYr() {
        return sbjctYr;
    }

    public void setSbjctYr(String sbjctYr) {
        this.sbjctYr = sbjctYr;
    }

    public String getSbjctSmstr() {
        return sbjctSmstr;
    }

    public void setSbjctSmstr(String sbjctSmstr) {
        this.sbjctSmstr = sbjctSmstr;
    }

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getSndngSdttm() {
        return sndngSdttm;
    }

    public void setSndngSdttm(String sndngSdttm) {
        this.sndngSdttm = sndngSdttm;
    }

    public String getSndngEdttm() {
        return sndngEdttm;
    }

    public void setSndngEdttm(String sndngEdttm) {
        this.sndngEdttm = sndngEdttm;
    }

    public String getOwnSndngYn() {
        return ownSndngYn;
    }

    public void setOwnSndngYn(String ownSndngYn) {
        this.ownSndngYn = ownSndngYn;
    }

    public String getListType() {
        return listType;
    }

    public void setListType(String listType) {
        this.listType = listType;
    }

    public String getEfctvSndngDttm() {
        return efctvSndngDttm;
    }

    public void setEfctvSndngDttm(String efctvSndngDttm) {
        this.efctvSndngDttm = efctvSndngDttm;
    }

    public int getRnum() {
        return rnum;
    }

    public void setRnum(int rnum) {
        this.rnum = rnum;
    }

    public String getOrgnm() {
        return orgnm;
    }

    public void setOrgnm(String orgnm) {
        this.orgnm = orgnm;
    }

    public String getDeptnm() {
        return deptnm;
    }

    public void setDeptnm(String deptnm) {
        this.deptnm = deptnm;
    }

    public String getSbjctnm() {
        return sbjctnm;
    }

    public void setSbjctnm(String sbjctnm) {
        this.sbjctnm = sbjctnm;
    }

    public String getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(String dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

    public String getReadYn() {
        return readYn;
    }

    public void setReadYn(String readYn) {
        this.readYn = readYn;
    }

    public int getRcvrCnt() {
        return rcvrCnt;
    }

    public void setRcvrCnt(int rcvrCnt) {
        this.rcvrCnt = rcvrCnt;
    }

    public String getRsrvYn() {
        return rsrvYn;
    }

    public void setRsrvYn(String rsrvYn) {
        this.rsrvYn = rsrvYn;
    }

    public String getSndngYn() {
        return sndngYn;
    }

    public void setSndngYn(String sndngYn) {
        this.sndngYn = sndngYn;
    }

    public int getSndngSuccCnt() {
        return sndngSuccCnt;
    }

    public void setSndngSuccCnt(int sndngSuccCnt) {
        this.sndngSuccCnt = sndngSuccCnt;
    }

    public int getFileCnt() {
        return fileCnt;
    }

    public void setFileCnt(int fileCnt) {
        this.fileCnt = fileCnt;
    }

    public String getRcvrListJson() {
        return rcvrListJson;
    }

    public void setRcvrListJson(String rcvrListJson) {
        this.rcvrListJson = rcvrListJson;
    }

    public String getSndngrPhnno() {
        return sndngrPhnno;
    }

    public void setSndngrPhnno(String sndngrPhnno) {
        this.sndngrPhnno = sndngrPhnno;
    }

    public String getAdminYn() {
        return adminYn;
    }

    public void setAdminYn(String adminYn) {
        this.adminYn = adminYn;
    }

    public String getUserTycd() {
        return userTycd;
    }

    public void setUserTycd(String userTycd) {
        this.userTycd = userTycd;
    }

    public String getStdntNo() {
        return stdntNo;
    }

    public void setStdntNo(String stdntNo) {
        this.stdntNo = stdntNo;
    }

    public String getUsernm() {
        return usernm;
    }

    public void setUsernm(String usernm) {
        this.usernm = usernm;
    }

    public String getMblPhn() {
        return mblPhn;
    }

    public void setMblPhn(String mblPhn) {
        this.mblPhn = mblPhn;
    }

    public String getEml() {
        return eml;
    }

    public void setEml(String eml) {
        this.eml = eml;
    }

    public String getUserRprsId2() {
        return userRprsId2;
    }

    public void setUserRprsId2(String userRprsId2) {
        this.userRprsId2 = userRprsId2;
    }

    public List<String> getUserIdList() {
        return userIdList;
    }

    public void setUserIdList(List<String> userIdList) {
        this.userIdList = userIdList;
    }

    public List<AtflVO> getAtflList() {
        return atflList;
    }

    public void setAtflList(List<AtflVO> atflList) {
        this.atflList = atflList;
    }
}
