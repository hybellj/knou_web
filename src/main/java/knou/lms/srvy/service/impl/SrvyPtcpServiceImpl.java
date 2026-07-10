package knou.lms.srvy.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.srvy.dao.SrvyPtcpDAO;
import knou.lms.srvy.dao.SrvyPtcpHstryDAO;
import knou.lms.srvy.dao.SrvyQstnDAO;
import knou.lms.srvy.dao.SrvyQstnVwitmLvlDAO;
import knou.lms.srvy.dao.SrvyRspnsDAO;
import knou.lms.srvy.dao.SrvyVwitmDAO;
import knou.lms.srvy.dao.SrvypprDAO;
import knou.lms.srvy.service.SrvyPtcpService;
import knou.lms.srvy.vo.SrvyPtcpHstryVO;
import knou.lms.srvy.vo.SrvyPtcpVO;
import knou.lms.srvy.vo.SrvyVO;

@Service("srvyPtcpService")
public class SrvyPtcpServiceImpl extends ServiceBase implements SrvyPtcpService {

	@Resource(name="srvyPtcpDAO")
	private SrvyPtcpDAO srvyPtcpDAO;

	@Resource(name="srvyRspnsDAO")
	private SrvyRspnsDAO srvyRspnsDAO;

	@Resource(name="srvypprDAO")
	private SrvypprDAO srvypprDAO;

	@Resource(name="srvyQstnDAO")
	private SrvyQstnDAO srvyQstnDAO;

	@Resource(name="srvyVwitmDAO")
	private SrvyVwitmDAO srvyVwitmDAO;

	@Resource(name="srvyQstnVwitmLvlDAO")
	private SrvyQstnVwitmLvlDAO srvyQstnVwitmLvlDAO;

	@Resource(name="srvyPtcpHstryDAO")
	private SrvyPtcpHstryDAO srvyPtcpHstryDAO;

	@Resource(name="attachFileService")
	private AttachFileService attachFileService;

	/**
	* 설문참여목록조회
	*
	* @param srvyId     	설문아이디
    * @param ptcpyn 		참여여부
    * @param srvyPtcpEvlyn  설문참여평가여부
    * @param searchValue    검색어(학과, 학번, 이름)
    * @param userId 		사용자아이디
	* @return 설문참여목록
	*/
	@Override
	public List<EgovMap> srvyPtcpList(Map<String, Object> params) {
		return srvyPtcpDAO.srvyPtcpList(params);
	}

	/**
	* 설문참여자조회
	*
	* @param srvyId 	설문아이디
    * @param userId 	사용자이이디
	* @return 설문참여자
	*/
	@Override
	public EgovMap srvyPtcpntSelect(String srvyId, String userId) {
		return srvyPtcpDAO.srvyPtcpntSelect(srvyId, userId);
	}

	/**
	* 교수메모조회
	*
	* @param srvyPtcpId 설문참여아이디
    * @param userId 	사용자이이디
	* @return 교수메모조회
	*/
	@Override
	public EgovMap profMemoSelect(String srvyPtcpId, String userId) {
		return srvyPtcpDAO.profMemoSelect(srvyPtcpId, userId);
	}

