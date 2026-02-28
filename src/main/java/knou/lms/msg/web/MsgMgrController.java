package knou.lms.msg.web;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.StringUtil;
import knou.lms.cmmn.vo.CmmnCdVO;

@Controller
@RequestMapping(value = "/msg/msgMgr")
public class MsgMgrController extends ControllerBase {
    
    private static final Logger LOGGER = LoggerFactory.getLogger(MsgMgrController.class);
    
    @Autowired @Qualifier("messageSource")
    private MessageSource messageSource;
    
    /***************************************************** 
     * @Method Name : msgMgrList
     * @Method 설명 : 코드관리 > 코드 리스트
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "msg/main/code_list.jsp"
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value="/msgPushList.do")
    public String msgPushList(CmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
    	return "msg/main/msg_push_list";
    }
    
    @RequestMapping(value="/msgShrtntList.do")
    public String msgShrtntList(CmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
    	return "msg/main/msg_shrtnt_list";
    }
    
    @RequestMapping(value="/msgEmlList.do")
    public String msgEmlList(CmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
    	return "msg/main/msg_eml_list";
    }
    
    @RequestMapping(value="/msgAlimTalkList.do")
    public String msgAlimTalkList(CmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
    	return "msg/main/msg_alim_talk_list";
    }
    
    @RequestMapping(value="/msgSmsList.do")
    public String msgSmsList(CmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
    	return "msg/main/msg_sms_list";
    }
    
    @RequestMapping(value="/msgTmpltList.do")
    public String msgTmpltList(CmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
    	return "msg/main/msg_tmplt_list";
    }
    
    @RequestMapping(value="/msgAutoAlimDlvrList.do")
    public String msgAutoAlimDlvrList(CmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
    	
    	return "msg/main/msg_auto_alim_dlvr_list";
    }
    
    @RequestMapping(value="/msgDlvrHistList.do")
    public String msgDlvrHistList(CmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
    	return "msg/main/msg_dlvr_hist_list";
    }
    
    @RequestMapping(value="/msgMngPopView.do")
    public String msgMngPopView(CmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
    	return "msg/popup/msg_mng_pop_view";
    }
    
    @RequestMapping(value="/msgAlimRcvStsList.do")
    public String msgAlimRcvStsList(CmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("vo", vo);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
    	
    	return "msg/main/msg_alim_rcv_sts_list";
    }
}
