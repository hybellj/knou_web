package knou.lms.msg.web;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.facade.AutoAlimMsgFacadeService;
import knou.lms.msg.vo.AutoAlimMsgVO;
import knou.lms.user.CurrentUser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

@Controller
public class AutoAlimMsgController extends ControllerBase {

    @Resource(name = "autoAlimMsgFacadeService")
    private AutoAlimMsgFacadeService autoAlimMsgFacadeService;

    /*****************************************************
     * 관리자 자동알림 안내문구 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_auto_alim_msg_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admAutoAlimMsgListView.do")
    public String admAutoAlimMsgListView(AutoAlimMsgVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {

        model.addAttribute("vo", vo);
        model.addAttribute("orgList", autoAlimMsgFacadeService.selectActiveOrgList());

        return "msg/adm_auto_alim_msg_list_view";
    }

    /*****************************************************
     * 관리자 자동알림 안내문구 등록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_auto_alim_msg_regist_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admAutoAlimMsgRegistView.do")
    public String admAutoAlimMsgRegistView(AutoAlimMsgVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {

        model.addAttribute("vo", vo);
        model.addAttribute("orgList", autoAlimMsgFacadeService.selectActiveOrgList());

        return "msg/adm_auto_alim_msg_regist_view";
    }

    /*****************************************************
     * 관리자 자동알림 안내문구 수정 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_auto_alim_msg_modify_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admAutoAlimMsgSelectView.do")
    public String admAutoAlimMsgSelectView(AutoAlimMsgVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {

        AutoAlimMsgVO resultVo = autoAlimMsgFacadeService.selectAutoAlimMsgWithTrgt(vo);

        model.addAttribute("vo", vo);
        model.addAttribute("detailVo", resultVo);
        model.addAttribute("orgList", autoAlimMsgFacadeService.selectActiveOrgList());

        return "msg/adm_auto_alim_msg_modify_view";
    }

    /*****************************************************
     * 자동알림 안내문구 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<AutoAlimMsgVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/autoAlimMsgListAjax.do", "/admAutoAlimMsgListAjax.do"})
    @ResponseBody
    public ProcessResultVO<AutoAlimMsgVO> autoAlimMsgListAjax(AutoAlimMsgVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<AutoAlimMsgVO> resultVO = new ProcessResultVO<>();

        resultVO = autoAlimMsgFacadeService.selectAutoAlimMsgListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 자동알림 안내문구 등록 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<AutoAlimMsgVO>
     ******************************************************/
    @RequestMapping({"/autoAlimMsgRegistAjax.do", "/admAutoAlimMsgRegistAjax.do"})
    @ResponseBody
    public ProcessResultVO<AutoAlimMsgVO> autoAlimMsgRegistAjax(AutoAlimMsgVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<AutoAlimMsgVO> resultVO = new ProcessResultVO<>();

        vo.setRgtrId(userCtx.getUserId());
        autoAlimMsgFacadeService.registAutoAlimMsg(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 자동알림 안내문구 수정 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<AutoAlimMsgVO>
     ******************************************************/
    @RequestMapping({"/autoAlimMsgModifyAjax.do", "/admAutoAlimMsgModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<AutoAlimMsgVO> autoAlimMsgModifyAjax(AutoAlimMsgVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<AutoAlimMsgVO> resultVO = new ProcessResultVO<>();

        vo.setMdfrId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        autoAlimMsgFacadeService.modifyAutoAlimMsg(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 자동알림 안내문구 삭제 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<AutoAlimMsgVO>
     ******************************************************/
    @RequestMapping({"/autoAlimMsgDeleteAjax.do", "/admAutoAlimMsgDeleteAjax.do"})
    @ResponseBody
    public ProcessResultVO<AutoAlimMsgVO> autoAlimMsgDeleteAjax(AutoAlimMsgVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<AutoAlimMsgVO> resultVO = new ProcessResultVO<>();

        autoAlimMsgFacadeService.deleteAutoAlimMsg(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }
}
