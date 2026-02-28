package knou.lms.resh.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.resh.vo.ReshAnsrVO;
import knou.lms.resh.vo.ReshQstnVO;
import knou.lms.resh.vo.ReshVO;

@Mapper("reshAnsrDAO")
public interface ReshAnsrDAO {

    /*****************************************************
     * TODO 설문 참여 장치별 현황 조회
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReshJoinDeviceStatus(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항별 선택지 응답현황
     * @param ReshQstnVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReshQstnItemAnswerStatus(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항별 서술형 응답 리스트 조회
     * @param ReshQstnVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReshTextQstnAnswer(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항별 척도형 응답현황
     * @param ReshQstnVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReshQstnScaleAnswerStatus(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 참여자 리스트 조회
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReshJoinUser(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 참여자 수 조회
     * @param ReshVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int reshJoinUserCnt(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 응답 등록
     * @param ReshAnsrVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertReshAnsr(ReshAnsrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 응답 삭제
     * @param ReshAnsrVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delReshAnsr(ReshAnsrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 참여자 등록
     * @param ReshAnsrVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertReshJoinUser(ReshAnsrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 참여자 삭제
     * @param ReshAnsrVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delReshJoinUser(ReshAnsrVO vo) throws Exception;
    
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
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listHomeReshJoinUser(ReshAnsrVO vo) throws Exception;
    
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
     * TODO 설문 참여 정보 조회
     * @param ReshAnsrVO
     * @return ReshAnsrVO
     * @throws Exception
     ******************************************************/
    public ReshAnsrVO selectReshJoinUserInfo(ReshAnsrVO vo) throws Exception;
    
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
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReshScore(ReshAnsrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 메모 수정
     * @param ReshAnsrVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReshUserMemo(ReshAnsrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 메모 조회
     * @param ReshAnsrVO
     * @return ReshAnsrVO
     * @throws Exception
     ******************************************************/
    public ReshAnsrVO selectProfMemo(ReshAnsrVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 참여자 리스트 조회(EZ-Grader)
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReshJoinUserByEzGrader(ReshAnsrVO vo) throws Exception;
    
}
