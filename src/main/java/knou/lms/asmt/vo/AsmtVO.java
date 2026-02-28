package knou.lms.asmt.vo;

import knou.lms.common.vo.DefaultVO;

import java.util.Base64;

public class AsmtVO extends DefaultVO {

    private static final long serialVersionUID = 7862736751085217603L;

    private String selectType; //조회유형 (OBJECT, LIST, PAGING)
    private String sortType; //조회정렬유형 (NO, DT)
    private String searchKey2;
    private String searchKey3;

    private String targetCnt; //대상자수
    private String submitCnt; //제출수
    private String noCnt; //미제출수
    private String evalCnt; //평가수
    private String evalScore; //평가점수
    private String avgScore; //평균점수
    private String maxScore; //최고점수
    private String minScore; //최소점수

    /**
     * KNOU ERD에 맞게 변환
     */
    private String grpcd; //그룹코드
    private String asmtId; //과제아이디(PK)
    private String newAsmtId;
    private String prevAsmtId;

    private String asmtGbncd; //과제구분코드
    private String asmtGbnnm;   //과제구분명
    private String asmtTtl; //과제제목
    private String asmtCts; //과제내용
    private String sbasmtTycd; //제출과제유형코드
    private String rublicId;           // 루브릭아이디
    private String delyn; //삭제 여부

    private String sbjctNm;                //과목명
    private String dgrsSmstrChrt;          //학기기수차트
    private String smstrChrtId; //학기기수아이디


    private String asmtSbmsnSdttm;         //과제제출시작일시
    private String asmtSbmsnEdttm;         //과제제출종료일시

    private String asmtPrctcyn;            //실습여부
    private String sbmsnFileMimeTycd;      //제출파일마임유형코드

    private String asmtOyn;                //과제공개여부
    private String extdSbmsnPrmyn;         //연장제출허용여부
    private String extdSbmsnSdttm;         //연장제출시작일시
    private String extdSbmsnEdttm;         //연장제출종료일시

    private String teamAsmtStngyn;         //팀과제설정여부
    private String lrnGrpId;               //학습그룹아이디
    private String lrnGrpNm;               //학습그룹명
    private String asmtGrpId;              //과제그룹아이디
    private String asmtGrpnm;              //과제그룹명


    private String tmbrSbmsnPrmyn;          //팀원제출허용여부

    private String mrkRfltyn;              //성적반영여부
    private String mrkRfltrt;             //성적반영비율
    private String mrkOyn;                 //성적공개여부

    private String mrkInqSdttm;            //성적조회시작일시
    private String mrkInqEdttm;            //성적조회종료일시

    private String evlUseyn;               // 평가사용여부
    private String evlScrTycd;              //평가점수유형코드
    private String evlRsltOyn;              //평가결과공개여부
    private String avgScrOyn;               //평균점수공개여부

    private String pushAlimyn;              //푸시알림여부

    private String sbasmtOstdOyn;           //제출과제외부공개여부
    private String sbasmtOstdOpenSdttm;     //제출과제외부공개시작일시
    private String sbasmtOstdOpenEdttm;     //제출과제외부공개종료일시

    private String indvAsmtyn;              //개별과제여부

    private String resbmsnSdttm;            //재제출시작일시
    private String resbmsnEdttm;            //재제출종료일시
    private Integer resbmsnMrkRfltrt;       //재제출성적반영비율

    private String lctrWknoSchdlId;         //강의주차일정아이디
    private String lctrWknonm;              //강의주차명

    private String examInsYn;               //시험존재여부
    private String examStareTypeCd;         //시험응시방식코드
    private String parExamBscId;
    private String parExamEndDttm;

    private String evlRfltyn; //평가사용여부
    private String evlSdttm; //평가시작일시
    private String evlEdttm; //평가종료일시
    //    private String evalCritUseYn; //평가기준사용여부
    private String avgScrOpenyn; //평균점수공개여부
    private String dvclasCncrntRegyn; //분반 등록 여부
    private String dvclasList; //분반 목록
    private String dvclasNo; //분반 번호
    private String exlnAsmtDwldyn; //우수과제다운로드여부

    // 과제 제출 테이블 TB_LMS_ASMT_SBMSN
    private String asmtSbmsnId;   // 과제제출아이디
    private String teamId;        // 팀아이디
    private String sbmsnDttm;     // 제출일시
    private String sbmsnTycd;     // 제출유형코드
    private String sbmsnCts;      // 제출내용
    private String sbmsnTxt;      // 제출텍스트
    private String sbmsnStscd;    // 제출상태코드
    private Integer sbmsnCnt;     // 제출수
    private String resbmsnyn;     // 재제출여부
    private String sendEndDttm; //과제 종료 일시

