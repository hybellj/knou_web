package knou.lms.sbjctinfo.vo;

import knou.lms.common.vo.DefaultVO;

public class SbjctInfoVO extends DefaultVO {

    private static final long serialVersionUID = 3028160159638360586L;
    private String crsCreCd;        // 개설과목아이디
    private String orgNm;           // 기관명

    private String creYear;         // 년도
    private String creTerm;         // 학기
    private String sbjctCd;         // 과목코드
    private String sbjctTycd;       // 과목분류코드
    private String lctrGbncd;       // 강의구분코드
    private String useYn;           // 사용여부
    private String sbjctExpln;      // 과목설명

    private String lowFileId;       // 저화질파일아이디
    private String lowFileNm;       // 저화질파일명
    private String lowFileSize;     // 저화질파일크기

    private String highFileId;      // 고화질파일아이디
    private String highFileNm;      // 고화질파일명
    private String highFileSize;    // 고화질파일크기

    private Integer playMin;        // 재생시간_분
    private Integer playSec;        // 재생시간_초
    private Integer totalPlaySec;   // 총재생시간_초

    private String dvclasNo;      // 분반번호
    private String dvclasNcknm;   // 분반별칭

    public String getCrsCreCd() { return crsCreCd; }
    public void setCrsCreCd(String crsCreCd) { this.crsCreCd = crsCreCd; }

    public String getOrgNm() { return orgNm; }
    public void setOrgNm(String orgNm) { this.orgNm = orgNm; }

    public String getCreYear() { return creYear; }
    public void setCreYear(String creYear) { this.creYear = creYear; }

    public String getCreTerm() { return creTerm; }
    public void setCreTerm(String creTerm) { this.creTerm = creTerm; }

    public String getSbjctCd() { return sbjctCd; }
    public void setSbjctCd(String sbjctCd) { this.sbjctCd = sbjctCd; }

    public String getSbjctTycd() { return sbjctTycd; }
    public void setSbjctTycd(String sbjctTycd) { this.sbjctTycd = sbjctTycd; }

    public String getLctrGbncd() { return lctrGbncd; }
    public void setLctrGbncd(String lctrGbncd) { this.lctrGbncd = lctrGbncd; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }

    public String getSbjctExpln() { return sbjctExpln; }
    public void setSbjctExpln(String sbjctExpln) { this.sbjctExpln = sbjctExpln; }

    public String getLowFileId() { return lowFileId; }
    public void setLowFileId(String lowFileId) { this.lowFileId = lowFileId; }

    public String getLowFileNm() { return lowFileNm; }
    public void setLowFileNm(String lowFileNm) { this.lowFileNm = lowFileNm; }

    public String getLowFileSize() { return lowFileSize; }
    public void setLowFileSize(String lowFileSize) { this.lowFileSize = lowFileSize; }

    public String getHighFileId() { return highFileId; }
    public void setHighFileId(String highFileId) { this.highFileId = highFileId; }

    public String getHighFileNm() { return highFileNm; }
    public void setHighFileNm(String highFileNm) { this.highFileNm = highFileNm; }

    public String getHighFileSize() { return highFileSize; }
    public void setHighFileSize(String highFileSize) { this.highFileSize = highFileSize; }

    public Integer getPlayMin() { return playMin; }
    public void setPlayMin(Integer playMin) { this.playMin = playMin; }

    public Integer getPlaySec() { return playSec; }
    public void setPlaySec(Integer playSec) { this.playSec = playSec; }

    public Integer getTotalPlaySec() { return totalPlaySec; }
    public void setTotalPlaySec(Integer totalPlaySec) { this.totalPlaySec = totalPlaySec; }

    public String getDvclasNo() { return dvclasNo; }
    public void setDvclasNo(String dvclasNo) { this.dvclasNo = dvclasNo; }

    public String getDvclasNcknm() { return dvclasNcknm; }
    public void setDvclasNcknm(String dvclasNcknm) { this.dvclasNcknm = dvclasNcknm; }
}
