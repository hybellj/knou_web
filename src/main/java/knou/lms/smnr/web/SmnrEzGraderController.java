package knou.lms.smnr.web;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.lms.common.dto.ResultDTO;
import knou.lms.smnr.facade.SmnrFacadeService;
import knou.lms.smnr.vo.SmnrVO;
import knou.lms.smnr.web.view.SmnrMainView;
import knou.lms.user.CurrentUser;

@Controller
@RequestMapping(value="/smnr/ezgrader")
public class SmnrEzGraderController extends ControllerBase {

	@Resource(name="smnrFacadeService")
	private SmnrFacadeService smnrFacadeService;

	/**
     * EZ-Grader팝업
     *
     * @param sbjctId 	과목아이디
     * @param smnrId 	세미나아이디
     * @return smnr_ez_grader_pop.jsp
     */
    @RequestMapping(value="/smnrEzGraderPopup.do")
    public String smnrEzGraderPopup(SmnrVO vo, ModelMap model, HttpServletRequest request) {
        model.addAttribute("vo", smnrFacadeService.loadSmnrEzgraderPopup(vo).getEgovMap());

        return "smnr/ezgrader/smnr_ez_grader_pop";
    }

    /**
     * 교수세미나참석목록조회
     *
     * @param smnrId     	세미나아이디
     * @param sbjctId 		과목아이디
     * @param searchKey  	참석여부
     * @param searchSort  	정렬코드
     * @return 교수세미나참석목록
     */
    @RequestMapping(value="/profSmnrAtndListByEzGraderAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profSmnrAtndListByEzGraderAjax(SmnrVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(smnrFacadeService.getSmnrAtndListByEzGrader(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 교수세미나참석이력목록조회
     *
     * @param smnrId     	세미나아이디
     * @param userId 		사용자아이디
     * @return 교수설문답변목록
     */
    @RequestMapping(value="/profSmnrAtndHstryListByEzGraderAjax.do")
    @ResponseBody
    public ResultDTO<SmnrMainView> profSmnrAtndHstryListByEzGraderAjax(SmnrVO vo, @RequestBody Map<String, Object> params, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<SmnrMainView>().setData(smnrFacadeService.getProfSmnrAtndHstryListByEzGrader(params, userCtx)).setResultSuccess();
    }

}
