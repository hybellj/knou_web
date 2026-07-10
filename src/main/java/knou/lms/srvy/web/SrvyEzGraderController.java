package knou.lms.srvy.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.lms.common.dto.ResultDTO;
import knou.lms.srvy.facade.SrvyFacadeService;
import knou.lms.srvy.vo.SrvyPtcpVO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.web.view.SrvyMainView;

@Controller
@RequestMapping(value="/srvy/ezgrader")
public class SrvyEzGraderController extends ControllerBase {

	@Resource(name="srvyFacadeService")
	private SrvyFacadeService srvyFacadeService;

	/**
     * EZ-Grader팝업
     *
     * @param srvyId 	설문아이디
     * @return srvy_ez_grader_pop.jsp
     */
    @RequestMapping(value="/srvyEzGraderPopup.do")
    public String srvyEzGraderPopup(SrvyVO vo, ModelMap model, HttpServletRequest request) {
        model.addAttribute("vo", srvyFacadeService.loadSrvyEzgraderPopup(vo).getEgovMap());

        return "srvy/ezgrader/srvy_ez_grader_pop";
    }

    /**
     * 교수설문참여목록조회
     *
     * @param srvyId     	설문아이디
     * @param sbjctId 		과목아이디
     * @param searchKey  	참여여부
     * @param searchSort  	정렬코드
     * @return 교수설문참여목록
     */
    @RequestMapping(value="/profSrvyPtcpListByEzGraderAjax.do")
    @ResponseBody
    public ResultDTO<EgovMap> profSrvyPtcpListByEzGraderAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<EgovMap>().setReturnList(srvyFacadeService.getSrvyPtcpListByEzGrader(vo).getEgovList()).setResultSuccess();
    }

    /**
     * 교수설문답변목록조회
     *
     * @param srvyId     	설문아이디
     * @param userId 		사용자아이디
     * @param srvyPtcpId  	설문참여아이디
     * @return 교수설문답변목록
     */
    @RequestMapping(value="/profSrvyRspnsListByEzGraderAjax.do")
    @ResponseBody
    public ResultDTO<SrvyMainView> profSrvyRspnsListByEzGraderAjax(SrvyPtcpVO vo, ModelMap model, HttpServletRequest request) {
        return new ResultDTO<SrvyMainView>().setData(srvyFacadeService.getProfSrvyRspnsListByEzGrader(vo)).setResultSuccess();
    }

}
