package knou.lms.smnr.pltfrm.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.lms.common.dto.ResultDTO;
import knou.lms.smnr.pltfrm.facade.SmnrPltfrmFacadeService;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmStngVO;
import knou.lms.smnr.pltfrm.web.view.SmnrPltfrmMainView;
import knou.lms.smnr.web.view.SmnrPageInfo;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value="/smnr/pltfrm")
public class SmnrPltfrmController extends ControllerBase {

	@Resource(name="smnrPltfrmFacadeService")
	private SmnrPltfrmFacadeService smnrPltfrmFacadeService;

	/**
     * 관리자ZOOM권한사용자관리화면
     *
     * @return adm_zoom_authrt_user_mng_view.jsp
     */
    @RequestMapping(value="/admZoomAuthrtUserMngView.do")
    public String admZoomAuthrtUserMngView(OnlnPltfrmStngVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("orgList", smnrPltfrmFacadeService.loadAdmZoomAuthrtUserMngView().getOrgList());
    	model.addAttribute("userCtx", userCtx);
    	model.addAttribute("vo", vo);

        return "smnr/adm_zoom_authrt_user_mng_view";
    }

    /**
     * 관리자온라인플랫폼권한목록조회
     *
     * @param orgId     	기관아이디
     * @param searchValue 	검색어 ( 계정이메일 )
     * @param pltfrmGbncd 	플랫폼구분코드
     * @return 온라인플랫폼권한목록
     */
    @RequestMapping(value="/admOnlnPltfrmAuthrtListAjax.do")
    @ResponseBody
    public ResultDTO<SmnrPltfrmMainView> admOnlnPltfrmAuthrtListAjax(OnlnPltfrmStngVO vo, SmnrPageInfo pageInfo, ModelMap model, HttpServletRequest request) {
    	ResultDTO<SmnrPltfrmMainView> resultVO = new ResultDTO<SmnrPltfrmMainView>();
        resultVO.setData(smnrPltfrmFacadeService.getOnlnPltfrmAuthrtList(vo, pageInfo));
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 관리자계정등록(수정)팝업
     *
     * @param orgId 			기관아이디
     * @param pltfrmGbncd 		플랫폼구분코드
     * @param onlnPltfrmStngId 	온라인플랫폼설정아이디
     * @return adm_acnt_regist_pop.jsp
     */
    @RequestMapping(value="/admAcntRegistPopup.do")
    public String admAcntRegistPopup(OnlnPltfrmStngVO vo, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("orgList", smnrPltfrmFacadeService.loadAdmAcntRegistPopup().getOrgList());
    	model.addAttribute("vo", vo);

        return "smnr/popup/adm_acnt_regist_pop";
    }

    /**
     * 온라인플랫폼관리자계정등록
     *
     * @param OnlnPltfrmStngVO	온라인플랫폼설정정보
     * @return ResultDTO<EgovMap>
     */
    @RequestMapping(value="/admOnlnPltfrmAdmAcntRegistAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> admOnlnPltfrmAdmAcntRegistAjax(OnlnPltfrmStngVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        vo.setRgtrId(userCtx.getUserId());
        return smnrPltfrmFacadeService.admAcntRegist(vo).getResultDTO();
    }

    /**
     * 온라인플랫폼관리자계정삭제
     *
     * @param OnlnPltfrmStngVO	온라인플랫폼설정정보
     * @return ResultDTO<OnlnPltfrmStngVO>
     */
    @RequestMapping(value="/admOnlnPltfrmAdmAcntDeleteAjax.do")
    @ResponseBody
    public ResultDTO<OnlnPltfrmStngVO> admOnlnPltfrmAdmAcntDeleteAjax(OnlnPltfrmStngVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
	    vo.setRgtrId(userCtx.getUserId());
	    smnrPltfrmFacadeService.admAtncDelete(vo);

    	return new ResultDTO<OnlnPltfrmStngVO>().setResultSuccess();
    }

    /**
     * 생성ZOOM수조회
     *
     * @param onlnPltfrmStngId 	온라인플랫폼설정아이디
     * @return 생성ZOOM수
     */
    @RequestMapping(value="/admCreateZoomCntSelectAjax.do")
    @ResponseBody
    public ResultDTO<OnlnPltfrmStngVO> admCreateZoomCntSelectAjax(OnlnPltfrmStngVO vo, ModelMap model, HttpServletRequest request) {
    	ResultDTO<OnlnPltfrmStngVO> resultVO = new ResultDTO<OnlnPltfrmStngVO>();
        resultVO.setResult(smnrPltfrmFacadeService.createZoomCntSelect(vo));

        return resultVO;
    }

    /**
     * 관리자ZOOM권한목록동기화팝업
     *
     * @param orgId 		기관아이디
     * @param pltfrmGbncd 	플랫폼구분코드
     * @return adm_zoom_authrt_list_sync_pop.jsp
     */
    @RequestMapping(value="/admZoomAuthrtListSyncPopup.do")
    public String admZoomAuthrtListSyncPopup(OnlnPltfrmStngVO vo, ModelMap model, HttpServletRequest request) {
    	model.addAttribute("onlnPltfrmAuthrtList", smnrPltfrmFacadeService.loadAdmZoomAuthrtListSyncPopup(vo).getOnlnPltfrmAuthrtList());
    	model.addAttribute("vo", vo);

        return "smnr/popup/adm_zoom_authrt_list_sync_pop";
    }

    /**
     * ZOOM사용자동기화
     *
     * @param orgId 	기관아이디
     * @param userId 	사용자아이디
     */
    @RequestMapping(value="/admZoomUserSyncAjax.do")
    @ResponseBody
    public ResultDTO<OnlnPltfrmStngVO> zoomUserSyncAjax(OnlnPltfrmStngVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
    	ResultDTO<OnlnPltfrmStngVO> resultVO = new ResultDTO<OnlnPltfrmStngVO>();
        vo.setUserId(userCtx.getUserId());
        resultVO.setResult(smnrPltfrmFacadeService.zoomUserBulkRegist(vo));

        return resultVO;
    }

	/**
     * 대기중온라인플랫폼사용자수조회
     *
     * @param pltfrmGbncd		플랫폼구분코드
	 * @param meetngrmSdttm		회의실시작일시
	 * @param meetngrmEdttm		회의실종료일시
     * @return 대기중온라인플랫폼사용자수
     */
    @RequestMapping(value="/pendingOnlnPltfrmUserCntSelectAjax.do")
    @ResponseBody
    public ResultDTO<OnlnPltfrmStngVO> pendingOnlnPltfrmUserCntSelectAjax(@CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="subSmnrs", defaultValue="[]") String subSmnrsStr) {
    	ResultDTO<OnlnPltfrmStngVO> resultVO = new ResultDTO<OnlnPltfrmStngVO>();

        try {
        	ObjectMapper mapper = new ObjectMapper();
        	List<Map<String, Object>> subSmnrs = mapper.readValue(subSmnrsStr, new TypeReference<List<Map<String, Object>>>() {});
        	subSmnrs.forEach(map -> map.put("orgId", userCtx.getOrgId()));
            resultVO.setResult(smnrPltfrmFacadeService.getPendingOnlnPltfrmUserCntSelect(subSmnrs));
        } catch(JsonProcessingException e) {
            resultVO.setResult(-1);
            resultVO.setMessage("정보 조회 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

}
