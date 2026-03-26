package knou.lms.srvy.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.lms.common.vo.ProcessResultVO;
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
     * @param sbjctId 	과목아이디
     * @param srvyId 	설문아이디
     * @return srvy_ez_grader_pop.jsp
     * @throws Exception
     */
    @RequestMapping(value="/srvyEzGraderPopup.do")
    public String srvyEzGraderPopup(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	SrvyMainView srvyMainView = srvyFacadeService.loadSrvyEzgraderPopup(vo);

        model.addAttribute("vo", srvyMainView.getSrvyEgovMap());

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
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyPtcpListByEzGraderAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profSrvyPtcpListByEzGraderAjax(SrvyVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
        	SrvyMainView srvyMainView = srvyFacadeService.getSrvyPtcpListByEzGrader(vo);
        	resultVO.setReturnList(srvyMainView.getSrvyPtcpList());
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수설문답변목록조회
     *
     * @param srvyId     	설문아이디
     * @param userId 		사용자아이디
     * @param srvyPtcpId  	설문참여아이디
     * @return 교수설문답변목록
     * @throws Exception
     */
    @RequestMapping(value="/profSrvyRspnsListByEzGraderAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profSrvyRspnsListByEzGraderAjax(SrvyPtcpVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
        	SrvyMainView srvyMainView = srvyFacadeService.getProfSrvyRspnsListByEzGrader(vo);
        	resultVO.setReturnVO(srvyMainView);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

}
