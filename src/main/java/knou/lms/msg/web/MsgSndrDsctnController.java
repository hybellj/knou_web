package knou.lms.msg.web;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.ExcelUtilPoi;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.facade.MsgSndrDsctnFacadeService;
import knou.lms.msg.vo.MsgSndrDsctnVO;
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
import java.util.Map;

@Controller
public class MsgSndrDsctnController extends ControllerBase {

    @Resource(name = "msgSndrDsctnFacadeService")
    private MsgSndrDsctnFacadeService msgSndrDsctnFacadeService;

    private static final int PAGE_SIZE = 10;

    /*****************************************************
     * 교수 발송내역관리 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/prof_msg_sndr_dsctn_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/profMsgSndrDsctnListView.do")
    public String profMsgSndrDsctnListView(MsgSndrDsctnVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo = msgSndrDsctnFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("orgId");
        vo.setOrgId(null);

        vo.setUserId(userCtx.getUserId());

        EgovMap filterOptions = msgSndrDsctnFacadeService.loadFilterOptions(vo);
        filterOptions.put("orgList", msgSndrDsctnFacadeService.selectProfSbjctOrgList(userCtx.getUserId()));
        model.addAttribute("filterOptions", filterOptions);

        model.addAttribute("initSmry", msgSndrDsctnFacadeService.selectSndrDsctnSmry(vo));
        model.addAttribute("initCostMap", msgSndrDsctnFacadeService.selectSndngCostMap());

        model.addAttribute("vo", vo);

        return "msg/prof_msg_sndr_dsctn_list_view";
    }

    /*****************************************************
     * 관리자 발송내역관리 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/adm_msg_sndr_dsctn_list_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admMsgSndrDsctnListView.do")
    public String admMsgSndrDsctnListView(MsgSndrDsctnVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        vo = msgSndrDsctnFacadeService.loadListViewInfo(vo);

        if (vo == null) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        delEncParam("orgId");
        vo.setOrgId(null);

        EgovMap filterOptions = msgSndrDsctnFacadeService.loadFilterOptions(vo);
        filterOptions.put("orgList", msgSndrDsctnFacadeService.selectActiveOrgListByAuth(userCtx.getUserId(), true));
        model.addAttribute("filterOptions", filterOptions);

        model.addAttribute("initSmry", msgSndrDsctnFacadeService.selectSndrDsctnSmry(vo));
        model.addAttribute("initCostMap", msgSndrDsctnFacadeService.selectSndngCostMap());

        model.addAttribute("vo", vo);

        return "msg/adm_msg_sndr_dsctn_list_view";
    }

    /*****************************************************
     * 발송내역 목록 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgSndrDsctnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping({"/msgSndrDsctnListAjax.do", "/admMsgSndrDsctnListAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnListAjax(MsgSndrDsctnVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        vo.setListScale(vo.getListScale() > 0 ? vo.getListScale() : PAGE_SIZE);
        if (!MsgAuthUtil.isAdmin(userCtx)) {
            vo.setUserId(userCtx.getUserId());
        }

        resultVO = msgSndrDsctnFacadeService.selectSndrDsctnListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 발송내역 채널별 요약 AJAX 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<MsgSndrDsctnVO>
     ******************************************************/
    @RequestMapping({"/msgSndrDsctnSmrySelectAjax.do", "/admMsgSndrDsctnSmrySelectAjax.do"})
    @ResponseBody
    public ProcessResultVO<MsgSndrDsctnVO> msgSndrDsctnSmrySelectAjax(MsgSndrDsctnVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        if (!MsgAuthUtil.isAdmin(userCtx)) {
            vo.setUserId(userCtx.getUserId());
        }

        MsgSndrDsctnVO smry = msgSndrDsctnFacadeService.selectSndrDsctnSmry(vo);
        resultVO.setReturnVO(smry);
        resultVO.setReturnSubVO(msgSndrDsctnFacadeService.selectSndngCostMap());
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 발송내역 엑셀 다운로드
     * @param vo
     * @param userCtx
     * @param model
     * @return "excelView"
     ******************************************************/
    @RequestMapping({"/msgSndrDsctnExcelDown.do", "/admMsgSndrDsctnExcelDown.do"})
    public String msgSndrDsctnExcelDown(MsgSndrDsctnVO vo, @CurrentUser UserContext userCtx, ModelMap model) {
        if (!MsgAuthUtil.isAdmin(userCtx)) {
            vo.setUserId(userCtx.getUserId());
        }

        List<MsgSndrDsctnVO> list = msgSndrDsctnFacadeService.selectSndrDsctnExcelList(vo);

        String title = getMessage("msg.sndrDsctn.label.title");
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

    /*****************************************************
     * 발송비용금액 엑셀 다운로드0
     * @param vo
     * @param userCtx
     * @param model
     * @return "excelView"
     ******************************************************/
    @RequestMapping({"/msgSndrDsctnSmryExcelDown.do", "/admMsgSndrDsctnSmryExcelDown.do"})
    public String msgSndrDsctnSmryExcelDown(MsgSndrDsctnVO vo, @CurrentUser UserContext userCtx, ModelMap model) {
        if (!MsgAuthUtil.isAdmin(userCtx)) {
            vo.setUserId(userCtx.getUserId());
        }

        MsgSndrDsctnVO smry = msgSndrDsctnFacadeService.selectSndrDsctnSmry(vo);

        Map<String, String> labels = new HashMap<>();
        labels.put("totalSndCnt", getMessage("msg.sndrDsctn.label.totalSndCnt"));
        labels.put("totalSuccCnt", getMessage("msg.sndrDsctn.label.totalSuccCnt"));
        labels.put("totalFailCnt", getMessage("msg.sndrDsctn.label.totalFailCnt"));
        labels.put("sndCost", getMessage("msg.sndrDsctn.label.sndCost"));

        List<Map<String, Object>> list = msgSndrDsctnFacadeService.buildSmryExcelRows(smry, labels);

        String title = getMessage("msg.sndrDsctn.label.costTitle");
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
