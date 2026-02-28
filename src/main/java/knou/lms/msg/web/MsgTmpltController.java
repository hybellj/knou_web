package knou.lms.msg.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.MsgTmpltService;
import knou.lms.msg.vo.MsgTmpltVO;

@Controller
@RequestMapping(value = "/msg/tmplt")
public class MsgTmpltController extends ControllerBase {

    @Resource(name = "msgTmpltService")
    private MsgTmpltService msgTmpltService;

    private static final int PAGE_SIZE = 12;
    private static final String ORG_MSG = "ORG_MSG";
    private static final String INDV_MSG = "INDV_MSG";

    private UserContext getUserContext(HttpServletRequest request) {
        return new UserContext(
                SessionInfo.getOrgId(request),
                SessionInfo.getUserId(request),
                SessionInfo.getAuthrtCd(request),
                SessionInfo.getAuthrtGrpcd(request),
                SessionInfo.getUserRprsId(request),
                SessionInfo.getLastLogin(request));
    }

    private boolean isAdmin(UserContext userCtx) {
        return "ADM".equals(userCtx.getAuthrtGrpcd());
    }

    private boolean isValidAuthority(MsgTmpltVO existVo, String userId, boolean isAdmin) {
        if (ORG_MSG.equals(existVo.getMsgCtsGbncd())) {
            return isAdmin;
        }
        return userId.equals(existVo.getRgtrId());
    }

    private void initSearchParam(MsgTmpltVO vo, UserContext userCtx) {
        vo.setOrgId(userCtx.getOrgId());

        if (ORG_MSG.equals(vo.getMsgCtsGbncd())) {
            vo.setRgtrId(null);
        } else {
            vo.setMsgCtsGbncd(INDV_MSG);
            vo.setRgtrId(userCtx.getUserId());
        }
    }

