package knou.lms.mrk.web;

import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.fasterxml.jackson.core.JsonProcessingException;
import knou.framework.common.*;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.service.CommonService;
import knou.lms.mrk.vo.*;
import knou.lms.system.manage.service.CommonCodeService;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.mrk.service.MarkFacadeService;
import knou.lms.mrk.service.MarkItemSettingService;
import knou.lms.mrk.service.MarkObjectionApplyService;
import knou.lms.mrk.service.MarkService;
import knou.lms.mrk.service.MarkSubjectService;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping("/mrk")
public class MarkController extends ControllerBase {
	
    private static final Logger log = LoggerFactory.getLogger(MarkController.class);
	
    @Resource(name="markFacadeService")
    private MarkFacadeService markFacadeService;

    @Resource(name="markSubjectService")
    private MarkSubjectService markSubjectService;

    @Resource(name="markObjectionApplyService")
    private MarkObjectionApplyService markObjectionApplyService;

    @Resource(name = "subjectService")
    private SubjectService subjectService;
    
    @Resource(name = "markService")
    private MarkService markService;   
    
    @Resource(name="markItemSettingService")
    private MarkItemSettingService markItemSettingService;

    @Resource(name="commonCodeService")
    private CommonCodeService commonCodeService;

    @Resource(name="commonService")
    private CommonService commonService;

    /**
	 * 교수 > 대시보드 > 글로벌메뉴 > 성적관리
	 * 
	 * @return prof_total_mrk_sbjct_list_view.jsp
	 * @throws Exception
	 */
	@RequestMapping("/profTotalMrkListView.do")
    public String scoreOverallProfMain(MarkSubjectVO vo, @CurrentUser UserContext userCtx, Model model) {

    	String usertAuthrtGrpcd = userCtx.getAuthrtGrpcd();
    	String usertAuthrtCd = userCtx.getAuthrtCd();    	
    	
        // 조회필터옵션 세팅
    	EgovMap filterOptions = markFacadeService.loadFilterOptions(userCtx);
    	model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("authGrpCd", usertAuthrtGrpcd);

        if( ! CommConst.AUTHRT_GRPCD_PROF.equals(usertAuthrtGrpcd) ) {
        	throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }
        
        model.addAttribute("TUT_YN", CommConst.AUTHRT_CD_TUT.equals(usertAuthrtCd) ? "Y" : "N");
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        model.addAttribute("sUserId", userCtx.getUserId());
        model.addAttribute(getEncParams());

        return "mrk/prof_total_mrk_sbjct_list_view";
    }

    /**
     * [교수] 강의실 > 성적관리 > 성적관리 탭
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/lec/profSbjctMrkListView.do")
    public String profSbjctMrkListView(MarkSubjectVO vo, @CurrentUser UserContext userCtx, 
    		Model model, HttpServletRequest request) throws Exception {

        String userAuthrtGrpcd = userCtx.getAuthrtGrpcd();

        if(! CommConst.AUTHRT_GRPCD_PROF.equals(userAuthrtGrpcd) ) {
            throw new AccessDeniedException(getMessage("common.system.no_auth"));  // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
        }

        String sbjctId = vo.getSbjctId();
        String orgId = userCtx.getOrgId();

        ProcessResultVO<EgovMap> returnVO = new ProcessResultVO<>();

        returnVO = markSubjectService.stdMrkList(orgId, sbjctId, "");

        ObjectMapper mapper = new ObjectMapper();
        String mrkItmStnJson = mapper.writeValueAsString(returnVO.getReturnSubVO());

        model.addAttribute("mrkItmStngList", mrkItmStnJson );
        model.addAttribute("encParams", getEncParams());

        return "mrk/prof_mrk_sbjct_list_view";
    }


    /**
     * [학생] 강의실 > 성적확인 > 성적확인 탭
     * @param vo
     * @param model
     * @return
     */
    @RequestMapping("/lec/stdSbjctMrkStsView.do")
    public String stdSbjctMrkStsView (MarkSubjectVO vo, @CurrentUser UserContext userCtx,  Model model) {

        model.addAttribute("encParams", getEncParams());

        // 강의 평가 완료 여부
        boolean lctrEvlYn = true;

        if (!lctrEvlYn) { // todo: 강의평가 작업완료되면 해당 목록 가져와서 쓸 예정... 임시로  pass
            // 성적 조회기간 조회

            // 강의평가 - 미완료 : 강의평가 목록 조회
            return "mrk/std_lctr_evl_list_view";
        } else {

            // 성적 이의신청기간 조회
            Map<String, String> mrkObjctAplyProd = markObjectionApplyService.mrkObjctAplyPrdSelect(userCtx.getOrgId());
            model.addAttribute("taskSdttm", mrkObjctAplyProd.get("taskSdttm"));
            model.addAttribute("taskEdttm", mrkObjctAplyProd.get("taskEdttm"));

            // 강의평가 - 완료 : 성적현황 화면 조회
            return "mrk/std_mrk_sbjct_sts_view";
        }
    }

