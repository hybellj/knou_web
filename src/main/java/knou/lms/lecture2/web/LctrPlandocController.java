package knou.lms.lecture2.web;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.RepoInfo;
import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.lecture2.facade.LctrPlandocFacadeService;
import knou.lms.lecture2.service.LctrPlandocService;
import knou.lms.lecture2.vo.LctrPlandocVO;
import knou.lms.lecture2.vo.LctrPlandocView;
import knou.lms.schedule.service.CalendarService;
import knou.lms.schedule.vo.OrgTaskScheduleVO;
import knou.lms.user.CurrentUser;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping(value="/lctr/plandoc")
public class LctrPlandocController extends ControllerBase {
	
    private static final Logger log = LoggerFactory.getLogger(LctrPlandocController.class);
    private static final String LCTR_PLANDOC_ENRL_PRD = "LCTR_PLANDOC_ENRL_PRD";
    private static final String LCTR_PLANDOC_MOD_PRD = "LCTR_PLANDOC_MOD_PRD";

    @Resource(name="lctrPlandocService")
    private LctrPlandocService lctrPlandocService;

    @Resource(name="lctrPlandocFacadeService")
    private LctrPlandocFacadeService lctrPlandocFacadeService;
    @Resource(name="semesterService")
    private SemesterService semesterService;
    @Resource(name="calendarService")
    private CalendarService calendarService;

