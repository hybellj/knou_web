package knou.lms.smnr.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.smnr.vo.SmnrVO;

@Mapper("smnrDAO")
public interface SmnrDAO {

	/**
	* 교수세미나목록조회
	*
	* @param sbjctId 		과목아이디
	* @param searchValue 	검색내용(세미나명)
	* @param listScale	 	페이지크기
	* @return 세미나목록 페이징
	* @throws Exception
	*/
	public List<EgovMap> profSmnrListPaging(SmnrVO vo) throws Exception;

	/**
	 * 세미나등록
	 *
	 * @param SmnrVO
	 * @throws Exception
	 */
	public void smnrRegist(SmnrVO vo) throws Exception;

	/**
	 * 세미나수정
	 *
	 * @param SmnrVO
	 * @throws Exception
	 */
	public void smnrModify(SmnrVO vo) throws Exception;

	/**
	 * 세미나삭제여부수정
	 *
	 * @param SmnrVO
	 * @throws Exception
	 */
	public void smnrDelynModify(SmnrVO vo) throws Exception;

	/**
	 * 성적반영세미나목록조회
	 *
	 * @param sbjctId	과목아이디
	 * @return 성적반영세미나목록
	 * @throws Exception
	 */
	public List<SmnrVO> mrkRfltSmnrList(SmnrVO vo) throws Exception;

	/**
	 * 세미나성적반영비율목록수정
	 *
	 * @param List<SmnrVO>
	 * @throws Exception
	 */
	public void smnrMrkRfltrtListModify(List<SmnrVO> list) throws Exception;

	/**
	 * 세미나일괄등록
	 *
	 * @param List<SmnrVO>
	 * @throws Exception
	 */
	public void smnrBulkRegist(List<SmnrVO> vo) throws Exception;

	/**
	 * 세미나대상수강생목록
	 *
	 * @param smnrId	세미나아이디
	 * @return 세미나대상수강생목록
	 * @throws Exception
	 */
	public List<EgovMap> smnrTrgtAtndlcUserList(SmnrVO vo) throws Exception;

	/**
	 * 세미나조회
	 *
	 * @param smnrId	세미나아이디
	 * @return 세미나정보  smnrLrnGrpSubSmnrList
	 * @throws Exception
	 */
	public EgovMap smnrSelect(SmnrVO vo) throws Exception;

	/**
	* 세미나학습그룹부세미나목록조회
	*
	* @param lrnGrpId 	학습그룹아이디
	* @param smnrId 	세미나아이디
	* @return 세미나학습그룹부세미나목록
	* @throws Exception
	*/
	public List<EgovMap> smnrLrnGrpSubSmnrList(Map<String, Object> params) throws Exception;

	/**
	 * 하위세미나삭제
	 *
	 * @param smnrId	세미나아이디
	 * @throws Exception
	 */
	public void subSmnrDelete(@Param("smnrId") String smnrId) throws Exception;

}
