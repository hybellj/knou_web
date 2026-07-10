package knou.lms.msg.web;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.MsgSndngCostService;
import knou.lms.msg.vo.MsgSndngCostVO;
import knou.lms.user.CurrentUser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

@Controller
public class MsgSndngCostController extends ControllerBase {

    @Resource(name = "msgSndngCostService")
    private MsgSndngCostService msgSndngCostService;

    /*****************************************************
     * 관리자 발송단가관리 화면
     * @param vo
     * @param model
     * @return "msg/adm_msg_sndng_cost_list_view"
     ******************************************************/
    @RequestMapping(value = "/admMsgSndngCostListView.do")
    public String admMsgSndngCostListView(MsgSndngCostVO vo, ModelMap model) {
        model.addAttribute("vo", vo);
        model.addAttribute("encParams", getEncParams());

        return "msg/adm_msg_sndng_cost_list_view";
    }

    /*****************************************************
     * 발송단가 목록 AJAX 조회
     * @param vo
     * @return ProcessResultVO<MsgSndngCostVO>
     ******************************************************/
    @RequestMapping(value = "/admMsgSndngCostListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndngCostVO> msgSndngCostListAjax(MsgSndngCostVO vo) {
        ProcessResultVO<MsgSndngCostVO> resultVO = new ProcessResultVO<>();

        resultVO.setReturnList(msgSndngCostService.selectSndngCostList());
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 발송단가 등록 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgSndngCostVO>
     ******************************************************/
    @RequestMapping(value = "/admMsgSndngCostRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndngCostVO> msgSndngCostRegistAjax(MsgSndngCostVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgSndngCostVO> resultVO = new ProcessResultVO<>();

        vo.setRgtrId(userCtx.getUserId());
        msgSndngCostService.insertSndngCost(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 발송단가 수정 AJAX
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgSndngCostVO>
     ******************************************************/
    @RequestMapping(value = "/admMsgSndngCostModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndngCostVO> msgSndngCostModifyAjax(MsgSndngCostVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgSndngCostVO> resultVO = new ProcessResultVO<>();

        vo.setMdfrId(userCtx.getUserId());
        msgSndngCostService.updateSndngCost(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }
}