    /**
     * 학생의 성적 현황 정보 조회
     * - 학생 성적항목별 점수 목록
     * - 과목 성적항목별 평균점수 목록
     * - 점수 구간별 분포 목록
     * @param vo
     * @return
     */
    @GetMapping("/stdMrkSbjctStsSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<MarkSubjectDetailView> stdMrkSbjctStsSelectAjax(MarkSubjectVO vo, @CurrentUser UserContext userCtx) {

        ProcessResultVO<MarkSubjectDetailView> resultVO = new ProcessResultVO<>();
        resultVO.setReturnVO(markFacadeService.getStdMrkSbjctSts(vo.getSbjctId(), userCtx.getUserId()));

        return resultVO;
    }


    /**
     * [교수] 과목의 학생 성적 목록 조회
     * @param vo
     * @return
     */
    @GetMapping("/profMrkListBySbjctAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profMrkListBySbjctAjax (MarkSubjectVO vo, @CurrentUser UserContext userCtx) {

        ProcessResultVO<EgovMap> resultVO = markSubjectService.stdMrkList(userCtx.getOrgId(), vo.getSbjctId(), vo.getSearchType());
        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * [교수]해당 과목의 학생 성적 초기화 (평가점수 가져오기)
     * @param sbjctId
     * @param request
     */
    @PostMapping("/profStdMrkInitAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profStdMrkInitAjax(MarkSubjectVO vo, @CurrentUser UserContext userCtx) {

        // TODO : 평가점수 가져오기 재점검
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        markSubjectService.stdMrkInit(userCtx.getOrgId(), vo.getSbjctId(), userCtx.getUserId());
        resultVO.setResultSuccess("평가점수 가져오기 완료");

        return resultVO;
    }

    /**
     * (성적처리저장 전) 절대평가 분포 목록 조회 팝업
     * @param vo
     * @param userCtx
     * @return
     */
    @GetMapping("/profStdGrdrtListPop.do")
    public String profStdGrdrtListPop (MarkSubjectVO vo, @CurrentUser UserContext userCtx) {

        if (!"PROF".equals(userCtx.getAuthrtCd())) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        return "mrk/popup/prof_absolute_grdrt_list_pop";
//        return "mrk/popup/std_mrk_objct_aply_pop";
    }

    /**
     * [교수] 과목의 학생 성적 수정
     * @param vo
     * @param userCtx
     * @return
     */
    @PostMapping("/profStdMrkModify.do")
	@ResponseBody
    public ProcessResultVO<EgovMap> profStdMrkModify(@RequestBody MarkSubjectVO vo, @CurrentUser UserContext userCtx) throws JsonProcessingException {
    	
        // unchecked cast 해소
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Map<String, String>> stdMrkListMap = mapper.readValue(
                vo.getSbjctMrkListStr(), new TypeReference<>() {}
        );

        return markSubjectService.stdMrkModify(stdMrkListMap, userCtx.getOrgId(), vo.getSbjctId(), userCtx.getUserId());
    }

    /**
     * [교수] 학생 점수환산상태 수정
     * (최종 확정, 평가취소)
     * @param vo
     * @param userCtx
     * @return
     */
    @PostMapping("/profStdScrCnvsStsModify.do")
    @ResponseBody
    public ResultDTO<EgovMap> profStdScrCnvsStsModify(MarkSubjectVO vo, @CurrentUser UserContext userCtx) {

        String scrCnvsStscd = vo.getScrCnvsStscd();

        PageInfo pageInfo = new PageInfo();
        pageInfo.setUpCd("SCR_CNVS_STSCD");
        List<EgovMap> scrCnvsStscdList = commonCodeService.admCmmnCdList(pageInfo);

        boolean isValidCd = scrCnvsStscdList.stream().anyMatch(map -> scrCnvsStscd.equals(map.get("cd")));

        if (!isValidCd) {
            throw new IllegalArgumentException(getCommonFailMessage());
        }

        vo.setMdfrId(userCtx.getUserId());

        return markSubjectService.stdScrCnvsStsModify(vo);
    }

    //  이의 신청 --------------------------------------------------------------------------
    /**
     * [교수] 강의실 > 성적관리 > 성적이의신청 탭
     * @param vo
     * @param model
     * @return
     */
    @GetMapping("/lec/profMrkObjctAplyView.do")
    public String profMrkObjctAplyView(MarkSubjectVO vo, Model model) {

        // TODO:기관코드 임시 하드코딩
        vo.setOrgId("LMSBASIC");
        
        // 성적이의 신청기간 조회
        Map<String, String> mrkObjctAplyProd = markFacadeService.getMrkObjctAplyPrd(vo.getOrgId());
        model.addAttribute("taskSdttm", mrkObjctAplyProd.get("taskSdttm"));
        model.addAttribute("taskEdttm", mrkObjctAplyProd.get("taskEdttm"));
        model.addAttribute("encParams", getEncParams());
        return "mrk/prof_mrk_objct_aply_list_view";
    }

    /**
     * [교수] 성적이의신청 목록 조회
     * @param vo (vo.sbjctId)
     * @return
     */
    @GetMapping("/profMrkObjctAplyListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profMrkObjctAplyListAjax(MarkObjectionApplyVO vo) {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        // 성적 이의신청 목록 조회
        resultVO.setReturnList(markObjectionApplyService.profMrkObjctAplyList(vo.getSbjctId()));
        resultVO.setResultSuccess();
        return resultVO;
    }

    /**
     * [교수] 강의실 > 성적관리 > 성적이의신청 탭 > 엑셀다운로드
     * @param vo
     * @param model
     * @return
     */
    @PostMapping("/profMrkObjctAplyListExcelDown.do")
    public String profMrkObjctAplyListExcelDown (MarkObjectionApplyVO vo, Model model) {
        HashMap<String, Object> map = new HashMap<>();
        String title = getMessage("score.label.answer.list"); // 성적재확인 신청목록

        List<EgovMap> list = markObjectionApplyService.profMrkObjctAplyList(vo.getSbjctId());

        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + DateTimeUtil.getDates());
        modelMap.put("sheetName", title);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    /**
     * [교수] 강의실 > 성적관리 > 성적이의신청 탭 > 성적이의신청사유 팝업
     * @param vo
     * @return
     */
    @GetMapping("/profMrkObjctAplySelectPop.do")
    public String profMrkObjctAplySelectPop (MarkObjectionApplyVO vo, Model model) {
        model.addAttribute("mrkObjctAplyVO",  markObjectionApplyService.mrkObjctAplySelect(vo.getMrkObjctAplyId()));
        return "mrk/popup/prof_mrk_objct_aply_pop";
    }

    /**
     * 성적이의신청 조회
     * @param vo
     * @return
     * @throws Exception
     */
    @GetMapping("/mrkObjctAplyctsSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<MarkObjectionApplyVO> mrkObjctAplyctsSelectAjax(MarkObjectionApplyVO vo) {    	
        ProcessResultVO<MarkObjectionApplyVO> resultVO = new ProcessResultVO<>();
        resultVO.setReturnVO(markObjectionApplyService.mrkObjctAplySelect(vo.getMrkObjctAplyId()));
        return resultVO;
    }

    /**
     * [교수] 강의실 > 성적관리 > 성적이의신청 탭 > 신청결과 팝업
     * @param vo
     * @param model
     * @return
     * @throws Exception
     */
    @GetMapping("/mrkObjctAplyListViewPop.do")
    public String mrkObjctAplyListViewPop(MarkObjectionApplyVO vo, Model model) throws Exception {

        // 성적이의신청 목록조회
        List<EgovMap> aplyList = markObjectionApplyService.profMrkObjctAplyList(vo.getSbjctId());

        String targetId = "";
        for (EgovMap applyInfo : aplyList) {
            if (applyInfo.get("mrkObjctAplyId").equals(vo.getMrkObjctAplyId())){
                targetId = (String) applyInfo.get("userId");
                break;
            }
        }
        // 조회대상
        model.addAttribute("targetId", targetId);

        ObjectMapper mapper = new ObjectMapper();
        String aplyListJson = mapper.writeValueAsString(aplyList);

        model.addAttribute("aplyList", aplyListJson);
        model.addAttribute("encParams", getEncParams());

        return "mrk/popup/prof_mrk_objct_aply_list_pop";
    }

    /**
     * [교수] 강의실 > 성적관리 > 성적이의신청 탭 > 신청결과 팝업 > 성적상세 팝업
     * @param vo
     * @param model
     * @return
     * @throws Exception
     */
    @GetMapping("/mrkSbjctSelectViewPop.do")
    public String mrkSbjctSelectViewPop(DefaultVO vo, Model model) throws Exception {

        // 기관코드 임시 하드코딩
        vo.setOrgId("LMSBASIC");
        MarkSubjectDetailView detailView = markFacadeService.getStdMrkSbjctDtl(vo.getOrgId(), vo.getSbjctId(), vo.getUserId());

        ObjectMapper mapper = new ObjectMapper();

        // 성적항목비율
        List<EgovMap> mrkItmStngList = detailView.getMrkItmStngList();
        String mrkItmStngListJson = mapper.writeValueAsString(mrkItmStngList); // writeValueAsString의 json exception은 controller로 올린다.

        EgovMap mrkDetails = detailView.getStdMrkSbjctDtlInfo();
        String mrkDetailJson = mapper.writeValueAsString(mrkDetails);

        model.addAttribute("mrkItmStngList", mrkItmStngList);
        model.addAttribute("mrkItmStngListJson", mrkItmStngListJson);
        model.addAttribute("mrkDetails", mrkDetails);
        model.addAttribute("mrkDetailJson", mrkDetailJson);
        model.addAttribute("totalRatio", detailView.getTotalRatio());

        return "mrk/popup/prof_mrk_sbjct_detail_pop";
    }

    /**
     * [학생] 강의실 > 성적확인 > 성적이의신청 탭
     * @param vo
     * @param model
     * @return
     */
    @GetMapping("/lec/stdMrkOjctAplyView.do")
    public String stdMrkOjctAplyView(MarkObjectionApplyVO vo, @CurrentUser UserContext userCtx, Model model) {

        // 성적이의 신청기간 조회
        Map<String, String> mrkObjctAplyProd = markObjectionApplyService.mrkObjctAplyPrdSelect(userCtx.getOrgId());
        model.addAttribute("taskSdttm", mrkObjctAplyProd.get("taskSdttm"));
        model.addAttribute("taskEdttm", mrkObjctAplyProd.get("taskEdttm"));

        String objctAplyProdYn = markObjectionApplyService.isMrkObjctAplyDate(userCtx.getOrgId()) ? "Y" : "N";
        model.addAttribute("objctAplyProdYn", objctAplyProdYn);

        model.addAttribute("encParams", getEncParams());
        model.addAttribute("vo", vo);

        return "mrk/std_mrk_objct_aply_list_view";
    }

    /**
     * [학습자] 성적이의신청 목록 조회
     * @param vo (vo.sbjctId)
     * @return
     */
    @GetMapping("/stdMrkObjctAplyListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> stdMrkObjctAplyListAjax(MarkObjectionApplyVO vo, 
    		@CurrentUser UserContext userCtx) throws Exception {
    	
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        vo.setUserId(userCtx.getUserId());

        // 성적 이의신청 목록 조회
        resultVO= markObjectionApplyService.mrkObjctAplyListPaging(vo);
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /**
     * [학생] 강의실 > 성적관리 > 성적이의신청 탭 > 처리결과 팝업
     * @param vo
     * @return
     */
    @GetMapping("/stdMrkObjctAplySelectPop.do")
    public String stdMrkObjctAplySelectPop (MarkObjectionApplyVO vo, Model model) {
    	
    	SubjectDTO sbjctDto = new SubjectDTO(vo.getSbjctId());

        SubjectVO subjectVO = subjectService.subjectSelect(sbjctDto);
        model.addAttribute("subjectVO", subjectVO);
        model.addAttribute("mrkObjctAplyVO",  markObjectionApplyService.mrkObjctAplySelect(vo.getMrkObjctAplyId()));
        return "mrk/popup/std_mrk_objct_aply_pop";
    }

    /**
     * [학생] 강의실 > 성적관리 > 성적이의신청 탭 > 신청화면
     * @param vo
     * @param model
     * @param ctx
     * @return
     */
    @GetMapping("/stdMrkObjctAplyRegistViewPop.do")
    public String stdMrkObjctAplyRegistViewPop (MarkObjectionApplyVO vo, Model model
    		, @CurrentUser UserContext ctx, HttpServletRequest request)  {
        MarkObjectionApplyView applyView = new MarkObjectionApplyView();
        
        applyView = markFacadeService.getStdMrkObjctAply(vo.getSbjctId(), ctx, "");

        model.addAttribute("sbjctInfo", applyView.getSbjctInfo());
        model.addAttribute("userInfo", applyView.getUserInfo());
        model.addAttribute("applyInfo", applyView.getApplyInfo() == null ? new MarkObjectionApplyVO() : applyView.getApplyInfo()); // null
        model.addAttribute("applyDttm", DateTimeUtil.getYear()+"년 "+DateTimeUtil.getMonth()+"월 "+DateTimeUtil.getDay()+"일");

        model.addAttribute("encParams", getEncParams());
        model.addAttribute("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_OBJCT, null));

        return "mrk/popup/std_mrk_objct_aply_regist_pop";
    }

    /**
     * [학생] 강의실 > 성적관리 > 성적이의신청 탭 > 수정화면
     * @param vo
     * @param model
     * @param ctx
     * @return
     */
    @GetMapping("/stdMrkObjctAplyModifyViewPop.do")
    public String stdMrkObjctAplyModifyViewPop (MarkObjectionApplyVO vo, Model model
    		, @CurrentUser UserContext ctx, HttpServletRequest request) {
        MarkObjectionApplyView applyView = new MarkObjectionApplyView();

        applyView = markFacadeService.getStdMrkObjctAply(vo.getSbjctId(), ctx, vo.getMrkObjctAplyId());
        applyView.getApplyInfo().setGubun("edit");

        String applyDttm = applyView.getApplyInfo().getObjctAplyDttm();
        applyDttm = applyDttm.substring(0,4) + "년 " + applyDttm.substring(4,6) + "월 " + applyDttm.substring(6,8) + "일";
        model.addAttribute("applyDttm", applyDttm);

        model.addAttribute("sbjctInfo", applyView.getSbjctInfo());
        model.addAttribute("userInfo", applyView.getUserInfo());
        model.addAttribute("applyInfo", applyView.getApplyInfo());

        model.addAttribute("encParams", getEncParams());
        model.addAttribute("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_OBJCT, null));

        return "mrk/popup/std_mrk_objct_aply_regist_pop";
    }

    /**
     * [학생] 성적 이의신청 등록
     * @param vo
     * @param userCtx
     * @return
     */
    @PostMapping("/stdMrkObjctAplyRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<MarkObjectionApplyVO> stdMrkObjctAplyRegist(MarkObjectionApplyVO vo
    		, @CurrentUser UserContext userCtx) throws Exception { // IOException     	
        ProcessResultVO<MarkObjectionApplyVO> resultVO = new ProcessResultVO<>();
        markObjectionApplyService.mrkObjctAplyRegist(vo, userCtx);
        resultVO.setResultSuccess(getMessage("score.label.ect.eval.oper.msg7_1"));
        return resultVO;
    }

    /**
     * [학생] 성적 이의신청 수정
     * @param vo
     * @param userCtx
     * @return
     */
    @PostMapping("/stdMrkObjctAplyModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<MarkObjectionApplyVO> stdMrkObjctAplyModify(MarkObjectionApplyVO vo
    		, @CurrentUser UserContext userCtx) throws Exception {

        ProcessResultVO<MarkObjectionApplyVO> resultVO = new ProcessResultVO<>();
        markObjectionApplyService.mrkObjctAplyModify(vo, userCtx);
        resultVO.setResultSuccess(getMessage("common.modify.success"));
        return resultVO;
    }

    /**
     * [학생] 성적 이의신청 삭제
     * @param vo
     * @param userCtx
     * @return
     * @throws Exception
     */
    @PostMapping("/stdMrkObjctAplyDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<MarkObjectionApplyVO> stdMrkObjctAplyDeleteAjax(MarkObjectionApplyVO vo, @CurrentUser UserContext userCtx
    		, HttpServletRequest request) throws Exception {    	
    	ProcessResultVO<MarkObjectionApplyVO> resultVO = new ProcessResultVO<>();
        markObjectionApplyService.mrkObjctAplyDelete(vo, userCtx);
        resultVO.setResultSuccess(getMessage("common.alert.delete.success"));
        return resultVO;
    }
    
    /*
     * 평가비중목록조회
     */
    @RequestMapping("/evalWeightList.do")
    public String evalWeightList(SubjectVO vo, @CurrentUser UserContext userCtx
    		, HttpServletRequest request, ModelMap model) {
    	
    	MarkView markActvRateView = markFacadeService.getMarkActvInfoSelect(vo.getSbjctId(), userCtx); 	
    	model.addAttribute("actvRateView", markActvRateView);        
        return markActvRateView.getViewName();
    }


    // 성적처리 예외 -----------------------------------------------------------------------------------------------

    /**
     * [관리자] 수업운영도구 > 과목관리 > 성적관리 > 성적처리예외처리 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return
     */
    @RequestMapping("/admMrkProcExcpProcListView.do")
    public String admMrkProcExcpProcView(SubjectVO vo, @CurrentUser UserContext userCtx, Model model) {

        if ( !isSbjctop(userCtx) )  {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        model.addAttribute("filterOptions", commonService.loadFilterOptions(userCtx));
        model.addAttribute("pageInfo", new PageInfo());

        return "/mrk/adm_mrk_proc_excp_proc_list_view";
    }

    /**
     * 성적처리 예외처리 목록 Ajax 조회 - 과목별 최근 1건
     * @param pageInfo
     * @param userCtx
     * @return
     */
    @GetMapping("/admMrkProcExcpProcListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admMrkProcExcpProcListAjax(PageInfo pageInfo, @CurrentUser UserContext userCtx) {

        if ( !isSbjctop(userCtx) )  {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        return markSubjectService.mrkProcExcpProcListPaging(pageInfo);
    }

    /**
     * [관리자] 수업운영도구 > 과목관리 > 성적관리 > 성적처리예외처리 > 예외처리로그 팝업 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return
     */
    @GetMapping("/admAllMrkProcExcpProcListPop.do")
    public String admAllMrkProcExcpProcListPop(SubjectVO vo, @CurrentUser UserContext userCtx, Model model) {

        if ( !isSbjctop(userCtx) )  {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        model.addAttribute("filterOptions", commonService.loadFilterOptions(userCtx));
        model.addAttribute("pageInfo", new PageInfo());

        return "/mrk/popup/adm_mrk_proc_excp_proc_list_pop";
//        return "/mrk/prof_absolute_grdrt_list_pop";
    }

    /**
     * 성적처리 예외처리 목록 Ajax 조회 - 전체
     * @param pageInfo
     * @param userCtx
     * @return
     */
    @GetMapping("/admAllMrkProcExcpProcListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admAllMrkProcExcpProcListAjax(PageInfo pageInfo, @CurrentUser UserContext userCtx) {

        if ( !isSbjctop(userCtx) )  {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        return markSubjectService.allMrkProcExcpProcListPaging(pageInfo);
    }

    /**
     * 성적처리 예외처리 건 일괄 등록
     * @param mrkProcExcpProcList
     * @param userCtx
     * @return
     */
    @PostMapping("/admMrkProcExcpProcRegist.do")
    @ResponseBody
    public ResultDTO<EgovMap> admMrkProcExcpProcRegist(@RequestBody List<MrkProcExcpProcVO> mrkProcExcpProcList, @CurrentUser UserContext userCtx) {

        if ( !isSbjctop(userCtx) )  {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        markSubjectService.mrkProcExcpProcRegist(mrkProcExcpProcList, userCtx.getUserId());

        return new ResultDTO<EgovMap>().setResultSuccess();
    }

    /**
     * 성적처리 예외처리 건 일괄 삭제
     * @param mrkProcExcpProcList (@required mrkProcExcpProcId, sbjctId)
     * @param userCtx
     * @return
     */
    @PostMapping("/admMrkProcExcpProcDelete.do")
    @ResponseBody
    public ResultDTO<EgovMap> admMrkProcExcpProcDelete(@RequestBody List<MrkProcExcpProcVO> mrkProcExcpProcList, @CurrentUser UserContext userCtx) {

        if ( !isSbjctop(userCtx) )  {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        markSubjectService.mrkProcExcpProcDelete(mrkProcExcpProcList);

        return new ResultDTO<EgovMap>().setResultSuccess();
    }




    /**
     * 과목 운영자 여부 체크
     * @param userCtx
     * @return boolean
     */
    private boolean isSbjctop(UserContext userCtx) {

        boolean isSbjctop = false;
        List<String> allowedAuthrtCds = Arrays.asList(CommConst.AUTHRT_CD_ADM, CommConst.AUTHRT_CD_SBJCTOP);

        if ( userCtx.isAdmin() && allowedAuthrtCds.contains(userCtx.getAuthrtCd()) ) {
            isSbjctop = true;
        }

        return isSbjctop;
    }

}