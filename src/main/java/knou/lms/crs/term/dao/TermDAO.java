package knou.lms.crs.term.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.crs.term.vo.CrsTermLessonVO;
import knou.lms.crs.term.vo.TermVO;

@Mapper("termDAO")
public interface TermDAO {

    /**
    * 학기 정보 등록. 
    * @param  CrsVO 
    * @return List
    * @throws Exception
    */
   public void insert(TermVO vo) throws Exception;
   
    /**
    * 학기 정보 수정. 
    * @param  CrsVO 
    * @return List
    * @throws Exception
    */
   public void update(TermVO vo)throws Exception;
   
   /**
   * 학기 정보 수정 시 개설과목에 관련 정보 반영. 
   * @param  TermVO 
   * @return List
   * @throws Exception
   */
  public void updateCreCrs(TermVO vo)throws Exception; 
   
   /**
    * 학기 삭제 시 하위 학기 주차 전부 삭제 .
    * @param termVO 
    * @return vo
    * @throws Exception
    */
   public void deleteTermLesson(TermVO vo) throws Exception;
   
    /**
    * 학기 정보 삭제. 
    * @param  CrsVO 
    * @return void
    * @throws Exception
    */
   public void delete(TermVO vo) throws Exception;

    /**
    * 학기 목록 조회. 
    * @param  CrsVO 
    * @return List
    * @throws Exception
    */
   public TermVO select(TermVO vo) throws Exception;
   
   /**
    * 학기 정보의 전체 목록을 조회한다. 
    * @param listScale 
    * @param pageIndex 
    * @param  CrsVO 
    * @return List
    * @throws Exception
    */
   public List<TermVO> listPageing(TermVO vo) throws Exception;
   public int countPageing(TermVO vo) throws Exception;

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
    * 학기 주차 조회한다. 
    * @param  CrsVO 
    * @return List
    * @throws Exception
    */
   public List<CrsTermLessonVO> termLessonSelect(CrsTermLessonVO vo)throws Exception;

   public int editCurTermYn(TermVO vo) throws Exception;
   public int notEditCurTermYn(TermVO vo) throws Exception;

   /**
    * 학기 주차 조회한다. 
    * @param  CrsTermLessonVO 
    * @return 
    * @throws Exception
    */
   public void crsTermUpdate(CrsTermLessonVO vo)throws Exception;
   
   /**
    * 학기 모든 목록 .
    * @param termVO 
    * @param 
    * @return List<TermVO>
    * @throws Exception
    */
   public List<TermVO> listTermStatus(TermVO termVO) throws Exception;
   
   /**
    * 학기 모든 목록 .
    * @param termVO 
    * @param 
    * @return List<TermVO>
    * @throws Exception
    */
   public List<TermVO> list(TermVO termVO) throws Exception;
   public List<TermVO> listHaksaTerm(TermVO vo) throws Exception;

   /**
    * 학기 조인 목록 .
    * @param termVO 
    * @param 
    * @return List
    * @throws Exception
    */
   public List<TermVO> listTermRltn(TermVO termVO) throws Exception;

   /**
    * 학기 조회 .
    * @param termVO 
    * @return vo
    * @throws Exception
    */
   public TermVO termRltnView(TermVO vo) throws Exception;

   /***************************************************** 
    *수강, 강의 리스트(학기부분에서 사용).
    * @param vo
    * @return
    ******************************************************/ 
    public List<TermVO> listHomeTermStatus(TermVO vo)  throws Exception;
    
    public List<TermVO> selectListHomeTermStatus(TermVO vo) throws Exception;
    
    public List<TermVO> listTermByProf(TermVO vo) throws Exception;
    
    public TermVO selectTermByCrsCreCd(TermVO vo) throws Exception;
    
    public TermVO selectCurrentTerm(TermVO vo) throws Exception;
    
    public TermVO selectCurTermLesson(TermVO vo) throws Exception;
    
    /**
     * 학사년도, 학기별  학기 정보 조회
     * @param  TermVO 
     * @return TermVO
     * @throws Exception
     */
    public TermVO selectTermByHaksa(TermVO vo) throws Exception;
  
    public List<TermVO> selectListTermStatus(TermVO termVo) throws Exception;
    
    public List<TermVO> selectListTermRltn(TermVO termVo) throws Exception;
    
    public List<TermVO> selectListStatus(TermVO termVo) throws Exception;
    
    public TermVO selectUniTermByTermLink(TermVO vo) throws Exception;
    
    public List<TermVO> listCreYearByProf(TermVO vo) throws Exception;
    
    public List<TermVO> listCreYearByProfCourse(TermVO vo) throws Exception;
    
    public List<CrsTermLessonVO> listTermLesson(TermVO vo) throws Exception;

    public void mergeTermLessonList(List<CrsTermLessonVO> list) throws Exception;
    
    public void deleteTermLessonNotInclude(CrsTermLessonVO vo) throws Exception;
}
