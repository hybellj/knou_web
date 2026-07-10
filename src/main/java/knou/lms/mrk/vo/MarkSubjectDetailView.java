package knou.lms.mrk.vo;

import knou.lms.subject.vo.SubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;
import java.util.Map;

public class MarkSubjectDetailView {

    private List<EgovMap> mrkItmStngList;
    private EgovMap stdMrkSbjctDtlInfo;
    private Map<String, Double> AvgScrInfoByMrkItm;
    private EgovMap mrkRangeStatus; // 점수 구간 현황
    private int totalRatio;

    public List<EgovMap> getMrkItmStngList() {
        return mrkItmStngList;
    }

    public void setMrkItmStngList(List<EgovMap> mrkItmStngList) {
        this.mrkItmStngList = mrkItmStngList;
    }

    public EgovMap getStdMrkSbjctDtlInfo() {
        return stdMrkSbjctDtlInfo;
    }

    public void setStdMrkSbjctDtlInfo(EgovMap stdMrkSbjctDtlInfo) {
        this.stdMrkSbjctDtlInfo = stdMrkSbjctDtlInfo;
    }

    public Map<String, Double> getAvgScrInfoByMrkItm() {
        return AvgScrInfoByMrkItm;
    }

    public void setAvgScrInfoByMrkItm(Map<String, Double> avgScrInfoByMrkItm) {
        this.AvgScrInfoByMrkItm = avgScrInfoByMrkItm;
    }

    public EgovMap getMrkRangeStatus() {
        return mrkRangeStatus;
    }

    public void setMrkRangeStatus(EgovMap mrkRangeStatus) {
        this.mrkRangeStatus = mrkRangeStatus;
    }

    public int getTotalRatio() {
        return totalRatio;
    }

    public void setTotalRatio(int totalRatio) {
        this.totalRatio = totalRatio;
    }
}
