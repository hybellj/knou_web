package knou.lms.forum2.web;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.IdPrefixType;
import knou.framework.common.RepoInfo;
import knou.framework.common.SessionInfo;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.forum2.vo.DscsAtclVO;
import knou.lms.forum2.vo.DscsCmntVO;
import knou.lms.forum2.vo.DscsFdbkVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.service.DscsAtclService;
import knou.lms.forum2.service.DscsCmntService;
import knou.lms.forum2.service.DscsFdbkService;
import knou.lms.forum2.service.DscsJoinUserService;
import knou.lms.forum2.service.DscsService;
import knou.lms.forum2.vo.DscsListVO;
import knou.lms.forum2.vo.DscsTeamDscsVO;
import knou.lms.forum2.vo.DscsVO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.team.service.TeamCtgrService;
import knou.lms.team.service.TeamMemberService;
import knou.lms.team.service.TeamService;
import knou.lms.team.vo.TeamCtgrVO;
import knou.lms.team.vo.TeamMemberVO;
import knou.lms.team.vo.TeamVO;

@Controller
@RequestMapping(value = "/forum2/forumLect")
public class DscsLectController extends ControllerBase {
    private static final Logger LOGGER = LoggerFactory.getLogger(DscsLectController.class);

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name = "dscsService")
    private DscsService dscsService;

    @Resource(name = "dscsAtclService")
    private DscsAtclService dscsAtclService;

    @Resource(name = "dscsCmntService")
    private DscsCmntService dscsCmntService;

    @Resource(name="dscsJoinUserService")
    private DscsJoinUserService dscsJoinUserService;

    @Resource(name="dscsFdbkService")
    private DscsFdbkService dscsFdbkService;

    @Resource(name="termService")
    private TermService termService;

    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name = "sysFileService")
    private SysFileService sysFileService;

    @Resource(name="attachFileService")
    private AttachFileService attachFileService;

    @Resource(name="teamService")
    private TeamService teamService;

    @Resource(name="teamCtgrService")
    private TeamCtgrService teamCtgrService;

    @Resource(name="teamMemberService")
    private TeamMemberService teamMemberService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    private String test_sbjctId = "SBJCT_OFRNG_ID1";
    private String test_lrnGrpId = "LRN_GRP_01";
    private String test_DscsId = "DSCS_bdjqfhfbhij34db3e2d";

    /**
     * 토론목록화면이동
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profForumListView.do")
    public String profForumListView(DscsListVO dscsListVO, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("orgId", dscsListVO.getOrgId());
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        // TODO : Test Code 값 추후 수정 예정.(setSbjctId, setLrnGrpId)
        // - 필수값 체크 : 과목 ID 가 없을 경우 (잘못된 접근)
        dscsListVO.setSbjctId(dscsListVO.getSbjctId() != null ? dscsListVO.getSbjctId() : test_sbjctId);
        dscsListVO.setLrnGrpId(dscsListVO.getLrnGrpId() != null ? dscsListVO.getLrnGrpId() : test_lrnGrpId);

        model.addAttribute("dscsListVO", dscsListVO);

        return "forum2/lect/prof_forum_list_view";
    }

    /**
     * 토론작성화면이동
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profDscsWriteView.do")
    public String profDscsWriteView(DscsVO dscsVO, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        List<DscsVO> dvclasList = dscsService.selectDscsDvclasList(dscsVO);
        model.addAttribute("dvclasList", dvclasList);

        dscsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));
        // 등록 or 수정 구분 - I : 등록, E : 수정
        model.addAttribute("mode", "I");
        model.addAttribute("dscsVO", dscsVO);

        setCommonSessionValue(dscsVO, request);

        return "forum2/lect/prof_forum_write_view";
    }

    /**
     * 토론목록조회
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profDscsList.do")
    @ResponseBody
    public ProcessResultVO<DscsListVO> profDscsList(DscsListVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DscsListVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        // 현 사용자의 구분(학생, 교수)
        String userType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        vo.setSearchKeyNm(userType);
        vo.setViewAll("PROF".equals(userType)); // 교수 화면은 삭제여부 관계없이 조회되도록함.
        vo.setUserId(userId);

        try {
            setCommonSessionValue(vo, request);
            resultVO = dscsService.selectDscsList(vo);
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
    @RequestMapping(value = "/profDscsRegist.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> profDscsRegist(DscsVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        try {
            setCommonSessionValue(vo, request);
            resultVO = dscsService.saveDscs(vo);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
            resultVO.setResultSuccess();
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
    @RequestMapping(value = "/profDscsEditView.do")
    public String profDscsEditView(DscsVO dscsVO, ModelMap model, HttpServletRequest request) throws Exception {
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        // 등록 or 수정 구분 - I : 등록, E : 수정
        model.addAttribute("mode", "E");

        if (!StringUtil.isNull(dscsVO.getDscsId())) {
            setCommonSessionValue(dscsVO, request);

            dscsVO = dscsService.selectDscs(dscsVO);
            // 첨부파일저장소 설정
            dscsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));

            // 분반 목록 조회 (teamForumDiv 렌더링용 — sbjctId 는 selectForum 에서 반환됨)
        List<DscsVO> dvclasList = dscsService.selectDscsDvclasList(dscsVO);
            model.addAttribute("dvclasList", dvclasList);

            model.addAttribute("dscsVO", dscsVO);
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
    @RequestMapping(value = "/profDscsModify.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> profDscsModify(DscsVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        try {
            setCommonSessionValue(vo, request);
            resultVO = dscsService.saveDscs(vo);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
            resultVO.setResultSuccess();
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    // 이전 토론 가져오기 팝업
    @RequestMapping(value="/Form/forumCopyPop.do")
    public String dscsCopyPop(DscsVO dscsVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String orgId = SessionInfo.getOrgId(request);
        String sbjctId = dscsVO.getSbjctId();

        // 강의실 대표교수 정보 조회
        // TODO : 26.3.26 임시 막음 처리.
       /* CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(sbjctId);
        creCrsVO = crecrsService.selectTchCreCrs(creCrsVO);

        String repUserId = creCrsVO.getUserId();*/
        String repUserId = StringUtil.nvl(SessionInfo.getUserId(request));

        // 대표교수의 과목이 있는 학기기수 목록 조회
        List<EgovMap> smstrChrtList = dscsService.selectProfSmstrChrtList(dscsVO);

        model.addAttribute("dscsVO", dscsVO);
        model.addAttribute("smstrChrtList", smstrChrtList);
        model.addAttribute("repUserId", repUserId);

        return "forum2/popup/prof_forum_copy";
    }

    // 교수학기기수별과목목록 조회 ajax (토론 복사 팝업용)
    @RequestMapping(value="/Form/smstrChrtSbjctListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> smstrChrtSbjctListAjax(DscsVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        try {
            resultVO.setReturnList(dscsService.selectProfSmstrChrtSbjctList(vo));
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error");
        }
        return resultVO;
    }

    // 이전 토론 가져오기 리스트 ajax
    @RequestMapping(value="/Form/dscsCopyList.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> dscsCopyList(@RequestBody DscsVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setUserId(userId);
            vo.setOrgId(orgId);
            resultVO = dscsService.selectProfSbjctDscsList(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    // 이전 토론 가져오기 ajax
    @RequestMapping(value="/Form/dscsCopy.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> dscsCopy(DscsVO dscsVO, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<DscsVO> returnVO = new ProcessResultVO<DscsVO>();

        try {
            dscsVO = dscsService.selectDscs(dscsVO);
            // 복사시 이전 토론 ID 는 제거한다.
            dscsVO.setDscsId("");

            returnVO.setReturnVO(dscsVO);
            returnVO.setResult(1);
        } catch(Exception e) {
            returnVO.setResult(-1);
            returnVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return returnVO;
    }

    /**
     * 학습그룹 팀 목록 조회 (팀 토론 부주제 설정용)
     */
    @RequestMapping(value = "/profDscsLrnGrpTeamListAjax.do")
    @ResponseBody
    public ProcessResultVO<DscsTeamDscsVO> profDscsLrnGrpTeamListAjax(
            DscsTeamDscsVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DscsTeamDscsVO> resultVO = new ProcessResultVO<>();
        try {
            resultVO = dscsService.selectDscsLrnGrpTeamList(vo);
            resultVO.setResultSuccess();
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
    @RequestMapping(value = "/profDscsMrkOynModify.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> profDscsMrkOynModify(DscsVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

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

            setCommonSessionValue(vo, request);
            vo.setMrkOyn(mrkOyn);
            resultVO = dscsService.modifyDscsMrkOyn(vo);
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
    public ProcessResultVO<DscsVO> dscsMrkRfltrtModifyAjax(@RequestBody List<DscsVO> list, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        try {
            for (DscsVO vo : list) {
                setCommonSessionValue(vo, request);
                vo.setMdfrId(userId);
            }
            dscsService.updateDscsMrkRfltrt(list);
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
    @RequestMapping(value = "/profDscsDelete.do")
    @ResponseBody
    public ProcessResultVO<DscsVO> profDscsDelete(@RequestBody DscsVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<>();

        try {
            setCommonSessionValue(vo, request);
            resultVO = dscsService.deleteDscs(vo);

            if (resultVO.getResult() == 0) {
                // 성적반영여부(SCORE_APLY_YN)가 Y인 경우에 성적반영 비율 100% 기준으로 1/N 자동 계산하여 성적반영비율 필더(SCORE_RATIO)에 저장
                dscsService.setScoreRatio(vo);

                resultVO.setResultSuccess();
            }
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    /**
     * 토론방
     * @param dscsVO
     * @param request
     */
    @RequestMapping(value = "/Form/bbsManage.do")
    public String bbsManage(DscsVO dscsVO, ModelMap model, HttpServletRequest request) throws Exception {

        /**
         * selectDscs 필수값 : dscsId, sbjctId
         */
        dscsVO = dscsService.selectDscs(dscsVO);

        // 첨부파일저장소 설정
        dscsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", dscsVO.getSbjctId());
        model.addAttribute("userId", StringUtil.nvl(SessionInfo.getUserId(request)));
        model.addAttribute("userName", StringUtil.nvl(SessionInfo.getUserNm(request)));
        model.addAttribute("dscsVO", dscsVO);

        return "forum2/lect/forum_bbs_manage";
    }

    @RequestMapping(value = "/Form/forumBbsViewList.do")
    @ResponseBody
    public ProcessResultVO<DscsAtclVO> dscsBbsViewList(DscsVO dscsVO, HttpServletRequest request) throws Exception {
        DscsAtclVO dscsAtclVO = new DscsAtclVO();
        dscsAtclVO.setDscsId(dscsVO.getDscsId());
        dscsAtclVO.setSearchValue(dscsVO.getSearchValue());
        dscsAtclVO.setPageIndex(dscsVO.getPageIndex());
        dscsAtclVO.setListScale(dscsVO.getListScale());
        dscsAtclVO.setSbjctId(dscsVO.getSbjctId());

        dscsAtclVO.setViewAll(true);// 교수 화면은 삭제여부 관계없이 조회되도록함.
        ProcessResultVO<DscsAtclVO> resultVO = new ProcessResultVO<>();
        try {
            resultVO = dscsAtclService.listPageing(dscsAtclVO);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    @RequestMapping(value = "/Form/addDscsBbs.do")
    public String addDscsBbs(DscsVO dscsVO, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));
        String atclSn = IdGenerator.getNewId(IdPrefixType.DSATC.getCode());
        model.addAttribute("userId", userId);
        model.addAttribute("userName", userName);
        model.addAttribute("atclSn", atclSn);
        model.addAttribute("dscsVO", dscsVO);
        return "forum2/lect/forum_bbs_view_write";
    }

    @RequestMapping(value = "/Form/editDscsBbs.do")
    public String editDscsBbs(DscsVO dscsVO, ModelMap model, HttpServletRequest request) throws Exception {
        String atclSn = StringUtil.nvl(request.getParameter("dscsAtclId"), request.getParameter("atclSn"));
        DscsAtclVO dscsAtclVO = new DscsAtclVO();
        dscsAtclVO.setDscsId(dscsVO.getDscsId());
        dscsAtclVO.setDscsAtclId(atclSn);
        dscsAtclVO = dscsAtclService.selectAtcl(dscsAtclVO);

        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("FORUM");
        fileVO.setFileBindDataSn(atclSn);
        ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);

        model.addAttribute("fileList", fileList.getReturnList());
        model.addAttribute("atclSn", atclSn);
        model.addAttribute("dscsVO", dscsVO);
        model.addAttribute("dscsAtclVO", dscsAtclVO);
        model.addAttribute("userId", StringUtil.nvl(SessionInfo.getUserId(request)));
        model.addAttribute("userName", StringUtil.nvl(SessionInfo.getUserNm(request)));
        return "forum2/lect/forum_bbs_view_write";
    }

    /**
     * 토론방게시글저장
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/Form/addAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addAtcl(DscsVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String atclSn = IdGenerator.getNewId(IdPrefixType.DSATC.getCode());
        try {
            String userId = StringUtil.nvl(SessionInfo.getUserId(request));

            DscsAtclVO dscsAtclVO = new DscsAtclVO();
            dscsAtclVO.setDscsId(StringUtil.nvl(request.getParameter("dscsId"), vo.getDscsId()));
            dscsAtclVO.setDscsAtclId(StringUtil.nvl(request.getParameter("dscsAtclId"), atclSn));
            dscsAtclVO.setOknokGbncd(StringUtil.nvl(request.getParameter("oknokGbncd"), request.getParameter("prosConsTypeCd")));
            dscsAtclVO.setDscsAtclTycd(StringUtil.nvl(request.getParameter("dscsAtclTycd"), request.getParameter("atclTypeCd")));
            dscsAtclVO.setAtclCts(StringUtil.nvl(request.getParameter("atclCts"), request.getParameter("cts")));
            dscsAtclVO.setAtclTtl(StringUtil.nvl(request.getParameter("atclTtl"), ""));
            dscsAtclVO.setSbjctId(vo.getSbjctId());
            dscsAtclVO.setRgtrId(userId);
            dscsAtclVO.setMdfrId(userId);
            dscsAtclVO.setUserId(userId);
            dscsAtclVO.setAtclSeqno(0);
            dscsAtclVO.setUploadFiles(vo.getUploadFiles());
            dscsAtclVO.setUploadPath(vo.getUploadPath());
            dscsAtclVO.setRepoCd(vo.getRepoCd());
            dscsAtclService.insertAtcl(dscsAtclVO, vo.getTeamId());
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 토론게시글수정
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/Form/editAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editAtcl(DscsVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            String userId = StringUtil.nvl(SessionInfo.getUserId(request));
            DscsAtclVO dscsAtclVO = new DscsAtclVO();
            dscsAtclVO.setDscsId(StringUtil.nvl(request.getParameter("dscsId"), vo.getDscsId()));
            dscsAtclVO.setDscsAtclId(StringUtil.nvl(request.getParameter("dscsAtclId"), request.getParameter("atclSn")));
            dscsAtclVO.setOknokGbncd(StringUtil.nvl(request.getParameter("oknokGbncd"), request.getParameter("prosConsTypeCd")));
            dscsAtclVO.setAtclCts(StringUtil.nvl(request.getParameter("atclCts"), request.getParameter("cts")));
            dscsAtclVO.setAtclTtl(StringUtil.nvl(request.getParameter("atclTtl"), ""));
            dscsAtclVO.setMdfrId(userId);
            dscsAtclVO.setUserId(userId);
            dscsAtclVO.setUploadFiles(vo.getUploadFiles());
            dscsAtclVO.setUploadPath(vo.getUploadPath());
            dscsAtclVO.setRepoCd(vo.getRepoCd());
            dscsAtclService.updateAtcl(dscsAtclVO);
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 토론게시글삭제
     * @param dscsVO
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/Form/delAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delAtcl(DscsVO dscsVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            DscsAtclVO dscsAtclVO = new DscsAtclVO();
            dscsAtclVO.setDscsId(StringUtil.nvl(request.getParameter("dscsId"), dscsVO.getDscsId()));
            dscsAtclVO.setDscsAtclId(StringUtil.nvl(request.getParameter("dscsAtclId"), request.getParameter("atclSn")));
            dscsAtclVO.setMdfrId(StringUtil.nvl(SessionInfo.getUserId(request)));
            dscsAtclService.deleteAtcl(dscsAtclVO);
            returnVo.setResult(1);
        } catch (Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getCommonFailMessage());
        }
        return returnVo;
    }

    // 참여글 숨김
    @RequestMapping(value = "/Form/hideAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> hideAtcl(DscsVO dscsVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            DscsAtclVO dscsAtclVO = new DscsAtclVO();
            dscsAtclVO.setDscsId(StringUtil.nvl(request.getParameter("dscsId"), dscsVO.getDscsId()));
            dscsAtclVO.setDscsAtclId(StringUtil.nvl(request.getParameter("dscsAtclId"), request.getParameter("atclSn")));
            dscsAtclVO.setMdfrId(StringUtil.nvl(SessionInfo.getUserId(request)));
            dscsAtclService.hideAtcl(dscsAtclVO);
            returnVo.setResult(1);
        } catch (Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getCommonFailMessage());
        }
        return returnVo;
    }

    /**
     * 토론댓글등록
     * @param dscsVO
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/Form/addCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addCmnt(DscsVO dscsVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            String userId = StringUtil.nvl(SessionInfo.getUserId(request));
            DscsCmntVO dscsCmntVO = new DscsCmntVO();
            dscsCmntVO.setDscsCmntId(IdGenerator.getNewId(IdPrefixType.DSCMT.getCode()));
            dscsCmntVO.setDscsId(StringUtil.nvl(request.getParameter("dscsId"), dscsVO.getDscsId()));
            dscsCmntVO.setDscsAtclId(StringUtil.nvl(request.getParameter("dscsAtclId"), request.getParameter("atclSn")));
            dscsCmntVO.setUpCmntId(StringUtil.nvl(request.getParameter("upCmntId"), request.getParameter("parCmntSn")));
            dscsCmntVO.setCmntCts(request.getParameter("cmntCts"));
            dscsCmntVO.setRspnsReqyn(StringUtil.nvl(request.getParameter("rspnsReqyn"), StringUtil.nvl(request.getParameter("ansReqYn"), "N")));
            dscsCmntVO.setRgtrId(userId);
            dscsCmntVO.setMdfrId(userId);
            dscsCmntService.insertCmnt(dscsCmntVO);

            // TODO: 26.3.19 : 학습자만 체크할 수 있음.
            /*
            // 답변 요청 체크시 QnA 게시판에 등록
            String orgId = SessionInfo.getOrgId(request);
            if("Y".equals(dscsCmntVO.getAnsReqYn())) {
                BbsInfoVO bbsInfoVO = new BbsInfoVO();
                bbsInfoVO.setCrsCreCd(crsCreCd);
                bbsInfoVO.setOrgId(orgId);
                bbsInfoVO.setBbsId("QNA");
                bbsInfoVO.setSysDefaultYn("Y");
                bbsInfoVO.setSysUseYn("N");

                bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

                if(bbsInfoVO != null) {
                    int cmntCtsLen = 0;

                    if(!"".equals(StringUtil.nvl(cmntCts))) {
                        cmntCtsLen = cmntCts.length();
                    }

                    // 최대 20자
                    if(cmntCtsLen > 20) {
                        cmntCtsLen = 20;
                    }

                    BbsAtclVO feedBackAtclVO = new BbsAtclVO();
                    feedBackAtclVO.setCrsCreCd(crsCreCd);
                    feedBackAtclVO.setBbsId(bbsInfoVO.getBbsId());
                    feedBackAtclVO.setAtclTtl(StringUtil.substring(cmntCts, 0, cmntCtsLen));
                    feedBackAtclVO.setAtclCts(cmntCts);
                    feedBackAtclVO.setRgtrId(userId);
                    bbsAtclService.insertBbsAtcl(feedBackAtclVO);
                }
            }
            */

            returnVo.setResult(1);
        } catch (Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getCommonFailMessage());
        }
        return returnVo;
    }

    /**
     * 토론댓글수정
     * @param dscsVO
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/Form/editCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editCmnt(DscsVO dscsVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            DscsCmntVO dscsCmntVO = new DscsCmntVO();
            dscsCmntVO.setDscsCmntId(StringUtil.nvl(request.getParameter("dscsCmntId"), request.getParameter("cmntSn")));
            dscsCmntVO.setCmntCts(request.getParameter("cmntCts"));
            dscsCmntVO.setRspnsReqyn(StringUtil.nvl(request.getParameter("rspnsReqyn"), request.getParameter("ansReqYn")));
            dscsCmntVO.setMdfrId(StringUtil.nvl(SessionInfo.getUserId(request)));
            dscsCmntService.updateCmnt(dscsCmntVO);
            returnVo.setResult(1);
        } catch (Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getCommonFailMessage());
        }
        return returnVo;
    }

    /**
     * 토론방댓글삭제
     * @param dscsVO
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/Form/delCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delCmnt(DscsVO dscsVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            DscsCmntVO dscsCmntVO = new DscsCmntVO();
            dscsCmntVO.setDscsCmntId(StringUtil.nvl(request.getParameter("dscsCmntId"), request.getParameter("cmntSn")));
            dscsCmntVO.setMdfrId(StringUtil.nvl(SessionInfo.getUserId(request)));
            dscsCmntService.deleteCmnt(dscsCmntVO);
            returnVo.setResult(1);
        } catch (Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getCommonFailMessage());
        }
        return returnVo;
    }

    // 댓글 숨김
    @RequestMapping(value = "/Form/hideCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> hideCmnt(DscsVO dscsVO, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            DscsCmntVO dscsCmntVO = new DscsCmntVO();
            dscsCmntVO.setDscsCmntId(StringUtil.nvl(request.getParameter("dscsCmntId"), request.getParameter("cmntSn")));
            dscsCmntVO.setMdfrId(StringUtil.nvl(SessionInfo.getUserId(request)));
            dscsCmntService.hideCmnt(dscsCmntVO);
            returnVo.setResult(1);
        } catch (Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getCommonFailMessage());
        }
        return returnVo;
    }

    /**
     * 팀토론토론방OPEN여부 수정
     * @param vo
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/profTeamDscsOynModify.do")
    @ResponseBody
    public ProcessResultVO<DscsTeamDscsVO> profTeamDscsOynModify(DscsTeamDscsVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DscsTeamDscsVO> resultVO = new ProcessResultVO<>();

        try {
            if (StringUtil.isNull(vo.getDscsId())) {
                resultVO.setResultFailed("dscsId is required");
                return resultVO;
            }

            String mrkOyn = StringUtil.nvl(vo.getTeamDscsOyn());
            if (StringUtil.isNull(mrkOyn)) {
                mrkOyn = StringUtil.nvl(request.getParameter("mrkOyn"));
            }
            mrkOyn = mrkOyn.toUpperCase();

            if (!"Y".equals(mrkOyn) && !"N".equals(mrkOyn)) {
                resultVO.setResultFailed("수정 중 에러가 발생하였습니다.");
                return resultVO;
            }
            String userId = StringUtil.nvl(SessionInfo.getUserId(request));
            vo.setMdfrId(userId);
            vo.setTeamDscsOyn(mrkOyn);
            resultVO = dscsService.modifyTeamDscsOyn(vo);
        } catch (Exception e) {
            resultVO.setResultFailed(e.getMessage());
        }

        return resultVO;
    }

    // 팀토론 토론방 팀리스트
    @RequestMapping(value="/listTeamJson.do")
    @ResponseBody
    public ProcessResultVO<TeamVO> listTeamJson(TeamCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        ProcessResultVO<TeamVO> returnVO = new ProcessResultVO<>();
        try {
            String teamCtgrCd = vo.getTeamCtgrCd();

            if(ValidationUtils.isNotEmpty(teamCtgrCd)) {
                TeamVO teamVO = new TeamVO();
                teamVO.setTeamCtgrCd(teamCtgrCd);
                List<TeamVO> list = teamService.teamList(teamVO);
                returnVO.setReturnList(list);
            }

            returnVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            returnVO.setResult(-1);
        }
        return returnVO;
    }

    // 팀 구성원 보기
    @RequestMapping(value="/teamMemberList.do")
    public String teamMemberList(TeamCtgrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        List<TeamCtgrVO> teamCtgrList = teamCtgrService.teamList(vo);
        request.setAttribute("teamCtgrList", teamCtgrList);

        return "forum/popup/team_member_list_pop";
    }

    // 팀 구성원 ajax
    @RequestMapping(value="/teamMember.do")
    @ResponseBody
    public ProcessResultVO<TeamMemberVO> listTeam(TeamVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<TeamMemberVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setUserId(userId);

        try {
            // List<TeamMemberVO> list = teamService.list(vo);
            List<TeamMemberVO> list = teamMemberService.selectTeamMemberList(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    // 팀토론 일경우 검색 조건 추가
    @RequestMapping(value="/teamSelectList.do")
    @ResponseBody
    public ProcessResultVO<TeamVO> teamSelectList(TeamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<TeamVO> resultVO = new ProcessResultVO<>();
        Locale locale = LocaleUtil.getLocale(request);

        try {
            List<TeamVO> list = teamService.list(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("forum.common.error", null, locale)); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 성적평가
    @RequestMapping(value="/Form/scoreManage.do")
    public String scoreManage(DscsVO dscsVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        model.addAttribute("tab", request.getParameter("tab"));

        String crsCreCd = dscsVO.getSbjctId();
        model.addAttribute("crsCreCd", crsCreCd);

        dscsVO = dscsService.selectDscs(dscsVO);

        /*  강의실에서 토론 진입시 교수자ID */
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        /* 강의실에서 토론 진입시 교수자이름 */
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", dscsVO.getSbjctId());

        model.addAttribute("userId", userId);
        model.addAttribute("userName", userName);

        if("PTCP_FULL_SCR".equals(StringUtil.nvl(dscsVO.getEvlScrTycd()))) {
            // 모든 토론 참여자를 토론 참여자 테이블에 삽입
            DscsVO fvo = new DscsVO();
            fvo.setRgtrId(userId);
            fvo.setSbjctId(dscsVO.getSbjctId());
            fvo.setDscsId(dscsVO.getDscsId());
            dscsJoinUserService.insertJoinUser(fvo);

            // TODO : 26.3.20(기획 요청에 따라 먼저 평가를 하지 않고 목록에서 일괄 평가식으로 처리함.)
            /*
            DscsJoinUserVO joinUserVO = new DscsJoinUserVO();
            joinUserVO.setSearchMenu("ONCE");
            joinUserVO.setRgtrId(userId);
            joinUserVO.setDscsId(forumVO.getDscsId());
            joinUserVO.setSearchKey("JOIN");
            dscsJoinUserService.participateScore(joinUserVO);
            //joinUserVO.setSearchKey("NOTJOIN");
            //dscsJoinUserService.participateScore(joinUserVO);
            */
        }
        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
        dscsJoinUserVO.setDscsId(dscsVO.getDscsId());

        // 성적분포현황차트
        List<?> dscsJoinUserList = dscsJoinUserService.dscsJoinUserList(dscsJoinUserVO);
        int minScore = 0;
        int maxScore = 0;
        int totalScore = 0;
        int score = 0;
        int avgScore = 0;

        if(dscsJoinUserList.size() > 0) {
            for(int i = 0; i < dscsJoinUserList.size(); i++) {
                EgovMap egovMap = (EgovMap) dscsJoinUserList.get(i);

                // long tmpScore = (long)egovMap.get("score");
                // score = Long.valueOf(tmpScore).intValue();
                BigDecimal tmpScore = (BigDecimal) egovMap.get("score");
                long befScore = tmpScore.longValue();
                score = Long.valueOf(befScore).intValue();

                if(i == 0) {
                    minScore = score;
                    maxScore = score;
                } else {
                    if(minScore > score) {
                        minScore = score;
                    }

                    if(maxScore < score) {
                        maxScore = score;
                    }
                }
                totalScore = totalScore + score;
            }
            avgScore = totalScore / dscsJoinUserList.size();
        }

        model.addAttribute("minScore", minScore);
        model.addAttribute("maxScore", maxScore);
        model.addAttribute("avgScore", avgScore);

        // 찬반현황 차트용
        dscsVO.setOrgId(orgId);
        // TODO : 26.3.16 (앞에서 읽었는데 또 다시 읽어야 하나?-joinUserCount 가 달라지는가?)
        /*
        dscsVO = dscsService.selectDscs(param);
         */
        dscsVO.setSbjctId(crsCreCd);

        dscsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));
        model.addAttribute("dscsVO", dscsVO);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        // TODO : 26.3.18 불필요한 코드(필요시 test_sbjctId 로 변경할 것)
        //creCrsVO = crecrsService.select(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);

        return "forum2/lect/forum_score_manage";
    }

    /*****************************************************
     * 토론 참여 사용자 리스트 가져오기 ajax
     * @param dscsJoinUserVO
     * @return ProcessResultVO<DscsJoinUserVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/dscsJoinUserList.do")
    @ResponseBody
    public ProcessResultVO<DscsJoinUserVO> dscsJoinUserList(DscsJoinUserVO dscsJoinUserVO,
            @RequestParam(value="byteamDscsUseyn", required=false, defaultValue="") String byteamDscsUseyn,
            ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<DscsJoinUserVO> resultVO = new ProcessResultVO<>();
        try {
            resultVO = dscsJoinUserService.listPaging(dscsJoinUserVO, byteamDscsUseyn);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 토론 참여자 성적 변경 ajax
     * @param dscsJoinUserVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateDscsJoinUserScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateDscsJoinUserScore(DscsJoinUserVO dscsJoinUserVO, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String teamId = StringUtil.nvl(request.getParameter("teamId"));

        try {
            dscsJoinUserVO.setRgtrId(userId);
            dscsJoinUserVO.setMdfrId(userId);
            dscsJoinUserVO.setTeamId(teamId);

            dscsJoinUserService.updateDscsJoinUserScore(dscsJoinUserVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 토론 참여자 글자수로 점수 주기(ajax)
     * @param dscsJoinUserVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateDscsJoinUserLenScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateDscsJoinUserLenScore(DscsJoinUserVO dscsJoinUserVO, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String teamId = StringUtil.nvl(request.getParameter("teamId"));

        try {
            dscsJoinUserVO.setRgtrId(userId);
            dscsJoinUserVO.setMdfrId(userId);
            dscsJoinUserVO.setTeamId(teamId);

            dscsJoinUserService.updateDscsJoinUserLenScore(dscsJoinUserVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 토론 성적평가 엑셀 다운로드
     * @param dscsJoinUserVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/forumScoreExcelDown.do")
    public String dscsScoreExcelDown(DscsJoinUserVO dscsJoinUserVO,
            @RequestParam(value="byteamDscsUseyn", required=false, defaultValue="") String byteamDscsUseyn,
            ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        dscsJoinUserVO.setPagingYn("N");
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적평가리스트");
        map.put("sheetName", "성적평가리스트");
        map.put("excelGrid", dscsJoinUserVO.getExcelGrid());
        map.put("list", dscsJoinUserService.listPaging(dscsJoinUserVO, byteamDscsUseyn).getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("outFileName", "성적평가리스트_" + date.format(today));
        modelMap.put("workbook", excelUtilPoi.simpleBigGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    // 상호평가 토론방 리스트
    @RequestMapping(value="/evalDscsBbsViewList.do")
    public String evalDscsBbsViewList(DscsVO dscsVO, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        request.setAttribute("tab", request.getParameter("tab"));

        String stdList = dscsVO.getStdList();

        /*토론 게시글*/
        DscsAtclVO dscsAtclVO = new DscsAtclVO();

        String rltnCd = request.getParameter("rltnCd");
        if(rltnCd != null) {
            dscsAtclVO.setDscsId(rltnCd);
            dscsVO.setDscsId(rltnCd);
        } else {
            dscsAtclVO.setDscsId(dscsVO.getDscsId());
        }

        dscsAtclVO.setSearchKey(dscsVO.getSearchKey());
        dscsAtclVO.setSearchValue(dscsVO.getSearchValue());
        dscsAtclVO.setPageIndex(dscsVO.getPageIndex());
        //int listScale = 2; //dscsAtclVO.getListScale()
        dscsAtclVO.setListScale(dscsVO.getListScale());
        dscsAtclVO.setStdList(stdList);
        dscsAtclVO.setSbjctId(dscsVO.getSbjctId());
        dscsAtclVO.setViewAll(true);// 교수 화면은 삭제여부 관계없이 조회되도록함.

        ProcessResultVO<DscsAtclVO> resultList = dscsAtclService.listPageing(dscsAtclVO);

        request.setAttribute("dscsAtclList", resultList.getReturnList());
        request.setAttribute("pageInfo", resultList.getPageInfo());
        request.setAttribute("dscsVO", dscsVO);
        request.setAttribute("konanCopyScoreUrl", CommConst.KONAN_COPY_SCORE_URL);

        return "forum2/lect/forum_bbs_view_eval";
    }

    // 토론 성적평가 > 피드백
    @RequestMapping(value="/forumScoreEvalFeedBack.do")
    public String dscsScoreEvalFeedBack(DscsVO dscsVO, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        /*참여자 정보*/
        if(!"EZG".equals(dscsVO.getSearchMenu())) {
            DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
            dscsJoinUserVO.setDscsId(dscsVO.getDscsId());
            dscsJoinUserVO.setStdId(dscsVO.getStdId());

            dscsJoinUserVO = dscsJoinUserService.selectDscsJoinUser(dscsJoinUserVO);
            request.setAttribute("dscsJoinUserVO", dscsJoinUserVO);
        }

        DscsFdbkVO dscsFdbkVO = new DscsFdbkVO();
        dscsFdbkVO.setDscsId(dscsVO.getDscsId());
        dscsFdbkVO.setStdId(dscsVO.getStdId());

        if(dscsVO.getTeamId() != null || dscsVO.getTeamId() != "") {
            dscsFdbkVO.setTeamId(dscsVO.getTeamId());
        }

        /* 피드백 list */
        List<?> dscsFdbkList = dscsFdbkService.dscsFdbkList(dscsFdbkVO);

        int fdbkSize = dscsFdbkList.size();

        request.setAttribute("fdbkSize", fdbkSize);
        request.setAttribute("forumFdbkList", dscsFdbkList);
        request.setAttribute("dscsVO", dscsVO);

        return "forum2/lect/forum_score_eval_feedBack";
    }

    // 성적분포현황 BarChart
    @RequestMapping(value="/viewScoreChart.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> viewScoreChart(DscsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            // TODO : 26.3.20 : to-be vo 변경에 따른 처리.
            /*vo = dscsService.selectDscs(vo);*/
            DscsVO param = new DscsVO();
            param.setSbjctId(vo.getSbjctId());
            param.setDscsId(vo.getDscsId());
            EgovMap scoreMap = dscsService.viewScoreChart(param);

            resultVO.setReturnVO(scoreMap);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 교수 메모 팝업창 정보
    @RequestMapping(value="/dscsProfMemoPop.do")
    public String dscsProfMemoPop(DscsJoinUserVO dscsJoinUserVO, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(dscsJoinUserVO.getSbjctId());
        // TODO : 26.3.23 : AS-IS code TO-BE 필요시 적용.
        /*creCrsVO = crecrsService.infoCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);*/
        request.setAttribute("dscsId", dscsJoinUserVO.getDscsId());
        request.setAttribute("stdId", dscsJoinUserVO.getStdId());

        dscsJoinUserVO.setUserId(SessionInfo.getUserId(request));
        dscsJoinUserVO = dscsJoinUserService.selectProfMemo(dscsJoinUserVO);
        request.setAttribute("dscsJoinUserVO", dscsJoinUserVO);

        return "forum2/popup/forum_prof_memo";
    }

    // 교수 메모 수정
    @RequestMapping(value="/editDscsProfMemo.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editDscsProfMemo(DscsJoinUserVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        try {
            vo.setMdfrId(userId);
            dscsJoinUserService.editDscsProfMemo(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.alert.memo.error");/* 메모 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    // 피드백
    @RequestMapping(value="/dscsFdbkPop.do")
    public String dscsFeedBack(DscsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getSbjctId());
        // TODO : 26.3.23 : AS-IS code TO-BE 필요시 적용.
        /*creCrsVO = crecrsService.infoCreCrs(creCrsVO);*/
        request.setAttribute("creCrsVO", creCrsVO);

        String dscsId = vo.getDscsId();
        String stdId = vo.getStdId();
        String teamId = vo.getTeamId();

        request.setAttribute("dscsId", dscsId);
        request.setAttribute("stdId", stdId);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
        dscsJoinUserVO.setDscsId(dscsId);
        dscsJoinUserVO.setStdId(stdId);
        dscsJoinUserVO.setUserId(userId);
        dscsJoinUserVO = dscsJoinUserService.selectProfMemo(dscsJoinUserVO);

        request.setAttribute("dscsJoinUserVO", dscsJoinUserVO);

        // String userType = StringUtil.nvl(SessionInfo.getClassUserType(request));
        String userType = "CLASS_PROFESSOR";

        /*
        if(!"EZG".equals(vo.getSearchMenu())) {
            dscsJoinUserVO = dscsJoinUserService.selectDscsJoinUser(dscsJoinUserVO);
            request.setAttribute("dscsJoinUserVO", dscsJoinUserVO);
        }
        */

        DscsFdbkVO dscsFdbkVO = new DscsFdbkVO();
        dscsFdbkVO.setDscsId(dscsId);
        dscsFdbkVO.setStdId(stdId);

        if(teamId != null || teamId != "") {
            dscsFdbkVO.setTeamId(teamId);
        }

        request.setAttribute("userId", userId);
        request.setAttribute("userName", userName);
        request.setAttribute("userType", userType);

        String student = (SessionInfo.getAuthrtGrpcd(request).contains("USR")) ? "STD" : "";
        request.setAttribute("student", student);

        vo.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));

        request.setAttribute("dscsVO", vo);
        request.setAttribute("PAGE_FILE_UPLOAD", request.getContextPath() + CommConst.PAGE_FILE_UPLOAD);

        return "forum2/popup/forum_feedback";
    }

    // 피드백 조회
    @RequestMapping(value="/getFdbk.do")
    @ResponseBody
    public ProcessResultVO<DscsFdbkVO> getFdbk(DscsVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String fdbkCts = request.getParameter("fdbkCts");
        String upDscsFdbkId = request.getParameter("upDscsFdbkId");
        String stdId = vo.getStdId();

        DscsFdbkVO dscsFdbkVO = new DscsFdbkVO();
        dscsFdbkVO.setDscsFdbkId(IdGenerator.getNewId("FFDBK"));
        if(upDscsFdbkId == null || upDscsFdbkId.equals("")) {
            dscsFdbkVO.setUpDscsFdbkId(null);
        } else {
            dscsFdbkVO.setUpDscsFdbkId(upDscsFdbkId);
        }
        dscsFdbkVO.setDscsId(vo.getDscsId());
        dscsFdbkVO.setFdbkCts(fdbkCts);
        dscsFdbkVO.setStdId(stdId);

        if(vo.getTeamId() != null || vo.getTeamId() != "") {
            dscsFdbkVO.setTeamId(vo.getTeamId());
        }

        // 피드백 리스트
        ProcessResultVO<DscsFdbkVO> resultVO = new ProcessResultVO<>();
        try {
            List<DscsFdbkVO> list = dscsFdbkService.selectFdbk(dscsFdbkVO);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    // 피드백 작성
    @RequestMapping(value="/addFdbkCts.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addFockCts(DscsVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String fdbkCts = request.getParameter("fdbkCts");
        String upDscsFdbkId = request.getParameter("upDscsFdbkId");
        String stdId = vo.getStdId();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        DscsFdbkVO dscsFdbkVO = new DscsFdbkVO();
        dscsFdbkVO.setDscsFdbkId(IdGenerator.getNewId("FFDBK"));
        if(upDscsFdbkId == null || upDscsFdbkId.equals("")) {
            dscsFdbkVO.setUpDscsFdbkId(null);
        } else {
            dscsFdbkVO.setUpDscsFdbkId(upDscsFdbkId);
        }
        dscsFdbkVO.setDscsId(vo.getDscsId());
        dscsFdbkVO.setFdbkCts(fdbkCts);
        dscsFdbkVO.setStdId(stdId);

        dscsFdbkVO.setRgtrId(userId);
        dscsFdbkVO.setRgtrnm(userName);
        dscsFdbkVO.setMdfrId(userId);

        if(vo.getTeamId() != null || vo.getTeamId() != "") {
            dscsFdbkVO.setTeamId(vo.getTeamId());
        }

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            dscsFdbkService.insertDscsFdbk(dscsFdbkVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.alert.memo.error");/* 메모 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    // 피드백 수정
    @RequestMapping(value="/editFdbkCts.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editFdbkCts(DscsVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String dscsFdbkId = request.getParameter("dscsFdbkId");
        String fdbkCts = request.getParameter("fdbkCts");
        String stdId = vo.getStdId();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        DscsFdbkVO dscsFdbkVO = new DscsFdbkVO();
        dscsFdbkVO.setDscsFdbkId(dscsFdbkId);
        dscsFdbkVO.setDscsId(vo.getDscsId());
        dscsFdbkVO.setFdbkCts(fdbkCts);
        dscsFdbkVO.setStdId(stdId);

        dscsFdbkVO.setRgtrId(userId);
        dscsFdbkVO.setMdfrId(userId);

        if(vo.getTeamId() != null || vo.getTeamId() != "") {
            dscsFdbkVO.setTeamId(vo.getTeamId());
        }

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            dscsFdbkService.updateDscsFdbk(dscsFdbkVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.alert.memo.error");/* 메모 저장 중 에러가 발생하였습니다. */
        }

        return resultVO;
    }

    // 피드백 삭제
    @RequestMapping(value="/delFdbkCts.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delFdbkCts(DscsVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String dscsFdbkId = request.getParameter("dscsFdbkId");
        String fdbkCts = request.getParameter("fdbkCts");
        String stdId = vo.getStdId();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        DscsFdbkVO dscsFdbkVO = new DscsFdbkVO();
        dscsFdbkVO.setDscsFdbkId(dscsFdbkId);
        dscsFdbkVO.setDscsId(vo.getDscsId());
        dscsFdbkVO.setFdbkCts(fdbkCts);
        dscsFdbkVO.setStdId(stdId);

        dscsFdbkVO.setRgtrId(userId);
        dscsFdbkVO.setMdfrId(userId);

        if(vo.getTeamId() != null || vo.getTeamId() != "") {
            dscsFdbkVO.setTeamId(vo.getTeamId());
        }

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            dscsFdbkService.deleteDscsFdbk(dscsFdbkVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.alert.memo.error");/* 메모 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    // 일괄 피드백 팝업
    @RequestMapping(value="/allDscsFdbkPop.do")
    public String allDscsFdbkPop(DscsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String dscsId = vo.getDscsId();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        // 모든 토론 참여자를 토론 참여자 테이블에 삽입
        vo.setRgtrId(userId);
        dscsJoinUserService.insertJoinUser(vo);

        request.setAttribute("dscsId", dscsId);
        request.setAttribute("userId", userId);
        request.setAttribute("userName", userName);

        return "forum2/popup/forum_all_feedback";
    }

    // 일괄 피드백 작성
    @RequestMapping(value="/allAddFdbkCts.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> allAddFdbkCts(DscsVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String fdbkCts = request.getParameter("fdbkCts");

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        DscsFdbkVO dscsFdbkVO = new DscsFdbkVO();

        dscsFdbkVO.setDscsId(vo.getDscsId());
        dscsFdbkVO.setFdbkCts(fdbkCts);

        dscsFdbkVO.setRgtrId(userId);
        dscsFdbkVO.setRgtrnm(userName);
        dscsFdbkVO.setMdfrId(userId);

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            dscsFdbkService.insertDscsAllFdbk(dscsFdbkVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.alert.memo.error");/* 메모 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }


    // 학습자 활동공간
    @RequestMapping(value="/listTeamStdSumm.do")
    public String listTeamStdSumm(TeamVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        List<TeamVO> stdList = teamService.listStd(vo);
        request.setAttribute("stdList", stdList);
        request.setAttribute("vo", vo);

        return "forum/lect/team_std_list_summ";
    }

    // 학습자 활동공간
    @RequestMapping(value="/listTeamStdJson.do")
    @ResponseBody
    public ProcessResultVO<TeamVO> listTeamStdJson(TeamVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<TeamVO> resultVO = new ProcessResultVO<>();

        try {
            List<TeamVO> stdList = teamService.listStd(vo);

            resultVO.setReturnList(stdList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 피드백 저장
    @RequestMapping(value="/Form/regFdbk.do")
    @ResponseBody
    public ProcessResultVO<DscsFdbkVO> regFdbk(DscsFdbkVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        // 쪽지발송을 위한 목록
        String[] stdArr = vo.getStdId().split(",");

        // 피드백 저장
        ProcessResultVO<DscsFdbkVO> resultVO = dscsFdbkService.insertFdbk(vo);

        // TODO : 26.3.20 : to-be 임시 막음 처리함.
        // 피드백 쪽지 발송
        /*sendFeedbackMessage(request, vo, stdArr);*/

        return resultVO;
    }

    // 피드백 수정
    @RequestMapping(value="/edtFdbk.do")
    @ResponseBody
    public ProcessResultVO<DscsFdbkVO> edtFdbk(DscsFdbkVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        vo.setUserId(SessionInfo.getUserId(request));

        return dscsFdbkService.updateFdbk(vo);
    }

    // 피드백 삭제
    @RequestMapping(value="/delFdbk.do")
    @ResponseBody
    public ProcessResultVO<DscsFdbkVO> delFdbk(DscsFdbkVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        vo.setUserId(SessionInfo.getUserId(request));

        return dscsFdbkService.deleteFdbk(vo);
    }



    // 엑셀 성적 등록 팝업
    @RequestMapping(value="/forumScoreExcelUploadPop.do")
    public String dscsScoreExcelUploadPop(DscsVO dscsVO, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        dscsVO.setUploadPath(RepoInfo.getAtflRepo(request, CommConst.REPO_DSCS));

        model.addAttribute("dscsVO", dscsVO);
        model.addAttribute("userId", userId);

        return "forum2/popup/forum_score_excel_upload";
    }

    // 엑셀 성적 등록 샘플 엑셀 다운로드
    @RequestMapping(value="/forumScoreSampleDownload.do")
    public String dscsScoreSampleDownload(DscsVO dscsVO, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();

        dscsJoinUserVO.setSbjctId(dscsVO.getSbjctId());
        dscsJoinUserVO.setDscsId(dscsVO.getDscsId());

        dscsJoinUserVO.setSearchValue(dscsVO.getSearchValue());
        dscsJoinUserVO.setPageIndex(dscsVO.getPageIndex());
        dscsJoinUserVO.setListScale(1000);
        dscsJoinUserVO.setDscsUnitTycd(dscsVO.getDscsUnitTycd());
        ProcessResultVO<DscsJoinUserVO> resultList = dscsJoinUserService.listPaging(dscsJoinUserVO, dscsVO.getByteamDscsUseyn());
        request.setAttribute("forumJoinUserList", resultList.getReturnList());
        request.setAttribute("pageInfo", resultList.getPageInfo());

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적등록_학습자목록");
        map.put("sheetName", "성적등록_학습자목록");
        map.put("excelGrid", dscsVO.getExcelGrid());

        map.put("list", resultList.getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", "토론_성적등록_학습자목록_" + date.format(today));

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        // Cookie cookie = new Cookie("fileDownloadToken", "TRUE");
        // response.addCookie(cookie);

        return "excelView";
    }

    // 엑셀 성적등록 엑셀 업로드
    @RequestMapping(value="/uploadDscsScoreExcel.do")
    @ResponseBody
    public ProcessResultVO<DscsJoinUserVO> uploadDscsScoreExcel(DscsJoinUserVO dscsJoinUserVO, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String uploadFiles = dscsJoinUserVO.getUploadFiles();
        String uploadPath = dscsJoinUserVO.getUploadPath();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        dscsJoinUserVO.setRgtrId(userId);
        dscsJoinUserVO.setMdfrId(userId);

        String forumCtgrCd = StringUtil.nvl(request.getParameter("dscsUnitTycd"), request.getParameter("forumCtgrCd"));

        ProcessResultVO<DscsJoinUserVO> resultVO = new ProcessResultVO<>();
        try {
            /*List<FileVO> fileList = FileUtil.getUploadFileList(uploadFiles);
            FileVO fileVO = null;

            if(fileList != null && !fileList.isEmpty() && fileList.size() > 0) {
                fileVO = fileList.get(0);

                String fileExt = FileUtil.getFileExtention(fileVO.getFileNm());
                fileVO.setFilePath(uploadPath);
                fileVO.setFileSaveNm(fileVO.getFileSaveNm() + "." + fileExt);
            }*/
            List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(uploadFiles, uploadPath);
            List<String> fileIdList = new ArrayList<>();

            // 첨부파일
            if (uploadFileList.size() > 0) {
                for (AtflVO atflVO : uploadFileList) {
                    atflVO.setRefId(dscsJoinUserVO.getDscsId());
                    atflVO.setRgtrId(dscsJoinUserVO.getRgtrId());
                    atflVO.setMdfrId(dscsJoinUserVO.getMdfrId());
                    atflVO.setAtflRepoId(CommConst.REPO_DSCS);
                    fileIdList.add(atflVO.getAtflId());
                }

                // 첨부파일 저장
                attachFileService.insertAtflList(uploadFileList);
            }

            AtflVO atflVO = uploadFileList.get(0);

            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("startRaw", 4);
            map.put("excelGrid", dscsJoinUserVO.getExcelGrid());
            map.put("atflVO", atflVO);
            map.put("searchKey", "excelUpload");

            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            List<?> list = excelUtilPoi.simpleReadGrid(map);

            dscsJoinUserService.updateExampleExcelScore(dscsJoinUserVO, list, forumCtgrCd);

            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        } finally {
            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }
        return resultVO;
    }

    // 성적평가 리스트 엑셀 다운로드
    @RequestMapping(value="/listScoreExcel.do")
    public String listScoreExcel(DscsVO dscsVO, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();

        dscsJoinUserVO.setSbjctId(dscsVO.getSbjctId());
        dscsJoinUserVO.setDscsId(dscsVO.getDscsId());
        dscsJoinUserVO.setSearchValue(dscsVO.getSearchValue());
        dscsJoinUserVO.setPageIndex(dscsVO.getPageIndex());
        // dscsJoinUserVO.setListScale(dscsVO.getListScale());
        dscsJoinUserVO.setListScale(1000);

        ProcessResultVO<DscsJoinUserVO> resultList = dscsJoinUserService.listPaging(dscsJoinUserVO, dscsVO.getByteamDscsUseyn());
        request.setAttribute("forumJoinUserList", resultList.getReturnList());
        request.setAttribute("pageInfo", resultList.getPageInfo());

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적평가리스트");
        map.put("sheetName", "성적평가리스트");
        map.put("excelGrid", dscsVO.getExcelGrid());

        map.put("list", resultList.getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", "성적평가리스트_" + date.format(today));

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        // Cookie cookie = new Cookie("fileDownloadToken", "TRUE");
        // response.addCookie(cookie);

        return "excelView";
    }


    // 참여형 일괄평가
    @RequestMapping(value="/participateScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> participateScore(DscsJoinUserVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setSearchKey("JOIN");
            dscsJoinUserService.participateScore(vo);
            vo.setSearchKey("NOTJOIN");
            dscsJoinUserService.participateScore(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 개별 평가점수
    @RequestMapping(value="/setScoreRatio.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> setScoreRatio(DscsJoinUserVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String teamId = StringUtil.nvl(request.getParameter("teamId"));

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setTeamId(teamId);
            vo.setUserId(userId);

            dscsJoinUserService.setScoreRatio(vo);

            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 토론현황보기
    @RequestMapping(value="/forumChartViewPop.do")
    public String dscsChartViewPop(DscsVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String sbjctId = vo.getSbjctId();
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        // 성적분포현황차트
        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
        dscsJoinUserVO.setDscsId(vo.getDscsId());

        List<?> dscsJoinUserList = dscsJoinUserService.dscsJoinUserList(dscsJoinUserVO);
        int minScore = 0;
        int maxScore = 0;
        int totalScore = 0;
        int score = 0;
        int avgScore = 0;

        if(dscsJoinUserList.size() > 0) {
            for(int i = 0; i < dscsJoinUserList.size(); i++) {
                EgovMap egovMap = (EgovMap) dscsJoinUserList.get(i);
                /*
                 * long tmpScore = (long)egovMap.get("score"); score =
                 * Long.valueOf(tmpScore).intValue();
                 */

                BigDecimal tmpScore = (BigDecimal) egovMap.get("score");
                long befScore = tmpScore.longValue();
                score = Long.valueOf(befScore).intValue();

                if(i == 0) {
                    minScore = score;
                    maxScore = score;
                } else {
                    if(minScore > score) {
                        minScore = score;
                    }

                    if(maxScore < score) {
                        maxScore = score;
                    }
                }
                totalScore = totalScore + score;
            }
            avgScore = totalScore / dscsJoinUserList.size();
        }

        request.setAttribute("minScore", minScore);
        request.setAttribute("maxScore", maxScore);
        request.setAttribute("avgScore", avgScore);


        // TODO : 26.3.20 : to-be vo 변경에 따른 처리.
        /*vo = dscsService.selectDscs(vo);*/
        DscsVO param = new DscsVO();
        param.setSbjctId(vo.getSbjctId());
        param.setDscsId(vo.getDscsId());
        DscsVO loadedDscsVO = dscsService.selectDscs(param);
        vo = loadedDscsVO;
        // 찬반현황 차트용
        vo.setOrgId(orgId);
        vo.setSbjctId(sbjctId);

        request.setAttribute("dscsVO", vo);

        return "forum2/popup/forum_chart_view";
    }


    // 피드백 쪽지 발송
    private void sendFeedbackMessage(HttpServletRequest request, DscsFdbkVO vo, String[] stdNoArr) throws Exception {
        // 쪽지발송 처리
        /*if("Y".equals(CommConst.FEEDBACK_MESSAGE_SEND_YN)) {
            String orgId = SessionInfo.getOrgId(request);

            // 과목정보
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(vo.getCrsCreCd());
            creCrsVO = crecrsService.selectCreCrs(creCrsVO);

            // 토론정보
            DscsVO dscsVO = new DscsVO();
            dscsVO.setDscsId(vo.getDscsId());
            dscsVO = forumService.selectDscs(dscsVO);

            // 학생정보
            StdVO stdVO = new StdVO();
            stdVO.setCrsCreCd(vo.getCrsCreCd());
            stdVO.setStdIdArr(stdNoArr);
            List<StdVO> stdList = stdService.listUserByStdNo(stdVO);

            // 발송대상자 조회
            List<String> userIdList = new ArrayList<>();

            for(StdVO stdVO2 : stdList) {
                userIdList.add(stdVO2.getUserId());
            }

            UsrUserInfoVO userResvInfoVO = new UsrUserInfoVO();
            userResvInfoVO.setOrgId(orgId);
            userResvInfoVO.setSqlForeach(userIdList.toArray(new String[userIdList.size()]));
            List<UsrUserInfoVO> listUserRecvInfo = usrUserInfoService.listUserRecvInfo(userResvInfoVO);

            if(listUserRecvInfo.size() > 0) {
                String msgCtnt = "<b>[" + creCrsVO.getCrsCreNm() + "] 과목, [" + dscsVO.getDscsTtl() + "] 교수님 피드백입니다.</b><br>";
                msgCtnt += vo.getFdbkCts();

                ErpMessageMsgVO erpMessageMsgVO = new ErpMessageMsgVO();
                erpMessageMsgVO.setUsrUserInfoList(listUserRecvInfo);
                erpMessageMsgVO.setCtnt(msgCtnt);
                erpMessageMsgVO.setCrsCreCd(vo.getCrsCreCd());

                // 쪽지발송 저장
                erpService.insertSysMessageMsg(request, erpMessageMsgVO, "토론 피드백 쪽지 발송");
            }
        }*/
    }


    private void setCommonSessionValue(DscsListVO vo, HttpServletRequest request) {
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
    private void setCommonSessionValue(DscsVO vo, HttpServletRequest request) {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setLangCd(SessionInfo.getLocaleKey(request));
        vo.setUserId(SessionInfo.getUserId(request));
        vo.setRgtrId(SessionInfo.getUserId(request));
        vo.setMdfrId(SessionInfo.getUserId(request));
    }
}


