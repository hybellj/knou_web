package knou.lms.exam.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.dao.ExamQbankCtgrDAO;
import knou.lms.exam.service.ExamQbankCtgrService;
import knou.lms.exam.vo.ExamQbankCtgrVO;

@Service("examQbankCtgrService")
public class ExamQbankCtgrServiceImpl extends ServiceBase implements ExamQbankCtgrService {

    @Resource(name="examQbankCtgrDAO")
    private ExamQbankCtgrDAO examQbankCtgrDAO;

    /*****************************************************
     * <p>
     * TODO 문제은행 분류 코드 정보 조회
     * </p>
     * 문제은행 분류 코드 정보 조회
     * 
     * @param ExamQbankCtgrVO
     * @return ExamQbankCtgrVO
     * @throws Exception
     ******************************************************/
    @Override
    public ExamQbankCtgrVO select(ExamQbankCtgrVO vo) throws Exception {

        return examQbankCtgrDAO.select(vo);
    }
    
    /*****************************************************
     * <p>
     * TODO 문제은행 분류 코드 목록 조회
     * </p>
     * 문제은행 분류 코드 목록 조회
     * 
     * @param ExamQbankCtgrVO
     * @return List<ExamQbankCtgrVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamQbankCtgrVO> list(ExamQbankCtgrVO vo) throws Exception {
        
        return examQbankCtgrDAO.list(vo);
    }

    /*****************************************************
     * <p>
     * TODO 문제은행 분류 코드 목록 조회 페이징
     * </p>
     * 문제은행 분류 코드 목록 조회 페이징
     * 
     * @param ExamQbankCtgrVO
     * @return ProcessResultVO<ExamQbankCtgrVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamQbankCtgrVO> listPaging(ExamQbankCtgrVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<ExamQbankCtgrVO> qbankCtgrList = examQbankCtgrDAO.listPaging(vo);
        
        if(qbankCtgrList.size() > 0) {
            paginationInfo.setTotalRecordCount(qbankCtgrList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<ExamQbankCtgrVO> resultVO = new ProcessResultVO<ExamQbankCtgrVO>();
        
        resultVO.setReturnList(qbankCtgrList);
        resultVO.setPageInfo(paginationInfo);
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 문제은행 분류 코드 등록
     * </p>
     * 문제은행 분류 코드 등록
     * 
     * @param ExamQbankCtgrVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insertQbankCtgr(ExamQbankCtgrVO vo) throws Exception {
        String examQbankCtgrCd = IdGenerator.getNewId("QCTGR");
        vo.setExamQbankCtgrCd(examQbankCtgrCd);
        
        examQbankCtgrDAO.insertQbankCtgr(vo);
    }
    
    /*****************************************************
     * <p>
     * TODO 문제은행 분류 코드 수정
     * </p>
     * 문제은행 분류 코드 수정
     * 
     * @param ExamQbankCtgrVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateQbankCtgr(ExamQbankCtgrVO vo) throws Exception {
        examQbankCtgrDAO.updateQbankCtgr(vo);
    }

    /*****************************************************
     * <p>
     * TODO 문제은행 분류 코드 삭제
     * </p>
     * 문제은행 분류 코드 삭제
     * 
     * @param ExamQbankCtgrVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteQbankCtgr(ExamQbankCtgrVO vo) throws Exception {
        ExamQbankCtgrVO ctgrVO = examQbankCtgrDAO.select(vo);
        examQbankCtgrDAO.updateQbankCtgrOdr(ctgrVO);
        examQbankCtgrDAO.deleteQbankCtgr(vo);
    }

    /*****************************************************
     * <p>
     * TODO 문제은행 특정 분류코드 순서 조회
     * </p>
     * 문제은행 특정 분류코드 순서 조회
     * 
     * @param ExamQbankCtgrVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int selectQbankCtgrOdr(ExamQbankCtgrVO vo) throws Exception {
        return examQbankCtgrDAO.selectQbankCtgrOdr(vo);
    }

    /*****************************************************
     * <p>
     * TODO 문제은행 과목별 사용자 목록 가져오기
     * </p>
     * 문제은행 과목별 사용자 목록 가져오기
     * 
     * @param ExamQbankCtgrVO
     * @return List<ExamQbankCtgrVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamQbankCtgrVO> listQbankCtgrUser(ExamQbankCtgrVO vo) throws Exception {
        return examQbankCtgrDAO.listQbankCtgrUser(vo);
    }

}
