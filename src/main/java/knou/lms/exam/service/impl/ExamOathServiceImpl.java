package knou.lms.exam.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.dao.ExamOathDAO;
import knou.lms.exam.service.ExamOathService;
import knou.lms.exam.vo.ExamOathVO;

@Service("examOathService")
public class ExamOathServiceImpl extends ServiceBase implements ExamOathService {

    @Resource(name="examOathDAO")
    private ExamOathDAO examOathDAO;
    
    /*****************************************************
     * <p>
     * TODO 시험 서약서 조회
     * </p>
     * 시험 서약서 조회
     * 
     * @param ExamOathVO
     * @return ExamOathVO
     * @throws Exception
     ******************************************************/
    @Override
    public ExamOathVO select(ExamOathVO vo) throws Exception {
        return examOathDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 시험 서약서 목록 조회
     * </p>
     * 시험 서약서 목록 조회
     * 
     * @param ExamOathVO
     * @return List<ExamOathVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamOathVO> list(ExamOathVO vo) throws Exception {
        return examOathDAO.list(vo);
    }

    /*****************************************************
     * <p>
     * TODO 시험 서약서 등록
     * </p>
     * 시험 서약서 등록
     * 
     * @param ExamOathVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insert(ExamOathVO vo) throws Exception {
        String oathCd = IdGenerator.getNewId("OATH");
        vo.setOathCd(oathCd);
        examOathDAO.insert(vo);
    }

    /*****************************************************
     * <p>
     * TODO 과목별 시험 서약서 제출 목록 조회
     * </p>
     * 과목별 시험 서약서 제출 목록 조회
     * 
     * @param ExamOathVO
     * @return ProcessResultVO<ExamOathVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamOathVO> listOathByCreCrsPaging(ExamOathVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<ExamOathVO> examOathList = examOathDAO.listOathByCreCrsPaging(vo);
        
        if(examOathList.size() > 0) {
            paginationInfo.setTotalRecordCount(examOathList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<ExamOathVO> resultVO = new ProcessResultVO<ExamOathVO>();
        
        resultVO.setReturnList(examOathList);
        resultVO.setPageInfo(paginationInfo);
        
        return resultVO;
    }

}
