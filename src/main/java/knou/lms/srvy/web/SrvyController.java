package knou.lms.srvy.web;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.srvy.facade.SrvyFacadeService;
import knou.lms.srvy.vo.SrvyPtcpVO;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyQstnVwitmLvlVO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.vo.SrvyVwitmVO;
import knou.lms.srvy.vo.SrvypprVO;
import knou.lms.srvy.web.view.SrvyMainView;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value="/srvy")
public class SrvyController extends ControllerBase {

	@Resource(name="srvyFacadeService")
	private SrvyFacadeService srvyFacadeService;

	/**
     * 교수설문목록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_srvy_list_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyListView.do")
    public String profSrvyListView(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String sbjctId = vo.getSbjctId() == null ? "SBJCT_OFRNG_ID1" : vo.getSbjctId();
        model.addAttribute("sbjctId", sbjctId);    // 과목아이디
        model.addAttribute("menuTycd", "PROF");

        return "srvy/prof_srvy_list_view";
    }

    /**
     * 교수설문목록조회
     *
     * @param sbjctId     과목아이디
     * @param searchValue 검색어 ( 설문명 )
     * @return 교수 설문목록
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profSrvyListAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            resultVO = srvyFacadeService.getProfSrvyList(vo).getProfSrvyList();
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수설문등록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_srvy_regist_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyRegistView.do")
    public String profSrvyRegistView(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvyRegistView(vo);
        model.addAttribute("dvclasList", srvyMainView.getSbjctDcvlasList());

        model.addAttribute("menuTycd", "PROF");
        model.addAttribute("sbjctId", vo.getSbjctId());    // 과목아이디

        return "srvy/prof_srvy_regist_view";
    }

    /**
     * 설문등록
     *
     * @param SrvyVO 				설문정보
     * @param subSrvysStr 			학습그룹부과제정보
     * @param sbjctIds 				분반과목아이디목록
     * @param lrnGrpIds 			학습그룹아이디:과목아이디목록
     * @param byteamSubsrvyUseyns 	팀별부설문사용여부:과목아이디목록
     * @return ProcessResultVO<SrvyVO>
     * @throws Exception
     */
    @RequestMapping(value="/srvyRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyVO> srvyRegistAjax(SrvyVO vo, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="subSrvys", defaultValue="[]") String subSrvysStr
    		, @RequestParam(value="sbjctIds", defaultValue="[]") String sbjctIds
    		, @RequestParam(value="lrnGrpIds", defaultValue="[]") String lrnGrpIds
    		, @RequestParam(value="byteamSubsrvyUseyns", defaultValue="[]") String byteamSubsrvyUseyns
    		) throws Exception {

        ProcessResultVO<SrvyVO> resultVO = new ProcessResultVO<SrvyVO>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            if(ValidationUtils.isEmpty(userId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);

            Map<String, String> subMap = new HashMap<>();
            subMap.put("subSrvysStr", subSrvysStr);
            subMap.put("sbjctIds", sbjctIds);
            subMap.put("lrnGrpIds", lrnGrpIds);
            subMap.put("byteamSubsrvyUseyns", byteamSubsrvyUseyns);
            subMap.put("srvyTeamyn", request.getParameter("srvyTeamyn"));
            SrvyMainView srvyMainView = srvyFacadeService.srvyRegist(vo, subMap);

            resultVO.setReturnVO(srvyMainView.getSrvyVO());
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("저장 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수설문수정화면
     *
     * @param sbjctId 	과목아이디
     * @param srvyId 	설문아이디
     * @return prof_srvy_regist_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyModifyView.do")
    public String profSrvyModifyView(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvyModifyView(vo);

    	EgovMap srvyEgovMap = srvyMainView.getSrvyEgovMap();
    	srvyEgovMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_SRVY, (String) srvyEgovMap.get("srvyId")));	// 첨부파일저장소 설정
        model.addAttribute("vo", srvyEgovMap);
        model.addAttribute("dvclasList", srvyMainView.getSrvyGrpSbjctList());
        model.addAttribute("sbjctId", StringUtil.nvl(vo.getSbjctId()));
        model.addAttribute("menuTycd", "PROF");

        return "srvy/prof_srvy_regist_view";
    }

    /**
     * 설문수정
     *
     * @param SrvyVO 				설문정보
     * @param subSrvysStr 			학습그룹부과제정보
     * @param sbjctIds 				분반과목아이디목록
     * @param lrnGrpIds 			학습그룹아이디:과목아이디목록
     * @param byteamSubsrvyUseyns 	팀별부설문사용여부:과목아이디목록
     * @return ProcessResultVO<SrvyVO>
     * @throws Exception
     */
    @RequestMapping(value="/srvyModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyVO> srvyModifyAjax(SrvyVO vo, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="subSrvys", defaultValue="[]") String subSrvysStr
    		, @RequestParam(value="sbjctIds", defaultValue="[]") String sbjctIds
    		, @RequestParam(value="lrnGrpIds", defaultValue="[]") String lrnGrpIds
    		, @RequestParam(value="byteamSubsrvyUseyns", defaultValue="[]") String byteamSubsrvyUseyns
    		) throws Exception {

        ProcessResultVO<SrvyVO> resultVO = new ProcessResultVO<SrvyVO>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            if(ValidationUtils.isEmpty(userId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);

            Map<String, String> subMap = new HashMap<>();
            subMap.put("subSrvysStr", subSrvysStr);
            subMap.put("sbjctIds", sbjctIds);
            subMap.put("lrnGrpIds", lrnGrpIds);
            subMap.put("byteamSubsrvyUseyns", byteamSubsrvyUseyns);
            subMap.put("srvyTeamyn", request.getParameter("srvyTeamyn"));
            SrvyMainView srvyMainView = srvyFacadeService.srvyModify(vo, subMap);

            resultVO.setReturnVO(srvyMainView.getSrvyVO());
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 과목성적공개설문수조회
     *
     * @param sbjctId 	과목아이디
     * @return 과목성적공개설문수
     * @throws Exception
     */
    @RequestMapping(value="/sbjctMrkOynSrvyCntSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> sbjctMrkOynSrvyCntSelectAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
        	SrvyMainView srvyMainView = srvyFacadeService.getSbjctMrkOynSrvyCnt(vo);
            resultVO.setResult(srvyMainView.getSrvyVO().getTotalCnt());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("정보 조회 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

    /**
     * 설문성적공개여부수정
     *
     * @param srvyId	설문아이디
     * @param mrkOyn    성적공개여부
     * @throws Exception
     */
    @RequestMapping(value="/srvyMrkOynModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyVO> srvyMrkOynModifyAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<SrvyVO> resultVO = new ProcessResultVO<SrvyVO>();

        try {
            vo.setMdfrId(userId);
            srvyFacadeService.srvyDtlModify(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 설문성적반영비율수정
     *
     * @param srvyId	설문아이디
     * @param mrkRfltrt 성적반영비율
     * @throws Exception
     */
    @RequestMapping(value="/srvyMrkRfltrtModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyVO> srvyMrkRfltrtModifyAjax(@RequestBody List<SrvyVO> list, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<SrvyVO> resultVO = new ProcessResultVO<SrvyVO>();

        try {
            for(SrvyVO vo : list) {
                vo.setMdfrId(userId);
            }
            srvyFacadeService.srvyMrkRfltrtListModify(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 설문학습그룹부과제목록조회
     *
     * @param lrnGrpId  학습그룹아이디
     * @param srvyId	설문아이디
     * @return 설문부과제목록
     * @throws Exception
     */
    @RequestMapping(value="/srvyLrnGrpSubAsmtListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> srvyLrnGrpSubAsmtListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
        	SrvyMainView srvyMainView = srvyFacadeService.getSrvyLrnGrpSubAsmtList(params);
            resultVO.setReturnList(srvyMainView.getSrvyLrnGrpSubAsmtList());
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수이전설문복사팝업
     *
     * @param sbjctId 과목아이디
     * @return prof_bfr_srvy_copy_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profBfrSrvyCopyPopup.do")
    public String profBfrSrvyCopyPopup(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	SrvyMainView srvyMainView = srvyFacadeService.loadProfBfrSrvyCopyPopup(vo);
    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        model.addAttribute("srvySearchSmstrList", srvyMainView.getSrvySearchSmstrList());
        vo.setUserId(userId);
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
     * @param listScale     페이지크기
     * @return 설문목록 페이징
     * @throws Exception
     */
    @RequestMapping(value="/profAuthrtSbjctSrvyListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAuthrtSbjctSrvyListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
        	SrvyMainView srvyMainView = srvyFacadeService.getProfAuthrtSbjctSrvyList(params);
        	resultVO.setReturnList(srvyMainView.getProfAuthrtSbjctSrvyList());
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 설문정보조회
     *
     * @param srvyId 	설문아이디
     * @return 설문정보
     * @throws Exception
     */
    @RequestMapping(value="/srvySelectAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> quizSelectAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
        	SrvyMainView srvyMainView = srvyFacadeService.getSrvy(vo);
            resultVO.setReturnVO(srvyMainView.getSrvyEgovMap());
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("정보 조회 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

    /**
     * 설문삭제
     *
     * @param sbjctId   과목아이디
     * @param srvyId 	설문아이디
     * @param delyn 	삭제여부
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     */
    @RequestMapping(value="/srvyDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> srvyDeleteAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setMdfrId(userId);
            srvyFacadeService.srvyDelete(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("삭제 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

    /**
     * 교수설문지미리보기팝업
     *
     * @param srvyId 	설문아이디
     * @return prof_srvyppr_preview_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvypprPreviewPopup.do")
    public String profSrvypprPreviewPopup(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvypprPreviewPopup(vo);

    	model.addAttribute("vo", srvyMainView.getSrvyEgovMap());
    	model.addAttribute("srvypprList", srvyMainView.getSrvypprList());
    	model.addAttribute("srvyQstnList", srvyMainView.getSrvyQstnList());
    	model.addAttribute("srvyVwitmList", srvyMainView.getSrvyVwitmList());
    	model.addAttribute("srvyQstnVwitmLvlList", srvyMainView.getSrvyQstnVwitmLvlList());
    	if("SRVY_TEAM".equals(srvyMainView.getSrvyEgovMap().get("srvyGbn"))) {
    		model.addAttribute("srvyTeamList", srvyMainView.getSrvyTeamList());
    	}

        return "srvy/popup/prof_srvyppr_preview_pop";
    }

    /**
     * 교수설문문항관리화면
     *
     * @param srvyId 	설문아이디
     * @param sbjctId   과목아이디
     * @return prof_srvy_qstn_mng_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyQstnMngView.do")
    public String profSrvyQstnMngView(SrvyVO vo, @CurrentUser UserContext userCtx,
    		ModelMap model, HttpServletRequest request) throws Exception {

        SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvyQstnMngView(vo, userCtx);

        model.addAttribute("userCtx", userCtx);
        model.addAttribute("vo", srvyMainView.getSrvyEgovMap());
        model.addAttribute("srvyTeamList", srvyMainView.getSrvyTeamList());
        model.addAttribute("isQstnsCmptn", srvyMainView.getIsQstnsCmptn());
        model.addAttribute("qstnRspnsTycdList", srvyMainView.getCmmnCdList().get("qstnRspnsTycd"));
        model.addAttribute("qstnDfctlvTycdList", srvyMainView.getCmmnCdList().get("qstnDfctlvTycd"));
        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        model.addAttribute("menuTycd", "PROF");

        return "srvy/prof_srvy_qstn_mng_view";
    }

    /**
     * 설문지문항목록조회
     *
     * @param srvyId 	설문아이디
     * @return 설문지문항목록
     * @throws Exception
     */
    @RequestMapping(value="/srvypprQstnListAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyMainView> srvypprQstnListAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<SrvyMainView> resultVO = new ProcessResultVO<SrvyMainView>();

        try {
        	resultVO.setReturnVO(srvyFacadeService.getSrvypprQstnList(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수설문지등록팝업
     *
     * @param srvyId 	설문아이디
     * @return prof_srvyppr_regist_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvypprRegistPopup.do")
    public String profSrvypprRegistPopup(SrvypprVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        request.setAttribute("vo", vo);

        return "srvy/popup/prof_srvyppr_regist_pop";
    }

    /**
     * 설문지등록
     *
     * @param SrvypprVO 설문지 정보
     * @throws Exception
     */
    @RequestMapping(value="/srvypprRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvypprVO> srvypprRegistAjax(SrvypprVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SrvypprVO> resultVO = new ProcessResultVO<SrvypprVO>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setRgtrId(userId);

            srvyFacadeService.srvypprRegist(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("설문지 저장 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수설문지수정팝업
     *
     * @param srvyId 		설문아이디
     * @param srvypprId 	설문지아이디
     * @return prof_srvyppr_regist_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvypprModifyPopup.do")
    public String profSrvypprModifyPopup(SrvypprVO vo, ModelMap map, HttpServletRequest request) throws Exception {

    	SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvypprModifyPopup(vo);
    	SrvypprVO srvyppr = srvyMainView.getSrvypprVO();
    	srvyppr.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_SRVY, srvyppr.getSrvyId()));
        request.setAttribute("vo", srvyMainView.getSrvypprVO());

        return "srvy/popup/prof_srvyppr_regist_pop";
    }

    /**
     * 설문지참여수조회
     *
     * @param sbjctId 	과목아이디
     * @param srvyId 	설문아이디
     * @param srvypprId 설문지아이디
     * @return 설문지참여수조회
     * @throws Exception
     */
    @RequestMapping(value="/srvypprPtcpCntSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> srvypprPtcpCntSelectAjax(SrvypprVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            resultVO.setResult(srvyFacadeService.getSrvypprPtcpCntSelect(vo));
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("정보 조회 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

    /**
     * 설문지삭제
     *
     * @param srvyId 		설문아이디
     * @param srvypprId 	설문지아이디
     * @param srvySeqno 	설문지순번
     * @throws Exception
     */
    @RequestMapping(value="/srvypprDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvypprVO> srvypprDeleteAjax(SrvypprVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SrvypprVO> resultVO = new ProcessResultVO<SrvypprVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
        	vo.setMdfrId(userId);
            srvyFacadeService.srvypprDelete(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("설문지 삭제 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수설문문제복사팝업
     *
     * @param sbjctId	과목아이디
     * @param srvyId 	설문아이디
     * @return prof_srvy_qstn_copy_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyQstnCopyPopup.do")
    public String profSrvyQstnCopyPopup(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvyQstnCopyPopup(vo);
    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        model.addAttribute("srvySearchSmstrList", srvyMainView.getSrvySearchSmstrList());
        vo.setUserId(userId);
        model.addAttribute("vo", vo);

        return "srvy/popup/prof_srvy_qstn_copy_pop";
    }

    /**
     * 문제가져오기설문목록조회
     *
     * @param sbjctId 		과목이이디
     * @return 설문목록
     * @throws Exception
     */
    @RequestMapping(value="/copyQstnSrvyListAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyVO> copyQstnSrvyListAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	ProcessResultVO<SrvyVO> resultVO = new ProcessResultVO<SrvyVO>();

    	try {
    		SrvyMainView srvyMainView = srvyFacadeService.getQstnCopySrvyList(vo);
    		resultVO.setReturnList(srvyMainView.getQstnCopySrvyList());
    		resultVO.setResult(1);
    	} catch(Exception e) {
    		resultVO.setResult(-1);
    		resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
    	}

    	return resultVO;
    }

    /**
     * 문제가져오기설문지목록조회
     *
     * @param srvyId 	설문아이디
     * @return 설문지목록
     * @throws Exception
     */
    @RequestMapping(value="/copyQstnSrvypprListAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvypprVO> copyQstnSrvypprListAjax(SrvypprVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	ProcessResultVO<SrvypprVO> resultVO = new ProcessResultVO<SrvypprVO>();

    	try {
    		SrvyMainView srvyMainView = srvyFacadeService.getQstnCopySrvypprList(vo);
    		resultVO.setReturnList(srvyMainView.getSrvypprList());
    		resultVO.setResult(1);
    	} catch(Exception e) {
    		resultVO.setResult(-1);
    		resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
    	}

    	return resultVO;
    }

    /**
     * 교수문항복사설문문항목록조회
     *
     * @param srvypprId 설문지아이디
     * @return 설문문항목록
     * @throws Exception
     */
    @RequestMapping(value="/profQstnCopySrvyQstnListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profQstnCopySrvyQstnListAjax(SrvyQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
        	SrvyMainView srvyMainView = srvyFacadeService.getQstnCopySrvyQstnList(vo);
            resultVO.setReturnList(srvyMainView.getSrvyQstnList());
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수설문문항가져오기
     *
     * @param copySrvyQstnId	복사설문문항아이디
     * @param srvyId 			설문아이디
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyQstnCopyAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyQstnVO> profSrvyQstnCopyAjax(@RequestBody List<Map<String, Object>> list, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<SrvyQstnVO> resultVO = new ProcessResultVO<SrvyQstnVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
        	for(Map<String, Object> map : list) {
            	map.put("rgtrId", userId);
            }
        	srvyFacadeService.srvyQstnCopy(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("가져오기 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수설문문항엑셀업로드팝업
     *
     * @param srvyId	설문아이디
     * @return prof_srvy_qstn_excel_upload_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyQstnExcelUploadPopup.do")
    public String profSrvyQstnExcelUploadPopup(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setUserId(userId);
        vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_SRVY, vo.getSrvyId()));	// 첨부파일저장소 설정
        model.addAttribute("vo", vo);

        return "srvy/popup/prof_srvy_qstn_excel_upload_pop";
    }

    /**
     * 교수설문문항등록샘플엑셀다운로드
     *
     * @param srvyId		설문아이디
     * @param excelGrid 	엑셀그리드
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyQstnRegistSampleExcelDown.do")
    public String profSrvyQstnRegistSampleExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	SrvyMainView srvyMainView = srvyFacadeService.getSrvyQstnExcelSampleData(vo);
    	HashMap<String, Object> map = srvyMainView.getSrvyQstnSampleMap();
        List<EgovMap> list = null;
        if (map != null) {
            list = (List<EgovMap>) map.get("list");
        }

        //엑셀 정보값 세팅
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("outFileName", "설문문항");
        params.put("sheetName", "sample");
        params.put("list", list);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        params.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(params);

        return "excelView";
    }

    /**
     * 교수설문문항엑셀업로드
     *
     * @param srvyId 		설문아이디
     * @param uploadFiles 	파일목록
     * @param uploadPath 	파일경로
     * @param excelGrid 	엑셀그리드
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyQstnExcelUpload.do")
    @ResponseBody
    public ProcessResultVO<SrvyVO> profSrvyQstnExcelUpload(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SrvyVO> resultVO = new ProcessResultVO<SrvyVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);
        vo.setRgtrId(userId);

        try {
        	resultVO = srvyFacadeService.srvyQstnExcelUpload(vo);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    /**
     * 설문문항등록
     *
     * @param SrvyQstnVO 문항정보
     * @return ProcessResultVO<SrvyQstnVO>
     * @throws Exception
     */
    @RequestMapping(value="/srvyQstnRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyQstnVO> srvyQstnRegistAjax(SrvyQstnVO vo,
    			@RequestParam(value="qstns", defaultValue="[]") String qstnsStr,
    			@RequestParam(value="lvls", defaultValue="[]") String lvlsStr,
    			ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<SrvyQstnVO> resultVO = new ProcessResultVO<SrvyQstnVO>();

        try {
            if(ValidationUtils.isEmpty(userId) || ValidationUtils.isEmpty(vo.getSrvypprId())) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }

            vo.setRgtrId(userId);
            srvyFacadeService.srvyQstnRegist(vo, qstnsStr, lvlsStr);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("문항 등록 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 설문문항수정
     *
     * @param QstnVO 문항 정보
     * @return ProcessResultVO<QstnVO>
     * @throws Exception
     */
    @RequestMapping(value="/srvyQstnModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyQstnVO> srvyQstnModifyAjax(SrvyQstnVO vo,
				@RequestParam(value="qstns", defaultValue="[]") String qstnsStr,
				@RequestParam(value="lvls", defaultValue="[]") String lvlsStr,
				ModelMap model, HttpServletRequest request) throws Exception {

    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<SrvyQstnVO> resultVO = new ProcessResultVO<SrvyQstnVO>();

        try {
            if(ValidationUtils.isEmpty(userId) || ValidationUtils.isEmpty(vo.getSrvypprId())) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }

            vo.setRgtrId(userId);
            srvyFacadeService.srvyQstnModify(vo, qstnsStr, lvlsStr);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("문항 등록 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 설문문항삭제
     *
     * @param srvypprId 	설문지아이디
     * @param srvyQstnId 	설문문항아이디
     * @param qstnSeqno 	문항순번
     * @throws Exception
     */
    @RequestMapping(value="/srvyQstnDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyQstnVO> srvyQstnDeleteAjax(SrvyQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SrvyQstnVO> resultVO = new ProcessResultVO<SrvyQstnVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
        	vo.setRgtrId(userId);
            srvyFacadeService.srvyQstnDelete(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("설문 문항 삭제 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 설문문항정보조회
     *
     * @param srvypprId 	설문지아이디
     * @param srvyQstnId    설문문항아이디
     * @return 설문문항정보
     * @throws Exception
     */
    @RequestMapping(value="/srvyQstnSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyMainView> srvyQstnSelectAjax(SrvyQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SrvyMainView> resultVO = new ProcessResultVO<SrvyMainView>();

        try {
        	resultVO.setReturnVO(srvyFacadeService.getSrvyQstn(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("정보 조회 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

    /**
     * 설문지순번수정
     *
     * @param srvyId 	설문아이디
     * @param srvySeqno 변경할 설문지순번
     * @param searchKey 설문지순번
     * @throws Exception
     */
    @RequestMapping(value="/srvySeqnoModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvypprVO> srvySeqnoModifyAjax(SrvypprVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<SrvypprVO> resultVO = new ProcessResultVO<SrvypprVO>();

        try {
            vo.setMdfrId(userId);
            srvyFacadeService.srvySeqnoModify(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 문항순번수정
     *
     * @param srvypprId 	설문지아이디
     * @param qstnSeqno 	변경할 문항순번
     * @param searchKey 	문항순번
     * @throws Exception
     */
    @RequestMapping(value="/qstnSeqnoModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyQstnVO> qstnSeqnoModifyAjax(SrvyQstnVO vo, ModelMap model, HttpServletRequest request) throws Exception {

    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));
    	ProcessResultVO<SrvyQstnVO> resultVO = new ProcessResultVO<SrvyQstnVO>();

    	try {
    		vo.setMdfrId(userId);
    		srvyFacadeService.qstnSeqnoModify(vo);
    		resultVO.setResult(1);
    	} catch(Exception e) {
    		resultVO.setResult(-1);
    		resultVO.setMessage("수정 중 에러가 발생하였습니다.");
    	}
    	return resultVO;
    }

    /**
     * 설문문제출제완료수정
     *
     * @param upSrvyId   	상위설문아이디
     * @param srvyId   		설문아이디
     * @param srvyGbncd   	설문팀구분코드 ( SRVY_TEAM, SRVY )
     * @param searchGubun 	수정상태 ( save, edit )
     * @param searchKey 	( bsc, dtl )
     * @return ProcessResultVO<SrvyVO>
     * @throws Exception
     */
    @RequestMapping(value="/srvyQstnsCmptnModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyVO> srvyQstnsCmptnModifyAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = SessionInfo.getUserId(request);
        ProcessResultVO<SrvyVO> resultVO = new ProcessResultVO<SrvyVO>();

        try {
            vo.setMdfrId(userId);
            srvyFacadeService.srvyQstnsCmptnModify(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("문항 출제 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수설문평가관리화면
     *
     * @param srvyId 	설문아이디
     * @param sbjctId 	과목아이디
     * @return prof_srvy_evl_mng_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyEvlMngView.do")
    public String profSrvyEvlMngView(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
		SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvyEvlMngView(vo);

		model.addAttribute("vo", srvyMainView.getSrvyEgovMap());
		model.addAttribute("menuTycd", "PROF");
		model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

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
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyPtcpListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profSrvyPtcpListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
        	SrvyMainView srvyMainView = srvyFacadeService.getSrvyPtcpList(params);
            resultVO.setReturnList(srvyMainView.getSrvyPtcpList());
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수설문지평가팝업
     *
     * @param srvyId 			설문아이디
     * @param srvyPtcpId 		설문참여아이디
     * @param userId    		사용자아이디
     * @param srvyPtcpEvlyn    	평가여부
     * @param ptcpyn    		참여여부
     * @param searchValue    	검색어(학과, 학번, 이름)
     * @return prof_srvyppr_evl_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvypprEvlPopup.do")
    public String profSrvypprEvlPopup(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {

        SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvypprEvlPopup(params);
        model.addAttribute("params", params);
        model.addAttribute("vo", srvyMainView.getSrvyEgovMap());
        model.addAttribute("srvyPtcpnt", srvyMainView.getSrvyPtcpnt());
        model.addAttribute("srvyPtcpList", srvyMainView.getSrvyPtcpList());
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
     * @throws Exception
     */
    @RequestMapping(value="/srvyQstnDistributionChartAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyMainView> srvyQstnDistributionChartAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SrvyMainView> resultVO = new ProcessResultVO<SrvyMainView>();

        try {
        	resultVO.setReturnVO(srvyFacadeService.getSrvyQstnDistributionChart(params));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생했습니다!");
        }
        return resultVO;
    }

    /**
     * 교수설문지인쇄팝업
     *
     * @param upSrvyId 	상위설문아이디
     * @param srvyId   	설문아이디
     * @param userId   	사용자아이디
     * @return prof_srvyppr_print_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvypprPrintPopup.do")
    public String profSrvypprPrintPopup(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {
    	SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvypprPrintPopup(params);
    	model.addAttribute("params", params);
        model.addAttribute("srvyPtcpnt", srvyMainView.getSrvyPtcpnt());
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
	* @throws Exception
	*/
    @RequestMapping(value="/profSrvyMemoPopup.do")
    public String profSrvyMemoPopup(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {
    	SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvyMemoPopup(params);

        model.addAttribute("vo", srvyMainView.getSrvyEgovMap());
        model.addAttribute("srvyPtcpnt", srvyMainView.getSrvyPtcpnt());
        model.addAttribute("profMemo", srvyMainView.getProfMemo());

		return "srvy/popup/prof_srvy_memo_pop";
    }

    /**
	* 설문교수메모수정
	*
	* @param examDtlId 	시험상세아이디
	* @param tkexamId 	시험응시아이디
	* @param userId 	사용자아이디
	* @param profMemo 	교수메모
	* @throws Exception
	*/
    @RequestMapping(value="/srvyProfMemoModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<SrvyPtcpVO> srvyProfMemoModifyAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<SrvyPtcpVO> resultVO = new ProcessResultVO<SrvyPtcpVO>();

        try {
        	params.put("rgtrId", userId);
            srvyFacadeService.profMemoModify(params);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("메모 저장 중 에러가 발생하였습니다.");
        }
        return resultVO;
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
    @RequestMapping(value="/profSrvyEvlScrBulkModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> profSrvyEvlScrBulkModifyAjax(@RequestBody List<Map<String, Object>> list, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        try {
            for(Map<String, Object> map : list) {
            	map.put("rgtrId", userId);
            }
            srvyFacadeService.profSrvyEvlScrBulkModify(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("점수 수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수설문참여현황팝업
     *
     * @param srvyId 	설문아이디
     * @param sbjctId 	과목아이디
     * @return prof_srvy_ptcp_status_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyPtcpStatusPopup.do")
    public String profSrvyPtcpStatusPopup(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	UserContext userCtx = new UserContext(SessionInfo.getOrgId(request),
                SessionInfo.getUserId(request),
                SessionInfo.getUserTycd(request),
                SessionInfo.getAuthrtCd(request),
                SessionInfo.getAuthrtGrpcd(request),
                SessionInfo.getUserRprsId(request),
                SessionInfo.getLastLogin(request));
        request.getSession().setAttribute("USER_CONTEXT", userCtx);

    	SrvyMainView srvyMainView = srvyFacadeService.loadProfSrvyPtcpStatusPopup(vo, userCtx);

    	model.addAttribute("vo", srvyMainView.getSrvyEgovMap());
    	if("SRVY_TEAM".equals(srvyMainView.getSrvyEgovMap().get("srvyGbn"))) {
    		model.addAttribute("srvyTeamList", srvyMainView.getSrvyTeamList());
    	}
    	model.addAttribute("cntnDvcTycdList", srvyMainView.getCmmnCdList().get("cntnDvcTycd"));
    	model.addAttribute("srvyPtcpDvcStatusList", srvyMainView.getSrvyPtcpDvcStatusList());
    	model.addAttribute("srvyPtcpCnt", srvyMainView.getSrvyPtcpCnt());
    	model.addAttribute("srvypprList", srvyMainView.getSrvypprList());
    	model.addAttribute("srvyQstnList", srvyMainView.getSrvyQstnList());
    	model.addAttribute("srvyVwitmList", srvyMainView.getSrvyVwitmList());
    	model.addAttribute("srvyQstnVwitmLvlList", srvyMainView.getSrvyQstnVwitmLvlList());
    	model.addAttribute("srvyChcQstnRspnsStatusList", srvyMainView.getSrvyChcQstnRspnsStatusList());
    	model.addAttribute("srvyTextQstnRspnsStatusList", srvyMainView.getSrvyTextQstnRspnsStatusList());
    	model.addAttribute("srvyLevelQstnRspnsStatusList", srvyMainView.getSrvyLevelQstnRspnsStatusList());
    	model.addAttribute("colorList", srvyMainView.getColorList());

        return "srvy/popup/prof_srvy_ptcp_status_pop";
    }

    /**
     * 교수설문엑셀성적등록팝업
     *
     * @param srvyId 	설문아이디
     * @param sbjctId 	과목아이디
     * @return prof_srvy_excel_scr_regist_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyExcelScrRegistPopup.do")
    public String profSrvyExcelScrRegistPopup(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
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
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyScrRegistSampleExcelDown.do")
    public String profSrvyScrRegistSampleExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String title = "학습자목록";

        Map<String, Object> searchMap = new HashMap<String, Object>();
        searchMap.put("srvyId", vo.getSrvyId());
        List<EgovMap> srvyPtcpList = srvyFacadeService.getSrvyPtcpList(searchMap).getSrvyPtcpList();

        // POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        // 엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);  		// 시험학습자목록
        map.put("sheetName", title);   	// 학습자목록
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", srvyPtcpList);

        HashMap<String, Object> params = new HashMap<>();
        params.put("outFileName", title);  // 학습자목록
        params.put("sheetName", title);    // 학습자목록
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
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyScrExcelUpload.do")
    @ResponseBody
    public ProcessResultVO<SrvyPtcpVO> profSrvyScrExcelUpload(SrvyPtcpVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SrvyPtcpVO> resultVO = new ProcessResultVO<SrvyPtcpVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setRgtrId(userId);

        try {
        	srvyFacadeService.srvyScrExcelUpload(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        return resultVO;
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
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyPtcpListExcelDown.do")
    public String profSrvyPtcpListExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", "참여목록");
        map.put("sheetName", "참여목록");
        map.put("excelGrid", vo.getExcelGrid());

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("srvyId", vo.getSrvyId());
        params.put("ptcpyn", request.getParameter("ptcpyn"));
        params.put("srvyPtcpEvlyn", request.getParameter("srvyPtcpEvlyn"));
        params.put("searchValue", vo.getSearchValue());
        SrvyMainView srvyMainView = srvyFacadeService.getSrvyPtcpList(params);
        map.put("list", srvyMainView.getSrvyPtcpList());

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", "참여목록");

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
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyPtcpStatusExcelDown.do")
    public String profSrvyPtcpStatusExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String paperTitle = "설문결과";

        SrvyMainView srvyMainView = srvyFacadeService.getSrvyPtcpStatusExcelDownList(vo);

        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", paperTitle);      // 설문결과
        map.put("sheetName", paperTitle);  // 설문결과
        map.put("list", srvyMainView);

        //엑셀화
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", paperTitle);   // 설문결과
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
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyRspnsStatusExcelDown.do")
    public String profSrvyRspnsStatusExcelDown(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String paperTitle = "참여자 답변 목록";

        SrvyMainView srvyMainView = srvyFacadeService.getSrvyRspnsStatusExcelDownList(vo);

        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", paperTitle);
        map.put("sheetName", paperTitle);
        map.put("list", srvyMainView);

        //엑셀화
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", "제출설문");
        modelMap.put("workbook", makeSrvyRspnsStatusExcel(map, request));
        modelMap.put("list", srvyMainView);
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    // 교수설문참여현황엑셀생성
    public SXSSFWorkbook makeSrvyPtcpStatusExcel(HashMap<String, Object> map, HttpServletRequest request) throws Exception {

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
        	if("SRVY_TEAM".equals(srvyMainView.getSrvyEgovMap().get("srvyGbn")) && srvyppr.getSrvySeqno() == 1) {
        		// 설문팀목록
        		for(EgovMap team : srvyMainView.getSrvyTeamList()) {
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
            			List<EgovMap> rspnsList = srvyMainView.getSrvyChcQstnRspnsStatusList();
            			for (EgovMap rspns : rspnsList) {
            				if(qstn.get("srvyQstnId").equals(rspns.get("srvyQstnId"))) {
            					row = worksheet.createRow(++rowNum);

            					// 문항아이템(문항 선택지)
            					String itemTitle = rspns.get("vwitmCts").toString();
            					if ("ETC".equals(itemTitle) ) {
            						itemTitle = "기타 항목";
            					}
            					row.createCell(0).setCellValue(itemTitle);
            					row.getCell(0).setCellStyle(itemStyle);

            					// 문항 답변 현황
            					StringBuilder answerStatus = new StringBuilder(rspns.get("ratio").toString())
            							.append("%")
            							.append(" (")
            							.append(rspns.get("totJoinCnt").toString())
            							.append("명")
            							.append(" ")
            							.append("중")
            							.append(" ")
            							.append(rspns.get("joinCnt").toString())
            							.append("명")
            							.append(")");
            					row.createCell(1).setCellValue(answerStatus.toString());
            					row.getCell(1).setCellStyle(answerStyle);

            					// 문항 답변 카운트
            					row.createCell(2).setCellValue(rspns.get("joinCnt").toString() + "명");
            					row.getCell(2).setCellStyle(answerCntStyle);
            				}
            			}

            		// 서술형
            		} else if ("LONG_TEXT".equals(reschQstnTypeCd)) {
            			List<EgovMap> rspnsList = srvyMainView.getSrvyTextQstnRspnsStatusList();
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
            					List<EgovMap> rspnsList = srvyMainView.getSrvyLevelQstnRspnsStatusList();
            					if (rspnsList != null && !rspnsList.isEmpty() && rspnsList.size() > 0) {
            						for(EgovMap rspns : rspnsList) {
            							String srvyVwitmId = rspns.get("srvyVwitmId").toString();
            							if(srvyVwitmId.equals(vwitm.getSrvyVwitmId())) {
            								StringBuilder answerStatus = new StringBuilder(rspns.get("ratio").toString())
            										.append("%")
            										.append(" (")
            										.append(rspns.get("totJoinCnt").toString())
            										.append("명")
            										.append(" ")
            										.append("중")
            										.append(" ")
            										.append(rspns.get("joinCnt").toString())
            										.append("명")
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
    public SXSSFWorkbook makeSrvyRspnsStatusExcel(HashMap<String, Object> map, HttpServletRequest request) throws Exception {

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
        List<EgovMap> qstnList = srvyMainView.getSrvyExcelDownQstnList();
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
	        if("SRVY_TEAM".equals(srvyMainView.getSrvyEgovMap().get("srvyGbn"))) {
	        	srvyId = srvyMainView.getSrvyTeamList().get(teamCnt).get("srvyId").toString();
	        	row = worksheet.createRow(++rowNum); // 빈 row
	        	row = worksheet.createRow(++rowNum);
	        	row.createCell(0).setCellValue(srvyMainView.getSrvyTeamList().get(teamCnt).get("teamnm").toString());
	        	row.getCell(0).setCellStyle(titleStyle);
	        	row = worksheet.createRow(++rowNum); // 빈 row
	        	teamCnt++;
	        } else {
	        	srvyId = firstQstn.get("srvyId").toString();
	        }

	        //header
            row = worksheet.createRow(++rowNum);
            row.createCell(0).setCellValue("No");
            row.createCell(1).setCellValue("참여자");
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
            List<EgovMap> curSrvyUserList = srvyMainView.getSrvyExcelDownQstnRspnsList().stream()
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
		            List<EgovMap> curUserRspnsList = srvyMainView.getSrvyExcelDownQstnRspnsList().stream()
						    .filter(user ->
						    	curUser.get("userId").equals(user.get("userId")) &&
						    	curUser.get("srvyId").equals(user.get("srvyId"))
						    )
						    .collect(Collectors.toList());

		            for(EgovMap qstn : curSrvyQstnList) {
		            	String rspns = "";
			            if ("LEVEL".equals(qstn.get("qstnRspnsTycd")) ) {
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
			            		    .map(user -> user.get("vwitmCts").toString())
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

}
