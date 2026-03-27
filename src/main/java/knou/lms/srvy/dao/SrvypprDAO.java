package knou.lms.srvy.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.vo.SrvypprVO;

@Mapper("srvypprDAO")
public interface SrvypprDAO {

	/**
	* 설문지목록조회
	*
	* @param srvyId		설문아이디
	* @param searchType	조회유형
	* @return 설문지목록
	* @throws Exception
	*/
	public List<SrvypprVO> srvypprList(@Param("srvyId") String srvyId, @Param("searchType") String searchType) throws Exception;

	/**
	* 설문지조회
	*
	* @param srvypprId	설문지아이디
	* @return 설문지정보
	* @throws Exception
	*/
	public SrvypprVO srvypprSelect(@Param("srvypprId") String srvypprId) throws Exception;

	/**
	 * 설문지등록
	 *
	 * @param SrvypprVO
	 * @throws Exception
	 */
	public void srvypprRegist(SrvypprVO vo) throws Exception;

	/**
	* 설문지참여수조회
	*
	* @param sbjctId	과목아이디
	* @param srvyId		설문아이디
	* @param srvypprId	설문지아이디
	* @return 설문지참여수
	* @throws Exception
	*/
	public int srvypprPtcpCntSelect(SrvypprVO vo) throws Exception;

	/**
	* 설문지삭제
	*
	* @param srvypprId	설문지아이디
	* @throws Exception
	*/
	public void srvypprDelete(@Param("srvypprId") String srvypprId) throws Exception;

	/**
	* 설문지미삭제순번수정
	*
	* @param srvypprId	설문지아이디
	* @param srvySeqno	설문지순번
	* @throws Exception
	*/
	public void srvypprDelNSeqnoModify(SrvypprVO vo) throws Exception;

	/**
	 * 설문지순번수정
	 *
	 * @param srvyId 	설문아이디
     * @param srvySeqno 변경할 설문지순번
     * @param searchKey 설문지순번
	 * @throws Exception
	 */
	public void srvySeqnoModify(SrvypprVO vo) throws Exception;

	/**
	* 설문지전체삭제
	*
	* @param SrvyVO
	* @throws Exception
	*/
	public void srvypprAllDelete(SrvyVO vo) throws Exception;

	/**
	 * 설문지일괄등록
	 *
	 * @param List<SrvypprVO>
	 * @throws Exception
	 */
	public void srvypprBulkRegist(List<SrvypprVO> vo) throws Exception;

}