    private String teamnm;
    private String sbmsnStscdnm; //과제제출상태명

    // 과제 평가 테이블 TB_LMS_ASMT_EVL
    private String asmtEvlId;              // 과제평가아이디
    private String scr;                   // 점수
    private Integer rublicCnvSnScr;         // 루브릭환산점수
    private String scrMemo;                // 점수메모
    private String evlGrdcd;               // 평가등급코드

    private String evlyn;                  // 평가여부
    private Integer evlWgvlrt;           // 평가가중치비율
    private String exlnAsmtyn;              // 우수과제여부
    private String mosaCmpDttm;             // MOSA완료일시
    private Integer maxMosart;           // 최대MOSA비율
    private String maxMosaId;               // 최대MOSA아이디
    private String cmrclDataFileId;         // 상용데이터파일아이디
    private Integer cmrclDataMosart;     // 상용데이터MOSA비율
    private String rgtrId;                  // 등록자아이디
    private String regDttm;                 // 등록일시
    private String mdfrId;                  // 수정자아이디
    private String modDttm;                 // 수정일시

    //    private String memberRole; //수강생 역할
//    private String leaderYn; //팀장여부
//    private String fileRgtrId;
//    private String fileRegDttm;
//    private String hstyCd;
//    private String sbmtFileInfo;
//    private String crsCd; //과정 코드
//    private String creTerm; //개설 기수
//    private String declsNo; //분반 번호3


    //    private String scoreType; //점수유형
    private String lrnGrpList; //팀그룹 리스트
    private String[] asmntArray; //과제 고유번호
    private String[] sbjctArray; //과목개설
    private String[] mrkRfltrtArray; // 성적반영비율
    private String[] dvclsListArray; //분반목록
    private String indvAsmtList;


    // 과제피드백 테이블 TB_LMS_ASMT_FDBK
    private String asmntFdbkId; //과제피드백아이디
    private String asmntSbmsnId; //과제제출아이디
    private String upAsmntFdbkId; //상위과제피드백아이디
    private String fdbkTrgtUnitTycd; //피드백대상단위유형코드
    private String fdbkCts; //피드백내용
    private String fdbkTycd; //피드백유형코드
    private String pushNotiYn; //푸시알림여부

    // 과제 댓글 테이블 TB_LMS_ASMT_CMNT
    private String asmntCmntId; //과제댓글아이디
    private String upAsmntCmntId; //상위과제댓글아이디
    private String asmntCmntCts; //과제댓글내용

    // 과제제출대상 테이블 TB_LMS_ASMT_TRGT
    private String asmtSbmsnTrgtId; //과제제출대상아이디


    // 수강대상 리스트용
    private String atndlcId; //수강아이디

    //====================================================================

    // 실기과제 리스트용
    private String phtFile;
    private byte[] phtFileByte; // 사용자 프로필 사진
    private String fileNm;
    private String filePath;
    private String fileExt;
    private String thumbPath;

    private String submitDttm;
    private String lateDttm;
    private String lateDttmFmt;
    private String reDttm;
    private String reDttmFmt;
    private String ezgUserId;

    // 과제 댓글 테이블 tb_lms_asmnt_cmnt
//    private Integer cmntLen;
//    private Integer cmntLvl;
//    private String parRegNm;
//    private int fileCnt;

    // 과제 제출기한 여부
    private String sbmsnPrdyn; // 제출기간 여부
    private String extdSbmsnPrdyn; // 연장제출 기간 여부
    private String resbmsnPrdyn; // 재제출 기간 여부

    private String copyAsmtId; // 과제 복사
    private String newSbjctId;

    // AS-IS 과제평가와 섞인 것 같음. 일단 살려두기
    // 과제 상호평가 연결 테이블 tb_lms_asmnt_mut_eval_rslt
    private String mutEvalCd;
    private String rltnCd;
    private String evalDttm;
    private String qstnCd;
    private String gradeCd;


    private String lessonScheduleNm;
//    private String konanMaxCopyRate;
//    private String grscDegrCorsGbn;
//    private String grscDegrCorsGbnNm;


    public String getEvalCnt() {
        return evalCnt;
    }

