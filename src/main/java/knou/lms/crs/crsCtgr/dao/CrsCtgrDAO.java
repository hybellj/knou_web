package knou.lms.crs.crsCtgr.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.crs.crsCtgr.vo.CreTmCtgrVO;
import knou.lms.crs.crsCtgr.vo.CrsCtgrVO;

@Mapper("crsCtgrDAO")
public interface CrsCtgrDAO {
    
    /**
     * 교과별 분류 리스트.
     * @param CrsCtgrVO
     * @return List<CrsCtgrVO>
     * @throws Exception
     */
    public List<CrsCtgrVO> listCrsCtgr(CrsCtgrVO vo) throws Exception;
    
	/**
	 *  교과별 분류 순서를 매칭
	 * @param CrsCtgrVO
	 * @return CrsCtgrVO
	 * @throws Exception
	 */
	public List<CrsCtgrVO> ctgrTree(CrsCtgrVO vo) throws Exception;

	/**
     *  과목 분류 부모값 조회
     * @param CrsCtgrVO
     * @return CrsCtgrVO
     * @throws Exception
     */
    public CrsCtgrVO selectParCrsCtgrCd(CrsCtgrVO vo) throws Exception;

    /**
     *  테마 분류 부모값 조회
     * @param CreTmCtgrVO
     * @return CreTmCtgrVO
     * @throws Exception
     */
    public CreTmCtgrVO selectParCreTmCtgrCd(CreTmCtgrVO vo) throws Exception;
    
    /**
     * 교과별 분류 리스트.
     * @param CrsCtgrVO
     * @return List<CreTmCtgrVO>
     * @throws Exception
     */
    public List<CreTmCtgrVO> listCreTmCtgr(CreTmCtgrVO vo) throws Exception;
}
