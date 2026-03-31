package knou.lms.bbs.web;

import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.FileUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.bbs.service.BbsAtclService;
import knou.lms.bbs.service.BbsCmntService;
import knou.lms.bbs.service.BbsInfoService;
import knou.lms.bbs.service.BbsViewService;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.bbs.vo.BbsCmntVO;
import knou.lms.bbs.vo.BbsInfoVO;
import knou.lms.bbs.vo.BbsVO;
import knou.lms.bbs.vo.BbsViewVO;
import knou.lms.bbs.web.util.BbsAuthUtil;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;

@Controller
@RequestMapping(value = "/bbs/bbsMgr")
public class BbsMgrController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(BbsMgrController.class);
    private static final String TEMPLATE_URL = "bbsMgr";

    @Resource(name = "bbsInfoService")
    private BbsInfoService bbsInfoService;

    @Resource(name = "bbsAtclService")
    private BbsAtclService bbsAtclService;

    @Resource(name = "orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name = "termService")
    private TermService termService;

    @Resource(name = "crecrsService")
    private CrecrsService crecrsService;

    @Resource(name = "bbsCmntService")
    private BbsCmntService bbsCmntService;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name = "bbsViewService")
    private BbsViewService bbsViewService;

    /** 게시판 START **/

    /*****************************************************
     * 게시글 목록 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/atcl_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/atclList.do")
    public String atclListForm(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        String orgId = SessionInfo.getOrgId(request);
        String bbsId = vo.getBbsId();
        String langCd = SessionInfo.getLocaleKey(request);

        String atclWriteAuth = "N"; // 글쓰기 권한

        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        if(ValidationUtils.isEmpty(bbsId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setBbsId(bbsId);
        bbsInfoVO.setLangCd(langCd);
        bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
        bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

        if(bbsInfoVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        // 글쓰기 권한 체크
        atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsInfoVO);

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);

        model.addAttribute("defaultYear", termVO.getHaksaYear());
        model.addAttribute("defaultTerm", termVO.getHaksaTerm());
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));

        model.addAttribute("bbsInfoVO", bbsInfoVO);
        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("vo", vo);
        model.addAttribute("templateUrl", "bbsMgr");

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

//        return "bbs/atcl_list";
        return "bbs/atcl_list_sample";
    }

    /*****************************************************
     * 게시글 보기 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/atcl_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/atclView.do")
    public String atclViewForm(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        boolean isVirtualLogin = SessionInfo.isVirtualLogin(request);

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String userAcntId = SessionInfo.getUserRprsId(request);
        String bbsId = vo.getBbsId();
        String atclId   = request.getParameter("atclId");
//        String bbsCd;
        String langCd = SessionInfo.getLocaleKey(request);

        String atclEditAuth = "N";      // 글수정 권한
        String atclDeleteAuth  = "N";   // 글삭제 권한
        String answerWriteAuth = "N";   // 답글쓰기 권한
        String commentWriteAuth = "N";  // 댓글쓰기 권한

        // 파라미터 체크
        if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setBbsId(bbsId);
        bbsInfoVO.setLangCd(langCd);
        bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
        bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

        if(bbsInfoVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        // 게시글 조회
        BbsAtclVO bbsAtclVO = new BbsAtclVO();
        bbsAtclVO.setOrgId(orgId);
        bbsAtclVO.setBbsId(bbsId);
        bbsAtclVO.setAtclId(atclId);
        bbsAtclVO.setVwerId(userAcntId); // 조회자
        bbsAtclVO.setLangCd(langCd);
        bbsAtclVO = bbsAtclService.viewBbsAtcl(bbsAtclVO);

        if(bbsAtclVO  == null) {
            // 게시글 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
        }

        // 조회 정보 등록
        if(!isVirtualLogin) {
            try {
                BbsViewVO bbsViewVO = new BbsViewVO();
                bbsViewVO.setOrgId(orgId);
                bbsViewVO.setAtclId(atclId);
                bbsViewVO.setUserId(userAcntId);
                BbsViewVO bbsViewInfo = bbsViewService.selectBbsView(bbsViewVO);

                if(bbsViewInfo == null) {
                    bbsViewService.insertBbsView(bbsViewVO);
                } else {
                    bbsViewService.updateBbsView(bbsViewVO);
                }

                int cnt = bbsViewService.countBbsView(bbsViewVO);

                BbsAtclVO updateHitVO = new BbsAtclVO();
                updateHitVO.setAtclId(atclId);
                updateHitVO.setInqCnt(cnt);
                //bbsAtclService.updateBbsAtclHits(updateHitVO);

                // 답글이 있는경우 답글 viewer 세팅
                int answerAtclCnt = bbsAtclVO.getAnswerAtclCnt();

                if(answerAtclCnt > 0) {
                    BbsAtclVO bbsAtclVO2 = new BbsAtclVO();
                    bbsAtclVO2.setOrgId(orgId);
                    bbsAtclVO2.setBbsId(vo.getBbsId());
                    bbsAtclVO2.setUpAtclId(bbsAtclVO.getAtclId());

                    List<BbsAtclVO> listAnswerAtcl = bbsAtclService.listBbsAtclAnswer(bbsAtclVO2);

                    for(BbsAtclVO answerAtclVO : listAnswerAtcl) {
                        bbsViewVO = new BbsViewVO();
                        bbsViewVO.setAtclId(answerAtclVO.getAtclId());
                        bbsViewVO.setUserId(userAcntId);

                        bbsViewInfo = bbsViewService.selectBbsView(bbsViewVO);

                        if(bbsViewInfo == null) {
                            bbsViewService.insertBbsView(bbsViewVO);
                        } else {
                            bbsViewService.updateBbsView(bbsViewVO);
                        }
                    }
                }
            } catch (Exception e) {
                LOGGER.debug("e: ", e);
            }
        }

        // 글수정, 삭제, 답글, 댓글쓰기 권한체크
        atclEditAuth = BbsAuthUtil.getAtclEditAuth(request, bbsInfoVO, bbsAtclVO);
        //atclDeleteAuth = BbsAuthUtil.getAtclDeleteAuth(request, bbsInfoVO, bbsAtclVO);
        answerWriteAuth = BbsAuthUtil.getAnswerAtclWriteAuth(request, bbsInfoVO);
        commentWriteAuth = BbsAuthUtil.getCommentWriteAuth(request, bbsInfoVO, bbsAtclVO);

        // 1:1 상담일경우 담당교수만 답변가능
        if("Y".equals(answerWriteAuth) && bbsInfoVO.getBbsId().equals("SECRET") && !userId.equals(StringUtil.nvl(bbsAtclVO.getDscsnProfId()))) {
            answerWriteAuth = "N";
        }

        model.addAttribute("bbsInfoVO", bbsInfoVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("atclEditAuth", atclEditAuth);
        model.addAttribute("atclDeleteAuth", atclDeleteAuth);
        model.addAttribute("answerWriteAuth", answerWriteAuth);
        model.addAttribute("commentWriteAuth", commentWriteAuth);
        model.addAttribute("vo", vo);

        model.addAttribute("templateUrl", "bbsMgr");

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("userId", userId);

        return "bbs/atcl_view";
    }

    /*****************************************************
     * 게시글 쓰기 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/atcl_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/atclWrite.do")
    public String atclWriteForm(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        String bbsId = vo.getBbsId();
        String langCd = SessionInfo.getLocaleKey(request);

        String atclWriteAuth = "Y"; // 글쓰기 권한

        // 게시판 정보 조회
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setBbsId(bbsId);
        bbsInfoVO.setLangCd(langCd);
        bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
        bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

        if(bbsInfoVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        // 글쓰기 권한 체크
        atclWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsInfoVO);

        TermVO termVO = new TermVO();
        termVO.setOrgId(SessionInfo.getOrgId(request));
        termVO = termService.selectCurrentTerm(termVO);
        model.addAttribute("termVO", termVO);
        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        model.addAttribute("bbsInfoVO", bbsInfoVO);
        model.addAttribute("atclWriteAuth", atclWriteAuth);
        model.addAttribute("vo", vo);

        model.addAttribute("templateUrl", "bbsMgr");

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "bbs/atcl_write";
    }

    /*****************************************************
     * 게시글 수정 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/atcl_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/atclEdit.do")
    public String atclEditForm(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        String orgId = SessionInfo.getOrgId(request);
        String bbsId = vo.getBbsId();
        String atclId   = request.getParameter("atclId");
        String langCd = SessionInfo.getLocaleKey(request);

        String atclEditAuth = "N"; // 글수정 권한

        // 게시판 정보 조회
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setBbsId(bbsId);
        bbsInfoVO.setLangCd(langCd);
        bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
        bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

        if(bbsInfoVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        // 게시글 조회
        BbsAtclVO bbsAtclVO = new BbsAtclVO();
        bbsAtclVO.setOrgId(orgId);
        bbsAtclVO.setBbsId(bbsId);
        bbsAtclVO.setAtclId(atclId);
        bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

        if(bbsAtclVO == null) {
            // 게시글 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
        }

        atclEditAuth = BbsAuthUtil.getAtclEditAuth(request, bbsInfoVO, bbsAtclVO);

        // 첨부 파일 조회
        if(bbsAtclVO.getAtchFileCnt() > 0) {
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("BBS");
            fileVO.setFileBindDataSn(bbsAtclVO.getAtclId());
            ProcessResultVO<FileVO> resultVO = (ProcessResultVO<FileVO>) sysFileService.list(fileVO);
            List<FileVO> fileList = resultVO.getReturnList();
            bbsAtclVO.setFileList(fileList);
        }

        model.addAttribute("yearList", DateTimeUtil.getYearList(10, "mix"));
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        model.addAttribute("univGbnList", orgCodeService.selectOrgCodeList("UNIV_GBN"));

        model.addAttribute("bbsInfoVO", bbsInfoVO);
        model.addAttribute("bbsAtclVO", bbsAtclVO);
        model.addAttribute("atclEditAuth", atclEditAuth);
        model.addAttribute("vo", vo);

        model.addAttribute("templateUrl", "bbsMgr");

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "bbs/atcl_write";
    }

    /*****************************************************
     * 게시글 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listAtcl.do")
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> listAtcl(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        String orgId  = SessionInfo.getOrgId(request);
        String bbsIds = request.getParameter("bbsIds"); // 게시판 id ',' 구분자
        String langCd = SessionInfo.getLocaleKey(request);

        vo.setOrgId(orgId);
        vo.setLangCd(langCd);

        try {

            // 게시판 id ',' 구분자로 들어온 경우
            if(ValidationUtils.isNotEmpty(bbsIds)) {
                List<String> bbsIdList = Arrays.asList(bbsIds.split(","));
                vo.setBbsIdList(bbsIdList);
                vo.setBbsId(null);
            }

            vo.setCrsCreCd(null);
            //vo.setViewerNo(userId);

            resultVO = bbsAtclService.listBbsAtclPaging(vo);
            resultVO.setResult(1);
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 게시글 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addAtcl.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> addAtcl(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        String orgId        = SessionInfo.getOrgId(request);
        String userId       = SessionInfo.getUserId(request);
        String bbsId        = vo.getBbsId();
        String parAtclId    = vo.getUpAtclId();

        String uploadFiles  = vo.getUploadFiles();
        String uploadPath   = vo.getUploadPath();

        vo.setOrgId(orgId);
        vo.setRgtrId(userId);

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 답글인 경우
            if(ValidationUtils.isNotEmpty(parAtclId)) {
                // 답글 쓰기권한 체크
                String answerWriteAuth = BbsAuthUtil.getAnswerAtclWriteAuth(request, bbsInfoVO);

                if(!"Y".equals(answerWriteAuth)) {
                    // 접근 권한이 없습니다.
                    throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
                }

                // 게시글 정보 조회
                BbsAtclVO bbsAtclVO = new BbsAtclVO();
                bbsAtclVO.setOrgId(orgId);
                bbsAtclVO.setBbsId(bbsId);
                bbsAtclVO.setAtclId(parAtclId);
                bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

                if(bbsAtclVO == null) {
                    // 게시글 정보를 찾을 수 없습니다.
                    throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
                }

                // 부모글 타이틀 세팅
                vo.setAtclTtl("RE : " + bbsAtclVO.getAtclTtl());
            } else {
                String getWriteAuth = BbsAuthUtil.getAtclWriteAuth(request, bbsInfoVO);

                if(!"Y".equals(getWriteAuth)) {
                    // 접근 권한이 없습니다.
                    throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
                }
            }

            vo.setBbsId(bbsInfoVO.getBbsId());
            vo.setCrsCreCd(null);

            bbsAtclService.insertBbsAtcl(vo);

            resultVO.setReturnVO(vo);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());

            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!

            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }

        return resultVO;
    }

    /*****************************************************
     * 게시글 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editAtcl.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> editAtcl(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsId = vo.getBbsId();
        String atclId   = vo.getAtclId();

        String uploadFiles  = vo.getUploadFiles();
        String uploadPath   = vo.getUploadPath();

        vo.setOrgId(orgId);
        vo.setMdfrId(userId);

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시글 정보 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            // 글수정 권한체크
            String atclEditAuth = BbsAuthUtil.getAtclEditAuth(request, bbsInfoVO, bbsAtclVO);

            if(!"Y".equals(atclEditAuth)) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            vo.setBbsId(bbsInfoVO.getBbsId());
            vo.setCrsCreCd(null);

            bbsAtclService.updateBbsAtcl(vo);

            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());

            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!

            if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }
        }

        return resultVO;
    }

    /*****************************************************
     * 게시글 삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/removeAtcl.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> removeAtcl(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsId = vo.getBbsId();
        String atclId   = vo.getAtclId();

        vo.setOrgId(orgId);
        vo.setMdfrId(userId);

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시글 정보 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            //String atclDeleteAuth = BbsAuthUtil.getAtclDeleteAuth(request, bbsInfoVO, bbsAtclVO);

			/*
			 * if(!"Y".equals(atclDeleteAuth)) { // 접근 권한이 없습니다. throw new
			 * BadRequestUrlException(getMessage("bbs.error.no_auth")); }
			 */

            bbsAtclService.deleteBbsAtcl(vo);

            resultVO.setResult(1);
            resultVO.setMessage(getMessage("bbs.alert.success_delete")); // 정상적으로 삭제되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 게시글 좋아요 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editGoodCnt.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> editGoodCnt(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        String orgId  = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsId  = vo.getBbsId();
        String atclId = vo.getAtclId();

        vo.setRgtrId(userId);

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 좋아요 사용여부 체크
            if(!"Y".equals(bbsInfoVO.getGoodUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 정보 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            // 좋아요 사용여부 체크
            if(!"Y".equals(bbsAtclVO.getGoodUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 삭제여부 체크
            if(!"N".equals(bbsAtclVO.getDelYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 전체 좋아요 수
            bbsAtclVO = bbsAtclService.updateBbsAtclGoodCnt(vo);

            resultVO.setReturnVO(bbsAtclVO);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 답글 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listAnswerAtcl.do")
    @ResponseBody
    public ProcessResultVO<BbsAtclVO> listAnswerAtcl(BbsAtclVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        String orgId        = SessionInfo.getOrgId(request);
        String bbsId        = vo.getBbsId();
        String parAtclId    = vo.getUpAtclId();

        vo.setOrgId(orgId);

        try {
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(parAtclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 답글 사용여부 체크
            if(!"Y".equals(bbsInfoVO.getAnsrUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 정보 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(parAtclId);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            // 게시글 삭제여부 체크
            if(!"N".equals(bbsAtclVO.getDelYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            List<BbsAtclVO> list = bbsAtclService.listBbsAtclAnswer(vo);

            bbsAtclService.listBbsAtclAnswer(vo);
            resultVO.setReturnList(list);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /** 게시판 END **/


    /** 댓글 START **/

    /*****************************************************
     * 댓글 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/cmntList.do")
    @ResponseBody
    public ProcessResultVO<BbsCmntVO> cmntList(BbsCmntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsId = request.getParameter("bbsId");
        String atclId   = vo.getAtclId();

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시판 댓글 사용여부 체크
            /*
            if(!"Y".equals(bbsInfoVO.getCmntUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }
            */

            // 게시글 정보 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            // 게시글 댓글 사용여부 체크
            if(!"Y".equals(bbsAtclVO.getCmntUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 삭제여부 체크
            if(!"N".equals(bbsAtclVO.getDelYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            vo.setViewerNo(userId);

            resultVO = bbsCmntService.listBbsCmntPagingWithAuth(request, bbsInfoVO, bbsAtclVO, vo);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 댓글 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/cmntInfo.do")
    @ResponseBody
    public ProcessResultVO<BbsCmntVO> cmntInfo(BbsCmntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String bbsId = request.getParameter("bbsId");
        String atclId   = vo.getAtclId();
        String cmntId   = vo.getCmntId();

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId) || ValidationUtils.isEmpty(cmntId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
            bbsInfoVO.setUseYn("Y");
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시판 댓글 사용여부 체크
            /*
            if(!"Y".equals(bbsInfoVO.getCmntUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }
            */

            // 게시글 정보 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            // 게시글 댓글 사용여부 체크
            if(!"Y".equals(bbsAtclVO.getCmntUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 삭제여부 체크
            if(!"N".equals(bbsAtclVO.getDelYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            BbsCmntVO bbsCmntVO = bbsCmntService.selectBbsCmnt(vo);

            resultVO.setReturnVO(bbsCmntVO);
            resultVO.setResult(1);
        } catch(MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 댓글 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addCmnt.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsCmntVO> addCmnt(BbsCmntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        String userId       = SessionInfo.getUserId(request);
        String orgId        = SessionInfo.getOrgId(request);
        String bbsId        = request.getParameter("bbsId");
        String atclId       = vo.getAtclId();
        String langCd       = SessionInfo.getLocaleKey(request);

        String commentWriteAuth = "N";

        vo.setRgtrId(userId);

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setLangCd(langCd);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시판 댓글 사용여부 체크
            if(!"Y".equals(bbsInfoVO.getCmntUseYn())) {
                // 접근 권한이 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.no_auth"));
            }

            // 게시글 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO.setLangCd(langCd);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO  == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            // 댓글 쓰기권한 체크
            commentWriteAuth = BbsAuthUtil.getCommentWriteAuth(request, bbsInfoVO, bbsAtclVO);

            if(!"Y".equals(commentWriteAuth)) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            bbsCmntService.insertBbsCmnt(vo);

            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 댓글 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editCmnt.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsCmntVO> editCmnt(BbsCmntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsId = request.getParameter("bbsId");
        String atclId   = vo.getAtclId();
        String cmntId   = vo.getCmntId();
        String langCd = SessionInfo.getLocaleKey(request);

        String commentEditAuth = "N";

        vo.setMdfrId(userId);

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId) || ValidationUtils.isEmpty(cmntId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setLangCd(langCd);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }


            // 게시글 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO.setLangCd(langCd);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO  == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            BbsCmntVO bbsCmntVO = new BbsCmntVO();
            bbsCmntVO.setAtclId(atclId);
            bbsCmntVO.setCmntId(cmntId);
            bbsCmntVO = bbsCmntService.selectBbsCmnt(bbsCmntVO);

            if(bbsCmntVO == null) {
                // 댓글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_comment"));
            }

            // 댓글 수정권한 체크
            commentEditAuth = BbsAuthUtil.getCommentEditAuth(request, bbsInfoVO, bbsAtclVO, bbsCmntVO);

            if(!"Y".equals(commentEditAuth)) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            bbsCmntService.updateBbsCmnt(vo);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 댓글 삭제
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/removeCmnt.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsCmntVO> removeCmnt(BbsCmntVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsCmntVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String bbsId = request.getParameter("bbsId");
        String atclId   = vo.getAtclId();
        String cmntId   = vo.getCmntId();
        String langCd = SessionInfo.getLocaleKey(request);

        String commentDeleteAuth = "N";

        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(atclId) || ValidationUtils.isEmpty(cmntId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            // 게시판 정보 조회
            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setLangCd(langCd);
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            // 게시글 조회
            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO = bbsAtclService.selectBbsAtcl(bbsAtclVO);

            if(bbsAtclVO  == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_atcl"));
            }

            BbsCmntVO bbsCmntVO = new BbsCmntVO();
            bbsCmntVO.setAtclId(atclId);
            bbsCmntVO.setCmntId(cmntId);
            bbsCmntVO = bbsCmntService.selectBbsCmnt(bbsCmntVO);

            if(bbsCmntVO == null) {
                // 댓글 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_comment"));
            }

            // 댓글 삭제권한 체크
            commentDeleteAuth = BbsAuthUtil.getCommentDeleteAuth(request, bbsInfoVO, bbsAtclVO, bbsCmntVO);

            if(!"Y".equals(commentDeleteAuth)) {
                // 접근 권한이 없습니다.
                throw new AccessDeniedException(getMessage("bbs.error.no_auth"));
            }

            bbsCmntService.updateBbsCmntDelY(vo);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("bbs.alert.success_delete")); // 정상적으로 삭제되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /** 댓글 END **/


    /** 게시판 관리 START **/

    /*****************************************************
     * 게시판 관리 목록 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/mgr/info_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/infoList.do")
    public String infoListForm(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        model.addAttribute("vo", vo);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "bbs/mgr/info_list";
    }

    /*****************************************************
     * 게시판 관리 목록 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/listInfo.do")
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> listInfo(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String langCd = SessionInfo.getLocaleKey(request);

        vo.setOrgId(orgId);
        vo.setLangCd(langCd);

        try {
            vo.setSysUseYn("Y"); // 시스템 게시판

            resultVO = bbsInfoService.listBbsInfoPaging(vo);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 게시판 관리 등록 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/mgr/info_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/infoWrite.do")
    public String infoWriteForm(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        List<OrgCodeVO> langCdList = orgCodeService.listCode("LANG_CD", true);
        List<OrgCodeVO> bbsCdList = orgCodeService.listCode("BBS_CD", true);
        List<OrgCodeVO> bbsTypeCdList = orgCodeService.listCode("BBS_TYPE_CD", true);

        model.addAttribute("langCdList", langCdList);
        model.addAttribute("bbsCdList", bbsCdList);
        model.addAttribute("bbsTypeCdList", bbsTypeCdList);
        model.addAttribute("bbsInfoVO", null);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "bbs/mgr/info_write";
    }

    /*****************************************************
     * 게시판 관리 수정 이동
     * @param vo
     * @param model
     * @param request
     * @return "bbs/mgr/info_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/infoEdit.do")
    public String infoEditForm(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        // logUserConnService.saveUserConnState(request, CommConst.CONN_BBS);

        String orgId = SessionInfo.getOrgId(request);
        String bbsId = vo.getBbsId();
        String langCd = SessionInfo.getLocaleKey(request);

        if(ValidationUtils.isEmpty(bbsId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }

        // 게시판 정보 조회
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setBbsId(bbsId);
        bbsInfoVO.setLangCd(langCd);
        bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
        bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

        if(bbsInfoVO == null) {
            // 게시판 정보를 찾을 수 없습니다.
            throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
        }

        List<OrgCodeVO> langCdList = orgCodeService.listCode("LANG_CD", true);
        List<OrgCodeVO> bbsCdList = orgCodeService.listCode("BBS_CD", true);
        List<OrgCodeVO> bbsTypeCdList = orgCodeService.listCode("BBS_TYPE_CD", true);

        model.addAttribute("langCdList", langCdList);
        model.addAttribute("bbsCdList", bbsCdList);
        model.addAttribute("bbsTypeCdList", bbsTypeCdList);
        model.addAttribute("bbsInfoVO", bbsInfoVO);
        model.addAttribute("vo", vo);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "bbs/mgr/info_write";
    }

    /*****************************************************
     * 게시판 관리 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addInfo.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> addInfo(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsCd    = vo.getBbsId();

        vo.setOrgId(orgId);
        vo.setRgtrId(userId);

        try {
            vo.setSysUseYn("Y");        // 시스템 게시판
            vo.setSysDefaultYn("N");    // 시스템 기본 제공 여부

            vo.setCmntUseYn("Y");       // 댓글
            vo.setLockUseYn("Y");       // 비밀글 사용여부

            if("PDS".equals(bbsCd)) {
                vo.setGoodUseYn("Y");   // 좋아요
            } else {
                vo.setGoodUseYn("N");   // 좋아요
            }

            bbsInfoService.insertBbsInfo(vo);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 게시판 관리 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editInfo.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> editInfo(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsId = vo.getBbsId();

        vo.setOrgId(orgId);
        vo.setMdfrId(userId);

        try {
            if(ValidationUtils.isEmpty(bbsId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            bbsInfoService.updateBbsInfo(vo);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 게시판 관리 사용여부 수정
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/editUseYn.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> editUseYn(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String bbsId = vo.getBbsId();
        String useYn = vo.getUseYn();

        vo.setMdfrId(userId);

        try {
            if(ValidationUtils.isEmpty(bbsId) || ValidationUtils.isEmpty(useYn)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            BbsInfoVO bbsInfoVO = new BbsInfoVO();
            bbsInfoVO.setOrgId(orgId);
            bbsInfoVO.setBbsId(bbsId);
            bbsInfoVO.setSysUseYn("Y"); // 시스템 게시판
            bbsInfoVO = bbsInfoService.selectBbsInfo(bbsInfoVO);

            if(bbsInfoVO == null) {
                // 게시판 정보를 찾을 수 없습니다.
                throw new BadRequestUrlException(getMessage("bbs.error.not_exists_bbs"));
            }

            bbsInfoService.updateBbsInfoUseYn(vo);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }

        return resultVO;
    }

    /*****************************************************
     * 팀 게시판 등록
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/addTeamBbsInfo.do", method = RequestMethod.POST)
    @ResponseBody
    public ProcessResultVO<BbsInfoVO> addTeamBbsInfo(BbsInfoVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<BbsInfoVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String teamCd = vo.getTeamCd();

        vo.setOrgId(orgId);
        vo.setRgtrId(userId);

        try {
            if(ValidationUtils.isEmpty(teamCd)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(getMessage("common.system.error"));
            }

            bbsInfoService.insertTeamBbs(vo);
            resultVO.setResult(1);
            resultVO.setMessage(getMessage("success.common.save")); // 정상적으로 저장되었습니다.
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /** 게시판 관리 END **/

}
