package knou.lms.resh.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.resh.vo.ReshPageVO;
import knou.lms.resh.vo.ReshQstnItemVO;
import knou.lms.resh.vo.ReshQstnVO;
import knou.lms.resh.vo.ReshScaleVO;

public interface ReshQstnService {

    /*****************************************************
     * TODO 설문 페이지 목록 조회 (항목 포함)
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
     * TODO 설문 페이지 목록 조회
     * @param ReshPageVO
     * @return List<ReshPageVO>
     * @throws Exception
     ******************************************************/
    public List<ReshPageVO> listReshSimplePage(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 복사
     * @param ReshPageVO
     * @return ProcessResultVO<ReshPageVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ReshPageVO> copyReshQstn(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지 순서 변경
     * @param ReshPageVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> editReshPageOdr(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지별 항목 순서 변경
     * @param ReshQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> editReshQstnOdr(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지 등록
     * @param ReshPageVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> insertReshPage(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지 수정
     * @param ReshPageVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> updateReshPage(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 페이지 삭제
     * @param ReshPageVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> deleteReshPage(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 등록
     * @param ReshQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> insertReshQstn(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 수정
     * @param ReshQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> updateReshQstn(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 삭제
     * @param ReshQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> deleteReshQstn(ReshQstnVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 엑셀 업로드 샘플 파일 데이터 조회
     * @param ReshPageVO
     * @return HashMap<String, Object>
     * @throws Exception
     ******************************************************/
    public HashMap<String, Object> getReshQstnExcelSampleData(ReshPageVO vo) throws Exception;
    
    /*****************************************************
     * TODO 설문 문항 엑셀 업로드 처리
     * @param ReshPageVO, List<?>
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<DefaultVO> uploadReshQstnExcel(ReshPageVO vo, List<?> qstnList, HttpServletRequest request) throws Exception;
    
}
