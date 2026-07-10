package knou.lms.stats.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.framework.util.ExcelUtilPoi;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.service.CommonService;
import knou.lms.stats.service.QnaStatsService;
import knou.lms.stats.vo.QnaStatsVO;
import knou.lms.user.CurrentUser;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/stats/lrnStatsAnls")
public class LrnStatsAnlsController extends ControllerBase {

    @Resource(name="qnaStatsService")
    private QnaStatsService qnaStatsService;

    @Resource(name="commonService")
    private CommonService commonService;

    /**
     * 관리자 > 과목관리 > 학습통계분석 > 질의응답 총괄현황 화면
     */
    @RequestMapping("/admQnaStatsListView.do")
    public String admQnaStatsListView(QnaStatsVO vo,
                                      @CurrentUser UserContext userCtx,
                                      ModelMap model,
                                      HttpServletRequest request) throws Exception {
        boolean isSystemAdmin = CommConst.AUTHRT_CD_ADM.equals(userCtx.getAuthrtCd());
        if (!isSystemAdmin || vo.getOrgId() == null || vo.getOrgId().isEmpty()) {
            vo.setOrgId(userCtx.getLoginUser().getOrgId());
        }
        vo.setLangCd(userCtx.getLangCd());

        EgovMap filterOptions = commonService.loadFilterOptions(userCtx);
        filterOptions.put("orgId", vo.getOrgId());
        filterOptions.put("yrSmstrList", commonService.yrSmstrSelect(vo));
        model.addAttribute("filterOptions", filterOptions);
        model.addAttribute("isSystemAdmin", isSystemAdmin);
        model.addAttribute("userCtx", userCtx);
        model.addAttribute("qnaStatsVO", vo);
        model.addAttribute("encParams", getEncParams());

        return "stats/lrnStatsAnls/adm_qna_stats_list";
    }

    /**
     * 질의응답 총괄현황 목록을 조회한다.
     */
    @RequestMapping("/admQnaStatsListAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> qnaStatsListAjax(QnaStatsVO vo,
                                               @CurrentUser UserContext userCtx,
                                               HttpServletRequest request) throws Exception {
        if (!CommConst.AUTHRT_CD_ADM.equals(userCtx.getAuthrtCd())) {
            vo.setOrgId(userCtx.getLoginUser().getOrgId());
        }
        vo.setLangCd(userCtx.getLangCd());

        ResultDTO<EgovMap> resultDTO = qnaStatsService.admQnaStatsList(vo);
        resultDTO.setResultSuccess();
        resultDTO.setEncParams(getEncParams());
        return resultDTO;
    }

    /**
     * 질의응답 총괄현황 엑셀을 다운로드한다.
     */
    @RequestMapping("/admQnaStatsExcelDown.do")
    public String qnaStatsExcelDown(QnaStatsVO vo,
                                    @CurrentUser UserContext userCtx,
                                    ModelMap model) throws Exception {
        if (!CommConst.AUTHRT_CD_ADM.equals(userCtx.getAuthrtCd())) {
            vo.setOrgId(userCtx.getLoginUser().getOrgId());
        }
        vo.setLangCd(userCtx.getLangCd());

        String title = "질의응답 총괄현황";
        List<EgovMap> list = qnaStatsService.qnaStatsExcelList(vo);

        HashMap<String, Object> excelMap = new HashMap<>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", vo.getExcelGrid());
        excelMap.put("list", list);

        HashMap<String, Object> modelAttr = new HashMap<>();
        modelAttr.put("outFileName", title + "_" + new SimpleDateFormat("yyyyMMdd").format(new Date()));
        modelAttr.put("workbook", new ExcelUtilPoi().simpleGrid(excelMap));
        model.addAllAttributes(modelAttr);

        return "excelView";
    }
}