    /**
     * 교수 강의계획서 목록 화면
     *
     * @param lctrPlandocVO
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RequestMapping(value="/profLctrPlandocListView.do")
    public String profLctrPlandocListView(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx,
                                          HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        SmstrChrtVO smstrChrtVO = new SmstrChrtVO();
        smstrChrtVO.setOrgId(userCtx.getOrgId());
        smstrChrtVO = semesterService.selectCurrentSemester(smstrChrtVO);
        model.addAttribute("defaultYear", smstrChrtVO.getDgrsYr());
        model.addAttribute("defaultTerm", smstrChrtVO.getDgrsSmstrChrt());

        // 조회필터옵션 세팅
        EgovMap filterOptions = lctrPlandocFacadeService.loadFilterOptions(userCtx);
        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("plandocVO", lctrPlandocVO);
        model.addAttribute("plandocModifyPeriodYn", getPlandocTaskPeriodYn(userCtx, LCTR_PLANDOC_MOD_PRD));

        return "lecture/plandoc/prof_lctr_plandoc_list_view";
    }

    /**
     * 교수 강의계획서 목록 AJAX
     *
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profLctrPlandocListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profLctrPlandocListAjax(LctrPlandocVO vo, @CurrentUser UserContext userCtx,
                                                            ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        vo.setUserId(userCtx.getUserId());
        resultVO = lctrPlandocService.lctrPlandocListPaging(vo);
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }


    /**
     * 교수 강의계획서 수정 화면
     *
     * @param lctrPlandocVO
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profLctrPlandocModifyView.do")
    public String profLctrPlandocModifyView(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx,
                                            HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        LctrPlandocView lpv = lctrPlandocFacadeService.loadLctrPlandocModifyView(lctrPlandocVO, userCtx);

        model.addAttribute("subjectInfo", lpv.getSubjectInfo());
        model.addAttribute("profInfo", lpv.getProfInfo());
        model.addAttribute("coprofList", lpv.getCoprofList());
        model.addAttribute("tutList", lpv.getTutList());
        model.addAttribute("assiList", lpv.getAssiList());
        model.addAttribute("lctrPlandocInfo", lpv.getLctrPlandocInfo());
        model.addAttribute("mrkEvlInfo", lpv.getMrkEvlInfo());
        model.addAttribute("txtbkList", lpv.getTxtbkList());
        model.addAttribute("lectureScheduleList", lpv.getLectureScheduleList());
        model.addAttribute("mrkItmStngList", lpv.getMrkItmStngList());
        model.addAttribute("lctrTycdList", lpv.getCmmnCdList().get("lctrTycdList"));
        model.addAttribute("txtbkGbncdList", lpv.getCmmnCdList().get("txtbkGbncdList"));
        model.addAttribute("noteFileList", lpv.getNoteFileList());
        model.addAttribute("voiceFileList", lpv.getVoiceFileList());
        model.addAttribute("trainingFileList", lpv.getTrainingFileList());
        model.addAttribute("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_PLANDOC));


        return "lecture/plandoc/prof_lctr_plandoc_modify_view";
    }

    /**
     * 교수 강의계획서 수정 AJAX
     *
     * @param lctrPlandocVO
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profLctrPlandocModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<LctrPlandocVO> profLctrPlandocModifyAjax(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx,
                                                                    HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        ProcessResultVO<LctrPlandocVO> resultVO = new ProcessResultVO<LctrPlandocVO>();

        resultVO.setReturnVO(lctrPlandocService.lctrPlandocModify(lctrPlandocVO, userCtx));
        resultVO.setEncParams(getEncParams());
        resultVO.setResultSuccess();


        return resultVO;
    }

    /**
     * 관리자 강의계획서 목록 화면
     *
     * @param lctrPlandocVO
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admLctrPlandocListView.do")
    public String admLctrPlandocListView(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx,
                                         HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        SmstrChrtVO smstrChrtVO = new SmstrChrtVO();
        smstrChrtVO.setOrgId(userCtx.getOrgId());
        smstrChrtVO = semesterService.selectCurrentSemester(smstrChrtVO);
        model.addAttribute("defaultYear", smstrChrtVO.getDgrsYr());
        model.addAttribute("defaultTerm", smstrChrtVO.getDgrsSmstrChrt());
        model.addAttribute("defaultOrgId", userCtx.getOrgId());

        EgovMap filterOptions = lctrPlandocFacadeService.loadAdmFilterOptions(userCtx);
        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("plandocVO", lctrPlandocVO);
        model.addAttribute("plandocRegistPeriodYn", getPlandocTaskPeriodYn(userCtx, LCTR_PLANDOC_ENRL_PRD));
        model.addAttribute("plandocModifyPeriodYn", getPlandocTaskPeriodYn(userCtx, LCTR_PLANDOC_MOD_PRD));

        return "lecture/plandoc/adm_lctr_plandoc_list_view";
    }

    /**
     * 관리자 강의계획서 목록 AJAX
     *
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admLctrPlandocListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> admLctrPlandocListAjax(LctrPlandocVO vo, @CurrentUser UserContext userCtx,
                                                           ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = lctrPlandocService.admLctrPlandocListPaging(vo);
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 관리자 강의계획서 등록 화면
     */
    @RequestMapping(value="/admLctrPlandocRegistView.do")
    public String admLctrPlandocRegistView(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx,
                                           HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        lctrPlandocVO.setGubun("regist");
        LctrPlandocView lpv = lctrPlandocFacadeService.loadAdmLctrPlandocWriteView(lctrPlandocVO, userCtx);
        setAdmLctrPlandocWriteModel(model, request, lpv, "regist");

        return "lecture/plandoc/adm_lctr_plandoc_write_view";
    }

