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

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.srvy.dao.SrvyPtcpDAO;
import knou.lms.srvy.service.SrvyPtcpService;
import knou.lms.srvy.vo.SrvyPtcpVO;
import knou.lms.srvy.vo.SrvyVO;

@Service("srvyPtcpService")
public class SrvyPtcpServiceImpl extends ServiceBase implements SrvyPtcpService {

	@Resource(name="srvyPtcpDAO")
	private SrvyPtcpDAO srvyPtcpDAO;

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

	/**
	* 설문성적엑셀업로드
	*
	* @param srvyId 		설문아이디
    * @param uploadFiles 	파일목록
    * @param uploadPath 	파일경로
    * @param excelGrid 	엑셀그리드
	* @throws Exception
	*/
	@Override
	public void srvyScrExcelUpload(SrvyPtcpVO vo) throws Exception {
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
        List<Map<String, Object>> list = (List<Map<String, Object>>) excelUtilPoi.simpleReadGrid(map);

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

        // 첨부파일 삭제
        attachFileService.deleteAtflByAtflIds(fileIdList.toArray(new String[0]));
	}

}
