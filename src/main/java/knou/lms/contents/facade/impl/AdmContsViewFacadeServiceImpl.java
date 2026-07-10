package knou.lms.contents.facade.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.RepoInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.StringUtil;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.contents.facade.AdmContsViewFacadeService;
import knou.lms.contents.facade.ContsAuthHelper;
import knou.lms.contents.service.ContsService;
import knou.lms.contents.web.paging.ContsExrcsQstnPageInfo;
import knou.lms.contents.web.paging.ContsPageInfo;
import knou.lms.contents.web.paging.ContsSddnQstnPageInfo;
import knou.lms.contents.vo.LctrContsVO;
import knou.lms.contents.vo.LctrWknoSchdlVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.org.service.OrgInfoService;

@Service("admContsViewFacadeService")
public class AdmContsViewFacadeServiceImpl implements AdmContsViewFacadeService {

    @Resource(name = "contsAuthHelper")
    private ContsAuthHelper contsAuthHelper;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    @Resource(name = "contsService")
    private ContsService contsService;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    @Resource(name = "cmmnCdService")
    private CmmnCdService cmmnCdService;

    @Resource(name = "messageSource")
    private MessageSource messageSource;

    /**
     * 관리자 권한에 맞는 기관 목록과 화면 기본값을 구성한다.
     * @param pageInfo
     * @param userCtx
     * @return
     * @throws Exception
     */
    @Override
    public Map<String, Object> listView(ContsPageInfo pageInfo, UserContext userCtx) throws Exception {
        String orgId = contsAuthHelper.resolveSearchOrgId(pageInfo.getOrgId(), userCtx);
        boolean fixedOrg = !contsAuthHelper.isSystemAdmin(userCtx);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("orgList", contsAuthHelper.filterOrgListByRole(orgInfoService.listActiveOrg(), orgId, fixedOrg));
        resultMap.put("orgId", orgId);
        resultMap.put("fixedOrgYn", fixedOrg ? "Y" : "N");
        resultMap.put("menuType", CommConst.AUTHRT_GRPCD_ADM);
        resultMap.put("authGrpCd", userCtx.getAuthrtCd());
        resultMap.put("contsPageInfo", pageInfo);
        return resultMap;
    }

    /**
     * 강의주차일정 조회 결과를 팝업 모델로 구성한다.
     * @param vo
     * @param userCtx
     * @return
     */
    @Override
    public Map<String, Object> lctrWknoSchdlMngPop(LctrWknoSchdlVO vo, UserContext userCtx) {
        String orgId = contsAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx);
        vo.setOrgId(orgId);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        LctrWknoSchdlVO detail = contsService.selectAdmLctrWknoSchdl(vo);
        if(detail == null) {
            resultMap.put("message", getMessage("fail.common.select"));/*조회에 실패하였습니다.*/
            resultMap.put("lctrWknoSchdlVO", vo);
            return resultMap;
        }

