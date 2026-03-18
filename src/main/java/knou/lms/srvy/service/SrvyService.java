package knou.lms.srvy.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.srvy.vo.SrvyVO;

public interface SrvyService {

	/**
     * 교수설문목록조회
     *
     * @param sbjctId	 	과목아이디
     * @param searchValue  	검색내용(설문명)
     * @return 설문목록 페이징
     * @throws Exception
     */
    public ProcessResultVO<EgovMap> profSrvyListPaging(SrvyVO vo) throws Exception;

    /**
     * 설문등록
     *
     * @param SrvyVO				설문정보
     * @param Map<String, String>	부가정보
     * @throws Exception
     */
    public SrvyVO srvyRegist(SrvyVO vo, Map<String, String> subMap) throws Exception;

    /**
     * 설문수정
     *
     * @param SrvyVO				설문정보
     * @param Map<String, String>	부가정보
     * @throws Exception
     */
    public SrvyVO srvyModify(SrvyVO vo, Map<String, String> subMap) throws Exception;

    /**
     * 설문성적반영비율수정
     *
     * @param sbjctId	과목아이디
     * @param mdfrId	수정자아이디
     * @throws Exception
     */
    public void srvyMrkRfltrtModify(SrvyVO vo) throws Exception;

    /**
	 * 과목성적공개설문수조회
	 *
	 * @param sbjctId	과목아이디
	 * @throws Exception
	 */
	public Integer sbjctMrkOynSrvyCntSelect(SrvyVO vo) throws Exception;

	/**
     * 설문세부정보수정
     *
     * @param SrvyVO	설문정보
     * @throws Exception
     */
	public void srvyDtlModify(SrvyVO vo) throws Exception;

	/**
	 * 설문성적반영비율목록수정
	 *
	 * @param List<SrvyVO>
	 * @throws Exception
	 */
	public void srvyMrkRfltrtListModify(List<SrvyVO> list) throws Exception;

	/**
	* 설문그룹과목목록조회
	*
	* @param srvyId 	설문아이디
	* @return 과목 목록
	* @throws Exception
	*/
	public List<EgovMap> srvyGrpSbjctList(String srvyId) throws Exception;

	/**
	* 설문조회
	*
	* @param SrvyVO
	* @return 설문정보
	* @throws Exception
	*/
	public EgovMap srvySelect(SrvyVO vo) throws Exception;

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
	* @param sbjctId 		과목아이디
	* @param searchValue 	검색내용(설문명)
	* @return 설문목록
	* @throws Exception
	*/
	public List<EgovMap> profAuthrtSbjctSrvyList(Map<String, Object> params) throws Exception;

	/**
     * 설문삭제
     *
     * @param srvyId		설문아이디
     * @param mdfrId		수정자아이디
     * @throws Exception
     */
	public void srvyDelete(SrvyVO vo) throws Exception;

	/**
	* 설문팀목록조회
	*
	* @param srvyId 	설문아이디
	* @return 설문팀목록
	* @throws Exception
	*/
	public List<EgovMap> srvyTeamList(String srvyId) throws Exception;

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
	public List<SrvyVO> qstnCopySrvyList(String sbjctId) throws Exception;

	/**
     * 설문문제출제완료수정
     *
     * @param upSrvyId   	상위설문아이디
     * @param srvyId   		설문아이디
     * @param srvyGbncd   	설문팀구분코드 ( SRVY_TEAM, SRVY )
     * @param searchGubun 	수정상태 ( save, edit )
     * @param searchKey 	( bsc, dtl )
     * @throws Exception
     */
	public void srvyQstnsCmptnModify(SrvyVO vo) throws Exception;

}
