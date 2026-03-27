package knou.lms.resh.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.URLBuilder;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.login.web.LoginControllerTOBE;
import knou.lms.org.service.OrgCodeService;
import knou.lms.resh.service.ReshAnsrService;
import knou.lms.resh.service.ReshQstnService;
import knou.lms.resh.service.ReshService;
import knou.lms.resh.vo.ReshAnsrVO;
import knou.lms.resh.vo.ReshPageVO;
import knou.lms.resh.vo.ReshVO;
import org.apache.log4j.Logger;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
@RequestMapping(value = "/resh/reshMgr")
public class ReshMgrController extends ControllerBase {

    private static final Logger log = Logger.getLogger(LoginControllerTOBE.class);


    @Resource(name = "reshService")
    private ReshService reshService;

    @Resource(name = "reshQstnService")
    private ReshQstnService reshQstnService;

    @Resource(name = "reshAnsrService")
    private ReshAnsrService reshAnsrService;

    @Resource(name = "orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name = "messageSource")
    private MessageSource messageSource;

    /***************************************************** 
     * TODO 전체 설문 목록 페이지
     * @param ReshVO
     * @return "resh/mgr/home_resh_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/homeReshList.do")
    public String homeReshListForm(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);

        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));


        if (!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        request.setAttribute("orgId", orgId);
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "resh/mgr/home_resh_list";
    }

    /***************************************************** 
     * TODO 전체 설문 등록 페이지
     * @param ReshVO
     * @return "resh/mgr/home_resh_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/writeHomeResh.do")
    public String writeHomeReshForm(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        if (!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        request.setAttribute("userTypeList", orgCodeService.selectOrgCodeList("USER_TYPE"));
        request.setAttribute("orgId", orgId);
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "resh/mgr/home_resh_write";
    }

    /***************************************************** 
     * TODO 전체 설문 등록
     * @param ReshVO
     * @return "redirect:/resh/reshMgr/Form/homeReshList.do"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/writeHomeResh.do")
    public String writeHomeResh(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);
        reshService.insertHomeResh(vo);

        return "redirect:" + new URLBuilder("resh/reshMgr", "/Form/homeReshList.do", request);
    }

    /***************************************************** 
     * TODO 전체 설문 수정 페이지
     * @param ReshVO
     * @return "resh/mgr/home_resh_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/editHomeResh.do")
    public String editHomeReshForm(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        if (!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        ReshVO reshVo = reshService.select(vo);
        request.setAttribute("vo", reshVo);
        request.setAttribute("userTypeList", orgCodeService.selectOrgCodeList("USER_TYPE"));
        request.setAttribute("orgId", orgId);
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "resh/mgr/home_resh_write";
    }

    /***************************************************** 
     * TODO 전체 설문 수정
     * @param ReshVO
     * @return "redirect:/resh/reshMgr/Form/homeReshList.do"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editHomeResh.do")
    public String editHomeResh(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        reshService.updateHomeResh(vo);

        return "redirect:" + new URLBuilder("resh/reshMgr", "/Form/homeReshList.do", request);
    }

    /***************************************************** 
     * TODO 이전 전체 설문 가져오기 팝업
     * @param ReshVO
     * @return "resh/popup/home_resh_copy_list_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/homeReshCopyListPop.do")
    public String homeReshCopyListPop(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if (!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        return "resh/mgr/popup/home_resh_copy_list_pop";
    }

    /*****************************************************
     * TODO 전체 설문 삭제
     * @param ReshVO
     * @return "redirect:/resh/reshMgr/Form/homeReshList.do"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/delHomeResh.do")
    public String delHomeResh(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setMdfrId(userId);
        reshService.deleteHomeResh(vo);

        return "redirect:" + new URLBuilder("resh/reshMgr", "/Form/homeReshList.do", request);
    }

    /***************************************************** 
     * TODO 전체설문 정보 페이지
     * @param ReshVO
     * @return "resh/mgr/home_resh_info_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/homeReshInfoManage.do")
    public String homeReshInfoManage(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        if (!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        ReshVO reshVo = reshService.select(vo);
        request.setAttribute("vo", reshVo);
        request.setAttribute("userTypeList", orgCodeService.selectOrgCodeList("USER_TYPE"));
        request.setAttribute("orgId", orgId);
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "resh/mgr/home_resh_info_manage";
    }

    /***************************************************** 
     * TODO 전체설문 문항 관리 페이지
     * @param ReshVO
     * @return "resh/mgr/home_resh_qstn_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/homeReshQstnManage.do")
    public String homeReshQstnManage(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        if (!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        ReshVO reshVo = reshService.select(vo);
        request.setAttribute("vo", reshVo);

        ReshPageVO pageVO = new ReshPageVO();
        pageVO.setReschCd(vo.getReschCd());
        List<ReshPageVO> pageList = reshQstnService.listReshPage(pageVO);
        request.setAttribute("listReschPage", pageList);

        request.setAttribute("qstnTypeList", orgCodeService.selectOrgCodeList("RESCH_QSTN_TYPE_CD"));
        request.setAttribute("orgId", orgId);
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "resh/mgr/home_resh_qstn_manage";
    }

    /***************************************************** 
     * TODO 전체설문 결과 페이지
     * @param ReshVO
     * @return "resh/mgr/home_resh_result_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/homeReshResultManage.do")
    public String homeReshResultManage(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if (!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        vo.setReschTypeCd("HOME");
        ReshVO reshVo = reshService.select(vo);
        request.setAttribute("vo", reshVo);

        vo.setOrgId(orgId);
        List<EgovMap> joinDeviceList = reshAnsrService.listReshJoinDeviceStatus(vo);
        request.setAttribute("joinDeviceList", joinDeviceList);

        ReshPageVO pageVo = new ReshPageVO();
        pageVo.setReschCd(vo.getReschCd());
        List<ReshPageVO> reschAnswerList = reshAnsrService.listReshAnswerStatus(pageVo);
        request.setAttribute("reschAnswerList", reschAnswerList);

        List<Map<String, Object>> colorList = new ArrayList<Map<String, Object>>();
        String[] colorTitleList = {"bcOrange", "bcLYellow", "bcOlive", "bcGreen", "bcLblue", "bcPurple", "bcViolet", "bcBrown", "bcGrey", "bcPink"};
        String[] colorCodeList = {"#f2711c", "#fff9db", "#b5cc18", "#21ba45", "#deeaf6", "#a333c8", "#6435c9", "#a5673f", "#767676", "#e03997"};

        for (int i = 0; i < 10; i++) {
            Map<String, Object> colorMap = new HashMap<String, Object>();
            colorMap.put("title", colorTitleList[i]);
            colorMap.put("code", colorCodeList[i]);
            colorList.add(colorMap);
        }

        request.setAttribute("colorList", colorList);
        request.setAttribute("deviceList", orgCodeService.selectOrgCodeList("DEVICE_TYPE_CD"));
        request.setAttribute("orgId", orgId);
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "resh/mgr/home_resh_result_manage";
    }

    /***************************************************** 
     * TODO 전체설문 참여자 목록 가져오기 ajax
     * @param ReshAnsrVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/homeReshJoinUserList.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> homeReshJoinUserList(ReshAnsrVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        Locale locale = LocaleUtil.getLocale(request);

        try {
            resultVO = reshAnsrService.listHomeReshJoinUser(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.list", null, locale));/* 설문 리스트 조회 중 에러가 발생하였습니다. */
        }

        return resultVO;
    }

}
