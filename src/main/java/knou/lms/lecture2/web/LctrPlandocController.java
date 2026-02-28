package knou.lms.lecture2.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.lecture2.facade.LctrPlandocFacadeService;
import knou.lms.lecture2.service.LctrPlandocService;
import knou.lms.lecture2.vo.LctrPlandocVO;
import knou.lms.lecture2.vo.LctrPlandocView;
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
@RequestMapping("/lctr/plandoc")
public class LctrPlandocController extends ControllerBase {
    private static final Logger LOGGER = LoggerFactory.getLogger(LctrPlandocController.class);

    @Resource(name="lctrPlandocService")
    private LctrPlandocService lctrPlandocService;

    @Resource(name="lctrPlandocFacadeService")
    private LctrPlandocFacadeService lctrPlandocFacadeService;

    /**
     * 교수 강의계획서 목록 화면
     *
     * @param lctrPlandocVO
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RequestMapping("/profLctrPlandocListView.do")
    public String profLctrPlandocListView(LctrPlandocVO lctrPlandocVO, HttpServletRequest request, HttpServletResponse response, ModelMap model) {

        model.addAttribute("plandocVO", lctrPlandocVO);
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
    public ProcessResultVO<EgovMap> profLctrPlandocListAjax(LctrPlandocVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        vo.setUserId(SessionInfo.getUserId(request));
        try {
            resultVO = lctrPlandocService.lctrPlandocListPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /**
     * 교수 강의계획서 상세 화면
     *
     * @param lctrPlandocVO
     * @param request
     * @param response
     * @param model
     * @return
     */
    @RequestMapping("/profLctrPlandocView.do")
    public String profLctrPlandocView(LctrPlandocVO lctrPlandocVO, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        UserContext userCtx = new UserContext(SessionInfo.getOrgId(request),
                SessionInfo.getUserId(request),
                SessionInfo.getUserTycd(request),
                SessionInfo.getAuthrtCd(request),
                SessionInfo.getAuthrtGrpcd(request),
                SessionInfo.getUserRprsId(request),
                SessionInfo.getLastLogin(request));

        LctrPlandocView lpv = lctrPlandocFacadeService.loadLctrPlandocView(userCtx, lctrPlandocVO);

        model.addAttribute("subjectInfo", lpv.getSubjectInfo());
        model.addAttribute("profInfo", lpv.getProfInfo());
        model.addAttribute("coprofList", lpv.getCoprofList());
        model.addAttribute("tutList", lpv.getTutList());
        model.addAttribute("AssiList", lpv.getAssiList());
        model.addAttribute("lctrPlandocInfo", lpv.getLctrPlandocInfo());
        model.addAttribute("mrkEvlInfo", lpv.getMrkEvlInfo());
        model.addAttribute("txtbkList", lpv.getTxtbkList());
        model.addAttribute("lectureScheduleList", lpv.getLectureScheduleList());
        model.addAttribute("mrkItmStngList", lpv.getMrkItmStngList());

        return "lecture/plandoc/prof_lctr_plandoc_view";
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
    @RequestMapping("/profLctrPlandocModifyView.do")
    public String profLctrPlandocModifyView(LctrPlandocVO lctrPlandocVO, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        UserContext userCtx = new UserContext(SessionInfo.getOrgId(request),
                SessionInfo.getUserId(request),
                SessionInfo.getUserTycd(request),
                SessionInfo.getAuthrtCd(request),
                SessionInfo.getAuthrtGrpcd(request),
                SessionInfo.getUserRprsId(request),
                SessionInfo.getLastLogin(request));

        LctrPlandocView lpv = lctrPlandocFacadeService.loadLctrPlandocModifyView(userCtx, lctrPlandocVO);

        model.addAttribute("subjectInfo", lpv.getSubjectInfo());
        model.addAttribute("profInfo", lpv.getProfInfo());
        model.addAttribute("coprofList", lpv.getCoprofList());
        model.addAttribute("tutList", lpv.getTutList());
        model.addAttribute("AssiList", lpv.getAssiList());
        model.addAttribute("lctrPlandocInfo", lpv.getLctrPlandocInfo());
        model.addAttribute("mrkEvlInfo", lpv.getMrkEvlInfo());
        model.addAttribute("txtbkList", lpv.getTxtbkList());
        model.addAttribute("lectureScheduleList", lpv.getLectureScheduleList());
        model.addAttribute("mrkItmStngList", lpv.getMrkItmStngList());
        model.addAttribute("lctrTycdList", lpv.getCmmnCdList().get("lctrTycdList"));
        model.addAttribute("txtbkGbncdList", lpv.getCmmnCdList().get("txtbkGbncdList"));


        return "lecture/plandoc/prof_lctr_plandoc_modify_view";
    }

    @RequestMapping("/profLctrPlandocModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<LctrPlandocVO> profLctrPlandocModifyAjax(LctrPlandocVO lctrPlandocVO, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        UserContext userCtx = new UserContext(SessionInfo.getOrgId(request),
                SessionInfo.getUserId(request),
                SessionInfo.getUserTycd(request),
                SessionInfo.getAuthrtCd(request),
                SessionInfo.getAuthrtGrpcd(request),
                SessionInfo.getUserRprsId(request),
                SessionInfo.getLastLogin(request));

        ProcessResultVO<LctrPlandocVO> resultVO = new ProcessResultVO<LctrPlandocVO>();

        try {
            resultVO.setReturnVO(lctrPlandocService.lctrPlandocModify(userCtx, lctrPlandocVO));
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

}
