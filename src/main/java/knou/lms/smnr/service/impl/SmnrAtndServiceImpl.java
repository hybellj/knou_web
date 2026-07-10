package knou.lms.smnr.service.impl;

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
import knou.lms.smnr.dao.SmnrAtndDAO;
import knou.lms.smnr.dao.SmnrAtndHstryDAO;
import knou.lms.smnr.service.SmnrAtndService;
import knou.lms.smnr.vo.SmnrAtndVO;
import knou.lms.smnr.vo.SmnrVO;

@Service("smnrAtndService")
public class SmnrAtndServiceImpl extends ServiceBase implements SmnrAtndService {

	@Resource(name="smnrAtndDAO")
	private SmnrAtndDAO smnrAtndDAO;

	@Resource(name="smnrAtndHstryDAO")
	private SmnrAtndHstryDAO smnrAtndHstryDAO;

	@Resource(name="attachFileService")
	private AttachFileService attachFileService;

	/**
	 * 세미나참석조회
	 *
	 * @param SmnrVO
	 * @return 세미나참석정보
	 */
	@Override
	public SmnrAtndVO smnrAtndSelect(SmnrVO vo) {
		return smnrAtndDAO.smnrAtndSelect(vo);
	}

	/**
	 * 세미나참석등록
	 *
	 * @param SmnrAtndVO
	 */
	@Override
	public void smnrAtndRegist(SmnrAtndVO vo) {
		vo.setSmnrAtndId(IdGenUtil.genNewId(IdPrefixType.SMATN));
		smnrAtndDAO.smnrAtndRegist(vo);
	}

	/**
	 * 세미나참석수정
	 *
	 * @param SmnrAtndVO
	 */
	@Override
	public void smnrAtndModify(SmnrAtndVO vo) {
		smnrAtndDAO.smnrAtndModify(vo);
	}

	/**
	* 세미나참석목록조회
	*
	* @param smnrId     	세미나아이디
    * @param atndStscd 		참석여부
    * @param atndEvlyn 		참석평가여부
    * @param searchValue    검색어(학과, 학번, 이름)
    * @param userId 		사용자아이디
	* @return 세미나참석목록
	*/
	@Override
	public List<EgovMap> smnrAtndList(Map<String, Object> params) {
		return smnrAtndDAO.smnrAtndList(params);
	}

	/**
	* 교수세미나평가점수일괄수정
	*
	* @param smnrId 	세미나아이디
	* @param smnrAtndId	세미나참석아이디
	* @param userId 	사용자아이디
	* @param scr 		점수
	* @param scoreType  점수유형
	*/
	@Override
	public void profSmnrEvlScrBulkModify(List<Map<String, Object>> list) {
		for(Map<String, Object> map : list) {
			if(isNullOrNullString(map.get("smnrAtndId"))) map.put("smnrAtndId", IdGenUtil.genNewId(IdPrefixType.SMATN));
		}
		smnrAtndDAO.userListEvlScrBulkModify(list);
	}

