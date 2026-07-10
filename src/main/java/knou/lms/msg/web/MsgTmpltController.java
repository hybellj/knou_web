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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@Controller
public class MsgTmpltController extends ControllerBase {

    @Resource(name = "msgTmpltService")
    private MsgTmpltService msgTmpltService;

    private static final String ORG_MSG = "ORG_MSG";
    private static final String INDV_MSG = "INDV_MSG";

    private void initSearchParam(MsgTmpltVO vo, UserContext userCtx) {
        boolean isAdmin = MsgAuthUtil.isAdmin(userCtx);

        if (ORG_MSG.equals(vo.getMsgCtsGbncd())) {
            vo.setRgtrId(null);
            if (!isAdmin) {
                vo.setOrgId(userCtx.getOrgId());
            }
        } else {
            vo.setMsgCtsGbncd(INDV_MSG);
            if (isAdmin) {
                String userId = StringUtil.nvl(vo.getUserId());
                if (userId.isEmpty()) {
                    userId = userCtx.getUserId();
                }
                vo.setRgtrId(userId);
            } else {
                vo.setRgtrId(userCtx.getUserId());
            }
        }
    }

    /*****************************************************
     * 교수 메시지 템플릿 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_tmplt_list_view"
     ******************************************************/
    @RequestMapping(value = "/profMsgTmpltListView.do")
    public String profMsgTmpltListView(MsgTmpltVO vo, @CurrentUser UserContext userCtx, ModelMap model) {
        model.addAttribute("vo", vo);
        model.addAttribute("isAdmin", MsgAuthUtil.isAdmin(userCtx));

        return "msg/prof_msg_tmplt_list_view";
    }

    /*****************************************************
     * 관리자 메시지 템플릿 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_tmplt_list_view"
     ******************************************************/
    @RequestMapping(value = "/admMsgTmpltListView.do")
    public String admMsgTmpltListView(MsgTmpltVO vo, @CurrentUser UserContext userCtx, ModelMap model) {
        model.addAttribute("vo", vo);
        model.addAttribute("isAdmin", true);

        return "msg/adm_msg_tmplt_list_view";
    }

    /*****************************************************
     * 메시지 템플릿 목록 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgTmpltListAjax.do", "/admMsgTmpltListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltListAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        initSearchParam(vo, userCtx);

        resultVO = msgTmpltService.selectTmpltListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 상세 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     ******************************************************/
    @RequestMapping({"/msgTmpltSelectAjax.do", "/admMsgTmpltSelectAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltSelectAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        MsgTmpltVO result = msgTmpltService.selectTmplt(vo);

        if (result != null && !"Y".equals(MsgAuthUtil.getTmpltAccessAuth(userCtx, result.getRgtrId(), result.getMsgCtsGbncd(), result.getOrgId()))) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        resultVO.setReturnVO(result);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 등록
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     ******************************************************/
    @RequestMapping({"/msgTmpltRegistAjax.do", "/admMsgTmpltRegistAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltRegistAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        if (ORG_MSG.equals(vo.getMsgCtsGbncd()) && !MsgAuthUtil.isAdmin(userCtx)) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getCommonNoAuthMessage());
            return resultVO;
        }

        vo.setRgtrId(userCtx.getUserId());
        vo.setOrgId(userCtx.getOrgId());

        msgTmpltService.insertTmplt(vo);
        resultVO.setReturnVO(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 수정
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     ******************************************************/
    @RequestMapping({"/msgTmpltModifyAjax.do", "/admMsgTmpltModifyAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltModifyAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

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

        msgTmpltService.updateTmplt(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 삭제
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     ******************************************************/
    @RequestMapping({"/msgTmpltDeleteAjax.do", "/admMsgTmpltDeleteAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltDeleteAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        String userId = userCtx.getUserId();
        boolean admin = MsgAuthUtil.isAdmin(userCtx);

        msgTmpltService.deleteTmplt(vo, userId, admin);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 전체 삭제
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     ******************************************************/
    @RequestMapping({"/msgTmpltAllDeleteAjax.do", "/admMsgTmpltAllDeleteAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltAllDeleteAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());

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

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 다건 삭제
     * @param vo
     * @param userCtx
     * @param returnView 리스트 뷰 URL
     * @return redirect:listUrl
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgTmpltDelete.do", "/admMsgTmpltDelete.do"})
    public String msgTmpltDelete(MsgTmpltVO vo, @CurrentUser UserContext userCtx,
                                 @RequestParam("returnView") String returnView) throws Exception {
        msgTmpltService.deleteTmplt(vo, userCtx.getUserId(), MsgAuthUtil.isAdmin(userCtx));

        addEncParam("msgCtsGbncd", vo.getMsgCtsGbncd());
        addEncParam("pageIndex", String.valueOf(vo.getPageIndex() > 0 ? vo.getPageIndex() : 1));
        addEncParam("searchText", StringUtil.nvl(vo.getSearchText()));

        return "redirect:" + resolveListUrl(returnView) + "?encParams=" + getEncParams();
    }

    /*****************************************************
     * 메시지 템플릿 전체 삭제
     * @param vo
     * @param userCtx
     * @param returnView 리스트 뷰 URL
     * @return redirect:listUrl
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgTmpltAllDelete.do", "/admMsgTmpltAllDelete.do"})
    public String msgTmpltAllDelete(MsgTmpltVO vo, @CurrentUser UserContext userCtx,
                                    @RequestParam("returnView") String returnView) throws Exception {
        vo.setOrgId(userCtx.getOrgId());

        if (ORG_MSG.equals(vo.getMsgCtsGbncd())) {
            if (!MsgAuthUtil.isAdmin(userCtx)) {
                throw new AccessDeniedException(getCommonNoAuthMessage());
            }
            vo.setRgtrId(null);
        } else {
            vo.setMsgCtsGbncd(INDV_MSG);
            vo.setRgtrId(userCtx.getUserId());
        }

        msgTmpltService.deleteAllTmplt(vo);

        addEncParam("msgCtsGbncd", vo.getMsgCtsGbncd());
        addEncParam("pageIndex", "1");
        addEncParam("searchText", "");

        return "redirect:" + resolveListUrl(returnView) + "?encParams=" + getEncParams();
    }

    private String resolveListUrl(String returnView) {
        if ("/admMsgTmpltListView.do".equals(returnView)) {
            return "/admMsgTmpltListView.do";
        }
        return "/profMsgTmpltListView.do";
    }

    /*****************************************************
     * 메시지 템플릿 엑셀 다운로드 목록 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgTmpltVO>
     ******************************************************/
    @RequestMapping({"/msgTmpltExcelListAjax.do", "/admMsgTmpltExcelListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgTmpltVO> msgTmpltExcelListAjax(MsgTmpltVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        initSearchParam(vo, userCtx);

        List<MsgTmpltVO> list = msgTmpltService.selectTmpltExcelList(vo);

        resultVO.setReturnList(list);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 메시지 템플릿 엑셀 다운로드
     * @param vo
     * @param userCtx
     * @param model
     * @return "excelView"
     ******************************************************/
    @RequestMapping({"/msgTmpltExcelDown.do", "/admMsgTmpltExcelDown.do"})
    public String msgTmpltExcelDown(MsgTmpltVO vo, @CurrentUser UserContext userCtx, ModelMap model) {
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