	/**
	* 교수메모수정
	*
	* @param srvyPtcpId 	설문참여아이디
    * @param srvyId 		설문아이디
    * @param userId 		사용자이이디
    * @param profMemo 		교수메모
	*/
	@Override
	public void profMemoModify(Map<String, Object> params) {
		if(isNullOrNullString(params.get("srvyPtcpId"))) params.put("srvyPtcpId", IdGenUtil.genNewId(IdPrefixType.SRPCT));

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
	*/
	@Override
	public void profSrvyEvlScrBulkModify(List<Map<String, Object>> list) {
		for(Map<String, Object> map : list) {
			if(isNullOrNullString(map.get("srvyPtcpId"))) map.put("srvyPtcpId", IdGenUtil.genNewId(IdPrefixType.SRPCT));
		}
		srvyPtcpDAO.userListEvlScrBulkModify(list);
	}

	/**
	* 설문참여장치별현황목록
	*
	* @param srvyId     설문아이디
    * @param sbjctId 	과목아이디
	* @return 설문참여장치별현황목록
	*/
	@Override
	public List<EgovMap> srvyPtcpDvcStatusList(String srvyId, String sbjctId) {
		return srvyPtcpDAO.srvyPtcpDvcStatusList(srvyId, sbjctId);
	}

	/**
	* 설문참여수조회
	*
	* @param srvyId     설문아이디
    * @param sbjctId 	과목아이디
	* @return 설문참여수
	*/
	@Override
	public EgovMap srvyPtcpCntSelect(String srvyId, String sbjctId) {
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
	*/
	@Override
	public List<EgovMap> srvyPtcpListByEzGrader(SrvyVO vo) {
		return srvyPtcpDAO.srvyPtcpListByEzGrader(vo);
	}

	/**
	* 설문성적엑셀업로드
	*
	* @param srvyId 		설문아이디
    * @param uploadFiles 	파일목록
    * @param uploadPath 	파일경로
    * @param excelGrid 	엑셀그리드
	*/
	@Override
	public void srvyScrExcelUpload(SrvyPtcpVO vo) {
        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        List<String> fileIdList = new ArrayList<>();

        // 첨부파일
        if (uploadFileList.size() > 0) {
        	for (AtflVO atflVO : uploadFileList) {
        		atflVO.setRefId(vo.getSrvyId());
        		atflVO.setRgtrId(vo.getRgtrId());
        		atflVO.setMdfrId(vo.getRgtrId());
        		atflVO.setAtflRepoId(CommConst.REPO_SRVY);
        		fileIdList.add(atflVO.getAtflId());
        	}

        	// 첨부파일 저장
        	attachFileService.insertAtflList(uploadFileList);
        }

        AtflVO atflVO = uploadFileList.get(0);

        //엑셀 읽기위한 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("startRaw", 4);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("atflVO", atflVO);
        map.put("searchKey", "excelUpload");

        //엑셀 리더
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
        try {
        	list = (List<Map<String, Object>>) excelUtilPoi.simpleReadGrid(map);

        	// 첨부파일 삭제
        	attachFileService.deleteAtflByAtflIds(fileIdList.toArray(new String[0]));
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

        // 설문참여목록조회
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("srvyId", vo.getSrvyId());
        List<EgovMap> ptcpList = srvyPtcpDAO.srvyPtcpList(params);

        if(list.size() > 0) {
        	// 성적등록용목록
        	List<Map<String, Object>> scrList = new ArrayList<Map<String, Object>>();

        	for(Map<String, Object> user : list) {
        		String userId = user.get("B").toString();
        		Optional<EgovMap> result = ptcpList.stream()
        				.filter(ptcp -> userId.equals(ptcp.get("userId")))
        				.findFirst();

        		if(result.isPresent()) {
        			Map<String, Object> scr = new HashMap<String, Object>();
        			scr.put("srvyId", result.get().get("srvyId"));
        			if(result.get().get("srvyPtcpId") == null) {
        				scr.put("srvyPtcpId", IdGenUtil.genNewId(IdPrefixType.SRPCT));
        			} else {
        				scr.put("srvyPtcpId", result.get().get("srvyPtcpId"));
        			}
        			scr.put("userId", userId);
        			scr.put("scr", new BigDecimal(user.get("D").toString()));
        			scr.put("scoreType", "batch");
        			scr.put("rgtrId", vo.getRgtrId());
        			scrList.add(scr);
        		}
        	}
        	// 설문점수엑셀일괄등록
        	srvyPtcpDAO.userListEvlScrBulkModify(scrList);
        }
	}

	/**
	* 교수메모일괄수정
	*
	* @param srvyPtcpId 	설문참여아이디
    * @param srvyId 		설문아이디
    * @param userId 		사용자이이디
    * @param profMemo 		교수메모
	*/
	@Override
	public void profMemoBulkModify(List<Map<String, Object>> list) {
		for(Map<String, Object> map : list) {
			if(isNullOrNullString(map.get("srvyPtcpId"))) map.put("srvyPtcpId", IdGenUtil.genNewId(IdPrefixType.SRPCT));
        }
		srvyPtcpDAO.profMemoBulkModify(list);
	}

	/**
	* 학생설문참여
	*
	* @param srvyId 		설문아이디
    * @param srvyPtcpId 	설문참여아이디
    * @param sbjctId 		과목아이디
    * @param userId			사용자아이디
	*/
	@Override
	public ResultDTO<EgovMap> stdntSrvyPtcp(Map<String, Object> params) {
		ResultDTO<EgovMap> resultVO = new ResultDTO<EgovMap>();

		// 설문참여정보조회
		EgovMap ptcpInfo = srvyPtcpDAO.srvyPtcpInfoSelect(params);
		if(ptcpInfo == null || ptcpInfo.isEmpty()) {
			// 설문참여목록
			EgovMap stdnt = srvyPtcpDAO.srvyPtcpList(params).get(0);
			if(stdnt == null) {
				resultVO.setResultFailed();
				resultVO.setMessage("참여 대상자가 아닙니다.");
				return resultVO;
			} else {
				params.put("srvyPtcpId", IdGenUtil.genNewId(IdPrefixType.SRPCT));
				// 설문참여등록
				srvyPtcpDAO.srvyPtcpRegist(params);

				// 설문참여정보조회
				ptcpInfo = srvyPtcpDAO.srvyPtcpInfoSelect(params);
			}
		} else {
			params.put("srvyPtcpId", ptcpInfo.get("srvyPtcpId"));
		}

		if("N".equals(ptcpInfo.get("ptcpPeriodyn"))) {
			resultVO.setResultFailed();
			resultVO.setMessage("설문 참여기간이 아닙니다.");
			return resultVO;
		}

		EgovMap map = new EgovMap();
		map.put("ptcpInfo", ptcpInfo);
		String srvyId = "";
		if("LCTR".equals(params.get("type"))) {
			srvyId = params.get("srvyId").toString();
			params.put("srvyId", params.get("upSrvyId"));
		}
		// 설문지목록조회
		map.put("srvypprList", srvypprDAO.srvypprList(params.get("srvyId").toString(), ""));
		// 설문문항목록조회
		map.put("srvyQstnList", srvyQstnDAO.srvyQstnList(params.get("srvyId").toString(), ""));
		// 설문보기항목일괄목록조회
		map.put("srvyVwitmList", srvyVwitmDAO.srvyVwitmBulkList(params.get("srvyId").toString(), "", ""));
		// 설문문항보기항목레벨일괄조회
		map.put("srvyQstnVwitmLvlList", srvyQstnVwitmLvlDAO.srvyQstnVwitmLvlBulkList(params.get("srvyId").toString(), ""));

		if("LCTR".equals(params.get("type"))) params.put("srvyId", srvyId);
		// 설문답변목록
		map.put("srvyRspnsList", srvyRspnsDAO.srvyRspnsList(params.get("srvyPtcpId").toString(), params.get("srvyId").toString(), params.get("userId").toString()));

		// 설문참여
		srvyPtcpDAO.srvyPtcp(params);

		// 설문참여이력등록
		SrvyPtcpHstryVO hstry = new SrvyPtcpHstryVO();
		hstry.setSrvyPtcpHstryId(IdGenUtil.genNewId(IdPrefixType.SRPTH));
		hstry.setUserId(params.get("userId").toString());
		hstry.setSrvyId(params.get("srvyId").toString());
		hstry.setSrvyHstryGbncd("SRVY_PTCP_STRT");
		hstry.setCntnIp(params.get("cntnIp").toString());
		hstry.setRgtrId(params.get("userId").toString());
		srvyPtcpHstryDAO.srvyPtcpHstryRegist(hstry);

		resultVO.setResultSuccess();
		resultVO.setData(map);

		return resultVO;
	}

	/**
     * 설문지제출
     *
     * @param rspns			답변목록
     * @param srvyPtcpId	설문참여아이디
     */
	@Override
	public void srvypprSbmsn(Map<String, Object> params) {
		ObjectMapper mapper = new ObjectMapper();
    	List<Map<String, Object>> rspns = mapper.convertValue(params.get("rspns"), new TypeReference<List<Map<String, Object>>>() {});	// 답변목록
    	params.put("rspns", rspns);
    	// 설문답변일괄저장
    	srvyRspnsDAO.srvyRspnsBulkSave(params);

    	// 설문지제출
    	srvyPtcpDAO.srvypprSbmsn(params);

    	// 사용자설문참여정보조회
    	SrvyPtcpHstryVO hstry = srvyPtcpHstryDAO.userSrvyPtcpInfoSelect(params);
    	// 설문참여이력등록
    	hstry.setSrvyPtcpHstryId(IdGenUtil.genNewId(IdPrefixType.SRPTH));
    	hstry.setSrvyHstryGbncd("SRVYPPR_SBMSN");
		hstry.setCntnIp(params.get("cntnIp").toString());
		hstry.setRgtrId(params.get("userId").toString());
		srvyPtcpHstryDAO.srvyPtcpHstryRegist(hstry);
	}

	/**
	* 강의평가참여장치별현황목록
	*
    * @param srvyId			설문아이디
    * @param orgId  		기관아이디
    * @param smstrChrtId	학기기수아이디
    * @param sbjctId		과목아이디
    * @param srvyPtcp		참여여부
    * @param searchValue	검색어 ( 이름, 학번 )
	* @return 강의평가참여장치별현황목록
	*/
	@Override
	public List<EgovMap> lctrEvlPtcpDvcStatusList(Map<String, Object> params) {
		return srvyPtcpDAO.lctrEvlPtcpDvcStatusList(params);
	}

	/**
	* 강의평가참여수조회
	*
    * @param srvyId			설문아이디
    * @param orgId  		기관아이디
    * @param smstrChrtId	학기기수아이디
    * @param sbjctId		과목아이디
    * @param srvyPtcp		참여여부
    * @param searchValue	검색어 ( 이름, 학번 )
	* @return 강의평가참여수
	*/
	@Override
	public EgovMap lctrEvlPtcpCntSelect(Map<String, Object> params) {
		return srvyPtcpDAO.lctrEvlPtcpCntSelect(params);
	}

	/**
	* 전체설문참여장치별현황목록
	*
    * @param srvyId			설문아이디
    * @param orgId  		기관아이디
    * @param smstrChrtId	학기기수아이디
    * @param srvyTrgtTycd	설문대상유형코드
    * @param srvyPtcp		참여여부
    * @param searchValue	검색어 ( 이름, 학번 )
	* @return 전체설문참여장치별현황목록
	*/
	@Override
	public List<EgovMap> wholSrvyPtcpDvcStatusList(Map<String, Object> params) {
		return srvyPtcpDAO.wholSrvyPtcpDvcStatusList(params);
	}

	/**
	* 전체설문참여수조회
	*
    * @param srvyId			설문아이디
    * @param orgId  		기관아이디
    * @param smstrChrtId	학기기수아이디
    * @param srvyTrgtTycd	설문대상유형코드
    * @param srvyPtcp		참여여부
    * @param searchValue	검색어 ( 이름, 학번 )
	* @return 전체설문참여수
	*/
	@Override
	public EgovMap wholSrvyPtcpCntSelect(Map<String, Object> params) {
		return srvyPtcpDAO.wholSrvyPtcpCntSelect(params);
	}

	/**
	* 학생강의평가참여수조회
	*
    * @param srvyId			설문아이디
    * @param sbjctId		과목아이디
	* @return 학생강의평가참여수
	*/
	@Override
	public EgovMap stdntLctrEvlPtcpCntSelect(String srvyId, String sbjctId) {
		return srvyPtcpDAO.stdntLctrEvlPtcpCntSelect(srvyId, sbjctId);
	}

	/**
	* 대상전체설문참여
	*
	* @param srvyId 		설문아이디
	* @param userId			사용자아이디
    * @param cntnIp 		접속아이피
    * @param cntnDvcTycd 	접속기기유형코드
    * @param userTycd 		사용자유형코드
	*/
	@Override
	public ResultDTO<EgovMap> trgtWholSrvyPtcp(Map<String, Object> params) {
		ResultDTO<EgovMap> resultVO = new ResultDTO<EgovMap>();

		// 설문참여정보조회
		EgovMap ptcpInfo = srvyPtcpDAO.srvyPtcpInfoSelect(params);
		if(ptcpInfo == null || ptcpInfo.isEmpty()) {
			// 전체설문참여대상조회
			EgovMap trgt = srvyPtcpDAO.wholSrvyPtcpTrgtSelect(params);
			if(trgt == null) {
				resultVO.setResultFailed();
				resultVO.setMessage("참여 대상자가 아닙니다.");
				return resultVO;
			} else {
				params.put("srvyPtcpId", IdGenUtil.genNewId(IdPrefixType.SRPCT));
				// 설문참여등록
				srvyPtcpDAO.srvyPtcpRegist(params);

				// 설문참여정보조회
				ptcpInfo = srvyPtcpDAO.srvyPtcpInfoSelect(params);
			}
		} else {
			params.put("srvyPtcpId", ptcpInfo.get("srvyPtcpId"));
		}

		if("N".equals(ptcpInfo.get("ptcpPeriodyn"))) {
			resultVO.setResultFailed();
			resultVO.setMessage("설문 참여기간이 아닙니다.");
			return resultVO;
		}

		EgovMap map = new EgovMap();
		map.put("ptcpInfo", ptcpInfo);
		// 설문지목록조회
		map.put("srvypprList", srvypprDAO.srvypprList(params.get("srvyId").toString(), ""));
		// 설문문항목록조회
		map.put("srvyQstnList", srvyQstnDAO.srvyQstnList(params.get("srvyId").toString(), ""));
		// 설문보기항목일괄목록조회
		map.put("srvyVwitmList", srvyVwitmDAO.srvyVwitmBulkList(params.get("srvyId").toString(), "", ""));
		// 설문문항보기항목레벨일괄조회
		map.put("srvyQstnVwitmLvlList", srvyQstnVwitmLvlDAO.srvyQstnVwitmLvlBulkList(params.get("srvyId").toString(), ""));
		// 설문답변목록
		map.put("srvyRspnsList", srvyRspnsDAO.srvyRspnsList(params.get("srvyPtcpId").toString(), params.get("srvyId").toString(), params.get("userId").toString()));

		// 설문참여
		srvyPtcpDAO.srvyPtcp(params);

		// 설문참여이력등록
		SrvyPtcpHstryVO hstry = new SrvyPtcpHstryVO();
		hstry.setSrvyPtcpHstryId(IdGenUtil.genNewId(IdPrefixType.SRPTH));
		hstry.setUserId(params.get("userId").toString());
		hstry.setSrvyId(params.get("srvyId").toString());
		hstry.setSrvyHstryGbncd("SRVY_PTCP_STRT");
		hstry.setCntnIp(params.get("cntnIp").toString());
		hstry.setRgtrId(params.get("userId").toString());
		srvyPtcpHstryDAO.srvyPtcpHstryRegist(hstry);

		resultVO.setResultSuccess();
		resultVO.setData(map);

		return resultVO;
	}

	private boolean isNullOrNullString(Object value) {
	    return value == null || "null".equals(String.valueOf(value).trim().toLowerCase());
	}

}
