package knou.lms.contents.vo;

import java.util.ArrayList;
import java.util.List;

import knou.lms.common.vo.DefaultVO;
import knou.lms.file.vo.AtflVO;

/**
 * 강의콘텐츠 정보를 담는다.
 */
public class LctrContsVO extends DefaultVO {

    private static final long serialVersionUID = 1L;

    private String lctrContsId; // 강의콘텐츠아이디
    private String lctrId; // 강의아이디
    private Integer contsSeqno; // 콘텐츠순번
    private Integer prevContsSeqno; // 변경전콘텐츠순번
    private String upLctrContsId; // 상위강의콘텐츠아이디
    private String contsFileId; // 콘텐츠파일아이디
    private String contsnm; // 콘텐츠명
    private String lctrContsTycd; // 강의콘텐츠유형코드
    private String contsUrl; // 콘텐츠URL
    private String contsPath; // 콘텐츠경로
    private String contsPstnCd; // 콘텐츠위치코드
    private String contsFileExt; // 콘텐츠파일확장자
    private Integer vdoMnts; // 동영상시간
    private String atndcRfltyn; // 출석반영여부
    private String oyn; // 공개여부
    private String exrcsQstnId; // 연습문제아이디
    private String rgtrId; // 등록자아이디
    private String regDttm; // 등록일시
    private String mdfrId; // 수정자아이디
    private String modDttm; // 수정일시
    private String sddnQstnId; // 돌발퀴즈아이디
    private Integer sddnQstnPlySec; // 돌발퀴즈재생시간
    private String langCd; // 언어코드
    private String htmlSrc; // HTML소스
    private String lrnTocTtl; // 학습목차제목
    private String lrnTocCts; // 학습목차내용
    private String admRegContsyn; // 관리자등록콘텐츠여부
    private String delyn; // 삭제여부
    private String vdoQltyGbncd; // 동영상화질구분코드

    /* DB와 관계없는 파라미터 */
    private String mode; // 화면모드
    private String orgId; // 기관아이디
    private String sbjctId; // 과목아이디
    private String sbjctYr; // 과목년도
    private String sbjctSmstr; // 과목학기
    private String sbjctnm; // 과목명
    private String lctrWknoSchdlId; // 강의주차일정아이디
    private Integer lctrWkno; // 강의주차
    private String lctrWknonm; // 강의주차명
    private String lctrWknoSymd; // 강의주차시작일자
    private String lctrWknoEymd; // 강의주차종료일자
    private String searchValue; // 검색어
    private String uploadPath; // 업로드경로
    private String rgtrNm; // 등록자명
    private String mdfrNm; // 수정자명
    private String sdVideoContsId; // 저화질동영상콘텐츠아이디
    private String sdVideoFileId; // 저화질동영상파일아이디
    private String sdVideoUploadFiles; // 저화질동영상업로드파일
    private String sdVideoUploadPath; // 저화질동영상업로드경로
    private String sdVideoDelFileIdStr; // 저화질동영상삭제파일아이디
    private String hdVideoContsId; // 고화질동영상콘텐츠아이디
    private String hdVideoFileId; // 고화질동영상파일아이디
    private String hdVideoUploadFiles; // 고화질동영상업로드파일
    private String hdVideoUploadPath; // 고화질동영상업로드경로
    private String hdVideoDelFileIdStr; // 고화질동영상삭제파일아이디
    private String srtContsId; // 자막콘텐츠아이디
    private String srtFileId; // 자막파일아이디
    private String srtUploadFiles; // 자막업로드파일
    private String srtUploadPath; // 자막업로드경로
    private String srtDelFileIdStr; // 자막삭제파일아이디
    private String exrcsQstnTtl; // 연습문제제목
    private List<AtflVO> sdVideoFileList = new ArrayList<AtflVO>(); // 저화질동영상파일목록
    private List<AtflVO> hdVideoFileList = new ArrayList<AtflVO>(); // 고화질동영상파일목록
    private List<AtflVO> srtFileList = new ArrayList<AtflVO>(); // 자막파일목록
    private List<LctrContsVO> srtContsList = new ArrayList<LctrContsVO>(); // 자막콘텐츠목록
    private List<LctrContsVO> childContsList = new ArrayList<LctrContsVO>(); // 하위콘텐츠목록
    private List<LctrContsDvclasSelVO> dvclasSelList = new ArrayList<LctrContsDvclasSelVO>(); // 분반선택목록

