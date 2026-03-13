package knou.lms.msg.web;

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
import knou.lms.msg.service.PopupNtcService;
import knou.lms.msg.vo.PopupNtcVO;

@Controller
public class PopupNtcController extends ControllerBase {

    @Resource(name = "popupNtcService")
    private PopupNtcService popupNtcService;

    private static final int PAGE_SIZE = 10;

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
        String authrtGrpcd = userCtx.getAuthrtGrpcd();
        return authrtGrpcd != null && authrtGrpcd.contains("ADM");
    }

    /**
     * 팝업공지 목록 화면
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/popupNtcListView.do")
    public String popupNtcListView(PopupNtcVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        UserContext userCtx = getUserContext(request);

        if (!isAdmin(userCtx)) {
            model.addAttribute("message", getCommonNoAuthMessage());
            return "common/error";
        }

        model.addAttribute("userCtx", userCtx);
        model.addAttribute("pageSize", PAGE_SIZE);

        return "msg2/popup_ntc_list";
    }

    /**
     * 팝업공지 목록 조회 (AJAX)
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/popupNtcListAjax.do")
    @ResponseBody
    public ProcessResultVO<PopupNtcVO> popupNtcListAjax(PopupNtcVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<PopupNtcVO>();

        try {
            UserContext userCtx = getUserContext(request);

            if (!isAdmin(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            resultVO = popupNtcService.selectPopupNtcListPage(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 팝업공지 상세보기 화면
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/popupNtcDetail.do")
    public String popupNtcDetail(PopupNtcVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        UserContext userCtx = getUserContext(request);

        if (!isAdmin(userCtx)) {
            model.addAttribute("message", getCommonNoAuthMessage());
            return "common/error";
        }

        PopupNtcVO detailVO = popupNtcService.selectPopupNtc(vo);

        model.addAttribute("userCtx", userCtx);
        model.addAttribute("detailVO", detailVO);

        return "msg2/popup_ntc_detail";
    }

    /**
     * 팝업공지 등록 화면
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/popupNtcRegist.do")
    public String popupNtcRegist(PopupNtcVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        UserContext userCtx = getUserContext(request);

        if (!isAdmin(userCtx)) {
            model.addAttribute("message", getCommonNoAuthMessage());
            return "common/error";
        }

        model.addAttribute("userCtx", userCtx);
        model.addAttribute("mode", "regist");

        return "msg2/popup_ntc_regist";
    }

    /**
     * 팝업공지 수정 화면
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/popupNtcModify.do")
    public String popupNtcModify(PopupNtcVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        UserContext userCtx = getUserContext(request);

        if (!isAdmin(userCtx)) {
            model.addAttribute("message", getCommonNoAuthMessage());
            return "common/error";
        }

        PopupNtcVO detailVO = popupNtcService.selectPopupNtc(vo);

        model.addAttribute("userCtx", userCtx);
        model.addAttribute("detailVO", detailVO);
        model.addAttribute("mode", "modify");

        return "msg2/popup_ntc_regist";
    }

    /**
     * 팝업공지 등록 (AJAX)
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/popupNtcRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<PopupNtcVO> popupNtcRegistAjax(PopupNtcVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<PopupNtcVO>();

        try {
            UserContext userCtx = getUserContext(request);

            if (!isAdmin(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setOrgId(userCtx.getOrgId());
            vo.setRgtrId(userCtx.getUserId());

            int cnt = popupNtcService.registPopupNtc(vo);
            resultVO.setResult(cnt > 0 ? ProcessResultVO.RESULT_SUCC : ProcessResultVO.RESULT_FAIL);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.insert"));
        }

        return resultVO;
    }

    /**
     * 팝업공지 수정 (AJAX)
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/popupNtcModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<PopupNtcVO> popupNtcModifyAjax(PopupNtcVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<PopupNtcVO>();

        try {
            UserContext userCtx = getUserContext(request);

            if (!isAdmin(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setMdfrId(userCtx.getUserId());

            int cnt = popupNtcService.modifyPopupNtc(vo);
            resultVO.setResult(cnt > 0 ? ProcessResultVO.RESULT_SUCC : ProcessResultVO.RESULT_FAIL);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.update"));
        }

        return resultVO;
    }

    /**
     * 팝업공지 삭제 (AJAX)
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/popupNtcDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<PopupNtcVO> popupNtcDeleteAjax(PopupNtcVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<PopupNtcVO>();

        try {
            UserContext userCtx = getUserContext(request);

            if (!isAdmin(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            if (vo.getPopupNtcId() == null || vo.getPopupNtcId().isEmpty()) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getMessage("common.item.select.msg"));
                return resultVO;
            }

            int cnt = popupNtcService.deletePopupNtc(vo);
            resultVO.setResult(cnt > 0 ? ProcessResultVO.RESULT_SUCC : ProcessResultVO.RESULT_FAIL);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.delete"));
        }

        return resultVO;
    }

    /**
     * 팝업공지 전시여부 변경 (AJAX)
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/popupNtcUseynModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<PopupNtcVO> popupNtcUseynModifyAjax(PopupNtcVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<PopupNtcVO>();

        try {
            UserContext userCtx = getUserContext(request);

            if (!isAdmin(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setMdfrId(userCtx.getUserId());

            int cnt = popupNtcService.modifyPopupNtcUseyn(vo);
            resultVO.setResult(cnt > 0 ? ProcessResultVO.RESULT_SUCC : ProcessResultVO.RESULT_FAIL);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.update"));
        }

        return resultVO;
    }

    /**
     * 기관 목록 조회 (AJAX)
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/popupNtcOrgListAjax.do")
    @ResponseBody
    public ProcessResultVO<PopupNtcVO> popupNtcOrgListAjax(PopupNtcVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<PopupNtcVO>();

        try {
            UserContext userCtx = getUserContext(request);

            if (!isAdmin(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            resultVO.setReturnList(popupNtcService.selectOrgList(vo));
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /**
     * 팝업공지 단건 조회 (미리보기/AJAX)
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/popupNtcSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<PopupNtcVO> popupNtcSelectAjax(PopupNtcVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<PopupNtcVO>();

        try {
            UserContext userCtx = getUserContext(request);

            if (!isAdmin(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            PopupNtcVO result = popupNtcService.selectPopupNtc(vo);
            resultVO.setReturnVO(result);
            resultVO.setResult(result != null ? ProcessResultVO.RESULT_SUCC : ProcessResultVO.RESULT_FAIL);
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }
}
