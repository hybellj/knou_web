package knou.lms.asmt2.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.ValidationUtils;
import knou.lms.asmt2.service.AsmtService;
import knou.lms.asmt2.vo.AsmtVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.user.CurrentUser;
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
import java.util.List;

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
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtListView.do")
    public String profAsmtListView(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {
        String sbjctId = vo.getSbjctId();

        if(ValidationUtils.isEmpty(sbjctId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        vo.setRgtrId(userCtx.getUserId());

        //asmtService.chkNewStd(asmtVO);

        model.addAttribute("asmtVO", vo);

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
    public ProcessResultVO<EgovMap> profAsmtListAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        if(ValidationUtils.isEmpty(vo.getSbjctId())) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        try {
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
    public ProcessResultVO<AsmtVO> profMrkRfltrtModifyAjax(AsmtVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
    public ProcessResultVO<AsmtVO> profAsmtMrkOynModifyAjax(AsmtVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        vo.setMdfrId(SessionInfo.getUserId(request));
        return asmtService.mrkOynModify(vo);
    }

    /**
     * 교수 과제등록 화면
     *
     * @param request
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtRegistView.do")
    public String profAsmtRegistView(AsmtVO vo, HttpServletRequest request, ModelMap model) throws Exception {
        String sbjctId = vo.getSbjctId();

        if(ValidationUtils.isEmpty(sbjctId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 분반목록
        List<EgovMap> dvclasList = asmtService.dvclasList(vo);

        model.addAttribute("mode", "A");    // 수정: E, 등록: A
        model.addAttribute("asmtVO", vo);
        model.addAttribute("dvclasList", dvclasList);

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
    public String profAsmtModifyView(AsmtVO vo, HttpServletRequest request, ModelMap model) throws Exception {
        String sbjctId = vo.getSbjctId();
        String asmtId = vo.getAsmtId();

        if(ValidationUtils.isEmpty(sbjctId) || ValidationUtils.isEmpty(asmtId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 분반목록
        List<EgovMap> dvclasList = asmtService.dvclasList(vo);

        EgovMap asmtVO = (EgovMap) asmtService.asmtSelect(vo).getReturnVO();
        model.addAttribute("mode", "E");    // 수정: E, 등록: A
        model.addAttribute("dvclasList", dvclasList);
        model.addAttribute("asmtVO", asmtVO);

        return "asmt2/prof_asmt_write_view";
    }

    /**
     * 교수 과제 상세 화면
     *
     * @param request
     * @param model
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtView.do")
    public String profAsmtView(AsmtVO vo, HttpServletRequest request, ModelMap model) throws Exception {
        String sbjctId = vo.getSbjctId();
        String asmtId = vo.getAsmtId();

        if(ValidationUtils.isEmpty(sbjctId) || ValidationUtils.isEmpty(asmtId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

// TODO: 상세화면, 현재 수정화면으로 임시 변경

//        return "asmt2/prof_asmt_view";
        model.addAttribute("asmtVO", vo);
        model.addAttribute("mode", "E");
        return "asmt2/prof_asmt_write_view";
    }

    /**
     * 학습그룹 팀 목록 조회(팀 부주제 설정용)
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtLrnGrpTeamListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtLrnGrpTeamListAjax(AsmtVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        try {
            resultVO.setReturnList(asmtService.lrnGrpTeamList(vo));
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /**
     * 개별과제 수강생 목록 조회
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profIndivAsmtStdListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profIndivAsmtStdListAjax(AsmtVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        try {
            resultVO.setReturnList(asmtService.indivStdList(vo));
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /**
     * 교수 개별 과제 제출 대상 목록 AJAX
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profIndivAsmtSbmsnTrgtListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profIndivAsmtSbmsnTrgtListAjax(AsmtVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        try {
            resultVO.setReturnList(asmtService.indivSbmsnTrgt(vo).getReturnList());
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /**
     * 교수 과제 조회 AJAX
     *
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profAsmtSelectAjax(AsmtVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        try {
            resultVO.setReturnVO(asmtService.asmtSelect(vo).getReturnVO());
            resultVO.setResultSuccess();
        } catch(Exception e) {
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }


    /**
     * 교수 과제 등록
     *
     * @param vo
     * @param userCtx
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/profAsmtRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<AsmtVO> profAsmtRegistAjax(AsmtVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();
        vo.setUserId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());

        try {
            asmtService.profAsmtRegist(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

}
