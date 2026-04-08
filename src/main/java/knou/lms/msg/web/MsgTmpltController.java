package knou.lms.msg.web;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.MsgTmpltService;
import knou.lms.msg.vo.MsgTmpltVO;
import knou.lms.msg.web.util.MsgAuthUtil;
import knou.lms.user.CurrentUser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@Controller
public class MsgTmpltController extends ControllerBase {

    @Resource(name = "msgTmpltService")
    private MsgTmpltService msgTmpltService;

    private static final int PAGE_SIZE = 12;
    private static final String ORG_MSG = "ORG_MSG";
    private static final String INDV_MSG = "INDV_MSG";

    private void initSearchParam(MsgTmpltVO vo, UserContext userCtx) {
        if (ORG_MSG.equals(vo.getMsgCtsGbncd())) {
            vo.setRgtrId(null);
        } else {
            vo.setMsgCtsGbncd(INDV_MSG);
            String userId = StringUtil.nvl(vo.getUserId());
            if (userId.isEmpty()) {
                userId = userCtx.getUserId();
            }
            vo.setRgtrId(userId);
        }
    }

    /*****************************************************
     * 교수 메시지 템플릿 목록 화면
     * @param vo
     * @param model
     * @param request
     * @return "msg2/prof_msg_tmplt_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgTmpltListView.do")
    public String profMsgTmpltListView(MsgTmpltVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (!MsgAuthUtil.isProfessor(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        vo.setListScale(PAGE_SIZE);
        setEncParamsToVO(vo);

        model.addAttribute("vo", vo);
        model.addAttribute("isAdmin", MsgAuthUtil.isAdmin(userCtx));

        return "msg2/prof_msg_tmplt_list_view";
    }

    /*****************************************************
     * 관리자 메시지 템플릿 목록 화면
     * @param vo
     * @param model
     * @param request
     * @return "msg2/mngr_msg_tmplt_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/mngrMsgTmpltListView.do")
    public String mngrMsgTmpltListView(MsgTmpltVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (!MsgAuthUtil.isAdmin(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        vo.setListScale(PAGE_SIZE);
        setEncParamsToVO(vo);

        model.addAttribute("vo", vo);
        model.addAttribute("isAdmin", true);

        return "msg2/mngr_msg_tmplt_list_view";
    }

    /*****************************************************
     * 메시지 템플릿 목록 조회 (AJAX 페이징)
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgTmpltListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltListAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            initSearchParam(vo, userCtx);

            resultVO = msgTmpltService.selectTmpltListPage(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 상세 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgTmpltSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltSelectAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            MsgTmpltVO result = msgTmpltService.selectTmplt(vo);

            if (result != null && !"Y".equals(MsgAuthUtil.getTmpltAccessAuth(userCtx, result.getRgtrId(), result.getMsgCtsGbncd(), result.getOrgId()))) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            resultVO.setReturnVO(result);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 등록
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgTmpltRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltRegistAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            if (ORG_MSG.equals(vo.getMsgCtsGbncd()) && !MsgAuthUtil.isAdmin(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setRgtrId(userCtx.getUserId());

            msgTmpltService.registTmplt(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.insert"));
        }

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 수정
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgTmpltModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltModifyAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            MsgTmpltVO existVo = msgTmpltService.selectTmplt(vo);
            if (existVo == null) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getMessage("common.content.not_found"));
                return resultVO;
            }
            if (!"Y".equals(MsgAuthUtil.getTmpltEditAuth(userCtx, existVo.getRgtrId(), existVo.getMsgCtsGbncd()))) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            vo.setMsgCtsGbncd(null);
            vo.setMdfrId(userCtx.getUserId());

            msgTmpltService.modifyTmplt(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.update"));
        }

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 삭제
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgTmpltDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltDeleteAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            String userId = userCtx.getUserId();
            boolean admin = MsgAuthUtil.isAdmin(userCtx);

            msgTmpltService.deleteTmplt(vo, userId, admin);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (IllegalAccessException e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.delete"));
        }

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 전체 삭제
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgTmpltAllDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltAllDeleteAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            if (ORG_MSG.equals(vo.getMsgCtsGbncd())) {
                if (!MsgAuthUtil.isAdmin(userCtx)) {
                    resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                    resultVO.setMessage(getCommonNoAuthMessage());
                    return resultVO;
                }
                vo.setRgtrId(null);
            } else {
                vo.setMsgCtsGbncd(INDV_MSG);
                vo.setRgtrId(userCtx.getUserId());
            }

            msgTmpltService.deleteAllTmplt(vo);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.delete"));
        }

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 엑셀 다운로드 목록 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgTmpltExcelListAjax.do")
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltExcelListAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        try {
            if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
                resultVO.setResult(ProcessResultVO.RESULT_FAIL);
                resultVO.setMessage(getCommonNoAuthMessage());
                return resultVO;
            }

            initSearchParam(vo, userCtx);

            List<MsgTmpltVO> list = msgTmpltService.selectTmpltExcelList(vo);

            resultVO.setReturnList(list);
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setEncParams(getEncParams());
        } catch (Exception e) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("fail.common.select"));
        }

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/msgTmpltExcelDown.do")
    public String msgTmpltExcelDown(MsgTmpltVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (!MsgAuthUtil.isAdmin(userCtx) && !MsgAuthUtil.isProfessor(userCtx)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }

        initSearchParam(vo, userCtx);

        List<MsgTmpltVO> list = msgTmpltService.selectTmpltExcelList(vo);

        String title = getMessage("msg.tmplt.label.title");
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }
}
