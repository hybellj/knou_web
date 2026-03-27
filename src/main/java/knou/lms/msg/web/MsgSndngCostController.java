package knou.lms.msg.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.MsgSndngCostService;
import knou.lms.msg.vo.MsgSndngCostVO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@Controller
public class MsgSndngCostController extends ControllerBase {

    @Resource(name = "msgSndngCostService")
    private MsgSndngCostService msgSndngCostService;

    private boolean isAdmin(HttpServletRequest request) {
        return StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request)).contains("ADM");
    }

    /*****************************************************
     * 관리자 발송단가관리 화면
     * @param model
     * @param request
     * @return "msg2/mngr_msg_sndng_cost_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/mngrMsgSndngCostListView.do")
    public String mngrMsgSndngCostListView(ModelMap model, HttpServletRequest request) throws Exception {
        if (!isAdmin(request)) {
            model.addAttribute("message", getCommonNoAuthMessage());
            return "common/error";
        }

        return "msg2/mngr_msg_sndng_cost_list_view";
    }

    /*****************************************************
     * 발송단가 목록 AJAX 조회
     * @param vo
     * @param request
     * @return ProcessResultVO<MsgSndngCostVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgSndngCostListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndngCostVO> msgSndngCostListAjax(MsgSndngCostVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndngCostVO> resultVO = new ProcessResultVO<>();

        try {
            if (!isAdmin(request)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            resultVO.setReturnList(msgSndngCostService.selectSndngCostList());
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 발송단가 등록 AJAX
     * @param vo
     * @param request
     * @return ProcessResultVO<MsgSndngCostVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgSndngCostRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndngCostVO> msgSndngCostRegistAjax(MsgSndngCostVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndngCostVO> resultVO = new ProcessResultVO<>();

        try {
            if (!isAdmin(request)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setRgtrId(SessionInfo.getUserId(request));
            msgSndngCostService.insertSndngCost(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.insert"));
        }

        return resultVO;
    }

    /*****************************************************
     * 발송단가 수정 AJAX
     * @param vo
     * @param request
     * @return ProcessResultVO<MsgSndngCostVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgSndngCostModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgSndngCostVO> msgSndngCostModifyAjax(MsgSndngCostVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgSndngCostVO> resultVO = new ProcessResultVO<>();

        try {
            if (!isAdmin(request)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setMdfrId(SessionInfo.getUserId(request));
            msgSndngCostService.updateSndngCost(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.update"));
        }

        return resultVO;
    }
}
