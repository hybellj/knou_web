package knou.lms.crs.rubric.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.*;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.rubric.service.RubricService;
import knou.lms.crs.rubric.vo.RubricVO;
import knou.lms.user.CurrentUser;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
@RequestMapping(value="/crs")
public class RubricController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(RubricController.class);

    @Resource(name="rubricService")
    private RubricService rubricService;

    /*****************************************************
     * 기본 루브릭
     * @param vo
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/defaultRubricView.do")
    public String defaultRubricView(RubricVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String sbjctId = StringUtil.nvl(getEncParam("sbjctId"));

        resetEncParam();
        addEncParam("userId", userId);
        if(!sbjctId.isEmpty()) addEncParam("sbjctId", sbjctId);

        vo.setUserId(userId);
        model.addAttribute("vo", vo);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("encParams", getEncParams());

        return "/crs/rubric/rubric_list_view";
    }

    /*****************************************************
     * 루브릭 [등록|수정] 페이지
     * @param vo
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/rubricWriteView.do")
    public String rubricWriteView(RubricVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
//        String userId = userCtx.getUserId();
        String orgId = userCtx.getOrgId();
        String isModify = null;

        RubricVO rubricDefaultInfoVO = null;
        List<EgovMap> rubricInfoVO = null;
        if(StringUtil.nvl(vo.getRubricId()).isEmpty()) {
            // 루브릭 ID가 공백일 경우 [등록]
            isModify = "N";
            rubricDefaultInfoVO = rubricService.selectRegisterInfo(vo);
        } else {
            // 루브릭 ID가 있을 경우 [수정]
            isModify = "Y";
            rubricDefaultInfoVO = rubricService.selectRubricRegistInfo(vo);
            rubricInfoVO = rubricService.listRubricInfo(vo);
        }

        String sbjctId = StringUtil.nvl(getEncParam("sbjctId"));
        addEncParam("rubricId", StringUtil.nvl(vo.getRubricId()));
        if(!sbjctId.isEmpty()) addEncParam("sbjctId", sbjctId);

        model.addAttribute("vo", vo);
        model.addAttribute("rubricDefaultInfoVO", rubricDefaultInfoVO);
        model.addAttribute("rubricInfoVO", rubricInfoVO);
        model.addAttribute("orgId", orgId);
        model.addAttribute("isModify", isModify);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("encParams", getEncParams());

        return "/crs/rubric/rubric_write";
    }

    /*****************************************************
     * 루브릭 가져오기 팝업
     * @param vo
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/rubricImportPopup.do")
    public String rubricImportPopup(RubricVO vo, ModelMap model, HttpServletRequest request) {
        // 다른 화면에서 사용 시 userId (현재 로그인 한 사용자가 반드시 필요하다..)
        model.addAttribute("vo", vo);
        return "/crs/rubric/popup/rubric_import_pop";
    }

    /*****************************************************
     * 루브릭 등록
     * @param vo
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/rubricRegist.do", method=RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<RubricVO> rubricRegist(RubricVO vo, ModelMap model, HttpServletRequest request) {
        ProcessResultVO<RubricVO> resultVO = new ProcessResultVO<RubricVO>();
        String userId = vo.getUserId();

        if(ValidationUtils.isEmpty(userId)) {
            throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
        }

        resultVO.setReturnVO(rubricService.rubricRegist(vo));
        resultVO.setResultSuccess();
        resultVO.setMessage(getMessage("success.common.save"));
        return resultVO;
    }

    /*****************************************************
     * 루브릭 목록 페이징
     * @param RubricVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/rubricPaging.do")
    @ResponseBody
    public ProcessResultVO<RubricVO> listRubricPaging(RubricVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<RubricVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        String rubricTtl = StringUtil.nvl(request.getParameter("rubricTtl"));

        String sbjctId = StringUtil.nvl(getEncParam("sbjctId"));
        vo.setRubricTtl(rubricTtl);

        addEncParam("rubricTtl", rubricTtl);
        if(!sbjctId.isEmpty()) addEncParam("sbjctId", sbjctId);

        resultVO = rubricService.listRubricPaging(vo);
        resultVO.setResultSuccess();
        resultVO.setEncParams(getEncParams());
        return resultVO;
    }

    /**
     * 루브릭 가져오기 목록 조회 (루브릭 관리자 등록 + 본인 등록 조회)
     *
     * @param vo
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     */
    @RequestMapping(value="/rubricImportList.do")
    @ResponseBody
    public ProcessResultVO<RubricVO> rubricImportList(RubricVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<RubricVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());

        resultVO.setReturnList(rubricService.importRubricList(vo));
        resultVO.setResultSuccess();
        return resultVO;
    }

    /*****************************************************
     * 루브릭 목록 조회
     * @param RubricVO
     * @param model
     * @param request
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/rubricList.do")
    @ResponseBody
    public List<EgovMap> listRubricInfo(RubricVO vo, ModelMap model, HttpServletRequest request) {
        List<EgovMap> resultVO = rubricService.listRubricInfo(vo);
        return resultVO;
    }

    /*****************************************************
     * 루브릭 수정
     * @param vo
     * @param model
     * @param request
     * @return view
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/rubricModify.do", method=RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<RubricVO> rubricModify(RubricVO vo, ModelMap model, HttpServletRequest request) {
        ProcessResultVO<RubricVO> resultVO = new ProcessResultVO<RubricVO>();
        String userId = vo.getUserId();

        if(ValidationUtils.isEmpty(userId)) {
            throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
        }

        resultVO.setReturnVO(rubricService.rubricModify(vo));
        resultVO.setResultSuccess();
        resultVO.setMessage(getMessage("success.common.save"));
        return resultVO;
    }

    /*****************************************************
     * 루브릭 사용여부 수정
     * @param RubricVO
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/rubricUseynModify.do", method=RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<RubricVO> rubricUseynModify(RubricVO vo, ModelMap model, HttpServletRequest request) {
        ProcessResultVO<RubricVO> resultVO = new ProcessResultVO<>();

        rubricService.rubricUseynModify(vo);
        resultVO.setResultSuccess();
        resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        return resultVO;
    }

    /*****************************************************
     * 루브릭 삭제
     * @param RubricVO
     * @return resultVO
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/rubricDelete.do", method=RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<RubricVO> rubricDelete(RubricVO vo, ModelMap model, HttpServletRequest request) {
        ProcessResultVO<RubricVO> resultVO = new ProcessResultVO<>();

        rubricService.rubricDelete(vo);
        resultVO.setResultSuccess();
        resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        return resultVO;
    }
}
