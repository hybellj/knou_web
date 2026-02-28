package knou.lms.sch.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.sch.service.PopupNoticeService;
import knou.lms.sch.vo.PopupNoticeVO;

@Controller
@RequestMapping(value = "/sch/schHome")
public class SchHomeController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(SchHomeController.class);
    
    @Resource(name = "popupNoticeService")
    private PopupNoticeService popupNoticeService;
    
    /***************************************************** 
     * 일정관리 > 팝업관리 미리보기
     * @param vo
     * @param model
     * @param request
     * @return "sch/popup/popup_notice_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/popupNoticeViewPop.do")
    public String popupNoticeViewPop(PopupNoticeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        String orgId = SessionInfo.getOrgId(request);
        String popNoticeSn = vo.getPopupNtcId();

        if(ValidationUtils.isEmpty(popNoticeSn)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        
        vo.setOrgId(orgId);
        
        PopupNoticeVO popupNoticeVO = popupNoticeService.select(vo);
            
        if(popupNoticeVO == null) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        
        if("EVAL".equals(popupNoticeVO.getPopupNtcId())) {
            model.addAttribute("lectEvalPopUrl", vo.getLectEvalUrl());
        }
        
        model.addAttribute("popupNoticeVO", popupNoticeVO);
        model.addAttribute("vo", vo);
        
        return "sch/popup/popup_notice_view";
    }
    
    /***************************************************** 
     * 일정관리 > 활성 팝업 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectActivePop.do")
    @ResponseBody
    public ProcessResultVO<PopupNoticeVO> selectActivePop(PopupNoticeVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<PopupNoticeVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
           
            resultVO.setReturnVO(popupNoticeService.selectAcitvePop(request, vo));
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }
}
