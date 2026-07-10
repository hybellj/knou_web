package knou.lms.srvy.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.srvy.dao.SrvyRspnsDAO;
import knou.lms.srvy.service.SrvyRspnsService;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyRspnsVO;

@Service("srvyRspnsService")
public class SrvyRspnsServiceImpl extends ServiceBase implements SrvyRspnsService {

	@Resource(name="srvyRspnsDAO")
	private SrvyRspnsDAO srvyRspnsDAO;

	/**
	 * 설문문항목록답변삭제
	 *
	 * @param List<SrvyQstnVO>
	 */
	@Override
	public void srvyQstnListRspnsDelete(List<SrvyQstnVO> list) {
		srvyRspnsDAO.srvyQstnListRspnsDelete(list);
	}

	/**
	* 설문선택형문항답변현황목록
	*
	* @param sbjctId 		과목아이디
	* @param srvyId 		설문아이디
	* @param searchType 	조회유형
	* @return 설문선택형문항답변현황목록
	*/
	@Override
	public List<EgovMap> srvyChcQstnRspnsStatusList(String sbjctId, String srvyId, String searchType) {
		return srvyRspnsDAO.srvyChcQstnRspnsStatusList(sbjctId, srvyId, searchType);
	}

	/**
	 * 설문서술형문항답변현황목록
	 *
	 * @param sbjctId 		과목아이디
	 * @param srvyId 		설문아이디
	 * @param searchType 	조회유형
	 * @return 설문서술형문항답변현황목록
	 */
	@Override
	public List<EgovMap> srvyTextQstnRspnsStatusList(String sbjctId, String srvyId, String searchType) {
		return srvyRspnsDAO.srvyTextQstnRspnsStatusList(sbjctId, srvyId, searchType);
	}

	/**
	 * 설문레벨형문항답변현황목록
	 *
	 * @param sbjctId 		과목아이디
	 * @param srvyId 		설문아이디
	 * @param searchType 	조회유형
	 * @return 설문레벨형문항답변현황목록
	 */
	@Override
	public List<EgovMap> srvyLevelQstnRspnsStatusList(String sbjctId, String srvyId, String searchType) {
		return srvyRspnsDAO.srvyLevelQstnRspnsStatusList(sbjctId, srvyId, searchType);
	}

	/**
	 * 설문엑셀다운문항목록
	 *
	 * @param srvyId 		설문아이디
	 * @return 설문엑셀다운문항목록
	 */
	@Override
	public List<EgovMap> srvyExcelDownQstnList(String srvyId) {
		return srvyRspnsDAO.srvyExcelDownQstnList(srvyId);
	}

	/**
	 * 설문엑셀다운문항답변목록
	 *
	 * @param srvyId 		설문아이디
	 * @return 설문엑셀다운문항답변목록
	 */
	@Override
	public List<EgovMap> srvyExcelDownQstnRspnsList(String srvyId) {
		return srvyRspnsDAO.srvyExcelDownQstnRspnsList(srvyId);
	}

	/**
	 * 설문강의평가엑셀다운문항답변목록
	 *
	 * @param srvyId 		설문아이디
	 * @return 설문강의평가엑셀다운문항답변목록
	 */
	@Override
	public List<EgovMap> srvylctrEvlExcelDownQstnRspnsList(String srvyId) {
		return srvyRspnsDAO.srvylctrEvlExcelDownQstnRspnsList(srvyId);
	}

	/**
	 * 설문답변목록
	 *
	 * @param srvyPtcpId 	설문참여아이디
	 * @param srvyId 		설문아이디
	 * @param userId 		사용자아이디
	 * @return 설문답변목록
	 */
	@Override
	public List<SrvyRspnsVO> srvyRspnsList(String srvyPtcpId, String srvyId, String userId) {
		return srvyRspnsDAO.srvyRspnsList(srvyPtcpId, srvyId, userId);
	}

