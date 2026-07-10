package knou.lms.srvy.web;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.RepoInfo;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.srvy.facade.SrvyFacadeService;
import knou.lms.srvy.service.SrvyService;
import knou.lms.srvy.vo.*;
import knou.lms.srvy.web.view.SrvyMainView;
import knou.lms.srvy.web.view.SrvyPageInfo;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value="/srvy")
public class SrvyController extends ControllerBase {

	@Resource(name="srvyFacadeService")
	private SrvyFacadeService srvyFacadeService;

	@Resource(name="srvyService")
	private SrvyService srvyService;

	/*****************************************************
     *						교수 화면	 					*
     ******************************************************/

	/**
     * 교수설문목록화면
     * @param 	sbjctId 과목아이디
     * @return 	prof_srvy_list_view.jsp
     */
    @RequestMapping(value="/profSrvyListView.do")
    public String profSrvyListView(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {

    	String sbjctId = vo.getSbjctId();
    	resetEncParam();
    	addEncParam("sbjctId", sbjctId);

        model.addAttribute("vo", vo);
        model.addAttribute("sbjctId", sbjctId);
        model.addAttribute("encParams", getEncParams());
    	model.addAttribute("vo", vo);

        return "srvy/prof_srvy_list_view";
    }

    /**
     * 과목별설문목록조회
     *
     * @param 	SrvyVO     설문
     * @return 	과목별설문목록
     */
    @RequestMapping(value="/bySubjectSrvyList.do")
    @ResponseBody
    public ResultDTO<EgovMap> bySubjectSrvyList(SrvyVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(srvyService.bySubjectSrvyList(vo)).setResultSuccess();
    }

    /**
     * 교수설문목록조회
     *
     * @param sbjctId     과목아이디
     * @param searchValue 검색어 ( 설문명 )
     * @return 교수설문목록
     */
    @RequestMapping(value="/profSrvyListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profSrvyListAjax(SrvyPageInfo pageInfo, ModelMap model, HttpServletRequest request) {
        return srvyFacadeService.getProfSrvyList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 교수설문등록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_srvy_regist_view.jsp
     */
    @RequestMapping(value="/profSrvyRegistView.do")
    public String profSrvyRegistView(SrvyVO vo, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvyRegistView(vo);
        model.addAttribute("dvclasList", srvyMainView.getEgovListMap().get("dvclasList"));
        model.addAttribute("lctrWknoList", srvyMainView.getEgovListMap().get("lctrWknoList"));
        EgovMap egovMap = new EgovMap();
        egovMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_SRVY, null));	// 첨부파일저장소 설정
        model.addAttribute("vo", egovMap);

        return "srvy/prof_srvy_regist_view";
    }

