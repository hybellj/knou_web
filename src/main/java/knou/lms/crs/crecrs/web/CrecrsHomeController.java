package knou.lms.crs.crecrs.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.CommonUtil;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsTchRltnVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrUserInfoVO;

@Controller
@RequestMapping(value= "/crs/creCrsHome")
public class CrecrsHomeController extends ControllerBase {
    private Logger log = LoggerFactory.getLogger(getClass());
    
    @Resource(name = "crecrsService")
    private CrecrsService crecrsService;
    
    @Resource(name = "orgCodeService")
    private OrgCodeService orgCodeService;
    
    @Resource(name = "usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;
    
    @Resource(name = "logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;
    
    @Resource(name = "termService")
    private TermService termService;


    /**
     * @Method Name : 마이페이지 > 공개강의 목록 폼
     * @Method 설명 : 마이페이지 > 공개강의 목록 폼
     * @param  
     * @param commandMap
     * @param model
     * @return  "/crs/crecrs/home_crecrs_open_list.jsp"
     * @throws Exception 
     */
    @RequestMapping(value = "/Form/stdCreCrsList.do")
    public String stdCreCrsList(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        List<OrgCodeVO> crsTypeList = orgCodeService.selectOrgCodeList(vo);

        //학기제 > 학기 구분값(정규, 비정규 코드값)
        List<OrgCodeVO> crsOperCdList = orgCodeService.selectOrgCodeList("TERM_TYPE");
        
        //강의실 타입(online, offline, mix)
        List<OrgCodeVO> learningTypeList = orgCodeService.selectOrgCodeList("LEARNING_TYPE");
        
        //-- 시작년도 가져오기
        String curYear = DateTimeUtil.getYear();
        List<String> yearList = new ArrayList<String>();
        for(int i= Integer.parseInt(curYear,10)+1; i >= Integer.parseInt("2012",10); i--) {
            yearList.add(Integer.toString(i));
        }
        //-- 현재의 년도를 Attribute에 세팅한다.
        model.addAttribute("curYear", curYear);
        model.addAttribute("yearList", yearList);
        
        //맨 처음 들어올때 세팅(운영중인 대학으로 세팅)
        if(StringUtils.isEmpty(vo.getCrsTypeCd())) {
            vo.setCrsTypeCd("UNI");
            vo.setTermStatus("SERVICE");
        }
        
        model.addAttribute("crsTypeList", crsTypeList);
        model.addAttribute("termTypeList", crsOperCdList);
        model.addAttribute("learningTypeList", learningTypeList);
        model.addAttribute("creCrsVo", vo);
        
        return "crs/crecrs/home_user_crecrs_list";
    }
    
    	
    @RequestMapping(value = "/Form/selectStdCreCrsList.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> selectStdCreCrsList(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVo = crecrsService.selectStdCreCrsList(vo);
    	
        return resultVo;
    }
    
    @RequestMapping(value = "/listTchCrsCreByTerm.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> listTchCrsCreByTerm(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setUserId(userId);
            List<CreCrsVO> list = crecrsService.listTchCrsCreByTerm(vo);

            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
    
    @RequestMapping(value = "/listCrsCreByTerm.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> listCrsCreByTerm(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();
        
        try {
            List<CreCrsVO> list = crecrsService.listCrsCreByTerm(vo);

            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
    
    /*****************************************************
     * 조교/교수 관리 목록 페이지
     * @param CreCrsVO
     * @return "crs/crstch/crecrs_tch_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/creCrsTchList.do")
    public String creCrsTchListForm(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd  = vo.getCrsCreCd();
        
        if(menuType.contains("USR")) {
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_COURSE_INFO, "교수/조교정보 확인");
        }
        
        vo.setCrsCreCd(crsCreCd);
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.select(vo);
        
        model.addAttribute("vo", vo);
        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("crsCreCd", crsCreCd);
        model.addAttribute("tchTypeList", orgCodeService.selectOrgCodeList("CRE_TCH_TYPE"));
        
        return "crs/crstch/crecrs_tch_list";
    }
    
    /*****************************************************
     * 조교/교수 관리 목록 가져오기
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsTchRltnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/creCrsTchList.do")
    @ResponseBody
    public ProcessResultVO<CreCrsTchRltnVO> creCrsTchList(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsTchRltnVO> resultVO = new ProcessResultVO<>();
        String crsCreCds = vo.getCrsCreCds();
            
        try {
            if(ValidationUtils.isNotEmpty(crsCreCds)) {
                vo.setSqlForeach(crsCreCds.split(","));
            }
            
            List<CreCrsTchRltnVO> list = crecrsService.listCrecrsTch(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
    
    /*****************************************************
     * 조교/교수 추가 팝업
     * @param CreCrsVO
     * @return "crs/crstch/popup/add_tch_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addTchPop.do")
    public String addTchPop(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        request.setAttribute("vo", vo);
        
        return "crs/crstch/popup/add_tch_pop";
    }
    
    /*****************************************************
     * 사용자와 동일 학과 교수 목록 가져오기
     * @param CreCrsTchRltnVO
     * @return ProcessResultVO<CreCrsTchRltnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/creCrsTchListByMenuType.do")
    @ResponseBody
    public ProcessResultVO<CreCrsTchRltnVO> creCrsTchListByMenuType(CreCrsTchRltnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsTchRltnVO> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setUserId(userId);
            resultVO = crecrsService.listCrecrsTchByMenuType(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
    
    /*****************************************************
     * 사용자 학과와 동일한 과목 목록 페이징
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listCrecrsByUserDept.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> listCrecrsByUserDept(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        
        try {
            vo.setOrgId(orgId);
            resultVO = crecrsService.listCrecrsByUserDept(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
    
    /*****************************************************
     * 조교/교수 등록
     * @param CreCrsTchRltnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/insertCrecrsTch.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> insertCrecrsTch(CreCrsTchRltnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            crecrsService.insertCrecrsTch(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
    
    /*****************************************************
     * 조교/교수 정보 수정 팝업
     * @param CreCrsVO
     * @return "crs/crstch/popup/add_tch_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editTchPop.do")
    public String editTchPop(CreCrsTchRltnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        vo = crecrsService.selectCrecrsTch(vo);
        request.setAttribute("vo", vo);
        
        return "crs/crstch/popup/edit_tch_pop";
    }
    
    /*****************************************************
     * 조교/교수 수정
     * @param CreCrsTchRltnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/updateCrecrsTch.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateCrecrsTch(CreCrsTchRltnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setMdfrId(userId);
            crecrsService.updateCrecrsTch(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
    
    /*****************************************************
     * 조교/교수 삭제
     * @param CreCrsTchRltnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/deleteCrecrsTch.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> deleteCrecrsTch(CreCrsTchRltnVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        
        try {
            crecrsService.deleteCrecrsTch(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
    
    /*****************************************************
     * 조교/교수 정보 간편 수정
     * @param UsrUserInfoVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editSimpleUserInfo.do")
    @ResponseBody
    public ProcessResultVO<UsrUserInfoVO> editSimpleUserInfo(UsrUserInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();
        String connIp = StringUtil.nvl(CommonUtil.getIpAddress(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setSubParam("SIMPLE");
            resultVO = usrUserInfoService.editUserInfo(vo, "AE", connIp);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }

    /*****************************************************
     * 분반 체크
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/checkDeclsNoList.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> checkDeclsNoList(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> returnVo = new ProcessResultVO<CreCrsVO>();
        List<CreCrsVO> declsNoList = new ArrayList<CreCrsVO>();
        List<String> dNoList = new ArrayList<String>();
        try {
            declsNoList = crecrsService.listCreCrsDeclsNo(vo);
            List<String> setDeclsList = new ArrayList<String>();
            for(int i= 1; i <= 20; i++) {
                setDeclsList.add(""+i);
            }
            for(CreCrsVO ccVo : declsNoList) {
                dNoList.add(ccVo.getDeclsNo());          
            }
            setDeclsList.removeAll(dNoList);
            vo.setDeclsList(setDeclsList);
            returnVo.setResult(1);
            returnVo.setReturnVO(vo);
        } catch (Exception e) {
            returnVo.setResult(-1);
        }
        
        return returnVo;
    }

    /**
     * @Method Name : checkDeclsCnt
     * @Method 설명 : 분반 중복 체크
     * @param  CreCrsVO
     * @param commandMap
     * @param model
     * @param request
     * @return  
     * @throws Exception
     */
    @RequestMapping(value="/checkDeclsCnt.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> checkDeclsCnt(CreCrsVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        ProcessResultVO<CreCrsVO> returnVO = new ProcessResultVO<>();
        try {
            int dupCnt = crecrsService.checkDeclsCnt(vo);
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setDeclsCnt(dupCnt);
            returnVO.setReturnVO(creCrsVO);
            returnVO.setResult(1);
        } catch (Exception e) {
            returnVO.setResult(-1);
            returnVO.setMessage(getCommonFailMessage());
        }
        return returnVO;
    }
    
    /***************************************************** 
     * 교수 개설과목
     * @param CreCrsVO 
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/creCrsList.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> creCrsList(CreCrsVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            if("".equals(StringUtil.nvl(vo.getSearchFrom()))) {
                vo.setUserId(userId);
            } else if("ALL".equals(StringUtil.nvl(vo.getSearchFrom()))) {
                if(!"".equals(StringUtil.nvl(vo.getCrsTypeCd()))) {
                    String[] crsTypeCds = vo.getCrsTypeCd().split("\\,");
                    vo.setCrsTypeCdList(crsTypeCds);
                }
                vo.setCrsTypeCd("");
            }
            resultVO = crecrsService.listCreCrs(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 권한별 학기 개설과목 목록
     * @param CreCrsVO 
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listAuthCrsCreByTerm.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> listAuthCrsCreByTerm(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        try {
            vo.setSearchKey(authGrpCd.contains("TUT") ? "ASSISTANT" : "PROF");
            if(menuType.contains("ADM") && !menuType.contains("PROF")) vo.setSearchKey(null);
            vo.setUserId(userId);
            List<CreCrsVO> list = crecrsService.listAuthCrsCreByTerm(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 대표교수 개설과목 목록
     * @param CreCrsVO 
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listRepUserCrsCreByTerm.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> listRepUserCrsCreByTerm(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<>();
        
        String repUserId = vo.getRepUserId();
        
        try {
            vo.setSearchKey("PROF");
            vo.setUserId(repUserId);
            List<CreCrsVO> list = crecrsService.listAuthCrsCreByTerm(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }

    
    /***************************************************** 
     * 강의실 드롭다운 목록
     * @param CreCrsVO 
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listCrsCreDropdown.do")
    @ResponseBody
    public ProcessResultVO<CreCrsVO> listCrsCreDropdown(CreCrsVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            List<CreCrsVO> list = crecrsService.listCrsCreDropdown(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 이전과목 가져오기
     * @param vo
     * @param model
     * @param request
     * @return "crs/crecrs/copy_prev_course"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/copyPrevCourse.do")
    public String importPrevCourseForm(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd  = vo.getCrsCreCd();
        String prevCourseYn = SessionInfo.getPrevCourseYn(request);
        
        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        
        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        
        String haksaYear = termVO.getHaksaYear();
        String haksaTerm = termVO.getHaksaTerm();
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.select(creCrsVO);
        
        String prevYear = creCrsVO.getCreYear();
        String prevTerm = creCrsVO.getCreTerm();
        
        if("21".equals(haksaTerm)) {
            prevTerm = "20";
        } else if("20".equals(haksaTerm)) {
            prevTerm = "11";
        } else if("11".equals(haksaTerm)) {
            prevTerm = "10";
        } else if("10".equals(haksaTerm)) {
            prevTerm = "21";
            Integer year = Integer.valueOf(haksaYear) - 1;
            prevYear = year.toString();
        }
        
        model.addAttribute("termVO", termVO);
        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "m"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("prevYear", prevYear);
        model.addAttribute("prevTerm", prevTerm);
        model.addAttribute("prevCourseYn", prevCourseYn);
        
        model.addAttribute("vo", vo);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("crsCreCd", crsCreCd);
        
        return "crs/crecrs/copy_prev_course";
    }
    
    /***************************************************** 
     * 이전과목 가져오기
     * @param vo 
     * @param model 
     * @param request 
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/copyPrevCourse.do")
    @ResponseBody
    public ProcessResultVO<Map<String, Object>> copyPrevCourse(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<Map<String, Object>> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String userId = SessionInfo.getUserId(request);
        String crsCreCd  = vo.getCrsCreCd();
        String copyCrsCreCd = request.getParameter("copyCrsCreCd");
        String gubun = vo.getGubun();
        
        try {
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(gubun) || ValidationUtils.isEmpty(copyCrsCreCd) || crsCreCd.equals(copyCrsCreCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            
            if(!menuType.contains("PROF")) {
                // 페이지 접근 권한이 없습니다.
                throw new AccessDeniedException(getCommonNoAuthMessage());
            }
            
            vo.setOrgId(orgId);
            vo.setRgtrId(userId);
            Map<String, Object> resultMap = crecrsService.copyPrevCourse(vo, copyCrsCreCd);
            resultVO.setReturnVO(resultMap);
            resultVO.setResult(1);
        } catch(MediopiaDefineException | EgovBizException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            log.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 사용자 학기별 대학구분 조회 
     * @param vo 
     * @param model 
     * @param request 
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listUserUnivGbn.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> listUserUnivGbn(CreCrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        
        try {
            resultVO.setReturnList(crecrsService.listUserUnivGbn(request, vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            log.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        
        return resultVO;
    }
}
