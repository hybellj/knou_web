package knou.lms.sbjctinfo.web;

import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.ValidationUtils;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.lecture2.vo.LectureWknoScheduleVO;
import knou.lms.sbjctinfo.service.SbjctInfoService;
import knou.lms.sbjctinfo.vo.SbjctInfoAliasVO;
import knou.lms.sbjctinfo.vo.SbjctInfoQuizPreviewVO;
import knou.lms.sbjctinfo.vo.SbjctInfoVO;
import knou.lms.subject.service.SubjectFacadeService;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.web.view.SubjectViewModel;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value = "/sbjctinfo")
public class SbjctInfoController extends ControllerBase {

    @Resource(name = "subjectService")
    private SubjectService subjectService;

    @Resource(name = "sbjctInfoService")
    private SbjctInfoService sbjctInfoService;

    @Resource(name = "cmmnCdService")
    private CmmnCdService cmmnCdService;

    @Resource(name="subjectFacadeService")
    private SubjectFacadeService subjectFacadeService;

    /**
     * 과목정보 및 분반별칭관리 화면 조회
     *
     * @param vo
     * @param userCtx
     * @param model
     * @param request
     * @return sbjctinfo/sbjctinfo_list
     * @throws Exception
     */
    @RequestMapping(value = "/sbjctinfoview.do")
    public String sbjctinfoview(SbjctInfoVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        if (ValidationUtils.isEmpty(vo.getSbjctId())) {
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        validateSbjctAdmAccess(vo.getSbjctId(), userCtx);

        String sessionOrgId = userCtx.getOrgId();
        addEncParam("sbjctId", vo.getSbjctId());
        addEncParam("orgId", sessionOrgId);// 좌측 GNB/메뉴 이동 시 sbjctId, orgId 유지
                
        SubjectViewModel subjectVM = subjectFacadeService.getSubjectViewModel(userCtx, vo.getSbjctId());
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

        String orgId = sessionOrgId;

        List<CmmnCdVO> sbjctTycdList = cmmnCdService.listCode(orgId, "SBJCT_TYCD").getReturnList();
        List<CmmnCdVO> lctrGbncdList = cmmnCdService.listCode(orgId, "LCTR_GBNCD").getReturnList();

        model.addAttribute("sbjctTycdList", sbjctTycdList);
        model.addAttribute("lctrGbncdList", lctrGbncdList);

        // 1. 과목 기본정보 조회
        SbjctInfoVO sbjctInfo = sbjctInfoService.selectSbjctInfo(vo);
        model.addAttribute("sbjctInfo", sbjctInfo);

        if (sbjctInfo != null) {

            // 2. 분반별칭 목록 조회 (같은 과목 그룹 전체)
            SbjctInfoAliasVO aliasVO = new SbjctInfoAliasVO();
            aliasVO.setSbjctId(sbjctInfo.getSbjctId());
            List<SbjctInfoAliasVO> aliasList = sbjctInfoService.selectSbjctInfoAliasList(aliasVO);
            model.addAttribute("aliasList", aliasList);

            // 3. 돌발퀴즈 목록 조회
            SbjctInfoQuizPreviewVO quizVO = new SbjctInfoQuizPreviewVO();
            quizVO.setSbjctId(sbjctInfo.getSbjctId());
            List<SbjctInfoQuizPreviewVO> quizList = sbjctInfoService.selectQuizPreviewList(quizVO);
            model.addAttribute("quizList", quizList);

            // 4. 다국어 자막(스크립트) 목록 조회
            // 다국어 자막 메세지 테이블 삭제로 임시 빈목록 처리
            model.addAttribute("srtList", Collections.emptyList());
        }

        return "sbjctinfo/sbjctinfo_list";
    }

    /**
     * 분반별칭 저장
     *
     * @param vo
     * @param userCtx
     * @param request
     * @return ProcessResultVO<SbjctInfoAliasVO>
     * @throws Exception
     */
    @RequestMapping(value = "/aliasSave.do")
    @ResponseBody
    public ProcessResultVO<SbjctInfoAliasVO> aliasSave(
            SbjctInfoAliasVO vo,
            @CurrentUser UserContext userCtx,
            HttpServletRequest request) throws Exception {

        validateSbjctAdmAccess(vo.getSbjctId(), userCtx);
        vo.setMdfrId(userCtx.getUserId());

        int updateCnt = sbjctInfoService.saveSbjctInfoAlias(vo);

        ProcessResultVO<SbjctInfoAliasVO> resultVO = new ProcessResultVO<>();
        if (updateCnt > 0) {
            resultVO.setResultSuccess();
            resultVO.setEncParams(getEncParams());
        } else {
            resultVO.setResultFailed();
            resultVO.setMessage("저장할 분반 정보가 없습니다.");
            resultVO.setEncParams(getEncParams());
        }

        return resultVO;
    }
    /**
     * 돌발퀴즈 미리보기 팝업 조회
     *
     * @param vo
     * @param userCtx
     * @param model
     * @return sbjctinfo/popup/sbjctinfo_quiz_preview_popup
     * @throws Exception
     */
    @RequestMapping(value = "/quizPreview.do")
    public String quizPreview(SbjctInfoQuizPreviewVO vo, @CurrentUser UserContext userCtx, ModelMap model) throws Exception {
        validateSbjctAdmAccess(vo.getSbjctId(), userCtx);
        List<SbjctInfoQuizPreviewVO> quizInfoList = sbjctInfoService.selectQuizPreviewDetail(vo);
        model.addAttribute("quizInfoList", quizInfoList);
        return "sbjctinfo/popup/sbjctinfo_quiz_preview_popup";
    }

    /**
     * 과목 운영자 권한 검증.
     *
     * @param sbjctId
     * @param userCtx
     * @throws Exception
     */
    private void validateSbjctAdmAccess(String sbjctId, UserContext userCtx) throws Exception {
        if (ValidationUtils.isEmpty(sbjctId) || userCtx == null || ValidationUtils.isEmpty(userCtx.getUserId())) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
        SubjectDTO sbjctDto = new SubjectDTO();
        sbjctDto.setSbjctId(sbjctId);
        sbjctDto.setProfIds(
            userCtx.getProfIds() == null || userCtx.getProfIds().isEmpty()
                ? Collections.singletonList(userCtx.getUserId())
                : userCtx.getProfIds()
        );
        if (!subjectService.hasSubjectAuthority(sbjctDto)) {
            throw new AccessDeniedException(getCommonNoAuthMessage());
        }
    }
}
