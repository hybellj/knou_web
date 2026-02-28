package knou.lms.crs.crs.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.crs.vo.CrsInfoCntsVO;
import knou.lms.crs.crs.vo.CrsVO;

@Mapper("crsDAO")
public interface CrsDAO {

    public List<CrsVO> selectCrsList(CrsVO vo) throws Exception;
    public void updateUseYn(CrsVO vo) throws Exception;
    public List<EgovMap> selectCrsListExcelDown(CrsVO vo) throws Exception;
    public void deleteCrs(CrsVO vo) throws Exception;
    public int selectCrsNmCheck(CrsVO vo) throws Exception;
    public void multiCrs(CrsVO vo) throws Exception;
    
    // LMS 다른 메뉴들에서 호출해서 사용하는 메서드
    public CrsVO selectCrs(CrsVO vo) throws Exception;
    public List<CrsVO> selectCrsByCrsCreCd(CreCrsVO vo) throws Exception;
    public List<CrsVO> selectCrsByUserId(CreCrsVO vo) throws Exception;
    public CrsVO selectCrsInfo(CrsVO vo) throws Exception;
    public List<CrsVO> selectList(CrsVO vo) throws Exception;
    public CrsVO selectCrsView(CrsVO vo) throws Exception;

    /**
     * 기관 정보 목록
     * @param CrsVO
     * @return List<CrsVO>
     * @throws Exception
     */
    public List<CrsVO> list(CrsVO vo) throws Exception;
    
    /**
     *  과목 목록
     * @param CrsVO
     * @return List
     * @throws Exception
     */
    public List<CrsVO> crsListPageing(CrsVO vo);
    
    /**
     *  과목 목록 > 사용여부 토글
     * @param CrsVO
     * @return ProcessResultVO
     * @throws Exception
     */
    public int editUseYn(CrsVO vo) throws Exception;
    
    /**
     *  과목 등록
     * @param CrsVO
     * @return int
     * @throws Exception
     */
    public void insert(CrsVO vo) throws Exception;

    /**
     *  과목 수정
     * @param CrsVO
     * @return int
     * @throws Exception
     */
    public void update(CrsVO vo) throws Exception;

    /**
     *  과목 삭제
     * @param CrsVO
     * @return void
     * @throws Exception
     */
    public void delete(CrsVO vo) throws Exception;
    
    /**
     * 비교과 상세보기 > 강의 미리보기
    * @param CrsInfoCntsVO
    * @return List<CrsInfoCntsVO>
    * @throws Exception
    */
   public List<CrsInfoCntsVO> listCrsPreview(CrsInfoCntsVO vo) throws Exception;
   
   /**
    * 미리보기 등록
   * @param CrsVO
   * @return void
   * @throws Exception
   */
  public void mergeCrsInfoCnts(CrsVO vo) throws Exception;

  /**
    * 미리보기 삭제
   * @param CrsVO
   * @return void
   * @throws Exception
   */
  public void deleteCrsInfoCnts(CrsVO vo) throws Exception;
  
  /**
   * 외부기관의 과정번호 생성
   * @param CrsVO
   * @return String
   * @throws Exception
   */
  public String selectNewCrsCd(CrsVO vo) throws Exception;
}