    /**
     * 설문등록
     *
     * @param SrvyVO 				설문정보
     * @param subSrvysStr 			팀그룹부과제정보
     * @param sbjctIds 				분반과목아이디목록
     * @param teamGrpIds 			팀그룹아이디:과목아이디목록
     * @param byteamSubsrvyUseyns 	팀별부설문사용여부:과목아이디목록
     * @return SrvyVO
     */
    @RequestMapping(value="/srvyRegistAjax.do")
    @ResponseBody
    public ResultDTO<SrvyVO> srvyRegistAjax(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="subSrvys", defaultValue="[]") String subSrvysStr
    		, @RequestParam(value="sbjctIds", defaultValue="[]") String sbjctIds
    		, @RequestParam(value="teamGrpIds", defaultValue="[]") String teamGrpIds
    		, @RequestParam(value="byteamSubsrvyUseyns", defaultValue="[]") String byteamSubsrvyUseyns) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());

        Map<String, String> subMap = new HashMap<>();
        subMap.put("subSrvysStr", subSrvysStr);
        subMap.put("sbjctIds", sbjctIds);
        subMap.put("teamGrpIds", teamGrpIds);
        subMap.put("byteamSubsrvyUseyns", byteamSubsrvyUseyns);
        subMap.put("srvyTeamyn", request.getParameter("srvyTeamyn"));
        return new ResultDTO<SrvyVO>().setData(srvyFacadeService.srvyRegist(vo, subMap).getSrvyVO()).setResultSuccess();
    }

    /**
     * 교수설문수정화면
     *
     * @param sbjctId 	과목아이디
     * @param srvyId 	설문아이디
     * @return prof_srvy_regist_view.jsp
     */
    @RequestMapping(value="/profSrvyModifyView.do")
    public String profSrvyModifyView(SrvyVO vo, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvyModifyView(vo);
    	EgovMap egovMap = srvyMainView.getEgovMap();
    	egovMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_SRVY, (String) srvyMainView.getEgovMap().get("srvyId")));	// 첨부파일저장소 설정
        model.addAttribute("vo", egovMap);
        model.addAttribute("dvclasList", srvyMainView.getEgovListMap().get("dvclasList"));
        model.addAttribute("lctrWknoList", srvyMainView.getEgovListMap().get("lctrWknoList"));

        return "srvy/prof_srvy_regist_view";
    }

    /**
     * 설문수정
     *
     * @param SrvyVO 				설문정보
     * @param subSrvysStr 			팀그룹부과제정보
     * @param sbjctIds 				분반과목아이디목록
     * @param teamGrpIds 			팀그룹아이디:과목아이디목록
     * @param byteamSubsrvyUseyns 	팀별부설문사용여부:과목아이디목록
     * @return SrvyVO
     */
    @RequestMapping(value="/srvyModifyAjax.do")
    @ResponseBody
    public ResultDTO<SrvyVO> srvyModifyAjax(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="subSrvys", defaultValue="[]") String subSrvysStr
    		, @RequestParam(value="sbjctIds", defaultValue="[]") String sbjctIds
    		, @RequestParam(value="teamGrpIds", defaultValue="[]") String teamGrpIds
    		, @RequestParam(value="byteamSubsrvyUseyns", defaultValue="[]") String byteamSubsrvyUseyns) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());

        Map<String, String> subMap = new HashMap<>();
        subMap.put("subSrvysStr", subSrvysStr);
        subMap.put("sbjctIds", sbjctIds);
        subMap.put("teamGrpIds", teamGrpIds);
        subMap.put("byteamSubsrvyUseyns", byteamSubsrvyUseyns);
        subMap.put("srvyTeamyn", request.getParameter("srvyTeamyn"));
        return new ResultDTO<SrvyVO>().setData(srvyFacadeService.srvyModify(vo, subMap).getSrvyVO()).setResultSuccess();
    }

    /**
     * 과목성적공개설문수조회
     *
     * @param sbjctId 	과목아이디
     * @return 과목성적공개설문수
     */
    @RequestMapping(value="/sbjctMrkOynSrvyCntSelectAjax.do")
    @ResponseBody
    public ResultDTO<SrvyVO> sbjctMrkOynSrvyCntSelectAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) {
    	ResultDTO<SrvyVO> resultVO = new ResultDTO<SrvyVO>();
        resultVO.setResult(srvyFacadeService.getSbjctMrkOynSrvyCnt(vo).getSrvyVO().getTotalCnt());

        return resultVO;
    }

    /**
     * 설문성적공개여부수정
     *
     * @param srvyId	설문아이디
     * @param mrkOyn    성적공개여부
     */
    @RequestMapping(value="/srvyMrkOynModifyAjax.do")
    @ResponseBody
    public ResultDTO<SrvyVO> srvyMrkOynModifyAjax(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        srvyFacadeService.srvyDtlModify(vo);

        return new ResultDTO<SrvyVO>().setResultSuccess();
    }

    /**
     * 설문성적반영비율수정
     *
     * @param srvyId	설문아이디
     * @param mrkRfltrt 성적반영비율
     */
    @RequestMapping(value="/srvyMrkRfltrtModifyAjax.do")
    @ResponseBody
    public ResultDTO<SrvyVO> srvyMrkRfltrtModifyAjax(@RequestBody List<SrvyVO> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(vo -> vo.setMdfrId(userCtx.getUserId()));
        srvyFacadeService.srvyMrkRfltrtListModify(list);

        return new ResultDTO<SrvyVO>().setResultSuccess();
    }

    /**
     * 설문팀그룹부과제목록조회
     *
     * @param teamGrpId	팀그룹아이디
     * @param srvyId 	설문아이디
     * @return 설문부과제목록
     */
    @RequestMapping(value="/srvyTeamGrpSubAsmtListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> srvyTeamGrpSubAsmtListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(srvyFacadeService.getSrvyTeamGrpSubSrvyList(params).getEgovList()).setResultSuccess();
    }

    /**
     * 교수이전설문복사팝업
     *
     * @param sbjctId 과목아이디
     * @return prof_bfr_srvy_copy_pop.jsp
     */
    @RequestMapping(value="/profBfrSrvyCopyPopup.do")
    public String profBfrSrvyCopyPopup(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	vo.setOrgId(userCtx.getOrgId());
        model.addAttribute("srvySearchSmstrList", srvyFacadeService.loadProfBfrSrvyCopyPopup(vo).getEgovList());
        vo.setUserId(userCtx.getUserId());
        model.addAttribute("vo", vo);

        return "srvy/popup/prof_bfr_srvy_copy_pop";
    }

    /**
     * 교수권한과목설문목록조회
     *
     * @param userId        교수아이디
     * @param smstrChrtId 	학사년도/학기
     * @param sbjctId       과목아이디
     * @param searchValue   검색내용(설문명)
     * @return 설문목록
     */
    @RequestMapping(value="/profAuthrtSbjctSrvyListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profAuthrtSbjctSrvyListAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(srvyFacadeService.getProfAuthrtSbjctSrvyList(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 설문정보조회
     *
     * @param srvyId 	설문아이디
     * @return 설문정보
     */
    @RequestMapping(value="/srvySelectAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> srvySelectAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setData(srvyFacadeService.getSrvy(vo).getEgovMap()).setResultSuccess();
    }

    /**
     * 설문삭제
     *
     * @param sbjctId   과목아이디
     * @param srvyId 	설문아이디
     * @param delyn 	삭제여부
     * @return ResultDTO<SrvyVO>
     */
    @RequestMapping(value="/srvyDeleteAjax.do")
    @ResponseBody
    public ResultDTO<SrvyVO> srvyDeleteAjax(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        srvyFacadeService.srvyDelete(vo);

        return new ResultDTO<SrvyVO>().setResultSuccess();
    }

    /**
     * 설문지미리보기팝업
     *
     * @param srvyId 	설문아이디
     * @return srvyppr_preview_pop.jsp
     */
    @RequestMapping(value={"/profSrvypprPreviewPopup.do", "/admSrvypprPreviewPopup.do"})
    public String profSrvypprPreviewPopup(SrvyVO vo, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvypprPreviewPopup(vo);

    	model.addAttribute("vo", srvyMainView.getEgovMap());
    	model.addAttribute("srvypprList", srvyMainView.getSrvypprList());
    	model.addAttribute("srvyQstnList", srvyMainView.getSrvyQstnList());
    	model.addAttribute("srvyVwitmList", srvyMainView.getSrvyVwitmList());
    	model.addAttribute("srvyQstnVwitmLvlList", srvyMainView.getSrvyQstnVwitmLvlList());
    	if("SRVY_TEAM".equals(srvyMainView.getEgovMap().get("srvyGbn"))) {
    		model.addAttribute("srvyTeamList", srvyMainView.getEgovList());
    	}

        return "srvy/popup/srvyppr_preview_pop";
    }

    /**
     * 교수설문문항관리화면
     *
     * @param srvyId 	설문아이디
     * @param sbjctId   과목아이디
     * @return prof_srvy_qstn_mng_view.jsp
     */
    @RequestMapping(value="/profSrvyQstnMngView.do")
    public String profSrvyQstnMngView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvyQstnMngView(vo, userCtx);

        EgovMap egovMap = srvyMainView.getEgovMap();
        egovMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_SRVY, null));
        model.addAttribute("vo", egovMap);
        model.addAttribute("srvyTeamList", srvyMainView.getEgovList());
        model.addAttribute("isQstnsCmptn", srvyMainView.getIsQstnsCmptn());
        model.addAttribute("qstnRspnsTycdList", srvyMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", srvyMainView.getCmmnCdList().get("qstnDfctlvTycd"));
        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        model.addAttribute("userCtx", userCtx);

        return "srvy/prof_srvy_qstn_mng_view";
    }

    /**
     * 설문지문항목록조회
     *
     * @param srvyId 	설문아이디
     * @return 설문지문항목록
     */
    @RequestMapping(value={"/srvypprQstnListAjax.do", "/admSrvypprQstnListAjax.do"})
    @ResponseBody
    public ResultDTO<SrvyMainView> srvypprQstnListAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<SrvyMainView>().setData(srvyFacadeService.getSrvypprQstnList(vo)).setResultSuccess();
    }

    /**
     * 설문지등록팝업
     *
     * @param srvyId 	설문아이디
     * @return srvyppr_regist_pop.jsp
     */
    @RequestMapping(value={"/profSrvypprRegistPopup.do", "/admSrvypprRegistPopup.do"})
    public String profSrvypprRegistPopup(SrvypprVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        model.addAttribute("vo", vo);
        model.addAttribute("userCtx", userCtx);

        return "srvy/popup/srvyppr_regist_pop";
    }

    /**
     * 설문지등록
     *
     * @param SrvypprVO 설문지 정보
     */
    @RequestMapping(value={"/srvypprRegistAjax.do", "/admSrvypprRegistAjax.do"})
    @ResponseBody
    public ResultDTO<SrvypprVO> srvypprRegistAjax(SrvypprVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        srvyFacadeService.srvypprRegist(vo);

        return new ResultDTO<SrvypprVO>().setResultSuccess();
    }

    /**
     * 설문지수정팝업
     *
     * @param srvyId 		설문아이디
     * @param srvypprId 	설문지아이디
     * @return srvyppr_regist_pop.jsp
     */
    @RequestMapping(value={"/profSrvypprModifyPopup.do", "/admSrvypprModifyPopup.do"})
    public String profSrvypprModifyPopup(SrvypprVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvypprModifyPopup(vo);
    	SrvypprVO srvyppr = srvyMainView.getSrvypprVO();
    	srvyppr.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_SRVY, srvyppr.getSrvyId()));
        request.setAttribute("vo", srvyppr);
        model.addAttribute("userCtx", userCtx);

        return "srvy/popup/srvyppr_regist_pop";
    }

    /**
     * 설문지참여수조회
     *
     * @param sbjctId 	과목아이디
     * @param srvyId 	설문아이디
     * @param srvypprId 설문지아이디
     * @return 설문지참여수조회
     */
    @RequestMapping(value="/srvypprPtcpCntSelectAjax.do")
    @ResponseBody
    public ResultDTO<SrvyVO> srvypprPtcpCntSelectAjax(SrvypprVO vo, ModelMap model, HttpServletRequest request) {
    	ResultDTO<SrvyVO> resultVO = new ResultDTO<SrvyVO>();
        resultVO.setResult(srvyFacadeService.getSrvypprPtcpCntSelect(vo));

        return resultVO;
    }

    /**
     * 설문지삭제
     *
     * @param srvyId 		설문아이디
     * @param srvypprId 	설문지아이디
     * @param srvySeqno 	설문지순번
     */
    @RequestMapping(value={"/srvypprDeleteAjax.do", "/admSrvypprDeleteAjax.do"})
    @ResponseBody
    public ResultDTO<SrvypprVO> srvypprDeleteAjax(SrvypprVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        srvyFacadeService.srvypprDelete(vo);

        return new ResultDTO<SrvypprVO>().setResultSuccess();
    }

    /**
     * 교수설문문제복사팝업
     *
     * @param sbjctId	과목아이디
     * @param srvyId 	설문아이디
     * @return prof_srvy_qstn_copy_pop.jsp
     */
    @RequestMapping(value="/profSrvyQstnCopyPopup.do")
    public String profSrvyQstnCopyPopup(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	vo.setOrgId(userCtx.getOrgId());
        model.addAttribute("srvySearchSmstrList", srvyFacadeService.loadProfSrvyQstnCopyPopup(vo).getEgovList());
        vo.setUserId(userCtx.getUserId());
        model.addAttribute("vo", vo);

        return "srvy/popup/prof_srvy_qstn_copy_pop";
    }

    /**
     * 문제가져오기설문목록조회
     *
     * @param sbjctId 		과목이이디
     * @return 설문목록
     */
    @RequestMapping(value="/copyQstnSrvyListAjax.do")
    @ResponseBody
    public ResultDTO<SrvyVO> copyQstnSrvyListAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) {
    	return new ResultDTO<SrvyVO>().setReturnList(srvyFacadeService.getQstnCopySrvyList(vo).getSrvyList()).setResultSuccess();
    }

    /**
     * 문제가져오기설문지목록조회
     *
     * @param srvyId 	설문아이디
     * @return 설문지목록
     */
    @RequestMapping(value={"/copyQstnSrvypprListAjax.do", "/admCopyQstnSrvypprListAjax.do"})
    @ResponseBody
    public ResultDTO<SrvypprVO> copyQstnSrvypprListAjax(SrvypprVO vo, ModelMap model, HttpServletRequest request) {
    	return new ResultDTO<SrvypprVO>().setReturnList(srvyFacadeService.getQstnCopySrvypprList(vo).getSrvypprList()).setResultSuccess();
    }

    /**
     * 문항복사설문문항목록조회
     *
     * @param srvypprId 설문지아이디
     * @return 설문문항목록
     */
    @RequestMapping(value={"/profQstnCopySrvyQstnListAjax.do", "/admQstnCopySrvyQstnListAjax.do"})
    @ResponseBody
    public ResultDTO<EgovMap> profQstnCopySrvyQstnListAjax(SrvyQstnVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(srvyFacadeService.getQstnCopySrvyQstnList(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 설문문항가져오기
     *
     * @param copySrvyQstnId	복사설문문항아이디
     * @param srvyId 			설문아이디
     */
    @RequestMapping(value={"/profSrvyQstnCopyAjax.do", "/admSrvyQstnCopyAjax.do"})
    @ResponseBody
    public ResultDTO<SrvyQstnVO> profSrvyQstnCopyAjax(@RequestBody List<Map<String, Object>> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(map -> map.put("rgtrId", userCtx.getUserId()));
        srvyFacadeService.srvyQstnCopy(list);

        return new ResultDTO<SrvyQstnVO>().setResultSuccess();
    }

    /**
     * 설문문항엑셀업로드팝업
     *
     * @param srvyId	설문아이디
     * @return srvy_qstn_excel_upload_pop.jsp
     */
    @RequestMapping(value={"/profSrvyQstnExcelUploadPopup.do", "/admSrvyQstnExcelUploadPopup.do"})
    public String profSrvyQstnExcelUploadPopup(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setUserId(userCtx.getUserId());
        vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_SRVY, vo.getSrvyId()));	// 첨부파일저장소 설정
        model.addAttribute("vo", vo);
        model.addAttribute("userCtx", userCtx);

        return "srvy/popup/srvy_qstn_excel_upload_pop";
    }

    /**
     * 설문문항등록샘플엑셀다운로드
     *
     * @param srvyId		설문아이디
     * @param excelGrid 	엑셀그리드
     */
    @RequestMapping(value={"/profSrvyQstnRegistSampleExcelDown.do", "/admSrvyQstnRegistSampleExcelDown.do"})
    public String profSrvyQstnRegistSampleExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) {
    	HashMap<String, Object> map = srvyFacadeService.getSrvyQstnExcelSampleData(vo).getSrvyQstnSampleMap();
        List<EgovMap> list = null;
        if (map != null) {
            list = (List<EgovMap>) map.get("list");
        }

        //엑셀 정보값 세팅
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("outFileName", getMessage("srvy.label.qstn"));	// 문항
        params.put("sheetName", "sample");
        params.put("list", list);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        params.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(params);

        return "excelView";
    }

    /**
     * 설문문항엑셀업로드
     *
     * @param srvyId 		설문아이디
     * @param uploadFiles 	파일목록
     * @param uploadPath 	파일경로
     * @param excelGrid 	엑셀그리드
     * @return excelView
     */
    @RequestMapping(value={"/profSrvyQstnExcelUpload.do", "/admSrvyQstnExcelUpload.do"})
    @ResponseBody
    public ResultDTO<SrvyVO> profSrvyQstnExcelUpload(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setOrgId(userCtx.getOrgId());
        vo.setRgtrId(userCtx.getUserId());

        return srvyFacadeService.srvyQstnExcelUpload(vo);
    }

    /**
     * 설문문항등록
     *
     * @param SrvyQstnVO 문항정보
     * @return ResultDTO<SrvyQstnVO>
     */
    @RequestMapping(value={"/srvyQstnRegistAjax.do", "/admSrvyQstnRegistAjax.do"})
    @ResponseBody
    public ResultDTO<SrvyQstnVO> srvyQstnRegistAjax(SrvyQstnVO vo, @CurrentUser UserContext userCtx,
    			@RequestParam(value="qstns", defaultValue="[]") String qstnsStr,
    			@RequestParam(value="lvls", defaultValue="[]") String lvlsStr,
    			ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        srvyFacadeService.srvyQstnRegist(vo, qstnsStr, lvlsStr);

        return new ResultDTO<SrvyQstnVO>().setResultSuccess();
    }

    /**
     * 설문문항수정
     *
     * @param QstnVO 문항 정보
     * @return ResultDTO<QstnVO>
     */
    @RequestMapping(value={"/srvyQstnModifyAjax.do", "/admSrvyQstnModifyAjax.do"})
    @ResponseBody
    public ResultDTO<SrvyQstnVO> srvyQstnModifyAjax(SrvyQstnVO vo, @CurrentUser UserContext userCtx,
				@RequestParam(value="qstns", defaultValue="[]") String qstnsStr,
				@RequestParam(value="lvls", defaultValue="[]") String lvlsStr,
				ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        srvyFacadeService.srvyQstnModify(vo, qstnsStr, lvlsStr);

        return new ResultDTO<SrvyQstnVO>().setResultSuccess();
    }

    /**
     * 설문문항삭제
     *
     * @param srvypprId 	설문지아이디
     * @param srvyQstnId 	설문문항아이디
     * @param qstnSeqno 	문항순번
     */
    @RequestMapping(value={"/srvyQstnDeleteAjax.do", "/admSrvyQstnDeleteAjax.do"})
    @ResponseBody
    public ResultDTO<SrvyQstnVO> srvyQstnDeleteAjax(SrvyQstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        srvyFacadeService.srvyQstnDelete(vo);

        return new ResultDTO<SrvyQstnVO>().setResultSuccess();
    }

    /**
     * 설문문항정보조회
     *
     * @param srvypprId 	설문지아이디
     * @param srvyQstnId    설문문항아이디
     * @return 설문문항정보
     */
    @RequestMapping(value={"/srvyQstnSelectAjax.do", "/admSrvyQstnSelectAjax.do"})
    @ResponseBody
    public ResultDTO<SrvyMainView> srvyQstnSelectAjax(SrvyQstnVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<SrvyMainView>().setData(srvyFacadeService.getSrvyQstn(vo)).setResultSuccess();
    }

    /**
     * 설문지순번수정
     *
     * @param srvyId 	설문아이디
     * @param srvySeqno 변경할 설문지순번
     * @param searchKey 설문지순번
     */
    @RequestMapping(value={"/srvySeqnoModifyAjax.do", "/admSrvySeqnoModifyAjax.do"})
    @ResponseBody
    public ResultDTO<SrvypprVO> srvySeqnoModifyAjax(SrvypprVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        srvyFacadeService.srvySeqnoModify(vo);

        return new ResultDTO<SrvypprVO>().setResultSuccess();
    }

    /**
     * 문항순번수정
     *
     * @param srvypprId 	설문지아이디
     * @param qstnSeqno 	변경할 문항순번
     * @param searchKey 	문항순번
     */
    @RequestMapping(value={"/qstnSeqnoModifyAjax.do", "/admQstnSeqnoModifyAjax.do"})
    @ResponseBody
    public ResultDTO<SrvyQstnVO> qstnSeqnoModifyAjax(SrvyQstnVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
	    vo.setMdfrId(userCtx.getUserId());
	    srvyFacadeService.qstnSeqnoModify(vo);

    	return new ResultDTO<SrvyQstnVO>().setResultSuccess();
    }

    /**
     * 설문문제출제완료수정
     *
     * @param upSrvyId   	상위설문아이디
     * @param srvyId   		설문아이디
     * @param srvyGbncd   	설문구분코드 ( SRVY_TEAM, SRVY )
     * @param searchGubun 	수정상태 ( save, edit )
     * @param searchKey 	( bsc, dtl )
     * @return ResultDTO<SrvyVO>
     */
    @RequestMapping(value={"/srvyQstnsCmptnModifyAjax.do", "/admSrvyQstnsCmptnModifyAjax.do"})
    @ResponseBody
    public ResultDTO<SrvyVO> srvyQstnsCmptnModifyAjax(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setMdfrId(userCtx.getUserId());
        srvyFacadeService.srvyQstnsCmptnModify(vo);

        return new ResultDTO<SrvyVO>().setResultSuccess();
    }

    /**
     * 교수설문평가관리화면
     *
     * @param srvyId 	설문아이디
     * @param sbjctId 	과목아이디
     * @return prof_srvy_evl_mng_view.jsp
     */
    @RequestMapping(value="/profSrvyEvlMngView.do")
    public String profSrvyEvlMngView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
		model.addAttribute("vo", srvyFacadeService.loadProfSrvyEvlMngView(vo).getEgovMap());
		model.addAttribute("userCtx", userCtx);

        return "srvy/prof_srvy_evl_mng_view";
    }

    /**
     * 교수설문참여목록조회
     *
     * @param srvyId     	설문아이디
     * @param ptcpyn 		참여여부
     * @param srvyPtcpEvlyn 설문참여평가여부
     * @param searchValue   검색어(학과, 학번, 이름)
     * @return 설문참여목록
     */
    @RequestMapping(value="/profSrvyPtcpListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profSrvyPtcpListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(srvyFacadeService.getSrvyPtcpList(params).getEgovList()).setResultSuccess();
    }

    /**
     * 교수설문지평가팝업
     *
     * @param upSrvyId 			상위설문아이디
     * @param srvyId 			설문아이디
     * @param srvyPtcpId 		설문참여아이디
     * @param userId    		사용자아이디
     * @param srvyPtcpEvlyn    	평가여부
     * @param ptcpyn    		참여여부
     * @param searchValue    	검색어(학과, 학번, 이름)
     * @return prof_srvyppr_evl_pop.jsp
     */
    @RequestMapping(value="/profSrvypprEvlPopup.do")
    public String profSrvypprEvlPopup(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvypprEvlPopup(params);
        model.addAttribute("params", params);
        model.addAttribute("vo", srvyMainView.geteMap().get("srvyVO"));
        model.addAttribute("srvyPtcpnt", srvyMainView.geteMap().get("ptcpnt"));
        model.addAttribute("srvyPtcpList", srvyMainView.getEgovList());
        model.addAttribute("srvypprList", srvyMainView.getSrvypprList());
        model.addAttribute("srvyQstnList", srvyMainView.getSrvyQstnList());
        model.addAttribute("srvyVwitmList", srvyMainView.getSrvyVwitmList());
        model.addAttribute("srvyQstnVwitmLvlList", srvyMainView.getSrvyQstnVwitmLvlList());
        model.addAttribute("srvyRspnsList", srvyMainView.getSrvyRspnsList());

        return "srvy/popup/prof_srvyppr_evl_pop";
    }

    /**
     * 설문문항분포차트
     *
     * @param srvyId  		설문아이디
     * @param srvyQstnId 	설문문항아이디
     * @param srvypprId 	설문지아이디
     * @return 설문문항분포
     */
    @RequestMapping(value="/srvyQstnDistributionChartAjax.do")
    @ResponseBody
    public ResultDTO<SrvyMainView> srvyQstnDistributionChartAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<SrvyMainView>().setData(srvyFacadeService.getSrvyQstnDistributionChart(params)).setResultSuccess();
    }

    /**
     * 교수설문지인쇄팝업
     *
     * @param upSrvyId 	상위설문아이디
     * @param srvyId   	설문아이디
     * @param userId   	사용자아이디
     * @return prof_srvyppr_print_pop.jsp
     */
    @RequestMapping(value="/profSrvypprPrintPopup.do")
    public String profSrvypprPrintPopup(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvypprPrintPopup(params);
    	model.addAttribute("params", params);
        model.addAttribute("srvyPtcpnt", srvyMainView.getEgovMap());
        model.addAttribute("srvypprList", srvyMainView.getSrvypprList());
        model.addAttribute("srvyQstnList", srvyMainView.getSrvyQstnList());
        model.addAttribute("srvyVwitmList", srvyMainView.getSrvyVwitmList());
        model.addAttribute("srvyQstnVwitmLvlList", srvyMainView.getSrvyQstnVwitmLvlList());
        model.addAttribute("srvyRspnsList", srvyMainView.getSrvyRspnsList());

        return "srvy/popup/prof_srvyppr_print_pop";
    }

    /**
	* 교수설문메모팝업
	*
	* @param srvyId 		설문아이디
	* @param srvyPtcpId 	설문참여아이디
	* @param userId 		사용자아이디
	* @return prof_quiz_memo_pop.jsp
	*/
    @RequestMapping(value="/profSrvyMemoPopup.do")
    public String profSrvyMemoPopup(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvyMemoPopup(params);
        model.addAttribute("vo", srvyMainView.geteMap().get("srvyVO"));
        model.addAttribute("srvyPtcpnt", srvyMainView.geteMap().get("ptcpnt"));
        model.addAttribute("profMemo", srvyMainView.geteMap().get("profMemo"));

		return "srvy/popup/prof_srvy_memo_pop";
    }

    /**
	* 설문교수메모수정
	*
	* @param examDtlId 	시험상세아이디
	* @param tkexamId 	시험응시아이디
	* @param userId 	사용자아이디
	* @param profMemo 	교수메모
	*/
    @RequestMapping(value="/srvyProfMemoModifyAjax.do")
    @ResponseBody
    public ResultDTO<SrvyPtcpVO> srvyProfMemoModifyAjax(@RequestBody Map<String, Object> params, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        params.put("rgtrId", userCtx.getUserId());
        srvyFacadeService.profMemoModify(params);

        return new ResultDTO<SrvyPtcpVO>().setResultSuccess();
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
    @RequestMapping(value="/profSrvyEvlScrBulkModifyAjax.do")
    @ResponseBody
    public ResultDTO<SrvyVO> profSrvyEvlScrBulkModifyAjax(@RequestBody List<Map<String, Object>> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(map -> map.put("rgtrId", userCtx.getUserId()));
        srvyFacadeService.profSrvyEvlScrBulkModify(list);

        return new ResultDTO<SrvyVO>().setResultSuccess();
    }

    /**
     * 설문결과팝업
     *
     * @param srvyId 	설문아이디
     * @param sbjctId 	과목아이디
     * @return srvy_ptcp_status_pop.jsp
     */
    @RequestMapping(value="/srvyPtcpStatusPopup.do")
    public String srvyPtcpStatusPopup(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadSrvyPtcpStatusPopup(vo, userCtx);

    	model.addAttribute("vo", srvyMainView.geteMap().get("srvyVO"));
    	if("SRVY_TEAM".equals(srvyMainView.geteMap().get("srvyVO").get("srvyGbn"))) {
    		model.addAttribute("srvyTeamList", srvyMainView.getEgovList());
    	}
    	model.addAttribute("cntnDvcTycdList", srvyMainView.getCmmnCdList().get("cntnDvcTycd"));
    	model.addAttribute("srvyPtcpDvcStatusList", srvyMainView.getEgovListMap().get("ptcpDvcList"));
    	model.addAttribute("srvyPtcpCnt", srvyMainView.geteMap().get("ptcpCnt"));
    	model.addAttribute("srvypprList", srvyMainView.getSrvypprList());
    	model.addAttribute("srvyQstnList", srvyMainView.getSrvyQstnList());
    	model.addAttribute("srvyVwitmList", srvyMainView.getSrvyVwitmList());
    	model.addAttribute("srvyQstnVwitmLvlList", srvyMainView.getSrvyQstnVwitmLvlList());
    	model.addAttribute("chcRspnsList", srvyMainView.getEgovListMap().get("chcRspnsList"));
    	model.addAttribute("textRspnsList", srvyMainView.getEgovListMap().get("textRspnsList"));
    	model.addAttribute("levelRspnsList", srvyMainView.getEgovListMap().get("levelRspnsList"));
    	model.addAttribute("colorList", srvyMainView.getColorList());
    	model.addAttribute("userTycd", userCtx.getUserTycd());

        return "srvy/popup/srvy_ptcp_status_pop";
    }

    /**
     * 교수설문엑셀성적등록팝업
     *
     * @param srvyId 	설문아이디
     * @return prof_srvy_excel_scr_regist_pop.jsp
     */
    @RequestMapping(value="/profSrvyExcelScrRegistPopup.do")
    public String profSrvyExcelScrRegistPopup(SrvyVO vo, ModelMap model, HttpServletRequest request) {
    	vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_SRVY, vo.getSrvyId()));
        request.setAttribute("vo", vo);

        return "srvy/popup/prof_srvy_excel_scr_regist_pop";
    }

    /**
     * 교수설문성적등록샘플엑셀다운로드
     *
     * @param srvyId 		설문아이디
     * @param excelGrid 	엑셀그리드
     * @return excelView
     */
    @RequestMapping(value="/profSrvyScrRegistSampleExcelDown.do")
    public String profSrvyScrRegistSampleExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) {
        String title = getMessage("common.label.student.list");	// 학습자목록

        Map<String, Object> searchMap = new HashMap<String, Object>();
        searchMap.put("srvyId", vo.getSrvyId());
        List<EgovMap> srvyPtcpList = srvyFacadeService.getSrvyPtcpList(searchMap).getEgovList();

        // POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        // 엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", srvyPtcpList);

        HashMap<String, Object> params = new HashMap<>();
        params.put("outFileName", title);
        params.put("sheetName", title);
        params.put("list", srvyPtcpList);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        params.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(params);

        return "excelView";
    }

    /**
     * 교수설문성적엑셀업로드
     *
     * @param srvyId 		설문아이디
     * @param uploadFiles 	파일목록
     * @param uploadPath 	파일경로
     * @param excelGrid 	엑셀그리드
     * @return excelView
     */
    @RequestMapping(value="/profSrvyScrExcelUpload.do")
    @ResponseBody
    public ResultDTO<SrvyPtcpVO> profSrvyScrExcelUpload(SrvyPtcpVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        srvyFacadeService.srvyScrExcelUpload(vo);

        return new ResultDTO<SrvyPtcpVO>().setResultSuccess();
    }

    /**
     * 교수설문참여목록엑셀다운로드
     *
     * @param srvyId     		설문아이디
     * @param ptcpyn 			참여여부
     * @param srvyPtcpEvlyn 	설문참여평가여부
     * @param searchValue   	검색어(학과, 학번, 이름)
     * @param excelGrid 		엑셀그리드
     * @return excelView
     */
    @RequestMapping(value="/profSrvyPtcpListExcelDown.do")
    public String profSrvyPtcpListExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) {
    	String title = getMessage("srvy.label.ptcp.list");	// 참여목록
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("srvyId", vo.getSrvyId());
        params.put("ptcpyn", request.getParameter("ptcpyn"));
        params.put("srvyPtcpEvlyn", request.getParameter("srvyPtcpEvlyn"));
        params.put("searchValue", vo.getSearchValue());
        map.put("list", srvyFacadeService.getSrvyPtcpList(params).getEgovList());

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /**
     * 교수설문참여현황엑셀다운로드
     *
     * @param srvyId 	설문아이디
     * @param sbjctId 	과목아이디
     * @return excelView
     */
    @RequestMapping(value="/profSrvyPtcpStatusExcelDown.do")
    public String profSrvyPtcpStatusExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) {
        String title = getMessage("srvy.button.srvy.result");	// 설문결과
        SrvyMainView srvyMainView = srvyFacadeService.getSrvyPtcpStatusExcelDownList(vo);

        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("list", srvyMainView);

        //엑셀화
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title);
        modelMap.put("workbook", makeSrvyPtcpStatusExcel(map, request));
        modelMap.put("list", srvyMainView);
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /**
     * 교수설문답변현황엑셀다운로드
     *
     * @param srvyId 	설문아이디
     * @param sbjctId 	과목아이디
     * @return excelView
     */
    @RequestMapping(value="/profSrvyRspnsStatusExcelDown.do")
    public String profSrvyRspnsStatusExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) {
        String title = getMessage("srvy.label.ptcp.rspns.list");	// 참여자 답변 목록
        SrvyMainView srvyMainView = srvyFacadeService.getSrvyRspnsStatusExcelDownList(vo);

        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("list", srvyMainView);

        //엑셀화
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", getMessage("srvy.label.ptcp.srvy"));	// 제출설문
        modelMap.put("workbook", makeSrvyRspnsStatusExcel(map, request));
        modelMap.put("list", srvyMainView);
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    // 교수설문참여현황엑셀생성
    public SXSSFWorkbook makeSrvyPtcpStatusExcel(HashMap<String, Object> map, HttpServletRequest request) {
        String sheetName = StringUtil.nvl(map.get("sheetName"),"sheet1");

        String ext = StringUtil.nvl(map.get("ext"));
        if(StringUtil.isNull(ext)) {
            ext = ".xlsx";
        }

        SXSSFWorkbook workbook = null;
        SXSSFSheet worksheet = null;
        SXSSFRow row = null;

        workbook = new SXSSFWorkbook();
        // 새로운 sheet를 생성한다.
        worksheet = workbook.createSheet(sheetName);

        //페이지 제목 폰트 설정
        Font pageTitleFont = workbook.createFont();
        pageTitleFont.setFontHeight((short)(16*22)); //사이즈
        pageTitleFont.setBold(true);

        //문항 제목 폰트 설정
        Font titleFont = workbook.createFont();
        titleFont.setFontHeight((short)(16*12)); //사이즈
        titleFont.setBold(true);

        //문항 아이템 폰트 설정
        Font itemFont = workbook.createFont();
        itemFont.setFontHeight((short)(16*12)); //사이즈
        itemFont.setBold(true);

        //답변현황 폰트 설정
        Font answerFont = workbook.createFont();
        answerFont.setFontHeight((short)(16*12)); //사이즈
        answerFont.setBold(false);

        //척도 타이틀 폰트 설정
        Font scaleFont = workbook.createFont();
        scaleFont.setFontHeight((short)(16*12)); //사이즈
        scaleFont.setBold(true);

        // 페이지 제목 셀 스타일 및 폰트 설정
        CellStyle pageTitleStyle = workbook.createCellStyle();
        pageTitleStyle.setAlignment(HorizontalAlignment.LEFT);
        pageTitleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        pageTitleStyle.setBorderRight(BorderStyle.NONE);
        pageTitleStyle.setBorderLeft(BorderStyle.NONE);
        pageTitleStyle.setBorderTop(BorderStyle.NONE);
        pageTitleStyle.setBorderBottom(BorderStyle.NONE);
        pageTitleStyle.setFont(pageTitleFont);

        // 문항 제목 셀 스타일 및 폰트 설정
        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setAlignment(HorizontalAlignment.LEFT);
        titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        titleStyle.setBorderRight(BorderStyle.NONE);
        titleStyle.setBorderLeft(BorderStyle.NONE);
        titleStyle.setBorderTop(BorderStyle.NONE);
        titleStyle.setBorderBottom(BorderStyle.NONE);
        titleStyle.setFont(titleFont);

        // 문항 아이템 셀 스타일 및 폰트 설정
        CellStyle itemStyle = workbook.createCellStyle();
        itemStyle.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
        itemStyle.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        itemStyle.setBorderRight(BorderStyle.THIN);
        itemStyle.setBorderLeft(BorderStyle.THIN);
        itemStyle.setBorderTop(BorderStyle.THIN);
        itemStyle.setBorderBottom(BorderStyle.THIN);
        itemStyle.setFont(itemFont);

        // 답변 현황 셀 스타일 및 폰트 설정
        CellStyle answerStyle = workbook.createCellStyle();
        answerStyle.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
        answerStyle.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        answerStyle.setBorderRight(BorderStyle.THIN);
        answerStyle.setBorderLeft(BorderStyle.THIN);
        answerStyle.setBorderTop(BorderStyle.THIN);
        answerStyle.setBorderBottom(BorderStyle.THIN);
        answerStyle.setFont(answerFont);

        // 답변 카운트 셀 스타일 및 폰트 설정
        CellStyle answerCntStyle = workbook.createCellStyle();
        answerCntStyle.setAlignment(HorizontalAlignment.CENTER); //왼쪽 정렬
        answerCntStyle.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        answerCntStyle.setBorderRight(BorderStyle.THIN);
        answerCntStyle.setBorderLeft(BorderStyle.THIN);
        answerCntStyle.setBorderTop(BorderStyle.THIN);
        answerCntStyle.setBorderBottom(BorderStyle.THIN);
        answerCntStyle.setFont(answerFont);

        // 척도 타이틀 셀 스타일 및 폰트 설정
        CellStyle scaleStyle = workbook.createCellStyle();
        scaleStyle.setAlignment(HorizontalAlignment.CENTER); //왼쪽 정렬
        scaleStyle.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        scaleStyle.setBorderRight(BorderStyle.THIN);
        scaleStyle.setBorderLeft(BorderStyle.THIN);
        scaleStyle.setBorderTop(BorderStyle.THIN);
        scaleStyle.setBorderBottom(BorderStyle.THIN);
        scaleStyle.setFont(scaleFont);

        // 칼럼 길이 설정
        worksheet.setColumnWidth(0, 15000);
        worksheet.setColumnWidth(1, 5000);
        worksheet.setColumnWidth(2, 5000);
        worksheet.setColumnWidth(3, 5000);
        worksheet.setColumnWidth(4, 5000);
        worksheet.setColumnWidth(5, 5000);
        worksheet.setColumnWidth(6, 5000);
        worksheet.setColumnWidth(7, 5000);
        worksheet.setColumnWidth(8, 5000);
        worksheet.setColumnWidth(9, 5000);
        worksheet.setColumnWidth(10, 5000);

        SrvyMainView srvyMainView = (SrvyMainView) map.get("list");
        // 설문지목록
        List<SrvypprVO> srvypprList = srvyMainView.getSrvypprList();
        if (srvypprList == null || srvypprList.isEmpty() || srvypprList.size() == 0) {
            return workbook;
        }
        // 설문문항목록
        List<EgovMap> qstnList = srvyMainView.getSrvyQstnList();
        if (qstnList == null || qstnList.isEmpty() || qstnList.size() == 0) {
            return workbook;
        }

        int rowNum = -1;
        for (SrvypprVO srvyppr : srvypprList) {
        	if("SRVY_TEAM".equals(srvyMainView.getEgovMap().get("srvyGbn")) && srvyppr.getSrvySeqno() == 1) {
        		// 설문팀목록
        		for(EgovMap team : srvyMainView.getEgovList()) {
        			if(srvyppr.getSrvyId().equals(team.get("srvyId"))) {
        				row = worksheet.createRow(++rowNum);
        	            row.createCell(0).setCellValue(team.get("teamnm").toString());
        	            row.getCell(0).setCellStyle(pageTitleStyle);
        	            row = worksheet.createRow(++rowNum); // 빈 row
        			}
        		}
        	}

            row = worksheet.createRow(++rowNum);
            row.createCell(0).setCellValue(srvyppr.getSrvySeqno() + ". " + srvyppr.getSrvyTtl());
            row.getCell(0).setCellStyle(pageTitleStyle);

            for (EgovMap qstn : qstnList) {
            	String srvypprId = (String) qstn.get("srvypprId");
            	if(srvypprId.equals(srvyppr.getSrvypprId())) {
            		row = worksheet.createRow(++rowNum);
            		StringBuilder qstnTitle = new StringBuilder()
            				.append(srvyppr.getSrvySeqno())
            				.append("-")
            				.append(qstn.get("qstnSeqno"))
            				.append(". ")
            				.append(qstn.get("qstnTtl"))
            				.append(" [")
            				.append(qstn.get("qstnRspnsTynm"))
            				.append("]");

            		row.createCell(0).setCellValue(qstnTitle.toString());
            		row.getCell(0).setCellStyle(titleStyle);

            		String reschQstnTypeCd = (String) qstn.get("qstnRspnsTycd");

            		// 단일선택형, 다중선택형, OX선택형
            		if ("ONE_CHC".equals(reschQstnTypeCd) || "MLT_CHC".equals(reschQstnTypeCd) || "OX_CHC".equals(reschQstnTypeCd)) {
            			List<EgovMap> rspnsList = srvyMainView.getEgovListMap().get("chcRspnsList");
            			for (EgovMap rspns : rspnsList) {
            				if(qstn.get("srvyQstnId").equals(rspns.get("srvyQstnId"))) {
            					row = worksheet.createRow(++rowNum);

            					// 문항아이템(문항 선택지)
            					String itemTitle = rspns.get("vwitmCts").toString();
            					if ("ETC".equals(itemTitle) ) {
									itemTitle = getMessage("srvy.label.vwitm.etc");	/* 기타 보기 */
            					}
            					row.createCell(0).setCellValue(itemTitle);
            					row.getCell(0).setCellStyle(itemStyle);

            					// 문항 답변 현황
            					StringBuilder answerStatus = new StringBuilder(rspns.get("ratio").toString())
            							.append("%")
            							.append(" (")
            							.append(rspns.get("totJoinCnt").toString())
            							.append(getMessage("message.person"))	/*명*/
            							.append(" ")
            							.append(getMessage("common.label.of"))	/*중*/
            							.append(" ")
            							.append(rspns.get("joinCnt").toString())
            							.append(getMessage("message.person"))	/*명*/
            							.append(")");
            					row.createCell(1).setCellValue(answerStatus.toString());
            					row.getCell(1).setCellStyle(answerStyle);

            					// 문항 답변 카운트
            					row.createCell(2).setCellValue(rspns.get("joinCnt").toString() + getMessage("message.person"));	/*명*/
            					row.getCell(2).setCellStyle(answerCntStyle);
            				}
            			}

            		// 서술형
            		} else if ("LONG_TEXT".equals(reschQstnTypeCd)) {
            			List<EgovMap> rspnsList = srvyMainView.getEgovListMap().get("textRspnsList");
            			if (rspnsList != null && !rspnsList.isEmpty() && rspnsList.size() > 0) {
            				for (EgovMap rspns : rspnsList) {
            					if(qstn.get("srvyQstnId").equals(rspns.get("srvyQstnId"))) {
            						row = worksheet.createRow(++rowNum);
            						row.createCell(0).setCellValue(rspns.get("usernm").toString());
            						row.getCell(0).setCellStyle(answerCntStyle);

            						row.createCell(1).setCellValue(rspns.get("rspns").toString());
            						row.getCell(1).setCellStyle(answerStyle);
            					}
            				}
            			}

            		// 레벨형
            		} else if ("LEVEL".equals(reschQstnTypeCd)) {
            			row = worksheet.createRow(++rowNum);
            			row.createCell(0).setCellValue("");
            			row.getCell(0).setCellStyle(scaleStyle);

            			int idx = 1;
            			String srvyQstnId = qstn.get("srvyQstnId").toString();
            			List<SrvyQstnVwitmLvlVO> lvlList = srvyMainView.getSrvyQstnVwitmLvlList();
            			for (SrvyQstnVwitmLvlVO lvl : lvlList) {
            				if(srvyQstnId.equals(lvl.getSrvyQstnId())) {
            					row.createCell(idx).setCellValue(lvl.getLvlCts());
            					row.getCell(idx).setCellStyle(scaleStyle);
            					idx++;
            				}
            			}

            			List<SrvyVwitmVO> vwitmList = srvyMainView.getSrvyVwitmList();
            			for(SrvyVwitmVO vwitm : vwitmList) {
            				if(srvyQstnId.equals(vwitm.getSrvyQstnId())) {
            					row = worksheet.createRow(++rowNum);
            					row.createCell(0).setCellValue(vwitm.getVwitmCts());
            					row.getCell(0).setCellStyle(itemStyle);
            					List<EgovMap> rspnsList = srvyMainView.getEgovListMap().get("levelRspnsList");
            					if (rspnsList != null && !rspnsList.isEmpty() && rspnsList.size() > 0) {
            						for(EgovMap rspns : rspnsList) {
            							String srvyVwitmId = rspns.get("srvyVwitmId").toString();
            							if(srvyVwitmId.equals(vwitm.getSrvyVwitmId())) {
            								StringBuilder answerStatus = new StringBuilder(rspns.get("ratio").toString())
            										.append("%")
            										.append(" (")
            										.append(rspns.get("totJoinCnt").toString())
            										.append(getMessage("message.person"))	/*명*/
            										.append(" ")
            										.append(getMessage("common.label.of"))	/*중*/
            										.append(" ")
            										.append(rspns.get("joinCnt").toString())
            										.append(getMessage("message.person"))	/*명*/
            										.append(")");

            								int seqno = Integer.valueOf(rspns.get("lvlSeqno").toString());
            								row.createCell(seqno).setCellValue(answerStatus.toString());
            								row.getCell(seqno).setCellStyle(answerStyle);
            							}
            						}
            					}
            				}
            			}
            		}

            		row = worksheet.createRow(++rowNum); // 빈 row(문항과 문항 사이에 한깐 띄운다)
            	}
            }
            row = worksheet.createRow(++rowNum); // 빈 row(페이지와 페이지 사이에 한깐 띄운다)
        }

        return workbook;
    }

    // 교수설문답변현황엑셀생성
    public SXSSFWorkbook makeSrvyRspnsStatusExcel(HashMap<String, Object> map, HttpServletRequest request) {
        String title = StringUtil.nvl(map.get("title"));
        String sheetName = StringUtil.nvl(map.get("sheetName"),"sheet1");

        String ext = StringUtil.nvl(map.get("ext"));
        if(StringUtil.isNull(ext)) {
           ext = ".xlsx";
        }

        SXSSFWorkbook workbook = new SXSSFWorkbook();
        SXSSFSheet worksheet = null;
        SXSSFRow row = null;

        //타이틀 폰트 설정
        Font titleFont = workbook.createFont();
        titleFont.setFontHeight((short)(16*25)); //사이즈
        titleFont.setBold(true);

        //헤더 폰트 설정
        Font headerFont = workbook.createFont();
        headerFont.setFontHeight((short)(16*12)); //사이즈
        headerFont.setBold(true);

        //답변 폰트 설정(헤더가 아닌 나머지 row)
        Font answerFont = workbook.createFont();
        answerFont.setFontHeight((short)(16*12)); //사이즈
        answerFont.setBold(false);


        // 타이틀 셀 스타일 및 폰트 설정
        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setAlignment(HorizontalAlignment.LEFT);
        titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        titleStyle.setBorderRight(BorderStyle.NONE);
        titleStyle.setBorderLeft(BorderStyle.NONE);
        titleStyle.setBorderTop(BorderStyle.NONE);
        titleStyle.setBorderBottom(BorderStyle.NONE);
        titleStyle.setFont(titleFont);

        // 헤더 셀 스타일 및 폰트 설정
        XSSFCellStyle styleHeaderXSS = (XSSFCellStyle) workbook.createCellStyle();
        styleHeaderXSS.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
        styleHeaderXSS.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        styleHeaderXSS.setFillForegroundColor(new XSSFColor(new java.awt.Color(192, 192, 192) ));
        styleHeaderXSS.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        styleHeaderXSS.setBorderRight(BorderStyle.THIN);
        styleHeaderXSS.setBorderLeft(BorderStyle.THIN);
        styleHeaderXSS.setBorderTop(BorderStyle.THIN);
        styleHeaderXSS.setBorderBottom(BorderStyle.THIN);
        styleHeaderXSS.setFont(headerFont);

        // 답변  셀 스타일 및 폰트 설정
        CellStyle answerStyle = workbook.createCellStyle();
        answerStyle.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
        answerStyle.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        answerStyle.setBorderRight(BorderStyle.THIN);
        answerStyle.setBorderLeft(BorderStyle.THIN);
        answerStyle.setBorderTop(BorderStyle.THIN);
        answerStyle.setBorderBottom(BorderStyle.THIN);
        answerStyle.setFont(answerFont);

        // 새로운 sheet를 생성한다.
        worksheet = workbook.createSheet(sheetName);

        SrvyMainView srvyMainView = (SrvyMainView) map.get("list");
        // 설문문항목록
        List<EgovMap> qstnList = srvyMainView.getEgovListMap().get("qstnList");
        int offset = 2;
        worksheet.setColumnWidth(0, 1000);
        worksheet.setColumnWidth(1, 5000);
        for(int i = 0; i < qstnList.size(); i++) {
        	worksheet.setColumnWidth(offset, 10000);
            offset++;
        }

        // title
        int rowNum = -1;
        row = worksheet.createRow(++rowNum);
        row.createCell(0).setCellValue(title);
        row.getCell(0).setCellStyle(titleStyle);
        row = worksheet.createRow(++rowNum); // 빈 row

        int teamCnt = 0;
        String srvyId = "";
        int i = 2;
        // 첫번째 문항 목록
        List<EgovMap> firstQstnList = qstnList.stream()
				    .filter(qstn ->
				    	1 == Integer.valueOf(qstn.get("srvySeqno").toString()) &&
				    	1 == Integer.valueOf(qstn.get("qstnSeqno").toString()) &&
				    	(qstn.get("vwitmSeqno") == null || 1 == Integer.valueOf(qstn.get("vwitmSeqno").toString()))
				    )
				    .collect(Collectors.toList());

        for (EgovMap firstQstn : firstQstnList) {
	        // 설문팀
	        if("SRVY_TEAM".equals(srvyMainView.getEgovMap().get("srvyGbn"))) {
	        	List<EgovMap> teamList = srvyMainView.getEgovListMap().get("teamList");
	        	srvyId = teamList.get(teamCnt).get("srvyId").toString();
	        	row = worksheet.createRow(++rowNum); // 빈 row
	        	row = worksheet.createRow(++rowNum);
	        	row.createCell(0).setCellValue(teamList.get(teamCnt).get("teamnm").toString());
	        	row.getCell(0).setCellStyle(titleStyle);
	        	row = worksheet.createRow(++rowNum); // 빈 row
	        	teamCnt++;
	        } else {
	        	srvyId = firstQstn.get("srvyId").toString();
	        }

	        //header
            row = worksheet.createRow(++rowNum);
            row.createCell(0).setCellValue("No");
            row.createCell(1).setCellValue(getMessage("common.label.sentence.member"));	/*참여자*/
            row.getCell(0).setCellStyle(styleHeaderXSS);
            row.getCell(1).setCellStyle(styleHeaderXSS);
            i = 2;
            final String srvyIdStr = srvyId;

            // 현재 설문 문항 목록
            List<EgovMap> curSrvyQstnList = qstnList.stream()
				    .filter(qstn ->
				    	srvyIdStr.equals(qstn.get("srvyId"))
				    )
				    .collect(Collectors.toList());
            for(EgovMap qstn : curSrvyQstnList) {
	            if ("LEVEL".equals(qstn.get("qstnRspnsTycd")) ) {
	            	row.createCell(i).setCellValue(qstn.get("srvySeqno").toString() + "_" + qstn.get("qstnSeqno").toString() + "_" + qstn.get("vwitmSeqno").toString());
	            } else {
	            	row.createCell(i).setCellValue(qstn.get("srvySeqno").toString() + "_" + qstn.get("qstnSeqno").toString());
	            }

	            row.getCell(i).setCellStyle(styleHeaderXSS);
	            i++;
            }

            // 현재 설문 학습자 목록
            List<EgovMap> curSrvyUserList = srvyMainView.getEgovListMap().get("rspnsList").stream()
            		.filter(user -> srvyIdStr.equals(user.get("srvyId")))
            		.collect(Collectors.toMap(
            				user -> user.get("userId").toString(),  // 키
            				user -> user,                           // 값
            				(existing, duplicate) -> existing       // 중복시 기존(첫번째) 유지
            		))
            		.values()
            		.stream()
            		.collect(Collectors.toList());

            if (curSrvyUserList != null && !curSrvyUserList.isEmpty() && curSrvyUserList.size() > 0) {
            	int idx = 1;
            	for(EgovMap curUser : curSrvyUserList) {
            		row = worksheet.createRow(++rowNum);
					row.createCell(0).setCellValue(idx);
					row.getCell(0).setCellStyle(answerStyle);
					row.createCell(1).setCellValue((String)curUser.get("usernm"));
					row.getCell(1).setCellStyle(answerStyle);
					int j = 2;

					// 현재 학습자 답변 목록
		            List<EgovMap> curUserRspnsList = srvyMainView.getEgovListMap().get("rspnsList").stream()
						    .filter(user ->
						    	curUser.get("userId").equals(user.get("userId")) &&
						    	curUser.get("srvyId").equals(user.get("srvyId"))
						    )
						    .collect(Collectors.toList());

		            for(EgovMap qstn : curSrvyQstnList) {
		            	String rspns = "";
			            if ("LEVEL".equals(qstn.get("qstnRspnsTycd"))) {
			            	rspns = curUserRspnsList.stream()
			            		    .filter(user ->
			            		    	user.get("srvypprId").equals(qstn.get("srvypprId")) &&
			            		    	user.get("srvyQstnId").equals(qstn.get("srvyQstnId")) &&
			            		    	user.get("srvyVwitmId").equals(qstn.get("srvyVwitmId"))
			            		    )
			            		    .findFirst()
			            		    .map(user -> user.get("lvlCts").toString())
			            		    .orElse(null);
			            } else {
			            	rspns = curUserRspnsList.stream()
			            		    .filter(user ->
			            		    	user.get("srvypprId").equals(qstn.get("srvypprId")) &&
			            		    	user.get("srvyQstnId").equals(qstn.get("srvyQstnId"))
			            		    )
			            		    .findFirst()
			            		    .map(user -> Objects.toString(user.get("vwitmCts")))
			            		    .orElse(null);
			            }

			            row.createCell(j).setCellValue(rspns);
	    				row.getCell(j).setCellStyle(answerStyle);

	    				j++;
		            }
            	}
            }
        }

        return workbook;
    }

    /**
     * 설문교수메모일괄수정
     *
     * @param srvyId  		설문아이디
     * @param srvyPtcpId	설문참여아이디
     * @param userId		사용자아이디
     * @param profMemo		교수메모
     */
    @RequestMapping(value="/srvyProfMemoBulkModifyAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> srvyProfMemoBulkModifyAjax(@RequestBody List<Map<String, Object>> list, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	list.forEach(map -> map.put("rgtrId", userCtx.getUserId()));
        srvyFacadeService.profMemoBulkModify(list);

        return new ResultDTO<EgovMap>().setResultSuccess();
    }

    /*****************************************************
     *						학생 화면	 					*
     ******************************************************/

    /**
     * 학생설문목록화면
     *
     * @param sbjctId 과목아이디
     * @return stdnt_srvy_list_view.jsp
     */
    @RequestMapping(value="/stdntSrvyListView.do")
    public String stdntSrvyListView(SrvyVO vo, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("vo", vo);

        return "srvy/stdnt_srvy_list_view";
    }

    /**
     * 학생설문목록조회
     *
     * @param sbjctId     과목아이디
     * @param useId	   	  사용자아이디
     * @param searchValue 검색어 ( 설문명 )
     * @return 학생설문목록
     */
    @RequestMapping(value="/stdntSrvyListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> stdntSrvyListAjax(SrvyPageInfo pageInfo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	pageInfo.setUserId(userCtx.getUserId());
        return srvyFacadeService.getStdntSrvyList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 학생설문정보화면
     *
     * @param sbjctId 	과목아이디
     * @param srvyId 	설문아이디
     * @param upSrvyId 	상위설문아이디
     * @return stdnt_srvy_info_view.jsp
     */
    @RequestMapping(value="/stdntSrvyInfoView.do")
    public String stdntQuizInfoView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("vo", srvyFacadeService.loadStdntSrvyInfoView(vo, userCtx).getEgovMap());
    	model.addAttribute("userCtx", userCtx);

        return "srvy/stdnt_srvy_info_view";
    }

    /**
     * 설문참여팝업
     *
     * @param srvyId 		설문아이디
     * @param upSrvyId 		상위설문아이디
     * @param srvyPtcpId 	설문참여아이디
     * @param sbjctId 		과목아이디
     * @return srvy_ptcp_pop.jsp
     */
    @RequestMapping(value="/srvyPtcpPopup.do")
    public String srvyPtcpPopup(SrvyVO srvy, SrvyPtcpVO ptcp, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	ptcp.setCntnDvcTycd(SessionInfo.getDeviceType(request));
        SrvyMainView srvyMainView = srvyFacadeService.loadSrvyPtcpPopup(srvy, ptcp, userCtx);
        model.addAttribute("vo", srvyMainView.getEgovMap());
        if(srvyMainView.getResultDTO().getResult() > 0) {
        	EgovMap exampprMap = (EgovMap) srvyMainView.getResultDTO().getData();
        	model.addAttribute("ptcpInfo", exampprMap.get("ptcpInfo"));
        	model.addAttribute("srvypprList", exampprMap.get("srvypprList"));
        	model.addAttribute("srvyQstnList", exampprMap.get("srvyQstnList"));
        	model.addAttribute("srvyVwitmList", exampprMap.get("srvyVwitmList"));
        	model.addAttribute("srvyQstnVwitmLvlList", exampprMap.get("srvyQstnVwitmLvlList"));
        	model.addAttribute("srvyRspnsList", exampprMap.get("srvyRspnsList"));
        } else {
        	model.addAttribute("msg", srvyMainView.getResultDTO().getMessage());
        }

        return "srvy/popup/srvy_ptcp_pop";
    }

    /**
     * 설문지제출
     *
     * @param rspns			답변목록
     * @param srvyPtcpId	설문참여아이디
     */
    @RequestMapping(value="/srvypprSbmsnAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> srvypprSbmsnAjax(@RequestBody Map<String, Object> params, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	params.put("userId", userCtx.getUserId());
    	params.put("cntnIp", StringUtil.nvl(userCtx.getIP(), "0:0:0:0:0:0:0:1"));
    	srvyFacadeService.srvypprSbmsn(params);

    	return new ResultDTO<EgovMap>().setResultSuccess();
    }

    /**
     * 설문참여이력목록조회
     *
     * @param srvyId 	설문아이디
     * @param userId	사용자아이디
     * @return 설문참여이력목록
     */
    @RequestMapping(value="/srvyPtcpHstryListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> srvyPtcpHstryListAjax(SrvyPtcpHstryVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setUserId(userCtx.getUserId());
        return new ResultDTO<EgovMap>().setReturnList(srvyFacadeService.getSrvyPtcpHstryList(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 학생대시보드설문강의평가목록화면
     *
     * @return stdnt_main_srvy_lctr_evl_list_view.jsp
     */
    @RequestMapping(value="/stdntMainSrvyLctrEvlListView.do")
    public String stdntMainSrvyLctrEvlListView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadStdntMainSrvyLctrEvlListView();
    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("vo", vo);

        return "srvy/stdnt_main_srvy_lctr_evl_list_view";
    }

    /**
     * 학생대시보드설문강의평가목록조회
     *
     * @param dgrsYr		학위연도
     * @param orgId			기관아이디
     * @param smstrChrtId	학기기수아이디
     * @param sbjctId		과목아이디
     * @return 설문강의평가목록
     */
    @RequestMapping(value="/stdntMainSrvyLctrEvlListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> stdntMainSrvyLctrEvlListAjax(@RequestBody Map<String, Object> params, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	params.put("userId", userCtx.getUserId());
    	return new ResultDTO<EgovMap>().setReturnList(srvyFacadeService.getStdntMainSrvyLctrEvlList(params).getEgovList()).setResultSuccess();
    }

    /**
     * 강의평가안내문팝업
     *
     * @param srvyId 		설문아이디
     * @param srvyPtcpId 	설문참여아이디
     * @param sbjctId 		과목아이디
     * @return srvy_lctr_evl_ptcp_info_pop.jsp
     */
    @RequestMapping(value="/srvyLctrEvlPtcpInfoPopup.do")
    public String srvyLctrEvlPtcpInfoPopup(SrvyVO vo, ModelMap model, HttpServletRequest request) {
    	// 업무일정에서 중간, 기말 강의평가기간 가져와야함
        SrvyMainView srvyMainView = srvyFacadeService.loadSrvyPtcpInfoPopup(vo);
        model.addAttribute("vo", srvyMainView.getEgovMap());
        model.addAttribute("srvyId", vo.getSubParam());

        return "srvy/popup/srvy_lctr_evl_ptcp_info_pop";
    }

    /**
     * 강의평가참여팝업
     *
     * @param srvyId 		설문아이디
     * @param upSrvyId 		상위설문아이디
     * @return srvy_ptcp_pop.jsp
     */
    @RequestMapping(value="/srvyLctrEvlPtcpPopup.do")
    public String srvyLctrEvlPtcpPopup(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	vo.setSubParam(SessionInfo.getDeviceType(request));
        SrvyMainView srvyMainView = srvyFacadeService.loadSrvyLctrEvlPtcpPopup(vo, userCtx);
        model.addAttribute("vo", srvyMainView.getEgovMap());
        if(srvyMainView.getResultDTO().getResult() > 0) {
        	EgovMap exampprMap = (EgovMap) srvyMainView.getResultDTO().getData();
        	model.addAttribute("ptcpInfo", exampprMap.get("ptcpInfo"));
        	model.addAttribute("srvypprList", exampprMap.get("srvypprList"));
        	model.addAttribute("srvyQstnList", exampprMap.get("srvyQstnList"));
        	model.addAttribute("srvyVwitmList", exampprMap.get("srvyVwitmList"));
        	model.addAttribute("srvyQstnVwitmLvlList", exampprMap.get("srvyQstnVwitmLvlList"));
        	model.addAttribute("srvyRspnsList", exampprMap.get("srvyRspnsList"));
        } else {
        	model.addAttribute("msg", srvyMainView.getResultDTO().getMessage());
        }

        return "srvy/popup/srvy_ptcp_pop";
    }

    /**
     * 강의평가결과팝업
     *
     * @param srvyId 	설문아이디
     * @param upSrvyId 	상위설문아이디
     * @return srvy_ptcp_status_pop.jsp
     */
    @RequestMapping(value="/srvyLctrEvlPtcpStatusPopup.do")
    public String srvyLctrEvlPtcpStatusPopup(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadSrvyLctrEvlPtcpStatusPopup(vo, userCtx);

    	model.addAttribute("vo", srvyMainView.geteMap().get("srvyVO"));
    	model.addAttribute("cntnDvcTycdList", srvyMainView.getCmmnCdList().get("cntnDvcTycd"));
    	model.addAttribute("srvyPtcpDvcStatusList", srvyMainView.getEgovListMap().get("ptcpDvcList"));
    	model.addAttribute("srvyPtcpCnt", srvyMainView.geteMap().get("ptcpCnt"));
    	model.addAttribute("srvypprList", srvyMainView.getSrvypprList());
    	model.addAttribute("srvyQstnList", srvyMainView.getSrvyQstnList());
    	model.addAttribute("srvyVwitmList", srvyMainView.getSrvyVwitmList());
    	model.addAttribute("srvyQstnVwitmLvlList", srvyMainView.getSrvyQstnVwitmLvlList());
    	model.addAttribute("chcRspnsList", srvyMainView.getEgovListMap().get("chcRspnsList"));
    	model.addAttribute("textRspnsList", srvyMainView.getEgovListMap().get("textRspnsList"));
    	model.addAttribute("levelRspnsList", srvyMainView.getEgovListMap().get("levelRspnsList"));
    	model.addAttribute("colorList", srvyMainView.getColorList());
    	model.addAttribute("userTycd", userCtx.getUserTycd());

        return "srvy/popup/srvy_ptcp_status_pop";
    }

    /**
     * 전체설문목록화면
     *
     * @return stdnt_whol_srvy_list_view.jsp
     */
    @RequestMapping(value={"/stdntWholSrvyListView.do", "/profWholSrvyListView.do"})
    public String wholSrvyListView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadStdntWholSrvyListView(vo);
    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("userTycd", userCtx.getUserTycd());
    	model.addAttribute("vo", vo);

        return "srvy/main_whol_srvy_list_view";
    }

    /**
     * 대상전체설문목록조회
     *
     * @param dgrsYr		학위연도
     * @param orgId			기관아이디
     * @param smstrChrtId	학기기수아이디
     * @param searchValue	검색어 ( 설문명 )
     * @return 대상전체설문목록
     */
    @RequestMapping(value="/trgtWholSrvyListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> trgtWholSrvyListAjax(SrvyPageInfo pageInfo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	pageInfo.setSearchText(userCtx.getUserTycd());
    	pageInfo.setUserId(userCtx.getUserId());
    	return srvyFacadeService.getTrgtWholSrvyList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 전체설문참여팝업
     *
     * @param srvyId 		설문아이디
     * @return srvy_ptcp_pop.jsp
     */
    @RequestMapping(value="/wholSrvyPtcpPopup.do")
    public String wholSrvyPtcpPopup(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	vo.setSubParam(SessionInfo.getDeviceType(request));
        SrvyMainView srvyMainView = srvyFacadeService.loadWholSrvyPtcpPopup(vo, userCtx);
        model.addAttribute("vo", srvyMainView.getEgovMap());
        if(srvyMainView.getResultDTO().getResult() > 0) {
        	EgovMap exampprMap = (EgovMap) srvyMainView.getResultDTO().getData();
        	model.addAttribute("ptcpInfo", exampprMap.get("ptcpInfo"));
        	model.addAttribute("srvypprList", exampprMap.get("srvypprList"));
        	model.addAttribute("srvyQstnList", exampprMap.get("srvyQstnList"));
        	model.addAttribute("srvyVwitmList", exampprMap.get("srvyVwitmList"));
        	model.addAttribute("srvyQstnVwitmLvlList", exampprMap.get("srvyQstnVwitmLvlList"));
        	model.addAttribute("srvyRspnsList", exampprMap.get("srvyRspnsList"));
        } else {
        	model.addAttribute("msg", srvyMainView.getResultDTO().getMessage());
        }

        return "srvy/popup/srvy_ptcp_pop";
    }

    /**
     * 전체설문결과팝업
     *
     * @param srvyId 	설문아이디
     * @return srvy_ptcp_status_pop.jsp
     */
    @RequestMapping(value="/wholSrvyPtcpStatusPopup.do")
    public String wholSrvyPtcpStatusPopup(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadWholSrvyPtcpStatusPopup(vo, userCtx);

    	model.addAttribute("vo", srvyMainView.geteMap().get("srvyVO"));
    	model.addAttribute("cntnDvcTycdList", srvyMainView.getCmmnCdList().get("cntnDvcTycd"));
    	model.addAttribute("srvyPtcpDvcStatusList", srvyMainView.getEgovListMap().get("ptcpDvcList"));
    	model.addAttribute("srvyPtcpCnt", srvyMainView.geteMap().get("ptcpCnt"));
    	model.addAttribute("srvypprList", srvyMainView.getSrvypprList());
    	model.addAttribute("srvyQstnList", srvyMainView.getSrvyQstnList());
    	model.addAttribute("srvyVwitmList", srvyMainView.getSrvyVwitmList());
    	model.addAttribute("srvyQstnVwitmLvlList", srvyMainView.getSrvyQstnVwitmLvlList());
    	model.addAttribute("chcRspnsList", srvyMainView.getEgovListMap().get("chcRspnsList"));
    	model.addAttribute("textRspnsList", srvyMainView.getEgovListMap().get("textRspnsList"));
    	model.addAttribute("levelRspnsList", srvyMainView.getEgovListMap().get("levelRspnsList"));
    	model.addAttribute("colorList", srvyMainView.getColorList());
    	model.addAttribute("userTycd", userCtx.getUserTycd());

        return "srvy/popup/srvy_ptcp_status_pop";
    }

    /**
     * 학생강의실설문강의평가목록화면
     *
     * @return stdnt_lect_srvy_lctr_evl_list_view.jsp
     */
    @RequestMapping(value="/stdntLectSrvyLctrEvlListView.do")
    public String stdntLectSrvyLctrEvlListView(SrvyVO vo, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("vo", vo);

        return "srvy/stdnt_lect_srvy_lctr_evl_list_view";
    }

    /**
     * 학생강의실설문강의평가목록조회
     *
     * @param sbjctId		과목아이디
     * @param searchValue	검색어(강의평가명)
     * @return 설문강의평가목록
     */
    @RequestMapping(value="/stdntLectSrvyLctrEvlListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> stdntLectSrvyLctrEvlListAjax(SrvyPageInfo pageInfo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	return srvyFacadeService.getStdntSrvyLctrEvlList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 학생강의실설문강의평가정보화면
     *
     * @return stdnt_lect_srvy_lctr_evl_info_view.jsp
     */
    @RequestMapping(value="/stdntLectSrvyLctrEvlInfoView.do")
    public String stdntLectSrvyLctrEvlInfoView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("vo", srvyFacadeService.loadStdntLectSrvyLctrEvlInfoView(vo, userCtx).getEgovMap());
    	model.addAttribute("userCtx", userCtx);

        return "srvy/stdnt_lect_srvy_lctr_evl_info_view";
    }

    /*****************************************************
     *						관리자 화면	 				*
     ******************************************************/

    /**
     * 관리자설문강의평가목록화면
     *
     * @return adm_srvy_lctr_evl_list_view.jsp
     */
    @RequestMapping(value="/admSrvyLctrEvlListView.do")
    public String admSrvyLctrEvlListView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyLctrEvlListView();
    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("vo", vo);

        return "srvy/adm_srvy_lctr_evl_list_view";
    }

    /**
     * 관리자설문강의평가목록조회
     *
     * @param dgrsYr		학위연도
     * @param orgId			기관아이디
     * @param smstrChrtId	학기기수아이디
     * @param searchValue	검색어 ( 제목 )
     * @return 설문강의평가목록
     */
    @RequestMapping(value="/admSrvyLctrEvlListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admSrvyLctrEvlListAjax(SrvyPageInfo pageInfo, ModelMap model, HttpServletRequest request) {
    	return srvyFacadeService.getAdmSrvyLctrEvlList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 관리자설문강의평가등록화면
     *
     * @return adm_srvy_lctr_evl_regist_view.jsp
     */
    @RequestMapping(value="/admSrvyLctrEvlRegistView.do")
    public String admSrvyLctrEvlRegistView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyLctrEvlRegistView(vo);
    	EgovMap egovMap = new EgovMap();
    	egovMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_SRVY, null));	// 첨부파일저장소 설정
        model.addAttribute("vo", egovMap);
    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);

        return "srvy/adm_srvy_lctr_evl_regist_view";
    }

    /**
     * 관리자설문강의평가미등록과목목록조회
     *
     * @param orgId 		기관아이디
     * @param dgrsYr 		학위연도
	 * @param smstrChrtId 	학기기수아이디
	 * @param srvyTycd 		설문유형코드
     * @return 설문강의평가미등록과목목록
     */
    @RequestMapping(value="/admSrvyLctrEvlNRegistSbjctListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admSrvyLctrEvlNRegistSbjctListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(srvyFacadeService.getSrvyLctrEvlNRegistSbjctList(params).getEgovList()).setResultSuccess();
    }

    /**
     * 관리자설문강의평가등록
     *
     * @param SrvyVO 		설문정보
     * @param sbjctIds 		과목아이디목록
     * @return ResultDTO<SrvyVO>
     */
    @RequestMapping(value="/admSrvyLctrEvlRegistAjax.do")
    @ResponseBody
    public ResultDTO<SrvyVO> admSrvyLctrEvlRegistAjax(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="sbjctIds", defaultValue="[]") String sbjctIds) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        Map<String, String> subMap = new HashMap<>();
        subMap.put("sbjctIds", sbjctIds);
        return new ResultDTO<SrvyVO>().setData(srvyFacadeService.srvyLctrEvlRegist(vo, subMap).getSrvyVO()).setResultSuccess();
    }

    /**
     * 관리자설문강의평가수정화면
     *
     * @return adm_srvy_lctr_evl_regist_view.jsp
     */
    @RequestMapping(value="/admSrvyLctrEvlModifyView.do")
    public String admSrvyLctrEvlModifyView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyLctrEvlModifyView(vo);

    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("vo", srvyMainView.getEgovMap().get("vo"));
    	model.addAttribute("sbjctList", srvyMainView.getEgovList());
    	model.addAttribute("userCtx", userCtx);

    	return "srvy/adm_srvy_lctr_evl_regist_view";
    }

    /**
     * 관리자설문강의평가수정
     *
     * @param SrvyVO 		설문정보
     * @param sbjctIds 		과목아이디목록
     * @return ResultDTO<SrvyVO>
     */
    @RequestMapping(value="/admSrvyLctrEvlModifyAjax.do")
    @ResponseBody
    public ResultDTO<SrvyVO> admSrvyLctrEvlModifyAjax(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="sbjctIds", defaultValue="[]") String sbjctIds)  {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        Map<String, String> subMap = new HashMap<>();
        subMap.put("sbjctIds", sbjctIds);

        return new ResultDTO<SrvyVO>().setData(srvyFacadeService.srvyLctrEvlModify(vo, subMap).getSrvyVO()).setResultSuccess();
    }

    /**
     * 관리자설문강의평가정보화면
     *
     * @return adm_srvy_lctr_evl_info_view.jsp
     */
    @RequestMapping(value="/admSrvyLctrEvlInfoView.do")
    public String admSrvyLctrEvlInfoView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	vo.setOrgId(userCtx.getOrgId());
    	model.addAttribute("vo", srvyFacadeService.loadAdmSrvyLctrEvlInfoView(vo).getEgovMap());

    	return "srvy/adm_srvy_lctr_evl_info_view";
    }

    /**
     * 관리자설문강의평가등록과목목록조회
     *
	 * @param srvyId 	설문아이디
     * @return 설문강의평가등록과목목록
     */
    @RequestMapping(value="/admSrvyLctrEvlRegistSbjctListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admSrvyLctrEvlRegistSbjctListAjax(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	vo.setOrgId(userCtx.getOrgId());
        return new ResultDTO<EgovMap>().setReturnList(srvyFacadeService.getSrvyLctrEvlRegistSbjctList(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 관리자이전설문강의평가복사팝업
     *
     * @param orgId 	기관아이디
     * @param srvyId	설문아이디
     * @return adm_bfr_srvy_lctr_evl_copy_pop.jsp
     */
    @RequestMapping(value="/admBfrSrvyLctrEvlCopyPopup.do")
    public String admBfrSrvyLctrEvlCopyPopup(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmBfrSrvyLctrEvlCopyPopup();
        model.addAttribute("orgList", srvyMainView.getOrgList());
        model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
        model.addAttribute("vo", vo);
        model.addAttribute("userCtx", userCtx);

        return "srvy/popup/adm_bfr_srvy_lctr_evl_copy_pop";
    }

    /**
     * 관리자등록설문강의평가목록조회
     *
     * @param orgId 		기관아이디
	 * @param smstrChrtId 	학기기수아이디
	 * @param srvyTrgtGbncd 설문대상구분코드
	 * @param searchValue 	검색어 ( 강의평가제목 )
	 * @param srvyId 		설문아이디
     * @return 등록설문강의평가목록
     */
    @RequestMapping(value="/admRegistSrvyLctrEvlListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admRegistSrvyLctrEvlListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(srvyFacadeService.getAdmRegistSrvyLctrEvlList(params).getEgovList()).setResultSuccess();
    }

    /**
     * 설문강의평가조회
     *
     * @param srvyId 		설문아이디
     * @return 설문강의평가
     */
    @RequestMapping(value={"/srvyLctrEvlSelectAjax.do", "/admSrvyLctrEvlSelectAjax.do"})
    @ResponseBody
    public ResultDTO<EgovMap> srvyLctrEvlSelectAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setData(srvyFacadeService.getSrvyLctrEvlSelect(vo).getEgovMap()).setResultSuccess();
    }

    /**
     * 관리자설문강의평가문항관리화면
     *
     * @return adm_srvy_lctr_evl_qstn_mng_view.jsp
     */
    @RequestMapping(value="/admSrvyLctrEvlQstnMngView.do")
    public String admSrvyLctrEvlQstnMngView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyLctrEvlQstnMngView(vo);
    	model.addAttribute("vo", srvyMainView.getEgovMap());
    	model.addAttribute("qstnRspnsTycdList", srvyMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", srvyMainView.getCmmnCdList().get("qstnDfctlvTycd"));
        model.addAttribute("userCtx", userCtx);

    	return "srvy/adm_srvy_lctr_evl_qstn_mng_view";
    }

    /**
     * 관리자설문강의평가문제복사팝업
     *
     * @param orgId		기관아이디
     * @param srvyId 	설문아이디
     * @return adm_srvy_lctr_evl_qstn_copy_pop.jsp
     */
    @RequestMapping(value="/admSrvyLctrEvlQstnCopyPopup.do")
    public String admSrvyLctrEvlQstnCopyPopup(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyLctrEvlQstnCopyPopup(vo);
        model.addAttribute("vo", vo);
        model.addAttribute("orgList", srvyMainView.getOrgList());
        model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);

        return "srvy/popup/adm_srvy_lctr_evl_qstn_copy_pop";
    }

    /**
     * 관리자설문강의평가관리팝업
     *
     * @param srvyId 	설문아이디
     * @return adm_srvy_lctr_evl_mng_pop.jsp
     */
    @RequestMapping(value="/admSrvyLctrEvlMngPopup.do")
    public String admSrvyLctrEvlMngPopup(SrvyVO vo, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("vo", srvyFacadeService.loadAdmSrvyLctrEvlMngPopup(vo).getEgovMap());

        return "srvy/popup/adm_srvy_lctr_evl_mng_pop";
    }

    /**
     * 관리자설문강의평가결과목록화면
     *
     * @return adm_srvy_lctr_evl_rslt_list_view.jsp
     */
    @RequestMapping(value="/admSrvyLtclEvlRsltListView.do")
    public String admSrvyLtclEvlRsltListView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyLtclEvlRsltListView();
    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("vo", vo);

        return "srvy/adm_srvy_lctr_evl_rslt_list_view";
    }

    /**
     * 관리자설문강의평가결과관리화면
     *
     * @return adm_srvy_lctr_evl_rslt_mng_view.jsp
     */
    @RequestMapping(value="/admSrvyLctrEvlRsltMngView.do")
    public String admSrvyLctrEvlRsltMngView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	vo.setOrgId(userCtx.getOrgId());
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyLctrEvlRsltMngView(vo);

    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	srvyMainView.getEgovMap().put("listScale", vo.getListScale());
    	model.addAttribute("vo", srvyMainView.getEgovMap().get("vo"));
    	model.addAttribute("userCtx", userCtx);

        return "srvy/adm_srvy_lctr_evl_rslt_mng_view";
    }

    /**
     * 관리자설문강의평가결과목록조회
     *
     * @param srvyId		설문아이디
     * @param orgId  		기관아이디
     * @param smstrChrtId	학기기수아이디
     * @param sbjctId		과목아이디
     * @param srvyPtcp		참여여부
     * @param searchValue	검색어 ( 이름, 학번 )
     * @return 강의평가결과목록
     */
    @RequestMapping(value="/admSrvyLctrEvlRsltListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admSrvyLctrEvlRsltListAjax(SrvyPageInfo pageInfo, ModelMap model, HttpServletRequest request) {
        return srvyFacadeService.getAdmSrvyLctrEvlRsltList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 관리자설문강의평가참여현황조회
     *
     * @param srvyId		설문아이디
     * @param orgId  		기관아이디
     * @param smstrChrtId	학기기수아이디
     * @param sbjctId		과목아이디
     * @param srvyPtcp		참여여부
     * @param searchValue	검색어 ( 이름, 학번 )
     * @return 설문강의평가참여현황
     */
    @RequestMapping(value="/admSrvyLctrEvlPtcpStatusAjax.do")
    @ResponseBody
    public ResultDTO<SrvyMainView> admSrvyLctrEvlPtcpStatusAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
    	return new ResultDTO<SrvyMainView>().setData(srvyFacadeService.getAdmSrvyLctrEvlPtcpStatus(params)).setResultSuccess();
    }

    /**
     * 관리자강의평가답변현황엑셀다운로드
     *
     * @param srvyId 	설문아이디
     * @return excelView
     */
    @RequestMapping(value="/admLctrEvlRspnsStatusExcelDown.do")
    public String admLctrEvlRspnsStatusExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) {
		String title = getMessage("srvy.label.ptcp.rspns.list"); /* 참여자 답변 목록 */
        SrvyMainView srvyMainView = srvyFacadeService.getLctrEvlRspnsStatusExcelDownList(vo);

        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("list", srvyMainView);

        //엑셀화
        HashMap<String, Object> modelMap = new HashMap<>();
		modelMap.put("outFileName", getMessage("srvy.label.ptcp.lctr.evl"));	/* 제출강의평가 */
        modelMap.put("workbook", makeSrvyRspnsStatusExcel(map, request));
        modelMap.put("list", srvyMainView);
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /**
     * 관리자강의평가참여현황엑셀다운로드
     *
     * @param srvyId 	설문아이디
     * @return excelView
     */
    @RequestMapping(value="/admLctrEvlPtcpStatusExcelDown.do")
    public String admLctrEvlPtcpStatusExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) {
		String title = getMessage("srvy.label.lctr.evl.result"); /* 강의평가 결과 */
        SrvyMainView srvyMainView = srvyFacadeService.getLctrEvlPtcpStatusExcelDownList(vo);

        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("list", srvyMainView);

        //엑셀화
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title);
        modelMap.put("workbook", makeSrvyPtcpStatusExcel(map, request));
        modelMap.put("list", srvyMainView);
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /**
     * 관리자전체설문목록화면
     * @return 	adm_srvy_list_view
     */
    @RequestMapping(value="/admSrvyListView.do")
    public String admSrvyListView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyListView(vo);
    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("vo", vo);
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);

    	return "srvy/adm_srvy_list_view";
    }

    /**
     * 관리자전체설문목록조회
     *
     * @param orgId			기관아이디
     * @param dgrsYr		학위연도
     * @param smstrChrtId	학기기수아이디
     * @param searchValue	검색어 ( 제목 )
     * @return 전체설문목록
     */
    @RequestMapping(value="/admSrvyListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admSrvyListAjax(SrvyPageInfo pageInfo, ModelMap model, HttpServletRequest request) {
    	return srvyFacadeService.getAdmSrvyList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 관리자전체설문등록화면
     * @return 	adm_srvy_regist_view
     */
    @RequestMapping(value="/admSrvyRegistView.do")
    public String admSrvyRegistView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyRegistView(vo);
    	EgovMap egovMap = new EgovMap();
    	egovMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_SRVY, null));	// 첨부파일저장소 설정
    	model.addAttribute("vo", egovMap);
    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);

    	return "srvy/adm_srvy_regist_view";
    }

    /**
     * 관리자전체설문등록
     *
     * @param SrvyVO 		설문정보
     * @return ResultDTO<SrvyVO>
     */
    @RequestMapping(value="/admSrvyRegistAjax.do")
    @ResponseBody
    public ResultDTO<SrvyVO> admSrvyRegistAjax(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        vo.setSearchKey(request.getParameter("srvyTrgtTycd"));
        return new ResultDTO<SrvyVO>().setData(srvyFacadeService.admSrvyRegist(vo).getSrvyVO()).setResultSuccess();
    }

    /**
     * 관리자전체설문수정화면
     * @return 	adm_srvy_regist_view
     */
    @RequestMapping(value="/admSrvyModifyView.do")
    public String admSrvyModifyView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyModifyView(vo);
    	EgovMap egovMap = (EgovMap) srvyMainView.getEgovMap().get("vo");
    	egovMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_SRVY, null));	// 첨부파일저장소 설정
    	model.addAttribute("vo", egovMap);
    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);

    	return "srvy/adm_srvy_regist_view";
    }

    /**
     * 관리자전체설문수정
     *
     * @param SrvyVO 		설문정보
     * @return ResultDTO<SrvyVO>
     */
    @RequestMapping(value="/admSrvyModifyAjax.do")
    @ResponseBody
    public ResultDTO<SrvyVO> admSrvyModifyAjax(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        vo.setSearchKey(request.getParameter("srvyTrgtTycd"));
        return new ResultDTO<SrvyVO>().setData(srvyFacadeService.admSrvyModify(vo).getSrvyVO()).setResultSuccess();
    }

    /**
     * 관리자이전전체설문복사팝업
     *
     * @param orgId 	기관아이디
     * @param srvyId	설문아이디
     * @return adm_bfr_srvy_copy_pop.jsp
     */
    @RequestMapping(value="/admBfrSrvyCopyPopup.do")
    public String admBfrSrvyCopyPopup(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmBfrSrvyCopyPopup(vo);
        model.addAttribute("orgList", srvyMainView.getOrgList());
        model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
        model.addAttribute("vo", vo);
        model.addAttribute("userCtx", userCtx);

        return "srvy/popup/adm_bfr_srvy_copy_pop";
    }

    /**
     * 관리자등록전체설문목록조회
     *
     * @param orgId 		기관아이디
     * @param dgrsYr	 	학위연도
	 * @param smstrChrtId 	학기기수아이디
	 * @param srvyTrgtTycd 	설문대상유형코드
	 * @param searchValue 	검색어 ( 전체설문제목 )
	 * @param srvyId 		설문아이디
     * @return 등록전체설문목록
     */
    @RequestMapping(value="/admRegistSrvyListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admRegistSrvyListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(srvyFacadeService.getAdmRegistSrvyList(params).getEgovList()).setResultSuccess();
    }

    /**
     * 관리자전체설문정보화면
     * @return 	adm_srvy_info_view
     */
    @RequestMapping(value="/admSrvyInfoView.do")
    public String admSrvyInfoView(SrvyVO vo, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("vo", srvyFacadeService.loadAdmSrvyInfoView(vo).getEgovMap());

    	return "srvy/adm_srvy_info_view";
    }

    /**
     * 전체설문조회
     *
     * @param srvyId 	설문아이디
     * @return 전체설문
     */
    @RequestMapping(value="/admSrvySelectAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admSrvySelectAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setData(srvyFacadeService.getAdmSrvySelect(vo).getEgovMap()).setResultSuccess();
    }

    /**
     * 관리자전체설문문항관리화면
     * @return 	adm_srvy_qstn_mng_view
     */
    @RequestMapping(value="/admSrvyQstnMngView.do")
    public String admSrvyQstnMngView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyQstnMngView(vo);

    	model.addAttribute("vo", srvyMainView.getEgovMap());
    	model.addAttribute("qstnRspnsTycdList", srvyMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", srvyMainView.getCmmnCdList().get("qstnDfctlvTycd"));
        model.addAttribute("userCtx", userCtx);

    	return "srvy/adm_srvy_qstn_mng_view";
    }

    /**
     * 관리자전체설문문제복사팝업
     *
     * @param orgId		기관아이디
     * @param srvyId 	설문아이디
     * @return adm_srvy_qstn_copy_pop.jsp
     */
    @RequestMapping(value="/admSrvyQstnCopyPopup.do")
    public String admSrvyQstnCopyPopup(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyQstnCopyPopup(vo);
        model.addAttribute("vo", vo);
        model.addAttribute("orgList", srvyMainView.getOrgList());
        model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);

        return "srvy/popup/adm_srvy_qstn_copy_pop";
    }

    /**
     * 관리자전체설문결과목록화면
     * @return 	adm_srvy_rslt_list_view
     */
    @RequestMapping(value="/admSrvyRsltListView.do")
    public String admSrvyRsltListView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyListView(vo);
    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("vo", vo);
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);

    	return "srvy/adm_srvy_rslt_list_view";
    }

    /**
     * 관리자전체설문결과관리화면
     * @return 	adm_srvy_rslt_mng_view
     */
    @RequestMapping(value="/admSrvyRsltMngView.do")
    public String admSrvyRsltMngView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSrvyRsltMngView(vo);
    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("vo", srvyMainView.getEgovMap().get("vo"));
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);

    	return "srvy/adm_srvy_rslt_mng_view";
    }

    /**
     * 관리자전체설문결과목록조회
     *
     * @param srvyId		설문아이디
     * @param orgId  		기관아이디
     * @param smstrChrtId	학기기수아이디
     * @param srvyTrgtTycd	설문대상유형코드
     * @param srvyPtcp		참여여부
     * @param searchValue	검색어 ( 이름, 학번 )
     * @return 전체설문결과목록
     */
    @RequestMapping(value="/admSrvyRsltListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admSrvyRsltListAjax(SrvyPageInfo pageInfo, ModelMap model, HttpServletRequest request) {
        return srvyFacadeService.getAdmSrvyRsltList(pageInfo).getResultDTO().setResultSuccess();
    }

    /**
     * 관리자전체설문답변현황엑셀다운로드
     *
     * @param srvyId 	설문아이디
     * @return excelView
     */
    @RequestMapping(value="/admRspnsStatusExcelDown.do")
    public String admRspnsStatusExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) {
		String title = getMessage("srvy.label.ptcp.rspns.list"); /* 참여자 답변 목록 */
        SrvyMainView srvyMainView = srvyFacadeService.getRspnsStatusExcelDownList(vo);

        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("list", srvyMainView);

        //엑셀화
        HashMap<String, Object> modelMap = new HashMap<>();
		modelMap.put("outFileName", getMessage("srvy.label.ptcp.srvy")); /* 제출설문 */
        modelMap.put("workbook", makeSrvyRspnsStatusExcel(map, request));
        modelMap.put("list", srvyMainView);
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /**
     * 관리자전체설문참여현황엑셀다운로드
     *
     * @param srvyId 	설문아이디
     * @return excelView
     */
    @RequestMapping(value="/admPtcpStatusExcelDown.do")
    public String admPtcpStatusExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) {
		String title = getMessage("srvy.label.all.srvy.result"); /* 전체설문 결과 */
        SrvyMainView srvyMainView = srvyFacadeService.getPtcpStatusExcelDownList(vo);

        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("list", srvyMainView);

        //엑셀화
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title);
        modelMap.put("workbook", makeSrvyPtcpStatusExcel(map, request));
        modelMap.put("list", srvyMainView);
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /**
     * 관리자전체설문참여현황조회
     *
     * @param srvyId		설문아이디
     * @param orgId  		기관아이디
     * @param smstrChrtId	학기기수아이디
     * @param srvyTrgtTycd	설문대상유형코드
     * @param srvyPtcp		참여여부
     * @param searchValue	검색어 ( 이름, 학번 )
     * @return 전체설문참여현황
     */
    @RequestMapping(value="/admSrvyPtcpStatusAjax.do")
    @ResponseBody
    public ResultDTO<SrvyMainView> admSrvyPtcpStatusAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
    	return new ResultDTO<SrvyMainView>().setData(srvyFacadeService.getAdmSrvyPtcpStatus(params)).setResultSuccess();
    }

    /**
     * 관리자과목설문강의평가목록화면
     *
     * @return adm_sbjct_srvy_lctr_evl_list_view.jsp
     */
    @RequestMapping(value="/admSbjctSrvyLctrEvlListView.do")
    public String admSbjctSrvyLctrEvlListView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSbjctSrvyLctrEvlListView();
    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("vo", vo);

        return "srvy/adm_sbjct_srvy_lctr_evl_list_view";
    }

    /**
     * 관리자과목설문강의평가정보화면
     *
     * @return adm_sbjct_srvy_lctr_evl_info_view.jsp
     */
    @RequestMapping(value="/admSbjctSrvyLctrEvlInfoView.do")
    public String admSbjctSrvyLctrEvlInfoView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("vo", srvyFacadeService.loadAdmSbjctSrvyLctrEvlInfoView(vo).getEgovMap());
    	model.addAttribute("userCtx", userCtx);

    	return "srvy/adm_sbjct_srvy_lctr_evl_info_view";
    }

    /**
     * 관리자설문강의평가과목별참여목록조회
     *
	 * @param srvyId 	설문아이디
	 * @param userId 	사용자아이디
     * @return 관리자설문강의평가과목별참여목록조회
     */
    @RequestMapping(value="/admSrvyLctrEvlSbjctPtcpListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admSrvyLctrEvlSbjctPtcpListAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(srvyFacadeService.getSrvyLctrEvlSbjctPtcpList(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 관리자과목설문강의평가결과목록화면
     *
     * @return adm_sbjct_srvy_lctr_evl_rslt_list_view.jsp
     */
    @RequestMapping(value="/admSbjctSrvyLtclEvlRsltListView.do")
    public String admSbjctSrvyLtclEvlRsltListView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSbjctSrvyLtclEvlRsltListView();
    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	model.addAttribute("curYear", srvyMainView.getEgovMap().get("curYear"));
    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("vo", vo);

        return "srvy/adm_sbjct_srvy_lctr_evl_rslt_list_view";
    }

    /**
     * 관리자과목설문강의평가결과관리화면
     *
     * @return adm_sbjct_srvy_lctr_evl_rslt_mng_view.jsp
     */
    @RequestMapping(value="/admSbjctSrvyLtclEvlRsltMngView.do")
    public String admSbjctSrvyLtclEvlRsltMngView(SrvyVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	SrvyMainView srvyMainView = srvyFacadeService.loadAdmSbjctSrvyLtclEvlRsltMngView(vo);

    	model.addAttribute("orgList", srvyMainView.getOrgList());
    	model.addAttribute("yearList", srvyMainView.getEgovMap().get("yearList"));
    	srvyMainView.getEgovMap().put("listScale", vo.getListScale());
    	model.addAttribute("vo", srvyMainView.getEgovMap().get("vo"));
    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("searchType", "SBJCTOP");

        return "srvy/adm_sbjct_srvy_lctr_evl_rslt_mng_view";
    }

}