    public void setEvalCnt(String evalCnt) {
        this.evalCnt = evalCnt;
    }

    public String getSelectType() {
        return selectType;
    }

    public void setSelectType(String selectType) {
        this.selectType = selectType;
    }

    public String getSortType() {
        return sortType;
    }

    public void setSortType(String sortType) {
        this.sortType = sortType;
    }

    public String getSearchKey2() {
        return searchKey2;
    }

    public void setSearchKey2(String searchKey2) {
        this.searchKey2 = searchKey2;
    }

    public String getSearchKey3() {
        return searchKey3;
    }

    public void setSearchKey3(String searchKey3) {
        this.searchKey3 = searchKey3;
    }

    public String getTargetCnt() {
        return targetCnt;
    }

    public void setTargetCnt(String targetCnt) {
        this.targetCnt = targetCnt;
    }

    public String getSubmitCnt() {
        return submitCnt;
    }

    public void setSubmitCnt(String submitCnt) {
        this.submitCnt = submitCnt;
    }

    public String getNoCnt() {
        return noCnt;
    }

    public void setNoCnt(String noCnt) {
        this.noCnt = noCnt;
    }

    public String getEvalScore() {
        return evalScore;
    }

    public void setEvalScore(String evalScore) {
        this.evalScore = evalScore;
    }

    public String getAvgScore() {
        return avgScore;
    }

    public void setAvgScore(String avgScore) {
        this.avgScore = avgScore;
    }

    public String getMaxScore() {
        return maxScore;
    }

    public void setMaxScore(String maxScore) {
        this.maxScore = maxScore;
    }

    public String getMinScore() {
        return minScore;
    }

    public void setMinScore(String minScore) {
        this.minScore = minScore;
    }

    public String getGrpcd() {
        return grpcd;
    }

    public void setGrpcd(String grpcd) {
        this.grpcd = grpcd;
    }

    public String getAsmtGbncd() {
        return asmtGbncd;
    }

    public void setAsmtGbncd(String asmtGbncd) {
        this.asmtGbncd = asmtGbncd;
    }

    public String getLessonScheduleNm() {
        return lessonScheduleNm;
    }

    public void setLessonScheduleNm(String lessonScheduleNm) {
        this.lessonScheduleNm = lessonScheduleNm;
    }

    public String getAsmtGbnnm() {
        return asmtGbnnm;
    }

    public void setAsmtGbnnm(String asmtGbnnm) {
        this.asmtGbnnm = asmtGbnnm;
    }

    public String getAsmtTtl() {
        return asmtTtl;
    }

    public void setAsmtTtl(String asmtTtl) {
        this.asmtTtl = asmtTtl;
    }

    public String getAsmtCts() {
        return asmtCts;
    }

    public void setAsmtCts(String asmtCts) {
        this.asmtCts = asmtCts;
    }

    public String getSbasmtTycd() {
        return sbasmtTycd;
    }

    public void setSbasmtTycd(String sbasmtTycd) {
        this.sbasmtTycd = sbasmtTycd;
    }

    public String getRublicId() {
        return rublicId;
    }

    public void setRublicId(String rublicId) {
        this.rublicId = rublicId;
    }

    public String getDelyn() {
        return delyn;
    }

    public void setDelyn(String delyn) {
        this.delyn = delyn;
    }

    public String getAsmtId() {
        return asmtId;
    }

    public void setAsmtId(String asmtId) {
        this.asmtId = asmtId;
    }

    public String getNewAsmtId() {
        return newAsmtId;
    }

    public void setNewAsmtId(String newAsmtId) {
        this.newAsmtId = newAsmtId;
    }

    public String getPrevAsmtId() {
        return prevAsmtId;
    }

    public void setPrevAsmtId(String prevAsmtId) {
        this.prevAsmtId = prevAsmtId;
    }

    public String getSbjctNm() {
        return sbjctNm;
    }

    public void setSbjctNm(String sbjctNm) {
        this.sbjctNm = sbjctNm;
    }

    public String getDgrsSmstrChrt() {
        return dgrsSmstrChrt;
    }

    public void setDgrsSmstrChrt(String dgrsSmstrChrt) {
        this.dgrsSmstrChrt = dgrsSmstrChrt;
    }

    public String getAsmtSbmsnSdttm() {
        return asmtSbmsnSdttm;
    }

    public void setAsmtSbmsnSdttm(String asmtSbmsnSdttm) {
        this.asmtSbmsnSdttm = asmtSbmsnSdttm;
    }

