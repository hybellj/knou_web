package knou.lms.msg.web;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.ExcelUtilPoi;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.facade.MsgRcptnAgreFacadeService;
import knou.lms.msg.vo.MsgRcptnAgreVO;
import knou.lms.msg.web.util.MsgAuthUtil;
import knou.lms.user.CurrentUser;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@Controller
public class MsgRcptnAgreController extends ControllerBase {

    @Resource(name = "msgRcptnAgreFacadeService")
    private MsgRcptnAgreFacadeService msgRcptnAgreFacadeService;

    private static final int PAGE_SIZE = 10;

    /*****************************************************
     * 교수 알림수신동의현황 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_rcptn_agre_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgRcptnAgreListView.do")
    public String profMsgRcptnAgreListView(MsgRcptnAgreVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo = msgRcptnAgreFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("orgId");
        vo.setOrgId(null);

        vo.setUserId(userCtx.getUserId());
        EgovMap filterOptions = msgRcptnAgreFacadeService.loadFilterOptions(vo);
        filterOptions.put("orgList", msgRcptnAgreFacadeService.selectProfSbjctOrgList(userCtx.getUserId()));
        model.addAttribute("filterOptions", filterOptions);

        model.addAttribute("vo", vo);

        return "msg/prof_msg_rcptn_agre_list_view";
    }

    /*****************************************************
     * 관리자 알림수신동의현황 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_rcptn_agre_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgRcptnAgreListView.do")
    public String admMsgRcptnAgreListView(MsgRcptnAgreVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo = msgRcptnAgreFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("orgId");
        vo.setOrgId(null);

        EgovMap filterOptions = msgRcptnAgreFacadeService.loadFilterOptions(vo);
        filterOptions.put("orgList", msgRcptnAgreFacadeService.selectActiveOrgListByAuth(userCtx.getUserId(), true));
        model.addAttribute("filterOptions", filterOptions);

        model.addAttribute("vo", vo);

        return "msg/adm_msg_rcptn_agre_list_view";
    }

    /*****************************************************
     * 알림수신동의 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgRcptnAgreVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgRcptnAgreListAjax.do", "/admMsgRcptnAgreListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgRcptnAgreVO> msgRcptnAgreListAjax(MsgRcptnAgreVO vo, @CurrentUser UserContext userCtx) throws Exception {
        vo.setListScale(vo.getListScale() > 0 ? vo.getListScale() : PAGE_SIZE);

        ProcessResultVO<MsgRcptnAgreVO> resultVO;
        if (MsgAuthUtil.isAdmin(userCtx)) {
            resultVO = msgRcptnAgreFacadeService.selectAdminRcptnAgreListPage(vo);
        } else {
            vo.setUserId(userCtx.getUserId());
            resultVO = msgRcptnAgreFacadeService.selectRcptnAgreListPage(vo);
        }
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }


    /*****************************************************
     * 알림수신동의 엑셀 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgRcptnAgreVO>
     ******************************************************/
    @RequestMapping({"/msgRcptnAgreExcelListAjax.do", "/admMsgRcptnAgreExcelListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgRcptnAgreVO> msgRcptnAgreExcelListAjax(MsgRcptnAgreVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgRcptnAgreVO> resultVO = new ProcessResultVO<>();

        resultVO.setReturnList(selectExcelList(vo, userCtx));
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 알림수신동의현황 엑셀 다운로드
     * @param vo
     * @param userCtx
     * @param model
     * @return "excelView"
     ******************************************************/
    @RequestMapping({"/msgRcptnAgreExcelDown.do", "/admMsgRcptnAgreExcelDown.do"})
    public String msgRcptnAgreExcelDown(MsgRcptnAgreVO vo, @CurrentUser UserContext userCtx, ModelMap model) {
        return buildExcelView(vo, selectExcelList(vo, userCtx), model);
    }

    private List<MsgRcptnAgreVO> selectExcelList(MsgRcptnAgreVO vo, UserContext userCtx) {
        if (MsgAuthUtil.isAdmin(userCtx)) {
            return msgRcptnAgreFacadeService.selectAdminRcptnAgreExcelList(vo);
        }
        vo.setUserId(userCtx.getUserId());
        return msgRcptnAgreFacadeService.selectRcptnAgreExcelList(vo);
    }

    private String buildExcelView(MsgRcptnAgreVO vo, List<MsgRcptnAgreVO> list, ModelMap model) {
        String title = getMessage("msg.rcptnAgre.label.title");
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }
}
