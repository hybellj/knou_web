package knou.lms.msg.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.MsgAlimService;
import knou.lms.msg.vo.MsgAlimVO;

@Controller
public class MsgAlimController extends ControllerBase {

    @Resource(name = "msgAlimService")
    private MsgAlimService msgAlimService;

    private static final int LIST_CNT = 5;

    private static final String CHNL_SHRTNT = "SHRTNT";

    /*****************************************************
     * 읽지 않은 알림 개수 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping("/alimUnrdCntSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> alimUnrdCntSelectAjax(MsgAlimVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            if ("".equals(StringUtil.nvl(vo.getUserId()))) {
                vo.setUserId(SessionInfo.getUserId(request));
            }
            if ("".equals(StringUtil.nvl(vo.getUserId()))) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getMessage("system.fail.login.msg"));
                return resultVO;
            }

            EgovMap unreadCnt = msgAlimService.selectAlimUnrdCnt(vo);

            resultVO.setReturnVO(unreadCnt);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 채널별 알림 목록 조회
     * @param vo
     * @param model
     * @param request
     * @param chnlCd
     * @return ProcessResultVO<Map<String, Object>>
     * @throws Exception
     ******************************************************/
    @RequestMapping("/alimChnlListAjax.do")
    @ResponseBody
    public ProcessResultVO<Map<String, Object>> alimChnlListAjax(
            MsgAlimVO vo, ModelMap model, HttpServletRequest request,
            @RequestParam(value = "chnlCd") String chnlCd) throws Exception {

        ProcessResultVO<Map<String, Object>> resultVO = new ProcessResultVO<>();

        try {
            if ("".equals(StringUtil.nvl(vo.getUserId()))) {
                vo.setUserId(SessionInfo.getUserId(request));
            }
            if ("".equals(StringUtil.nvl(vo.getUserId()))) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getMessage("system.fail.login.msg"));
                return resultVO;
            }

            vo.setListCnt(LIST_CNT);

            Map<String, Object> data = new HashMap<>();

            if (CHNL_SHRTNT.equals(chnlCd)) {
                data.put("list", msgAlimService.selectShrtntList(vo));
            } else {
                vo.setMblSndngTycd(chnlCd);
                data.put("list", msgAlimService.selectMblSndngList(vo));
            }

            resultVO.setReturnVO(data);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }
}
