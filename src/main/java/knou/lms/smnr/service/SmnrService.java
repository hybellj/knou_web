package knou.lms.smnr.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.smnr.vo.SmnrVO;

public interface SmnrService {

	/**
     * 교수세미나목록조회
     *
     * @param sbjctId	 	과목아이디
     * @param searchValue  	검색내용(세미나명)
     * @return 세미나목록 페이징
     * @throws Exception
     */
    public ProcessResultVO<EgovMap> profSmnrListPaging(SmnrVO vo) throws Exception;

    /**
     * 세미나등록
     *
     * @param SmnrVO				세미나정보
     * @param Map<String, String>	부가정보
     * @throws Exception
     */
    public void smnrRegist(SmnrVO vo, Map<String, String> subMap) throws Exception;

    /**
     * 세미나수정
     *
     * @param SmnrVO				세미나정보
     * @param Map<String, String>	부가정보
     * @throws Exception
     */
    public void smnrModify(SmnrVO vo, Map<String, String> subMap) throws Exception;

    /**
     * 세미나삭제
     *
     * @param SmnrVO		세미나정보
     * @throws Exception
     */
    public void smnrDelete(SmnrVO vo) throws Exception;

    /**
     * 세미나성적반영비율수정
     *
     * @param sbjctId	과목아이디
     * @param mdfrId	수정자아이디
     * @throws Exception
     */
    public void smnrMrkRfltrtModify(SmnrVO vo) throws Exception;

    /**
	 * 세미나성적반영비율목록수정
	 *
	 * @param List<SmnrVO>
	 * @throws Exception
	 */
	public void smnrMrkRfltrtListModify(List<SmnrVO> list) throws Exception;

	/**
     * 세미나세부정보수정
     *
     * @param SmnrVO	세미나정보
     * @throws Exception
     */
	public void smnrDtlModify(SmnrVO vo) throws Exception;

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
	 * @return 세미나정보
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

}
