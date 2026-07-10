package knou.lms.lecture2.vo;

import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;
import knou.lms.mrk.vo.MarkItemSettingVO;

import java.util.List;

public class LctrPlandocVO extends DefaultVO {

    private String lctrPlandocId;        // 강의계획서아이디 (PK)
    private String crclmnOtln;            // 교과목개요
    private String lctrGoal;              // 강의목표
    private String lctrOpGdln;             // 운영방침
    private String lctrOpPlan;             // 운영계획
    private String rltdSbjctCts;           // 관련과목내용
    private String remakrs;                // 참고사항

    private String plyrShrtctKeyPvsnyn;    // 플레이어단축키제공여부 (Y/N)
    private String scrptPvsnyn;             // 스크립트제공여부 (Y/N)
    private String sbttlsPvsnyn;            // 자막제공여부 (Y/N)
    private String plyrSpdAdjstPvsnyn;      // 재생속도조절제공여부 (Y/N)

    /*===첨부파일===*/
    // 강의노트
    private String noteUploadFiles;
    private String noteDelFileIdStr;
    private String[] noteDelFileIds = {};
    // 음성파일
    private String voiceUploadFiles;
    private String voiceDelFileIdStr;
    private String[] voiceDelFileIds = {};
    // 실습지도
    private String trainingUploadFiles;
    private String trainingDelFileIdStr;
    private String[] trainingDelFileIds = {};


    /*===연계컬럼====*/
    private String sbjctYr;                  // 과목년도
    private String sbjctSmstr;                // 과목학기
    private String smstrChrtId;             // 학기기수아이디

    /*===저장용===*/
    private List<TxtbkVO> txtbkList;    // 교재
    private List<MarkItemSettingVO> mrkItmStngList; // 평가비율
    private List<LectureScheduleVO> wkList; // 주차
    private List<RltmExamVO> rltmExamList; // 실시간시험


    public LctrPlandocVO() {
    }

    public LctrPlandocVO(String sbjctId) {
        this.setSbjctId(sbjctId);
    }

    public String getLctrPlandocId() {
        return lctrPlandocId;
    }

    public void setLctrPlandocId(String lctrPlandocId) {
        this.lctrPlandocId = lctrPlandocId;
    }

    public String getCrclmnOtln() {
        return crclmnOtln;
    }

    public void setCrclmnOtln(String crclmnOtln) {
        this.crclmnOtln = crclmnOtln;
    }

    public String getLctrGoal() {
        return lctrGoal;
    }

    public void setLctrGoal(String lctrGoal) {
        this.lctrGoal = lctrGoal;
    }

    public String getLctrOpGdln() {
        return lctrOpGdln;
    }

    public void setLctrOpGdln(String lctrOpGdln) {
        this.lctrOpGdln = lctrOpGdln;
    }

    public String getLctrOpPlan() {
        return lctrOpPlan;
    }

    public void setLctrOpPlan(String lctrOpPlan) {
        this.lctrOpPlan = lctrOpPlan;
    }

    public String getRltdSbjctCts() {
        return rltdSbjctCts;
    }

    public void setRltdSbjctCts(String rltdSbjctCts) {
        this.rltdSbjctCts = rltdSbjctCts;
    }

    public String getRemakrs() {
        return remakrs;
    }

    public void setRemakrs(String remakrs) {
        this.remakrs = remakrs;
    }

    public String getPlyrShrtctKeyPvsnyn() {
        return plyrShrtctKeyPvsnyn;
    }

    public void setPlyrShrtctKeyPvsnyn(String plyrShrtctKeyPvsnyn) {
        this.plyrShrtctKeyPvsnyn = plyrShrtctKeyPvsnyn;
    }

    public String getScrptPvsnyn() {
        return scrptPvsnyn;
    }

    public void setScrptPvsnyn(String scrptPvsnyn) {
        this.scrptPvsnyn = scrptPvsnyn;
    }

    public String getSbttlsPvsnyn() {
        return sbttlsPvsnyn;
    }

