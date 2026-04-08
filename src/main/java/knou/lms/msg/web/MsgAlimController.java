package knou.lms.msg.web;

import java.util.HashMap;
import java.util.Arrays;
import java.util.Map;

import knou.framework.common.CommConst;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.MsgAlimService;
import knou.lms.msg.vo.MsgAlimVO;
import knou.lms.user.CurrentUser;

@Controller
public class MsgAlimController extends ControllerBase {

    @Resource(name = "msgAlimService")
    private MsgAlimService msgAlimService;

    private static final int LIST_CNT = 5;

    private static final String CHNL_SHRTNT = CommConst.MSG_CHNL_SHRTNT;

    /*****************************************************
     * 읽지 않은 알림 개수 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping("/alimUnrdCntSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> alimUnrdCntSelectAjax(MsgAlimVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            if (userCtx == null) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getMessage("system.fail.login.msg"));
                return resultVO;
            }

            vo.setUserId(userCtx.getUserId());

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
     * @param userCtx
     * @param chnlCd
     * @return ProcessResultVO<Map<String, Object>>
     * @throws Exception
     ******************************************************/
    @RequestMapping("/alimChnlListAjax.do")
    @ResponseBody
    public ProcessResultVO<Map<String, Object>> alimChnlListAjax(
            MsgAlimVO vo, @CurrentUser UserContext userCtx,
            @RequestParam(value = "chnlCd") String chnlCd) throws Exception {

        ProcessResultVO<Map<String, Object>> resultVO = new ProcessResultVO<>();

        try {
            if (userCtx == null) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getMessage("system.fail.login.msg"));
                return resultVO;
            }

            if (!Arrays.asList(CommConst.MSG_VALID_CHNL_CDS).contains(chnlCd)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonFailMessage());
                return resultVO;
            }

            vo.setUserId(userCtx.getUserId());
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
