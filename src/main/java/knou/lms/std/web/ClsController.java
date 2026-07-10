package knou.lms.std.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.lms.user.CurrentUser;
import knou.lms.clssts.vo.ClsStdntVO;
import knou.lms.clssts.vo.ClsVO;

/**
 * 전체수업현황 메뉴 어댑터 Controller
 * 화면ID : KNOU_MN_B0102060101, KNOU_MN_B0102060102
 */
@Controller
@RequestMapping(value = "/cls")
public class ClsController extends ControllerBase {

    /**
     * 전체수업현황 목록 화면을 수업현황 화면으로 전달한다.
     *
     * @param vo
     * @param model
     * @param request
     * @return forward:/clssts/selectClsStsListView.do
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsListView.do")
    public String selectClsListView(ClsVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return "forward:/clssts/selectClsStsListView.do";
    }

    /**
     * 전체수업현황 목록 조회를 수업현황 목록 조회로 전달한다.
     *
     * @param vo
     * @param request
     * @return forward:/clssts/selectClsStsListPaging.do
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsListPaging.do")
    public String selectClsListPaging(ClsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return "forward:/clssts/selectClsStsListPaging.do";
    }

    /**
     * 운영과목 목록 조회를 수업현황 운영과목 조회로 전달한다.
     *
     * @param vo
     * @param request
     * @return forward:/clssts/selectClsStsSubjectList.do
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsSubjectList.do")
    public String selectClsSubjectList(ClsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return "forward:/clssts/selectClsStsSubjectList.do";
    }

    /**
     * 운영 기관 목록 조회를 수업현황 운영 기관 조회로 전달한다.
     *
     * @param vo
     * @param request
     * @return forward:/clssts/selectClsStsOrgList.do
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsOrgList.do")
    public String selectClsOrgList(ClsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return "forward:/clssts/selectClsStsOrgList.do";
    }

    /**
     * 운영 학기 목록 조회를 수업현황 운영 학기 조회로 전달한다.
     *
     * @param vo
     * @param request
     * @return forward:/clssts/selectClsStsTermList.do
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsTermList.do")
    public String selectClsTermList(ClsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return "forward:/clssts/selectClsStsTermList.do";
    }

    /**
     * 운영 학과 목록 조회를 수업현황 운영 학과 조회로 전달한다.
     *
     * @param vo
     * @param request
     * @return forward:/clssts/selectClsStsDeptList.do
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsDeptList.do")
    public String selectClsDeptList(ClsVO vo, @CurrentUser UserContext userCtx, HttpServletRequest request) throws Exception {
        return "forward:/clssts/selectClsStsDeptList.do";
    }

    /**
     * 전체수업현황 상세 화면을 수업현황 상세 화면으로 전달한다.
     *
     * @param vo
     * @param model
     * @param request
     * @return forward:/clssts/selectClsStsDetailView.do
     * @throws Exception
     */
    @RequestMapping(value = "/selectClsStdntListView.do")
    public String selectClsStdntListView(ClsStdntVO vo, @CurrentUser UserContext userCtx, ModelMap model, HttpServletRequest request) throws Exception {
        return "forward:/clssts/selectClsStsDetailView.do";
    }
}
