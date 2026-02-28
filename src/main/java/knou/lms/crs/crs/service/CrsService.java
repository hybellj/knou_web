package knou.lms.crs.crs.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.crs.vo.CrsInfoCntsVO;
import knou.lms.crs.crs.vo.CrsVO;
import knou.lms.org.vo.OrgCodeVO;

public interface CrsService {

    public ProcessResultVO<CrsVO> selectCrsList(CrsVO vo) throws Exception;
    public ProcessResultVO<CrsVO> updateUseYn(CrsVO vo) throws Exception;
    public List<EgovMap> selectCrsListExcelDown(CrsVO vo) throws Exception;
    public ProcessResultVO<CrsVO> deleteCrs(CrsVO vo) throws Exception;
    public int selectCrsNmCheck(CrsVO vo) throws Exception;
    public ProcessResultVO<CrsVO> multiCrs(CrsVO vo) throws Exception;
    
    // LMS 다른 메뉴들에서 호출해서 사용하는 메서드
    public CrsVO selectCrs(CrsVO vo) throws Exception;
    public List<CrsVO> selectCrsByCrsCreCd(CreCrsVO vo) throws Exception;
    public List<CrsVO> selectCrsByUserId(CreCrsVO vo) throws Exception;
    public List<OrgCodeVO> selectOrgCodeList(CreCrsVO vo) throws Exception;
    public CrsVO selectCrsInfo(CrsVO vo) throws Exception;
    public ProcessResultVO<CrsVO> selectList(CrsVO vo) throws Exception;
    public CrsVO selectCrsView(CrsVO vo) throws Exception;

    /**
     * 과목 페이징
     * @param CrsVO
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultListVO
     * @throws Exception
     */
    public ProcessResultListVO<CrsVO> crsListPageing(CrsVO vo, int pageIndex, int listScale, int pageScale) throws Exception;
    public ProcessResultListVO<CrsVO> crsListPageing(CrsVO vo, int pageIndex, int listScale) throws Exception;
    public ProcessResultListVO<CrsVO> crsListPageing(CrsVO vo, int pageIndex) throws Exception;
    
    /**
     *  과목 리스트
     * @param CrsVO
     * @return List
     * @throws Exception
     */
    public List<CrsVO> list(CrsVO vo) throws Exception;
    
    /**
     *  과목 정보 view 조회
     * @param CrsVO
     * @return ProcessResultVO
     * @throws Exception
     */
    public ProcessResultVO<CrsVO> viewCrs(CrsVO vo) throws Exception;
    
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
     * @return ProcessResultVO
     * @throws Exception
     */
    public void add(CrsVO vo) throws Exception;

    /**
     *  과목 수정
     * @param CrsVO
     * @return 
     * @throws Exception
     */
    public void edit(CrsVO vo) throws Exception;

    /**
     *  과목 삭제
     * @param CrsVO
     * @return ProcessResultVO
     * @throws Exception
     */
    public void remove(CrsVO vo) throws Exception;
    
    /**
     * 비교과 상세보기 > 강의 미리보기
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CrsInfoCntsVO> listCrsPreview(CrsInfoCntsVO vo) throws Exception;

    /**
     * 외부기관의 과정번호 생성
     * @param CrsVO
     * @return String
     * @throws Exception
     */
    public String selectNewCrsCd(CrsVO vo) throws Exception;
}
