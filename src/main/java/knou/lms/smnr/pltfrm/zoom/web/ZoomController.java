package knou.lms.smnr.pltfrm.zoom.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomMeetingVO;
import knou.lms.smnr.pltfrm.zoom.service.ZoomApiService;
import knou.lms.smnr.vo.SmnrVO;

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
     * @throws Exception
     */
    @RequestMapping(value="/zoomHostUrlSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<ZoomMeetingVO> zoomHostUrlSelectAjax(SmnrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ZoomMeetingVO> resultVO = new ProcessResultVO<ZoomMeetingVO>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
        	vo.setRgtrId(userId);
        	vo.setOrgId(orgId);
            resultVO = zoomApiService.zoomMeetingSelect(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("정보 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

}
