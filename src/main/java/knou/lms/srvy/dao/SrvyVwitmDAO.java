package knou.lms.srvy.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyVwitmVO;

@Mapper("srvyVwitmDAO")
public interface SrvyVwitmDAO {

	/**
	 * 설문문항목록보기항목삭제
	 *
	 * @param List<SrvyQstnVO>
	 * @throws Exception
	 */
	public void srvyQstnListVwitmDelete(List<SrvyQstnVO> list) throws Exception;

	/**
	 * 설문보기항목일괄등록
	 *
	 * @param SrvyVwitmVO
	 * @throws Exception
	 */
	public void srvyVwitmBulkRegist(List<SrvyVwitmVO> list) throws Exception;

	/**
	 * 설문보기항목삭제
	 *
	 * @param srvyQstnId 설문문항아이디
	 * @throws Exception
	 */
	public void srvyVwitmDelete(@Param("srvyQstnId") String srvyQstnId) throws Exception;

	/**
	 * 설문보기항목목록조회
	 *
	 * @param srvyQstnId 설문문항아이디
	 * return 설문보기항목목록
	 * @throws Exception
	 */
	public List<SrvyVwitmVO> srvyVwitmList(@Param("srvyQstnId") String srvyQstnId) throws Exception;

	/**
	 * 설문보기항목가져오기
	 *
	 * @param copySrvyQstnId 	복사설문문항아이디
	 * @param srvyQstnId 		설문문항아이디
	 * @throws Exception
	 */
	public void srvyVwitmCopy(List<Map<String, Object>> list) throws Exception;

	/**
	 * 설문보기항목일괄조회
	 *
	 * @param srvyId 		설문아이디
	 * @param qstnRspnsTycd 문항답변유형코드
	 * return 설문보기항목목록
	 * @throws Exception
	 */
	public List<SrvyVwitmVO> srvyVwitmBulkList(@Param("srvyId") String srvyId, @Param("qstnRspnsTycd") String qstnRspnsTycd) throws Exception;

}
