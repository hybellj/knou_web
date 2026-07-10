package knou.lms.forum2.web;

import java.net.URI;

import javax.servlet.http.HttpServletRequest;

import knou.framework.common.ControllerBase;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;

/**
 * forum2 컨트롤러 공통 기능을 제공한다.
 */
public abstract class DscsControllerBase extends ControllerBase {

    /**
     * 안전한 referer가 있으면 referer로, 없으면 기본 URL로 redirect한다.
     * @param request
     * @param defaultUrl
     * @return
     */
    protected String redirectToSafeReferer(HttpServletRequest request, String defaultUrl) {

        String referer = getSafeReferer(request);
        if (StringUtil.isNotNull(referer)) {
            return "redirect:" + referer;
        }
        return "redirect:" + defaultUrl;
    }

    /**
     * 동일 출처이며 현재 요청과 다른 referer를 반환한다.
     * @param request
     * @return
     */
    protected String getSafeReferer(HttpServletRequest request) {

        String referer = request.getHeader("referer");
        if (StringUtil.isNull(referer)) {
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
        } catch (IllegalArgumentException e) {
            return "";
        }
    }

    /**
     * 실패 결과에 메시지가 없으면 기본 실패 메시지를 설정한다.
     * @param resultVO
     * @return
     */
    protected <T> ProcessResultVO<T> withFailMessage(ProcessResultVO<T> resultVO) {

        if (resultVO != null && resultVO.getResult() < 0) {
            String message = resultVO.getMessage();
            if (StringUtil.isNull(message)) {
                resultVO.setMessage(getCommonFailMessage());
            }
        }
        return resultVO;
    }
}