    public String getAsmtSbmsnEdttm() {
        return asmtSbmsnEdttm;
    }

    public void setAsmtSbmsnEdttm(String asmtSbmsnEdttm) {
        this.asmtSbmsnEdttm = asmtSbmsnEdttm;
    }

    public String getAsmtPrctcyn() {
        return asmtPrctcyn;
    }

    public void setAsmtPrctcyn(String asmtPrctcyn) {
        this.asmtPrctcyn = asmtPrctcyn;
    }

    public String getSbmsnFileMimeTycd() {
        return sbmsnFileMimeTycd;
    }

    public void setSbmsnFileMimeTycd(String sbmsnFileMimeTycd) {
        this.sbmsnFileMimeTycd = sbmsnFileMimeTycd;
    }

    public String getAsmtOyn() {
        return asmtOyn;
    }

    public void setAsmtOyn(String asmtOyn) {
        this.asmtOyn = asmtOyn;
    }

    public String getExtdSbmsnPrmyn() {
        return extdSbmsnPrmyn;
    }

    public void setExtdSbmsnPrmyn(String extdSbmsnPrmyn) {
        this.extdSbmsnPrmyn = extdSbmsnPrmyn;
    }

    public String getExtdSbmsnSdttm() {
        return extdSbmsnSdttm;
    }

    public void setExtdSbmsnSdttm(String extdSbmsnSdttm) {
        this.extdSbmsnSdttm = extdSbmsnSdttm;
    }

    public String getExtdSbmsnEdttm() {
        return extdSbmsnEdttm;
    }

    public void setExtdSbmsnEdttm(String extdSbmsnEdttm) {
        this.extdSbmsnEdttm = extdSbmsnEdttm;
    }

    public String getTeamAsmtStngyn() {
        return teamAsmtStngyn;
    }

    public void setTeamAsmtStngyn(String teamAsmtStngyn) {
        this.teamAsmtStngyn = teamAsmtStngyn;
    }

    public String getLrnGrpNm() {
        return lrnGrpNm;
    }

    public void setLrnGrpNm(String lrnGrpNm) {
        this.lrnGrpNm = lrnGrpNm;
    }

    public String getTmbrSbmsnPrmyn() {
        return tmbrSbmsnPrmyn;
    }

    public void setTmbrSbmsnPrmyn(String tmbrSbmsnPrmyn) {
        this.tmbrSbmsnPrmyn = tmbrSbmsnPrmyn;
    }

    public String getMrkRfltyn() {
        return mrkRfltyn;
    }

    public void setMrkRfltyn(String mrkRfltyn) {
        this.mrkRfltyn = mrkRfltyn;
    }

    public String getMrkRfltrt() {
        return mrkRfltrt;
    }

    public void setMrkRfltrt(String mrkRfltrt) {
        this.mrkRfltrt = mrkRfltrt;
    }

    public String getMrkOyn() {
        return mrkOyn;
    }

    public void setMrkOyn(String mrkOyn) {
        this.mrkOyn = mrkOyn;
    }

    public String getMrkInqSdttm() {
        return mrkInqSdttm;
    }

    public void setMrkInqSdttm(String mrkInqSdttm) {
        this.mrkInqSdttm = mrkInqSdttm;
    }

    public String getMrkInqEdttm() {
        return mrkInqEdttm;
    }

    public void setMrkInqEdttm(String mrkInqEdttm) {
        this.mrkInqEdttm = mrkInqEdttm;
    }

    public String getEvlScrTycd() {
        return evlScrTycd;
    }

    public void setEvlScrTycd(String evlScrTycd) {
        this.evlScrTycd = evlScrTycd;
    }

    public String getEvlRsltOyn() {
        return evlRsltOyn;
    }

    public void setEvlRsltOyn(String evlRsltOyn) {
        this.evlRsltOyn = evlRsltOyn;
    }

    public String getAvgScrOyn() {
        return avgScrOyn;
    }

    public void setAvgScrOyn(String avgScrOyn) {
        this.avgScrOyn = avgScrOyn;
    }

    public String getPushAlimyn() {
        return pushAlimyn;
    }

    public void setPushAlimyn(String pushAlimyn) {
        this.pushAlimyn = pushAlimyn;
    }

    public String getSbasmtOstdOyn() {
        return sbasmtOstdOyn;
    }

    public void setSbasmtOstdOyn(String sbasmtOstdOyn) {
        this.sbasmtOstdOyn = sbasmtOstdOyn;
    }

