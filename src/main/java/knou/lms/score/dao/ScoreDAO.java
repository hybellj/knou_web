package knou.lms.score.dao;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.score.vo.OprScoreAssistVO;
import knou.lms.score.vo.OprScoreProfVO;
import knou.lms.score.vo.ScoreVO;

@Mapper("scoreDAO")
public interface ScoreDAO
{
    /***************************************************** 
     * TODO 성적 항목 설정을 등록한다.
     * @param vo
     * @throws Exception
     ******************************************************/ 
    public void copyScoreItemConf(ScoreVO vo) throws Exception;

    public int selectScoreItemChk(ScoreVO vo) throws Exception;
    
    /***************************************************** 
     * 수업운영 점수 (교수)
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
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void updateOprScoreProf(List<OprScoreProfVO> list) throws Exception;
    
    /***************************************************** 
     * 수업운영점수삭제(교수)
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void deleteOprScoreProf(List<OprScoreProfVO> list) throws Exception;
    
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
     * @return OprScoreAssistVO
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
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void updateOprScoreAssist(List<OprScoreAssistVO> list) throws Exception;
    
    /***************************************************** 
     * 수업운영점수삭제(조교)
     * @param list
     * @return 
     * @throws Exception
     ******************************************************/
    public void deleteOprScoreAssist(List<OprScoreAssistVO> list) throws Exception;
    
    /***************************************************** 
     * 교수/조교 수업운영 점수산정 > 교수 수업운영점수 목록
     * @param vo
     * @return List<OprScoreProfVO>
     * @throws Exception
     ******************************************************/
    public List<OprScoreProfVO> listOprScoreProf(Map<String, Object> map) throws Exception;
    
    /***************************************************** 
     * 교수/조교 수업운영 점수산정 > 조교 수업운영점수 목록
     * @param vo
     * @return List<OprScoreAssistVO>
     * @throws Exception
     ******************************************************/
    public List<OprScoreAssistVO> listOprScoreAssist(Map<String, Object> map) throws Exception;
    
    /***************************************************** 
     * 교수/조교 수업운영 점수산정 > 교수 평가기준 활용 수 목록
     * @param vo
     * @return List<Map<String, Object>>
     * @throws Exception
     ******************************************************/
    public List<Map<String, Object>> listProfScoreItemConf(Map<String, Object> map) throws Exception;
    
    /***************************************************** 
     * 교수/조교 수업운영 점수산정 > 수업운영 게시글 등록 수 목록
     * @param vo
     * @return List<Map<String, Object>>
     * @throws Exception
     ******************************************************/
    public List<Map<String, Object>> listOperAtclCount(Map<String, Object> map) throws Exception;
    
    /***************************************************** 
     * 교수/조교 수업운영 점수산정 > 알림터 72시간 내 미답변 수 (문의 / 상담) 목록
     * @param vo
     * @return List<Map<String, Object>>
     * @throws Exception
     ******************************************************/
    public List<Map<String, Object>> listOperNoAnsAtclCount(Map<String, Object> map) throws Exception;
    
    /***************************************************** 
     * 교수/조교 수업운영 점수산정 > 수업운영 메세지발송 수 조회
     * @param vo
     * @return List<Map<String, Object>>
     * @throws Exception
     ******************************************************/
    public List<Map<String, Object>> listOperMessageCount(Map<String, Object> map) throws Exception;
}
