package knou.lms.smnr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.RepoInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.ExcelUtilPoi;
import knou.lms.common.dto.ResultDTO;
import knou.lms.smnr.facade.SmnrFacadeService;
import knou.lms.smnr.service.SmnrService;
import knou.lms.smnr.vo.*;
import knou.lms.smnr.web.view.SmnrMainView;
import knou.lms.smnr.web.view.SmnrPageInfo;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value="/smnr")
public class SmnrController extends ControllerBase {

	private static final Logger log = LoggerFactory.getLogger(SmnrController.class);

	@Resource(name="smnrFacadeService")
	private SmnrFacadeService smnrFacadeService;

	@Resource(name="smnrService")
	private SmnrService smnrService;

	/*****************************************************
     *						교수 화면	 					*
     ******************************************************/

	/**
     * 교수세미나목록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_smnr_list_view.jsp
     */
    @RequestMapping(value="/profSmnrListView.do")
    public String profSmnrListView(SmnrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        model.addAttribute("vo", vo);
        model.addAttribute("userCtx", userCtx);
        return "smnr/prof_smnr_list_view";
    }

    /**
     * 과목별세미나목록조회
     * @param 	SmnrVO
     * @return 	과목별세미나목록
     */
    @RequestMapping(value="/bySubjectSmnrList.do")
    @ResponseBody
    public ResultDTO<EgovMap> bySubjectSmnrList(SmnrVO vo, ModelMap model, HttpServletRequest request) {
    	return new ResultDTO<EgovMap>().setReturnList(smnrService.bySubjectSmnrList(vo)).setResultSuccess();
    }

    /**
     * 교수세미나목록조회
     *
     * @param sbjctId     과목아이디
     * @param searchValue 검색어 ( 세미나명 )
     * @return 교수 세미나목록
     */
    @RequestMapping(value="/profSmnrListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profSmnrListAjax(SmnrPageInfo pageInfo, ModelMap model, HttpServletRequest request) {
        return smnrFacadeService.getProfSmnrList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 교수세미나등록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_smnr_regist_view.jsp
     */
    @RequestMapping(value="/profSmnrRegistView.do")
    public String profSmnrRegistView(SmnrVO vo, ModelMap model, HttpServletRequest request) {
    	SmnrMainView smnrMainView = smnrFacadeService.loadProfSmnrRegistView(vo);
    	model.addAttribute("subjectVO", smnrMainView.getSubjectVO());
    	model.addAttribute("lctrWknoList", smnrMainView.getEgovList());
    	EgovMap map = new EgovMap();
    	map.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_SMNR, null));	// 첨부파일저장소 설정
    	model.addAttribute("vo", map);

