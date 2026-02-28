package knou.lms.menu.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.service.OrgMenuService;
import knou.lms.common.vo.OrgMenuVO;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.menu.service.SysMenuService;
import knou.lms.menu.vo.MgrSysMenuVO;
import knou.lms.menu.vo.SysAuthGrpVO;
import knou.lms.menu.vo.SysMenuVO;

@Controller
@RequestMapping(value = "/menu/menuMgr")
public class SysMenuController extends ControllerBase {
    
    @Autowired @Qualifier("orgMenuService")
    private OrgMenuService orgMenuService;
    
    @Autowired @Qualifier("sysMenuService")
    private SysMenuService sysMenuService;
    
    private Logger logger = LoggerFactory.getLogger(getClass());
    
    /***************************************************** 
     * @Method Name : sysMenuMain
     * @Method 설명 : 시스템 관리 > 메뉴관리
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "menu/system_menu.jsp"
     * @throws Exception
     * /menu/menuMgr/sysMenuMain.do
     ******************************************************/
    @RequestMapping(value="/sysMenuMain.do")
    public String sysMenuMain(OrgMenuVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request), "SUP"); 
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        
        String orgId = SessionInfo.getOrgId(request);
        vo.setAuthrtGrpcd("ADM"); 
        vo.setAuthrtCd(userType);
        vo.setParMenuCd(""); //-- 최상위 메뉴
        vo.setOrgId(orgId);
        
        SysAuthGrpVO sagvo = new SysAuthGrpVO();
        sagvo.setOrgId(orgId);
        sagvo.setAuthrtGrpcd(StringUtil.nvl(vo.getAuthrtGrpcd(),"ADM")); //-- 홈페이지
        
        //--홈페이지 권한 목록 가져오기
        List<SysAuthGrpVO> authGrpList = sysMenuService.selectListAuthGrp(sagvo).getReturnList();
        request.setAttribute("authGrpList", authGrpList);
        
        //--메뉴 리스트 조회
        ProcessResultListVO<OrgMenuVO> resultList = orgMenuService.listTreeMenu(vo);
        if(StringUtils.isEmpty(vo.getAuthrtCd())) {
            vo.setAuthrtCd(userType);
        }
        
        request.setAttribute("menuList", resultList.getReturnList());
        request.setAttribute("authGrpCd", vo.getAuthrtCd());

        request.setAttribute("vo", vo);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        
        return "menu/system_menu";
    }   
    
    /*****************************************************
     * 관리자 메뉴 조회
     * @param request
     * @param response
     * @param model
     * @param SysMenuVO
     * @return List<MgrSysMenuVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/sysMenuList.do")
    @ResponseBody
    public List<MgrSysMenuVO> sysMenuList(HttpServletRequest request, HttpServletResponse response, ModelMap model, SysMenuVO vo) throws Exception {
        List<MgrSysMenuVO> resultList = sysMenuService.selectSysMenulist(vo); 
        return resultList;
    }
    
    /*****************************************************
     * 관리자 메뉴 사용 유무 저장
     * @param request
     * @param response
     * @param model
     * @param SysMenuVO
     * @return int
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/updateSysMenuListUseYn.do")
    @ResponseBody
    public ProcessResultVO<SysMenuVO> updateSysMenuListUseYn(@RequestBody SysMenuVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysMenuVO> resultVO = new ProcessResultVO<>();
        
        try {
            vo.setMdfrId(SessionInfo.getUserId(request));
            sysMenuService.updateSysMenuListUseYn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }

}
