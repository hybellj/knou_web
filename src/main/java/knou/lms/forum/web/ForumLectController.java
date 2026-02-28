package knou.lms.forum.web;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.*;
import knou.framework.vo.FileVO;
import knou.lms.bbs.service.BbsAtclService;
import knou.lms.bbs.service.BbsInfoService;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.bbs.vo.BbsInfoVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.erp.service.ErpService;
import knou.lms.erp.vo.ErpMessageMsgVO;
import knou.lms.forum.service.*;
import knou.lms.forum.vo.*;
import knou.lms.lesson.service.LessonScheduleService;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.team.service.TeamCtgrService;
import knou.lms.team.service.TeamMemberService;
import knou.lms.team.service.TeamService;
import knou.lms.team.vo.TeamCtgrVO;
import knou.lms.team.vo.TeamMemberVO;
import knou.lms.team.vo.TeamVO;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrUserInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Controller
@RequestMapping(value="/forum/forumLect")
public class ForumLectController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(ForumLectController.class);

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name="forumService")
    private ForumService forumService;

    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="termService")
    private TermService termService;

    @Resource(name="teamService")
    private TeamService teamService;

    @Resource(name="teamCtgrService")
    private TeamCtgrService teamCtgrService;

    @Resource(name="teamMemberService")
    private TeamMemberService teamMemberService;

    @Autowired
    @Resource(name="forumAtclService")
    private ForumAtclService forumAtclService;

    @Resource(name="forumCmntService")
    private ForumCmntService forumCmntService;

    @Resource(name="forumJoinUserService")
    private ForumJoinUserService forumJoinUserService;

    @Resource(name="forumFdbkService")
    private ForumFdbkService forumFdbkService;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="bbsAtclService")
    private BbsAtclService bbsAtclService;

    @Resource(name="bbsInfoService")
    private BbsInfoService bbsInfoService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    @Resource(name="stdService")
    private StdService stdService;

    @Resource(name="erpService")
    private ErpService erpService;

    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name="lessonScheduleService")
    private LessonScheduleService lessonScheduleService;

    @Resource(name="usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;

    @Resource(name="forumMutService")
    private ForumMutService forumMutService;

    // 토론 목록 페이지
    @RequestMapping(value="/Form/forumList.do")
    public String forumListForm(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        String crsCreCd = forumVO.getCrsCreCd();

        if(ValidationUtils.isEmpty(crsCreCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", forumVO.getCrsCreCd());

        if(!"".equals(userId) & !"".equals(crsCreCd)) {
            forumVO.setTotalCnt(forumService.count(forumVO));
        }

        model.addAttribute("userId", userId);
        model.addAttribute("userName", userName);
        model.addAttribute("forumVO", forumVO);

        return "forum/lect/forum_list";
    }

    // 토론 공개여부 ajax
    @RequestMapping(value="/editForumOpen.do")
    @ResponseBody
    public ProcessResultVO<ForumVO> editForumOpen(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ForumVO> resultVO = new ProcessResultVO<>();

        try {
            // 토론공개 토글 ajax
            if(request.getParameter("forumCd") == null || request.getParameter("forumCd").equals("")) {
            } else {
                forumVO.setForumCd(request.getParameter("forumCd"));
            }

            if(request.getParameter("forumOpenYn") == null || request.getParameter("forumOpenYn").equals("")) {
            } else {
                forumVO.setForumOpenYn(request.getParameter("forumOpenYn"));
            }

            forumService.updateForum(forumVO);
            resultVO.setResult(1);
            resultVO.setMessage("forum.java.message.forum.open.yes"); // 사용여부를 수정하였습니다.
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.java.message.forum.open.no"); // 사용여부를 수정하지 못하였습니다.
        }
        return resultVO;
    }

    // 성정반영 비율 저장
    @RequestMapping(value="/editScoreRatioAjax.do")
    @ResponseBody
    public ProcessResultVO<ForumVO> editScoreRatioAjax(ForumVO forumVO, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        ProcessResultVO<ForumVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        try {
            forumVO.setMdfrId(userId);
            String[] forumCds = StringUtil.nvl(forumVO.getForumCds()).split("\\|");
            String[] scoreRatios = StringUtil.nvl(forumVO.getScoreRatios()).split("\\|");

            if(forumCds.length > 0 && !"".equals(forumCds[0])) {
                for(int i = 0; i < forumCds.length; i++) {
                    forumVO.setForumCd(forumCds[i]);
                    forumVO.setScoreRatio(Integer.valueOf(scoreRatios[i]));
                    forumService.updateForum(forumVO);
                }
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.java.message.edit.score"); // 수정 중 오류가 발생하였습니다. 잠시 후 다시 시도해주세요.
        }
        return resultVO;
    }

    // 토론정보
    @RequestMapping(value="/Form/infoManage.do")
    public String infoManage(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        request.setAttribute("tab", request.getParameter("tab"));
        String rltnCd = request.getParameter("rltnCd");

        String crsCreCd = forumVO.getCrsCreCd();
        if(crsCreCd != null && !crsCreCd.equals("")) {
            // UserBroker.setCreCrsCd(request, crsCreCd);
        }

        if(rltnCd == null || rltnCd.equals("")) {

        } else {
            forumVO.setForumCd(rltnCd);
            // forumVO.setOrgId("ORG0000001");
            forumVO.setCrsCreCd(request.getParameter("crsCreCd"));
        }

        forumVO = forumService.selectForum(forumVO);
        forumVO.setCrsCreCd(crsCreCd);
        /*  강의실에서 토론 진입시 교수자ID */
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        /*강의실에서 토론 진입시 교수자이름*/
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // model.addAttribute("crsCreCd", vo.getCrsCreCd());

        request.setAttribute("userId", userId);
        request.setAttribute("userName", userName);

        request.setAttribute("forumVo", forumVO);

        return "forum/lect/forum_info_manage";
    }

    // 토론방
    @RequestMapping(value="/Form/bbsManage.do")
    public String bbsManage(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        model.addAttribute("tab", request.getParameter("tab"));

        forumVO = forumService.selectForum(forumVO);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        /* 강의실에서 토론 진입시 교수자이름 */
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", forumVO.getCrsCreCd());

        model.addAttribute("userId", userId);
        model.addAttribute("userName", userName);
        model.addAttribute("forumVo", forumVO);
        model.addAttribute("konanCopyScoreUrl", CommConst.KONAN_COPY_SCORE_URL);

        return "forum/lect/forum_bbs_manage";
    }

    // 토론방 리스트 ajax
    @RequestMapping(value="/Form/forumBbsViewList.do")
    @ResponseBody
    public ProcessResultVO<ForumAtclVO> forumBbsViewList(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String crsCreCd = forumVO.getCrsCreCd();

        String stdList = forumVO.getStdList();

        /*토론 게시글*/
        ForumAtclVO forumAtclVO = new ForumAtclVO();

        forumAtclVO.setForumCd(forumVO.getForumCd());
        forumAtclVO.setStdList(stdList);
        forumAtclVO.setSearchValue(forumVO.getSearchValue());
        forumAtclVO.setPageIndex(forumVO.getPageIndex());
        //int listScale = 2; //forumAtclVO.getListScale()
        forumAtclVO.setListScale(forumVO.getListScale());
        forumAtclVO.setCrsCreCd(crsCreCd);

        // 팀토론일 경우 팀원 목록 가져오기
        if("TEAM".equals(forumVO.getForumCtgrCd())) {
            TeamMemberVO teamMemberVO = new TeamMemberVO();
            teamMemberVO.setCrsCreCd(crsCreCd);
            // teamMemberVO.setUserId(userId);
            teamMemberVO.setTeamCtgrCd(forumVO.getTeamCtgrCd());
            teamMemberVO.setTeamNm(forumVO.getTeamNm());
            // 팀원 리스트
            String[] teamMemberList = teamMemberService.getTeamMemberList(teamMemberVO);
            int i = 0;
            String stdMemberList = "";
            for(String stdNo : teamMemberList) {
                if(i == 0) {
                    stdMemberList += stdNo;
                } else {
                    stdMemberList += "," + stdNo;
                }
                i++;
            }
            forumAtclVO.setStdList(stdMemberList);
        }

        ProcessResultVO<ForumAtclVO> resultVO = new ProcessResultVO<>();

        try {
            resultVO = forumAtclService.listPageing(forumAtclVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 토론방 엑셀 다운로드
    @RequestMapping(value="/downExcelForumAtclList.do")
    public String downExcelForumAtclList(ForumAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);

        vo.setOrgId(orgId);

        ForumVO forumVO = new ForumVO();
        forumVO.setForumCd(vo.getForumCd());
        forumVO = forumService.select(forumVO);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(forumVO.getCrsCreCd());
        creCrsVO = crecrsService.select(creCrsVO);

        String crsCreNm = creCrsVO.getCrsCreNm() + "(" + creCrsVO.getDeclsNo() + ")";

        // 조회조건 
        String[] searchValues = {};

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        List<EgovMap> list = forumAtclService.forumAtclExcalList(vo);

        for(EgovMap map : list) {
            String cts = StringUtil.nvl(map.get("cts"));
            cts = StringUtil.removeScript(cts);
            cts = StringUtil.removeTag(cts);
            cts = cts.replace("&nbsp;", "");

            map.put("cts", cts);
        }

        String title = forumVO.getForumTitle();

        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);

        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", crsCreNm + "_" + title + "_" + date.format(today));
        modelMap.put("sheetName", title);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    // 토론방 등록 팝업
    @RequestMapping(value="/Form/addForumBbs.do")
    public String addForumBbs(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        request.setAttribute("tab", request.getParameter("tab"));
        request.setAttribute("type", request.getParameter("type"));

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        /* 강의실에서 토론 진입시 교수자이름 */
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        String atclSn = IdGenerator.getNewId("ATCL");

        request.setAttribute("userId", userId);
        request.setAttribute("userName", userName);
        request.setAttribute("atclSn", atclSn);
        request.setAttribute("forumVo", forumVO);

        return "forum/lect/forum_bbs_view_write";
    }

    // 토론방 글 등록 ajax
    @RequestMapping(value="/Form/addAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addAtcl(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String prosConsTypeCd = request.getParameter("prosConsTypeCd");
        String atclTypeCd = request.getParameter("atclTypeCd");
        String atclSn = request.getParameter("atclSn");
        String cts = request.getParameter("cts");

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        /* 강의실에서 토론 진입시 교수자이름 */
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        try {
            ForumAtclVO forumAtclVO = new ForumAtclVO();
            forumAtclVO.setForumCd(vo.getForumCd());
            forumAtclVO.setAtclSn(atclSn);
            forumAtclVO.setProsConsTypeCd(prosConsTypeCd);
            forumAtclVO.setAtclTypeCd(atclTypeCd);
            forumAtclVO.setAtclSn(atclSn);
            forumAtclVO.setCts(cts);
            forumAtclVO.setCrsCreCd(vo.getCrsCreCd());

            forumAtclVO.setRgtrId(userId);
            forumAtclVO.setUserId(userId);
            forumAtclVO.setRgtrnm(userName);
            forumAtclVO.setMdfrId(userId);

            forumAtclVO.setUploadFiles(vo.getUploadFiles());
            forumAtclVO.setUploadPath(vo.getUploadPath());
            forumAtclVO.setRepoCd(vo.getRepoCd());

            forumAtclVO.setStdId("");
            forumAtclVO.setAtclOdr(0);

            forumAtclService.insertAtcl(forumAtclVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    // 토론방 수정 팝업
    @RequestMapping(value="/Form/editForumBbs.do")
    public String editForumBbs(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        request.setAttribute("tab", request.getParameter("tab"));
        request.setAttribute("type", request.getParameter("type"));
        String atclSn = request.getParameter("atclSn");

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        /*강의실에서 토론 진입시 교수자이름*/
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        request.setAttribute("userId", userId);
        request.setAttribute("userName", userName);

        if(!"".equals(StringUtil.nvl(atclSn))) {
            ForumAtclVO forumAtclVO = new ForumAtclVO();
            forumAtclVO.setAtclSn(atclSn);
            forumAtclVO.setForumCd(forumVO.getForumCd());
            forumAtclVO = forumAtclService.selectAtcl(forumAtclVO);

            request.setAttribute("forumAtclVO", forumAtclVO);

            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("FORUM");
            fileVO.setFileBindDataSn(atclSn);
            ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);
            for(FileVO fvo : fileList.getReturnList()) {
                fvo.setFileId((fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf("."))));
            }
            request.setAttribute("fileList", fileList.getReturnList());
        }
        request.setAttribute("forumVo", forumVO);
        request.setAttribute("atclSn", atclSn);

        return "forum/lect/forum_bbs_view_write";
    }

    // 토론방 글  수정 ajax
    @RequestMapping(value="/Form/editAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editAtcl(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String atclSn = request.getParameter("atclSn");
        String cts = request.getParameter("cts");
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String prosConsTypeCd = request.getParameter("prosConsTypeCd");

        ForumAtclVO forumAtclVO = new ForumAtclVO();
        forumAtclVO.setForumCd(vo.getForumCd());
        forumAtclVO.setProsConsTypeCd(prosConsTypeCd);
        forumAtclVO.setAtclSn(atclSn);
        forumAtclVO.setCts(cts);
        forumAtclVO.setUploadFiles(vo.getUploadFiles());
        forumAtclVO.setUploadPath(vo.getUploadPath());
        forumAtclVO.setRepoCd(vo.getRepoCd());
        forumAtclVO.setDelFileIds(vo.getDelFileIds());

        forumAtclVO.setRgtrId(userId);
        forumAtclVO.setMdfrId(userId);

        String userType = StringUtil.nvl(SessionInfo.getClassUserType(request));

        if(userType.equals("CLASS_LEARNER")) {
            forumAtclVO.setStdId(SessionInfo.getStdNo(request));
        }

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            forumAtclService.updateAtcl(forumAtclVO);
            returnVo.setResult(1);
        } catch(Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }
        return returnVo;
    }

    // 토론방 댓글 등록
    @RequestMapping(value="/Form/addCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> addCmnt(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String atclSn = request.getParameter("atclSn");
        String ansReqYn = request.getParameter("ansReqYn");
        String parCmntSn = request.getParameter("parCmntSn");
        String cmntCts = request.getParameter("cmntCts");
        String crsCreCd = request.getParameter("crsCreCd");
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        /* 강의실에서 토론 진입시 교수자이름 */
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        ForumCmntVO forumCmntVO = new ForumCmntVO();
        forumCmntVO.setCmntSn(IdGenerator.getNewId("CMNT"));
        if(parCmntSn == null || parCmntSn.equals("")) {
            forumCmntVO.setParCmntSn(null);
        } else {
            forumCmntVO.setParCmntSn(parCmntSn);
        }
        forumCmntVO.setForumCd(forumVO.getForumCd());
        forumCmntVO.setAtclSn(atclSn);
        forumCmntVO.setAnsReqYn(ansReqYn);
        forumCmntVO.setCmntCts(cmntCts);
        forumCmntVO.setCrsCreCd(forumVO.getCrsCreCd());

        forumCmntVO.setRgtrId(userId);
        forumCmntVO.setRgtrnm(userName);
        forumCmntVO.setMdfrId(userId);

        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        if(userType.equals("CLASS_LEARNER")) {
            forumCmntVO.setStdId(SessionInfo.getStdNo(request));
        }

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            forumCmntService.insertCmnt(forumCmntVO);

            // 답변 요청 체크시 QnA 게시판에 등록
            String orgId = SessionInfo.getOrgId(request);
            if("Y".equals(forumCmntVO.getAnsReqYn())) {
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

            returnVo.setResult(1);
        } catch(Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }
        return returnVo;
    }

    // 성적평가
    @RequestMapping(value="/Form/scoreManage.do")
    public String scoreManage(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        model.addAttribute("tab", request.getParameter("tab"));
        String rltnCd = request.getParameter("rltnCd");

        String crsCreCd = forumVO.getCrsCreCd();

        if(rltnCd == null || rltnCd.equals("")) {
        } else {
            forumVO.setForumCd(rltnCd);
            forumVO.setOrgId(orgId);
        }

        forumVO = forumService.selectForum(forumVO);
        /*  강의실에서 토론 진입시 교수자ID */
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        /* 강의실에서 토론 진입시 교수자이름 */
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", forumVO.getCrsCreCd());

        model.addAttribute("userId", userId);
        model.addAttribute("userName", userName);

        if("R".equals(StringUtil.nvl(forumVO.getEvalCtgr()))) {
            // 모든 토론 참여자를 토론 참여자 테이블에 삽입
            ForumVO fvo = new ForumVO();
            fvo.setRgtrId(userId);
            fvo.setCrsCreCd(forumVO.getCrsCreCd());
            fvo.setForumCd(forumVO.getForumCd());
            forumJoinUserService.insertJoinUser(fvo);

            ForumJoinUserVO joinUserVO = new ForumJoinUserVO();
            joinUserVO.setSearchMenu("ONCE");
            joinUserVO.setRgtrId(userId);
            joinUserVO.setForumCd(forumVO.getForumCd());
            joinUserVO.setSearchKey("JOIN");
            forumJoinUserService.participateScore(joinUserVO);
            //joinUserVO.setSearchKey("NOTJOIN");
            //forumJoinUserService.participateScore(joinUserVO);
        }
        ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
        forumJoinUserVO.setForumCd(forumVO.getForumCd());

        // 성적분포현황차트
        List<?> forumJoinUserList = forumJoinUserService.forumJoinUserList(forumJoinUserVO);
        int minScore = 0;
        int maxScore = 0;
        int totalScore = 0;
        int score = 0;
        int avgScore = 0;

        if(forumJoinUserList.size() > 0) {
            for(int i = 0; i < forumJoinUserList.size(); i++) {
                EgovMap egovMap = (EgovMap) forumJoinUserList.get(i);

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
            avgScore = totalScore / forumJoinUserList.size();
        }

        model.addAttribute("minScore", minScore);
        model.addAttribute("maxScore", maxScore);
        model.addAttribute("avgScore", avgScore);

        // 찬반현황 차트용
        forumVO.setOrgId(orgId);
        forumVO = forumService.selectForum(forumVO);
        forumVO.setCrsCreCd(crsCreCd);

        model.addAttribute("forumVo", forumVO);
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.select(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);

        return "forum/lect/forum_score_manage";
    }

    // 상호평가 탭
    @RequestMapping(value="/Form/mutEvalResult.do")
    public String mutEvalResult(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        forumVO.setOrgId(orgId);
        forumVO = forumService.selectForum(forumVO);

        model.addAttribute("forumVo", forumVO);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", forumVO.getCrsCreCd());

        return "forum/lect/forum_mut_eval_result";
    }

    // 토론 등록 폼
    @RequestMapping(value="/Form/addForumForm.do")
    public String addForumForm(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String lessonScheduleId = forumVO.getLessonScheduleId();

        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        /* 강의실에서 토론 진입시 교수자이름 */
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // model.addAttribute("crsCreCd", vo.getCrsCreCd());

        model.addAttribute("userId", userId);
        model.addAttribute("userName", userName);
        model.addAttribute("forumVo", forumVO);
        model.addAttribute("lessonScheduleId", lessonScheduleId);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(forumVO.getCrsCreCd());
        ;
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);

        List<CreCrsVO> declsList = crecrsService.listCreCrsDeclsNo(creCrsVO);
        model.addAttribute("declsList", declsList);

        String forumCd = IdGenerator.getNewId("FORUM");
        model.addAttribute("forumCd", forumCd);

        // 강의실 > 학습요소 추가 > 이전 데이터 가져오기
        String gubun = StringUtil.nvl(request.getParameter("gubun"));
        model.addAttribute("gubun", gubun);

        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(forumVO.getCrsCreCd());
        List<LessonScheduleVO> lessonScheduleList = lessonScheduleService.list(lessonScheduleVO);
        model.addAttribute("lessonScheduleList", lessonScheduleList);

        // 등록 or 수정 구분 - I : 등록, E : 수정
        model.addAttribute("mode", "I");

        return "forum/lect/forum_write_form";
    }

    // 토론 등록
    @RequestMapping(value="/addForum.do")
    @ResponseBody
    public ProcessResultVO<ForumVO> addForum(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ForumVO> resultVO = new ProcessResultVO<>();

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setRgtrId(userId);

        try {
            // 토론 등록
            forumService.insertForum(vo, request);

            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    // 이전 토론 가져오기 팝업
    @RequestMapping(value="/Form/forumCopyPop.do")
    public String forumCopyPop(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();

        // 강의실 대표교수 정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.selectTchCreCrs(creCrsVO);

        String repUserId = creCrsVO.getUserId();

        // 대표교수의 과목이 있는 학기 목록 조회
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO.setCrsCreCd(crsCreCd);
        List<TermVO> termList = termService.listTermByProf(termVO);

        model.addAttribute("vo", vo);
        model.addAttribute("termList", termList);
        model.addAttribute("repUserId", repUserId);

        return "forum/lect/forumCopyPop";
    }

    // 이전 토론 가져오기 리스트 ajax
    @RequestMapping(value="/Form/forumCopyList.do")
    @ResponseBody
    public ProcessResultVO<ForumVO> fourmCopyList(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ForumVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);

            resultVO = forumService.listMyCreCrsForum(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    // 이전 토론 가져오기 ajax
    @RequestMapping(value="/Form/forumCopy.do")
    @ResponseBody
    public ProcessResultVO<ForumVO> forumCopy(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<ForumVO> returnVO = new ProcessResultVO<ForumVO>();

        try {
            ForumVO forumVO = new ForumVO();
            forumVO = forumService.select(vo);
            returnVO.setReturnVO(forumVO);
            returnVO.setResult(1);
        } catch(Exception e) {
            returnVO.setResult(-1);
            returnVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return returnVO;
    }

    // 토론 수정 폼
    @RequestMapping(value="/Form/editForumForm.do")
    public String editForumForm(@Valid ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String crsCreCd = StringUtil.nvl(vo.getCrsCreCd());

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", crsCreCd);

        vo = forumService.selectForum(vo);
        vo.setCrsCreCd(crsCreCd);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);

        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("FORUM");
        fileVO.setFileBindDataSn(vo.getForumCd());
        ProcessResultVO<FileVO> fileList = sysFileService.list(fileVO);
        for(FileVO fvo : fileList.getReturnList()) {
            fvo.setFileId((fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf("."))));
        }
        model.addAttribute("fileList", fileList.getReturnList());

        List<CreCrsVO> declsList = crecrsService.listCreCrsDeclsNo(creCrsVO);
        model.addAttribute("declsList", declsList);

        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        List<LessonScheduleVO> lessonScheduleList = lessonScheduleService.list(lessonScheduleVO);
        model.addAttribute("lessonScheduleList", lessonScheduleList);

        model.addAttribute("forumVo", vo);

        // 등록 or 수정 구분 - I : 등록, E : 수정
        model.addAttribute("mode", "E");

        LocalDateTime today = LocalDateTime.now();
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));

        return "forum/lect/forum_write_form";
    }

    // 토론 수정
    @RequestMapping(value="/editForum.do")
    @ResponseBody
    public ProcessResultVO<ForumVO> editForum(@Valid ForumVO vo, BindingResult bindingResult, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<ForumVO> error = ValidateUtil.validate(bindingResult);
        if(error != null) return error;

        ProcessResultVO<ForumVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        try {
            vo.setMdfrId(userId);
            vo.setRgtrId(userId);

            if("".equals(StringUtil.nvl(vo.getOtherViewYn()))) {
                vo.setOtherViewYn("N");
            }

            forumService.updateForum(vo);

            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    // 토론 삭제
    @RequestMapping(value="/Form/delForum.do")
    public String delForum(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String crsCreCd = vo.getCrsCreCd();

        vo.setMdfrId(userId);
        vo.setRgtrId(userId);
        /*강의실에서 토론 진입시 교수자이름*/

        if("Y".equals(StringUtil.nvl(request.getParameter("returnLebYn"))) && StringUtil.nvl(vo.getForumStartDttm()).length() < 16) {
            vo = forumDateConversion(vo);
        }

        forumService.deleteForumCreCrsRltn(vo);
        forumService.deleteForum(vo);

        // 성적반영여부(SCORE_APLY_YN)가 Y인 경우에 성적반영 비율 100% 기준으로 1/N 자동 계산하여 성적반영비율 필더(SCORE_RATIO)에 저장
        ForumVO fvo = new ForumVO();
        fvo.setCrsCreCd(crsCreCd);
        forumService.setScoreRatio(fvo);

        /*강의실에서 토론 진입시 CRE_CRS_CD 값*/
        String url = "";
        url = new URLBuilder("forum", "/forum/forumLect/Form/forumList.do", request).addParameter("crsCreCd", crsCreCd).toString();
        return "redirect:" + url;
    }

    // 토론방 게시글  삭제 ajax
    @RequestMapping(value="/Form/delAtcl.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delAtcl(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String atclSn = request.getParameter("atclSn");

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        ForumAtclVO forumAtclVO = new ForumAtclVO();
        forumAtclVO.setForumCd(forumVO.getForumCd());
        forumAtclVO.setAtclSn(atclSn);

        forumAtclVO.setRgtrId(userId);
        forumAtclVO.setMdfrId(userId);

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            forumAtclService.deleteAtcl(forumAtclVO);
            returnVo.setResult(1);
        } catch(Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }
        return returnVo;
    }

    // 토론방 댓글 수정
    @RequestMapping(value="/Form/editCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editCmnt(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String cmntSn = request.getParameter("cmntSn");
        String cmntCts = request.getParameter("cmntCts");
        String ansReqYn = request.getParameter("ansReqYn");

        ForumCmntVO forumCmntVO = new ForumCmntVO();
        forumCmntVO.setCmntSn(cmntSn);
        forumCmntVO.setCmntCts(cmntCts);
        forumCmntVO.setAnsReqYn(ansReqYn);

        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        if(userType.equals("CLASS_LEARNER")) {
            forumCmntVO.setStdId(StringUtil.nvl(SessionInfo.getStdNo(request)));
        }

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            forumCmntService.updateCmnt(forumCmntVO);
            returnVo.setResult(1);
        } catch(Exception e) {
            returnVo.setResult(-1);
            returnVo.setMessage(getMessage("forum.common.error")); // 오류가 발생했습니다!
        }
        return returnVo;
    }

    // 토론방 댓글 삭제
    @RequestMapping(value="/Form/delCmnt.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> delCmnt(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String cmntSn = request.getParameter("cmntSn");

        ForumCmntVO forumCmntVO = new ForumCmntVO();
        forumCmntVO.setCmntSn(cmntSn);

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<>();
        try {
            forumCmntService.deleteCmnt(forumCmntVO);
            returnVo.setResult(1);
        } catch(Exception e) {
            returnVo.setResult(-1);
        }
        return returnVo;
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

    // 성적평가 성적 등록
    @RequestMapping(value="/addStdScore.do")
    @ResponseBody
    public ProcessResultVO<ForumJoinUserVO> addStdScore(ForumJoinUserVO forumJoinUserVO, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        ProcessResultVO<ForumJoinUserVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        forumJoinUserVO.setRgtrId(userId);
        forumJoinUserVO.setMdfrId(userId);

        try {
            forumJoinUserService.addStdScore(forumJoinUserVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 성적분포현황 BarChart
    @RequestMapping(value="/viewScoreChart.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> viewScoreChart(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try {
            EgovMap scoreMap = forumService.viewScoreChart(vo);

            resultVO.setReturnVO(scoreMap);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 교수 메모 팝업창 정보
    @RequestMapping(value="/forumProfMemoPop.do")
    public String forumProfMemoPop(ForumJoinUserVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.infoCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);
        request.setAttribute("forumCd", vo.getForumCd());
        request.setAttribute("stdNo", vo.getStdId());

        vo.setUserId(SessionInfo.getUserId(request));
        ;
        vo = forumJoinUserService.selectProfMemo(vo);
        request.setAttribute("vo", vo);

        return "forum/popup/forum_prof_memo";
    }

    // 교수 메모 수정
    @RequestMapping(value="/editForumProfMemo.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editForumProfMemo(ForumJoinUserVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        try {
            vo.setMdfrId(userId);
            forumJoinUserService.editForumProfMemo(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.alert.memo.error");/* 메모 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    // 피드백
    @RequestMapping(value="/forumFdbkPop.do")
    public String forumFeedBack(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("PROF") ? "PROF" : "USR");
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.infoCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);

        String forumCd = vo.getForumCd();
        String stdNo = vo.getStdId();
        String teamCd = vo.getTeamCd();

        request.setAttribute("forumCd", forumCd);
        request.setAttribute("stdNo", stdNo);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
        forumJoinUserVO.setForumCd(forumCd);
        forumJoinUserVO.setStdId(stdNo);
        forumJoinUserVO.setUserId(userId);
        forumJoinUserVO = forumJoinUserService.selectProfMemo(forumJoinUserVO);

        request.setAttribute("forumJoinUserVO", forumJoinUserVO);

        // String userType = StringUtil.nvl(SessionInfo.getClassUserType(request));
        String userType = "CLASS_PROFESSOR";

        /*
        if(!"EZG".equals(vo.getSearchMenu())) {
            forumJoinUserVO = forumJoinUserService.selectForumJoinUser(forumJoinUserVO);
            request.setAttribute("forumJoinUserVo", forumJoinUserVO);
        }
        */

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
        forumFdbkVO.setForumCd(forumCd);
        forumFdbkVO.setStdId(stdNo);

        if(teamCd != null || teamCd != "") {
            forumFdbkVO.setTeamCd(teamCd);
        }

        request.setAttribute("userId", userId);
        request.setAttribute("userName", userName);
        request.setAttribute("userType", userType);

        String student = (SessionInfo.getAuthrtGrpcd(request).contains("USR")) ? "STD" : "";
        request.setAttribute("student", student);

        request.setAttribute("forumVo", vo);
        request.setAttribute("PAGE_FILE_UPLOAD", request.getContextPath() + CommConst.PAGE_FILE_UPLOAD);

        return "forum/popup/forum_feedback";
    }

    // 피드백 조회
    @RequestMapping(value="/getFdbk.do")
    @ResponseBody
    public ProcessResultVO<ForumFdbkVO> getFdbk(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String fdbkCts = request.getParameter("fdbkCts");
        String parForumFdbkCd = request.getParameter("parForumFdbkCd");
        String stdNo = vo.getStdId();

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
        forumFdbkVO.setForumFdbkCd(IdGenerator.getNewId("FFDBK"));
        if(parForumFdbkCd == null || parForumFdbkCd.equals("")) {
            forumFdbkVO.setParForumFdbkCd(null);
        } else {
            forumFdbkVO.setParForumFdbkCd(parForumFdbkCd);
        }
        forumFdbkVO.setForumCd(vo.getForumCd());
        forumFdbkVO.setFdbkCts(fdbkCts);
        forumFdbkVO.setStdId(stdNo);

        if(vo.getTeamCd() != null || vo.getTeamCd() != "") {
            forumFdbkVO.setTeamCd(vo.getTeamCd());
        }

        // 피드백 리스트
        ProcessResultVO<ForumFdbkVO> resultVO = new ProcessResultVO<>();
        try {
            List<ForumFdbkVO> list = forumFdbkService.selectFdbk(forumFdbkVO);
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
    public ProcessResultVO<DefaultVO> addFockCts(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String fdbkCts = request.getParameter("fdbkCts");
        String parForumFdbkCd = request.getParameter("parForumFdbkCd");
        String stdNo = vo.getStdId();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
        forumFdbkVO.setForumFdbkCd(IdGenerator.getNewId("FFDBK"));
        if(parForumFdbkCd == null || parForumFdbkCd.equals("")) {
            forumFdbkVO.setParForumFdbkCd(null);
        } else {
            forumFdbkVO.setParForumFdbkCd(parForumFdbkCd);
        }
        forumFdbkVO.setForumCd(vo.getForumCd());
        forumFdbkVO.setFdbkCts(fdbkCts);
        forumFdbkVO.setStdId(stdNo);

        forumFdbkVO.setRgtrId(userId);
        forumFdbkVO.setRgtrnm(userName);
        forumFdbkVO.setMdfrId(userId);

        if(vo.getTeamCd() != null || vo.getTeamCd() != "") {
            forumFdbkVO.setTeamCd(vo.getTeamCd());
        }

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            forumFdbkService.insertForumFdbk(forumFdbkVO);
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
    public ProcessResultVO<DefaultVO> editFdbkCts(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String forumFdbkCd = request.getParameter("forumFdbkCd");
        String fdbkCts = request.getParameter("fdbkCts");
        String stdNo = vo.getStdId();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
        forumFdbkVO.setForumFdbkCd(forumFdbkCd);
        forumFdbkVO.setForumCd(vo.getForumCd());
        forumFdbkVO.setFdbkCts(fdbkCts);
        forumFdbkVO.setStdId(stdNo);

        forumFdbkVO.setRgtrId(userId);
        forumFdbkVO.setMdfrId(userId);

        if(vo.getTeamCd() != null || vo.getTeamCd() != "") {
            forumFdbkVO.setTeamCd(vo.getTeamCd());
        }

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            forumFdbkService.updateForumFdbk(forumFdbkVO);
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
    public ProcessResultVO<DefaultVO> delFdbkCts(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String forumFdbkCd = request.getParameter("forumFdbkCd");
        String fdbkCts = request.getParameter("fdbkCts");
        String stdNo = vo.getStdId();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
        forumFdbkVO.setForumFdbkCd(forumFdbkCd);
        forumFdbkVO.setForumCd(vo.getForumCd());
        forumFdbkVO.setFdbkCts(fdbkCts);
        forumFdbkVO.setStdId(stdNo);

        forumFdbkVO.setRgtrId(userId);
        forumFdbkVO.setMdfrId(userId);

        if(vo.getTeamCd() != null || vo.getTeamCd() != "") {
            forumFdbkVO.setTeamCd(vo.getTeamCd());
        }

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            forumFdbkService.deleteForumFdbk(forumFdbkVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.alert.memo.error");/* 메모 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    // 일괄 피드백 팝업
    @RequestMapping(value="/allForumFdbkPop.do")
    public String allForumFdbkPop(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String forumCd = vo.getForumCd();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        // 모든 토론 참여자를 토론 참여자 테이블에 삽입
        vo.setRgtrId(userId);
        forumJoinUserService.insertJoinUser(vo);

        request.setAttribute("forumCd", forumCd);
        request.setAttribute("userId", userId);
        request.setAttribute("userName", userName);

        return "forum/popup/forum_all_feedback";
    }

    // 일괄 피드백 작성
    @RequestMapping(value="/allAddFdbkCts.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> allAddFdbkCts(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String fdbkCts = request.getParameter("fdbkCts");

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String userName = StringUtil.nvl(SessionInfo.getUserNm(request));

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();

        forumFdbkVO.setForumCd(vo.getForumCd());
        forumFdbkVO.setFdbkCts(fdbkCts);

        forumFdbkVO.setRgtrId(userId);
        forumFdbkVO.setRgtrnm(userName);
        forumFdbkVO.setMdfrId(userId);

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        try {
            forumFdbkService.insertForumAllFdbk(forumFdbkVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.alert.memo.error");/* 메모 저장 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    // 엑셀 성적 등록 팝업
    @RequestMapping(value="/forumScoreExcelUploadPop.do")
    public String forumScoreExcelUploadPop(ForumVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));


        model.addAttribute("vo", vo);
        model.addAttribute("userId", userId);

        return "forum/popup/forum_score_excel_upload";
    }

    // 엑셀 성적 등록 샘플 엑셀 다운로드
    @RequestMapping(value="/forumScoreSampleDownload.do")
    public String forumScoreSampleDownload(ForumVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();

        forumJoinUserVO.setCrsCreCd(vo.getCrsCreCd());
        forumJoinUserVO.setForumCd(vo.getForumCd());

        forumJoinUserVO.setSearchValue(vo.getSearchValue());
        forumJoinUserVO.setPageIndex(vo.getPageIndex());
        forumJoinUserVO.setListScale(1000);
        forumJoinUserVO.setForumCtgrCd(vo.getForumCtgrCd());
        ProcessResultVO<ForumJoinUserVO> resultList = forumJoinUserService.listPageing(forumJoinUserVO);
        request.setAttribute("forumJoinUserList", resultList.getReturnList());
        request.setAttribute("pageInfo", resultList.getPageInfo());

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적등록_학습자목록");
        map.put("sheetName", "성적등록_학습자목록");
        map.put("excelGrid", vo.getExcelGrid());

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
    @RequestMapping(value="/uploadForumScoreExcel.do")
    @ResponseBody
    public ProcessResultVO<ForumJoinUserVO> uploadForumScoreExcel(ForumJoinUserVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);

        String forumCtgrCd = request.getParameter("forumCtgrCd");

        ProcessResultVO<ForumJoinUserVO> resultVO = new ProcessResultVO<>();
        try {
            FileVO fileVO = new FileVO();
            fileVO.setUploadFiles(vo.getUploadFiles());
            fileVO.setCopyFiles(vo.getCopyFiles());
            fileVO.setFilePath(vo.getUploadPath());
            fileVO.setRepoCd(vo.getRepoCd());
            fileVO.setRgtrId(vo.getRgtrId());

            fileVO = sysFileService.addFile(fileVO);

            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("startRaw", 4);
            map.put("excelGrid", vo.getExcelGrid());
            map.put("fileVO", fileVO);
            map.put("searchKey", "excelUpload");

            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            List<?> list = excelUtilPoi.simpleReadGrid(map);

            forumJoinUserService.updateExampleExcelScore(vo, list, forumCtgrCd);

            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    // 성적평가 리스트 엑셀 다운로드
    @RequestMapping(value="/listScoreExcel.do")
    public String listScoreExcel(ForumVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();

        forumJoinUserVO.setCrsCreCd(vo.getCrsCreCd());
        forumJoinUserVO.setForumCd(vo.getForumCd());
        forumJoinUserVO.setSearchValue(vo.getSearchValue());
        forumJoinUserVO.setPageIndex(vo.getPageIndex());
        // forumJoinUserVO.setListScale(vo.getListScale());
        forumJoinUserVO.setListScale(1000);

        ProcessResultVO<ForumJoinUserVO> resultList = forumJoinUserService.listPageing(forumJoinUserVO);
        request.setAttribute("forumJoinUserList", resultList.getReturnList());
        request.setAttribute("pageInfo", resultList.getPageInfo());

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적평가리스트");
        map.put("sheetName", "성적평가리스트");
        map.put("excelGrid", vo.getExcelGrid());

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

    public ForumVO forumDateConversion(ForumVO vo) throws Exception {
        //토론시작일시
        if(vo.getForumStartDttm() == null || vo.getForumStartDttm().equals("")) {
        } else {
            Date forumStartDttm = DateTimeUtil.stringToDate("yyyyMMddHHmmss", vo.getForumStartDttm());
            vo.setForumStartDttm(DateTimeUtil.dateToString(forumStartDttm, "yyyy-MM-dd HH:mm"));
        }
        //토론종료일시
        if(vo.getForumEndDttm() == null || vo.getForumEndDttm().equals("")) {
        } else {
            Date forumEndDttm = DateTimeUtil.stringToDate("yyyyMMddHHmmss", vo.getForumEndDttm());
            vo.setForumEndDttm(DateTimeUtil.dateToString(forumEndDttm, "yyyy-MM-dd HH:mm"));
        }
        return vo;
    }

    /***************************************************** 
     * 토론 참여 사용자 리스트 가져오기 ajax
     * @param ForumJoinUserVO
     * @return ProcessResultVO<ForumJoinUserVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/forumJoinUserList.do")
    @ResponseBody
    public ProcessResultVO<ForumJoinUserVO> forumJoinUserList(ForumJoinUserVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<ForumJoinUserVO> resultVO = new ProcessResultVO<>();
        try {
            resultVO = forumJoinUserService.listPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    /***************************************************** 
     * 토론 참여자 성적 변경 ajax
     * @param ExamStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateForumJoinUserScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateForumJoinUserScore(ForumJoinUserVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String teamCtgrCd = request.getParameter("teamCtgrCd");

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setTeamCd(teamCtgrCd);

            forumJoinUserService.updateForumJoinUserScore(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    /***************************************************** 
     * 토론 참여자 글자수로 점수 주기(ajax)
     * @param ExamStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateForumJoinUserLenScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateForumJoinUserLenScore(ForumJoinUserVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String teamCtgrCd = request.getParameter("teamCtgrCd");

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setTeamCd(teamCtgrCd);

            forumJoinUserService.updateForumJoinUserLenScore(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }
        return resultVO;
    }

    /***************************************************** 
     * 토론 성적평가 엑셀 다운로드
     * @param ForumJoinUserVO
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/forumScoreExcelDown.do")
    public String forumScoreExcelDown(ForumJoinUserVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        vo.setPagingYn("N");
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "성적평가리스트");
        map.put("sheetName", "성적평가리스트");
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", forumJoinUserService.listPaging(vo).getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("outFileName", "성적평가리스트_" + date.format(today));
        modelMap.put("workbook", excelUtilPoi.simpleBigGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    // 상호평가 토론방 리스트
    @RequestMapping(value="/evalForumBbsViewList.do")
    public String evalForumBbsViewList(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        request.setAttribute("tab", request.getParameter("tab"));

        String crsCreCd = forumVO.getCrsCreCd();

        String stdList = forumVO.getStdList();

        /*토론 게시글*/
        ForumAtclVO forumAtclVO = new ForumAtclVO();

        String rltnCd = request.getParameter("rltnCd");
        if(rltnCd != null) {
            forumAtclVO.setForumCd(rltnCd);
            forumVO.setForumCd(rltnCd);
        } else {
            forumAtclVO.setForumCd(forumVO.getForumCd());
        }

        forumAtclVO.setSearchKey(forumVO.getSearchKey());
        forumAtclVO.setSearchValue(forumVO.getSearchValue());
        forumAtclVO.setPageIndex(forumVO.getPageIndex());
        //int listScale = 2; //forumAtclVO.getListScale()
        forumAtclVO.setListScale(forumVO.getListScale());
        forumAtclVO.setStdList(stdList);
        forumAtclVO.setCrsCreCd(crsCreCd);

        ProcessResultVO<ForumAtclVO> resultList = forumAtclService.listPageing(forumAtclVO);

        request.setAttribute("forumAtclList", resultList.getReturnList());
        request.setAttribute("pageInfo", resultList.getPageInfo());
        request.setAttribute("forumVo", forumVO);
        request.setAttribute("konanCopyScoreUrl", CommConst.KONAN_COPY_SCORE_URL);

        return "forum/lect/forum_bbs_view_eval";
    }

    // 토론 성적평가 > 피드백
    @RequestMapping(value="/forumScoreEvalFeedBack.do")
    public String forumScoreEvalFeedBack(ForumVO forumVO, ModelMap model, HttpServletRequest request) throws Exception {

        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_FORUM);

        /*참여자 정보*/
        if(!"EZG".equals(forumVO.getSearchMenu())) {
            ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
            forumJoinUserVO.setForumCd(forumVO.getForumCd());
            forumJoinUserVO.setStdId(forumVO.getStdId());

            forumJoinUserVO = forumJoinUserService.selectForumJoinUser(forumJoinUserVO);
            request.setAttribute("forumJoinUserVo", forumJoinUserVO);
        }

        ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
        forumFdbkVO.setForumCd(forumVO.getForumCd());
        forumFdbkVO.setStdId(forumVO.getStdId());

        if(forumVO.getTeamCd() != null || forumVO.getTeamCd() != "") {
            forumFdbkVO.setTeamCd(forumVO.getTeamCd());
        }

        /* 피드백 list */
        List<?> forumFdbkList = forumFdbkService.forumFdbkList(forumFdbkVO);

        int fdbkSize = forumFdbkList.size();

        request.setAttribute("fdbkSize", fdbkSize);
        request.setAttribute("forumFdbkList", forumFdbkList);
        request.setAttribute("forumVo", forumVO);

        return "forum/lect/forum_score_eval_feedBack";
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
    public ProcessResultVO<ForumFdbkVO> regFdbk(ForumFdbkVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));

        // 쪽지발송을 위한 목록
        String[] stdArr = vo.getStdId().split(",");

        // 피드백 저장
        ProcessResultVO<ForumFdbkVO> resultVO = forumFdbkService.insertFdbk(vo);

        // 피드백 쪽지 발송
        sendFeedbackMessage(request, vo, stdArr);

        return resultVO;
    }

    // 피드백 수정
    @RequestMapping(value="/edtFdbk.do")
    @ResponseBody
    public ProcessResultVO<ForumFdbkVO> edtFdbk(ForumFdbkVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        vo.setUserId(SessionInfo.getUserId(request));

        return forumFdbkService.updateFdbk(vo);
    }

    // 피드백 삭제
    @RequestMapping(value="/delFdbk.do")
    @ResponseBody
    public ProcessResultVO<ForumFdbkVO> delFdbk(ForumFdbkVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        vo.setUserId(SessionInfo.getUserId(request));

        return forumFdbkService.deleteFdbk(vo);
    }

    // 참여형 일괄평가
    @RequestMapping(value="/participateScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> participateScore(ForumJoinUserVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setSearchKey("JOIN");
            forumJoinUserService.participateScore(vo);
            vo.setSearchKey("NOTJOIN");
            forumJoinUserService.participateScore(vo);
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
    public ProcessResultVO<DefaultVO> setScoreRatio(ForumJoinUserVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String teamCtgrCd = request.getParameter("teamCtgrCd");

        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setTeamCd(teamCtgrCd);
            vo.setUserId(userId);

            forumJoinUserService.setScoreRatio(vo);

            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }

    // 토론현황보기
    @RequestMapping(value="/forumChartViewPop.do")
    public String forumChartViewPop(ForumVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        // 성적분포현황차트
        ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
        forumJoinUserVO.setForumCd(vo.getForumCd());

        List<?> forumJoinUserList = forumJoinUserService.forumJoinUserList(forumJoinUserVO);
        int minScore = 0;
        int maxScore = 0;
        int totalScore = 0;
        int score = 0;
        int avgScore = 0;

        if(forumJoinUserList.size() > 0) {
            for(int i = 0; i < forumJoinUserList.size(); i++) {
                EgovMap egovMap = (EgovMap) forumJoinUserList.get(i);
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
            avgScore = totalScore / forumJoinUserList.size();
        }

        request.setAttribute("minScore", minScore);
        request.setAttribute("maxScore", maxScore);
        request.setAttribute("avgScore", avgScore);

        // 찬반현황 차트용
        vo.setOrgId(orgId);
        vo = forumService.selectForum(vo);
        vo.setCrsCreCd(crsCreCd);

        request.setAttribute("forumVo", vo);

        return "forum/popup/forum_chart_view";
    }


    // 피드백 쪽지 발송
    private void sendFeedbackMessage(HttpServletRequest request, ForumFdbkVO vo, String[] stdNoArr) throws Exception {
        // 쪽지발송 처리
        if("Y".equals(CommConst.FEEDBACK_MESSAGE_SEND_YN)) {
            String orgId = SessionInfo.getOrgId(request);

            // 과목정보
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(vo.getCrsCreCd());
            creCrsVO = crecrsService.selectCreCrs(creCrsVO);

            // 토론정보
            ForumVO forumVO = new ForumVO();
            forumVO.setForumCd(vo.getForumCd());
            forumVO = forumService.selectForum(forumVO);

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
                String msgCtnt = "<b>[" + creCrsVO.getCrsCreNm() + "] 과목, [" + forumVO.getForumTitle() + "] 교수님 피드백입니다.</b><br>";
                msgCtnt += vo.getFdbkCts();

                ErpMessageMsgVO erpMessageMsgVO = new ErpMessageMsgVO();
                erpMessageMsgVO.setUsrUserInfoList(listUserRecvInfo);
                erpMessageMsgVO.setCtnt(msgCtnt);
                erpMessageMsgVO.setCrsCreCd(vo.getCrsCreCd());

                // 쪽지발송 저장
                erpService.insertSysMessageMsg(request, erpMessageMsgVO, "토론 피드백 쪽지 발송");
            }
        }
    }

    /*****************************************************
     * 상호평가 내역 보기 팝업
     * @param  ForumMutVO
     * @return "forum/popup/forum_mut_eval_view_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/mutEvalViewPop.do")
    public String mutEvalViewPop(ForumMutVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        model.addAttribute("vo", vo);

        return "forum/popup/forum_mut_eval_view_pop";
    }

    // 상호평가 목록
    @RequestMapping(value="/forumMutList.do")
    @ResponseBody
    public ProcessResultVO<ForumMutVO> forumMutList(ForumMutVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ForumMutVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);

        try {
            vo.setOrgId(orgId);
            List<ForumMutVO> list = forumMutService.selectForumMutResultList(vo);

            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("forum.common.error"); // 오류가 발생했습니다!
        }

        return resultVO;
    }
}
