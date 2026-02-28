package knou.lms.erp.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.erp.service.ErpService;
import knou.lms.erp.vo.AlarmMainVO;
import knou.lms.erp.vo.ErpMessageMsgVO;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrUserInfoVO;

@Controller
@RequestMapping(value = "/erp")
public class ErpController extends ControllerBase {
    
    @Resource(name = "erpService")
    private ErpService erpService;
    
    @Resource(name = "usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;

    private static final Logger LOGGER = LoggerFactory.getLogger(ErpController.class);

    /***************************************************** 
     * Erp 쪽지보내기 팝업
     * @param vo
     * @param model
     * @param request
     * @return "erp/popup/send_erp_message_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/sendErpMessagePop.do")
    public String sendErpMessagePop(DefaultVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        model.addAttribute("vo", vo);
        
        return "erp/popup/send_erp_message_pop";
    }
    
    /***************************************************** 
     * Erp 쪽지보내기
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/sendErpMessage.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<ErpMessageMsgVO> sendErpMessage(ErpMessageMsgVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ErpMessageMsgVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        
        String ctnt = vo.getCtnt();
        
        try {
            vo.setOrgId(orgId);
            
            // 파라미터 체크
            if(ValidationUtils.isEmpty(vo.getUserId())) {
                // 잘못된 요청으로 오류가 발생하였습니다.
                throw new BadRequestUrlException(getMessage("system.fail.badrequest.nomethod"));
            }
            
            // 파라미터 체크
            if(ValidationUtils.isEmpty(ctnt)) {
                // 내용을 입력하세요.
                throw new BadRequestUrlException(getMessage("common.empty.msg"));
            }
            
            UsrUserInfoVO resvUserInfoVO = new UsrUserInfoVO();
            resvUserInfoVO.setOrgId(orgId);
            resvUserInfoVO.setUserId(vo.getUserId());
            resvUserInfoVO = usrUserInfoService.selectUserRecvInfo(resvUserInfoVO);
            
            if(resvUserInfoVO == null) {
                // 발송대상자를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("common.message.not.found.recv.user"));
            }
            
            vo.setUserNm(resvUserInfoVO.getUserNm());
            
            erpService.insertUserMessageMsg(request, vo, "LMS 쪽지보내기 팝업 발송");
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    
    /***************************************************** 
     * Erp SMS 직접 보내기 팝업
     * @param vo
     * @param model
     * @param request
     * @return "erp/popup/send_erp_message_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/directSendMsgPop.do")
    public String directSendMsgPop(AlarmMainVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        
        model.addAttribute("vo", vo);
        
        return "erp/popup/direct_send_msg_pop";
    }
    
    /***************************************************** 
     * Erp SMS 보내기
     * @param vo
     * @param model
     * @param request
     * @return result
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/directSendMsg.do")
    @ResponseBody
    public ProcessResultVO<AlarmMainVO> directSendMsg(AlarmMainVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	ProcessResultVO<AlarmMainVO> resultVO = new ProcessResultVO<>();
    	vo.setUserId(SessionInfo.getUserId(request));
    	vo.setUserNm(SessionInfo.getUserNm(request));
    	
    	erpService.directSendMsg(request, vo);
    	
    	resultVO.setResult(1);
        
        return resultVO;
    }
}