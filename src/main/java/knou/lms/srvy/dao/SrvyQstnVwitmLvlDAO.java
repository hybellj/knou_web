package knou.lms.srvy.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyQstnVwitmLvlVO;

@Mapper("srvyQstnVwitmLvlDAO")
public interface SrvyQstnVwitmLvlDAO {

	/**
	 * 설문문항목록보기항목레벨삭제
	 *
	 * @param List<SrvyQstnVO>
	 * @throws Exception
	 */
	public void srvyQstnListVwitmLvlDelete(List<SrvyQstnVO> list) throws Exception;

	/**
	 * 설문문항보기항목레벨일괄등록
	 *
	 * @param SrvyVwitmVO
	 * @throws Exception
	 */
	public void srvyQstnVwitmLvlBulkRegist(List<SrvyQstnVwitmLvlVO> list) throws Exception;

	/**
	 * 설문문항보기항목레벨삭제
	 *
	 * @param srvyQstnId 설문문항아이디
	 * @throws Exception
	 */
	public void srvyQstnVwitmLvlDelete(@Param("srvyQstnId") String srvyQstnId) throws Exception;

	/**
	 * 설문문항보기항목레벨목록조회
	 *
	 * @param srvyQstnId 설문문항아이디
	 * return 설문문항보기항목레벨목록
	 * @throws Exception
	 */
	public List<SrvyQstnVwitmLvlVO> srvyQstnVwitmLvlList(@Param("srvyQstnId") String srvyQstnId) throws Exception;

	/**
	 * 설문보기항목가져오기
	 *
	 * @param copySrvyQstnId 	복사설문문항아이디
	 * @param srvyQstnId 		설문문항아이디
	 * @throws Exception
	 */
	public void srvyQstnVwitmLvlCopy(List<Map<String, Object>> list) throws Exception;

	/**
	 * 설문문항보기항목레벨일괄조회
	 *
	 * @param srvyId 설문아이디
	 * return 설문문항보기항목레벨일괄목록
	 * @throws Exception
	 */
	public List<SrvyQstnVwitmLvlVO> srvyQstnVwitmLvlBulkList(@Param("srvyId") String srvyId) throws Exception;

}
