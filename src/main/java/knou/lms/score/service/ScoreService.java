package knou.lms.score.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.score.vo.OprScoreAssistVO;
import knou.lms.score.vo.OprScoreProfVO;
import knou.lms.score.vo.ScoreVO;

public interface ScoreService
{
    /***************************************************** 
     * TODO 성적 항목 설정을 등록한다.
     * @param vo
     * @return
     * @throws Exception
     ******************************************************/ 
    public ProcessResultVO<ScoreVO> copyScoreItemConf(ScoreVO vo) throws Exception;

    /***************************************************** 
     * 수업운영 점수
     * @param vo
     * @return OprScoreProfVO
     * @throws Exception
     ******************************************************/
    public OprScoreProfVO selectOprScoreProf(OprScoreProfVO vo) throws Exception;
    
    /***************************************************** 
     * 수업운영 점수합  (교수)
     * @param vo
     * @return OprScoreProfVO
     * @throws Exception
     ******************************************************/
    public OprScoreProfVO selectOprScoreProfTotal(OprScoreProfVO vo) throws Exception;
    
    /***************************************************** 
     * 관리자 > 수업운영도구 > 수업운영 점수등록(교수) 목록
     * @param vo
     * @return List<OprScoreProfVO>
     * @throws Exception
     ******************************************************/
    public List<OprScoreProfVO> listOprScoreProfWrite(OprScoreProfVO vo) throws Exception;

    /***************************************************** 
     * 관리자 > 수업운영도구 > 수업운영 점수전체(교수) 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listOprScoreProfTotal(OprScoreProfVO vo) throws Exception;
    
    /***************************************************** 
     * 관리자 > 수업운영도구 > 수업운영 점수(교수) 벌점원인 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listOprScoreProfPanaltyReason(OprScoreProfVO vo) throws Exception;
    
    /***************************************************** 
     * 관리자 > 수업운영도구 > 수업운영 점수(교수) 교수별 통계 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listOprScoreStatusByProf(OprScoreProfVO vo) throws Exception;
    
    /***************************************************** 
     * 수업운영점수등록(교수)
     * @param request
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void updateOprScoreProf(HttpServletRequest request, List<OprScoreProfVO> list) throws Exception;
    
    /***************************************************** 
     * 수업운영점수삭제(교수)
     * @param request
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void deleteOprScoreProf(HttpServletRequest request, List<OprScoreProfVO> list) throws Exception;

    /***************************************************** 
     * 수업운영 점수 (조교)
     * @param vo
     * @return OprScoreAssistVO
     * @throws Exception
     ******************************************************/
    public OprScoreAssistVO selectOprScoreAssist(OprScoreAssistVO vo) throws Exception;
    
    /***************************************************** 
     * 수업운영 점수합  (조교)
     * @param vo
     * @return OprScoreProfVO
     * @throws Exception
     ******************************************************/
    public OprScoreAssistVO selectOprScoreAssistTotal(OprScoreAssistVO vo) throws Exception;
    
    /***************************************************** 
     * 관리자 > 수업운영도구 > 수업운영 점수등록(조교) 목록
     * @param vo
     * @return List<OprScoreAssistVO>
     * @throws Exception
     ******************************************************/
    public List<OprScoreAssistVO> listOprScoreAssistWrite(OprScoreAssistVO vo) throws Exception;
    
    /***************************************************** 
     * 관리자 > 수업운영도구 > 수업운영 점수전체(조교) 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listOprScoreAssistTotal(OprScoreAssistVO vo) throws Exception;
    
    /***************************************************** 
     * 수업운영점수등록(조교)
     * @param request
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void updateOprScoreAssist(HttpServletRequest request, List<OprScoreAssistVO> list) throws Exception;
    
    /***************************************************** 
     * 수업운영점수삭제(조교)
     * @param request
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void deleteOprScoreAssist(HttpServletRequest request, List<OprScoreAssistVO> list) throws Exception;
    
    /***************************************************** 
     * 수업운영 점수 산정 (교수)
     * @param request
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void profCalcScore() throws Exception;
    
    /***************************************************** 
     * 수업운영 점수 산정 (조교)
     * @param request
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void assistCalcScore() throws Exception;
}
