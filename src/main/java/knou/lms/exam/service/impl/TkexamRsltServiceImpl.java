package knou.lms.exam.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.lms.exam.dao.TkexamDAO;
import knou.lms.exam.dao.TkexamRsltDAO;
import knou.lms.exam.service.TkexamRsltService;
import knou.lms.exam.vo.ExamBscVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;

@Service("tkexamRsltService")
public class TkexamRsltServiceImpl extends ServiceBase implements TkexamRsltService {

	@Resource
	private TkexamRsltDAO tkexamRsltDAO;

	@Resource
	private TkexamDAO tkexamDAO;

	@Autowired
	private AttachFileService attachFileService;

	/**
	* 교수메모조회
	*
	* @param tkexamId 	시험응시아이디
    * @param userId 	사용자이이디
	* @return 교수메모
	*/
	@Override
	public EgovMap profMemoSelect(String tkexamId, String userId) {
		return tkexamRsltDAO.profMemoSelect(tkexamId, userId);
	}

	/**
	* 교수메모수정
	*
	* @param examDtlId	 	시험상세아이디
	* @param tkexamRsltId 	시험응시결과아이디
    * @param tkexamId 		시험응시아이디
    * @param userId 		사용자이이디
    * @param profMemo 		교수메모
	*/
	@Override
	public void profMemoModify(Map<String, Object> params) {
		// 1. 응시정보 등록
		Object tkexamId = params.get("tkexamId");
		if(tkexamId == null || "null".equals(String.valueOf(tkexamId).trim().toLowerCase())) {
			params.put("tkexamId", IdGenUtil.genNewId(IdPrefixType.TKEXM));
			tkexamDAO.userTkexamRegist(params);
		}

		// 2. 교수메모 수정
		params.put("tkexamRsltId", IdGenUtil.genNewId(IdPrefixType.TKRST));
		tkexamRsltDAO.profMemoModify(params);
	}

	/**
	* 교수퀴즈평가점수일괄수정
	*
	* @param examDtlId 	시험상세아이디
	* @param tkexamId 	시험응시아이디
	* @param userId 	사용자아이디
	* @param scr 		점수
	* @param scoreType  점수유형
	*/
	@Override
	public void profQuizEvlScrBulkModify(List<Map<String, Object>> list) {
		// 1. 응시정보 등록
		for(Map<String, Object> map : list) {
			Object tkexamId = map.get("tkexamId");
			if(tkexamId == null || "null".equals(String.valueOf(tkexamId).trim().toLowerCase())) {
				map.put("tkexamId", IdGenUtil.genNewId(IdPrefixType.TKEXM));
			}
			map.put("tkexamRsltId", IdGenUtil.genNewId(IdPrefixType.TKRST));
		}
		tkexamDAO.userListTkexamRegist(list);

		// 2. 응시결과점수등록
		tkexamRsltDAO.userListEvlScrBulkModify(list);
	}

	/**
	* 퀴즈성적엑셀업로드
	*
	* @param examBscId 	시험기본아이디
    * @param excelGrid 	엑셀그리드
	*/
	@Override
	public void quizScrExcelUpload(ExamBscVO vo) {
		List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        List<String> fileIdList = new ArrayList<>();

        // 첨부파일
        if (uploadFileList.size() > 0) {
        	for (AtflVO atflVO : uploadFileList) {
        		atflVO.setRefId(vo.getExamBscId());
        		atflVO.setRgtrId(vo.getRgtrId());
        		atflVO.setMdfrId(vo.getMdfrId());
        		atflVO.setAtflRepoId(CommConst.REPO_EXAM);
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

        // 퀴즈응시목록조회
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("examBscId", vo.getExamBscId());
        List<EgovMap> tkexamList = tkexamDAO.quizTkexamList(params);

        if(list.size() > 0) {
        	// 성적등록용목록
        	List<Map<String, Object>> scrList = new ArrayList<Map<String, Object>>();

        	for(Map<String, Object> user : list) {
        		String stdUserId = user.get("B").toString();
        		Optional<EgovMap> result = tkexamList.stream()
        				.filter(tkexam -> stdUserId.equals(tkexam.get("userId")))
        				.findFirst();

        		if(result.isPresent()) {
        			Map<String, Object> scr = new HashMap<String, Object>();
        			scr.put("examDtlId", result.get().get("examDtlId"));
        			if(result.get().get("tkexamId") == null) {
        				scr.put("tkexamId", IdGenUtil.genNewId(IdPrefixType.TKEXM));
        			} else {
        				scr.put("tkexamId", result.get().get("tkexamId"));
        			}
        			scr.put("userId", stdUserId);
        			scr.put("scr", new BigDecimal(user.get("D").toString()));
        			scr.put("scoreType", "batch");
        			scr.put("rgtrId", vo.getRgtrId());
        			scrList.add(scr);
        		}
        	}
        	// 퀴즈점수엑셀일괄등록
        	profQuizEvlScrBulkModify(scrList);
        }
	}

	/**
	* 학생시험응시결과조회
	*
	* @param examDtlId 	시험상세아이디
    * @param userId 	사용자이이디
	* @return 학생시험응시결과
	*/
	@Override
	public EgovMap stdntTkexamRsltSelect(Map<String, Object> params) {
		return tkexamRsltDAO.stdntTkexamRsltSelect(params);
	}

}
