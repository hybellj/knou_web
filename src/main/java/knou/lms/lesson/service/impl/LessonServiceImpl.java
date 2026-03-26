package knou.lms.lesson.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.lesson.dao.LessonDAO;
import knou.lms.lesson.service.LessonService;
import knou.lms.lesson.vo.LessonCntsVO;
import knou.lms.lesson.vo.LessonPageVO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonTimeVO;
import knou.lms.lesson.vo.LessonVO;
import knou.lms.subject.vo.SubjectVO;

@Service("lessonService")
public class LessonServiceImpl extends ServiceBase implements LessonService {
    
    @Resource(name="lessonDAO")
    private LessonDAO lessonDAO;

    /**
     * 강의주차 전체 목록 조회 (세부 콘텐츠 포함)
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<LessonScheduleVO> listLessonScheduleAll(LessonScheduleVO vo) throws Exception {
        List<LessonScheduleVO> lessonScheduleList = new ArrayList<>();
        
        try {
            // 콘텐츠목록 조회
            LessonCntsVO lessonCntsVO = new LessonCntsVO();
            lessonCntsVO.setCrsCreCd(vo.getCrsCreCd());
            List<LessonCntsVO> lessonCntsList = lessonDAO.listLessonCntsAll(lessonCntsVO);
            
            HashMap<String, List<LessonCntsVO>> lessonCntsMap = new HashMap<>();
            for (LessonCntsVO cntsVO : lessonCntsList) {
                if (lessonCntsMap.containsKey(cntsVO.getLessonTimeId())) {
                    (lessonCntsMap.get(cntsVO.getLessonTimeId())).add(cntsVO);
                }
                else {
                    List<LessonCntsVO> list = new ArrayList<>();
                    list.add(cntsVO);
                    lessonCntsMap.put(cntsVO.getLessonTimeId(), list);
                }
            }
            
            // 교시목록 조회
            LessonTimeVO lessonTimeVO = new LessonTimeVO();
            lessonTimeVO.setCrsCreCd(vo.getCrsCreCd());
            List<LessonTimeVO> lessonTimeList = lessonDAO.listLessonTimeAll(lessonTimeVO);
            
            HashMap<String, List<LessonTimeVO>> lessonTimeMap = new HashMap<>();
            for (LessonTimeVO timeVO : lessonTimeList) {
                if (lessonCntsMap.containsKey(timeVO.getLessonTimeId())) {
                    timeVO.setListLessonCnts(lessonCntsMap.get(timeVO.getLessonTimeId()));
                }
                
                if (lessonTimeMap.containsKey(timeVO.getLessonScheduleId())) {
                    (lessonTimeMap.get(timeVO.getLessonScheduleId())).add(timeVO);
                }
                else {
                    List<LessonTimeVO> list = new ArrayList<>();
                    list.add(timeVO);
                    lessonTimeMap.put(timeVO.getLessonScheduleId(), list);
                }
            }
            
            // 주차목록 조회
            lessonScheduleList = lessonDAO.listLessonScheduleAll(vo);
            for (LessonScheduleVO scheduleVO : lessonScheduleList) {
                if (lessonTimeMap.containsKey(scheduleVO.getLessonScheduleId())) {
                    scheduleVO.setListLessonTime(lessonTimeMap.get(scheduleVO.getLessonScheduleId()));
                }
            }
            
        } catch (Exception e) {

        }
        
        return lessonScheduleList;
    }

    /*****************************************************
     * 주차 교시 정보 조회
     * @param LessonTimeVO
     * @return LessonTimeVO
     * @throws Exception
     ******************************************************/
    @Override
    public LessonTimeVO selectLessonTime(LessonTimeVO vo) throws Exception {
        return lessonDAO.selectLessonTime(vo);
    }
    
