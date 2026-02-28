package knou.lms.lesson.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.lesson.dao.LessonOperateDAO;
import knou.lms.lesson.service.LessonOperateService;
import knou.lms.lesson.vo.LessonOperateVO;
import knou.framework.util.StringUtil;

@Service("lessonOperateService")
public class LessonOperateServiceImpl extends ServiceBase implements LessonOperateService {
    
    private static final Logger logger = LoggerFactory.getLogger(LessonOperateServiceImpl.class);
    
    @Resource(name="lessonOperateDAO")
    private LessonOperateDAO lessonOperateDAO;

    @Override
    public ProcessResultListVO<LessonOperateVO> list(LessonOperateVO vo) throws Exception {
        
        ProcessResultListVO<LessonOperateVO> resultList = new ProcessResultListVO<LessonOperateVO>(); 
        try {
            List<LessonOperateVO> pagepList = lessonOperateDAO.list(vo);
            resultList.setResult(1);
            resultList.setReturnList(pagepList);
        } catch (Exception e){
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    
    @Override
    public LessonOperateVO view(LessonOperateVO vo) throws Exception {
        return lessonOperateDAO.select(vo);
    }

    @Override
    public ProcessResultListVO<LessonOperateVO> listPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception {

        ProcessResultListVO<LessonOperateVO> resultList = new ProcessResultListVO<LessonOperateVO>();
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totalCount = lessonOperateDAO.count(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<LessonOperateVO> pagepList = lessonOperateDAO.listPageing(vo);
            resultList.setResult(1);
            resultList.setReturnList(pagepList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception {
        
        return this.listPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listPageing(LessonOperateVO vo, int pageIndex) throws Exception {
        return this.listPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
    }

    @Override
    public ProcessResultListVO<LessonOperateVO> listAsmntNoSubmitPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception {

        ProcessResultListVO<LessonOperateVO> resultList = new ProcessResultListVO<LessonOperateVO>();
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totalCount = lessonOperateDAO.countAsmntNoSubmit(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<LessonOperateVO> pageList = lessonOperateDAO.listAsmntNoSubmitPageing(vo);
            resultList.setResult(1);
            resultList.setReturnList(pageList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listAsmntNoSubmitPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception {
        
        return this.listAsmntNoSubmitPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listAsmntNoSubmitPageing(LessonOperateVO vo, int pageIndex) throws Exception {
        return this.listAsmntNoSubmitPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
    }
    
    @Override
    public ProcessResultListVO<LessonOperateVO> listScoreUnratedPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception {

        ProcessResultListVO<LessonOperateVO> resultList = new ProcessResultListVO<LessonOperateVO>();
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totalCount = lessonOperateDAO.countScoreUnrated(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<LessonOperateVO> pageList = lessonOperateDAO.listScoreUnratedPageing(vo);
            resultList.setResult(1);
            resultList.setReturnList(pageList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listScoreUnratedPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception {
        
        return this.listScoreUnratedPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listScoreUnratedPageing(LessonOperateVO vo, int pageIndex) throws Exception {
        return this.listScoreUnratedPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
    }

    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginChiefPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception {

        ProcessResultListVO<LessonOperateVO> resultList = new ProcessResultListVO<LessonOperateVO>();
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totalCount = lessonOperateDAO.countLoginChief(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<LessonOperateVO> pageList = lessonOperateDAO.listLoginChiefPageing(vo);
            resultList.setResult(1);
            resultList.setReturnList(pageList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginChiefPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception {
        
        return this.listLoginChiefPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginChiefPageing(LessonOperateVO vo, int pageIndex) throws Exception {
        return this.listLoginChiefPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
    }

    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginLecturePageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception {

        ProcessResultListVO<LessonOperateVO> resultList = new ProcessResultListVO<LessonOperateVO>();
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totalCount = lessonOperateDAO.countLoginLecture(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<LessonOperateVO> pageList = lessonOperateDAO.listLoginLecturePageing(vo);
            resultList.setResult(1);
            resultList.setReturnList(pageList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginLecturePageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception {
        
        return this.listLoginChiefPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginLecturePageing(LessonOperateVO vo, int pageIndex) throws Exception {
        return this.listLoginChiefPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
    }
    
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginAsmntPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception {

        ProcessResultListVO<LessonOperateVO> resultList = new ProcessResultListVO<LessonOperateVO>();
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totalCount = lessonOperateDAO.countLoginLecture(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<LessonOperateVO> pageList = lessonOperateDAO.listLoginAsmntPageing(vo);
            resultList.setResult(1);
            resultList.setReturnList(pageList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginAsmntPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception {
        
        return this.listLoginChiefPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginAsmntPageing(LessonOperateVO vo, int pageIndex) throws Exception {
        return this.listLoginChiefPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
    }
    
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginQuizPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception {

        ProcessResultListVO<LessonOperateVO> resultList = new ProcessResultListVO<LessonOperateVO>();
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totalCount = lessonOperateDAO.countLoginLecture(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<LessonOperateVO> pageList = lessonOperateDAO.listLoginQuizPageing(vo);
            resultList.setResult(1);
            resultList.setReturnList(pageList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginQuizPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception {
        
        return this.listLoginChiefPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginQuizPageing(LessonOperateVO vo, int pageIndex) throws Exception {
        return this.listLoginChiefPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
    }
    
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginForumPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception {

        ProcessResultListVO<LessonOperateVO> resultList = new ProcessResultListVO<LessonOperateVO>();
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totalCount = lessonOperateDAO.countLoginLecture(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<LessonOperateVO> pageList = lessonOperateDAO.listLoginForumPageing(vo);
            resultList.setResult(1);
            resultList.setReturnList(pageList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginForumPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception {
        
        return this.listLoginChiefPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginForumPageing(LessonOperateVO vo, int pageIndex) throws Exception {
        return this.listLoginChiefPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
    }
    
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginResearchPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception {

        ProcessResultListVO<LessonOperateVO> resultList = new ProcessResultListVO<LessonOperateVO>();
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totalCount = lessonOperateDAO.countLoginLecture(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<LessonOperateVO> pageList = lessonOperateDAO.listLoginResearchPageing(vo);
            resultList.setResult(1);
            resultList.setReturnList(pageList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginResearchPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception {
        
        return this.listLoginChiefPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }
    @Override
    public ProcessResultListVO<LessonOperateVO> listLoginResearchPageing(LessonOperateVO vo, int pageIndex) throws Exception {
        return this.listLoginChiefPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
    }
    
}