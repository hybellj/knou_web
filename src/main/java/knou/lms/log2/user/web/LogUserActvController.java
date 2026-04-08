package knou.lms.log2.user.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.LocaleUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.lesson.web.LessonHomeController;
import knou.lms.log2.user.service.LogUserActvService;
import knou.lms.log2.user.vo.LectCntnInfoVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Locale;

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

}