package knou.lms.crs.termlink.web;

import java.nio.file.AccessDeniedException;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.BadRequestException;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.SessionBrokenException;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.termlink.service.TermLinkMgrResultService;
import knou.lms.crs.termlink.service.TermLinkMgrService;
import knou.lms.crs.termlink.service.TermLinkService;
import knou.lms.crs.termlink.vo.TermLinkMgrResultVO;
import knou.lms.crs.termlink.vo.TermLinkMgrVO;
import knou.lms.crs.termlink.vo.TermLinkVO;

@Controller
@RequestMapping(value="/crs/termLinkMgr")
public class TermLinkMgrController extends ControllerBase {
    
    @Resource(name="termLinkMgrService")
    private TermLinkMgrService termLinkMgrService;
    
    @Resource(name="termLinkMgrResultService")
    private TermLinkMgrResultService termLinkMgrResultService;
    
    @Resource(name="termLinkService")
    private TermLinkService termLinkService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    /*****************************************************
     * TODO 관리자 > 학사 연동 메인 페이지
     * @param TermLinkVO
     * @return "crs/termlink/term_link_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/termLinkMain")
    public String termLinkForm(TermLinkVO vo, Map commandMap, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale   = LocaleUtil.getLocale(request);
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId    = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        //권한 체크
        if("".equals(userId)) {
            throw new SessionBrokenException(messageSource.getMessage("system.fail.session.expire", null, locale));/* 세션이 만료되었습니다. */
        } else if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        } else {
            // 연동 정보 조회
            TermLinkMgrVO termLinkMgrVO = new TermLinkMgrVO();
            termLinkMgrVO = termLinkMgrService.select(termLinkMgrVO);
            
            request.setAttribute("autoLinkYn", termLinkMgrVO.getAutoLinkYn());
            request.setAttribute("lastLinkDttm", termLinkMgrVO.getLastLinkDttm());
            request.setAttribute("termCd", vo.getTermCd());
            request.setAttribute("orgId", orgId);
            request.setAttribute("menuType", "ADM");
            request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        }
        
        return "crs/termlink/term_link_form";
    }
    
    /*****************************************************
     * TODO 관리자 > 학사 연동 팝업
     * @param TermLinkVO
     * @return "crs/termlink/term_link_form"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/termLinkPop")
    public String termLinkPop(TermLinkVO vo, Map commandMap, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale   = LocaleUtil.getLocale(request);
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        //권한 체크
        if("".equals(userId)) {
            throw new SessionBrokenException(messageSource.getMessage("system.fail.session.expire", null, locale));/* 세션이 만료되었습니다. */
        } else if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        } else {
            // 연동 정보 조회
            TermLinkMgrVO termLinkMgrVO = new TermLinkMgrVO();
            termLinkMgrVO = termLinkMgrService.select(termLinkMgrVO);
            
            request.setAttribute("autoLinkYn", termLinkMgrVO.getAutoLinkYn());
            request.setAttribute("lastLinkDttm", termLinkMgrVO.getLastLinkDttm());
            request.setAttribute("termCd", vo.getTermCd());
        }
        
        return "crs/termlink/popup/term_link_pop";
    }
    
    /***************************************************** 
     * TODO 학사 연동
     * @param TermLinkVO 
     * @return ProcessResultVO<TermLinkVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/termLink.do")
    @ResponseBody
    public ProcessResultVO<TermLinkVO> termLink(TermLinkVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<TermLinkVO> resultVO = new ProcessResultVO<TermLinkVO>();
        Locale locale   = LocaleUtil.getLocale(request);
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        //권한 체크
        if("".equals(userId)) {
            throw new SessionBrokenException(messageSource.getMessage("system.fail.session.expire", null, locale));/* 세션이 만료되었습니다. */
        } else if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        } else {
            try {
                if(ValidationUtils.isEmpty(StringUtil.nvl(vo.getLinkType()))) {
                    throw new BadRequestException(messageSource.getMessage("system.fail.badrequest.nomethod", null, locale));/* 잘못된 요청으로 오류가 발생하였습니다. */
                }
                vo.setUserId(userId);
                termLinkService.runLink(vo);
                resultVO.setResult(1);
            } catch(Exception e) {
                resultVO.setResult(-1);
                resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
            }
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 학사 연동 관리 정보 수정
     * @param TermLinkVO 
     * @return ProcessResultVO<TermLinkVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editMgr.do")
    @ResponseBody
    public ProcessResultVO<TermLinkVO> editMgr(TermLinkMgrVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<TermLinkVO> resultVO = new ProcessResultVO<TermLinkVO>();
        Locale locale   = LocaleUtil.getLocale(request);
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        //권한 체크
        if("".equals(userId)) {
            throw new SessionBrokenException(messageSource.getMessage("system.fail.session.expire", null, locale));/* 세션이 만료되었습니다. */
        } else if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        } else {
            try {
                if(ValidationUtils.isEmpty(StringUtil.nvl(vo.getAutoLinkYn()))) {
                    throw new BadRequestException(messageSource.getMessage("system.fail.badrequest.nomethod", null, locale));/* 잘못된 요청으로 오류가 발생하였습니다. */
                }
                vo.setMdfrId(userId);
                termLinkMgrService.update(vo);
                resultVO.setResult(1);
            } catch(Exception e) {
                resultVO.setResult(-1);
                resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
            }
        }
        
        return resultVO;
    }
    
    /*****************************************************
     * TODO 관리자 > 학사 연동 결과 팝업
     * @param TermLinkVO
     * @return "crs/termlink/popup/term_link_mgr_result"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/termLinkMgrResultPop")
    public String termLinkMgrResultPop(TermLinkVO vo, Map commandMap, ModelMap model, 
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Locale locale   = LocaleUtil.getLocale(request);
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        //권한 체크
        if("".equals(userId)) {
            throw new SessionBrokenException(messageSource.getMessage("system.fail.session.expire", null, locale));/* 세션이 만료되었습니다. */
        } else if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        request.setAttribute("vo", vo);
        
        return "crs/termlink/popup/term_link_mgr_result_pop";
    }
    
    /***************************************************** 
     * TODO 학사 연동 결과 로그 페이징
     * @param TermLinkMgrResultVO 
     * @return ProcessResultVO<TermLinkMgrResultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/termLinkMgrResultListPaging.do")
    @ResponseBody
    public ProcessResultVO<TermLinkMgrResultVO> creCrsListPaging(TermLinkMgrResultVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<TermLinkMgrResultVO> resultVO = new ProcessResultVO<TermLinkMgrResultVO>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            resultVO = termLinkMgrResultService.listPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }

}
