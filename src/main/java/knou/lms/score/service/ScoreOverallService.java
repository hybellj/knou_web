package knou.lms.score.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.erp.vo.ErpScoreTestVO;
import knou.lms.score.vo.ScoreOverallScoreCalVO;
import knou.lms.score.vo.ScoreOverallVO;

public interface ScoreOverallService {

    public ProcessResultVO<ScoreOverallVO> selectOverallList(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectOverallExcelList(ScoreOverallVO vo) throws Exception;
    public ScoreOverallVO selectOverallStdInfo(ScoreOverallVO vo) throws Exception;
    public ScoreOverallVO selectOverallScoreDtl(ScoreOverallVO vo) throws Exception;
    public int selectScoreMustF(ScoreOverallScoreCalVO vo) throws Exception;
    public ScoreOverallVO selectStdDetailScore(ScoreOverallVO vo) throws Exception;
    
    public void updateOverallScoreStatus(ScoreOverallVO vo) throws Exception;
    public void saveOverallList(ScoreOverallVO vo) throws Exception;
    public ScoreOverallVO selectModGrade(ScoreOverallVO vo) throws Exception;
    public String selectCreCrsEval(ScoreOverallVO vo) throws Exception;
    public ScoreOverallScoreCalVO selectScoreRelConf(ScoreOverallScoreCalVO vo) throws Exception;
    public void saveRelativeScoreConvert(ScoreOverallScoreCalVO vo) throws Exception;
    public void saveAbsoluteScoreConvert(ScoreOverallScoreCalVO vo) throws Exception;
    public void savePfScoreConvert(ScoreOverallScoreCalVO vo) throws Exception;
    public ScoreOverallScoreCalVO selectScoreRel(ScoreOverallScoreCalVO vo) throws Exception;
    public List<ScoreOverallVO> selectOverallGraphList(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectOverallGraphListByGrade(ScoreOverallVO vo) throws Exception;
    public ScoreOverallVO selectOverallGridCase(ScoreOverallVO vo) throws Exception;
    public void updateOverallScoreOpenYn(ScoreOverallVO vo) throws Exception;
    public String selectOverallScoreOpenYn(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> chartScoreList(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> avgScoreList(ScoreOverallVO vo) throws Exception;
    public ScoreOverallVO selectStdScore(ScoreOverallVO vo) throws Exception;
    public ScoreOverallVO selectExamAbsentCnt(ScoreOverallVO vo) throws Exception;
    public String[] selectSysJobSchStr(ScoreOverallVO vo) throws Exception;
    public ProcessResultVO<ScoreOverallVO> selectOverallBaseInfo(ScoreOverallVO vo) throws Exception;
    public void insertStdScoreObjt(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectScoreObjtList(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectScoreObjtTchList(ScoreOverallVO vo) throws Exception;
    public ScoreOverallVO selectScoreObjtCtnt(ScoreOverallVO vo) throws Exception;
    public ScoreOverallVO selectScoreObjtReg(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectScoreObjtRegList(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectScoreObjtProcList(ScoreOverallVO vo) throws Exception;
    public void updateScoreObjtProc(ScoreOverallVO vo) throws Exception;
    public ScoreOverallVO selectStdMemo(ScoreOverallVO vo)  throws Exception;
    public void updateStdMemo(ScoreOverallVO vo)  throws Exception;
    public ScoreOverallVO selectCurDateFmt() throws Exception;
    public ScoreOverallVO selectLessonInfo(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectTestsDtlList(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectQuizDtlList(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectTestDtlList(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectAsmntDtlList(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectForumDtlList(ScoreOverallVO vo) throws Exception;
    public ProcessResultVO<ScoreOverallVO> selectObjtProcCfmInfo(ScoreOverallVO vo) throws Exception;
    public void updateTotScoreByStdNo(ScoreOverallVO vo) throws Exception;
    public void updateOverallScoreInit(ScoreOverallScoreCalVO vo) throws Exception;
    public ScoreOverallVO selectScoreOverallStd(ScoreOverallVO vo) throws Exception;
    public ProcessResultVO<ScoreOverallVO> selectOverallModStdInfo(ScoreOverallVO vo) throws Exception;
    public void updateStdScoreObjt(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectScoreObjtListAdmin(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectStdScoreObjtList(ScoreOverallVO vo) throws Exception;
    public ScoreOverallVO selectBtnStatus(ScoreOverallVO vo) throws Exception;
    public ProcessResultVO<ScoreOverallVO> selectOverallStdInfoAdmin(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectScoreItemConfList(ScoreOverallVO vo) throws Exception;
    public List<ScoreOverallVO> selectScoreHistList(ScoreOverallVO vo) throws Exception;
    public List<ErpScoreTestVO> selectErpTestScoreList(ScoreOverallVO vo) throws Exception;
    public EgovMap selectScoreExistsYnByUniCd(ScoreOverallVO vo) throws Exception;
    public void updateScoreItemChangeLog(String crsCreCd, String userId, String stdNo, int scoreItemOrder, String modScore, String mdfrId) throws Exception;
    public List<ScoreOverallVO> selectOverallMainList(ScoreOverallVO vo) throws Exception;
    public void updateScoreItemConfList(HttpServletRequest request, List<ScoreOverallVO> list) throws Exception;
}