        return "smnr/prof_smnr_regist_view";
    }

    /**
     * 세미나등록
     *
     * @param SmnrVO 				세미나정보
     * @param subSmnrsStr 			팀그룹부과제정보
     * @param teamGrpIds 			팀그룹아이디:과목아이디목록
     * @param byteamSubsmnrUseyns 	팀별부세미나사용여부:과목아이디목록
     * @return ResultDTO<SmnrVO>
     */
    @RequestMapping(value="/smnrRegistAjax.do")
    @ResponseBody
    public ResultDTO<SmnrVO> srvyRegistAjax(SmnrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="subSmnrs", defaultValue="[]") String subSmnrsStr
    		, @RequestParam(value="teamGrpIds", defaultValue="[]") String teamGrpIds) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        vo.setOrgId(userCtx.getOrgId());

        Map<String, String> subMap = new HashMap<>();
        subMap.put("subSmnrsStr", subSmnrsStr);
        subMap.put("teamGrpIds", teamGrpIds);
        smnrFacadeService.smnrRegist(vo, subMap);

        return new ResultDTO<SmnrVO>().setResultSuccess();
    }

    /**
     * 교수세미나수정화면
     *
     * @param smnrId 	세미나아이디
     * @param sbjctId	과목아이디
     * @return prof_smnr_regist_view.jsp
     */
    @RequestMapping(value="/profSmnrModifyView.do")
    public String profSmnrModifyView(SmnrVO vo, ModelMap model, HttpServletRequest request) {
    	SmnrMainView smnrMainView = smnrFacadeService.loadProfSmnrModifyView(vo);
    	EgovMap smnrEgovMap = smnrMainView.getEgovMap();
    	smnrEgovMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_SMNR, (String) smnrEgovMap.get("smnrId")));	// 첨부파일저장소 설정
        model.addAttribute("vo", smnrEgovMap);
    	model.addAttribute("subjectVO", smnrMainView.getSubjectVO());
    	model.addAttribute("lctrWknoList", smnrMainView.getEgovList());

        return "smnr/prof_smnr_regist_view";
    }

    /**
     * 세미나수정
     *
     * @param SmnrVO 				세미나정보
     * @param subSmnrsStr 			팀그룹부과제정보
     * @param teamGrpIds 			팀그룹아이디:과목아이디목록
     * @param byteamSubsmnrUseyns 	팀별부세미나사용여부:과목아이디목록
     * @return ResultDTO<SmnrVO>
     */
    @RequestMapping(value="/smnrModifyAjax.do")
    @ResponseBody
    public ResultDTO<SmnrVO> smnrModifyAjax(SmnrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="subSmnrs", defaultValue="[]") String subSmnrsStr
    		, @RequestParam(value="teamGrpIds", defaultValue="[]") String teamGrpIds) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        vo.setOrgId(userCtx.getOrgId());

        Map<String, String> subMap = new HashMap<>();
        subMap.put("subSmnrsStr", subSmnrsStr);
        subMap.put("teamGrpIds", teamGrpIds);
        subMap.put("meetngrmId", request.getParameter("meetngrmId"));
        smnrFacadeService.smnrModify(vo, subMap);

        return new ResultDTO<SmnrVO>().setResultSuccess();
    }

    /**
     * 세미나삭제
     *
     * @param sbjctId   과목아이디
     * @param smnrId 	세미나아이디
     * @return ResultDTO<SmnrVO>
     */
    @RequestMapping(value="/smnrDeleteAjax.do")
    @ResponseBody
    public ResultDTO<SmnrVO> srvyDeleteAjax(SmnrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        vo.setOrgId(userCtx.getOrgId());
        smnrFacadeService.smnrDelete(vo);

        return new ResultDTO<SmnrVO>().setResultSuccess();
    }

    /**
     * 세미나팀그룹부세미나목록조회
     *
     * @param teamGrpId 팀그룹아이디
     * @param smnrId	세미나아이디
     * @return 세미나팀그룹부세미나목록
     */
    @RequestMapping(value="/smnrTeamGrpSubSmnrListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> smnrTeamGrpSubSmnrListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(smnrFacadeService.getSmnrTeamGrpSubSmnrList(params).getEgovList()).setResultSuccess();
    }

    /**
     * 세미나성적공개여부수정
     *
     * @param smnrId	세미나아이디
     * @param mrkOyn    성적공개여부
     */
    @RequestMapping(value="/smnrMrkOynModifyAjax.do")
    @ResponseBody
    public ResultDTO<SmnrVO> smnrMrkOynModifyAjax(SmnrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        smnrFacadeService.smnrDtlModify(vo);

        return new ResultDTO<SmnrVO>().setResultSuccess();
    }

    /**
     * 세미나성적반영비율수정
     *
     * @param smnrId	세미나아이디
     * @param mrkRfltrt 성적반영비율
     */
    @RequestMapping(value="/smnrMrkRfltrtModifyAjax.do")
    @ResponseBody
    public ResultDTO<SmnrVO> smnrMrkRfltrtModifyAjax(@RequestBody List<SmnrVO> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        list.forEach(vo -> vo.setMdfrId(userCtx.getUserId()));
        smnrFacadeService.smnrMrkRfltrtListModify(list);

        return new ResultDTO<SmnrVO>().setResultSuccess();
    }

    /**
     * 교수세미나평가관리화면
     *
     * @param smnrId 	세미나아이디
     * @param sbjctId 	과목아이디
     * @return prof_smnr_evl_mng_view.jsp
     */
    @RequestMapping(value="/profSmnrEvlMngView.do")
    public String profSmnrEvlMngView(SmnrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	vo.setOrgId(userCtx.getOrgId());
    	SmnrMainView smnrMainView = smnrFacadeService.loadProfSmnrEvlMngView(vo);
    	EgovMap smnrMap = smnrMainView.getEgovMap();
    	smnrMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_SMNR, (String) smnrMap.get("smnrId")));
		model.addAttribute("vo", smnrMap);
		model.addAttribute("smnrGbncdList", smnrMainView.getCmmnCdList().get("smnrGbncd"));
		model.addAttribute("userCtx", userCtx);

        return "smnr/prof_smnr_evl_mng_view";
    }

    /**
     * 교수세미나참석목록조회
     *
     * @param smnrId     	세미나아이디
     * @param atndStscd 	참석여부
     * @param atndEvlyn 	참석평가여부
     * @param searchValue   검색어(학과, 학번, 이름)
     * @return 세미나참석목록
     */
    @RequestMapping(value="/profSmnrAtndListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profSmnrAtndListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(smnrFacadeService.getSmnrAtndList(params).getEgovList()).setResultSuccess();
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
    @RequestMapping(value="/profSmnrEvlScrBulkModifyAjax.do")
    @ResponseBody
    public ResultDTO<SmnrVO> profSmnrEvlScrBulkModifyAjax(@RequestBody List<Map<String, Object>> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(map -> map.put("rgtrId", userCtx.getUserId()));
        smnrFacadeService.profSmnrEvlScrBulkModify(list);

        return new ResultDTO<SmnrVO>().setResultSuccess();
    }

    /**
     * 세미나피드백등록
     *
     * @param SmnrFdbkVO	세미나정보
     * @return ResultDTO<SmnrFdbkVO>
     */
    @RequestMapping(value="/smnrFdbkRegistAjax.do")
    @ResponseBody
    public ResultDTO<SmnrFdbkVO> smnrFdbkRegistAjax(SmnrFdbkVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="fdbkUsers", defaultValue="[]") String fdbkUsersStr) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        smnrFacadeService.smnrFdbkRegist(vo, fdbkUsersStr);

        return new ResultDTO<SmnrFdbkVO>().setResultSuccess();
    }

    /**
     * 세미나피드백팝업
     *
     * @param smnrId 	세미나아이디
     * @param sbjctId 	과목아이디
     * @return smnr_fdbk_pop.jsp
     */
    @RequestMapping(value="/smnrFdbkPopup.do")
    public String smnrFdbkPopup(SmnrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SmnrMainView smnrMainView = smnrFacadeService.loadProfSmnrFdbkPopup(vo);
    	smnrMainView.geteMap().get("vo").put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_SMNR, null));
    	model.addAttribute("vo", smnrMainView.geteMap().get("vo"));
        model.addAttribute("smnrAtndVO", smnrMainView.geteMap().get("atndVO"));
        model.addAttribute("userTycd", userCtx.getUserTycd());

        return "smnr/popup/smnr_fdbk_pop";
    }

    /**
     * 교수세미나피드백목록조회
     *
     * @param smnrId    세미나아이디
     * @param userId 	사용자아이디
     * @return 교수세미나피드백목록
     */
    @RequestMapping(value="/profSmnrFdbkListAjax.do")
    @ResponseBody
    public ResultDTO<SmnrFdbkVO> profSmnrFdbkListAjax(SmnrFdbkVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<SmnrFdbkVO>().setReturnList(smnrFacadeService.getSmnrFdbkList(vo).getSmnrFdbkList()).setResultSuccess();
    }

    /**
     * 세미나피드백수정
     *
     * @param SmnrFdbkVO	세미나정보
     * @return ResultDTO<SmnrFdbkVO>
     */
    @RequestMapping(value="/smnrFdbkModifyAjax.do")
    @ResponseBody
    public ResultDTO<SmnrFdbkVO> smnrFdbkModifyAjax(SmnrFdbkVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        smnrFacadeService.smnrFdbkModify(vo);

        return new ResultDTO<SmnrFdbkVO>().setResultSuccess();
    }

    /**
     * 세미나피드백조회
     *
     * @param smnrFdbkId    세미나피드백아이디
     * @return 세미나피드백정보
     */
    @RequestMapping(value="/smnrFdbkSelectAjax.do")
    @ResponseBody
    public ResultDTO<SmnrFdbkVO> smnrFdbkSelectAjax(SmnrFdbkVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<SmnrFdbkVO>().setData(smnrFacadeService.getSmnrFdbk(vo).getSmnrFdbkVO()).setResultSuccess();
    }

    /**
     * 세미나피드백삭제
     *
     * @param SmnrFdbkVO	세미나정보
     * @return ResultDTO<SmnrFdbkVO>
     */
    @RequestMapping(value="/smnrFdbkDeleteAjax.do")
    @ResponseBody
    public ResultDTO<SmnrFdbkVO> smnrFdbkDeleteAjax(SmnrFdbkVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        smnrFacadeService.smnrFdbkDelete(vo);

        return new ResultDTO<SmnrFdbkVO>().setResultSuccess();
    }

    /**
     * 교수세미나엑셀성적등록팝업
     *
     * @param smnrId 	세미나아이디
     * @param sbjctId 	과목아이디
     * @return prof_smnr_excel_scr_regist_pop.jsp
     */
    @RequestMapping(value="/profSmnrExcelScrRegistPopup.do")
    public String profSmnrExcelScrRegistPopup(SmnrVO vo, ModelMap model, HttpServletRequest request) {
    	vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_SMNR, vo.getSmnrId()));
        request.setAttribute("vo", vo);

        return "smnr/popup/prof_smnr_excel_scr_regist_pop";
    }

    /**
     * 교수세미나성적등록샘플엑셀다운로드
     *
     * @param smnrId 		세미나아이디
     * @param excelGrid 	엑셀그리드
     * @return excelView
     */
    @RequestMapping(value="/profSmnrScrRegistSampleExcelDown.do")
    public String profSmnrScrRegistSampleExcelDown(SmnrVO vo, ModelMap model, HttpServletRequest request) {
        String title = "학습자목록";

        Map<String, Object> searchMap = new HashMap<String, Object>();
        searchMap.put("smnrId", vo.getSmnrId());
        List<EgovMap> smnrAtndList = smnrFacadeService.getSmnrAtndList(searchMap).getEgovList();

        // POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        // 엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);  		// 학습자목록
        map.put("sheetName", title);   	// 학습자목록
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", smnrAtndList);

        HashMap<String, Object> params = new HashMap<>();
        params.put("outFileName", title);  // 학습자목록
        params.put("sheetName", title);    // 학습자목록
        params.put("list", smnrAtndList);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        params.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(params);

        return "excelView";
    }

    /**
     * 교수세미나성적엑셀업로드
     *
     * @param smnrId 		세미나아이디
     * @param uploadFiles 	파일목록
     * @param uploadPath 	파일경로
     * @param excelGrid 	엑셀그리드
     * @return excelView
     */
    @RequestMapping(value="/profSmnrScrExcelUpload.do")
    @ResponseBody
    public ResultDTO<SmnrAtndVO> profSmnrScrExcelUpload(SmnrAtndVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        smnrFacadeService.smnrScrExcelUpload(vo);

        return new ResultDTO<SmnrAtndVO>().setResultSuccess();
    }

    /**
     * 교수세미나참석목록엑셀다운로드
     *
     * @param srvyId     		설문아이디
     * @param atndStscd 		참석여부
     * @param atndEvlyn 		참석평가여부
     * @param searchValue   	검색어(학과, 학번, 이름)
     * @param excelGrid 		엑셀그리드
     * @return excelView
     */
    @RequestMapping(value="/profSmnrAtndListExcelDown.do")
    public String profSmnrAtndListExcelDown(SmnrVO vo, ModelMap model, HttpServletRequest request) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", "참석목록");
        map.put("sheetName", "참석목록");
        map.put("excelGrid", vo.getExcelGrid());

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("smnrId", vo.getSmnrId());
        params.put("atndStscd", request.getParameter("atndStscd"));
        params.put("atndEvlyn", request.getParameter("atndEvlyn"));
        params.put("searchValue", vo.getSearchValue());
        map.put("list", smnrFacadeService.getSmnrAtndList(params).getEgovList());

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", "참석목록");

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /**
     * 교수세미나참석이력팝업
     *
     * @param smnrId 	세미나아이디
     * @return prof_smnr_atnd_hstry_list_pop.jsp
     */
    @RequestMapping(value="/profSmnrAtndHstryListPopup.do")
    public String profSmnrAtndHstryListPopup(SmnrVO vo, ModelMap model, HttpServletRequest request) {
        model.addAttribute("vo", smnrFacadeService.loadProfSmnrAtndHstryListPopup(vo).getEgovMap());

        return "smnr/popup/prof_smnr_atnd_hstry_list_pop";
    }

    /**
     * 교수세미나참석이력목록조회
     *
     * @param smnrId     	세미나아이디
     * @param searchValue   검색어(학과, 학번, 이름)
     * @return 세미나참석이력목록
     */
    @RequestMapping(value="/profSmnrAtndHstryListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profSmnrAtndHstryListAjax(SmnrVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(smnrFacadeService.getSmnrAtndHstryList(vo).getEgovList()).setResultSuccess();
    }

    /**
	* 교수세미나참석일괄수정
	*
	* @param smnrId 	세미나아이디
	* @param smnrAtndId	세미나참석아이디
	* @param userId 	사용자아이디
	* @param atndStscd 	참석상태코드
	*/
    @RequestMapping(value="/profSmnrAtndBulkModifyAjax.do")
    @ResponseBody
    public ResultDTO<SmnrVO> profSmnrAtndBulkModifyAjax(@RequestBody List<Map<String, Object>> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(map -> map.put("rgtrId", userCtx.getUserId()));
        smnrFacadeService.profSmnrAtndBulkModify(list);

        return new ResultDTO<SmnrVO>().setResultSuccess();
    }

    /**
     * 교수세미나참석관리팝업
     *
     * @param smnrId 		세미나아이디
     * @param smnrAtndId 	세미나참석아이디
     * @param userId 		사용자아이디
     * @return prof_smnr_atnd_mng_pop.jsp
     */
    @RequestMapping(value="/profSmnrAtndMngPopup.do")
    public String profSmnrAtndMngPopup(SmnrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	vo.setOrgId(userCtx.getOrgId());
    	SmnrMainView smnrMainView = smnrFacadeService.loadProfSmnrAtndMngPopup(vo);
    	smnrMainView.geteMap().get("vo").put("userId", vo.getUserId());
        model.addAttribute("vo", smnrMainView.geteMap().get("vo"));
        model.addAttribute("atndVO", smnrMainView.geteMap().get("atndVO"));
        model.addAttribute("zoomPastMeetingVO", smnrMainView.getZoomPastMeetingVO());

        return "smnr/popup/prof_smnr_atnd_mng_pop";
    }

    /**
     * 세미나참석정보조회
     *
     * @param smnrId 	세미나아이디
     * @param userId 	사용자아이디
     * @return 세미나참석정보
     */
    @RequestMapping(value="/smnrAtndSelectAjax.do")
    @ResponseBody
    public ResultDTO<SmnrAtndVO> smnrAtndSelectAjax(SmnrVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<SmnrAtndVO>().setData(smnrFacadeService.getSmnrAtndSelect(vo).getSmnrAtndVO()).setResultSuccess();
    }

    /**
     * 사용자세미나참석이력목록조회
     *
     * @param smnrId   	세미나아이디
     * @param userId   	사용자아이디
     * @return 사용자세미나참석이력목록
     */
    @RequestMapping(value="/userSmnrAtndHstryListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> userSmnrAtndHstryListAjax(SmnrAtndHstryVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(smnrFacadeService.getUserSmnrAtndHstryList(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 세미나참석상태수정
     *
     * @param smnrId		세미나아이디
     * @param atndeId   	참석자아이디
     * @param smnrAtndId   	세미나참석아이디
     * @param atndStscd   	참석상태코드
     */
    @RequestMapping(value="/smnrAtndStsModifyAjax.do")
    @ResponseBody
    public ResultDTO<SmnrAtndVO> smnrAtndStsModifyAjax(SmnrAtndVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        smnrFacadeService.profSmnrAtndModify(vo);

        return new ResultDTO<SmnrAtndVO>().setResultSuccess();
    }

    /**
     * 세미나참석메모수정
     *
     * @param smnrId		세미나아이디
     * @param atndeId   	참석자아이디
     * @param smnrAtndId   	세미나참석아이디
     * @param atndMemo   	참석메모
     */
    @RequestMapping(value="/smnrAtndMemoModifyAjax.do")
    @ResponseBody
    public ResultDTO<SmnrAtndVO> smnrAtndMemoModifyAjax(SmnrAtndVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
	    vo.setRgtrId(userCtx.getUserId());
	    smnrFacadeService.profSmnrAtndMemoModify(vo);

    	return new ResultDTO<SmnrAtndVO>().setResultSuccess();
    }

    /**
     * 세미나참석메모일괄수정
     *
     * @param smnrId  		세미나아이디
     * @param smnrAtndId	세미나참석아이디
     * @param userId		사용자아이디
     * @param atndMemo		참석메모
     */
    @RequestMapping(value="/smnrAtndMemoBulkModifyAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> smnrAtndMemoBulkModifyAjax(@RequestBody List<Map<String, Object>> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(map -> map.put("rgtrId", userCtx.getUserId()));
        smnrFacadeService.smnrAtndMemoBulkModify(list);

        return new ResultDTO<EgovMap>().setResultSuccess();
    }

    /**
	* 교수세미나피드백일괄등록
	*
	* @param smnrId 	세미나아이디
	* @param userId 	사용자아이디
	* @param fdbkCts 	피드백내용
	*/
    @RequestMapping(value="/profSmnrFdbkBulkRegistAjax.do")
    @ResponseBody
    public ResultDTO<SmnrVO> profSmnrFdbkBulkRegistAjax(@RequestBody List<Map<String, Object>> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(map -> map.put("rgtrId", userCtx.getUserId()));
        smnrFacadeService.profSmnrFdbkBulkRegist(list);

        return new ResultDTO<SmnrVO>().setResultSuccess();
    }

    /*****************************************************
     *						학생 화면	 					*
     ******************************************************/

    /**
     * 학생세미나목록화면
     *
     * @param sbjctId 과목아이디
     * @return stdnt_smnr_list_view.jsp
     */
    @RequestMapping(value="/stdntSmnrListView.do")
    public String stdntSmnrListView(SmnrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	vo.setUserId(userCtx.getUserId());
    	model.addAttribute("vo", vo);

        return "smnr/stdnt_smnr_list_view";
    }

    /**
     * 학생세미나목록조회
     *
     * @param sbjctId     과목아이디
     * @param searchValue 검색어 ( 세미나명 )
     * @return 학생 세미나목록
     */
    @RequestMapping(value="/stdntSmnrListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> stdntSmnrListAjax(SmnrPageInfo pageInfo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	pageInfo.setUserId(userCtx.getUserId());
        return smnrFacadeService.getStdntSmnrList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 학생세미나정보화면
     *
     * @param sbjctId 	과목아이디
     * @param smnrId 	세미나아이디
     * @param upSmnrId 	상위세미나아이디
     * @return stdnt_smnr_info_view.jsp
     */
    @RequestMapping(value="/stdntSmnrInfoView.do")
    public String stdntQuizInfoView(SmnrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SmnrMainView smnrMainView = smnrFacadeService.loadStdntSmnrInfoView(vo, userCtx);
    	model.addAttribute("vo", smnrMainView.getEgovMap());
    	model.addAttribute("smnrGbncdList", smnrMainView.getCmmnCdList().get("smnrGbncd"));

        return "smnr/stdnt_smnr_info_view";
    }

    /**
     * 세미나참석이력목록조회
     *
     * @param smnrId 	세미나아이디
     * @param userId	사용자아이디
     * @return 세미나참석이력목록
     */
    @RequestMapping(value="/smnrAtndHstryListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> smnrAtndHstryListAjax(SmnrAtndHstryVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setAtndeId(userCtx.getUserId());
        return new ResultDTO<EgovMap>().setReturnList(smnrFacadeService.getSmnrAtndHstryList(vo).getEgovList()).setResultSuccess();
    }

}