    public String getLctrContsId() {
        return lctrContsId;
    }

    public void setLctrContsId(String lctrContsId) {
        this.lctrContsId = lctrContsId;
    }

    public String getLctrId() {
        return lctrId;
    }

    public void setLctrId(String lctrId) {
        this.lctrId = lctrId;
    }

    public Integer getContsSeqno() {
        return contsSeqno;
    }

    public void setContsSeqno(Integer contsSeqno) {
        this.contsSeqno = contsSeqno;
    }

    public Integer getPrevContsSeqno() {
        return prevContsSeqno;
    }

    public void setPrevContsSeqno(Integer prevContsSeqno) {
        this.prevContsSeqno = prevContsSeqno;
    }

    public String getUpLctrContsId() {
        return upLctrContsId;
    }

    public void setUpLctrContsId(String upLctrContsId) {
        this.upLctrContsId = upLctrContsId;
    }

    public String getContsFileId() {
        return contsFileId;
    }

    public void setContsFileId(String contsFileId) {
        this.contsFileId = contsFileId;
    }

    public String getContsnm() {
        return contsnm;
    }

    public void setContsnm(String contsnm) {
        this.contsnm = contsnm;
    }

    public String getLctrContsTycd() {
        return lctrContsTycd;
    }

    public void setLctrContsTycd(String lctrContsTycd) {
        this.lctrContsTycd = lctrContsTycd;
    }

    public String getContsUrl() {
        return contsUrl;
    }

    public void setContsUrl(String contsUrl) {
        this.contsUrl = contsUrl;
    }

    public String getContsPath() {
        return contsPath;
    }

    public void setContsPath(String contsPath) {
        this.contsPath = contsPath;
    }

    public String getContsPstnCd() {
        return contsPstnCd;
    }

    public void setContsPstnCd(String contsPstnCd) {
        this.contsPstnCd = contsPstnCd;
    }

    public String getContsFileExt() {
        return contsFileExt;
    }

    public void setContsFileExt(String contsFileExt) {
        this.contsFileExt = contsFileExt;
    }

    public Integer getVdoMnts() {
        return vdoMnts;
    }

    public void setVdoMnts(Integer vdoMnts) {
        this.vdoMnts = vdoMnts;
    }

    public String getAtndcRfltyn() {
        return atndcRfltyn;
    }

    public void setAtndcRfltyn(String atndcRfltyn) {
        this.atndcRfltyn = atndcRfltyn;
    }

    public String getOyn() {
        return oyn;
    }

    public void setOyn(String oyn) {
        this.oyn = oyn;
    }

    public String getExrcsQstnId() {
        return exrcsQstnId;
    }

