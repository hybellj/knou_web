package knou.lms.crscls.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.ValidationUtils;
import knou.lms.std.service.ClsService;
import knou.lms.std.vo.*;
import knou.lms.common.vo.ProcessResultVO;
import org.apache.commons.collections.map.ListOrderedMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.BaseParam;
import knou.lms.subject.dto.SubjectParam;
import knou.lms.subject.service.SubjectFacadeService;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.LectureWknoScheduleVO;
import knou.lms.subject.web.view.SubjectViewModel;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

/**
 * 강의실 수업현황 Controller
 * 화면ID : KNOU_MN_B02200000_01 ~ 07
 */
@Controller
@RequestMapping(value = "/crscls")
public class CrsClsController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(CrsClsController.class);

    @Resource(name = "clsService")
    private ClsService clsService;

    @Resource(name="subjectFacadeService")
    private SubjectFacadeService subjectFacadeService;

    @Resource(name="subjectService")
    private SubjectService subjectService;

    /* ================================================================
       화면 반환
       ================================================================ */

    /**
     * 강의실 주차별 수업현황 화면
     * - sbjctId 없으면 BadRequestUrlException
     *
     * @param vo
     * @param model
     * @param request
     * @return crscls/crscls_weekly
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsClsStdntListView.do")
    public String selectCrsClsStdntListView(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        if (ValidationUtils.isEmpty(vo.getSbjctId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        String sessionOrgId = SessionInfo.getOrgId(request);
        UserContext userCtx = (UserContext) request.getSession().getAttribute("userCtx");

        BaseParam param = new SubjectParam(vo.getSbjctId(), userCtx, 3);
        SubjectViewModel subjectVM = subjectFacadeService.getSubjectViewModel(userCtx, param);
        model.addAttribute("subjectVM", subjectVM);

        LectureWknoScheduleVO lctrWknoSchdlVO = subjectService.currLctrWknoSchdlSelect(vo.getSbjctId());
        model.addAttribute("lctrWknoSchdlVO", lctrWknoSchdlVO);

        EgovMap lctrWknoAtndcrt = null;
        if (lctrWknoSchdlVO != null && !ValidationUtils.isEmpty(lctrWknoSchdlVO.getLctrWknoSchdlId())) {
            lctrWknoAtndcrt = subjectService.lctrWknoAtndcrtSelect(vo.getSbjctId(), lctrWknoSchdlVO.getLctrWknoSchdlId());
        }
        model.addAttribute("lctrWknoAtndcrt", lctrWknoAtndcrt);

        int sbjctConnectStdCnt = subjectService.subjectConnectStdCntSelect(vo.getSbjctId());
        model.addAttribute("sbjctConnectStdCnt", sbjctConnectStdCnt);

        int sbjctTotalStdCnt = subjectService.subjectTotalStdCntSelect(vo.getSbjctId());
        model.addAttribute("sbjctTotalStdCnt", sbjctTotalStdCnt);

        List<EgovMap> stdntSubjectConnectList = subjectService.stdntSubjectConnectList(vo.getSbjctId());
        model.addAttribute("stdntSubjectConnectList", stdntSubjectConnectList);

        ClsVO clsVO = new ClsVO();
        clsVO.setOrgId(sessionOrgId);
        clsVO.setSbjctId(vo.getSbjctId());

        ClsVO clsDetail = clsService.selectClsDetail(clsVO);

        model.addAttribute("orgId",     sessionOrgId);
        model.addAttribute("sbjctId",   vo.getSbjctId());
        model.addAttribute("dvclasNo",  request.getParameter("dvclasNo"));
        model.addAttribute("sbjctnm",   clsDetail != null ? clsDetail.getSbjctnm() : "");
        addEncParam("sbjctId", vo.getSbjctId());
        addEncParam("orgId", sessionOrgId);

        int wkCnt = resolveWkCnt(vo.getSbjctId(), sessionOrgId);
        model.addAttribute("wkCnt", wkCnt);

        return "crscls/crscls_weekly";
    }

    /**
     * 학습자 학습현황 팝업 화면
     * - sbjctId, userId 없으면 BadRequestUrlException
     *
     * @param vo
     * @param model
     * @param request
     * @return crscls/popup/crscls_stdnt_lrn_popup
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsStdntWkPopupView.do")
    public String selectCrsStdntWkPopupView(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String sbjctId = request.getParameter("sbjctId");
        String userId  = request.getParameter("userId");
        String wkNoStr = request.getParameter("wkNo");

        sbjctId = sbjctId == null ? null : sbjctId.trim();
        userId  = userId == null ? null : userId.trim();
        wkNoStr = wkNoStr == null ? null : wkNoStr.trim();

        if (ValidationUtils.isEmpty(sbjctId)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        if (ValidationUtils.isEmpty(userId)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        Integer wkNo = null;
        if (!ValidationUtils.isEmpty(wkNoStr)) {
            try {
                wkNo = Integer.parseInt(wkNoStr);
                if (wkNo <= 0) {
                    throw new BadRequestUrlException(getMessage("common.system.error"));
                }
            } catch (NumberFormatException e) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
        }

        int wkCnt = resolveWkCnt(sbjctId, SessionInfo.getOrgId(request));

        model.addAttribute("wkCnt",    wkCnt);
        model.addAttribute("sbjctId",  sbjctId);
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        model.addAttribute("userId",   userId);
        model.addAttribute("wkNo",     wkNo);

        return "crscls/popup/crscls_stdnt_lrn_popup";
    }

    /**
     * 학습자 주차별 학습기록 팝업 화면
     * - sbjctId, userId 없으면 BadRequestUrlException
     *
     * @param model
     * @param request
     * @return crscls/popup/crscls_stdnt_week_lrn_popup
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsStdntWkDetailPopupView.do")
    public String selectCrsStdntWkDetailPopupView(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String sbjctId = request.getParameter("sbjctId");
        String userId  = request.getParameter("userId");
        String wkNoStr = request.getParameter("wkNo");

        sbjctId = sbjctId == null ? null : sbjctId.trim();
        userId  = userId == null ? null : userId.trim();
        wkNoStr = wkNoStr == null ? null : wkNoStr.trim();

        if (ValidationUtils.isEmpty(sbjctId)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        if (ValidationUtils.isEmpty(userId)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        if (ValidationUtils.isEmpty(wkNoStr)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        int wkNo;
        try {
            wkNo = Integer.parseInt(wkNoStr);
        } catch (NumberFormatException e) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        if (wkNo <= 0) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        int wkCnt = resolveWkCnt(sbjctId, SessionInfo.getOrgId(request));

        model.addAttribute("wkCnt",    wkCnt);
        model.addAttribute("sbjctId",  sbjctId);
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        model.addAttribute("userId",   userId);
        model.addAttribute("wkNo",     wkNo);

        return "crscls/popup/crscls_stdnt_week_lrn_popup";
    }

    /**
     * 학습요소 참여현황 팝업 화면
     * - sbjctId, userId 없으면 BadRequestUrlException
     *
     * @param vo
     * @param model
     * @param request
     * @return crscls/popup/crscls_stdnt_element_popup
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsStdntElemPopupView.do")
    public String selectCrsStdntElemPopupView(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String sbjctId = request.getParameter("sbjctId");
        String userId  = request.getParameter("userId");

        sbjctId = sbjctId == null ? null : sbjctId.trim();
        userId  = userId == null ? null : userId.trim();

        if (ValidationUtils.isEmpty(sbjctId)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        if (ValidationUtils.isEmpty(userId)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        model.addAttribute("sbjctId",  sbjctId);
        model.addAttribute("dvclasNo", request.getParameter("dvclasNo"));
        model.addAttribute("userId",   userId);
        return "crscls/popup/crscls_stdnt_element_popup";
    }

    /**
     * 미학습자 현황 팝업 화면
     * - sbjctId, wkNo 없으면 BadRequestUrlException
     *
     * @param vo
     * @param model
     * @param request
     * @return crscls/popup/crscls_notlrnn_popup
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsNotLrnnPopupView.do")
    public String selectCrsNotLrnnPopupView(ClsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String sbjctId  = request.getParameter("sbjctId");
        String dvclasNo = request.getParameter("dvclasNo");
        String wkNoStr  = request.getParameter("wkNo");

        sbjctId  = sbjctId == null ? null : sbjctId.trim();
        dvclasNo = dvclasNo == null ? null : dvclasNo.trim();
        wkNoStr  = wkNoStr == null ? null : wkNoStr.trim();

        if (ValidationUtils.isEmpty(sbjctId)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        if (ValidationUtils.isEmpty(wkNoStr)) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        int wkNo;
        try {
            wkNo = Integer.parseInt(wkNoStr);
        } catch (NumberFormatException e) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        if (wkNo <= 0) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        model.addAttribute("sbjctId",  sbjctId);
        model.addAttribute("dvclasNo", dvclasNo);
        model.addAttribute("wkNo",     wkNo);

        ClsVO param = new ClsVO();
        param.setOrgId(SessionInfo.getOrgId(request));
        param.setSbjctId(sbjctId);

        ClsVO clsInfo = clsService.selectClsDetail(param);
        if (clsInfo != null) {
            model.addAttribute("sbjctnm", clsInfo.getSbjctnm());
        }

        return "crscls/popup/crscls_notlrnn_popup";
    }

    /* ================================================================
       메인 조회
       ================================================================ */

    /**
     * 주차별 미학습자 비율 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsWklyStatsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsClsWklyStats.do")
    @ResponseBody
    public ProcessResultVO<ClsWklyStatsVO> selectCrsClsWklyStats(ClsVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsWklyStatsVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            if (ValidationUtils.isEmpty(vo.getSbjctId())) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            List<ClsWklyStatsVO> list = clsService.selectClsWklyStats(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[selectCrsClsWklyStats] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 주차별 학습현황 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsClsStdntListPaging.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntVO> selectCrsClsStdntListPaging(ClsStdntVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsStdntVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        if (vo.getPageIndex() < 1)  vo.setPageIndex(1);
        if (vo.getListScale() <= 0) vo.setListScale(20);
        if (vo.getListScale() > 100) vo.setListScale(100);
        if (vo.getPageScale() <= 0) vo.setPageScale(10);
        if (vo.getPageScale() > 20) vo.setPageScale(20);

        try {
            if (ValidationUtils.isEmpty(vo.getSbjctId())) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            resultVO = clsService.selectClsStdntListPaging(vo);
            if (resultVO.getResult() >= 0) {
                resultVO.setResultSuccess();
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage(getCommonFailMessage());
            }
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[selectCrsClsStdntListPaging] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 학습요소 참여현황 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsElemStatsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsClsElemStats.do")
    @ResponseBody
    public ProcessResultVO<ClsElemStatsVO> selectCrsClsElemStats(ClsElemStatsVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsElemStatsVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        if (vo.getPageIndex() < 1)  vo.setPageIndex(1);
        if (vo.getListScale() <= 0) vo.setListScale(20);
        if (vo.getListScale() > 100) vo.setListScale(100);
        if (vo.getPageScale() <= 0) vo.setPageScale(10);
        if (vo.getPageScale() > 20) vo.setPageScale(20);

        try {
            if (ValidationUtils.isEmpty(vo.getSbjctId())) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            resultVO = clsService.selectClsElemStatsListPaging(vo);
            if (resultVO.getResult() >= 0) {
                resultVO.setResultSuccess();
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage(getCommonFailMessage());
            }
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[selectCrsClsElemStats] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 특정 주차 미학습자 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsClsNoStudyWeek.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntVO> selectCrsClsNoStudyWeek(ClsStdntVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsStdntVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            if (ValidationUtils.isEmpty(vo.getSbjctId())) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            if (vo.getWkNo() <= 0) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            List<ClsStdntVO> list = clsService.selectClsNoStudyWeek(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[selectCrsClsNoStudyWeek] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /* ================================================================
       팝업 조회
       ================================================================ */

    /**
     * 과목 상세 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsClsDetail.do")
    @ResponseBody
    public ProcessResultVO<ClsVO> selectCrsClsDetail(ClsVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            ClsVO result = clsService.selectClsDetail(vo);
            resultVO.setReturnVO(result);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            LOGGER.error("[selectCrsClsDetail] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 수강생 상세정보 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntInfoVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsStdntInfo.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntInfoVO> selectCrsStdntInfo(ClsStdntInfoVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsStdntInfoVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            ClsStdntInfoVO result = clsService.selectClsStdntInfo(vo);
            resultVO.setReturnVO(result);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[selectCrsStdntInfo] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 학습자 주차별 학습현황 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsStdntVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsStdntWeeklyInfo.do")
    @ResponseBody
    public ProcessResultVO<ClsStdntVO> selectCrsStdntWeeklyInfo(ClsStdntVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsStdntVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            ClsStdntVO result = clsService.selectClsStdntWeeklyInfo(vo);
            resultVO.setReturnVO(result);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[selectCrsStdntWeeklyInfo] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 주차별 학습요약 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsWkLrnVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsStdntWkLrnSummary.do")
    @ResponseBody
    public ProcessResultVO<ClsWkLrnVO> selectCrsStdntWkLrnSummary(ClsWkLrnVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsWkLrnVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            validateClsWkAccess(vo, false);

            ClsWkLrnVO result = clsService.selectStdntWkLrnSummary(vo);
            List<ClsChsiLrnVO> chsiList = clsService.selectStdntChsiLrnList(vo);

            if (result != null) {
                result.setChsiList(chsiList);
            }
            resultVO.setReturnVO(result);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[selectCrsStdntWkLrnSummary] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 차시별 학습로그 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsLrnLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsStdntLrnLog.do")
    @ResponseBody
    public ProcessResultVO<ClsLrnLogVO> selectCrsStdntLrnLog(ClsLrnLogVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsLrnLogVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            ClsWkLrnVO accessVo = new ClsWkLrnVO();
            accessVo.setOrgId(SessionInfo.getOrgId(request));
            accessVo.setSbjctId(request.getParameter("sbjctId") == null ? null : request.getParameter("sbjctId").trim());
            accessVo.setUserId(vo.getUserId());

            String wkNoStr = request.getParameter("wkNo");
            wkNoStr = wkNoStr == null ? null : wkNoStr.trim();
            if (ValidationUtils.isEmpty(wkNoStr)) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }
            try {
                int wkNo = Integer.parseInt(wkNoStr);
                if (wkNo <= 0) {
                    throw new BadRequestUrlException(getMessage("common.system.error"));
                }
                accessVo.setWkNo(wkNo);
            } catch (NumberFormatException e) {
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            validateClsWkAccess(accessVo, false);

            List<ClsLrnLogVO> list = clsService.selectStdntLrnLog(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[selectCrsStdntLrnLog] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 학습요소 제출 목록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsChsiLrnVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsStdntElemSbmsnList.do")
    @ResponseBody
    public ProcessResultVO<ClsChsiLrnVO> selectCrsStdntElemSbmsnList(ClsWkLrnVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsChsiLrnVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            List<ClsChsiLrnVO> list = clsService.selectStdntElemSbmsnList(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[selectCrsStdntElemSbmsnList] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 학습요소 제출 이력 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsAsmtSbmsnLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsStdntElemSbmsnLog.do")
    @ResponseBody
    public ProcessResultVO<ClsAsmtSbmsnLogVO> selectCrsStdntElemSbmsnLog(ClsAsmtSbmsnLogVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsAsmtSbmsnLogVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            List<ClsAsmtSbmsnLogVO> list = clsService.selectStdntElemSbmsnLog(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[selectCrsStdntElemSbmsnLog] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 강의실 접속현황 차트 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsAccessChartVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsStdntAccessChart.do")
    @ResponseBody
    public ProcessResultVO<ClsAccessChartVO> selectCrsStdntAccessChart(ClsAccessChartVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsAccessChartVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        if (vo.getYyyymm() == null || vo.getYyyymm().isEmpty()) {
            vo.setYyyymm(new SimpleDateFormat("yyyyMM").format(new Date()));
        }

        try {
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            List<ClsAccessChartVO> list = clsService.selectStdntAccessChart(vo);
            resultVO.setReturnList(list);
            resultVO.setResultSuccess();
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[selectCrsStdntAccessChart] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 강의실 활동기록 조회
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<ClsActivityLogVO>
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsStdntActivityLog.do")
    @ResponseBody
    public ProcessResultVO<ClsActivityLogVO> selectCrsStdntActivityLog(ClsActivityLogVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<ClsActivityLogVO> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));

        if (vo.getPageIndex() < 1)  vo.setPageIndex(1);
        if (vo.getListScale() <= 0) vo.setListScale(10);
        if (vo.getListScale() > 100) vo.setListScale(100);
        if (vo.getPageScale() <= 0) vo.setPageScale(10);
        if (vo.getPageScale() > 20) vo.setPageScale(20);

        try {
            validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

            resultVO = clsService.selectStdntActivityLogPaging(vo);
            if (resultVO.getResult() >= 0) {
                resultVO.setResultSuccess();
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage(getCommonFailMessage());
            }
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[selectCrsStdntActivityLog] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /* ================================================================
       처리
       ================================================================ */

    /**
     * 출석 처리
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<Object>
     * @throws Exception
     */
    @RequestMapping(value = "/updateCrsAtndlcProcess.do")
    @ResponseBody
    public ProcessResultVO<Object> updateCrsAtndlcProcess(ClsWkLrnVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<Object> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setRgtrId(SessionInfo.getUserId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));

        try {
            validateClsWkAccess(vo, true);

            int cnt = clsService.updateAtndlcProcess(vo);
            if (cnt > 0) {
                resultVO.setResultSuccess();
                resultVO.setMessage("출석 처리가 완료되었습니다.");
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage("출석 처리에 실패하였습니다.");
            }
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[updateCrsAtndlcProcess] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 출석 처리 취소
     *
     * @param vo
     * @param request
     * @return ProcessResultVO<Object>
     * @throws Exception
     */
    @RequestMapping(value = "/updateCrsAtndlcCancel.do")
    @ResponseBody
    public ProcessResultVO<Object> updateCrsAtndlcCancel(ClsWkLrnVO vo, HttpServletRequest request) throws Exception {

        ProcessResultVO<Object> resultVO = new ProcessResultVO<>();

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));

        try {
            validateClsWkAccess(vo, true);

            int cnt = clsService.updateAtndlcCancel(vo);
            if (cnt > 0) {
                resultVO.setResultSuccess();
                resultVO.setMessage("출석 처리가 취소되었습니다.");
            } else {
                resultVO.setResultFailed();
                resultVO.setMessage("출석 처리 취소에 실패하였습니다.");
            }
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed();
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.error("[updateCrsAtndlcCancel] fail, vo={}", vo, e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /* ================================================================
       엑셀 다운로드
       ================================================================ */

    /**
     * 특정 주차 미학습자 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsClsNoStudyWeekExcelDown.do")
    public String selectCrsClsNoStudyWeekExcelDown(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String dvclasNo = request.getParameter("dvclasNo");

        if (ValidationUtils.isEmpty(vo.getSbjctId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        if (vo.getWkNo() <= 0) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        vo.setOrgId(SessionInfo.getOrgId(request));

        List<ClsStdntVO> list = clsService.selectClsNoStudyWeek(vo);
        String title = "미학습자현황";

        List<ListOrderedMap> newList = new ArrayList<>();
        for (ClsStdntVO item : list) {
            ListOrderedMap orderedMap = new ListOrderedMap();
            orderedMap.put("lineNo",  item.getLineNo());
            orderedMap.put("deptnm",  item.getDeptnm());
            orderedMap.put("sbjctnm", vo.getSbjctnm() + (ValidationUtils.isEmpty(dvclasNo) ? "" : " " + dvclasNo + "반"));
            orderedMap.put("userId",  item.getUserId());
            orderedMap.put("stdntNo", item.getStdntNo());
            orderedMap.put("usernm",  item.getUsernm());
            orderedMap.put("prgrt",   item.getPrgrt());
            newList.add(orderedMap);
        }

        HashMap<String, Object> map = new HashMap<>();
        map.put("title",     title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list",      newList);
        map.put("ext",       ".xlsx(big)");

        String currentDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + currentDate);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

        model.addAllAttributes(modelMap);
        return "excelView";
    }

    /**
     * 주차별 학습현황 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsClsStdntListExcelDown.do")
    public String selectCrsClsStdntListExcelDown(ClsStdntVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        if (ValidationUtils.isEmpty(vo.getSbjctId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        vo.setOrgId(SessionInfo.getOrgId(request));
        int wkCnt = resolveWkCnt(vo.getSbjctId(), SessionInfo.getOrgId(request));

        if (vo.getWkList() == null || vo.getWkList().isEmpty()) {
            vo.setWkList(IntStream.rangeClosed(1, wkCnt).boxed().collect(Collectors.toList()));
        }

        List<ClsStdntVO> list = clsService.selectClsStdntList(vo);
        String title = "주차별 학습현황";

        List<ListOrderedMap> newList = new ArrayList<>();
        for (ClsStdntVO item : list) {
            ListOrderedMap orderedMap = new ListOrderedMap();
            orderedMap.put("lineNo",  item.getLineNo());
            orderedMap.put("deptnm",  item.getDeptnm());
            orderedMap.put("userId",  item.getUserId());
            orderedMap.put("stdntNo", item.getStdntNo());
            orderedMap.put("usernm",  item.getUsernm());
            orderedMap.put("entyR",   item.getEntyR());
            orderedMap.put("scyr",    item.getScyr());

            HashMap<Integer, String> wkMap = new HashMap<>();
            if (item.getWkStsList() != null) {
                for (ClsWkStsVO wkSts : item.getWkStsList()) {
                    wkMap.put(wkSts.getWkNo(), wkSts.getAtndSts());
                }
            }

            for (int w = 1; w <= wkCnt; w++) {
                String sts     = wkMap.getOrDefault(w, "-");
                String stsText = "ATND".equals(sts) ? "○" : "LATE".equals(sts) ? "△" : "ABSNT".equals(sts) ? "X" : "-";
                orderedMap.put("wk" + w + "Sts", stsText);
            }
            orderedMap.put("atndCnt", item.getAtndCnt());
            orderedMap.put("lateCnt", item.getLateCnt());
            orderedMap.put("absnCnt", item.getAbsnCnt());
            newList.add(orderedMap);
        }

        HashMap<String, Object> map = new HashMap<>();
        map.put("title",     title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list",      newList);
        map.put("ext",       ".xlsx(big)");

        String currentDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + currentDate);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

        model.addAllAttributes(modelMap);
        return "excelView";
    }

    /**
     * 학습요소 참여현황 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsClsElemStatsExcelDown.do")
    public String selectCrsClsElemStatsExcelDown(ClsElemStatsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        vo.setOrgId(SessionInfo.getOrgId(request));

        try {
            if (vo.getExcelGrid() == null || vo.getExcelGrid().trim().isEmpty()) {
                String defaultGrid =
                        "{\"colModel\":["
                                + "{\"label\":\"No\",\"name\":\"lineNo\",\"align\":\"center\",\"width\":\"3000\"},"
                                + "{\"label\":\"학과\",\"name\":\"deptnm\",\"align\":\"center\",\"width\":\"7000\"},"
                                + "{\"label\":\"대표아이디\",\"name\":\"userId\",\"align\":\"center\",\"width\":\"7000\"},"
                                + "{\"label\":\"학번\",\"name\":\"stdntNo\",\"align\":\"center\",\"width\":\"7000\"},"
                                + "{\"label\":\"이름\",\"name\":\"usernm\",\"align\":\"center\",\"width\":\"6000\"},"
                                + "{\"label\":\"Q&A(답변/등록)\",\"name\":\"qaText\",\"align\":\"center\",\"width\":\"6000\"},"
                                + "{\"label\":\"토론방(댓글수)\",\"name\":\"talkReplyCnt\",\"align\":\"center\",\"width\":\"4000\"},"
                                + "{\"label\":\"과제(제출/전체)\",\"name\":\"asmtText\",\"align\":\"center\",\"width\":\"6000\"},"
                                + "{\"label\":\"퀴즈(제출/전체)\",\"name\":\"quizText\",\"align\":\"center\",\"width\":\"6000\"},"
                                + "{\"label\":\"설문(제출/전체)\",\"name\":\"srvyText\",\"align\":\"center\",\"width\":\"6000\"},"
                                + "{\"label\":\"토론(제출/전체)\",\"name\":\"dsccText\",\"align\":\"center\",\"width\":\"6000\"},"
                                + "{\"label\":\"중간고사\",\"name\":\"midScore\",\"align\":\"center\",\"width\":\"4000\"},"
                                + "{\"label\":\"기말고사\",\"name\":\"finalScore\",\"align\":\"center\",\"width\":\"4000\"}"
                                + "]}";
                vo.setExcelGrid(defaultGrid);
            }

            List<ClsElemStatsVO> list = clsService.selectClsElemStatsListExcelDown(vo);

            String title = "학습요소참여현황";
            List<ListOrderedMap> newList = new ArrayList<>();

            for (ClsElemStatsVO item : list) {
                ListOrderedMap orderedMap = new ListOrderedMap();
                orderedMap.put("lineNo",       item.getLineNo());
                orderedMap.put("deptnm",       item.getDeptnm());
                orderedMap.put("userId",       item.getUserId());
                orderedMap.put("stdntNo",      item.getStdntNo());
                orderedMap.put("usernm",       item.getUsernm());
                orderedMap.put("qaText",       item.getQaAnsCnt()     + "/" + item.getQaRegCnt());
                orderedMap.put("talkReplyCnt", item.getTalkReplyCnt());
                orderedMap.put("asmtText",     item.getAsmtSbmsnCnt() + "/" + item.getAsmtTrgtCnt());
                orderedMap.put("quizText",     item.getQuizSbmsnCnt() + "/" + item.getQuizTrgtCnt());
                orderedMap.put("srvyText",     item.getSrvySbmsnCnt() + "/" + item.getSrvyTrgtCnt());
                orderedMap.put("dsccText",     item.getDsccSbmsnCnt() + "/" + item.getDsccTrgtCnt());
                orderedMap.put("midScore",
                        item.getMidLiveScore()   != null ? item.getMidLiveScore()
                                : item.getMidAltScore()  != null ? item.getMidAltScore()
                                : item.getMidEtcScore());
                orderedMap.put("finalScore",
                        item.getFinalLiveScore()  != null ? item.getFinalLiveScore()
                                : item.getFinalAltScore() != null ? item.getFinalAltScore()
                                : item.getFinalEtcScore());
                newList.add(orderedMap);
            }

            HashMap<String, Object> map = new HashMap<>();
            map.put("title",     title);
            map.put("sheetName", title);
            map.put("excelGrid", vo.getExcelGrid());
            map.put("list",      newList);
            map.put("ext",       ".xlsx(big)");

            String currentDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
            HashMap<String, Object> modelMap = new HashMap<>();
            modelMap.put("outFileName", title + "_" + currentDate);

            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

            model.addAllAttributes(modelMap);
            return "excelView";

        } catch (Exception e) {
            LOGGER.error("[selectCrsClsElemStatsExcelDown] 엑셀 생성 실패", e);
            throw e;
        }
    }

    /**
     * 강의실 활동기록 엑셀 다운로드
     *
     * @param vo
     * @param model
     * @param request
     * @return excelView
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsStdntActivityLogExcelDown.do")
    public String selectCrsStdntActivityLogExcelDown(ClsActivityLogVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        vo.setOrgId(SessionInfo.getOrgId(request));

        validateClsStdntAccess(vo.getSbjctId(), vo.getUserId(), vo.getOrgId());

        if (vo.getExcelGrid() == null || vo.getExcelGrid().trim().isEmpty()) {
            String defaultGrid =
                    "{\"colModel\":["
                            + "{\"label\":\"No\",         \"name\":\"lineNo\",   \"align\":\"center\",\"width\":\"3000\"},"
                            + "{\"label\":\"일시\",        \"name\":\"actDttm\",  \"align\":\"center\",\"width\":\"8000\"},"
                            + "{\"label\":\"활동 내용\",   \"name\":\"actConts\", \"align\":\"left\",  \"width\":\"8000\"},"
                            + "{\"label\":\"접근 장비\",   \"name\":\"deviceNm\", \"align\":\"center\",\"width\":\"5000\"},"
                            + "{\"label\":\"IP\",          \"name\":\"ipAddr\",   \"align\":\"center\",\"width\":\"6000\"}"
                            + "]}";
            vo.setExcelGrid(defaultGrid);
        }

        List<ClsActivityLogVO> list = clsService.selectStdntActivityLogList(vo);

        String title = "강의실활동기록";
        List<ListOrderedMap> newList = new ArrayList<>();
        for (ClsActivityLogVO item : list) {
            ListOrderedMap om = new ListOrderedMap();
            om.put("lineNo",   item.getLineNo());
            om.put("actDttm",  item.getActDttm());
            om.put("actConts", item.getActConts());
            om.put("deviceNm", item.getDeviceNm());
            om.put("ipAddr",   item.getIpAddr());
            newList.add(om);
        }

        HashMap<String, Object> map = new HashMap<>();
        map.put("title",     title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list",      newList);
        map.put("ext",       ".xlsx(big)");

        String currentDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + currentDate);

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

        model.addAllAttributes(modelMap);
        return "excelView";
    }

    /* ================================================================
       공통 private 메서드
       ================================================================ */

    /**
     * 과목 주차 수 조회
     * - sbjctId 가 없으면 기본값 15주 반환
     *
     * @param sbjctId
     * @param orgId
     * @return int
     * @throws Exception
     */
    private int resolveWkCnt(String sbjctId, String orgId) throws Exception {
        if (ValidationUtils.isEmpty(sbjctId)) {
            return 15;
        }
        ClsVO clsVO = new ClsVO();
        clsVO.setSbjctId(sbjctId);
        clsVO.setOrgId(orgId);

        ClsVO detail = clsService.selectClsDetail(clsVO);
        return (detail != null && detail.getWkCnt() > 0) ? detail.getWkCnt() : 15;
    }

    /**
     * 학습자 상세 조회 공통 접근 권한 검증
     * - sbjctId, userId 필수값 검증
     * - 해당 사용자가 해당 과목의 수강생인지 검증
     *
     * @param sbjctId
     * @param userId
     * @param orgId
     * @throws Exception
     */
    private void validateClsStdntAccess(String sbjctId, String userId, String orgId) throws Exception {
        if (ValidationUtils.isEmpty(sbjctId) || ValidationUtils.isEmpty(userId)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
        ClsWkLrnVO accessVo = new ClsWkLrnVO();
        accessVo.setSbjctId(sbjctId);
        accessVo.setUserId(userId);
        accessVo.setOrgId(orgId);

        if (clsService.checkClsStdntAccessCnt(accessVo) <= 0) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
    }

    /**
     * 주차 학습 접근 권한 검증
     * - sbjctId, userId, wkNo 필수값 검증
     * - requireSchdlId true 이면 lctrWknoSchdlId 도 검증 (출석처리/취소 시 사용)
     *
     * @param vo
     * @param requireSchdlId
     * @throws Exception
     */
    private void validateClsWkAccess(ClsWkLrnVO vo, boolean requireSchdlId) throws Exception {
        if (ValidationUtils.isEmpty(vo.getSbjctId())
                || ValidationUtils.isEmpty(vo.getUserId())
                || vo.getWkNo() <= 0) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
        if (requireSchdlId && ValidationUtils.isEmpty(vo.getLctrWknoSchdlId())) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
        if (clsService.checkClsStdntAccessCnt(vo) <= 0) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
        if (clsService.checkClsWkSchdlAccessCnt(vo) <= 0) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
    }

}
