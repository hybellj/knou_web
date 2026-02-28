package knou.lms.resh.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.resh.vo.ReshAnsrVO;
import knou.lms.resh.vo.ReshPageVO;
import knou.lms.resh.vo.ReshQstnVO;
import knou.lms.resh.vo.ReshVO;

public interface ReshAnsrService {

    /*****************************************************
     * TODO 설문 참여 장치별 현황 조회
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public abstract List<EgovMap> listReshJoinDeviceStatus(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항별 선택지 응답현황
     * @param ReshQstnVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public abstract List<EgovMap> listReshQstnItemAnswerStatus(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항별 서술형 응답 리스트 조회
     * @param ReshQstnVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public abstract List<EgovMap> listReshTextQstnAnswer(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항별 척도형 응답현황
     * @param ReshQstnVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public abstract List<EgovMap> listReshQstnScaleAnswerStatus(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지별 항목 응답 목록 조회
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public abstract List<ReshPageVO> listReshAnswerStatus(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 참여자 리스트 조회
     * @param ReshVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    public abstract ProcessResultVO<EgovMap> listReshJoinUser(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 제출
     * @param ReshAnsrVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public abstract ProcessResultVO<DefaultVO> insertReshAnsr(ReshAnsrVO vo, HttpServletRequest request) throws Exception;
    
    /*****************************************************
     * TODO 설문 수정
     * @param ReshAnsrVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public abstract ProcessResultVO<DefaultVO> updateReshAnsrByUser(ReshAnsrVO vo, HttpServletRequest request) throws Exception;
    
    /*****************************************************
     * TODO 설문 수정
     * @param ReshAnsrVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public abstract ProcessResultVO<DefaultVO> updateReshAnsr(ReshAnsrVO vo, HttpServletRequest request) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 참여자 수 조회
     * @param ReshAnsrVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int reshQstnJoinUserCnt(ReshAnsrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 홈페이지 설문 참여자 목록 조회
     * @param ReshAnsrVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<EgovMap> listHomeReshJoinUser(ReshAnsrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 홈페이지 설문 참여 현황 조회
     * @param ReshVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectHomeReshJoinUserStatus(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 답변 목록
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReshAnswer(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 및 척도 목록
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReshQstnAndScale(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 나의 설문 답변 목록
     * @param ReshAnsrVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReshMyAnswer(ReshAnsrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 점수 수정
     * @param ReshAnsrVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> updateReshScore(ReshAnsrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 참여저 정보 조회
     * @param ReshAnsrVO
     * @return ReshAnsrVO
     * @throws Exception
     ******************************************************/
    public ReshAnsrVO selectReshJoinUserInfo(ReshAnsrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 메모 수정
     * @param ReshAnsrVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> updateReshUserMemo(ReshAnsrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 메모 조회
     * @param ReshAnsrVO
     * @return ReshAnsrVO
     * @throws Exception
     ******************************************************/
    public ReshAnsrVO selectProfMemo(ReshAnsrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 엑셀 설문 성적 업로드
     * @param ReshAnsrVO, List<?>
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> updateExampleExcelScore(ReshAnsrVO vo, List<?> stdList) throws Exception;
    
    /*****************************************************
     * TODO 설문 참여자 리스트 조회(EZ-Grader)
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReshJoinUserByEzGrader(ReshAnsrVO vo) throws Exception;
    
}
