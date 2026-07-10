package knou.lms.log2.user.web;

import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.PageInfo;
import knou.framework.common.SessionInfo;
import knou.framework.util.LocaleUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log2.user.service.LogUserActvService;
import knou.lms.log2.user.vo.LectCntnInfoVO;
import knou.lms.log2.user.vo.LogUserActvVO;

@Controller
@RequestMapping(value= {"/log2"})
public class LogUserActvController extends ControllerBase {
    private static final Logger LOGGER = LoggerFactory.getLogger(LogUserActvController.class);

    @Resource(name="logUserActvService")
    private LogUserActvService logUserActvService;

    /*****************************************************
     * 강의실 > 과목설정 > 접속정보
     * @param lectCntnInfoVO
     * @return
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profSbjctStngCntnInfoListView.do")
    public String profSbjctStngCntnInfoListView(LectCntnInfoVO lectCntnInfoVO, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("lectCntnInfoVO", lectCntnInfoVO);

        return "log2/lect/prof_cntn_info_list_view";
    }

    /*****************************************************
     * 교수강의실과목설정접속정보 목록 ajax
     * @param lectCntnInfoVO
     * @param request
     * @return ProcessResultVO<LogUserActvVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/profSbjctStngCntnInfoListAjax.do")
    @ResponseBody
    public ProcessResultVO<LectCntnInfoVO> profLogUserActvList(LectCntnInfoVO lectCntnInfoVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<LectCntnInfoVO> resultVO = new ProcessResultVO<>();

        try {
            resultVO = logUserActvService.selectProfSbjctStngCntnInfoList(lectCntnInfoVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }

        return resultVO;
    }

    /**
     * [관리자] 사용자 접속 현황 조회
     * @param vo
     * @return
     */
    @GetMapping("/admUsrCntnStsListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> admUsrCntnStsListAjax(LogUserActvVO vo) {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        resultVO.setReturnList(logUserActvService.userCntnStsList(vo)); // 사용자 접속 목록
        resultVO.setReturnListSub(logUserActvService.userCntnCntSummary(vo));   // 사용자 접속 인원수 통계
        resultVO.setResultSuccess();

        return resultVO;
    }
    
    
    /**
     * 관리자접속로그목록조회페이징
     * @param 	PageInfo
     * @return	ProcessResultVO<EgovMap>
     */
    @GetMapping("/admCntnLogListPaging.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> admCntnLogListPaging(PageInfo pageInfo) throws Exception {
        return logUserActvService.admCntnLogListPaging(pageInfo).setResultSuccess();
    }
}