    public void setExrcsQstnId(String exrcsQstnId) {
        this.exrcsQstnId = exrcsQstnId;
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

    public String getSddnQstnId() {
        return sddnQstnId;
    }

    public void setSddnQstnId(String sddnQstnId) {
        this.sddnQstnId = sddnQstnId;
    }

    public Integer getSddnQstnPlySec() {
        return sddnQstnPlySec;
    }

    public void setSddnQstnPlySec(Integer sddnQstnPlySec) {
        this.sddnQstnPlySec = sddnQstnPlySec;
    }

    public String getLangCd() {
        return langCd;
    }

    public void setLangCd(String langCd) {
        this.langCd = langCd;
    }

    public String getSnsHtmlSrc() {
        return htmlSrc;
    }

    public void setSnsHtmlSrc(String snsHtmlSrc) {
        this.htmlSrc = snsHtmlSrc;
    }

    public String getHtmlSrc() {
        return htmlSrc;
    }

    public void setHtmlSrc(String htmlSrc) {
        this.htmlSrc = htmlSrc;
    }

    public String getLrnTocTtl() {
        return lrnTocTtl;
    }

    public void setLrnTocTtl(String lrnTocTtl) {
        this.lrnTocTtl = lrnTocTtl;
    }

    public String getLrnTocCts() {
        return lrnTocCts;
    }

    public void setLrnTocCts(String lrnTocCts) {
        this.lrnTocCts = lrnTocCts;
    }

    public String getAdmRegContsyn() {
        return admRegContsyn;
    }

    public void setAdmRegContsyn(String admRegContsyn) {
        this.admRegContsyn = admRegContsyn;
    }

    public String getDelyn() {
        return delyn;
    }

    public void setDelyn(String delyn) {
        this.delyn = delyn;
    }

    public String getVdoQltyGbncd() {
        return vdoQltyGbncd;
    }

    public void setVdoQltyGbncd(String vdoQltyGbncd) {
        this.vdoQltyGbncd = vdoQltyGbncd;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getSbjctId() {
        return sbjctId;
    }

    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
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

    public String getSbjctnm() {
        return sbjctnm;
    }

    public void setSbjctnm(String sbjctnm) {
        this.sbjctnm = sbjctnm;
    }

    public String getLctrWknoSchdlId() {
        return lctrWknoSchdlId;
    }

    public void setLctrWknoSchdlId(String lctrWknoSchdlId) {
        this.lctrWknoSchdlId = lctrWknoSchdlId;
    }

    public Integer getLctrWkno() {
        return lctrWkno;
    }

    public void setLctrWkno(Integer lctrWkno) {
        this.lctrWkno = lctrWkno;
    }

    public String getLctrWknonm() {
        return lctrWknonm;
    }

    public void setLctrWknonm(String lctrWknonm) {
        this.lctrWknonm = lctrWknonm;
    }

    public String getLctrWknoSymd() {
        return lctrWknoSymd;
    }

    public void setLctrWknoSymd(String lctrWknoSymd) {
        this.lctrWknoSymd = lctrWknoSymd;
    }

    public String getLctrWknoEymd() {
        return lctrWknoEymd;
    }

    public void setLctrWknoEymd(String lctrWknoEymd) {
        this.lctrWknoEymd = lctrWknoEymd;
    }

    public String getSearchValue() {
        return searchValue;
    }

    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }

    public String getUploadPath() {
        return uploadPath;
    }

    public void setUploadPath(String uploadPath) {
        this.uploadPath = uploadPath;
    }

    public String getRgtrNm() {
        return rgtrNm;
    }

    public void setRgtrNm(String rgtrNm) {
        this.rgtrNm = rgtrNm;
    }

    public String getMdfrNm() {
        return mdfrNm;
    }

    public void setMdfrNm(String mdfrNm) {
        this.mdfrNm = mdfrNm;
    }

    public String getSdVideoContsId() {
        return sdVideoContsId;
    }

    public void setSdVideoContsId(String sdVideoContsId) {
        this.sdVideoContsId = sdVideoContsId;
    }

    public String getSdVideoFileId() {
        return sdVideoFileId;
    }

    public void setSdVideoFileId(String sdVideoFileId) {
        this.sdVideoFileId = sdVideoFileId;
    }

    public String getSdVideoUploadFiles() {
        return sdVideoUploadFiles;
    }

    public void setSdVideoUploadFiles(String sdVideoUploadFiles) {
        this.sdVideoUploadFiles = sdVideoUploadFiles;
    }

    public String getSdVideoUploadPath() {
        return sdVideoUploadPath;
    }

    public void setSdVideoUploadPath(String sdVideoUploadPath) {
        this.sdVideoUploadPath = sdVideoUploadPath;
    }

    public String getSdVideoDelFileIdStr() {
        return sdVideoDelFileIdStr;
    }

    public void setSdVideoDelFileIdStr(String sdVideoDelFileIdStr) {
        this.sdVideoDelFileIdStr = sdVideoDelFileIdStr;
    }

    public String getHdVideoContsId() {
        return hdVideoContsId;
    }

    public void setHdVideoContsId(String hdVideoContsId) {
        this.hdVideoContsId = hdVideoContsId;
    }

    public String getHdVideoFileId() {
        return hdVideoFileId;
    }

    public void setHdVideoFileId(String hdVideoFileId) {
        this.hdVideoFileId = hdVideoFileId;
    }

    public String getHdVideoUploadFiles() {
        return hdVideoUploadFiles;
    }

    public void setHdVideoUploadFiles(String hdVideoUploadFiles) {
        this.hdVideoUploadFiles = hdVideoUploadFiles;
    }

    public String getHdVideoUploadPath() {
        return hdVideoUploadPath;
    }

    public void setHdVideoUploadPath(String hdVideoUploadPath) {
        this.hdVideoUploadPath = hdVideoUploadPath;
    }

    public String getHdVideoDelFileIdStr() {
        return hdVideoDelFileIdStr;
    }

    public void setHdVideoDelFileIdStr(String hdVideoDelFileIdStr) {
        this.hdVideoDelFileIdStr = hdVideoDelFileIdStr;
    }

    public String getSrtContsId() {
        return srtContsId;
    }

    public void setSrtContsId(String srtContsId) {
        this.srtContsId = srtContsId;
    }

    public String getSrtFileId() {
        return srtFileId;
    }

    public void setSrtFileId(String srtFileId) {
        this.srtFileId = srtFileId;
    }

    public String getSrtUploadFiles() {
        return srtUploadFiles;
    }

    public void setSrtUploadFiles(String srtUploadFiles) {
        this.srtUploadFiles = srtUploadFiles;
    }

    public String getSrtUploadPath() {
        return srtUploadPath;
    }

    public void setSrtUploadPath(String srtUploadPath) {
        this.srtUploadPath = srtUploadPath;
    }

    public String getSrtDelFileIdStr() {
        return srtDelFileIdStr;
    }

    public void setSrtDelFileIdStr(String srtDelFileIdStr) {
        this.srtDelFileIdStr = srtDelFileIdStr;
    }

    public String getExrcsQstnTtl() {
        return exrcsQstnTtl;
    }

    public void setExrcsQstnTtl(String exrcsQstnTtl) {
        this.exrcsQstnTtl = exrcsQstnTtl;
    }

    public List<AtflVO> getSdVideoFileList() {
        return sdVideoFileList;
    }

    public void setSdVideoFileList(List<AtflVO> sdVideoFileList) {
        this.sdVideoFileList = sdVideoFileList;
    }

    public List<AtflVO> getHdVideoFileList() {
        return hdVideoFileList;
    }

    public void setHdVideoFileList(List<AtflVO> hdVideoFileList) {
        this.hdVideoFileList = hdVideoFileList;
    }

    public List<AtflVO> getSrtFileList() {
        return srtFileList;
    }

    public void setSrtFileList(List<AtflVO> srtFileList) {
        this.srtFileList = srtFileList;
    }

    public List<LctrContsVO> getSrtContsList() {
        return srtContsList;
    }

    public void setSrtContsList(List<LctrContsVO> srtContsList) {
        this.srtContsList = srtContsList;
    }

    public List<LctrContsVO> getChildContsList() {
        return childContsList;
    }

    public void setChildContsList(List<LctrContsVO> childContsList) {
        this.childContsList = childContsList;
    }

    public List<LctrContsDvclasSelVO> getDvclasSelList() {
        return dvclasSelList;
    }

    public void setDvclasSelList(List<LctrContsDvclasSelVO> dvclasSelList) {
        this.dvclasSelList = dvclasSelList;
    }
}
