package knou.lms.resh.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.resh.vo.ReshVO;

@Mapper("reshDAO")
public interface ReshDAO {

    /*****************************************************
     * TODO 설문 정보 조회
     * @param ReshVO
     * @return ReshVO
     * @throws Exception
     ******************************************************/
    public ReshVO select(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 목록 조회
     * @param ReshVO
     * @return List<ReshVO>
     * @throws Exception
     ******************************************************/
    public List<ReshVO> list(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 목록 조회 페이징
     * @param ReshVO
     * @return List<ReshVO>
     * @throws Exception
     ******************************************************/
    public List<ReshVO> listPaging(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 개수 조회
     * @param ReshVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int count(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 내 강의에 등록된 설문 목록 조회
     * @param ReshVO
     * @return List<ReshVO>
     * @throws Exception
     ******************************************************/
    public List<ReshVO> listMyCreCrsResh(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 내 강의에 등록된 설문 목록 조회 페이징
     * @param ReshVO
     * @return List<ReshVO>
     * @throws Exception
     ******************************************************/
    public List<ReshVO> listMyCreCrsReshPaging(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 등록
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertResh(ReshVO vo) throws Exception;
    
    /*****************************************************
     * 설문 복사
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void copyResh(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 강의 연결 등록
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertReshCreCrsRltn(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 수정
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateResh(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항가져오기 시 복사된 설문 정보 업데이트
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReshQstnCopy(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 삭제 상태로 수정
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReshDelYn(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 강의 연결 삭제 상태로 수정
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReshCreCrsRltnDelYn(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 강의에 연결된 설문중에서 설문에 참여해야 성적을 조회할수 있도록 설정한 설문의 카운트
     * @param ReshVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectScoreViewReshCount(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문과 같이 등록된 분반 또는 다른 과목 목록 조회
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReshCreCrsDecls(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문과 같이 등록된 분반 또는 다른 과목 조회
     * @param ReshVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectReshCreCrsDecls(ReshVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 출제 완료 처리
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReschSubmitYn(ReshVO vo) throws Exception;
    
    /*****************************************************
     * 강의평가/만족도조사 설문 참여가능 여부 체크
     * @param ReshVO
     * @return int
     * @throws Exception
     ******************************************************/
    public EgovMap selectEvalJoinCheck(ReshVO vo) throws Exception;
    
    /*****************************************************
     * 설문 성적공개여부 수정 
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateScoreOpenYn(ReshVO vo) throws Exception;
    
    /*****************************************************
     * 설문 성적 반영비율 수정
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateScoreRatio(ReshVO vo) throws Exception;
    
    /*****************************************************
     * 성적 반영 설문 목록
     * @param ReshVO
     * @return List<ReshVO>
     * @throws Exception
     ******************************************************/
    public List<ReshVO> listReshScoreAply(ReshVO vo) throws Exception;
    
}
