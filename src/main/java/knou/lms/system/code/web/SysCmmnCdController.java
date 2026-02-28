package knou.lms.system.code.web;

import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.StringUtil;
import knou.framework.util.LocaleUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.org.dao.OrgInfoDAO;
import knou.lms.system.code.service.SysCmmnCdService;
import knou.lms.system.code.vo.SysCmmnCdVO;
import knou.lms.user.dao.UsrDeptCdDAO;

@Controller
@RequestMapping(value = "/sys/mgr")
public class SysCmmnCdController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(SysCmmnCdController.class);
    
    @Resource(name="sysCmmnCdService")
    private SysCmmnCdService sysCmmnCdService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    // 기관 Select Box 세팅용
    @Resource(name="orgInfoDAO")
    private OrgInfoDAO orgInfoDAO;

    // 학과/부서 Select Box 세팅용
    @Resource(name="usrDeptCdDAO")
    private UsrDeptCdDAO usrDeptCdDAO;
    
    /***************************************************** 
     * 시스템 관리 > 공통코드 관리 페이지 이동
     * @param vo
     * @param model
     * @param request
     * @return "sys/cmmn/cd_mng_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/code.do")
    public String sysCmmnCdForm(SysCmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String authrtCd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!authrtCd.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale)); // 페이지 접근 권한이 없습니다.
        }
        model.addAttribute("vo", vo);
        System.out.println("model is : " + model);
        return "sys/cmmn/cd_mng_list";
    }

    /*****************************************************
     * 상위 코드 관련
     *****************************************************/

    /***************************************************** 
     * 시스템 상위 공통코드 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addSysCmmnUpCd.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<SysCmmnCdVO> insertSysCmmnUpCd(SysCmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysCmmnCdVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String rgtrId = SessionInfo.getUserId(request);
        Locale locale = LocaleUtil.getLocale(request);
        String langCd = locale.toString();
        String upCd = vo.getUpCd();
        String upCdnm = vo.getUpCdnm();

        vo.setOrgId(orgId);
        vo.setRgtrId(rgtrId);
        vo.setLangCd(langCd);
        vo.setUpCd(upCd);
        vo.setUpCdnm(upCdnm);
        try {
            sysCmmnCdService.insertSysCmmnUpCd(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {            
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /***************************************************** 
     * 시스템 상위 공통코드 목록 페이징
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/sysCmmnUpCdPaging.do")  
    @ResponseBody
    public ProcessResultVO<SysCmmnCdVO> listSysCmmnUpCdPaging(SysCmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysCmmnCdVO> resultVO = new ProcessResultVO<>();     
        String orgId = SessionInfo.getOrgId(request);
        String cdnm = vo.getCdnm();
        Boolean isUpCdSelect = true;

        vo.setOrgId(orgId);
        vo.setCdnm(cdnm);
        vo.setIsUpCdSelect(isUpCdSelect);
        try {       
            resultVO = sysCmmnCdService.listSysCmmnUpCdPaging(vo);
            resultVO.setResultSuccess(); // resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResultFailed(); // resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /***************************************************** 
     * 시스템 상위 공통코드 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editSysCmmnUpCd.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<SysCmmnCdVO> updateSysCmmnUpCd(SysCmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysCmmnCdVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String mdfrId = SessionInfo.getUserId(request);
        String updtUpCd = vo.getUpdtUpCd();
        String upCdnm = vo.getUpCdnm();
        String upCd = vo.getUpCd();
        String cmmnCdId = vo.getCmmnCdId();
        boolean isUpCdModify = true;

        vo.setOrgId(orgId);
        vo.setMdfrId(mdfrId);
        vo.setUpdtUpCd(updtUpCd);
        vo.setUpCdnm(upCdnm);
        vo.setUpCd(upCd);
        vo.setCmmnCdId(cmmnCdId);
        vo.setIsUpCdModify(isUpCdModify);
        try {
            sysCmmnCdService.updateSysCmmnUpCd(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {            
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /***************************************************** 
     * 시스템 상위 공통코드 삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/removeSysCmmnUpCd.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<SysCmmnCdVO> deleteSysCmmnUpCd(SysCmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysCmmnCdVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String upCd = vo.getUpCd();
        boolean isUpCdDelete = true;

        vo.setOrgId(orgId);
        vo.setUpCd(upCd);
        vo.setIsUpCdDelete(isUpCdDelete);
        try {
            sysCmmnCdService.deleteSysCmmnUpCd(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {            
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 하위 코드 관련
     *****************************************************/

    /***************************************************** 
     * 시스템 공통코드 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addSysCmmnCd.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<SysCmmnCdVO> insertSysCmmnCd(SysCmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysCmmnCdVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String rgtrId = SessionInfo.getUserId(request);
        Locale locale = LocaleUtil.getLocale(request);
        String langCd = locale.toString();
        String upCd = vo.getUpCd();
        String cd = vo.getCd();
        String cdnm = vo.getCdnm();

        vo.setOrgId(orgId);
        vo.setRgtrId(rgtrId);
        vo.setLangCd(langCd);
        vo.setUpCd(upCd);
        vo.setCd(cd);
        vo.setCdnm(cdnm);
        try {
            sysCmmnCdService.insertSysCmmnCd(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {            
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 시스템 공통코드 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/sysCmmnCdPaging.do") 
    @ResponseBody
    public ProcessResultVO<SysCmmnCdVO> listSysCmmnCdPaging(SysCmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysCmmnCdVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String cdnm = vo.getCdnm();
        String upCd = vo.getUpCd();
        Boolean isUpCdSelect = false;
        boolean isUpCdDelete = false;

        vo.setOrgId(orgId);
        vo.setCdnm(cdnm);
        vo.setUpCd(upCd);
        vo.setIsUpCdSelect(isUpCdSelect);
        vo.setIsUpCdDelete(isUpCdDelete);

        try {       
            resultVO = sysCmmnCdService.listSysCmmnCdPaging(vo);
            resultVO.setResultSuccess(); // resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResultFailed(); // resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /***************************************************** 
     * 시스템 공통코드 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editSysCmmnCd.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<SysCmmnCdVO> updateSysCmmnCd(SysCmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysCmmnCdVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String mdfrId = SessionInfo.getUserId(request);
        boolean isUpCdModify = false;
        String cd = vo.getCd();
        String cdnm = vo.getCdnm();
        int cdSeqno = vo.getCdSeqno();
        String useyn = vo.getUseyn();
        String upCd = vo.getUpCd();
        String cmmnCdId = vo.getCmmnCdId();

        vo.setOrgId(orgId);
        vo.setMdfrId(mdfrId);
        vo.setIsUpCdModify(isUpCdModify);
        vo.setCd(cd);
        vo.setCdnm(cdnm);
        vo.setCdSeqno(cdSeqno);
        vo.setUseyn(useyn);
        vo.setUpCd(upCd);
        vo.setCmmnCdId(cmmnCdId);
        try {
            sysCmmnCdService.updateSysCmmnCd(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {            
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }    

    /***************************************************** 
     * 시스템 공통코드 삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/removeSysCmmnCd.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<SysCmmnCdVO> deleteSysCmmnCd(SysCmmnCdVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysCmmnCdVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        boolean isUpCdDelete = false;
        String cmmnCdId = vo.getCmmnCdId();

        vo.setOrgId(orgId);
        vo.setIsUpCdDelete(isUpCdDelete);
        vo.setCmmnCdId(cmmnCdId);
        try {
            sysCmmnCdService.deleteSysCmmnCd(vo);
            resultVO.setResultSuccess();
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {            
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    } 
}

