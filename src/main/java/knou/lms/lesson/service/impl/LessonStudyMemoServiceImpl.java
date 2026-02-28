package knou.lms.lesson.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.lesson.dao.LessonStudyMemoDAO;
import knou.lms.lesson.service.LessonStudyMemoService;
import knou.lms.lesson.vo.LessonStudyMemoVO;
import knou.lms.std.dao.StdDAO;

@Service("lessonStudyMemoService")
public class LessonStudyMemoServiceImpl extends ServiceBase implements LessonStudyMemoService {

    @Resource(name="lessonStudyMemoDAO")
    private LessonStudyMemoDAO lessonStudyMemoDAO;
    
    /*****************************************************
     * <p>
     * TODO 학습메모 정보 조회
     * </p>
     * 학습메모 정보 조회
     * 
     * @param LessonStudyMemoVO
     * @return LessonStudyMemoVO
     * @throws Exception
     ******************************************************/
    @Override
    public LessonStudyMemoVO select(LessonStudyMemoVO vo) throws Exception {
        return lessonStudyMemoDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 학습메모 목록 조회
     * </p>
     * 학습메모 목록 조회
     * 
     * @param LessonStudyMemoVO
     * @return List<LessonStudyMemoVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LessonStudyMemoVO> list(LessonStudyMemoVO vo) throws Exception {
        return lessonStudyMemoDAO.list(vo);
    }

    /*****************************************************
     * <p>
     * TODO 학습메모 목록 조회 페이징
     * </p>
     * 학습메모 목록 조회 페이징
     * 
     * @param LessonStudyMemoVO
     * @return ProcessResultVO<LessonStudyMemoVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<LessonStudyMemoVO> listPaging(LessonStudyMemoVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<LessonStudyMemoVO> memoList = lessonStudyMemoDAO.listPaging(vo);

        if(memoList.size() > 0) {
            paginationInfo.setTotalRecordCount(memoList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<LessonStudyMemoVO> resultVO = new ProcessResultVO<LessonStudyMemoVO>();
        
        resultVO.setReturnList(memoList);
        resultVO.setPageInfo(paginationInfo);
        
        return resultVO;
    }
    
    /*****************************************************
     * <p>
     * TODO 학습메모 등록
     * </p>
     * 학습메모 등록
     * 
     * @param LessonStudyMemoVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public LessonStudyMemoVO insert(LessonStudyMemoVO vo) throws Exception {
        String studyMemoId = IdGenerator.getNewId("MEMO");
        vo.setStudyMemoId(studyMemoId);
        lessonStudyMemoDAO.insert(vo);
        
        return vo;
    }
    
    /*****************************************************
     * <p>
     * TODO 학습메모 수정
     * </p>
     * 학습메모 수정
     * 
     * @param LessonStudyMemoVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void update(LessonStudyMemoVO vo) throws Exception {
        lessonStudyMemoDAO.update(vo);
    }

    /*****************************************************
     * <p>
     * TODO 학습메모 삭제
     * </p>
     * 학습메모 삭제
     * 
     * @param LessonStudyMemoVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void delete(LessonStudyMemoVO vo) throws Exception {
        lessonStudyMemoDAO.delete(vo);
    }

}
