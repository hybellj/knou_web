package knou.lms.msg.web;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.MsgMgrService;
import knou.lms.msg.vo.MsgMgrVO;
import knou.lms.msg.web.util.MsgAuthUtil;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.CurrentUser;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

@Controller
public class MsgMgrController extends ControllerBase {

    @Resource(name = "msgMgrService")
    private MsgMgrService msgMgrService;

    /*****************************************************
     * 전체시스템관리자 권한 조회
     * @param userCtx
     * @return boolean
     ******************************************************/
    private boolean isAdminUser(UserContext userCtx) {
        return CommConst.AUTHRT_CD_ADM.equals(StringUtil.nvl(userCtx.getAuthrtCd()));
    }

    /*****************************************************
     * 기관 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgMgrOrgListAjax.do", "/admMsgMgrOrgListAjax.do"})
    @ResponseBody
    public ProcessResultVO<OrgInfoVO> msgMgrOrgListAjax(MsgMgrVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<OrgInfoVO> resultVO = new ProcessResultVO<>();

        List<OrgInfoVO> list = isAdminUser(userCtx)
                ? msgMgrService.selectActiveOrgListByAuth(userCtx.getUserId(), true)
                : msgMgrService.selectProfSbjctOrgList(userCtx.getUserId());
        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 학사년도 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgMgrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgMgrYrListAjax.do", "/admMsgMgrYrListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgMgrVO> msgMgrYrListAjax(MsgMgrVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgMgrVO> resultVO = new ProcessResultVO<>();

        if (!MsgAuthUtil.isAdmin(userCtx)) {
            vo.setUserId(userCtx.getUserId());
        }

        List<MsgMgrVO> list = msgMgrService.selectYrList(vo);
        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 학기 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgMgrSmstrListAjax.do", "/admMsgMgrSmstrListAjax.do"})
    @ResponseBody
    public ProcessResultVO<EgovMap> msgMgrSmstrListAjax(MsgMgrVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        if (!MsgAuthUtil.isAdmin(userCtx)) {
            vo.setUserId(userCtx.getUserId());
        }

        List<EgovMap> list = msgMgrService.selectSmstrList(vo);
        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 운영과목 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgMgrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgMgrSbjctListAjax.do", "/admMsgMgrSbjctListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgMgrVO> msgMgrSbjctListAjax(MsgMgrVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgMgrVO> resultVO = new ProcessResultVO<>();

        if (!MsgAuthUtil.isAdmin(userCtx)) {
            vo.setUserId(userCtx.getUserId());
        }

        List<MsgMgrVO> list = msgMgrService.selectSbjctList(vo);
        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 학생 학사년도 목록 AJAX 조회 (수강과목 기준)
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgMgrVO>
     ******************************************************/
    @RequestMapping("/stdntMsgMgrYrListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgMgrVO> stdntMsgMgrYrListAjax(MsgMgrVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgMgrVO> resultVO = new ProcessResultVO<>();

        vo.setUserId(userCtx.getUserId());
        List<MsgMgrVO> list = msgMgrService.selectStdntYrList(vo);
        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 학생 학기 목록 AJAX 조회 (수강과목 기준)
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<EgovMap>
     ******************************************************/
    @RequestMapping("/stdntMsgMgrSmstrListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> stdntMsgMgrSmstrListAjax(MsgMgrVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        vo.setUserId(userCtx.getUserId());
        List<EgovMap> list = msgMgrService.selectStdntSmstrList(vo);
        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 학생 운영과목 목록 AJAX 조회 (수강과목 기준)
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgMgrVO>
     ******************************************************/
    @RequestMapping("/stdntMsgMgrSbjctListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgMgrVO> stdntMsgMgrSbjctListAjax(MsgMgrVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgMgrVO> resultVO = new ProcessResultVO<>();

        vo.setUserId(userCtx.getUserId());
        List<MsgMgrVO> list = msgMgrService.selectStdntSbjctList(vo);
        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 받는 사람 검색 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgMgrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgMgrRcvrSearchAjax.do", "/admMsgMgrRcvrSearchAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgMgrVO> msgMgrRcvrSearchAjax(MsgMgrVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgMgrVO> resultVO = new ProcessResultVO<>();

        if (!"POPUP".equals(vo.getGubun())) {
            MsgAuthUtil.applyOrgScope(vo, userCtx);
        }
        if (MsgAuthUtil.isAdmin(userCtx)) {
            vo.setAdminYn("Y");
        }
        vo.setSndngrId(userCtx.getUserId());

        resultVO = msgMgrService.selectRcvrSearchListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 받는 사람 검색 팝업 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/modal/msg_rcvr_popview"
     ******************************************************/
    @RequestMapping({"/msgMgrRcvrPopView.do", "/admMsgMgrRcvrPopView.do"})
    public String msgMgrRcvrPopView(MsgMgrVO vo, @CurrentUser UserContext userCtx, ModelMap model) {
        model.addAttribute("orgId", userCtx.getOrgId());
        model.addAttribute("isAdmin", MsgAuthUtil.isAdmin(userCtx));
        model.addAttribute("userTycdList", msgMgrService.selectUserTycdList());
        model.addAttribute("vo", vo);

        return "msg/modal/msg_rcvr_popview";
    }

    /*****************************************************
     * 템플릿에 저장 팝업 화면
     * @param vo
     * @param model
     * @return "msg/modal/msg_tmplt_popview"
     ******************************************************/
    @RequestMapping({"/msgMgrTmpltRegistPopView.do", "/admMsgMgrTmpltRegistPopView.do"})
    public String msgMgrTmpltRegistPopView(MsgMgrVO vo, @CurrentUser UserContext userCtx, ModelMap model) {
        model.addAttribute("isAdmin", MsgAuthUtil.isAdmin(userCtx));
        model.addAttribute("vo", vo);

        return "msg/modal/msg_tmplt_popview";
    }
}
