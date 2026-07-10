package knou.lms.crs.sbjct.web;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.crs.sbjct.facade.SbjctAuthHelper;
import knou.lms.crs.sbjct.policy.SbjctOfringAccessPolicy;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.crs.sbjct.vo.SbjctVO;

import org.springframework.ui.ModelMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.net.URI;

/**
 * 과목 도메인 컨트롤러 공통 웹 흐름을 처리한다.
 */
public class SbjctControllerBase extends ControllerBase {

    private static final String OPEN_LCTR_SYSTEM_SBJCT_TYCD = "OPEN_LCTR_SYSTEM";

    @Resource(name="sbjctService")
    private SbjctService accessSbjctService;

    @Resource(name="sbjctAuthHelper")
    private SbjctAuthHelper accessAuthHelper;

    @Resource(name="sbjctOfringAccessPolicy")
    private SbjctOfringAccessPolicy accessPolicy;

    /**
     * 암호화 파라미터와 추가 파라미터를 요청 값 객체에 복원하고 공통 모델 값을 세팅한다.
     * @param request
     * @param model
     * @param param
     * @throws Exception
     */
    protected void initEncryptedParamContext(HttpServletRequest request, ModelMap model, Object param) throws Exception {
        // 목록 화면에서 전달된 encParams/addParams 기준 검색 조건을 다운로드 요청 값에 복원한다.
        init(request, model, param);
    }

    /**
     * 안전한 referer URL이 있으면 해당 URL로 이동하고 없으면 기본 경로로 이동한다.
     * @param request
     * @param defaultUrl
     * @return
     */
    protected String redirectToSafeReferer(HttpServletRequest request, String defaultUrl) {
        String referer = getSafeReferer(request);
        if(StringUtil.isNotNull(referer)) {
            return "redirect:" + referer;
        }
        return "redirect:" + defaultUrl;
    }

    /**
     * 권한 없음 메시지를 세팅한 뒤 안전한 referer URL 또는 기본 경로로 이동한다.
     * @param request
     * @param defaultUrl
     * @return
     */
    protected String redirectNoAuthToSafeReferer(HttpServletRequest request, String defaultUrl) {
        setResultFail(getMessage("common.system.no_auth"));/*사용권한이 없거나 로그아웃되었습니다. 다시 로그인하세요.*/
        return redirectToSafeReferer(request, defaultUrl);
    }

    /**
     * 화면 구성에 필요한 일반 과목개설 상세 정보를 조회하고 접근 가능 여부를 확인한다.
     * @param sbjctId
     * @param userCtx
     * @return
     */
    protected SbjctVO resolveSbjctOfringViewAccess(String sbjctId, UserContext userCtx) {
        return resolveSbjctAccess(sbjctId, userCtx, true, false);
    }

    /**
     * 비동기 처리에 필요한 일반 과목개설 접근 정보를 조회하고 접근 가능 여부를 확인한다.
     * @param sbjctId
     * @param userCtx
     * @return
     */
    protected SbjctVO resolveSbjctOfringAsyncAccess(String sbjctId, UserContext userCtx) {
        return resolveSbjctAccess(sbjctId, userCtx, false, false);
    }

    /**
     * 화면 구성에 필요한 공개강좌개설 상세 정보를 조회하고 접근 가능 여부를 확인한다.
     * @param sbjctId
     * @param userCtx
     * @return
     */
    protected SbjctVO resolveOpenLctrOfringViewAccess(String sbjctId, UserContext userCtx) {
        return resolveSbjctAccess(sbjctId, userCtx, true, true);
    }

    /**
     * 비동기 처리에 필요한 공개강좌개설 접근 정보를 조회하고 접근 가능 여부를 확인한다.
     * @param sbjctId
     * @param userCtx
     * @return
     */
    protected SbjctVO resolveOpenLctrOfringAsyncAccess(String sbjctId, UserContext userCtx) {
        return resolveSbjctAccess(sbjctId, userCtx, false, true);
    }

