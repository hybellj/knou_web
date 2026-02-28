package knou.lms.crs.term.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.vo.CrsTermLessonVO;
import knou.lms.crs.term.vo.TermVO;

public interface TermService {

    /**
     * 학기 정보 등록 .
     * @param CrsVO
     * @return TermVO
     * @throws Exception
     */
    public void add(TermVO vo) throws Exception;
    
    /**
     * 학기 정보 수정.
     * @param CrsVO
     * @return void
     * @throws Exception
     */
    public void update(TermVO vo) throws Exception;
    
    /**
     * 학기, 개설과목 수정
     * @param TermVO
     * @return void
     * @throws Exception
     */
    public void updateTerm(TermVO vo) throws Exception;    
    
    public int editCurTermYn(TermVO vo) throws Exception;
    public int notEditCurTermYn(TermVO vo) throws Exception;

    /**
     * 학기 정보 삭제 .
     * @param CrsVO
     * @return void
     * @throws Exception
     */
    public void delete(TermVO vo) throws Exception;

    /**
     * 한 학기 조회.
     * @param CrsVO
     * @return TermVO
     * @throws Exception
     */
    public ProcessResultVO<TermVO> view(TermVO vo) throws Exception;
    
    /**
     * 학기 등록 .
     * @param pageIndex
     * @param listScale 
     * @param pageScale 
     * @param CrsVO
     * @return ProcessResultListVO
     * @throws Exception
     */
    public ProcessResultListVO<TermVO> listPageing(TermVO vo) throws Exception;
    
    /**
     * 학기 정보 중복 체크 .
     * @param vo 
     * @param CrsVO
     * @return TermVO
     * @throws Exception
     */
    public TermVO crsTermCheck(TermVO vo) throws Exception;
    public TermVO crsCurTermYnCheck(TermVO vo) throws Exception;

    /**
     * 학기 주차  조회 .
     * @param CrsVO
     * @return TermVO
     * @throws Exception
     */
    public List<CrsTermLessonVO> termLessonList(CrsTermLessonVO vo) throws Exception;
    
    /**
     * 학기 모든 목록 .
     * @param termVO 
     * @param CrsTermLessonVO
     * @return List
     * @throws Exception
     */
    public List<TermVO> list(TermVO vo) throws Exception;
    public List<TermVO> listHaksaTerm(TermVO vo) throws Exception;

    /**
     * 종료 아닌 학기의 모든 목록 .
     * @param termVO 
     * @param CrsTermLessonVO
     * @return List
     * @throws Exception
     */
    public List<TermVO> listTermStatus(TermVO vo) throws Exception;

    /**
     * 학기 모든 목록 .
     * @param termVO 
     * @param CrsTermLessonVO
     * @return List
     * @throws Exception
     */
    public List<TermVO> listTermRltn(TermVO vo) throws Exception;

    /**
     * 학기 조회 .
     * @param termVO 
     * @return vo
     * @throws Exception
     */
    public TermVO termRltnView(TermVO vo) throws Exception;

    /***************************************************** 
     * 마이페이지 > 수강, 강의 리스트(학기부분에서 사용)
     * @param vo
     * @return
     ******************************************************/  
    public List<TermVO> listHomeTermStatus(TermVO vo) throws Exception;
    
    public List<TermVO> selectListHomeTermStatus(TermVO vo) throws Exception;
    
    public List<TermVO> listTermByProf(TermVO vo) throws Exception;
    
    public TermVO selectTermByCrsCreCd(TermVO vo) throws Exception;
    
    public TermVO selectCurrentTerm(TermVO vo) throws Exception;
    
    public TermVO selectCurTermLesson(TermVO vo) throws Exception;
    
    public TermVO select(TermVO vo) throws Exception;
    
    /**
     * 학사년도, 학기별  학기 정보 조회
     * @param  TermVO 
     * @return TermVO
     * @throws Exception
     */
    public TermVO selectTermByHaksa(TermVO vo) throws Exception;
    
    public List<TermVO> selectListTermStatus(TermVO termVo) throws Exception;
    
    public List<TermVO> selectListTermRltn(TermVO termVo) throws Exception;
    
    // 법정교육, 공개강좌 사용
    public List<TermVO> selectListStatus(TermVO termVo) throws Exception;
    
    public TermVO selectUniTermByTermLink(TermVO vo) throws Exception;
    
    public List<TermVO> listCreYearByProf(TermVO vo) throws Exception;
    
    public List<TermVO> listCreYearByProfCourse(TermVO vo) throws Exception;
    
    public List<CrsTermLessonVO> listTermLesson(TermVO vo) throws Exception;
    
    public void saveTermLesson(HttpServletRequest request, List<CrsTermLessonVO> list) throws Exception;
}