	/**
	* 세미나성적엑셀업로드
	*
	* @param smnrId 		세미나아이디
    * @param uploadFiles 	파일목록
    * @param uploadPath 	파일경로
    * @param excelGrid 		엑셀그리드
	*/
	@Override
	public void smnrScrExcelUpload(SmnrAtndVO vo) {
		List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        List<String> fileIdList = new ArrayList<>();

        // 첨부파일
        if (uploadFileList.size() > 0) {
        	for (AtflVO atflVO : uploadFileList) {
        		atflVO.setRefId(vo.getSmnrId());
        		atflVO.setRgtrId(vo.getRgtrId());
        		atflVO.setMdfrId(vo.getRgtrId());
        		atflVO.setAtflRepoId(CommConst.REPO_SMNR);
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
        List<Map<String, Object>> list = null;
        try {
        	list = (List<Map<String, Object>>) excelUtilPoi.simpleReadGrid(map);
        } catch(Exception e) {
        	e.printStackTrace();
        }

        // 세미나참석목록조회
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("smnrId", vo.getSmnrId());
        List<EgovMap> atndList = smnrAtndDAO.smnrAtndList(params);

        if(list.size() > 0) {
        	// 성적등록용목록
        	List<Map<String, Object>> scrList = new ArrayList<Map<String, Object>>();

        	for(Map<String, Object> user : list) {
        		String userId = user.get("B").toString();
        		Optional<EgovMap> result = atndList.stream()
        			    .filter(atnd -> userId.equals(atnd.get("userId")))
        			    .findFirst();

        		if(result.isPresent()) {
        			Map<String, Object> scr = new HashMap<String, Object>();
        			scr.put("smnrId", result.get().get("smnrId"));
        			if(result.get().get("smnrAtndId") == null) {
        				scr.put("smnrAtndId", IdGenUtil.genNewId(IdPrefixType.SRPCT));
        			} else {
        				scr.put("smnrAtndId", result.get().get("smnrAtndId"));
        			}
        			scr.put("userId", userId);
        			scr.put("scr", new BigDecimal(user.get("D").toString()));
        			scr.put("scoreType", "batch");
        			scr.put("rgtrId", vo.getRgtrId());
        			scrList.add(scr);
        		}
        	}
        	// 세미나점수엑셀일괄등록
        	smnrAtndDAO.userListEvlScrBulkModify(scrList);
        }

        try {
			// 첨부파일 삭제
        	attachFileService.deleteAtflByAtflIds(fileIdList.toArray(new String[0]));
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 세미나참석일괄수정
	 *
	 * @param smnrId 		세미나아이디
	 * @param smnrAtndId	세미나참석아이디
	 * @param userId 		사용자아이디
	 * @param atndStscd 	참석상태코드
	 */
	@Override
	public void smnrAtndBulkModify(List<Map<String, Object>> list) {
		for(Map<String, Object> map : list) {
			if(isNullOrNullString(map.get("smnrAtndId"))) map.put("smnrAtndId", IdGenUtil.genNewId(IdPrefixType.SMATN));
			map.put("smnrAtndHstryId", IdGenUtil.genNewId(IdPrefixType.SMATH));
		}
		// 세미나참석일괄수정
		smnrAtndDAO.userListAtndBulkModify(list);
		// 사용자목록참석이력일괄등록
		smnrAtndHstryDAO.userListAtndHstryBulkRegist(list);
	}

	/**
	 * 세미나참석자조회
	 *
	 * @param smnrId 		세미나아이디
	 * @param userId 		사용자아이디
	 */
	@Override
	public EgovMap smnrAtndeSelect(SmnrVO vo) {
		return smnrAtndDAO.smnrAtndeSelect(vo);
	}

	/**
	 * 세미나참석메모일괄수정
	 *
	 * @param smnrId 		세미나아이디
	 * @param smnrAtndId	세미나참석아이디
	 * @param userId 		사용자아이디
	 * @param atndMemo 		참석메모
	 */
	@Override
	public void smnrAtndMemoBulkModify(List<Map<String, Object>> list) {
		for(Map<String, Object> map : list) {
			if(isNullOrNullString(map.get("smnrAtndId"))) map.put("smnrAtndId", IdGenUtil.genNewId(IdPrefixType.SMATN));
		}
		// 사용자목록참석메모일괄수정
		smnrAtndDAO.userListAtndMemoBulkModify(list);
	}

	/**
	* 세미나참석목록조회 ( Ez-Grader )
	*
	* @param smnrId     	세미나아이디
    * @param sbjctId 		과목아이디
    * @param searchKey  	참석여부
    * @param searchSort  	정렬코드
	* @return 세미나참석목록
	*/
	@Override
	public List<EgovMap> smnrAtndListByEzGrader(SmnrVO vo) {
		return smnrAtndDAO.smnrAtndListByEzGrader(vo);
	}

	/**
	* 대상자세미나참석목록조회 ( Ez-Grader )
	*
	* @param smnrId     	세미나아이디
	* @param userId     	사용자아이디
    * @param searchSort  	정렬코드
	* @return 대상자세미나참석목록
	*/
	@Override
	public List<EgovMap> trgtrSmnrAtndListByEzGrader(Map<String, Object> params) {
		return smnrAtndDAO.trgtrSmnrAtndListByEzGrader(params);
	}

	private boolean isNullOrNullString(Object value) {
	    return value == null || "null".equals(String.valueOf(value).trim().toLowerCase());
	}

}
