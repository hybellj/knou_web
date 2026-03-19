package knou.lms.srvy.web;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.srvy.facade.SrvyFacadeService;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.vo.SrvypprVO;
import knou.lms.srvy.web.view.SrvyMainView;

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
    public String profSrvyQstnMngView(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        UserContext userCtx = new UserContext(SessionInfo.getOrgId(request),
                SessionInfo.getUserId(request),
                SessionInfo.getUserTycd(request),
                SessionInfo.getAuthrtCd(request),
                SessionInfo.getAuthrtGrpcd(request),
                SessionInfo.getUserRprsId(request),
                SessionInfo.getLastLogin(request));
        request.getSession().setAttribute("USER_CONTEXT", userCtx);

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
     * 퀴즈문항수정
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

}
