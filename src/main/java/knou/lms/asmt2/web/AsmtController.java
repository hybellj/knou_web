package knou.lms.asmt2.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.ValidationUtils;
import knou.lms.asmt2.service.AsmtService;
import knou.lms.asmt2.vo.AsmtVO;
import knou.lms.common.vo.ProcessResultVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping(value="/asmt2")
public class AsmtController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(AsmtController.class);

    /**
     * 과제 정보 service
     */
    @Resource(name="asmt2Service")
    private AsmtService asmtService;

    /**
     * 교수 과제 목록 화면
     *
     * @param request
     * @param model
     * @param asmtVO
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtListView.do")
    public String profAsmtListView(HttpServletRequest request, ModelMap model, AsmtVO asmtVO) throws Exception {
        String sbjctId = asmtVO.getSbjctId();

        if(ValidationUtils.isEmpty(sbjctId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        asmtVO.setOrgId(SessionInfo.getOrgId(request));
        asmtVO.setRgtrId(SessionInfo.getUserId(request));

        //asmtService.chkNewStd(asmtVO);

        asmtVO.setSbjctId(sbjctId);
        model.addAttribute("asmtVO", asmtVO);

        return "asmt2/prof_asmt_list_view";
    }

    /**
     * 교수 과제목록 AJAX
     *
     * @param request
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtListAjax(HttpServletRequest request, ModelMap model, AsmtVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        if(ValidationUtils.isEmpty(vo.getSbjctId())) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        try {
            vo.setOrgId(SessionInfo.getOrgId(request));
            resultVO = asmtService.asmtListPaging(vo);
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

    /**
     * 교수 과제 성적반영비율 수정 AJAX
     *
     * @param request
     * @param response
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profMrkRfltrtModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> profMrkRfltrtModifyAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setMdfrId(SessionInfo.getUserId(request));

        return asmtService.mrkRfltrtModify(vo);
    }

    /**
     * 교수 과제 성적공개여부 수정
     *
     * @param request
     * @param response
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtMrkOynModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> profAsmtMrkOynModifyAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model, AsmtVO vo) throws Exception {
        vo.setMdfrId(SessionInfo.getUserId(request));
        return asmtService.mrkOynModify(vo);
    }

    /**
     * 교수 과제등록 화면
     *
     * @param request
     * @param model
     * @param asmtVO
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtRegistView.do")
    public String profAsmtRegistView(HttpServletRequest request, ModelMap model, AsmtVO asmtVO) throws Exception {
        String sbjctId = asmtVO.getSbjctId();

        if(ValidationUtils.isEmpty(sbjctId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        model.addAttribute("mode", "A");    // 수정: E, 등록: A
        model.addAttribute("asmtVO", asmtVO);

        return "asmt2/prof_asmt_write_view";
    }

    /**
     * 교수 과제수정 화면
     *
     * @param request
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtModifyView.do")
    public String profAsmtModifyView(HttpServletRequest request, ModelMap model, AsmtVO vo) throws Exception {
        String sbjctId = vo.getSbjctId();
        String asmtId = vo.getAsmtId();

        if(ValidationUtils.isEmpty(sbjctId) || ValidationUtils.isEmpty(asmtId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        EgovMap asmtVO = (EgovMap) asmtService.asmtSelect(vo).getReturnVO();
        model.addAttribute("mode", "E");    // 수정: E, 등록: A
        model.addAttribute("asmtVO", asmtVO);

        return "asmt2/prof_asmt_write_view";
    }

    /**
     * 교수 과제 상세 화면
     *
     * @param request
     * @param model
     * @param asmtVO
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtView.do")
    public String profAsmtView(HttpServletRequest request, ModelMap model, AsmtVO asmtVO) throws Exception {
        String sbjctId = asmtVO.getSbjctId();
        String asmtId = asmtVO.getAsmtId();

        if(ValidationUtils.isEmpty(sbjctId) || ValidationUtils.isEmpty(asmtId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }


        return "asmt2/prof_asmt_view";
    }


}
