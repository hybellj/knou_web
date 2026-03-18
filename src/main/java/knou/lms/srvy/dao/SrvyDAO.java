package knou.lms.srvy.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.srvy.vo.SrvyVO;

@Mapper("srvyDAO")
public interface SrvyDAO {

	/**
	* 교수설문목록조회
	*
	* @param sbjctId 		과목아이디
	* @param searchValue 	검색내용(설문명)
	* @param listScale	 	페이지크기
	* @return 설문목록 페이징
	* @throws Exception
	*/
	public List<EgovMap> profSrvyListPaging(SrvyVO vo) throws Exception;

	/**
	 * 과목성적공개설문수조회
	 *
	 * @param sbjctId 	과목아이디
	 * @param srvyId 	설문아이디
	 * @throws Exception
	 */
	public int sbjctMrkOynSrvyCntSelect(@Param("sbjctId") String sbjctId, @Param("srvyId") String srvyId) throws Exception;

	/**
	 * 성적반영설문목록조회
	 *
	 * @param sbjctId	과목아이디
	 * @return 성적반영설문목록
	 * @throws Exception
	 */
	public List<SrvyVO> mrkRfltSrvyList(SrvyVO vo) throws Exception;

	/**
	 * 설문성적반영비율목록수정
	 *
	 * @param List<SrvyVO>
	 * @throws Exception
	 */
	public void srvyMrkRfltrtListModify(List<SrvyVO> list) throws Exception;

	/**
	 * 설문등록
	 *
	 * @param SrvyVO
	 * @throws Exception
	 */
	public void srvyRegist(SrvyVO vo) throws Exception;

	/**
	 * 설문수정
	 *
	 * @param SrvyVO
	 * @throws Exception
	 */
	public void srvyModify(SrvyVO vo) throws Exception;

	/**
	* 설문그룹과목목록조회
	*
	* @param srvyId 	설문아이디
	* @return 설문그룹과목목록
	* @throws Exception
	*/
	public List<EgovMap> srvyGrpSbjctList(@Param("srvyId") String srvyId) throws Exception;

	/**
	* 설문조회
	*
	* @param SrvyVO
	* @return 설문정보
	* @throws Exception
	*/
	public EgovMap srvySelect(SrvyVO vo) throws Exception;

	/**
	 * 하위설문삭제
	 *
	 * @param srvyId	설문아이디
	 * @throws Exception
	 */
	public void subSrvyDelete(@Param("srvyId") String srvyId) throws Exception;

	/**
	 * 하위설문삭제여부수정
	 *
	 * @param SrvyVO
	 * @throws Exception
	 */
	public void subSrvyDelynModify(SrvyVO vo) throws Exception;

	/**
	* 설문팀목록조회
	*
	* @param srvyId 	설문아이디
	* @return 설문팀목록
	* @throws Exception
	*/
	public List<EgovMap> srvyTeamList(@Param("srvyId") String srvyId) throws Exception;

	/**
	* 설문아이디조회
	*
	* @param srvyGrpId		설문그룹아이디
	* @param sbjctId		과목아이디
	* @return srvyId 		설문기본아이디
	* @throws Exception
	*/
	public String srvyIdSelect(SrvyVO vo) throws Exception;

	/**
	* 설문학습그룹부과제목록조회
	*
	* @param lrnGrpId 	학습그룹아이디
	* @param srvyId 	설문아이디
	* @return 설문부과제목록
	* @throws Exception
	*/
	public List<EgovMap> srvyLrnGrpSubAsmtList(Map<String, Object> params) throws Exception;

	/**
	* 교수권한과목설문목록조회
	*
	* @param userId 		교수아이디
	* @param smstrChrtId 	학기기수아이디
	* @param sbjctId	 	과목아이디
	* @param searchValue 	검색내용(설문명)
	* @return 설문목록
	* @throws Exception
	*/
	public List<EgovMap> profAuthrtSbjctSrvyList(Map<String, Object> params) throws Exception;

	/**
	* 설문팀문제출제완료여부조회
	*
	* @param srvyId 	설문아이디
	* @throws Exception
	*/
	public Boolean srvyTeamQstnsCmptnynSelect(String srvyId) throws Exception;

	/**
	* 문제가져오기설문목록조회
	*
    * @param sbjctId 		과목이이디
	* @return 설문목록
	* @throws Exception
	*/
	public List<SrvyVO> qstnCopySrvyList(@Param("sbjctId") String sbjctId) throws Exception;

}
