package knou.lms.contents.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import knou.framework.common.ControllerBase;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.context2.UserContext;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.contents.excel.AdmContsExcelHandler;
import knou.lms.contents.facade.AdmContsViewFacadeService;
import knou.lms.contents.facade.ContsAuthHelper;
import knou.lms.contents.service.ContsService;
import knou.lms.contents.vo.ContsSbjctListVO;
import knou.lms.contents.vo.LctrContsVO;
import knou.lms.contents.vo.LctrWknoContsVO;
import knou.lms.contents.vo.LctrWknoSchdlVO;
import knou.lms.contents.web.paging.ContsExrcsQstnPageInfo;
import knou.lms.contents.web.paging.ContsPageInfo;
import knou.lms.contents.web.paging.ContsSddnQstnPageInfo;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value = "/contents/admConts")
public class AdmContsController extends ControllerBase {

    @Resource(name = "contsService")
    private ContsService contsService;

    @Resource(name = "admContsViewFacadeService")
    private AdmContsViewFacadeService admContsViewFacadeService;

    @Resource(name = "contsAuthHelper")
    private ContsAuthHelper contsAuthHelper;

    @Resource(name = "admContsExcelHandler")
    private AdmContsExcelHandler admContsExcelHandler;

    /**
     * 관리자 콘텐츠/학습목차 관리 목록 화면을 표시한다.
     * @param pageInfo
     * @param model
     * @param userCtx
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/admLctrContsListView.do")
    public String admLctrContsListView(
            ContsPageInfo pageInfo,
            ModelMap model,
            @CurrentUser UserContext userCtx) throws Exception {

        model.addAllAttributes(admContsViewFacadeService.listView(pageInfo, userCtx));
        return "contents/adm_lctr_conts_list_view";
    }

    /**
     * 검색 조건에 맞는 관리자 콘텐츠 관리 과목 목록을 조회한다.
     * @param pageInfo
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrContsSbjctList.do")
    @ResponseBody
    public ResultDTO<ContsSbjctListVO> admLctrContsSbjctList(
            ContsPageInfo pageInfo,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        pageInfo.setOrgId(contsAuthHelper.resolveSearchOrgId(pageInfo.getOrgId(), userCtx));
        pageInfo.setLangCd(userCtx.getLangCd());
        ResultDTO<ContsSbjctListVO> resultDTO = contsService.selectAdmLctrContsSbjctList(pageInfo);
        resultDTO.setEncParams(request.getParameter("encParams"));
        return resultDTO;
    }

    /**
     * 관리자 콘텐츠 관리 과목 목록을 엑셀로 다운로드한다.
     * @param pageInfo
     * @param model
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrContsSbjctListExcelDown.do")
    public String admLctrContsSbjctListExcelDown(
            ContsPageInfo pageInfo,
            ModelMap model,
            @CurrentUser UserContext userCtx) {

        model.addAllAttributes(admContsExcelHandler.listExcel(pageInfo, userCtx));

        return "excelView";
    }

    /**
     * 선택한 과목의 강의주차와 주차별 학습자료 목록을 조회한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrWknoContsList.do")
    @ResponseBody
    public ResultDTO<LctrWknoContsVO> admLctrWknoContsList(
            LctrWknoContsVO vo,
            @CurrentUser UserContext userCtx) {

        vo.setOrgId(contsAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx));
        return contsService.selectAdmLctrWknoContsList(vo);
    }

    /**
     * 관리자 학습목차 동영상 등록 팝업을 표시한다.
     * @param lctrContsVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrContsVideoRegistPop.do")
    public String admLctrContsVideoRegistPop(
            LctrContsVO lctrContsVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        model.addAllAttributes(admContsViewFacadeService.lctrContsVideoRegistPop(lctrContsVO, request, userCtx));
        model.addAttribute("encParams", request.getParameter("encParams"));

        return "contents/popup/adm_lctr_conts_video_regist_popview";
    }

    /**
     * 관리자 학습목차 연습문제 등록 팝업을 표시한다.
     * @param lctrContsVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrContsExrcsQstnRegistPop.do")
    public String admLctrContsExrcsQstnRegistPop(
            LctrContsVO lctrContsVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        model.addAllAttributes(admContsViewFacadeService.lctrContsExrcsQstnRegistPop(lctrContsVO, userCtx));
        model.addAttribute("encParams", request.getParameter("encParams"));

        return "contents/popup/adm_lctr_conts_exrcs_qntn_regist_popview";
    }

    /**
     * 관리자 학습목차 소셜 콘텐츠 등록 팝업을 표시한다.
     * @param lctrContsVO
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrContsSnsRegistPop.do")
    public String admLctrContsSnsRegistPop(
            LctrContsVO lctrContsVO,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        model.addAllAttributes(admContsViewFacadeService.lctrContsSnsRegistPop(lctrContsVO, request, userCtx));
        model.addAttribute("encParams", request.getParameter("encParams"));

        return "contents/popup/adm_lctr_conts_sns_regist_popview";
    }

    /**
     * 관리자 학습목차 돌발퀴즈 선택 팝업을 표시한다.
     * @param pageInfo
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrContsSddnQstnListPop.do")
    public String admLctrContsSddnQstnListPop(
            ContsSddnQstnPageInfo pageInfo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        model.addAllAttributes(admContsViewFacadeService.lctrContsSddnQstnListPop(pageInfo, userCtx));
        model.addAttribute("encParams", request.getParameter("encParams"));

        return "contents/popup/adm_lctr_conts_sddn_qntn_list_popview";
    }

    /**
     * 관리자 학습목차 돌발퀴즈 선택 목록을 조회한다.
     * @param pageInfo
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrContsSddnQstnList.do")
    @ResponseBody
    public ResultDTO<EgovMap> admLctrContsSddnQstnList(
            ContsSddnQstnPageInfo pageInfo,
            @CurrentUser UserContext userCtx) {

        pageInfo.setOrgId(contsAuthHelper.resolveSearchOrgId(pageInfo.getOrgId(), userCtx));
        pageInfo.setLangCd(userCtx.getLangCd());
        return contsService.selectAdmSddnQstnList(pageInfo);
    }

    /**
     * 관리자 학습목차 연습문제 선택 팝업을 표시한다.
     * @param pageInfo
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrContsExrcsQstnListPop.do")
    public String admLctrContsExrcsQstnListPop(
            ContsExrcsQstnPageInfo pageInfo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        model.addAllAttributes(admContsViewFacadeService.lctrContsExrcsQstnListPop(pageInfo, userCtx));
        model.addAttribute("encParams", request.getParameter("encParams"));

        return "contents/popup/adm_lctr_conts_exrcs_qntn_list_popview";
    }

    /**
     * 관리자 학습목차 연습문제 선택 목록을 조회한다.
     * @param pageInfo
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrContsExrcsQstnList.do")
    @ResponseBody
    public ResultDTO<EgovMap> admLctrContsExrcsQstnList(
            ContsExrcsQstnPageInfo pageInfo,
            @CurrentUser UserContext userCtx) {

        pageInfo.setOrgId(contsAuthHelper.resolveSearchOrgId(pageInfo.getOrgId(), userCtx));
        pageInfo.setLangCd(userCtx.getLangCd());
        return contsService.selectAdmExrcsQstnList(pageInfo);
    }

    /**
     * 관리자 학습목차 콘텐츠 등록 또는 수정 정보를 저장한다.
     * @param lctrContsVO
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrContsSave.do")
    @ResponseBody
    public ResultDTO<LctrContsVO> admLctrContsSave(
            LctrContsVO lctrContsVO,
            @CurrentUser UserContext userCtx) {

        lctrContsVO.setOrgId(contsAuthHelper.resolveSearchOrgId(lctrContsVO.getOrgId(), userCtx));
        lctrContsVO.setLangCd(userCtx.getLangCd());
        lctrContsVO.setRgtrId(userCtx.getUserId());
        lctrContsVO.setMdfrId(userCtx.getUserId());

        return contsService.saveAdmLctrConts(lctrContsVO);
    }

    /**
     * 관리자 학습목차 콘텐츠의 학습 이력 존재 여부를 조회한다.
     * @param lctrContsVO
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrContsLearningExists.do")
    @ResponseBody
    public ResultDTO<Boolean> admLctrContsLearningExists(
            LctrContsVO lctrContsVO,
            @CurrentUser UserContext userCtx) {

        lctrContsVO.setOrgId(contsAuthHelper.resolveSearchOrgId(lctrContsVO.getOrgId(), userCtx));
        return contsService.existsAdmLctrContsLearningHistory(lctrContsVO);
    }

    /**
     * 관리자 학습목차 콘텐츠와 하위 콘텐츠를 삭제한다.
     * @param lctrContsVO
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrContsDelete.do")
    @ResponseBody
    public ResultDTO<LctrContsVO> admLctrContsDelete(
            LctrContsVO lctrContsVO,
            @CurrentUser UserContext userCtx) {

        lctrContsVO.setOrgId(contsAuthHelper.resolveSearchOrgId(lctrContsVO.getOrgId(), userCtx));
        lctrContsVO.setMdfrId(userCtx.getUserId());

        return contsService.deleteAdmLctrContsTree(lctrContsVO);
    }

    /**
     * 강의주차일정 관리 팝업을 표시한다.
     * @param vo
     * @param model
     * @param request
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrWknoSchdlMngPop.do")
    public String lctrWknoSchdlMngPop(
            LctrWknoSchdlVO vo,
            ModelMap model,
            HttpServletRequest request,
            @CurrentUser UserContext userCtx) {

        model.addAllAttributes(admContsViewFacadeService.lctrWknoSchdlMngPop(vo, userCtx));
        model.addAttribute("encParams", request.getParameter("encParams"));

        return "contents/popup/lctr_wkno_schdl_mng_popview";
    }

    /**
     * 강의주차일정 관리 팝업에서 수정한 주차 정보를 저장한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrWknoSchdlModify.do")
    @ResponseBody
    public ResultDTO<LctrWknoSchdlVO> admLctrWknoSchdlModify(
            LctrWknoSchdlVO vo,
            @CurrentUser UserContext userCtx) {

        vo.setOrgId(contsAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx));
        vo.setLangCd(userCtx.getLangCd());
        vo.setUserId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());

        return contsService.updateAdmLctrWknoSchdl(vo);
    }

    /**
     * 강의주차 공개여부를 수정한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrWknoOynModify.do")
    @ResponseBody
    public ResultDTO<LctrWknoContsVO> admLctrWknoOynModify(
            LctrWknoContsVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<LctrWknoContsVO> resultDTO = new ResultDTO<LctrWknoContsVO>();
        if(StringUtil.isNull(vo.getLctrWknoSchdlId())) {
            return resultDTO.setResultFailed("lctrWknoSchdlId is required");
        }

        String oyn = StringUtil.nvl(vo.getOyn()).toUpperCase();
        if(!"Y".equals(oyn) && !"N".equals(oyn)) {
            return resultDTO.setResultFailed("invalid oyn");
        }

        vo.setOrgId(contsAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx));
        vo.setLangCd(userCtx.getLangCd());
        vo.setUserId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        vo.setOyn(oyn);

        return contsService.updateAdmLctrWknoOyn(vo);
    }

    /**
     * 강의주차 순차학습여부를 수정한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @RequestMapping(value = "/admLctrWknoSeqLrnynModify.do")
    @ResponseBody
    public ResultDTO<LctrWknoContsVO> admLctrWknoSeqLrnynModify(
            LctrWknoContsVO vo,
            @CurrentUser UserContext userCtx) {

        ResultDTO<LctrWknoContsVO> resultDTO = new ResultDTO<LctrWknoContsVO>();
        if(StringUtil.isNull(vo.getLctrWknoSchdlId())) {
            return resultDTO.setResultFailed("lctrWknoSchdlId is required");
        }

        String seqLrnyn = StringUtil.nvl(vo.getSeqLrnyn()).toUpperCase();
        if(!"Y".equals(seqLrnyn) && !"N".equals(seqLrnyn)) {
            return resultDTO.setResultFailed("invalid seqLrnyn");
        }

        vo.setOrgId(contsAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx));
        vo.setLangCd(userCtx.getLangCd());
        vo.setUserId(userCtx.getUserId());
        vo.setRgtrId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        vo.setSeqLrnyn(seqLrnyn);

        return contsService.updateAdmLctrWknoSeqLrnyn(vo);
    }

}
