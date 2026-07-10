package knou.lms.review.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.review.service.ReviewPeriodService;
import knou.lms.review.vo.ReviewPeriodListVO;
import knou.lms.review.vo.ReviewPeriodVO;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value = "/review")
public class ReviewPeriodController extends ControllerBase {

    @Resource(name = "reviewPeriodService")
    private ReviewPeriodService reviewPeriodService;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    @Resource(name = "semesterService")
    private SemesterService semesterService;

    @Resource(name = "cmmnCdService")
    private CmmnCdService cmmnCdService;

    /*****************************************************
     * 복습기간설정 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admReviewPeriodList.do")
    public String admReviewPeriodList(ReviewPeriodListVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        checkAdmin(userCtx, request);

        String orgId = resolveListOrgId(vo.getOrgId(), userCtx, request);
        vo.setOrgId(orgId);
        vo.setLangCd(getLangCd(userCtx));

        List<OrgInfoVO> orgList = getOrgList(userCtx, request);
        List<Integer> yearList = DateTimeUtil.getYearList(10, "mix");
        SmstrChrtVO currentSemester = getCurrentSemester(userCtx, request);
        String curYear = currentSemester == null ? DateTimeUtil.getYear() : StringUtil.nvl(currentSemester.getDgrsYr(), DateTimeUtil.getYear());
        String curTerm = currentSemester == null ? "" : StringUtil.nvl(currentSemester.getDgrsSmstrChrt());

        if (isBlank(vo.getDgrsYr())) {
            vo.setDgrsYr(curYear);
        }
        if (vo.getCurrentPageNo() <= 0) {
            vo.setCurrentPageNo(1);
        }
        if (vo.getRecordCountPerPage() <= 0) {
            vo.setRecordCountPerPage(10);
        }
        if (vo.getPageSize() <= 0) {
            vo.setPageSize(10);
        }

        List<SmstrChrtVO> smstrChrtList = getSmstrChrtList(orgId, vo.getDgrsYr(), orgList);

        if (isBlank(vo.getDgrsSmstrChrt()) && hasSmstrTerm(smstrChrtList, curTerm)) {
            vo.setDgrsSmstrChrt(curTerm);
        }

        model.addAttribute("orgList", orgList);
        model.addAttribute("yearList", yearList);
        model.addAttribute("smstrChrtList", smstrChrtList);
        model.addAttribute("crsGbncdList", getCodeList(orgId, "CRS_GBNCD", userCtx, request));
        model.addAttribute("sbjctTycdList", getCodeList(orgId, "SBJCT_TYCD", userCtx, request));
        model.addAttribute("allOrgYn", isAllOrgAdmin(userCtx) ? "Y" : "N");
        setCommonModel(model, request, vo);
        return "review/adm_review_period_list_view";
    }

    /*****************************************************
     * 복습기간설정 목록 조회
     * @param vo
     * @param userCtx
     * @param request
     * @return ResultDTO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admListReviewPeriod.do")
    @ResponseBody
    public ResultDTO<EgovMap> admListReviewPeriod(ReviewPeriodListVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>();
        try {
            checkAdmin(userCtx, request);
            vo.setOrgId(resolveListOrgId(vo.getOrgId(), userCtx, request));
            vo.setLangCd(getLangCd(userCtx));
            resultDTO = reviewPeriodService.listReviewPeriod(vo).setResultSuccess();
            resultDTO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException | IllegalArgumentException e) {
            resultDTO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
            resultDTO.setEncParams(getEncParams());
        }
        return resultDTO;
    }

    /*****************************************************
     * 복습기간설정 팝업
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admReviewPeriodSettingPopup.do")
    public String admReviewPeriodSettingPopup(ReviewPeriodVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        checkAdmin(userCtx, request);
        vo.setOrgId(resolveListOrgId(vo.getOrgId(), userCtx, request));
        vo.setLangCd(getLangCd(userCtx));

        if (isBlank(vo.getSbjctId())) {
            throw new BadRequestUrlException("과목 정보를 확인할 수 없습니다.");
        }

        EgovMap detail = reviewPeriodService.selectReviewPeriod(vo);
        if (detail == null) {
            throw new BadRequestUrlException("과목 정보를 확인할 수 없습니다.");
        }
        if (detail.get("orgId") != null) {
            vo.setOrgId(String.valueOf(detail.get("orgId")));
        }

        model.addAttribute("detail", detail);
        setCommonModel(model, request, vo);
        return "review/popup/adm_review_period_setting_pop";
    }

    /*****************************************************
     * 복습기간설정 저장
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<ReviewPeriodVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admSaveReviewPeriod.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<ReviewPeriodVO> admSaveReviewPeriod(ReviewPeriodVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<ReviewPeriodVO> resultVO = new ProcessResultVO<ReviewPeriodVO>();
        try {
            checkAdmin(userCtx, request);
            vo.setOrgId(resolveRequiredOrgId(vo.getOrgId(), userCtx, request));
            vo.setLangCd(getLangCd(userCtx));

            if (isBlank(vo.getSbjctId())) {
                throw new BadRequestUrlException("과목 정보를 확인할 수 없습니다.");
            }

            EgovMap detail = reviewPeriodService.selectReviewPeriod(vo);
            if (detail == null) {
                throw new BadRequestUrlException("과목 정보를 확인할 수 없습니다.");
            }
            if (detail.get("orgId") != null) {
                vo.setOrgId(String.valueOf(detail.get("orgId")));
            }

            vo.setMdfrId(getUserId(userCtx, request));
            if (isBlank(vo.getMdfrId())) {
                throw new BadRequestUrlException("사용자 정보를 확인할 수 없습니다.");
            }

            reviewPeriodService.saveReviewPeriod(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResultSuccess(getMessage("success.common.save"));
            resultVO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException | IllegalArgumentException e) {
            resultVO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
            resultVO.setEncParams(getEncParams());
        }
        return resultVO;
    }

    /*****************************************************
     * 기관/학년도 기준 학기 목록 조회
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<SmstrChrtVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admListHaksaTerm.do")
    @ResponseBody
    public ProcessResultVO<SmstrChrtVO> admListHaksaTerm(ReviewPeriodVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<SmstrChrtVO> resultVO = new ProcessResultVO<SmstrChrtVO>();
        try {
            checkAdmin(userCtx, request);
            String orgId = resolveListOrgId(vo.getOrgId(), userCtx, request);
            resultVO.setReturnList(getSmstrChrtList(orgId, vo.getHaksaYear(), getOrgList(userCtx, request)));
            resultVO.setResultSuccess();
            resultVO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed(getCommonFailMessage());
            resultVO.setEncParams(getEncParams());
        }
        return resultVO;
    }

    /*****************************************************
     * 기관 기준 공통코드 목록 조회
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<CmmnCdVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admReviewPeriodCmmnCdList.do")
    @ResponseBody
    public ProcessResultVO<CmmnCdVO> admReviewPeriodCmmnCdList(CmmnCdVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<CmmnCdVO> resultVO = new ProcessResultVO<CmmnCdVO>();
        try {
            checkAdmin(userCtx, request);
            String upCd = StringUtil.nvl(vo.getUpCd());
            if (isBlank(upCd)) {
                resultVO.setReturnList(Collections.<CmmnCdVO>emptyList());
                resultVO.setResultSuccess();
                resultVO.setEncParams(getEncParams());
                return resultVO;
            }

            String orgId = resolveListOrgId(vo.getOrgId(), userCtx, request);
            resultVO.setReturnList(getCodeList(orgId, upCd, userCtx, request));
            resultVO.setResultSuccess();
            resultVO.setEncParams(getEncParams());
        } catch (AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed(getCommonFailMessage());
            resultVO.setEncParams(getEncParams());
        }
        return resultVO;
    }

    /*****************************************************
     * 관리자 권한 확인
     * @param userCtx
     * @param request
     ******************************************************/
    private void checkAdmin(UserContext userCtx, HttpServletRequest request) {
        String authGrpCd = getAuthGrpCd(userCtx);
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));

        if ((userCtx == null || !userCtx.isAdmin()) && !CommConst.AUTHRT_GRPCD_ADM.equals(authGrpCd) && !"Y".equals(admYn)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
    }

    /*****************************************************
     * 상세/팝업 경로 공통 모델 구성
     * @param model
     * @param request
     * @param vo
     * @throws Exception
     ******************************************************/
    private void setCommonModel(ModelMap model, HttpServletRequest request, ReviewPeriodVO vo) throws Exception {
        preserveMenuId(vo, request);
        addEncParam("orgId", vo.getOrgId());
        addEncParam("haksaYear", vo.getHaksaYear());
        addEncParam("haksaTerm", vo.getHaksaTerm());
        addEncParam("sbjctId", vo.getSbjctId());
        addEncParam("crsGbncd", vo.getCrsGbncd());
        addEncParam("sbjctTycd", vo.getSbjctTycd());
        addEncParam("searchValue", vo.getSearchValue());
        model.addAttribute("vo", vo);
        model.addAttribute("encParams", getEncParams());
    }

    /*****************************************************
     * 목록 경로 공통 모델 구성
     * @param model
     * @param request
     * @param vo
     * @throws Exception
     ******************************************************/
    private void setCommonModel(ModelMap model, HttpServletRequest request, ReviewPeriodListVO vo) throws Exception {
        preserveMenuId(vo, request);
        addEncParam("orgId", vo.getOrgId());
        addEncParam("dgrsYr", vo.getDgrsYr());
        addEncParam("dgrsSmstrChrt", vo.getDgrsSmstrChrt());
        addEncParam("sbjctId", vo.getSbjctId());
        addEncParam("crsGbncd", vo.getCrsGbncd());
        addEncParam("sbjctTycd", vo.getSbjctTycd());
        addEncParam("searchText", vo.getSearchText());
        addEncParam("currentPageNo", String.valueOf(vo.getCurrentPageNo()));
        addEncParam("recordCountPerPage", String.valueOf(vo.getRecordCountPerPage()));
        addEncParam("pageSize", String.valueOf(vo.getPageSize()));
        model.addAttribute("vo", vo);
        model.addAttribute("encParams", getEncParams());
    }

    /*****************************************************
     * 상세/팝업 경로 menuId 유지
     * @param vo
     * @param request
     * @throws Exception
     ******************************************************/
    private void preserveMenuId(ReviewPeriodVO vo, HttpServletRequest request) throws Exception {
        String menuId = StringUtil.nvl(vo.getMenuId());
        if (isBlank(menuId)) {
            menuId = StringUtil.nvl(request.getParameter("menuId"));
        }
        if (!isBlank(menuId)) {
            vo.setMenuId(menuId);
            addEncParam("menuId", menuId);
        }
    }

    /*****************************************************
     * 목록 경로 menuId 유지
     * @param vo
     * @param request
     * @throws Exception
     ******************************************************/
    private void preserveMenuId(ReviewPeriodListVO vo, HttpServletRequest request) throws Exception {
        String menuId = StringUtil.nvl(vo.getMenuId());
        if (isBlank(menuId)) {
            menuId = StringUtil.nvl(request.getParameter("menuId"));
        }
        if (!isBlank(menuId)) {
            vo.setMenuId(menuId);
            addEncParam("menuId", menuId);
        }
    }

    /*****************************************************
     * 저장 경로 기관 ID 결정
     * @param orgId
     * @param userCtx
     * @param request
     * @return String
     ******************************************************/
    private String resolveRequiredOrgId(String orgId, UserContext userCtx, HttpServletRequest request) {
        if (!isAllOrgAdmin(userCtx)) {
            return getOrgId(userCtx, request);
        }
        return StringUtil.nvl(orgId);
    }

    /*****************************************************
     * 목록 경로 기관 ID 결정
     * @param orgId
     * @param userCtx
     * @param request
     * @return String
     ******************************************************/
    private String resolveListOrgId(String orgId, UserContext userCtx, HttpServletRequest request) {
        if (!isAllOrgAdmin(userCtx)) {
            return getOrgId(userCtx, request);
        }
        return StringUtil.nvl(orgId);
    }

    /*****************************************************
     * 사용자 권한 기준 기관 목록 조회
     * @param userCtx
     * @param request
     * @return List<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    private List<OrgInfoVO> getOrgList(UserContext userCtx, HttpServletRequest request) throws Exception {
        List<OrgInfoVO> orgList = orgInfoService.listActiveOrg();
        if (isAllOrgAdmin(userCtx)) {
            return orgList;
        }

        return filterOrgList(orgList, getOrgId(userCtx, request));
    }

    /*****************************************************
     * 단일 기관 관리자용 기관 목록 필터링
     * @param orgList
     * @param orgId
     * @return List<OrgInfoVO>
     ******************************************************/
    private List<OrgInfoVO> filterOrgList(List<OrgInfoVO> orgList, String orgId) {
        List<OrgInfoVO> filteredList = new ArrayList<OrgInfoVO>();
        String value = StringUtil.nvl(orgId);
        if (value.isEmpty() || orgList == null) {
            return filteredList;
        }

        for (OrgInfoVO orgInfoVO : orgList) {
            if (orgInfoVO != null && value.equals(StringUtil.nvl(orgInfoVO.getOrgId()))) {
                filteredList.add(orgInfoVO);
            }
        }
        return filteredList;
    }

    /*****************************************************
     * 기관/학년도 기준 학기 목록 조회
     * @param orgId
     * @param haksaYear
     * @param orgList
     * @return List<SmstrChrtVO>
     * @throws Exception
     ******************************************************/
    private List<SmstrChrtVO> getSmstrChrtList(String orgId, String haksaYear, List<OrgInfoVO> orgList) throws Exception {
        String year = StringUtil.nvl(haksaYear);
        if (year.isEmpty()) {
            return Collections.emptyList();
        }
        if (StringUtil.nvl(orgId).isEmpty()) {
            return getAllOrgSmstrChrtList(year, orgList);
        }

        SmstrChrtVO smstrChrtVO = new SmstrChrtVO();
        smstrChrtVO.setOrgId(orgId);
        smstrChrtVO.setDgrsYr(haksaYear);
        return semesterService.listSmstrChrtByDgrsYr(smstrChrtVO);
    }

    /*****************************************************
     * 전체 기관 기준 학기 목록 통합
     * @param haksaYear
     * @param orgList
     * @return List<SmstrChrtVO>
     * @throws Exception
     ******************************************************/
    private List<SmstrChrtVO> getAllOrgSmstrChrtList(String haksaYear, List<OrgInfoVO> orgList) throws Exception {
        Map<String, SmstrChrtVO> termMap = new LinkedHashMap<String, SmstrChrtVO>();
        if (orgList != null) {
            for (OrgInfoVO org : orgList) {
                if (org == null || isBlank(org.getOrgId())) {
                    continue;
                }

                SmstrChrtVO searchVO = new SmstrChrtVO();
                searchVO.setOrgId(org.getOrgId());
                searchVO.setDgrsYr(haksaYear);
                List<SmstrChrtVO> list = semesterService.listSmstrChrtByDgrsYr(searchVO);
                if (list == null) {
                    continue;
                }

                for (SmstrChrtVO term : list) {
                    String termValue = term == null ? "" : StringUtil.nvl(term.getDgrsSmstrChrt());
                    if (termValue.isEmpty() || termMap.containsKey(termValue)) {
                        continue;
                    }

                    SmstrChrtVO option = new SmstrChrtVO();
                    option.setDgrsYr(haksaYear);
                    option.setDgrsSmstrChrt(termValue);
                    option.setSmstrChrtnm(term.getSmstrChrtnm());
                    termMap.put(termValue, option);
                }
            }
        }

        List<SmstrChrtVO> result = new ArrayList<SmstrChrtVO>(termMap.values());
        Collections.sort(result, new Comparator<SmstrChrtVO>() {
            @Override
            public int compare(SmstrChrtVO left, SmstrChrtVO right) {
                return compareTerm(left.getDgrsSmstrChrt(), right.getDgrsSmstrChrt());
            }
        });
        return result;
    }

    /*****************************************************
     * 학기값 정렬 비교
     * @param left
     * @param right
     * @return int
     ******************************************************/
    private int compareTerm(String left, String right) {
        String leftText = StringUtil.nvl(left);
        String rightText = StringUtil.nvl(right);
        try {
            return Integer.valueOf(leftText).compareTo(Integer.valueOf(rightText));
        } catch (NumberFormatException e) {
            return leftText.compareTo(rightText);
        }
    }

    /*****************************************************
     * 학기 목록 내 포함 여부 확인
     * @param list
     * @param term
     * @return boolean
     ******************************************************/
    private boolean hasSmstrTerm(List<SmstrChrtVO> list, String term) {
        String target = StringUtil.nvl(term);
        if (target.isEmpty() || list == null) {
            return false;
        }
        for (SmstrChrtVO item : list) {
            if (item != null && target.equals(StringUtil.nvl(item.getDgrsSmstrChrt()))) {
                return true;
            }
        }
        return false;
    }

    /*****************************************************
     * 현재 학기 조회
     * @param userCtx
     * @param request
     * @return SmstrChrtVO
     * @throws Exception
     ******************************************************/
    private SmstrChrtVO getCurrentSemester(UserContext userCtx, HttpServletRequest request) throws Exception {
        SmstrChrtVO searchVO = new SmstrChrtVO();
        searchVO.setOrgId(getOrgId(userCtx, request));
        return semesterService.selectCurrentSemester(searchVO);
    }

    /*****************************************************
     * 기관 기준 공통코드 목록 조회
     * @param orgId
     * @param codeCtgrCd
     * @param userCtx
     * @param request
     * @return List<CmmnCdVO>
     * @throws Exception
     ******************************************************/
    private List<CmmnCdVO> getCodeList(String orgId, String codeCtgrCd, UserContext userCtx, HttpServletRequest request) throws Exception {
        List<CmmnCdVO> codeList = cmmnCdService.listCode(CommConst.LMSBASIC_ORG_ID, codeCtgrCd).getReturnList();
        return removeDefaultCode(codeList, codeCtgrCd);
    }

    /*****************************************************
     * 상위코드와 동일한 기본 행 제거
     * @param codeList
     * @param upCd
     * @return List<CmmnCdVO>
     ******************************************************/
    private List<CmmnCdVO> removeDefaultCode(List<CmmnCdVO> codeList, String upCd) {
        List<CmmnCdVO> result = new ArrayList<CmmnCdVO>();
        if (codeList == null) {
            return result;
        }

        String upperCode = StringUtil.nvl(upCd);
        for (CmmnCdVO code : codeList) {
            if (code != null && !upperCode.equals(code.getCd())) {
                result.add(code);
            }
        }
        return result;
    }

    /*****************************************************
     * 전체 기관 조회 가능 관리자 여부
     * @param userCtx
     * @return boolean
     ******************************************************/
    private boolean isAllOrgAdmin(UserContext userCtx) {
        String orgId = userCtx != null ? StringUtil.nvl(userCtx.getOrgId()) : "";
        return CommConst.KNOU_ORG_ID.equals(orgId) || CommConst.LMSBASIC_ORG_ID.equals(orgId);
    }

    /*****************************************************
     * 현재 사용자 ID 조회
     * @param userCtx
     * @param request
     * @return String
     ******************************************************/
    private String getUserId(UserContext userCtx, HttpServletRequest request) {
        if (userCtx != null && !isBlank(userCtx.getUserId())) {
            return userCtx.getUserId();
        }
        return request != null ? StringUtil.nvl(SessionInfo.getUserId(request)) : "";
    }

    /*****************************************************
     * 현재 기관 ID 조회
     * @param userCtx
     * @param request
     * @return String
     ******************************************************/
    private String getOrgId(UserContext userCtx, HttpServletRequest request) {
        if (userCtx != null && !isBlank(userCtx.getOrgId())) {
            return userCtx.getOrgId();
        }
        return request != null ? StringUtil.nvl(SessionInfo.getOrgId(request)) : "";
    }

    /*****************************************************
     * 현재 언어 코드 조회
     * @param userCtx
     * @return String
     ******************************************************/
    private String getLangCd(UserContext userCtx) {
        if (userCtx != null && !isBlank(userCtx.getLangCd())) {
            return userCtx.getLangCd();
        }
        return "ko";
    }

    /*****************************************************
     * 현재 권한 그룹 코드 조회
     * @param userCtx
     * @return String
     ******************************************************/
    private String getAuthGrpCd(UserContext userCtx) {
        return userCtx != null ? StringUtil.nvl(userCtx.getAuthrtGrpcd()) : "";
    }

    /*****************************************************
     * 공백 문자열 여부 확인
     * @param value
     * @return boolean
     ******************************************************/
    private boolean isBlank(String value) {
        return StringUtil.nvl(value).trim().length() == 0;
    }
}
