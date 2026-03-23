package knou.lms.srvy.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.srvy.vo.SrvyQstnVO;

@Mapper("srvyQstnDAO")
public interface SrvyQstnDAO {

	/**
	 * 설문문항목록조회
	 *
	 * @param srvyId		설문아이디
	 * @param searchType	조회유형
	 * @return 설문문항목록
	 * @throws Exception
	 */
	public List<EgovMap> srvyQstnList(@Param("srvyId") String srvyId, @Param("searchType") String searchType) throws Exception;

	/**
	 * 설문지문항목록조회
	 *
	 * @param srvypprId		설문지아이디
	 * @return 설문지문항목록
	 * @throws Exception
	 */
	public List<SrvyQstnVO> srvypprQstnList(@Param("srvypprId") String srvypprId) throws Exception;

	/**
	 * 설문지문항삭제
	 *
	 * @param srvypprId		설문지아이디
	 * @throws Exception
	 */
	public void srvypprQstnDelete(@Param("srvypprId") String srvypprId) throws Exception;

	/**
	 * 설문문항등록
	 *
	 * @param SrvyQstnVO
	 * @throws Exception
	 */
	public void srvyQstnRegist(SrvyQstnVO vo) throws Exception;

	/**
	 * 설문문항수정
	 *
	 * @param SrvyQstnVO
	 * @throws Exception
	 */
	public void srvyQstnModify(SrvyQstnVO vo) throws Exception;

	/**
	 * 설문문항미삭제순번수정
	 *
	 * @param SrvyQstnVO
	 * @throws Exception
	 */
	public void srvyQstnDelNSeqnoModify(SrvyQstnVO vo) throws Exception;

	/**
	 * 설문문항조회
	 *
	 * @param srvypprId		설문지아이디
	 * @param srvyQstnId	설문문항아이디
	 * @return 설문문항
	 * @throws Exception
	 */
	public SrvyQstnVO srvyQstnSelect(SrvyQstnVO vo) throws Exception;

	/**
     * 문항순번수정
     *
     * @param srvypprId 	설문지아이디
     * @param qstnSeqno 	변경할 문항순번
     * @param searchKey 	문항순번
     * @throws Exception
     */
	public void qstnSeqnoModify(SrvyQstnVO vo) throws Exception;

	/**
     * 교수문항복사설문문항목록조회
     *
     * @param srvypprId 	설문지아이디
     * @return 설문문항목록
     * @throws Exception
     */
	public List<EgovMap> profQstnCopySrvyQstnList(SrvyQstnVO vo) throws Exception;

	/**
	 * 설문문항가져오기
	 *
	 * @param copySrvyQstnId 	복사설문문항아이디
	 * @param srvyId 			설문아이디
	 * @param srvypprId  		설문지아이디
	 * @throws Exception
	 */
	public void srvyQstnCopy(List<Map<String, Object>> list) throws Exception;

}
