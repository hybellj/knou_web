package knou.lms.crscls.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.lms.user.CurrentUser;
import knou.lms.clssts.vo.ClsStdntVO;

/**
 * 강의실 수업현황 메뉴 어댑터 Controller
 */
@Controller
@RequestMapping(value = "/crscls")
public class CrsClsController extends ControllerBase {

    /**
     * 강의실 수업현황 화면을 수업현황 강의실 상세 화면으로 전달한다.
     *
     * @param vo
     * @param model
     * @param request
     * @return forward:/clssts/selectClsStsClassDetailView.do
     * @throws Exception
     */
    @RequestMapping(value = "/selectCrsClsStdntListView.do")
    public String selectCrsClsStdntListView(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return "forward:/clssts/selectClsStsClassDetailView.do";
    }
}
