package knou.lms.exam.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.dao.ExamQbankQstnDAO;
import knou.lms.exam.service.ExamQbankQstnService;
import knou.lms.exam.vo.ExamQbankQstnVO;

@Service("examQbankQstnService")
public class ExamQbankQstnServiceImpl extends ServiceBase implements ExamQbankQstnService {

    @Resource(name="examQbankQstnDAO")
    private ExamQbankQstnDAO examQbankQstnDAO;

    /*****************************************************
     * <p>
     * TODO 문제은행 문제 정보 조회
     * </p>
     * 문제은행 문제 정보 조회
     * 
     * @param ExamQbankQstnVO
     * @return ExamQbankQstnVO
     * @throws Exception
     ******************************************************/
    @Override
    public ExamQbankQstnVO select(ExamQbankQstnVO vo) throws Exception {

        return examQbankQstnDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 문제은행 문제 목록 조회
     * </p>
     * 문제은행 문제 목록 조회
     * 
     * @param ExamQbankQstnVO
     * @return List<ExamQbankQstnVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamQbankQstnVO> list(ExamQbankQstnVO vo) throws Exception {
        
        return examQbankQstnDAO.list(vo);
    }
    
    /*****************************************************
     * <p>
     * TODO 문제은행 문제 목록 조회 페이징
     * </p>
     * 문제은행 문제 목록 조회 페이징
     * 
     * @param ExamQbankQstnVO
     * @return ProcessResultVO<ExamQbankQstnVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamQbankQstnVO> listPaging(ExamQbankQstnVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<ExamQbankQstnVO> qbankQstnList = examQbankQstnDAO.listPaging(vo);
        
        if(qbankQstnList.size() > 0) {
            paginationInfo.setTotalRecordCount(qbankQstnList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<ExamQbankQstnVO> resultVO = new ProcessResultVO<ExamQbankQstnVO>();
        
        resultVO.setReturnList(qbankQstnList);
        resultVO.setPageInfo(paginationInfo);
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 문제은행 특정 분류코드 문제 순서 조회
     * </p>
     * 문제은행 특정 분류코드 문제 순서 조회
     * 
     * @param ExamQbankQstnVO
     * @return ExamQbankQstnVO
     * @throws Exception
     ******************************************************/
    @Override
    public ExamQbankQstnVO selectQbankQstnNos(ExamQbankQstnVO vo) throws Exception {
        return examQbankQstnDAO.selectQbankQstnNos(vo);
    }

    /*****************************************************
     * <p>
     * TODO 문제은행 문제 등록
     * </p>
     * 문제은행 문제 등록
     * 
     * @param ExamQbankQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insertQbankQstn(ExamQbankQstnVO vo) throws Exception {
        if("ALL".equals(vo.getQstnDiff())) {
            vo.setQstnDiff(null);
        }
        vo.setExamQbankQstnSn(examQbankQstnDAO.selectKey());
        
        examQbankQstnDAO.insertQbankQstn(vo);
    }

    /*****************************************************
     * <p>
     * TODO 문제은행 문제 수정
     * </p>
     * 문제은행 문제 수정
     * 
     * @param ExamQbankQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateQbankQstn(ExamQbankQstnVO vo) throws Exception {
        if("ALL".equals(vo.getQstnDiff())) {
            vo.setQstnDiff(null);
        }
        
        // 문제 순서 변경
        //ExamQbankQstnVO qstnVO = examQbankQstnDAO.select(vo);
        //examQbankQstnDAO.updateQstnNo(qstnVO);
        
        examQbankQstnDAO.updateQbankQstn(vo);
    }

    /*****************************************************
     * <p>
     * TODO 문제은행 문제 삭제 상태로 수정
     * </p>
     * 문제은행 문제 삭제 상태로 수정
     * 
     * @param ExamQbankQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateQbankQstnDelYn(ExamQbankQstnVO vo) throws Exception {
        // 문제 순서 변경
        ExamQbankQstnVO qstnVO = examQbankQstnDAO.select(vo);
        examQbankQstnDAO.updateQstnNo(qstnVO);
        
        examQbankQstnDAO.updateQbankQstnDelYn(vo);
    }
    
}