    /*****************************************************
     * 주차, 교시의 콘텐츠 목록 조회
     * @param LessonCntsVO
     * @return List<LessonCntsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LessonCntsVO> listLessonCntsByLessonTime(LessonCntsVO vo) throws Exception {
        return lessonDAO.listLessonCntsByLessonTime(vo);
    }

    /*****************************************************
     * 주차 콘텐츠 페이지 목록 조회
     * @param LessonPageVO
     * @return List<LessonPageVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LessonPageVO> listLessonPageBySchedule(LessonPageVO vo) throws Exception {
        return lessonDAO.listLessonPageBySchedule(vo);
    }

    /*****************************************************
     * 학습여부 목록 조회
     * @param LessonCntsVO
     * @return List<LessonCntsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LessonCntsVO> listLessonCntsViewYn(LessonCntsVO vo) throws Exception {
        return lessonDAO.listLessonCntsViewYn(vo);
    }

    /*****************************************************
     * 학습 콘텐츠 정보 조회
     * @param LessonCntsVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectLessonCnts(LessonCntsVO vo) throws Exception {
        return lessonDAO.selectLessonCnts(vo);
    }
    
    /*****************************************************
     * 주차 교시 목록 (by lessonScheduleId)
     * @param LessonTimeVO
     * @return List<LessonTimeVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LessonTimeVO> listLessonTimeByScheduleId(LessonTimeVO vo) throws Exception {
        return lessonDAO.listLessonTimeByScheduleId(vo);
    }

    /*****************************************************
     * 학습진도관리 현황 목록 조회
     * @param LessonVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listLessonProgress(SubjectVO vo) throws Exception {
        //resultVO.setReturnVO(lessonDAO.selectLessonProgress(vo));
        return lessonDAO.listLessonProgress(vo);
    }
    
    @Override
    public List<LessonVO> listLessonProgressExcel(LessonVO vo) throws Exception {
        //resultVO.setReturnVO(lessonDAO.selectLessonProgress(vo));
        return lessonDAO.listLessonProgressExcel(vo);
    }
    
    /*****************************************************
     * 학습진도관리 전체현황
     * @param LessonVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectLessonProgressTotalStatus(LessonVO vo) throws Exception {
        return lessonDAO.selectLessonProgressTotalStatus(vo);
    }
    
    /*****************************************************
     * 학습진도관리 목록 (배치)
     * @param LessonVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listLessonProgressStatusBatch(LessonVO vo) throws Exception {
        Integer lessonScheduleOrder = vo.getLessonScheduleOrder();
        
        if(lessonScheduleOrder != null) {
            return lessonDAO.listLessonProgressStatusWeekBatch(vo);
        } else {
            return lessonDAO.listLessonProgressStatusBatch(vo);
        }
    }
    
    /*****************************************************
     * 콘텐츠 현황 목록
     * @param LessonVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<EgovMap> listCntsUsage(LessonVO vo) throws Exception {
        ProcessResultVO<EgovMap> processResultVO = new ProcessResultVO<>();
        
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        if(ValidationUtils.isNotEmpty(vo.getCrsTypeCds())) {
            vo.setSqlForeach(vo.getCrsTypeCds().split(","));
        }
        
        int totCnt = lessonDAO.countCntsUsage(vo);
        
        paginationInfo.setTotalRecordCount(totCnt);
        
        List<EgovMap> resultList = lessonDAO.listCntsUsage(vo);
        
        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);
        
        return processResultVO;
    }
    
    @Override
    public List<EgovMap> listCntsUsageExc(LessonVO vo) throws Exception {
        ProcessResultVO<EgovMap> processResultVO = new ProcessResultVO<>();
        
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        if(ValidationUtils.isNotEmpty(vo.getCrsTypeCds())) {
            vo.setSqlForeach(vo.getCrsTypeCds().split(","));
        }
        
        int totCnt = lessonDAO.countCntsUsage(vo);
        
        paginationInfo.setTotalRecordCount(totCnt);
        
        List<EgovMap> resultList = lessonDAO.listCntsUsage(vo);
        
        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);
        
        return resultList;
    }
}