    public void setSbttlsPvsnyn(String sbttlsPvsnyn) {
        this.sbttlsPvsnyn = sbttlsPvsnyn;
    }

    public String getPlyrSpdAdjstPvsnyn() {
        return plyrSpdAdjstPvsnyn;
    }

    public void setPlyrSpdAdjstPvsnyn(String plyrSpdAdjstPvsnyn) {
        this.plyrSpdAdjstPvsnyn = plyrSpdAdjstPvsnyn;
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


    public List<TxtbkVO> getTxtbkList() {
        return txtbkList;
    }

    public void setTxtbkList(List<TxtbkVO> txtbkList) {
        this.txtbkList = txtbkList;
    }

    public List<MarkItemSettingVO> getMrkItmStngList() {
        return mrkItmStngList;
    }

    public void setMrkItmStngList(List<MarkItemSettingVO> mrkItmStngList) {
        this.mrkItmStngList = mrkItmStngList;
    }

    public List<LectureScheduleVO> getWkList() {
        return wkList;
    }

    public void setWkList(List<LectureScheduleVO> wkList) {
        this.wkList = wkList;
    }

    public List<RltmExamVO> getRltmExamList() {
        return rltmExamList;
    }

    public void setRltmExamList(List<RltmExamVO> rltmExamList) {
        this.rltmExamList = rltmExamList;
    }

    public String getSmstrChrtId() {
        return smstrChrtId;
    }

    public void setSmstrChrtId(String smstrChrtId) {
        this.smstrChrtId = smstrChrtId;
    }

    public String getNoteUploadFiles() {
        return noteUploadFiles;
    }

    public void setNoteUploadFiles(String noteUploadFiles) {
        this.noteUploadFiles = noteUploadFiles;
    }


    public String getNoteDelFileIdStr() {
        return noteDelFileIdStr;
    }

    public void setNoteDelFileIdStr(String noteDelFileIdStr) {
        this.noteDelFileIdStr = noteDelFileIdStr;
    }

    public String getVoiceUploadFiles() {
        return voiceUploadFiles;
    }

    public void setVoiceUploadFiles(String voiceUploadFiles) {
        this.voiceUploadFiles = voiceUploadFiles;
    }

    public String getVoiceDelFileIdStr() {
        return voiceDelFileIdStr;
    }

    public void setVoiceDelFileIdStr(String voiceDelFileIdStr) {
        this.voiceDelFileIdStr = voiceDelFileIdStr;
    }

    public String getTrainingUploadFiles() {
        return trainingUploadFiles;
    }

    public void setTrainingUploadFiles(String trainingUploadFiles) {
        this.trainingUploadFiles = trainingUploadFiles;
    }


    public String getTrainingDelFileIdStr() {
        return trainingDelFileIdStr;
    }

    public void setTrainingDelFileIdStr(String trainingDelFileIdStr) {
        this.trainingDelFileIdStr = trainingDelFileIdStr;
    }

    public void setNoteDelFileIds(String[] noteDelFileIds) {
        this.noteDelFileIds = noteDelFileIds;
    }

    public void setVoiceDelFileIds(String[] voiceDelFileIds) {
        this.voiceDelFileIds = voiceDelFileIds;
    }

    public void setTrainingDelFileIds(String[] trainingDelFileIds) {
        this.trainingDelFileIds = trainingDelFileIds;
    }

    public String[] getNoteDelFileIds() {
        if(StringUtil.isNull(noteDelFileIdStr)) {
            return new String[]{};
        }
        return noteDelFileIdStr.split(",");
    }

    public String[] getVoiceDelFileIds() {
        if(StringUtil.isNull(voiceDelFileIdStr)) {
            return new String[]{};
        }
        return voiceDelFileIdStr.split(",");
    }

    public String[] getTrainingDelFileIds() {
        if(StringUtil.isNull(trainingDelFileIdStr)) {
            return new String[]{};
        }
        return trainingDelFileIdStr.split(",");
    }
}