    /**
     * 메시지 템플릿 목록 화면
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgTmpltList.do")
    public String msgTmpltList(MsgTmpltVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        UserContext userCtx = getUserContext(request);

        initSearchParam(vo, userCtx);
        vo.setListScale(PAGE_SIZE);

        ProcessResultVO<MsgTmpltVO> resultVO = msgTmpltService.selectTmpltListPage(vo);

        model.addAttribute("userCtx", userCtx);
        model.addAttribute("vo", vo);
        model.addAttribute("list", resultVO.getReturnList());
        model.addAttribute("totalCnt", resultVO.getPageInfo().getTotalRecordCount());
        model.addAttribute("pageInfo", resultVO.getPageInfo());
        model.addAttribute("pageSize", PAGE_SIZE);
        model.addAttribute("isAdmin", isAdmin(userCtx));

        return "msg/main/msg_tmplt_list";
    }

    /**
     * 메시지 템플릿 추가 목록 조회 (무한스크롤)
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgTmpltListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltListAjax(MsgTmpltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<MsgTmpltVO>();

        try {
            UserContext userCtx = getUserContext(request);

            initSearchParam(vo, userCtx);
            vo.setListScale(PAGE_SIZE);

            resultVO = msgTmpltService.selectTmpltListPage(vo);
            resultVO.setSuccess(resultVO.getPageInfo().getLastRecordIndex() < resultVO.getPageInfo().getTotalRecordCount());
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 메시지 템플릿 상세 조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgTmpltSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltSelectAjax(MsgTmpltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<MsgTmpltVO>();

        try {
            MsgTmpltVO result = msgTmpltService.selectTmplt(vo);
            resultVO.setReturnVO(result);
            resultVO.setResult(result != null ? ProcessResultVO.RESULT_SUCC : ProcessResultVO.RESULT_FAIL);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 메시지 템플릿 등록
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgTmpltRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltRegistAjax(MsgTmpltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<MsgTmpltVO>();

        try {
            UserContext userCtx = getUserContext(request);

            if (ORG_MSG.equals(vo.getMsgCtsGbncd()) && !isAdmin(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setOrgId(userCtx.getOrgId());
            vo.setRgtrId(userCtx.getUserId());

            int cnt = msgTmpltService.registTmplt(vo);
            resultVO.setResult(cnt > 0 ? ProcessResultVO.RESULT_SUCC : ProcessResultVO.RESULT_FAIL);
            resultVO.setReturnVO(vo);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.insert"));
        }

        return resultVO;
    }

    /**
     * 메시지 템플릿 수정
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgTmpltModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltModifyAjax(MsgTmpltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<MsgTmpltVO>();

        try {
            UserContext userCtx = getUserContext(request);
            String userId = userCtx.getUserId();
            boolean admin = isAdmin(userCtx);

            MsgTmpltVO existVo = msgTmpltService.selectTmplt(vo);
            if (existVo == null) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getMessage("common.content.not_found"));
                return resultVO;
            }
            if (!isValidAuthority(existVo, userId, admin)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setMsgCtsGbncd(null);
            vo.setMdfrId(userId);

            int cnt = msgTmpltService.modifyTmplt(vo);
            resultVO.setResult(cnt > 0 ? ProcessResultVO.RESULT_SUCC : ProcessResultVO.RESULT_FAIL);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.update"));
        }

        return resultVO;
    }

    /**
     * 메시지 템플릿 삭제
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgTmpltDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltDeleteAjax(MsgTmpltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<MsgTmpltVO>();

        try {
            UserContext userCtx = getUserContext(request);
            String userId = userCtx.getUserId();
            boolean admin = isAdmin(userCtx);

            String[] ids = vo.getMsgTmpltIds();
            if ((ids == null || ids.length == 0) && vo.getMsgTmpltId() != null) {
                ids = new String[]{vo.getMsgTmpltId()};
            }

            if (ids == null || ids.length == 0) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getMessage("common.item.select.msg"));
                return resultVO;
            }

            for (String id : ids) {
                MsgTmpltVO checkVo = new MsgTmpltVO();
                checkVo.setMsgTmpltId(id);
                MsgTmpltVO existVo = msgTmpltService.selectTmplt(checkVo);

                if (existVo == null) {
                    continue;
                }

                if (!isValidAuthority(existVo, userId, admin)) {
                    resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                    resultVO.setMessage(getCommonNoAuthMessage());
                    return resultVO;
                }
            }

            int cnt = msgTmpltService.deleteTmplt(vo);
            resultVO.setResult(cnt > 0 ? ProcessResultVO.RESULT_SUCC : ProcessResultVO.RESULT_FAIL);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.delete"));
        }

        return resultVO;
    }

    /**
     * 메시지 템플릿 전체 삭제
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgTmpltAllDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltAllDeleteAjax(MsgTmpltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<MsgTmpltVO>();

        try {
            UserContext userCtx = getUserContext(request);

            vo.setOrgId(userCtx.getOrgId());

            if (ORG_MSG.equals(vo.getMsgCtsGbncd())) {
                if (!isAdmin(userCtx)) {
                    resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                    resultVO.setMessage(getCommonNoAuthMessage());
                    return resultVO;
                }
                vo.setRgtrId(null);
            } else {
                vo.setMsgCtsGbncd(INDV_MSG);
                vo.setRgtrId(userCtx.getUserId());
            }

            int cnt = msgTmpltService.deleteAllTmplt(vo);
            resultVO.setResult(cnt > 0 ? ProcessResultVO.RESULT_SUCC : ProcessResultVO.RESULT_FAIL);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.delete"));
        }

        return resultVO;
    }

    /**
     * 메시지 템플릿 엑셀 다운로드 목록 조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/msgTmpltExcelListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltExcelListAjax(MsgTmpltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<MsgTmpltVO>();

        try {
            UserContext userCtx = getUserContext(request);

            vo.setOrgId(userCtx.getOrgId());
            vo.setRgtrId(userCtx.getUserId());

            List<MsgTmpltVO> list = msgTmpltService.selectTmpltExcelList(vo);

            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }
}
