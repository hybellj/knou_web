package knou.lms.lesson.dao;

import java.util.List;

import knou.lms.lesson.vo.LessonOperateVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;


@Mapper("lessonOperateDAO")
public interface LessonOperateDAO {
    
	/**
	 * 
	 * @param  LessonOperateVO 
	 * @return List
	 * @throws Exception
	 */
	public List<LessonOperateVO> list(LessonOperateVO vo) throws Exception;
	
    /**
     * 수업운영 상세 정보를 조회한다. 
     * @param  LessonOperateVO 
     * @return LessonOperateVO
     * @throws Exception
     */
    public LessonOperateVO select(LessonOperateVO vo) throws Exception;

    /**
	 * 수업운영(강의알리미) 카운트
	 * @param  LessonOperateVO 
	 * @return int
	 * @throws Exception
	 */
	public int count(LessonOperateVO vo) throws Exception;
	
    /**
	 * 수업운영(강의알리미) 목록 조회
	 * @param  LessonOperateVO 
	 * @return List
	 * @throws Exception
	 */
	public List<LessonOperateVO> listPageing(LessonOperateVO vo) throws Exception;
	
    /**
     * 수업운영(과제미제출과목) 카운트
     * @param  LessonOperateVO 
     * @return List
     * @throws Exception
     */
    public int countAsmntNoSubmit(LessonOperateVO vo) throws Exception;
    
    /**
     * 수업운영(과제미제출과목) 목록 조회
     * @param  LessonOperateVO 
     * @return List
     * @throws Exception
     */
    public List<LessonOperateVO> listAsmntNoSubmitPageing(LessonOperateVO vo) throws Exception;

    /**
     * 수업운영(성적미평가과목) 카운트
     * @param  LessonOperateVO 
     * @return List
     * @throws Exception
     */
    public int countScoreUnrated(LessonOperateVO vo) throws Exception;
    
    /**
     * 수업운영(성적미평가과목) 목록 조회
     * @param  LessonOperateVO 
     * @return List
     * @throws Exception
     */
    public List<LessonOperateVO> listScoreUnratedPageing(LessonOperateVO vo) throws Exception;

    /**
     * 수업운영(교수/조교 로그인) 카운트
     * @param  LessonOperateVO 
     * @return List
     * @throws Exception
     */
    public int countLoginChief(LessonOperateVO vo) throws Exception;

    /**
     * 수업운영(교수/조교 로그인) 목록 조회
     * @param  LessonOperateVO 
     * @return List
     * @throws Exception
     */
    public List<LessonOperateVO> listLoginChiefPageing(LessonOperateVO vo) throws Exception;
    
    /**
     * 수업운영(교수/조교 과목) 카운트
     * @param  LessonOperateVO 
     * @return List
     * @throws Exception
     */
    public int countLoginLecture(LessonOperateVO vo) throws Exception;

    /**
     * 수업운영(교수/조교 과목) 목록 조회
     * @param  LessonOperateVO 
     * @return List
     * @throws Exception
     */
    public List<LessonOperateVO> listLoginLecturePageing(LessonOperateVO vo) throws Exception;
    
    /**
     * 수업운영
     * @param  LessonOperateVO 
     * @return List
     * @throws Exception
     */
    public List<LessonOperateVO> listLoginAsmntPageing(LessonOperateVO vo) throws Exception;
    public int countLoginAsmnt(LessonOperateVO vo) throws Exception;
    
    public List<LessonOperateVO> listLoginQuizPageing(LessonOperateVO vo) throws Exception;
    public int countLoginQuiz(LessonOperateVO vo) throws Exception;
    
    public List<LessonOperateVO> listLoginForumPageing(LessonOperateVO vo) throws Exception;
    public int countLoginForum(LessonOperateVO vo) throws Exception;
    
    public List<LessonOperateVO> listLoginResearchPageing(LessonOperateVO vo) throws Exception;
    public int countLoginResearch(LessonOperateVO vo) throws Exception;
    
}
