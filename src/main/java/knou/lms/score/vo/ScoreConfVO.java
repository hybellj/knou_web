package knou.lms.score.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class ScoreConfVO extends DefaultVO {

    // tb_lms_score_grade_conf 성적환산등급
    private String orgId;
    private String scorCd;
    private String uniCd;
    private Float avgScor;
    private Float baseScor;
    private Float startScor;
    private Float endScor;
    private Integer scorOdr;
    private String useYn;
    private String rgtrId;
    private String regDttm;
    private String mdfrId;
    private String modDttm;
    
    private String scorCds;
    private String avgScors;
    private String baseScors;
    private String startScors;
    private String endScors;
    
    private String tabOrd;
    
    public String getOrgId() {
        return orgId;
    }
    public void setOrgId(String orgId) {
        this.orgId = orgId;
    }

    public String getScorCd() {
        return scorCd;
    }
    public void setScorCd(String scorCd) {
        this.scorCd = scorCd;
    }

    public Float getAvgScor() {
        return avgScor;
    }
    public void setAvgScor(Float avgScor) {
        this.avgScor = avgScor;
    }

    public Float getBaseScor() {
        return baseScor;
    }
    public void setBaseScor(Float baseScor) {
        this.baseScor = baseScor;
    }

    public Float getStartScor() {
        return startScor;
    }
    public void setStartScor(Float startScor) {
        this.startScor = startScor;
    }

    public Float getEndScor() {
        return endScor;
    }
    public void setEndScor(Float endScor) {
        this.endScor = endScor;
    }

    public Integer getScorOdr() {
        return scorOdr;
    }
    public void setScorOdr(Integer scorOdr) {
        this.scorOdr = scorOdr;
    }

    public String getUseYn() {
        return useYn;
    }
    public void setUseYn(String useYn) {
        this.useYn = useYn;
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

    // tb_lms_score_rel_conf 성적 상대평가비율 기준
    // private String orgId;
    private String scorRelCd;
    private String startScorCd;
    private String endScorCd;
    private Integer startRatio;
    private Integer endRatio;
    // private Integer scorOdr;
    // private String useYn;
    // private String rgtrId;
    // private String regDttm;
    // private String mdfrId;
    // private String modDttm;
    
    private String scorRelCds;
    private String endScorCds;
    private String startRatios;
    private String endRatios;

    public String getScorRelCd() {
        return scorRelCd;
    }
    public void setScorRelCd(String scorRelCd) {
        this.scorRelCd = scorRelCd;
    }

    public String getStartScorCd() {
        return startScorCd;
    }
    public void setStartScorCd(String startScorCd) {
        this.startScorCd = startScorCd;
    }

    public String getEndScorCd() {
        return endScorCd;
    }
    public void setEndScorCd(String endScorCd) {
        this.endScorCd = endScorCd;
    }

    public Integer getStartRatio() {
        return startRatio;
    }
    public void setStartRatio(Integer startRatio) {
        this.startRatio = startRatio;
    }

    public Integer getEndRatio() {
        return endRatio;
    }
    public void setEndRatio(Integer endRatio) {
        this.endRatio = endRatio;
    }

    // tb_lms_score_atnd_conf  
    
    // 출석점수 기준설정
    // private String orgId;
    private String confGbn;
    private String confCd;
    private String confNm;
    private String confVal;
    
    // 강의오픈 요일
    private String openWeekCd;
    private String openWeekNm;
    private String openWeekVal;

    // 강의오픈 시간
    private String openTmCd;
    private String openTmNm;
    private String openTmVal;

    // 강의 1주차 오픈 요일
    private String openWeek1ApCd;
    private String openWeek1ApNm;
    private String openWeek1ApVal;

    // 강의 1주차 오픈 시간
    private String openWeek1TmCd;
    private String openWeek1TmNm;
    private String openWeek1TmVal;

    //출석인정기간 주차 조회
    private String atendTermCd;
    private String atendTermNm;
    private String atendTermVal;

    // 출석인정기간 1주차 조회
    private String atendWeekCd;    
    private String atendWeekNm;
    private String atendWeekVal;

    // 출석비율
    private String atndRatioCd;       
    private String atndRatioNm;
    private String atndRatioVal;

    // 지각비율
    private String lateRatioCd; 
    private String lateRatioNm;
    private String lateRatioVal;

    // 결석비율
    private String absentRatioCd;
    private String absentRatioNm;
    private String absentRatioVal;

    // 출석주차
    private String senLesnWeekCd;
    private String senLesnWeekNm;
    private String senLesnWeekVal;
    
    // 출석비율
    private String senAtndRatioCd;
    private String senAtndRatioNm;
    private String senAtndRatioVal;
    
    // 결석비율
    private String senAbsentRatioCd;
    private String senAbsentRatioNm;
    private String senAbsentRatioVal;

    // 1주차강좌수
    private String senLesnWeek1Cd;
    private String senLesnWeek1Nm;
    private String senLesnWeek1Val;

    // 2주차강좌수
    private String senLesnWeek2Cd;
    private String senLesnWeek2Nm;
    private String senLesnWeek2Val;

    // 3주차강좌수
    private String senLesnWeek3Cd;
    private String senLesnWeek3Nm;
    private String senLesnWeek3Val;

    // 4주차강좌수
    private String senLesnWeek4Cd;
    private String senLesnWeek4Nm;
    private String senLesnWeek4Val;

    //  출석점수기준 강의 출석평가 정보
    private String absentScoreNm1;
    private String absentScoreNm2;
    private String absentScoreNm3;
    private String absentScoreNm4;
    private String absentScoreNm5;
    
    private String absentScoreVal1;
    private String absentScoreVal2;
    private String absentScoreVal3;
    private String absentScoreVal4;
    private String absentScoreVal5;

    private String absentScoreCd1;
    private String absentScoreCd2;
    private String absentScoreCd3;
    private String absentScoreCd4;
    private String absentScoreCd5;
    
    // 목록
    private List<String> absentScoreListVas;
    private List<String> absentScoreListCds;
    
    // 출석점수기준 강의 지각감전기준 정보
    private String lateScoreNm1;
    private String lateScoreNm2;
    private String lateScoreNm3;
    private String lateScoreNm4;
    private String lateScoreNm5;
    private String lateScoreNm6;
    private String lateScoreNm7;
    
    private String lateScoreVal1;
    private String lateScoreVal2;
    private String lateScoreVal3;
    private String lateScoreVal4;
    private String lateScoreVal5;
    private String lateScoreVal6;
    private String lateScoreVal7;
    
    private String lateScoreCd1;
    private String lateScoreCd2;
    private String lateScoreCd3;
    private String lateScoreCd4;
    private String lateScoreCd5;
    private String lateScoreCd6;
    private String lateScoreCd7;

    // 세미나 출석기준 설정
    // 세미나 출석 비율
    private String seminarAtndRatioCd;
    private String seminarAtndRatioNm;
    private String seminarAtndRatioVal;

    // 세미나 출석 시간
    private String seminarAtndTmCd;
    private String seminarAtndTmNm;
    private String seminarAtndTmVal;

    // 세미나 지각 비율
    private String seminarLateRatioCd;
    private String seminarLateRatioNm;
    private String seminarLateRatioVal;

    // 세미나 지각 시간
    private String seminarLateTmCd;
    private String seminarLateTmNm;
    private String seminarLateTmVal;

    // 세미나 결석 비율
    private String seminarAbsentRatioCd;
    private String seminarAbsentRatioNm;
    private String seminarAbsentRatioVal;

    // private String useYn;
    // private String rgtrId;
    // private String regDttm;
    // private String mdfrId;
    // private String modDttm;

    public String getConfGbn() {
        return confGbn;
    }
    public void setConfGbn(String confGbn) {
        this.confGbn = confGbn;
    }

    public String getConfCd() {
        return confCd;
    }
    public void setConfCd(String confCd) {
        this.confCd = confCd;
    }

    public String getConfNm() {
        return confNm;
    }
    public void setConfNm(String confNm) {
        this.confNm = confNm;
    }

    public String getConfVal() {
        return confVal;
    }
    public void setConfVal(String confVal) {
        this.confVal = confVal;
    }
    
    public String getOpenWeekCd() {
        return openWeekCd;
    }
    public void setOpenWeekCd(String openWeekCd) {
        this.openWeekCd = openWeekCd;
    }
    public String getOpenWeekNm() {
        return openWeekNm;
    }
    public void setOpenWeekNm(String openWeekNm) {
        this.openWeekNm = openWeekNm;
    }
    
    public String getOpenWeekVal() {
        return openWeekVal;
    }
    public void setOpenWeekVal(String openWeekVal) {
        this.openWeekVal = openWeekVal;
    }
    
    public String getOpenTmCd() {
        return openTmCd;
    }
    public void setOpenTmCd(String openTmCd) {
        this.openTmCd = openTmCd;
    }
    
    public String getOpenTmNm() {
        return openTmNm;
    }
    public void setOpenTmNm(String openTmNm) {
        this.openTmNm = openTmNm;
    }
    
    public String getOpenTmVal() {
        return openTmVal;
    }
    public void setOpenTmVal(String openTmVal) {
        this.openTmVal = openTmVal;
    }
    
    public String getOpenWeek1ApCd() {
        return openWeek1ApCd;
    }
    public void setOpenWeek1ApCd(String openWeek1ApCd) {
        this.openWeek1ApCd = openWeek1ApCd;
    }
    
    public String getOpenWeek1ApNm() {
        return openWeek1ApNm;
    }
    public void setOpenWeek1ApNm(String openWeek1ApNm) {
        this.openWeek1ApNm = openWeek1ApNm;
    }
    
    public String getOpenWeek1ApVal() {
        return openWeek1ApVal;
    }
    public void setOpenWeek1ApVal(String openWeek1ApVal) {
        this.openWeek1ApVal = openWeek1ApVal;
    }
    
    public String getOpenWeek1TmCd() {
        return openWeek1TmCd;
    }
    public void setOpenWeek1TmCd(String openWeek1TmCd) {
        this.openWeek1TmCd = openWeek1TmCd;
    }
    
    public String getOpenWeek1TmNm() {
        return openWeek1TmNm;
    }
    public void setOpenWeek1TmNm(String openWeek1TmNm) {
        this.openWeek1TmNm = openWeek1TmNm;
    }
    
    public String getOpenWeek1TmVal() {
        return openWeek1TmVal;
    }
    public void setOpenWeek1TmVal(String openWeek1TmVal) {
        this.openWeek1TmVal = openWeek1TmVal;
    }
    
    public String getAtendTermCd() {
        return atendTermCd;
    }
    public void setAtendTermCd(String atendTermCd) {
        this.atendTermCd = atendTermCd;
    }
    
    public String getAtendTermNm() {
        return atendTermNm;
    }
    public void setAtendTermNm(String atendTermNm) {
        this.atendTermNm = atendTermNm;
    }
    
    public String getAtendTermVal() {
        return atendTermVal;
    }
    public void setAtendTermVal(String atendTermVal) {
        this.atendTermVal = atendTermVal;
    }
    
    public String getAtendWeekCd() {
        return atendWeekCd;
    }
    public void setAtendWeekCd(String atendWeekCd) {
        this.atendWeekCd = atendWeekCd;
    }
    
    public String getAtendWeekNm() {
        return atendWeekNm;
    }
    public void setAtendWeekNm(String atendWeekNm) {
        this.atendWeekNm = atendWeekNm;
    }
    
    public String getAtendWeekVal() {
        return atendWeekVal;
    }
    public void setAtendWeekVal(String atendWeekVal) {
        this.atendWeekVal = atendWeekVal;
    }
    
    public String getAtndRatioCd() {
        return atndRatioCd;
    }
    public void setAtndRatioCd(String atndRatioCd) {
        this.atndRatioCd = atndRatioCd;
    }
    
    public String getAtndRatioNm() {
        return atndRatioNm;
    }
    public void setAtndRatioNm(String atndRatioNm) {
        this.atndRatioNm = atndRatioNm;
    }
    
    public String getAtndRatioVal() {
        return atndRatioVal;
    }
    public void setAtndRatioVal(String atndRatioVal) {
        this.atndRatioVal = atndRatioVal;
    }
    
    public String getLateRatioCd() {
        return lateRatioCd;
    }
    public void setLateRatioCd(String lateRatioCd) {
        this.lateRatioCd = lateRatioCd;
    }
    
    public String getLateRatioNm() {
        return lateRatioNm;
    }
    public void setLateRatioNm(String lateRatioNm) {
        this.lateRatioNm = lateRatioNm;
    }
    
    public String getLateRatioVal() {
        return lateRatioVal;
    }
    public void setLateRatioVal(String lateRatioVal) {
        this.lateRatioVal = lateRatioVal;
    }
    
    public String getAbsentRatioCd() {
        return absentRatioCd;
    }
    public void setAbsentRatioCd(String absentRatioCd) {
        this.absentRatioCd = absentRatioCd;
    }
    
    public String getAbsentRatioNm() {
        return absentRatioNm;
    }
    public void setAbsentRatioNm(String absentRatioNm) {
        this.absentRatioNm = absentRatioNm;
    }
    
    public String getAbsentRatioVal() {
        return absentRatioVal;
    }
    public void setAbsentRatioVal(String absentRatioVal) {
        this.absentRatioVal = absentRatioVal;
    }
    
    public String getSenAtndRatioCd() {
        return senAtndRatioCd;
    }
    public void setSenAtndRatioCd(String senAtndRatioCd) {
        this.senAtndRatioCd = senAtndRatioCd;
    }
    
    public String getSenAtndRatioNm() {
        return senAtndRatioNm;
    }
    public void setSenAtndRatioNm(String senAtndRatioNm) {
        this.senAtndRatioNm = senAtndRatioNm;
    }
    
    public String getSenAtndRatioVal() {
        return senAtndRatioVal;
    }
    public void setSenAtndRatioVal(String senAtndRatioVal) {
        this.senAtndRatioVal = senAtndRatioVal;
    }
    
    public String getSenLesnWeekCd() {
        return senLesnWeekCd;
    }
    public void setSenLesnWeekCd(String senLesnWeekCd) {
        this.senLesnWeekCd = senLesnWeekCd;
    }
    
    public String getSenLesnWeekNm() {
        return senLesnWeekNm;
    }
    public void setSenLesnWeekNm(String senLesnWeekNm) {
        this.senLesnWeekNm = senLesnWeekNm;
    }
    
    public String getSenLesnWeekVal() {
        return senLesnWeekVal;
    }
    public void setSenLesnWeekVal(String senLesnWeekVal) {
        this.senLesnWeekVal = senLesnWeekVal;
    }
    
    public String getSenAbsentRatioCd() {
        return senAbsentRatioCd;
    }
    public void setSenAbsentRatioCd(String senAbsentRatioCd) {
        this.senAbsentRatioCd = senAbsentRatioCd;
    }
    
    public String getSenAbsentRatioNm() {
        return senAbsentRatioNm;
    }
    public void setSenAbsentRatioNm(String senAbsentRatioNm) {
        this.senAbsentRatioNm = senAbsentRatioNm;
    }
    
    public String getSenAbsentRatioVal() {
        return senAbsentRatioVal;
    }
    public void setSenAbsentRatioVal(String senAbsentRatioVal) {
        this.senAbsentRatioVal = senAbsentRatioVal;
    }
    
    public String getSenLesnWeek1Cd() {
        return senLesnWeek1Cd;
    }
    public void setSenLesnWeek1Cd(String senLesnWeek1Cd) {
        this.senLesnWeek1Cd = senLesnWeek1Cd;
    }
    
    public String getSenLesnWeek1Nm() {
        return senLesnWeek1Nm;
    }
    public void setSenLesnWeek1Nm(String senLesnWeek1Nm) {
        this.senLesnWeek1Nm = senLesnWeek1Nm;
    }
    
    public String getSenLesnWeek1Val() {
        return senLesnWeek1Val;
    }
    public void setSenLesnWeek1Val(String senLesnWeek1Val) {
        this.senLesnWeek1Val = senLesnWeek1Val;
    }
    
    public String getSenLesnWeek2Cd() {
        return senLesnWeek2Cd;
    }
    public void setSenLesnWeek2Cd(String senLesnWeek2Cd) {
        this.senLesnWeek2Cd = senLesnWeek2Cd;
    }
    
    public String getSenLesnWeek2Nm() {
        return senLesnWeek2Nm;
    }
    public void setSenLesnWeek2Nm(String senLesnWeek2Nm) {
        this.senLesnWeek2Nm = senLesnWeek2Nm;
    }
    
    public String getSenLesnWeek2Val() {
        return senLesnWeek2Val;
    }
    public void setSenLesnWeek2Val(String senLesnWeek2Val) {
        this.senLesnWeek2Val = senLesnWeek2Val;
    }
    
    public String getSenLesnWeek3Cd() {
        return senLesnWeek3Cd;
    }
    public void setSenLesnWeek3Cd(String senLesnWeek3Cd) {
        this.senLesnWeek3Cd = senLesnWeek3Cd;
    }
    
    public String getSenLesnWeek3Nm() {
        return senLesnWeek3Nm;
    }
    public void setSenLesnWeek3Nm(String senLesnWeek3Nm) {
        this.senLesnWeek3Nm = senLesnWeek3Nm;
    }
    
    public String getSenLesnWeek3Val() {
        return senLesnWeek3Val;
    }
    public void setSenLesnWeek3Val(String senLesnWeek3Val) {
        this.senLesnWeek3Val = senLesnWeek3Val;
    }
    
    public String getSenLesnWeek4Cd() {
        return senLesnWeek4Cd;
    }
    public void setSenLesnWeek4Cd(String senLesnWeek4Cd) {
        this.senLesnWeek4Cd = senLesnWeek4Cd;
    }
    
    public String getSenLesnWeek4Nm() {
        return senLesnWeek4Nm;
    }
    public void setSenLesnWeek4Nm(String senLesnWeek4Nm) {
        this.senLesnWeek4Nm = senLesnWeek4Nm;
    }
    
    public String getSenLesnWeek4Val() {
        return senLesnWeek4Val;
    }
    public void setSenLesnWeek4Val(String senLesnWeek4Val) {
        this.senLesnWeek4Val = senLesnWeek4Val;
    }
    
    public String getAbsentScoreNm5() {
        return absentScoreNm5;
    }
    public void setAbsentScoreNm5(String absentScoreNm5) {
        this.absentScoreNm5 = absentScoreNm5;
    }
    
    public String getAbsentScoreNm4() {
        return absentScoreNm4;
    }
    public void setAbsentScoreNm4(String absentScoreNm4) {
        this.absentScoreNm4 = absentScoreNm4;
    }
    
    public String getAbsentScoreNm3() {
        return absentScoreNm3;
    }
    public void setAbsentScoreNm3(String absentScoreNm3) {
        this.absentScoreNm3 = absentScoreNm3;
    }
    
    public String getAbsentScoreNm2() {
        return absentScoreNm2;
    }
    public void setAbsentScoreNm2(String absentScoreNm2) {
        this.absentScoreNm2 = absentScoreNm2;
    }
    
    public String getAbsentScoreNm1() {
        return absentScoreNm1;
    }
    public void setAbsentScoreNm1(String absentScoreNm1) {
        this.absentScoreNm1 = absentScoreNm1;
    }
    
    public String getAbsentScoreVal5() {
        return absentScoreVal5;
    }
    public void setAbsentScoreVal5(String absentScoreVal5) {
        this.absentScoreVal5 = absentScoreVal5;
    }
    
    public String getAbsentScoreVal4() {
        return absentScoreVal4;
    }
    public void setAbsentScoreVal4(String absentScoreVal4) {
        this.absentScoreVal4 = absentScoreVal4;
    }
    
    public String getAbsentScoreVal3() {
        return absentScoreVal3;
    }
    public void setAbsentScoreVal3(String absentScoreVal3) {
        this.absentScoreVal3 = absentScoreVal3;
    }
    
    public String getAbsentScoreVal2() {
        return absentScoreVal2;
    }
    public void setAbsentScoreVal2(String absentScoreVal2) {
        this.absentScoreVal2 = absentScoreVal2;
    }
    
    public String getAbsentScoreVal1() {
        return absentScoreVal1;
    }
    public void setAbsentScoreVal1(String absentScoreVal1) {
        this.absentScoreVal1 = absentScoreVal1;
    }
    
    public String getAbsentScoreCd5() {
        return absentScoreCd5;
    }
    public void setAbsentScoreCd5(String absentScoreCd5) {
        this.absentScoreCd5 = absentScoreCd5;
    }
    
    public List<String> getAbsentScoreListVas() {
        return absentScoreListVas;
    }
    public void setAbsentScoreListVas(List<String> absentScoreListVas) {
        this.absentScoreListVas = absentScoreListVas;
    }
    
    public List<String> getAbsentScoreListCds() {
        return absentScoreListCds;
    }
    public void setAbsentScoreListCds(List<String> absentScoreListCds) {
        this.absentScoreListCds = absentScoreListCds;
    }
    
    public String getAbsentScoreCd4() {
        return absentScoreCd4;
    }
    public void setAbsentScoreCd4(String absentScoreCd4) {
        this.absentScoreCd4 = absentScoreCd4;
    }
    
    public String getAbsentScoreCd3() {
        return absentScoreCd3;
    }
    public void setAbsentScoreCd3(String absentScoreCd3) {
        this.absentScoreCd3 = absentScoreCd3;
    }
    
    public String getAbsentScoreCd2() {
        return absentScoreCd2;
    }
    public void setAbsentScoreCd2(String absentScoreCd2) {
        this.absentScoreCd2 = absentScoreCd2;
    }

    public String getAbsentScoreCd1() {
        return absentScoreCd1;
    }
    public void setAbsentScoreCd1(String absentScoreCd1) {
        this.absentScoreCd1 = absentScoreCd1;
    }
    
    public String getLateScoreNm1() {
        return lateScoreNm1;
    }
    public void setLateScoreNm1(String lateScoreNm1) {
        this.lateScoreNm1 = lateScoreNm1;
    }
    
    public String getLateScoreNm2() {
        return lateScoreNm2;
    }
    public void setLateScoreNm2(String lateScoreNm2) {
        this.lateScoreNm2 = lateScoreNm2;
    
    }
    public String getLateScoreNm3() {
        return lateScoreNm3;
    }
    public void setLateScoreNm3(String lateScoreNm3) {
        this.lateScoreNm3 = lateScoreNm3;
    }
    
    public String getLateScoreNm4() {
        return lateScoreNm4;
    }
    public void setLateScoreNm4(String lateScoreNm4) {
        this.lateScoreNm4 = lateScoreNm4;
    }
    
    public String getLateScoreNm5() {
        return lateScoreNm5;
    }
    public void setLateScoreNm5(String lateScoreNm5) {
        this.lateScoreNm5 = lateScoreNm5;
    }
    
    public String getLateScoreNm6() {
        return lateScoreNm6;
    }
    public void setLateScoreNm6(String lateScoreNm6) {
        this.lateScoreNm6 = lateScoreNm6;
    }
    
    public String getLateScoreNm7() {
        return lateScoreNm7;
    }
    public void setLateScoreNm7(String lateScoreNm7) {
        this.lateScoreNm7 = lateScoreNm7;
    }
    
    public String getLateScoreVal1() {
        return lateScoreVal1;
    }
    public void setLateScoreVal1(String lateScoreVal1) {
        this.lateScoreVal1 = lateScoreVal1;
    }
    
    public String getLateScoreVal2() {
        return lateScoreVal2;
    }
    public void setLateScoreVal2(String lateScoreVal2) {
        this.lateScoreVal2 = lateScoreVal2;
    }
    public String getLateScoreVal3() {
        return lateScoreVal3;
    }
    public void setLateScoreVal3(String lateScoreVal3) {
        this.lateScoreVal3 = lateScoreVal3;
    }
    
    public String getLateScoreVal4() {
        return lateScoreVal4;
    }
    public void setLateScoreVal4(String lateScoreVal4) {
        this.lateScoreVal4 = lateScoreVal4;
    }
    
    public String getLateScoreVal5() {
        return lateScoreVal5;
    }
    public void setLateScoreVal5(String lateScoreVal5) {
        this.lateScoreVal5 = lateScoreVal5;
    }
    
    public String getLateScoreVal6() {
        return lateScoreVal6;
    }
    public void setLateScoreVal6(String lateScoreVal6) {
        this.lateScoreVal6 = lateScoreVal6;
    }
    
    public String getLateScoreVal7() {
        return lateScoreVal7;
    }
    public void setLateScoreVal7(String lateScoreVal7) {
        this.lateScoreVal7 = lateScoreVal7;
    }

    public String getLateScoreCd1() {
        return lateScoreCd1;
    }
    public void setLateScoreCd1(String lateScoreCd1) {
        this.lateScoreCd1 = lateScoreCd1;
    }
    
    public String getLateScoreCd2() {
        return lateScoreCd2;
    }
    public void setLateScoreCd2(String lateScoreCd2) {
        this.lateScoreCd2 = lateScoreCd2;
    }
    
    public String getLateScoreCd3() {
        return lateScoreCd3;
    }
    public void setLateScoreCd3(String lateScoreCd3) {
        this.lateScoreCd3 = lateScoreCd3;
    }
    
    public String getLateScoreCd4() {
        return lateScoreCd4;
    }
    public void setLateScoreCd4(String lateScoreCd4) {
        this.lateScoreCd4 = lateScoreCd4;
    }
    
    public String getLateScoreCd5() {
        return lateScoreCd5;
    }
    public void setLateScoreCd5(String lateScoreCd5) {
        this.lateScoreCd5 = lateScoreCd5;
    }
    
    public String getLateScoreCd6() {
        return lateScoreCd6;
    }
    public void setLateScoreCd6(String lateScoreCd6) {
        this.lateScoreCd6 = lateScoreCd6;
    }
    
    public String getLateScoreCd7() {
        return lateScoreCd7;
    }
    public void setLateScoreCd7(String lateScoreCd7) {
        this.lateScoreCd7 = lateScoreCd7;
    }
    
    // 세미나 출석기준 설정
    // 세미나 출석
    public String getSeminarAtndRatioCd() {
        return seminarAtndRatioCd;
    }
    public void setSeminarAtndRatioCd(String seminarAtndRatioCd) {
        this.seminarAtndRatioCd = seminarAtndRatioCd;
    }    
    
    public String getSeminarAtndRatioNm() {
        return seminarAtndRatioNm;
    }
    public void setSeminarAtndRatioNm(String seminarAtndRatioNm) {
        this.seminarAtndRatioNm = seminarAtndRatioNm;
    }
    
    public String getSeminarAtndRatioVal() {
        return seminarAtndRatioVal;
    }
    public void setSeminarAtndRatioVal(String seminarAtndRatioVal) {
        this.seminarAtndRatioVal = seminarAtndRatioVal;
    }
    
    public String getSeminarAtndTmCd() {
        return seminarAtndTmCd;
    }
    public void setSeminarAtndTmCd(String seminarAtndTmCd) {
        this.seminarAtndTmCd = seminarAtndTmCd;
    }
    
    public String getSeminarAtndTmNm() {
        return seminarAtndTmNm;
    }
    public void setSeminarAtndTmNm(String seminarAtndTmNm) {
        this.seminarAtndTmNm = seminarAtndTmNm;
    }
    
    public String getSeminarAtndTmVal() {
        return seminarAtndTmVal;
    }
    public void setSeminarAtndTmVal(String seminarAtndTmVal) {
        this.seminarAtndTmVal = seminarAtndTmVal;
    }
    
    // 세미나 지각
    public String getSeminarLateRatioCd() {
        return seminarLateRatioCd;
    }
    public void setSeminarLateRatioCd(String seminarLateRatioCd) {
        this.seminarLateRatioCd = seminarLateRatioCd;
    }
    
    public String getSeminarLateRatioNm() {
        return seminarLateRatioNm;
    }
    public void setSeminarLateRatioNm(String seminarLateRatioNm) {
        this.seminarLateRatioNm = seminarLateRatioNm;
    }
    
    public String getSeminarLateRatioVal() {
        return seminarLateRatioVal;
    }
    public void setSeminarLateRatioVal(String seminarLateRatioVal) {
        this.seminarLateRatioVal = seminarLateRatioVal;
    }
    
    public String getSeminarLateTmCd() {
        return seminarLateTmCd;
    }
    public void setSeminarLateTmCd(String seminarLateTmCd) {
        this.seminarLateTmCd = seminarLateTmCd;
    }
    
    public String getSeminarLateTmNm() {
        return seminarLateTmNm;
    }
    public void setSeminarLateTmNm(String seminarLateTmNm) {
        this.seminarLateTmNm = seminarLateTmNm;
    }
    
    public String getSeminarLateTmVal() {
        return seminarLateTmVal;
    }
    public void setSeminarLateTmVal(String seminarLateTmVal) {
        this.seminarLateTmVal = seminarLateTmVal;
    }
    
    // 세미나 결석
    public String getSeminarAbsentRatioCd() {
        return seminarAbsentRatioCd;
    }
    public void setSeminarAbsentRatioCd(String seminarAbsentRatioCd) {
        this.seminarAbsentRatioCd = seminarAbsentRatioCd;
    }
    
    public String getSeminarAbsentRatioNm() {
        return seminarAbsentRatioNm;
    }
    public void setSeminarAbsentRatioNm(String seminarAbsentRatioNm) {
        this.seminarAbsentRatioNm = seminarAbsentRatioNm;
    }
    
    public String getSeminarAbsentRatioVal() {
        return seminarAbsentRatioVal;
    }
    public void setSeminarAbsentRatioVal(String seminarAbsentRatioVal) {
        this.seminarAbsentRatioVal = seminarAbsentRatioVal;
    }
	public String getUniCd() {
		return uniCd;
	}
	public void setUniCd(String uniCd) {
		this.uniCd = uniCd;
	}
	public String getAvgScors() {
		return avgScors;
	}
	public void setAvgScors(String avgScors) {
		this.avgScors = avgScors;
	}
	public String getBaseScors() {
		return baseScors;
	}
	public void setBaseScors(String baseScors) {
		this.baseScors = baseScors;
	}
	public String getStartScors() {
		return startScors;
	}
	public void setStartScors(String startScors) {
		this.startScors = startScors;
	}
	public String getEndScors() {
		return endScors;
	}
	public void setEndScors(String endScors) {
		this.endScors = endScors;
	}
	public String getScorCds() {
		return scorCds;
	}
	public void setScorCds(String scorCds) {
		this.scorCds = scorCds;
	}
	public String getTabOrd() {
		return tabOrd;
	}
	public void setTabOrd(String tabOrd) {
		this.tabOrd = tabOrd;
	}
	public String getScorRelCds() {
		return scorRelCds;
	}
	public void setScorRelCds(String scorRelCds) {
		this.scorRelCds = scorRelCds;
	}
	public String getEndScorCds() {
		return endScorCds;
	}
	public void setEndScorCds(String endScorCds) {
		this.endScorCds = endScorCds;
	}
	public String getStartRatios() {
		return startRatios;
	}
	public void setStartRatios(String startRatios) {
		this.startRatios = startRatios;
	}
	public String getEndRatios() {
		return endRatios;
	}
	public void setEndRatios(String endRatios) {
		this.endRatios = endRatios;
	}
    
}
