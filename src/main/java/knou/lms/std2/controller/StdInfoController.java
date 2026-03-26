package knou.lms.std2.controller;

import knou.framework.common.ControllerBase;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.std2.service.StdInfoService;
import knou.lms.std2.vo.AtndlcVO;
import knou.lms.subject.service.SubjectService;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping(value="/std/info")
public class StdInfoController extends ControllerBase {
    private static final Logger LOGGER = LoggerFactory.getLogger(StdInfoController.class);

    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="subjectService")
    private SubjectService subjectService;

    @Resource(name="stdInfoService")
    private StdInfoService stdInfoService;


    /**
     * 교수-수강생정보 목록 화면 조회
     *
     * @param atndlcVO
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profStdInfoListView.do")
    public String profStdInfoListView(AtndlcVO atndlcVO, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String sbjctId = atndlcVO.getSbjctId();
        if(ValidationUtils.isEmpty(sbjctId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        // 페이지 접근 권한 체크


        // 과목정보 - 조회 없어도 될듯
        /*SbjctVO sbjctVO = new SbjctVO();
        sbjctVO.setSbjctId(sbjctId);
        SubjectVO subjectVO = subjectService.subjectSelect(sbjctId);
        model.addAttribute("sbjctVO", subjectVO);
        */

        model.addAttribute("atndlcVO", atndlcVO);

        return "std2/info/prof_std_info_list_view";
    }

    /**
     * 교수-수강생정보목록 ajax
     *
     * @param atndlcVO
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profStdInfoListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profStdInfoListAjax(AtndlcVO atndlcVO, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        try {
            resultVO = stdInfoService.stdInfoListPaging(atndlcVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;

    }

    /**
     * 교수 수강생정보 목록 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profStdInfoListExcelDownload.do")
    public String profStdInfoListExcelDownload(AtndlcVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        if(ValidationUtils.isEmpty(vo.getSbjctId())) {
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        // 조회
        List<EgovMap> list = stdInfoService.profStdInfoExcelList(vo);

        String title = getMessage("std.label.learner_info"); // 수강생정보

        String searchKeyNm = "";
        if("std".equals(vo.getSearchKey())) {
            searchKeyNm = getMessage("std.label.learner"); // 수강생
        } else if("dsbl".equals(vo.getSearchKey())) {
            searchKeyNm = getMessage("std.label.dis_studend"); // 장애학생
        } else if("audit".equals(vo.getSearchKey())) {
            searchKeyNm = getMessage("std.label.auditor"); // 청강생
        } else {
            searchKeyNm = getMessage("common.all"); // 전체
        }

        String[] searchValues = {
                getMessage("common.search.condition") + " : " + searchKeyNm + " / " + StringUtil.nvl(vo.getSearchValue())
        };

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + date.format(today));
        modelMap.put("sheetName", title);

        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

        model.addAllAttributes(modelMap);
        return "excelView";

    }
}
