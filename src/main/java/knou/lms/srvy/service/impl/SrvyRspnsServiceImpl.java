package knou.lms.srvy.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.srvy.dao.SrvyRspnsDAO;
import knou.lms.srvy.service.SrvyRspnsService;
import knou.lms.srvy.vo.SrvyQstnVO;

@Service("srvyRspnsService")
public class SrvyRspnsServiceImpl extends ServiceBase implements SrvyRspnsService {

	@Resource(name="srvyRspnsDAO")
	private SrvyRspnsDAO srvyRspnsDAO;

	/**
	 * 설문문항목록답변삭제
	 *
	 * @param List<SrvyQstnVO>
	 * @throws Exception
	 */
	@Override
	public void srvyQstnListRspnsDelete(List<SrvyQstnVO> list) throws Exception {
		srvyRspnsDAO.srvyQstnListRspnsDelete(list);
	}

	/**
	* 설문선택형문항답변현황목록
	*
	* @param sbjctId 		과목아이디
	* @param srvyId 		설문아이디
	* @param searchType 	조회유형
	* @return 설문선택형문항답변현황목록
	* @throws Exception
	*/
	@Override
	public List<EgovMap> srvyChcQstnRspnsStatusList(String sbjctId, String srvyId, String searchType) throws Exception {
		return srvyRspnsDAO.srvyChcQstnRspnsStatusList(sbjctId, srvyId, searchType);
	}

	/**
	 * 설문서술형문항답변현황목록
	 *
	 * @param sbjctId 		과목아이디
	 * @param srvyId 		설문아이디
	 * @param searchType 	조회유형
	 * @return 설문서술형문항답변현황목록
	 * @throws Exception
	 */
	@Override
	public List<EgovMap> srvyTextQstnRspnsStatusList(String sbjctId, String srvyId, String searchType) throws Exception {
		return srvyRspnsDAO.srvyTextQstnRspnsStatusList(sbjctId, srvyId, searchType);
	}

	/**
	 * 설문레벨형문항답변현황목록
	 *
	 * @param sbjctId 		과목아이디
	 * @param srvyId 		설문아이디
	 * @param searchType 	조회유형
	 * @return 설문레벨형문항답변현황목록
	 * @throws Exception
	 */
	@Override
	public List<EgovMap> srvyLevelQstnRspnsStatusList(String sbjctId, String srvyId, String searchType) throws Exception {
		return srvyRspnsDAO.srvyLevelQstnRspnsStatusList(sbjctId, srvyId, searchType);
	}

	/**
	 * 설문엑셀다운문항목록
	 *
	 * @param srvyId 		설문아이디
	 * @return 설문엑셀다운문항목록
	 * @throws Exception
	 */
	@Override
	public List<EgovMap> srvyExcelDownQstnList(String srvyId) throws Exception {
		return srvyRspnsDAO.srvyExcelDownQstnList(srvyId);
	}

	/**
	 * 설문엑셀다운문항답변목록
	 *
	 * @param srvyId 		설문아이디
	 * @return 설문엑셀다운문항답변목록
	 * @throws Exception
	 */
	@Override
	public List<EgovMap> srvyExcelDownQstnRspnsList(String srvyId) throws Exception {
		return srvyRspnsDAO.srvyExcelDownQstnRspnsList(srvyId);
	}

}
