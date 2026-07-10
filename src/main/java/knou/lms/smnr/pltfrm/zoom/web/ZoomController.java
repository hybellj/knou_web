package knou.lms.smnr.pltfrm.zoom.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.lms.common.dto.ResultDTO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomMeetingVO;
import knou.lms.smnr.pltfrm.zoom.service.ZoomApiService;
import knou.lms.smnr.vo.SmnrTrgtrVO;
import knou.lms.smnr.vo.SmnrVO;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value="/zoom")
public class ZoomController extends ControllerBase {

	@Resource(name="zoomApiService2")
	private ZoomApiService zoomApiService;

	/**
     * ZOOM호스트url조회
     *
     * @param smnrId     세미나아이디
     * @return ZOOM호스트url
     */
    @RequestMapping(value="/zoomHostUrlSelectAjax.do")
    @ResponseBody
    public ResultDTO<ZoomMeetingVO> zoomHostUrlSelectAjax(SmnrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        vo.setOrgId(userCtx.getOrgId());

        return zoomApiService.zoomMeetingSelect(vo).setResultSuccess();
    }

    /**
     * ZOOM참여자url조회
     *
     * @param smnrId     세미나아이디
     * @return ZOOM참여자url
     */
    @RequestMapping(value="/zoomUserUrlSelectAjax.do")
    @ResponseBody
    public ResultDTO<SmnrTrgtrVO> zoomUserUrlSelectAjax(SmnrVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	String userAgent = request.getHeader("User-Agent").toUpperCase();
	    vo.setUserId(userCtx.getUserId());
	    vo.setOrgId(userCtx.getOrgId());
	    vo.setSubParam(userAgent.indexOf("MOBILE") > -1 ? "MOBILE" : "PC");
	    vo.setRegIp(userCtx.getIP());

    	return zoomApiService.zoomUserUrlSelect(vo).setResultSuccess();
    }

}
