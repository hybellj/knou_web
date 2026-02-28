package knou.lms.resh.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.resh.vo.ReshPageVO;
import knou.lms.resh.vo.ReshQstnItemVO;
import knou.lms.resh.vo.ReshQstnVO;
import knou.lms.resh.vo.ReshScaleVO;

@Mapper("reshQstnDAO")
public interface ReshQstnDAO {

    /*****************************************************
     * TODO 설문 페이지 목록 조회
     * @param ReshPageVO
     * @return List<ReshPageVO>
     * @throws Exception
     ******************************************************/
    public List<ReshPageVO> listReshPage(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지별 문항 목록 조회
     * @param ReshPageVO
     * @return List<ReshQstnVO>
     * @throws Exception
     ******************************************************/
    public List<ReshQstnVO> listReshQstn(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 아이템 목록 조회
     * @param ReshQstnVO
     * @return List<ReshQstnItemVO>
     * @throws Exception
     ******************************************************/
    public List<ReshQstnItemVO> listReshQstnItem(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 척도 목록 조회
     * @param ReshQstnVO
     * @return List<ReshScaleVO>
     * @throws Exception
     ******************************************************/
    public List<ReshScaleVO> listReshScale(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 정보 조회
     * @param ReshQstnVO
     * @return ReshQstnVO
     * @throws Exception
     ******************************************************/
    public ReshQstnVO selectReshQstn(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지 조회
     * @param ReshPageVO
     * @return ReshPageVO
     * @throws Exception
     ******************************************************/
    public ReshPageVO selectReshPage(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지 등록
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertReshPage(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지 수정
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReshPage(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지 삭제
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delReshPage(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 등록
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertReshQstn(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 수정
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReshQstn(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 삭제
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delReshQstn(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 아이템 등록
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertReshQstnItem(ReshQstnItemVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 아이템 수정
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReshQstnItem(ReshQstnItemVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 아이템 삭제
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delReshQstnItem(ReshQstnItemVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 평가 척도 등록
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertReshScale(ReshScaleVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 평가 척도 수정
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReshScale(ReshScaleVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 평가 척도 삭제
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delReshScale(ReshScaleVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지 순서 변경
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReshPageOdr(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지 순서 특정 번호로 변경
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReshPageOdrToNo(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지별 항목 순서 변경
     * @param ReshQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReshQstnOdr(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지별 항목 순서 특정 번호로 변경
     * @param ReshQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReshQstnOdrToNo(ReshQstnVO vo) throws Exception;
    
}
