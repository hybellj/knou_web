package knou.lms.atndcrtr.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import knou.lms.atndcrtr.service.AtndCrtrService;
import knou.lms.atndcrtr.vo.AtndCrtrVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value = "/atndcrtr")
public class AtndCrtrController extends ControllerBase {

    @Resource(name = "atndCrtrService")
    private AtndCrtrService atndCrtrService;

    @Resource(name = "semesterService")
    private SemesterService semesterService;

    /*****************************************************
     * 출석점수 기준관리 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admAtndCrtrList.do")
    public String atndCrtrList(AtndCrtrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        checkAdmin(userCtx, request);
        setCommonModel(model, request, userCtx, vo);
        return "atndcrtr/adm_atnd_crtr_list";
    }

    /*****************************************************
     * 출석점수 기준관리 목록 조회
     * @param vo
     * @param userCtx
     * @param request
     * @param model
     * @return ProcessResultVO<AtndCrtrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admListAtndCrtr.do")
    @ResponseBody
    public ProcessResultVO<AtndCrtrVO> listAtndCrtr(AtndCrtrVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {
        ProcessResultVO<AtndCrtrVO> resultVO = new ProcessResultVO<AtndCrtrVO>();
        try {
            checkAdmin(userCtx, request);
            applyOrgScope(vo, userCtx, request);
            resultVO = atndCrtrService.listPaging(vo);
            // 목록 복귀 시에는 기관/연도/학기 필터만 유지하고,
            // 수정 대상 식별용 smstrChrtId는 개별 이동 시 addParams로 다시 전달한다.
            delEncParam("smstrChrtId");
            resultVO.setEncParams(getEncParams());
        } catch(AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
            delEncParam("smstrChrtId");
            resultVO.setEncParams(getEncParams());
        }
        return resultVO;
    }

    /*****************************************************
     * 학기(기수) 목록 조회
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<AtndCrtrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admListHaksaTerm.do")
    @ResponseBody
    public ProcessResultVO<AtndCrtrVO> listHaksaTerm(AtndCrtrVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        ProcessResultVO<AtndCrtrVO> resultVO = new ProcessResultVO<AtndCrtrVO>();
        try {
            checkAdmin(userCtx, request);
            applyOrgScope(vo, userCtx, request);
            resultVO.setReturnList(atndCrtrService.listHaksaTerm(vo));
            resultVO.setResultSuccess();
            resultVO.setEncParams(getEncParams());
        } catch(BadRequestUrlException e) {
            resultVO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
            resultVO.setEncParams(getEncParams());
        }
        return resultVO;
    }

    /*****************************************************
     * 출석점수 기준관리 등록/수정 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admAtndCrtrWrite.do")
    public String atndCrtrWrite(AtndCrtrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        checkAdmin(userCtx, request);

        AtndCrtrVO viewVO;
        String mode = "write";
        String basicLockYn = "N";
        if(!isBlank(vo.getSmstrChrtId())) {
            // 학기기수 ID가 있으면 기존 기준 수정 화면으로 본다.
            applyOrgScope(vo, userCtx, request);
            viewVO = atndCrtrService.select(vo);
            mode = "edit";
            basicLockYn = "Y";
            if(viewVO == null) {
                viewVO = defaultAtndCrtr(userCtx, request);
            }
        } else {
            viewVO = defaultAtndCrtr(userCtx, request);
            if(!isBlank(vo.getOrgId())) {
                viewVO.setOrgId(vo.getOrgId());
            }
            if(!isBlank(vo.getHaksaYear())) {
                viewVO.setHaksaYear(vo.getHaksaYear());
            }
            if(!isBlank(vo.getHaksaTerm())) {
                viewVO.setHaksaTerm(vo.getHaksaTerm());
            }
        }
        if(!isBlank(vo.getMenuId())) {
            viewVO.setMenuId(vo.getMenuId());
        }

        setCommonModel(model, request, userCtx, viewVO);
        model.addAttribute("vo", viewVO);
        model.addAttribute("mode", mode);
        model.addAttribute("basicLockYn", basicLockYn);
        return "atndcrtr/adm_atnd_crtr_write";
    }

    /*****************************************************
     * 출석점수 기준관리 상세 화면
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return String
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admAtndCrtrView.do")
    public String atndCrtrView(AtndCrtrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        checkAdmin(userCtx, request);

        applyOrgScope(vo, userCtx, request);
        AtndCrtrVO viewVO = atndCrtrService.select(vo);
        if(viewVO == null) {
            viewVO = new AtndCrtrVO();
        }
        if(!isBlank(vo.getMenuId())) {
            viewVO.setMenuId(vo.getMenuId());
        }

        setCommonModel(model, request, userCtx, viewVO);
        model.addAttribute("vo", viewVO);
        return "atndcrtr/adm_atnd_crtr_view";
    }

    /*****************************************************
     * 출석점수 기준관리 저장
     * @param vo
     * @param userCtx
     * @param request
     * @param model
     * @return ProcessResultVO<AtndCrtrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admSaveAtndCrtr.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<AtndCrtrVO> saveAtndCrtr(AtndCrtrVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {
        ProcessResultVO<AtndCrtrVO> resultVO = new ProcessResultVO<AtndCrtrVO>();
        try {
            checkAdmin(userCtx, request);
            applyOrgScope(vo, userCtx, request);

            String userId = getUserId(userCtx, request);
            if(isBlank(userId)) {
                throw new BadRequestUrlException("사용자 정보를 확인할 수 없습니다.");
            }

            vo.setRgtrId(userId);
            vo.setMdfrId(userId);

            atndCrtrService.save(vo);
            resultVO.setReturnVO(vo);
            resultVO.setResultSuccess(getMessage("success.common.save"));
            delEncParam("smstrChrtId");
            resultVO.setEncParams(getEncParams());
        } catch(AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
            delEncParam("smstrChrtId");
            resultVO.setEncParams(getEncParams());
        }
        return resultVO;
    }

    /*****************************************************
     * 출석점수 기준관리 삭제
     * @param vo
     * @param userCtx
     * @param request
     * @param model
     * @return ProcessResultVO<AtndCrtrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admDeleteAtndCrtr.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<AtndCrtrVO> deleteAtndCrtr(AtndCrtrVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {
        ProcessResultVO<AtndCrtrVO> resultVO = new ProcessResultVO<AtndCrtrVO>();
        try {
            checkAdmin(userCtx, request);
            applyOrgScope(vo, userCtx, request);
            vo.setMdfrId(getUserId(userCtx, request));

            atndCrtrService.delete(vo);
            resultVO.setResultSuccess(getMessage("success.common.delete"));
            delEncParam("smstrChrtId");
            resultVO.setEncParams(getEncParams());
        } catch(AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
            delEncParam("smstrChrtId");
            resultVO.setEncParams(getEncParams());
        }
        return resultVO;
    }

    /*****************************************************
     * 이전 학기 기준 조회
     * @param vo
     * @param userCtx
     * @param request
     * @param model
     * @return ProcessResultVO<AtndCrtrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admLoadPrevAtndCrtr.do")
    @ResponseBody
    public ProcessResultVO<AtndCrtrVO> loadPrevAtndCrtr(AtndCrtrVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request, ModelMap model) throws Exception {
        ProcessResultVO<AtndCrtrVO> resultVO = new ProcessResultVO<AtndCrtrVO>();
        try {
            checkAdmin(userCtx, request);
            applyOrgScope(vo, userCtx, request);

            AtndCrtrVO prevVO = atndCrtrService.selectPrev(vo);
            if(prevVO == null) {
                resultVO.setResultFailed("이전 학기 기준이 없습니다.");
            } else {
                resultVO.setReturnVO(prevVO);
                resultVO.setResultSuccess();
            }
            delEncParam("smstrChrtId");
            resultVO.setEncParams(getEncParams());
        } catch(AccessDeniedException | BadRequestUrlException e) {
            resultVO.setResultFailed(StringUtil.nvl(e.getMessage(), getCommonFailMessage()));
            delEncParam("smstrChrtId");
            resultVO.setEncParams(getEncParams());
        }
        return resultVO;
    }

    /*****************************************************
     * 화면 공통 데이터 설정
     * @param model
     * @param request
     * @param userCtx
     * @param vo
     * @throws Exception
     ******************************************************/
    private void setCommonModel(ModelMap model, HttpServletRequest request, UserContext userCtx, AtndCrtrVO vo) throws Exception {
        String sessionOrgId = getOrgId(userCtx, request);
        boolean allOrgYn = isAllOrgAdmin(userCtx);
        preserveMenuId(vo, request);

        String curYear = DateTimeUtil.getYear();
        String curTerm = "";
        SmstrChrtVO currentSemester = getCurrentSemester(sessionOrgId);
        if(currentSemester != null) {
            curYear = StringUtil.nvl(currentSemester.getDgrsYr(), curYear);
            curTerm = StringUtil.nvl(currentSemester.getDgrsSmstrChrt());
        }

        List<String> yearList = new ArrayList<String>();
        for(int i = Integer.parseInt(DateTimeUtil.getYear(), 10) + 1; i >= 2016; i--) {
            yearList.add(Integer.toString(i));
        }

        AtndCrtrVO orgVO = new AtndCrtrVO();
        if(!allOrgYn) {
            orgVO.setOrgId(sessionOrgId);
        }
        List<AtndCrtrVO> orgInfoList = atndCrtrService.listOrg(orgVO);

        if(!allOrgYn && isBlank(vo.getOrgId())) {
            vo.setOrgId(sessionOrgId);
        }
        if(isBlank(vo.getHaksaYear())) {
            vo.setHaksaYear(curYear);
        }
        AtndCrtrVO termSearchVO = new AtndCrtrVO();
        if(!allOrgYn) {
            termSearchVO.setOrgId(sessionOrgId);
        } else if(!isBlank(vo.getOrgId())) {
            termSearchVO.setOrgId(vo.getOrgId());
        }
        termSearchVO.setHaksaYear(vo.getHaksaYear());
        List<AtndCrtrVO> haksaTermList = atndCrtrService.listHaksaTerm(termSearchVO);

        if(isBlank(vo.getHaksaTerm())) {
            if(hasHaksaTerm(haksaTermList, curTerm)) {
                vo.setHaksaTerm(curTerm);
            }
        }

        addEncParam("orgId", vo.getOrgId());
        addEncParam("haksaYear", vo.getHaksaYear());
        addEncParam("haksaTerm", vo.getHaksaTerm());
        // 목록 검색 조건만 encParams에 유지한다.
        // smstrChrtId는 행 단위 식별값이므로 상세/수정 이동 시 addParams로 별도 전달한다.
        delEncParam("smstrChrtId");

        model.addAttribute("vo", vo);
        model.addAttribute("curYear", curYear);
        model.addAttribute("curTerm", curTerm);
        model.addAttribute("yearList", yearList);
        model.addAttribute("haksaTermList", haksaTermList);
        model.addAttribute("orgInfoList", orgInfoList);
        model.addAttribute("allOrgYn", allOrgYn ? "Y" : "N");
        model.addAttribute("orgId", sessionOrgId);
    }

