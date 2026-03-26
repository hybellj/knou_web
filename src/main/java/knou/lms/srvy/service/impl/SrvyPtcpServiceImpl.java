package knou.lms.srvy.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.srvy.dao.SrvyPtcpDAO;
import knou.lms.srvy.service.SrvyPtcpService;
import knou.lms.srvy.vo.SrvyVO;

@Service("srvyPtcpService")
public class SrvyPtcpServiceImpl extends ServiceBase implements SrvyPtcpService {

	@Resource(name="srvyPtcpDAO")
	private SrvyPtcpDAO srvyPtcpDAO;

	/**
	* 설문참여목록조회
	*
	* @param srvyId     	설문아이디
    * @param ptcpyn 		참여여부
    * @param srvyPtcpEvlyn  설문참여평가여부
    * @param searchValue    검색어(학과, 학번, 이름)
    * @param userId 		사용자아이디
	* @return 설문참여목록
	* @throws Exception
	*/
	@Override
	public List<EgovMap> srvyPtcpList(Map<String, Object> params) throws Exception {
		return srvyPtcpDAO.srvyPtcpList(params);
	}

	/**
	* 설문참여자조회
	*
	* @param srvyId 	설문아이디
    * @param userId 	사용자이이디
	* @return 설문참여자
	* @throws Exception
	*/
	@Override
	public EgovMap srvyPtcpntSelect(String srvyId, String userId) throws Exception {
		return srvyPtcpDAO.srvyPtcpntSelect(srvyId, userId);
	}

	/**
	* 교수메모조회
	*
	* @param srvyPtcpId 설문참여아이디
    * @param userId 	사용자이이디
	* @return 교수메모조회
	* @throws Exception
	*/
	@Override
	public EgovMap profMemoSelect(String srvyPtcpId, String userId) throws Exception {
		return srvyPtcpDAO.profMemoSelect(srvyPtcpId, userId);
	}

	/**
	* 교수메모수정
	*
	* @param srvyPtcpId 	설문참여아이디
    * @param srvyId 		설문아이디
    * @param userId 		사용자이이디
    * @param profMemo 		교수메모
	* @throws Exception
	*/
	@Override
	public void profMemoModify(Map<String, Object> params) throws Exception {
		Object srvyPtcpId = params.get("srvyPtcpId");
		if(srvyPtcpId == null || "null".equals(String.valueOf(srvyPtcpId).trim().toLowerCase())) {
			params.put("srvyPtcpId", IdGenUtil.genNewId(IdPrefixType.SRPCT));
		}

		srvyPtcpDAO.profMemoModify(params);
	}

	/**
	* 교수설문평가점수일괄수정
	*
	* @param srvyId 	설문아이디
	* @param srvyPtcpId	설문참여아이디
	* @param userId 	사용자아이디
	* @param scr 		점수
	* @param scoreType  점수유형
	* @throws Exception
	*/
	@Override
	public void profSrvyEvlScrBulkModify(List<Map<String, Object>> list) throws Exception {
		for(Map<String, Object> map : list) {
			Object srvyPtcpId = map.get("srvyPtcpId");
			if(srvyPtcpId == null || "null".equals(String.valueOf(srvyPtcpId).trim().toLowerCase())) {
				map.put("srvyPtcpId", IdGenUtil.genNewId(IdPrefixType.SRPCT));
			}
		}
		srvyPtcpDAO.userListEvlScrBulkModify(list);
	}

	/**
	* 설문참여장치별현황목록
	*
	* @param srvyId     설문아이디
    * @param sbjctId 	과목아이디
    * @param orgId  	기관아이디
	* @return 설문참여장치별현황목록
	* @throws Exception
	*/
	@Override
	public List<EgovMap> srvyPtcpDvcStatusList(String srvyId, String sbjctId, String orgId) throws Exception {
		return srvyPtcpDAO.srvyPtcpDvcStatusList(srvyId, sbjctId, orgId);
	}

	/**
	* 설문참여수조회
	*
	* @param srvyId     설문아이디
    * @param sbjctId 	과목아이디
	* @return 설문참여수
	* @throws Exception
	*/
	@Override
	public EgovMap srvyPtcpCntSelect(String srvyId, String sbjctId) throws Exception {
		return srvyPtcpDAO.srvyPtcpCntSelect(srvyId, sbjctId);
	}

	/**
	* 설문참여목록조회 ( Ez-Grader )
	*
	* @param srvyId     	설문아이디
    * @param sbjctId 		과목아이디
    * @param searchKey  	참여여부
    * @param searchSort  	정렬코드
	* @return 설문참여목록조회
	* @throws Exception
	*/
	@Override
	public List<EgovMap> srvyPtcpListByEzGrader(SrvyVO vo) throws Exception {
		return srvyPtcpDAO.srvyPtcpListByEzGrader(vo);
	}

}