	/**
	 * 설문문항답변분포목록
	 *
	 * @param sbjctId 		과목아이디
	 * @param srvyId 		설문아이디
	 * @param srvypprId 	설문지아이디
	 * @param srvyQstnId 	설문문항아이디
	 * @return 설문문항답변분포목록
	 */
	@Override
	public List<EgovMap> srvyQstnRspnsDistributionList(String sbjctId, String srvyId, String srvypprId, String srvyQstnId) {
		return srvyRspnsDAO.srvyQstnRspnsDistributionList(sbjctId, srvyId, srvypprId, srvyQstnId);
	}

	/**
	* 강의평가선택형문항답변현황목록
	*
    * @param srvyId			설문아이디
    * @param orgId  		기관아이디
    * @param smstrChrtId	학기기수아이디
    * @param sbjctId		과목아이디
    * @param srvyPtcp		참여여부
    * @param searchValue	검색어 ( 이름, 학번 )
	* @return 강의평가선택형문항답변현황목록
	*/
	@Override
	public List<EgovMap> lctrEvlChcQstnRspnsStatusList(Map<String, Object> params) {
		return srvyRspnsDAO.lctrEvlChcQstnRspnsStatusList(params);
	}

	/**
	* 강의평가서술형문항답변현황목록
	*
    * @param srvyId			설문아이디
    * @param orgId  		기관아이디
    * @param smstrChrtId	학기기수아이디
    * @param sbjctId		과목아이디
    * @param srvyPtcp		참여여부
    * @param searchValue	검색어 ( 이름, 학번 )
	* @return 강의평가서술형문항답변현황목록
	*/
	@Override
	public List<EgovMap> lctrEvlTextQstnRspnsStatusList(Map<String, Object> params) {
		return srvyRspnsDAO.lctrEvlTextQstnRspnsStatusList(params);
	}

	/**
	* 강의평가레벨형문항답변현황목록
	*
    * @param srvyId			설문아이디
    * @param orgId  		기관아이디
    * @param smstrChrtId	학기기수아이디
    * @param sbjctId		과목아이디
    * @param srvyPtcp		참여여부
    * @param searchValue	검색어 ( 이름, 학번 )
	* @return 강의평가레벨형문항답변현황목록
	*/
	@Override
	public List<EgovMap> lctrEvlLevelQstnRspnsStatusList(Map<String, Object> params) {
		return srvyRspnsDAO.lctrEvlLevelQstnRspnsStatusList(params);
	}

	/**
	* 전체설문선택형문항답변현황목록
	*
    * @param srvyId			설문아이디
    * @param orgId  		기관아이디
    * @param smstrChrtId	학기기수아이디
    * @param srvyTrgtTycd	설문대상유형코드
    * @param srvyPtcp		참여여부
    * @param searchValue	검색어 ( 이름, 학번 )
	* @return 전체설문선택형문항답변현황목록
	*/
	@Override
	public List<EgovMap> wholSrvyChcQstnRspnsStatusList(Map<String, Object> params) {
		return srvyRspnsDAO.wholSrvyChcQstnRspnsStatusList(params);
	}

	/**
	* 전체설문서술형문항답변현황목록
	*
    * @param srvyId			설문아이디
    * @param orgId  		기관아이디
    * @param smstrChrtId	학기기수아이디
    * @param srvyTrgtTycd	설문대상유형코드
    * @param srvyPtcp		참여여부
    * @param searchValue	검색어 ( 이름, 학번 )
	* @return 전체설문서술형문항답변현황목록
	*/
	@Override
	public List<EgovMap> wholSrvyTextQstnRspnsStatusList(Map<String, Object> params) {
		return srvyRspnsDAO.wholSrvyTextQstnRspnsStatusList(params);
	}

	/**
	* 전체설문레벨형문항답변현황목록
	*
    * @param srvyId			설문아이디
    * @param orgId  		기관아이디
    * @param smstrChrtId	학기기수아이디
    * @param srvyTrgtTycd	설문대상유형코드
    * @param srvyPtcp		참여여부
    * @param searchValue	검색어 ( 이름, 학번 )
	* @return 전체설문레벨형문항답변현황목록
	*/
	@Override
	public List<EgovMap> wholSrvyLevelQstnRspnsStatusList(Map<String, Object> params) {
		return srvyRspnsDAO.wholSrvyLevelQstnRspnsStatusList(params);
	}

}