    private void preserveMenuId(AtndCrtrVO vo, HttpServletRequest request) throws Exception {
        String menuId = StringUtil.nvl(vo.getMenuId());
        if(isBlank(menuId)) {
            menuId = StringUtil.nvl(request.getParameter("menuId"));
        }
        if(!isBlank(menuId)) {
            vo.setMenuId(menuId);
            addEncParam("menuId", menuId);
        }
    }

    /*****************************************************
     * 등록 화면 기본값 설정
     * @param userCtx
     * @param request
     * @return AtndCrtrVO
     ******************************************************/
    private AtndCrtrVO defaultAtndCrtr(UserContext userCtx, HttpServletRequest request) {
        AtndCrtrVO vo = new AtndCrtrVO();
        if(!isAllOrgAdmin(userCtx)) {
            vo.setOrgId(getOrgId(userCtx, request));
        }
        // 년도/학기 기본값은 setCommonModel에서 현재 학기 기준으로 채운다.
        return vo;
    }

    /*****************************************************
     * 기관 범위 적용
     * @param vo
     * @param userCtx
     * @param request
     ******************************************************/
    private void applyOrgScope(AtndCrtrVO vo, UserContext userCtx, HttpServletRequest request) {
        if(!isAllOrgAdmin(userCtx)) {
            vo.setOrgId(getOrgId(userCtx, request));
        }
    }

