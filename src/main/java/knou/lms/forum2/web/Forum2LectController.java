package knou.lms.forum2.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.service.ForumService;
import knou.lms.forum2.vo.Forum2ListVO;
import knou.lms.forum2.vo.Forum2VO;

@Controller
@RequestMapping(value = "/forum2/forumLect")
public class Forum2LectController extends ControllerBase {

    @Resource(name = "forum2Service")
    private ForumService forumService;

    private String test_sbjctId = "SBJCT_OFRNG_ID1";
    private String test_lrnGrpId = "LRN_GRP_01";

    /**
     * 토론목록화면이동
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumListView.do")
    public String profForumListView(Forum2ListVO forum2ListVO, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        // TODO : Test Code 값 추후 수정 예정.(setSbjctId, setLrnGrpId)
        forum2ListVO.setSbjctId("SBJCT20260001");
        forum2ListVO.setLrnGrpId("LRN_GRP_01");

        return "forum2/lect/prof_forum_list_view";
    }

    /**
     * 토론작성화면이동
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumWriteView.do")
    public String profForumWriteView(Forum2VO forum2VO, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        // TODO : Test Code 값 추후 수정 예정.(setSbjctId, setLrnGrpId)
        model.addAttribute("sbjctId", test_sbjctId);
        model.addAttribute("lrnGrpId", test_lrnGrpId);

        // TODO : Test Code 값 추후 수정 예정.(setSbjctId, setLrnGrpId)
        forum2VO.setSbjctId(test_sbjctId);
        List<Forum2VO> dvclasList = forumService.selectForumDvclasList(forum2VO);
        model.addAttribute("dvclasList", dvclasList);

        // 등록 or 수정 구분 - I : 등록, E : 수정
        model.addAttribute("mode", "I");

        setCommonSessionValue(forum2VO, request);

        return "forum2/lect/prof_forum_write_view";
    }

    /**
     * 토론목록조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumList.do")
    @ResponseBody
    public ProcessResultVO<Forum2ListVO> profForumList(Forum2ListVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2ListVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        // 현 사용자의 구분(학생, 교수)
        String userType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        vo.setSearchKeyNm(userType);
        vo.setUserId(userId);

        try {
            setCommonSessionValue(vo, request);
            resultVO = forumService.selectForumList(vo);
            if (resultVO.getResult() == 0) {
                resultVO.setResultSuccess();
            }
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 토론단건상세조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumSelect.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> profForumSelect(Forum2VO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        try {
            setCommonSessionValue(vo, request);
            resultVO = forumService.selectForum(vo);
            if (resultVO.getResult() == 0) {
                resultVO.setResultSuccess();
            }
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 토론저장
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumRegist.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> profForumRegist(Forum2VO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        try {
            setCommonSessionValue(vo, request);
            resultVO = forumService.saveForum(vo);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 토론수정화면이동
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumEditView.do")
    public String profForumEditView(Forum2VO forum2VO, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        // 등록 or 수정 구분 - I : 등록, E : 수정
        model.addAttribute("mode", "E");

        if (!StringUtil.isNull(forum2VO.getDscsId())) {
            setCommonSessionValue(forum2VO, request);
            ProcessResultVO<Forum2VO> resultVO = forumService.selectForum(forum2VO);
            if (resultVO != null && resultVO.getReturnVO() != null) {
                model.addAttribute("forum2VO", resultVO.getReturnVO());
            }
        }

        return "forum2/lect/prof_forum_write_view";
    }

    /**
     * 토론수정
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumModify.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> profForumModify(Forum2VO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        try {
            setCommonSessionValue(vo, request);
            resultVO = forumService.saveForum(vo);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 토론 성적공개여부 수정
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumMrkOynModify.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> profForumMrkOynModify(Forum2VO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        try {
            if (StringUtil.isNull(vo.getDscsId())) {
                resultVO.setResultFailed("dscsId is required");
                return resultVO;
            }

            String mrkOyn = StringUtil.nvl(vo.getMrkOyn());
            if (StringUtil.isNull(mrkOyn)) {
                mrkOyn = StringUtil.nvl(request.getParameter("mrkOyn"));
            }
            mrkOyn = mrkOyn.toUpperCase();

            if (!"Y".equals(mrkOyn) && !"N".equals(mrkOyn)) {
                resultVO.setResultFailed("수정 중 에러가 발생하였습니다.");
                return resultVO;
            }

            vo.setMrkOyn(mrkOyn);
            resultVO = forumService.modifyForumMrkOyn(vo);
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 토론 성적반영비율 수정
     * @param list
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/forumMrkRfltrtModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> forumMrkRfltrtModifyAjax(@RequestBody List<Forum2VO> list, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        try {
            for (Forum2VO vo : list) {
                vo.setMdfrId(userId);
            }
            forumService.updateForumMrkRfltrt(list);
            resultVO.setResultSuccess();
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }
    
    /**
     * 토론삭제
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumDelete.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> profForumDelete(Forum2VO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        try {
            setCommonSessionValue(vo, request);
            resultVO = forumService.deleteForum(vo);
            if (resultVO.getResult() == 0) {
                resultVO.setResultSuccess();
            }
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 토론복사
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumCopy.do")
    @ResponseBody
    public ProcessResultVO<Forum2VO> profForumCopy(Forum2VO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        try {
            setCommonSessionValue(vo, request);

            if (StringUtil.isNull(vo.getSourceDscssId())) {
                resultVO.setResultFailed("sourceDscssId is required");
                return resultVO;
            }

            resultVO = forumService.copyForum(vo);
            if (resultVO.getResult() == 0) {
                resultVO.setResultSuccess();
            }
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 목록용세션공통값주입
     * @param vo
     * @param request
     */
    private void setCommonSessionValue(Forum2ListVO vo, HttpServletRequest request) {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setLangCd(SessionInfo.getLocaleKey(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setRgtrId(SessionInfo.getUserId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));
    }

    /**
     * 저장용세션공통값주입
     * @param vo
     * @param request
     */
    private void setCommonSessionValue(Forum2VO vo, HttpServletRequest request) {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setLangCd(SessionInfo.getLocaleKey(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setRgtrId(SessionInfo.getUserId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));
    }
}


