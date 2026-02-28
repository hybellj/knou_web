package knou.lms.lesson.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.lesson.vo.LessonOperateVO;
import knou.lms.lesson.vo.LessonScheduleVO;

public interface LessonOperateService {

    /**
     * 
     * @param LessonOperateVO
     * @return ProcessResultListVO
     * @throws Exception
     */
    public ProcessResultListVO<LessonOperateVO> list(LessonOperateVO vo) throws Exception;

    /**
     * 
     * @param LessonOperateVO
     * @return LessonOperateVO
     * @throws Exception
     */
    public LessonOperateVO view(LessonOperateVO vo) throws Exception;
    
    /**
     * 수업운영도구(강의알리미) 페이징 목록 조회
     * @param LessonOperateVO
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultListVO
     * @throws Exception
     */
    public ProcessResultListVO<LessonOperateVO> listPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listPageing(LessonOperateVO vo, int pageIndex) throws Exception;

    /**
     * 수업운영도구(과제미제출과목) 페이징 목록 조회
     * @param LessonOperateVO
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultListVO
     * @throws Exception
     */
    public ProcessResultListVO<LessonOperateVO> listAsmntNoSubmitPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listAsmntNoSubmitPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listAsmntNoSubmitPageing(LessonOperateVO vo, int pageIndex) throws Exception;
    
    /**
     * 수업운영도구(성적미평가과목) 페이징 목록 조회
     * @param LessonOperateVO
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultListVO
     * @throws Exception
     */
    public ProcessResultListVO<LessonOperateVO> listScoreUnratedPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listScoreUnratedPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listScoreUnratedPageing(LessonOperateVO vo, int pageIndex) throws Exception;

    /**
     * 수업운영도구(교수,조교 로그인) 목록 조회
     * @param LessonOperateVO
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultListVO
     * @throws Exception
     */
    public ProcessResultListVO<LessonOperateVO> listLoginChiefPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listLoginChiefPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listLoginChiefPageing(LessonOperateVO vo, int pageIndex) throws Exception;
    
    /**
     * 수업운영(교수/조교 과목) 목록 조회
     * @param LessonOperateVO
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultListVO
     * @throws Exception
     */
    public ProcessResultListVO<LessonOperateVO> listLoginLecturePageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listLoginLecturePageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listLoginLecturePageing(LessonOperateVO vo, int pageIndex) throws Exception;
    
    
    /**
     * 수업운영 목록 조회 (세부 콘텐츠 포함)
     * @param vo
     * @return
     * @throws Exception
     */
    public ProcessResultListVO<LessonOperateVO> listLoginAsmntPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listLoginAsmntPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listLoginAsmntPageing(LessonOperateVO vo, int pageIndex) throws Exception;
    
    public ProcessResultListVO<LessonOperateVO> listLoginQuizPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listLoginQuizPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listLoginQuizPageing(LessonOperateVO vo, int pageIndex) throws Exception;

    public ProcessResultListVO<LessonOperateVO> listLoginForumPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listLoginForumPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listLoginForumPageing(LessonOperateVO vo, int pageIndex) throws Exception;

    public ProcessResultListVO<LessonOperateVO> listLoginResearchPageing(LessonOperateVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listLoginResearchPageing(LessonOperateVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<LessonOperateVO> listLoginResearchPageing(LessonOperateVO vo, int pageIndex) throws Exception;
}
