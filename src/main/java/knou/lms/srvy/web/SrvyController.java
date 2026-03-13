package knou.lms.srvy.web;

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
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.srvy.facade.SrvyFacadeService;
import knou.lms.srvy.vo.SrvyVO;
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
        model.addAttribute("sbjctId", "SBJCT_OFRNG_ID1");    // 과목아이디
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
            resultVO = srvyMainView.getProfAuthrtSbjctSrvyList();
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

        //List<ReshPageVO> listReschPage = reshQstnService.listReshPage(pageVo);
        //model.addAttribute("vo", quizMainView.getExamBscVO());
        //model.addAttribute("qstnList", quizMainView.getQstnList());
        //model.addAttribute("qstnVwitmList", quizMainView.getQstnVwitmList());
        //if("QUIZ_TEAM".equals(quizMainView.getExamBscVO().getExamGbncd())) {
        //    model.addAttribute("quizTeamList", quizMainView.getQuizTeamList());
        //}

        return "srvy/popup/prof_srvyppr_preview_pop";
    }

}