    /**
     * 과목개설 요청 성격과 공개강좌 여부에 맞는 접근 정보를 조회한다.
     * @param sbjctId
     * @param userCtx
     * @param viewAccess
     * @param openLctrOnly
     * @return
     */
    private SbjctVO resolveSbjctAccess(String sbjctId, UserContext userCtx, boolean viewAccess, boolean openLctrOnly) {
        if(StringUtil.isNull(sbjctId) || userCtx == null) {
            return null;
        }

        SbjctVO accessVO;
        if(viewAccess) {
            SbjctVO searchVO = new SbjctVO();
            searchVO.setSbjctId(sbjctId);
            searchVO.setLangCd(userCtx.getLangCd());
            accessVO = accessSbjctService.selectSbjctOfring(searchVO);
        } else {
            accessVO = accessPolicy.selectSbjctOfringAccess(sbjctId);
        }

        if(openLctrOnly && (accessVO == null || !OPEN_LCTR_SYSTEM_SBJCT_TYCD.equals(accessVO.getSbjctTycd()))) {
            return null;
        }
        return canAccessSbjctOfring(accessVO, userCtx) ? accessVO : null;
    }

    /**
     * 로그인 사용자가 과목개설 기관에 접근할 수 있는지 확인한다.
     * @param savedVO
     * @param userCtx
     * @return
     */
    private boolean canAccessSbjctOfring(SbjctVO savedVO, UserContext userCtx) {
        return accessPolicy.canAccessOrg(
                savedVO,
                userCtx,
                accessAuthHelper.isSystemAdmin(userCtx));
    }

    /**
     * 로그인 사용자가 과목개설 후속 단계를 관리할 수 있는지 확인한다.
     * @param savedVO
     * @param userCtx
     * @return
     */
    protected boolean canManageNextStep(SbjctVO savedVO, UserContext userCtx) {
        return accessPolicy.canManageNextStep(
                savedVO,
                userCtx,
                accessAuthHelper.isSystemAdmin(userCtx));
    }

    /**
     * 동일 출처이면서 현재 요청과 다른 referer URL만 반환한다.
     * @param request
     * @return
     */
    protected String getSafeReferer(HttpServletRequest request) {
        String referer = request.getHeader("referer");
        if(StringUtil.isNull(referer)) {
            return "";
        }

        try {
            URI refererUri = URI.create(referer);
            URI requestUri = URI.create(request.getRequestURL().toString());
            boolean sameOrigin = StringUtil.nvl(refererUri.getScheme()).equalsIgnoreCase(StringUtil.nvl(requestUri.getScheme()))
                    && StringUtil.nvl(refererUri.getHost()).equalsIgnoreCase(StringUtil.nvl(requestUri.getHost()))
                    && refererUri.getPort() == requestUri.getPort();
            boolean sameRequest = StringUtil.nvl(refererUri.getPath()).equals(StringUtil.nvl(requestUri.getPath()))
                    && StringUtil.nvl(refererUri.getQuery()).equals(StringUtil.nvl(request.getQueryString()));
            return sameOrigin && !sameRequest ? referer : "";
        } catch(IllegalArgumentException e) {
            return "";
        }
    }

    /**
     * 실패 결과에 메시지가 없으면 공통 실패 메시지를 보정한다.
     * @param resultDTO
     * @return
     */
    protected <T> ResultDTO<T> withFailMessage(ResultDTO<T> resultDTO) {
        if (resultDTO != null && resultDTO.getResult() < 0 && StringUtil.isNull(resultDTO.getMessage())) {
            resultDTO.setMessage(getCommonFailMessage());
        }
        return resultDTO;
    }

    /**
     * 저장 성공 결과 메시지를 세팅한다.
     * @param resultDTO
     * @return
     */
    protected <T> ResultDTO<T> successSave(ResultDTO<T> resultDTO) {
        return resultDTO.setResultSuccess(getMessage("success.common.save"));/*정상적으로 저장되었습니다.*/
    }

    /**
     * 권한 없음 실패 결과를 반환한다.
     * @param resultDTO
     * @return
     */
    protected <T> ResultDTO<T> noAuthResult(ResultDTO<T> resultDTO) {
        return resultDTO.setResultFailed(getMessage("common.system.no_auth"));/*사용권한이 없거나 로그아웃되었습니다. 다시 로그인하세요.*/
    }
}
