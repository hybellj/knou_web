package knou.lms.msg.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;
import knou.lms.msg.service.MsgAlimService;
import knou.lms.msg.vo.MsgAlimVO;
import knou.lms.common.vo.ProcessResultVO;

@Controller
public class MsgAlimController extends ControllerBase {

    @Resource(name = "msgAlimService")
    private MsgAlimService msgAlimService;

    private static final int LIST_CNT = 5;

    /**
     * 읽지 않은 알림 개수 조회
     * @param request
     * @return
     */
    @RequestMapping("/alimUnrdCntSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> alimUnrdCntSelectAjax(HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            if ("".equals(userId)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getMessage("system.fail.login.msg"));
                return resultVO;
            }

            MsgAlimVO msgAlimVO = new MsgAlimVO();
            msgAlimVO.setUserId(userId);

            EgovMap unreadCnt = msgAlimService.selectAlimUnrdCnt(msgAlimVO);

            resultVO.setReturnVO(unreadCnt);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 채널별 알림 목록 조회
     * @param request
     * @param chnlCd
     * @return
     */
    @RequestMapping("/alimChnlListAjax.do")
    @ResponseBody
    public ProcessResultVO<Map<String, Object>> alimChnlListAjax(
            HttpServletRequest request,
            @RequestParam(value = "chnlCd", defaultValue = "ALL") String chnlCd) throws Exception {

        ProcessResultVO<Map<String, Object>> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            if ("".equals(userId)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getMessage("system.fail.login.msg"));
                return resultVO;
            }

            MsgAlimVO msgAlimVO = new MsgAlimVO();
            msgAlimVO.setUserId(userId);
            msgAlimVO.setListCnt(LIST_CNT);

            Map<String, Object> data = msgAlimService.selectAlimChnlData(msgAlimVO, chnlCd);

            resultVO.setReturnVO(data);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }
}