    public String getSbasmtOstdOpenSdttm() {
        return sbasmtOstdOpenSdttm;
    }

    public void setSbasmtOstdOpenSdttm(String sbasmtOstdOpenSdttm) {
        this.sbasmtOstdOpenSdttm = sbasmtOstdOpenSdttm;
    }

    public String getSbasmtOstdOpenEdttm() {
        return sbasmtOstdOpenEdttm;
    }

    public void setSbasmtOstdOpenEdttm(String sbasmtOstdOpenEdttm) {
        this.sbasmtOstdOpenEdttm = sbasmtOstdOpenEdttm;
    }

    public String getIndvAsmtyn() {
        return indvAsmtyn;
    }

    public void setIndvAsmtyn(String indvAsmtyn) {
        this.indvAsmtyn = indvAsmtyn;
    }

    public String getResbmsnSdttm() {
        return resbmsnSdttm;
    }

    public void setResbmsnSdttm(String resbmsnSdttm) {
        this.resbmsnSdttm = resbmsnSdttm;
    }

    public String getResbmsnEdttm() {
        return resbmsnEdttm;
    }

    public void setResbmsnEdttm(String resbmsnEdttm) {
        this.resbmsnEdttm = resbmsnEdttm;
    }

    public Integer getResbmsnMrkRfltrt() {
        return resbmsnMrkRfltrt;
    }

    public void setResbmsnMrkRfltrt(Integer resbmsnMrkRfltrt) {
        this.resbmsnMrkRfltrt = resbmsnMrkRfltrt;
    }

    public String getLctrWknonm() {
        return lctrWknonm;
    }

    public void setLctrWknonm(String lctrWknonm) {
        this.lctrWknonm = lctrWknonm;
    }

    public String getExamInsYn() {
        return examInsYn;
    }

    public void setExamInsYn(String examInsYn) {
        this.examInsYn = examInsYn;
    }

    public String getExamStareTypeCd() {
        return examStareTypeCd;
    }

    public void setExamStareTypeCd(String examStareTypeCd) {
        this.examStareTypeCd = examStareTypeCd;
    }

    public String getParExamBscId() {
        return parExamBscId;
    }

    public void setParExamBscId(String parExamBscId) {
        this.parExamBscId = parExamBscId;
    }

    public String getParExamEndDttm() {
        return parExamEndDttm;
    }

    public void setParExamEndDttm(String parExamEndDttm) {
        this.parExamEndDttm = parExamEndDttm;
    }

    public String getEvlRfltyn() {
        return evlRfltyn;
    }

    public void setEvlRfltyn(String evlRfltyn) {
        this.evlRfltyn = evlRfltyn;
    }

    public String getEvlSdttm() {
        return evlSdttm;
    }

    public void setEvlSdttm(String evlSdttm) {
        this.evlSdttm = evlSdttm;
    }

    public String getEvlEdttm() {
        return evlEdttm;
    }

    public void setEvlEdttm(String evlEdttm) {
        this.evlEdttm = evlEdttm;
    }

    public String getAvgScrOpenyn() {
        return avgScrOpenyn;
    }

    public void setAvgScrOpenyn(String avgScrOpenyn) {
        this.avgScrOpenyn = avgScrOpenyn;
    }

    public String getDvclasCncrntRegyn() {
        return dvclasCncrntRegyn;
    }

    public void setDvclasCncrntRegyn(String dvclasCncrntRegyn) {
        this.dvclasCncrntRegyn = dvclasCncrntRegyn;
    }

    public String getDvclasList() {
        return dvclasList;
    }

    public void setDvclasList(String dvclasList) {
        this.dvclasList = dvclasList;
    }

    public String getAsmtSbmsnId() {
        return asmtSbmsnId;
    }

    public void setAsmtSbmsnId(String asmtSbmsnId) {
        this.asmtSbmsnId = asmtSbmsnId;
    }

