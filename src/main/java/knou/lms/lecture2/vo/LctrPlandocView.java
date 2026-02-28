package knou.lms.lecture2.vo;

import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.subject2.vo.SubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;
import java.util.Map;

public class LctrPlandocView {
    private SubjectVO SubjectInfo;
    private EgovMap profInfo;
    private List<EgovMap> coprofList;
    private List<EgovMap> tutList;
    private List<EgovMap> AssiList;
    private LctrPlandocVO lctrPlandocInfo;
    private List<TxtbkVO> txtbkList;
    private CmmnCdVO mrkEvlInfo;
    private List<EgovMap> lectureScheduleList;
    private List<EgovMap> mrkItmStngList;
    private Map<String, List<CmmnCdVO>> cmmnCdList;

    public SubjectVO getSubjectInfo() {
        return SubjectInfo;
    }

    public void setSubjectInfo(SubjectVO subjectInfo) {
        SubjectInfo = subjectInfo;
    }

    public EgovMap getProfInfo() {
        return profInfo;
    }

    public void setProfInfo(EgovMap profInfo) {
        this.profInfo = profInfo;
    }

    public List<EgovMap> getCoprofList() {
        return coprofList;
    }

    public void setCoprofList(List<EgovMap> coprofList) {
        this.coprofList = coprofList;
    }

    public List<EgovMap> getTutList() {
        return tutList;
    }

    public void setTutList(List<EgovMap> tutList) {
        this.tutList = tutList;
    }

    public List<EgovMap> getAssiList() {
        return AssiList;
    }

    public void setAssiList(List<EgovMap> assiList) {
        AssiList = assiList;
    }

    public LctrPlandocVO getLctrPlandocInfo() {
        return lctrPlandocInfo;
    }

    public void setLctrPlandocInfo(LctrPlandocVO lctrPlandocInfo) {
        this.lctrPlandocInfo = lctrPlandocInfo;
    }

    public List<TxtbkVO> getTxtbkList() {
        return txtbkList;
    }

    public void setTxtbkList(List<TxtbkVO> txtbkList) {
        this.txtbkList = txtbkList;
    }

    public CmmnCdVO getMrkEvlInfo() {
        return mrkEvlInfo;
    }

    public void setMrkEvlInfo(CmmnCdVO mrkEvlInfo) {
        this.mrkEvlInfo = mrkEvlInfo;
    }

    public List<EgovMap> getLectureScheduleList() {
        return lectureScheduleList;
    }

    public void setLectureScheduleList(List<EgovMap> lectureScheduleList) {
        this.lectureScheduleList = lectureScheduleList;
    }

    public List<EgovMap> getMrkItmStngList() {
        return mrkItmStngList;
    }

    public void setMrkItmStngList(List<EgovMap> mrkItmStngList) {
        this.mrkItmStngList = mrkItmStngList;
    }

    public Map<String, List<CmmnCdVO>> getCmmnCdList() {
        return cmmnCdList;
    }

    public void setCmmnCdList(Map<String, List<CmmnCdVO>> cmmnCdList) {
        this.cmmnCdList = cmmnCdList;
    }
}