    /**
     * 관리자 강의계획서 수정 화면
     *
     * @param lctrPlandocVO
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admLctrPlandocModifyView.do")
    public String admLctrPlandocModifyView(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx,
                                           HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        lctrPlandocVO.setGubun("modify");
        LctrPlandocView lpv = lctrPlandocFacadeService.loadAdmLctrPlandocWriteView(lctrPlandocVO, userCtx);
        setAdmLctrPlandocWriteModel(model, request, lpv, "modify");

        return "lecture/plandoc/adm_lctr_plandoc_write_view";
    }

    private void setAdmLctrPlandocWriteModel(ModelMap model, HttpServletRequest request, LctrPlandocView lpv, String writeMode) throws Exception {
        model.addAttribute("writeMode", writeMode);
        model.addAttribute("subjectInfo", lpv.getSubjectInfo());
        model.addAttribute("profInfo", lpv.getProfInfo());
        model.addAttribute("coprofList", lpv.getCoprofList());
        model.addAttribute("tutList", lpv.getTutList());
        model.addAttribute("assiList", lpv.getAssiList());
        model.addAttribute("lctrPlandocInfo", lpv.getLctrPlandocInfo());
        model.addAttribute("mrkEvlInfo", lpv.getMrkEvlInfo());
        model.addAttribute("txtbkList", lpv.getTxtbkList());
        model.addAttribute("lectureScheduleList", lpv.getLectureScheduleList());
        model.addAttribute("mrkItmStngList", lpv.getMrkItmStngList());
        model.addAttribute("rltmExamList", lpv.getRltmExamList());
        model.addAttribute("examQstnsTrgtrList", lpv.getExamQstnsTrgtrList());
        model.addAttribute("lctrTycdList", lpv.getCmmnCdList().get("lctrTycdList"));
        model.addAttribute("txtbkGbncdList", lpv.getCmmnCdList().get("txtbkGbncdList"));
        model.addAttribute("examTycdList", lpv.getCmmnCdList().get("examTycdList"));
        model.addAttribute("rltmTkexamGbncdList", lpv.getCmmnCdList().get("rltmTkexamGbncdList"));
        model.addAttribute("openOptnGbncdList", lpv.getCmmnCdList().get("openOptnGbncdList"));
        model.addAttribute("noteFileList", lpv.getNoteFileList());
        model.addAttribute("voiceFileList", lpv.getVoiceFileList());
        model.addAttribute("trainingFileList", lpv.getTrainingFileList());
        model.addAttribute("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_PLANDOC));
    }

    /**
     * 관리자 강의계획서 등록 AJAX
     *
     * @param lctrPlandocVO
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admLctrPlandocRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<LctrPlandocVO> admLctrPlandocRegistAjax(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx,
                                                                   HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<LctrPlandocVO> resultVO = new ProcessResultVO<LctrPlandocVO>();

        resultVO.setReturnVO(lctrPlandocService.admLctrPlandocRegist(lctrPlandocVO, userCtx));
        resultVO.setEncParams(getEncParams());
        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * 관리자 강의계획서 수정 AJAX
     *
     * @param lctrPlandocVO
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/admLctrPlandocModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<LctrPlandocVO> admLctrPlandocModifyAjax(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx,
                                                                   HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<LctrPlandocVO> resultVO = new ProcessResultVO<LctrPlandocVO>();

        resultVO.setReturnVO(lctrPlandocService.admLctrPlandocModify(lctrPlandocVO, userCtx));
        resultVO.setEncParams(getEncParams());
        resultVO.setResultSuccess();

        return resultVO;
    }

    @RequestMapping(value="/admLctrPlandocDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<LctrPlandocVO> admLctrPlandocDeleteAjax(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx,
                                                                   HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<LctrPlandocVO> resultVO = new ProcessResultVO<LctrPlandocVO>();

        // 삭제는 등록기간 또는 수정기간 중 하나라도 열려 있을 때만 허용한다.
        boolean registPeriod = "Y".equals(getPlandocTaskPeriodYn(userCtx, LCTR_PLANDOC_ENRL_PRD));
        boolean modifyPeriod = "Y".equals(getPlandocTaskPeriodYn(userCtx, LCTR_PLANDOC_MOD_PRD));
        if(!registPeriod && !modifyPeriod) {
            resultVO.setEncParams(getEncParams());
            return resultVO.setResultFailed("강의계획서 등록/수정기간이 아닙니다.");
        }

        int deleteCnt = lctrPlandocService.admLctrPlandocDelete(lctrPlandocVO);
        resultVO.setEncParams(getEncParams());
        if(deleteCnt > 0) {
            return resultVO.setResultSuccess("삭제되었습니다.");
        }
        return resultVO.setResultFailed("삭제할 강의계획서가 없습니다.");
    }

    private String getPlandocTaskPeriodYn(UserContext userCtx, String taskSchdlTycd) {
        OrgTaskScheduleVO schdlVO = calendarService.orgTaskSchdlSelect(userCtx.getOrgId(), taskSchdlTycd);
        return schdlVO == null ? "N" : schdlVO.getTaskPeriodYn();
    }

    /**
     * 교수 강의계획서 상세팝업
     *
     * @param lctrPlandocVO
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RequestMapping(value={"/profLctrPlandocPopView.do", "/profLctrPlandocView.do", "/admLctrPlandocPopView.do"})
    public String profLctrPlandocView(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx,
                                      HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        LctrPlandocView lpv = lctrPlandocFacadeService.loadLctrPlandocView(lctrPlandocVO, userCtx);

        model.addAttribute("subjectInfo", lpv.getSubjectInfo());
        model.addAttribute("profInfo", lpv.getProfInfo());
        model.addAttribute("coprofList", lpv.getCoprofList());
        model.addAttribute("tutList", lpv.getTutList());
        model.addAttribute("assiList", lpv.getAssiList());
        model.addAttribute("lctrPlandocInfo", lpv.getLctrPlandocInfo());
        model.addAttribute("mrkEvlInfo", lpv.getMrkEvlInfo());
        model.addAttribute("txtbkList", lpv.getTxtbkList());
        model.addAttribute("lectureScheduleList", lpv.getLectureScheduleList());
        model.addAttribute("mrkItmStngList", lpv.getMrkItmStngList());
        model.addAttribute("noteFileList", lpv.getNoteFileList());
        model.addAttribute("voiceFileList", lpv.getVoiceFileList());
        model.addAttribute("trainingFileList", lpv.getTrainingFileList());
        model.addAttribute("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_PLANDOC));

        String servletPath = request.getServletPath(); // 요청 URL

        model.addAttribute("plandocModifyPeriodYn", getPlandocTaskPeriodYn(userCtx, LCTR_PLANDOC_MOD_PRD));

        if("/lctr/plandoc/profLctrPlandocPopView.do".equals(servletPath)) {
            return "lecture/plandoc/prof_lctr_plandoc_pop_view";

        } else if("/lctr/plandoc/profLctrPlandocView.do".equals(servletPath)) {
            return "lecture/plandoc/prof_lctr_plandoc_view";

        } else if("/lctr/plandoc/admLctrPlandocPopView.do".equals(servletPath)) {
            return "lecture/plandoc/adm_lctr_plandoc_pop_view";
        } else {
            return "common/error";
        }
    }

    /**
     * 학생 강의계획서 목록 화면
     *
     * @param lctrPlandocVO
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RequestMapping(value="/stdntLctrPlandocListView.do")
    public String stdntLctrPlandocListView(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx,
                                           HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        SmstrChrtVO smstrChrtVO = new SmstrChrtVO();
        smstrChrtVO.setOrgId(userCtx.getOrgId());
        smstrChrtVO = semesterService.selectCurrentSemester(smstrChrtVO);
        model.addAttribute("defaultYear", smstrChrtVO.getDgrsYr());
        model.addAttribute("defaultTerm", smstrChrtVO.getDgrsSmstrChrt());

        // 조회필터옵션 세팅
        EgovMap filterOptions = lctrPlandocFacadeService.loadFilterOptions(userCtx);
        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("plandocVO", lctrPlandocVO);

        return "lecture/plandoc/stdnt_lctr_plandoc_list_view";
    }

    /**
     * 학생 강의계획서 목록 AJAX
     *
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/stdntLctrPlandocListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> stdntLctrPlandocListAjax(LctrPlandocVO vo, @CurrentUser UserContext userCtx,
                                                             ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        vo.setUserId(userCtx.getUserId());
        resultVO = lctrPlandocService.stdntLctrPlandocListPaging(vo);
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /**
     * 학생 강의계획서 상세
     *
     * @param lctrPlandocVO
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RequestMapping(value="/stdntLctrPlandocView.do")
    public String stdntLctrPlandocView(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx,
                                       HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        LctrPlandocView lpv = lctrPlandocFacadeService.loadLctrPlandocView(lctrPlandocVO, userCtx);

        model.addAttribute("subjectInfo", lpv.getSubjectInfo());
        model.addAttribute("profInfo", lpv.getProfInfo());
        model.addAttribute("coprofList", lpv.getCoprofList());
        model.addAttribute("tutList", lpv.getTutList());
        model.addAttribute("assiList", lpv.getAssiList());
        model.addAttribute("lctrPlandocInfo", lpv.getLctrPlandocInfo());
        model.addAttribute("mrkEvlInfo", lpv.getMrkEvlInfo());
        model.addAttribute("txtbkList", lpv.getTxtbkList());
        model.addAttribute("lectureScheduleList", lpv.getLectureScheduleList());
        model.addAttribute("mrkItmStngList", lpv.getMrkItmStngList());
        model.addAttribute("noteFileList", lpv.getNoteFileList());
        model.addAttribute("voiceFileList", lpv.getVoiceFileList());
        model.addAttribute("trainingFileList", lpv.getTrainingFileList());
        model.addAttribute("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_PLANDOC));

        return "lecture/plandoc/stdnt_lctr_plandoc_view";

    }

    @RequestMapping(value="/admLctrPlandocView.do")
    public String admLctrPlandocView(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx,
                                     HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        LctrPlandocView lpv = lctrPlandocFacadeService.loadAdmLctrPlandocView(lctrPlandocVO, userCtx);

        model.addAttribute("subjectInfo", lpv.getSubjectInfo());
        model.addAttribute("profInfo", lpv.getProfInfo());
        model.addAttribute("coprofList", lpv.getCoprofList());
        model.addAttribute("tutList", lpv.getTutList());
        model.addAttribute("assiList", lpv.getAssiList());
        model.addAttribute("lctrPlandocInfo", lpv.getLctrPlandocInfo());
        model.addAttribute("mrkEvlInfo", lpv.getMrkEvlInfo());
        model.addAttribute("txtbkList", lpv.getTxtbkList());
        model.addAttribute("lectureScheduleList", lpv.getLectureScheduleList());
        model.addAttribute("mrkItmStngList", lpv.getMrkItmStngList());
        model.addAttribute("rltmExamList", lpv.getRltmExamList());
        model.addAttribute("examQstnsTrgtrList", lpv.getExamQstnsTrgtrList());
        if(lpv.getCmmnCdList() != null) {
            model.addAttribute("examTycdList", lpv.getCmmnCdList().get("examTycdList"));
            model.addAttribute("rltmTkexamGbncdList", lpv.getCmmnCdList().get("rltmTkexamGbncdList"));
            model.addAttribute("openOptnGbncdList", lpv.getCmmnCdList().get("openOptnGbncdList"));
        }
        model.addAttribute("noteFileList", lpv.getNoteFileList());
        model.addAttribute("voiceFileList", lpv.getVoiceFileList());
        model.addAttribute("trainingFileList", lpv.getTrainingFileList());
        model.addAttribute("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_PLANDOC));


        model.addAttribute("plandocModifyPeriodYn", getPlandocTaskPeriodYn(userCtx, LCTR_PLANDOC_MOD_PRD));
        model.addAttribute("plandocRegistPeriodYn", getPlandocTaskPeriodYn(userCtx, LCTR_PLANDOC_ENRL_PRD));

        return "lecture/plandoc/adm_lctr_plandoc_view";

    }

    /**
     * 과목 목록 AJAX
     *
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/sbjctListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> sbjctListAjax(LctrPlandocVO vo, @CurrentUser UserContext userCtx,
                                                  ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        vo.setUserId(userCtx.getUserId());

        resultVO.setReturnList(lctrPlandocService.sbjctList(vo, userCtx));
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

}