    public String getTeamId() {
        return teamId;
    }

    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }

    public String getSbmsnDttm() {
        return sbmsnDttm;
    }

    public void setSbmsnDttm(String sbmsnDttm) {
        this.sbmsnDttm = sbmsnDttm;
    }

    public String getSbmsnTycd() {
        return sbmsnTycd;
    }

    public void setSbmsnTycd(String sbmsnTycd) {
        this.sbmsnTycd = sbmsnTycd;
    }

    public String getSbmsnCts() {
        return sbmsnCts;
    }

    public void setSbmsnCts(String sbmsnCts) {
        this.sbmsnCts = sbmsnCts;
    }

    public String getSbmsnTxt() {
        return sbmsnTxt;
    }

    public void setSbmsnTxt(String sbmsnTxt) {
        this.sbmsnTxt = sbmsnTxt;
    }

    public String getSbmsnStscd() {
        return sbmsnStscd;
    }

    public void setSbmsnStscd(String sbmsnStscd) {
        this.sbmsnStscd = sbmsnStscd;
    }

    public Integer getSbmsnCnt() {
        return sbmsnCnt;
    }

    public void setSbmsnCnt(Integer sbmsnCnt) {
        this.sbmsnCnt = sbmsnCnt;
    }

    public String getResbmsnyn() {
        return resbmsnyn;
    }

    public void setResbmsnyn(String resbmsnyn) {
        this.resbmsnyn = resbmsnyn;
    }

    public String getSendEndDttm() {
        return sendEndDttm;
    }

    public void setSendEndDttm(String sendEndDttm) {
        this.sendEndDttm = sendEndDttm;
    }

    public String getLrnGrpId() {
        return lrnGrpId;
    }

    public void setLrnGrpId(String lrnGrpId) {
        this.lrnGrpId = lrnGrpId;
    }

    public String getTeamnm() {
        return teamnm;
    }

    public void setTeamnm(String teamnm) {
        this.teamnm = teamnm;
    }

    public String getSbmsnStscdnm() {
        return sbmsnStscdnm;
    }

    public void setSbmsnStscdnm(String sbmsnStscdnm) {
        this.sbmsnStscdnm = sbmsnStscdnm;
    }

    public String getAsmtEvlId() {
        return asmtEvlId;
    }

    public void setAsmtEvlId(String asmtEvlId) {
        this.asmtEvlId = asmtEvlId;
    }

    public String getScr() {
        return scr;
    }

    public void setScr(String scr) {
        this.scr = scr;
    }

    public Integer getRublicCnvSnScr() {
        return rublicCnvSnScr;
    }

    public void setRublicCnvSnScr(Integer rublicCnvSnScr) {
        this.rublicCnvSnScr = rublicCnvSnScr;
    }

    public String getScrMemo() {
        return scrMemo;
    }

    public void setScrMemo(String scrMemo) {
        this.scrMemo = scrMemo;
    }

    public String getEvlGrdcd() {
        return evlGrdcd;
    }

    public void setEvlGrdcd(String evlGrdcd) {
        this.evlGrdcd = evlGrdcd;
    }

    public String getEvlyn() {
        return evlyn;
    }

    public void setEvlyn(String evlyn) {
        this.evlyn = evlyn;
    }

    public Integer getEvlWgvlrt() {
        return evlWgvlrt;
    }

    public void setEvlWgvlrt(Integer evlWgvlrt) {
        this.evlWgvlrt = evlWgvlrt;
    }

    public String getExlnAsmtyn() {
        return exlnAsmtyn;
    }

    public void setExlnAsmtyn(String exlnAsmtyn) {
        this.exlnAsmtyn = exlnAsmtyn;
    }

    public String getMosaCmpDttm() {
        return mosaCmpDttm;
    }

    public void setMosaCmpDttm(String mosaCmpDttm) {
        this.mosaCmpDttm = mosaCmpDttm;
    }

    public Integer getMaxMosart() {
        return maxMosart;
    }

    public void setMaxMosart(Integer maxMosart) {
        this.maxMosart = maxMosart;
    }

    public String getMaxMosaId() {
        return maxMosaId;
    }

    public void setMaxMosaId(String maxMosaId) {
        this.maxMosaId = maxMosaId;
    }

    public String getCmrclDataFileId() {
        return cmrclDataFileId;
    }

    public void setCmrclDataFileId(String cmrclDataFileId) {
        this.cmrclDataFileId = cmrclDataFileId;
    }

    public Integer getCmrclDataMosart() {
        return cmrclDataMosart;
    }

    public void setCmrclDataMosart(Integer cmrclDataMosart) {
        this.cmrclDataMosart = cmrclDataMosart;
    }

    @Override
    public String getRgtrId() {
        return rgtrId;
    }

    @Override
    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    @Override
    public String getRegDttm() {
        return regDttm;
    }

    @Override
    public void setRegDttm(String regDttm) {
        this.regDttm = regDttm;
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

    @Override
    public void setModDttm(String modDttm) {
        this.modDttm = modDttm;
    }

    public String getLrnGrpList() {
        return lrnGrpList;
    }

    public void setLrnGrpList(String lrnGrpList) {
        this.lrnGrpList = lrnGrpList;
    }

    public String[] getAsmntArray() {
        return asmntArray;
    }

    public void setAsmntArray(String[] asmntArray) {
        this.asmntArray = asmntArray;
    }

    public String[] getSbjctArray() {
        return sbjctArray;
    }

    public void setSbjctArray(String[] sbjctArray) {
        this.sbjctArray = sbjctArray;
    }

    public String[] getMrkRfltrtArray() {
        return mrkRfltrtArray;
    }

    public void setMrkRfltrtArray(String[] mrkRfltrtArray) {
        this.mrkRfltrtArray = mrkRfltrtArray;
    }

    public String[] getDvclsListArray() {
        return dvclsListArray;
    }

    public void setDvclsListArray(String[] dvclsListArray) {
        this.dvclsListArray = dvclsListArray;
    }

    public String getIndvAsmtList() {
        return indvAsmtList;
    }

    public void setIndvAsmtList(String indvAsmtList) {
        this.indvAsmtList = indvAsmtList;
    }

    public String getAsmntFdbkId() {
        return asmntFdbkId;
    }

    public void setAsmntFdbkId(String asmntFdbkId) {
        this.asmntFdbkId = asmntFdbkId;
    }

    public String getAsmntSbmsnId() {
        return asmntSbmsnId;
    }

    public void setAsmntSbmsnId(String asmntSbmsnId) {
        this.asmntSbmsnId = asmntSbmsnId;
    }

    public String getUpAsmntFdbkId() {
        return upAsmntFdbkId;
    }

    public void setUpAsmntFdbkId(String upAsmntFdbkId) {
        this.upAsmntFdbkId = upAsmntFdbkId;
    }

    public String getFdbkTrgtUnitTycd() {
        return fdbkTrgtUnitTycd;
    }

    public void setFdbkTrgtUnitTycd(String fdbkTrgtUnitTycd) {
        this.fdbkTrgtUnitTycd = fdbkTrgtUnitTycd;
    }

    public String getFdbkCts() {
        return fdbkCts;
    }

    public void setFdbkCts(String fdbkCts) {
        this.fdbkCts = fdbkCts;
    }

    public String getFdbkTycd() {
        return fdbkTycd;
    }

    public void setFdbkTycd(String fdbkTycd) {
        this.fdbkTycd = fdbkTycd;
    }

    public String getPushNotiYn() {
        return pushNotiYn;
    }

    public void setPushNotiYn(String pushNotiYn) {
        this.pushNotiYn = pushNotiYn;
    }

    public String getAsmntCmntId() {
        return asmntCmntId;
    }

    public void setAsmntCmntId(String asmntCmntId) {
        this.asmntCmntId = asmntCmntId;
    }

    public String getUpAsmntCmntId() {
        return upAsmntCmntId;
    }

    public void setUpAsmntCmntId(String upAsmntCmntId) {
        this.upAsmntCmntId = upAsmntCmntId;
    }

    public String getAsmntCmntCts() {
        return asmntCmntCts;
    }

    public void setAsmntCmntCts(String asmntCmntCts) {
        this.asmntCmntCts = asmntCmntCts;
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

    public String getFileNm() {
        return fileNm;
    }

    public void setFileNm(String fileNm) {
        this.fileNm = fileNm;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFileExt() {
        return fileExt;
    }

    public void setFileExt(String fileExt) {
        this.fileExt = fileExt;
    }

    public String getThumbPath() {
        return thumbPath;
    }

    public void setThumbPath(String thumbPath) {
        this.thumbPath = thumbPath;
    }

    public String getSubmitDttm() {
        return submitDttm;
    }

    public void setSubmitDttm(String submitDttm) {
        this.submitDttm = submitDttm;
    }

    public String getLateDttm() {
        return lateDttm;
    }

    public void setLateDttm(String lateDttm) {
        this.lateDttm = lateDttm;
    }

    public String getLateDttmFmt() {
        return lateDttmFmt;
    }

    public void setLateDttmFmt(String lateDttmFmt) {
        this.lateDttmFmt = lateDttmFmt;
    }

    public String getReDttm() {
        return reDttm;
    }

    public void setReDttm(String reDttm) {
        this.reDttm = reDttm;
    }

    public String getReDttmFmt() {
        return reDttmFmt;
    }

    public void setReDttmFmt(String reDttmFmt) {
        this.reDttmFmt = reDttmFmt;
    }

    public String getPhtFile() {
        String phtFile = null;

        if(phtFileByte != null && phtFileByte.length > 0) {
            phtFile = "data:image/png;base64," + new String(Base64.getEncoder().encode(phtFileByte));
        }

        return phtFile;
    }

    public String getLctrWknoSchdlId() {
        return lctrWknoSchdlId;
    }

    public void setLctrWknoSchdlId(String lctrWknoSchdlId) {
        this.lctrWknoSchdlId = lctrWknoSchdlId;
    }

    public void setEzgUserId(String ezgUserId) {
        this.ezgUserId = ezgUserId;
    }

    public String getEzgUserId() {
        return ezgUserId;
    }

    public String getSbmsnPrdyn() {
        return sbmsnPrdyn;
    }

    public void setSbmsnPrdyn(String sbmsnPrdyn) {
        this.sbmsnPrdyn = sbmsnPrdyn;
    }

    public String getExtdSbmsnPrdyn() {
        return extdSbmsnPrdyn;
    }

    public void setExtdSbmsnPrdyn(String extdSbmsnPrdyn) {
        this.extdSbmsnPrdyn = extdSbmsnPrdyn;
    }

    public String getResbmsnPrdyn() {
        return resbmsnPrdyn;
    }

    public void setResbmsnPrdyn(String resbmsnPrdyn) {
        this.resbmsnPrdyn = resbmsnPrdyn;
    }

    public String getCopyAsmtId() {
        return copyAsmtId;
    }

    public void setCopyAsmtId(String copyAsmtId) {
        this.copyAsmtId = copyAsmtId;
    }

    public String getNewSbjctId() {
        return newSbjctId;
    }

    public void setNewSbjctId(String newSbjctId) {
        this.newSbjctId = newSbjctId;
    }

    public String getDvclasNo() {
        return dvclasNo;
    }

    public void setDvclasNo(String dvclasNo) {
        this.dvclasNo = dvclasNo;
    }

    public String getMutEvalCd() {
        return mutEvalCd;
    }

    public void setMutEvalCd(String mutEvalCd) {
        this.mutEvalCd = mutEvalCd;
    }

    public String getRltnCd() {
        return rltnCd;
    }

    public void setRltnCd(String rltnCd) {
        this.rltnCd = rltnCd;
    }

    public String getEvalDttm() {
        return evalDttm;
    }

    public void setEvalDttm(String evalDttm) {
        this.evalDttm = evalDttm;
    }

    public String getQstnCd() {
        return qstnCd;
    }

    public void setQstnCd(String qstnCd) {
        this.qstnCd = qstnCd;
    }

    public String getGradeCd() {
        return gradeCd;
    }

    public void setGradeCd(String gradeCd) {
        this.gradeCd = gradeCd;
    }

    public String getAsmtGrpId() {
        return asmtGrpId;
    }

    public void setAsmtGrpId(String asmtGrpId) {
        this.asmtGrpId = asmtGrpId;
    }

    public String getAsmtGrpnm() {
        return asmtGrpnm;
    }

    public void setAsmtGrpnm(String asmtGrpnm) {
        this.asmtGrpnm = asmtGrpnm;
    }

    public String getAsmtSbmsnTrgtId() {
        return asmtSbmsnTrgtId;
    }

    public void setAsmtSbmsnTrgtId(String asmtSbmsnTrgtId) {
        this.asmtSbmsnTrgtId = asmtSbmsnTrgtId;
    }


    public String getEvlUseyn() {
        return evlUseyn;
    }

    public void setEvlUseyn(String evlUseyn) {
        this.evlUseyn = evlUseyn;
    }

    public String getSmstrChrtId() {
        return smstrChrtId;
    }

    public void setSmstrChrtId(String smstrChrtId) {
        this.smstrChrtId = smstrChrtId;
    }

    public String getAtndlcId() {
        return atndlcId;
    }

    public void setAtndlcId(String atndlcId) {
        this.atndlcId = atndlcId;
    }

    public String getExlnAsmtDwldyn() {
        return exlnAsmtDwldyn;
    }

    public void setExlnAsmtDwldyn(String exlnAsmtDwldyn) {
        this.exlnAsmtDwldyn = exlnAsmtDwldyn;
    }
}
