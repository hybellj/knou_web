package knou.lms.lecture2.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.lms.common.dto.ResultDTO;
import knou.lms.lecture2.service.LectureService;
import knou.lms.lecture2.vo.LectureVO;
import knou.lms.user.CurrentUser;
import knou.lms.user.service.UserPrfilService;
import knou.lms.user.vo.UserPrfilVO;

@Controller
@RequestMapping(value="/lctr")
public class LectureController extends ControllerBase {
	
	private static final Logger log = LoggerFactory.getLogger(LectureController.class);
	
	@Resource(name="lectureService")
    private LectureService lectureService;
	
	@Resource(name="userPrfilService")
    private UserPrfilService userPrfilService;
	
	@RequestMapping(value="/lectureView.do")
    public String	lectureView(LectureVO lectureVO, @CurrentUser UserContext userCtx,
                                                 ModelMap model, HttpServletRequest request) throws Exception {
        return "/lecture/lecture";
    }	
	
	@RequestMapping(value="/attandanceListView.do")
    public String	attandanceListView(LectureVO lectureVO, @CurrentUser UserContext userCtx,
                                                 ModelMap model, HttpServletRequest request) throws Exception {		
        return "/lecture/atndc_manage_list";
    }
	
	@RequestMapping(value="/attandanceList.do")
	@ResponseBody
    public ResultDTO<EgovMap>	attandanceList(LectureVO lectureVO, @CurrentUser UserContext userCtx,
                                                 ModelMap model, HttpServletRequest request) throws Exception {		
        return new ResultDTO<EgovMap>().setReturnList(lectureService.attandanceList(lectureVO)).setResultSuccess();
    }
	
	@RequestMapping(value="/attandanceDetailView.do")
    public String	attandanceDetailView(LectureVO lectureVO, @CurrentUser UserContext userCtx,
                                                 ModelMap model, HttpServletRequest request) throws Exception {
		
		//1 학생정보
		model.addAttribute("stdntProfileVO", userPrfilService.userPrfilSelect(new UserPrfilVO(lectureVO.getStdntId()))); // 학생정보 설정
		
		//2	주차정보 -- 과목의 모든주자정보를 가져와서 SELECT BOX에 넣어야 함.
		
		//3 차시정보	
		//model.addAttribute("stdntProfileVO", lectureService.byWknoStdntAttandanceList(lectureVO.getStdntId());
		
		//4 학습기록
		
		model.addAttribute("lecturVO", lectureVO);		
		
		return "/lecture/atndc_manage_detail";
    }
	
	@RequestMapping(value="/byWknoStdntAttandanceList.do") // 학생의주차별출석목록
	@ResponseBody
    public ResultDTO<EgovMap>	byWknoStdntAttandanceList(LectureVO lectureVO, @CurrentUser UserContext userCtx,
                                                 ModelMap model, HttpServletRequest request) throws Exception {
		log.info(lectureVO.toString());
        return new ResultDTO<EgovMap>().setReturnList(lectureService.byWknoStdntAttandanceList(lectureVO)).setResultSuccess();
    }
	
	
	@RequestMapping(value="/lecturePreview.do")
    public String	lecturePreview(LectureVO lectureVO, @CurrentUser UserContext userCtx,
                                                 ModelMap model, HttpServletRequest request) throws Exception {
        return "/lecture/lecture_preview";
    }
}