    private SmstrChrtVO getCurrentSemester(String orgId) throws Exception {
        SmstrChrtVO searchVO = new SmstrChrtVO();
        searchVO.setOrgId(orgId);
        return semesterService.selectCurrentSemester(searchVO);
    }

    private boolean hasHaksaTerm(List<AtndCrtrVO> termList, String haksaTerm) {
        String target = StringUtil.nvl(haksaTerm);
        if(target.isEmpty() || termList == null) {
            return false;
        }

        for(AtndCrtrVO term : termList) {
            if(term != null && target.equals(StringUtil.nvl(term.getHaksaTerm()))) {
                return true;
            }
        }
        return false;
    }

    /*****************************************************
     * 전체 기관 관리자 여부 확인
     * @param request
     * @return boolean
     ******************************************************/
    private boolean isAllOrgAdmin(UserContext userCtx) {
        String orgId = userCtx != null ? StringUtil.nvl(userCtx.getOrgId()) : "";
        return CommConst.KNOU_ORG_ID.equals(orgId) || CommConst.LMSBASIC_ORG_ID.equals(orgId);
    }

    /*****************************************************
     * 관리자 권한 확인
     * @param userCtx
     * @param request
     ******************************************************/
    private void checkAdmin(UserContext userCtx, HttpServletRequest request) throws Exception{
        if(userCtx != null && userCtx.isAdmin()) {
            return;
        }

        String authGrpCd = getAuthGrpCd(userCtx, request);
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));

        if(CommConst.AUTHRT_GRPCD_ADM.equals(authGrpCd) || "Y".equals(admYn)) {
            return;
        }

        throw new AccessDeniedException(getCommonNoAuthMessage());
    }

    /*****************************************************
     * 사용자 아이디 조회
     * @param userCtx
     * @param request
     * @return String
     ******************************************************/
    private String getUserId(UserContext userCtx, HttpServletRequest request) {
        if(userCtx != null && !isBlank(userCtx.getUserId())) {
            return userCtx.getUserId();
        }
        return "";
    }

    /*****************************************************
     * 기관 아이디 조회
     * @param userCtx
     * @param request
     * @return String
     ******************************************************/
    private String getOrgId(UserContext userCtx, HttpServletRequest request) {
        if(userCtx != null && !isBlank(userCtx.getOrgId())) {
            return userCtx.getOrgId();
        }
        return "";
    }

    /*****************************************************
     * 권한 그룹 코드 조회
     * @param userCtx
     * @param request
     * @return String
     ******************************************************/
    private String getAuthGrpCd(UserContext userCtx, HttpServletRequest request) {
        if(userCtx != null && !isBlank(userCtx.getAuthrtGrpcd())) {
            return StringUtil.nvl(userCtx.getAuthrtGrpcd());
        }
        return "";
    }

    /*****************************************************
     * 공백 여부 확인
     * @param value
     * @return boolean
     ******************************************************/
    private boolean isBlank(String value) {
        return StringUtil.nvl(value).trim().length() == 0;
    }
}