        detail.setOrgId(orgId);
        resultMap.put("lctrWknoSchdlVO", detail);
        return resultMap;
    }

    /**
     * 동영상 등록/수정 팝업 모델을 구성한다.
     * @param lctrContsVO
     * @param request
     * @param userCtx
     * @return
     */
    @Override
    public Map<String, Object> lctrContsVideoRegistPop(LctrContsVO lctrContsVO, HttpServletRequest request, UserContext userCtx) {
        String orgId = contsAuthHelper.resolveSearchOrgId(lctrContsVO.getOrgId(), userCtx);
        lctrContsVO.setOrgId(orgId);

        String mode = StringUtil.nvl(lctrContsVO.getMode(), "C").toUpperCase();
        LctrContsVO detail = lctrContsVO;
        // 수정 모드에서만 기존 콘텐츠와 하위 콘텐츠를 화면에 복원한다.
        if("E".equals(mode) && !StringUtil.isNull(lctrContsVO.getLctrContsId())) {
            LctrContsVO saved = contsService.selectAdmLctrConts(lctrContsVO);
            if(saved != null) {
                detail = saved;
                detail.setOrgId(orgId);
                detail.setMode(mode);
                bindVideoChildContext(detail);
            }
        }

        LctrContsVO uploadContext = contsService.selectAdmLctrContsUploadContext(lctrContsVO);
        if(uploadContext != null) {
            applyUploadContext(detail, uploadContext);
        }
        detail.setMode(mode);
        detail.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_CONTS, buildContsUploadAddPath(detail)));

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("lctrContsVO", detail);
        resultMap.put("langCdList", selectLangCdList());
        resultMap.put("mode", mode);
        return resultMap;
    }

    /**
     * 연습문제 등록/수정 팝업 모델을 구성한다.
     * @param lctrContsVO
     * @param userCtx
     * @return
     */
    @Override
    public Map<String, Object> lctrContsExrcsQstnRegistPop(LctrContsVO lctrContsVO, UserContext userCtx) {
        String orgId = contsAuthHelper.resolveSearchOrgId(lctrContsVO.getOrgId(), userCtx);
        lctrContsVO.setOrgId(orgId);

        String mode = StringUtil.nvl(lctrContsVO.getMode(), "C").toUpperCase();
        LctrContsVO detail = lctrContsVO;
        if("E".equals(mode) && !StringUtil.isNull(lctrContsVO.getLctrContsId())) {
            LctrContsVO saved = contsService.selectAdmLctrConts(lctrContsVO);
            if(saved != null) {
                detail = saved;
                detail.setOrgId(orgId);
                detail.setMode(mode);
            }
        }

        LctrContsVO uploadContext = contsService.selectAdmLctrContsUploadContext(lctrContsVO);
        if(uploadContext != null) {
            applyUploadContext(detail, uploadContext);
        }
        detail.setMode(mode);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("lctrContsVO", detail);
        resultMap.put("weekContsList", contsService.selectAdmLctrContsWeekList(detail));
        resultMap.put("dvclasList", "E".equals(mode) ? Collections.emptyList() : contsService.selectAdmLctrContsDvclasTargetList(detail));
        resultMap.put("mode", mode);
        return resultMap;
    }

    /**
     * 소셜 콘텐츠 등록/수정 팝업 모델을 구성한다.
     * @param lctrContsVO
     * @param request
     * @param userCtx
     * @return
     */
    @Override
    public Map<String, Object> lctrContsSnsRegistPop(LctrContsVO lctrContsVO, HttpServletRequest request, UserContext userCtx) {
        String orgId = contsAuthHelper.resolveSearchOrgId(lctrContsVO.getOrgId(), userCtx);
        lctrContsVO.setOrgId(orgId);

        String mode = StringUtil.nvl(lctrContsVO.getMode(), "C").toUpperCase();
        LctrContsVO detail = lctrContsVO;
        // 수정 모드에서는 저장된 소셜 콘텐츠 정보를 팝업 입력값으로 복원한다.
        if("E".equals(mode) && !StringUtil.isNull(lctrContsVO.getLctrContsId())) {
            LctrContsVO saved = contsService.selectAdmLctrConts(lctrContsVO);
            if(saved != null) {
                detail = saved;
                detail.setOrgId(orgId);
                detail.setMode(mode);
            }
        }

        // 학습목차 에디터에서 사용할 콘텐츠 업로드 경로 정보를 구성한다.
        LctrContsVO uploadContext = contsService.selectAdmLctrContsUploadContext(lctrContsVO);
        if(uploadContext != null) {
            applyUploadContext(detail, uploadContext);
        }
        detail.setMode(mode);
        detail.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_CONTS, buildContsUploadAddPath(detail)));

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("lctrContsVO", detail);
        resultMap.put("mode", mode);
        return resultMap;
    }

    /**
     * 콘텐츠 업로드 저장소 하위 경로를 과목 기준으로 구성한다.
     * @param lctrContsVO
     * @return
     */
    private String buildContsUploadAddPath(LctrContsVO lctrContsVO) {
        if(StringUtil.isNull(lctrContsVO.getSbjctYr()) || StringUtil.isNull(lctrContsVO.getSbjctSmstr()) || StringUtil.isNull(lctrContsVO.getSbjctnm())) {
            return null;
        }
        return sanitizePathSegment(lctrContsVO.getSbjctYr() + "_" + lctrContsVO.getSbjctSmstr() + "_" + lctrContsVO.getSbjctnm());
    }

    /**
     * 업로드 경로와 팝업 표시에 필요한 주차 정보를 상세 VO에 반영한다.
     * @param detail
     * @param uploadContext
     */
    private void applyUploadContext(LctrContsVO detail, LctrContsVO uploadContext) {
        detail.setSbjctId(uploadContext.getSbjctId());
        detail.setLctrWknoSchdlId(uploadContext.getLctrWknoSchdlId());
        detail.setLctrId(StringUtil.nvl(detail.getLctrId(), uploadContext.getLctrId()));
        detail.setSbjctYr(uploadContext.getSbjctYr());
        detail.setSbjctSmstr(uploadContext.getSbjctSmstr());
        detail.setSbjctnm(uploadContext.getSbjctnm());
        detail.setLctrWkno(uploadContext.getLctrWkno());
        detail.setLctrWknonm(uploadContext.getLctrWknonm());
        detail.setLctrWknoSymd(uploadContext.getLctrWknoSymd());
        detail.setLctrWknoEymd(uploadContext.getLctrWknoEymd());
    }

    /**
     * 저장된 동영상 하위 콘텐츠와 첨부파일 목록을 팝업 모델에 반영한다.
     * @param detail
     */
    private void bindVideoChildContext(LctrContsVO detail) {
        List<LctrContsVO> childList = contsService.selectAdmLctrContsChildren(detail);
        for(LctrContsVO child : childList) {
            String contsType = StringUtil.nvl(child.getLctrContsTycd());
            String vdoQltyGbncd = StringUtil.nvl(child.getVdoQltyGbncd());
            List<AtflVO> fileList = selectFileList(child.getLctrContsId());
            if("VIDEO".equals(contsType) && "SD".equals(vdoQltyGbncd)) {
                detail.setSdVideoContsId(child.getLctrContsId());
                detail.setSdVideoFileId(child.getContsFileId());
                detail.setSdVideoFileList(fileList);
            } else if("VIDEO".equals(contsType) && "HD".equals(vdoQltyGbncd)) {
                detail.setHdVideoContsId(child.getLctrContsId());
                detail.setHdVideoFileId(child.getContsFileId());
                detail.setHdVideoFileList(fileList);
            } else if("SRT".equals(contsType)) {
                detail.setSrtContsId(child.getLctrContsId());
                detail.setSrtFileId(child.getContsFileId());
                detail.setSrtFileList(fileList);
                child.setSrtContsId(child.getLctrContsId());
                child.setSrtFileId(child.getContsFileId());
                child.setSrtFileList(fileList);
                detail.getSrtContsList().add(child);
            } else if("SDDN_QSTN".equals(contsType)) {
                detail.getChildContsList().add(child);
            }
        }
    }

    /**
     * 첨부파일 참조아이디 기준으로 파일 목록을 조회한다.
     * @param refId
     * @return
     */
    private List<AtflVO> selectFileList(String refId) {
        AtflVO atflVO = new AtflVO();
        atflVO.setRefId(refId);
        return attachFileService.selectAtflListByRefId(atflVO);
    }

    /**
     * 파일 경로에 사용할 수 없는 문자를 치환한다.
     * @param value
     * @return
     */
    private String sanitizePathSegment(String value) {
        return StringUtil.nvl(value).trim().replaceAll("[\\\\/:*?\"<>|]", "_");
    }

    /**
     * 언어코드 목록을 조회한다.
     * @return
     */
    private List<CmmnCdVO> selectLangCdList() {
        try {
            return removeDefaultCode(cmmnCdService.listCode(null, "LANG_CD").getReturnList());
        } catch(Exception e) {
            return Collections.emptyList();
        }
    }

    /**
     * 공통코드 목록에서 기본 선택 항목을 제거한다.
     * @param codeList
     * @return
     */
    private List<CmmnCdVO> removeDefaultCode(List<CmmnCdVO> codeList) {
        if(codeList == null || codeList.isEmpty()) {
            return Collections.emptyList();
        }

        List<CmmnCdVO> filteredList = new ArrayList<CmmnCdVO>();
        for(CmmnCdVO codeVO : codeList) {
            if(codeVO != null && (codeVO.getCdSeqno() == null || codeVO.getCdSeqno() != 0)) {
                filteredList.add(codeVO);
            }
        }
        return filteredList;
    }

    /**
     * 돌발퀴즈 선택 팝업 모델을 구성한다.
     * @param pageInfo
     * @param userCtx
     * @return
     */
    @Override
    public Map<String, Object> lctrContsSddnQstnListPop(ContsSddnQstnPageInfo pageInfo, UserContext userCtx) {
        String orgId = contsAuthHelper.resolveSearchOrgId(pageInfo.getOrgId(), userCtx);
        pageInfo.setOrgId(orgId);
        pageInfo.setLangCd(userCtx.getLangCd());

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("contsSddnQstnPageInfo", pageInfo);
        resultMap.put("orgId", orgId);
        return resultMap;
    }

    /**
     * 연습문제 선택 팝업 모델을 구성한다.
     * @param pageInfo
     * @param userCtx
     * @return
     */
    @Override
    public Map<String, Object> lctrContsExrcsQstnListPop(ContsExrcsQstnPageInfo pageInfo, UserContext userCtx) {
        String orgId = contsAuthHelper.resolveSearchOrgId(pageInfo.getOrgId(), userCtx);
        pageInfo.setOrgId(orgId);
        pageInfo.setLangCd(userCtx.getLangCd());
        pageInfo.setSearchSbjctId(StringUtil.nvl(pageInfo.getSearchSbjctId(), pageInfo.getSbjctId()));

        LctrContsVO lctrContsVO = new LctrContsVO();
        lctrContsVO.setOrgId(orgId);
        lctrContsVO.setSbjctId(pageInfo.getSbjctId());
        lctrContsVO.setLctrWkno(pageInfo.getLctrWkno());

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("contsExrcsQstnPageInfo", pageInfo);
        resultMap.put("sbjctDvclasList", contsService.selectAdmLctrContsDvclasList(lctrContsVO));
        resultMap.put("orgId", orgId);
        return resultMap;
    }

    /**
     * 현재 요청 언어에 맞는 메시지를 반환한다.
     * @param messageKey
     * @return
     */
    private String getMessage(String messageKey) {
        return messageSource.getMessage(messageKey, null, messageKey, LocaleContextHolder.getLocale());
    }
}
