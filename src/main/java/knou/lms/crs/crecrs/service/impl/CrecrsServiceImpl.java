package knou.lms.crs.crecrs.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.ServiceProcessException;
import knou.framework.util.*;
import knou.lms.asmt.dao.AsmtDAO;
import knou.lms.asmt.service.AsmtProService;
import knou.lms.asmt.vo.AsmtVO;
import knou.lms.bbs.dao.BbsAtclDAO;
import knou.lms.bbs.dao.BbsInfoDAO;
import knou.lms.bbs.service.BbsAtclService;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.dao.CrecrsDAO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsTchRltnVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.crs.dao.CrsDAO;
import knou.lms.crs.crs.service.CrsService;
import knou.lms.crs.crs.vo.CrsVO;
import knou.lms.crs.crsCtgr.service.CrsCtgrService;
import knou.lms.crs.crsCtgr.vo.CrsCtgrVO;
import knou.lms.crs.term.dao.TermDAO;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.exam.service.ExamService;
import knou.lms.exam.vo.ExamVO;
import knou.lms.forum.service.ForumService;
import knou.lms.forum.vo.ForumVO;
import knou.lms.lesson.dao.*;
import knou.lms.lesson.service.LessonCntsService;
import knou.lms.lesson.vo.*;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.resh.service.ReshService;
import knou.lms.resh.vo.ReshVO;
import knou.lms.score.service.ScoreService;
import knou.lms.score.vo.ScoreVO;
import knou.lms.std.dao.StdDAO;
import knou.lms.std.vo.StdVO;
import knou.lms.subject2.vo.SubjectVO;
import knou.lms.user.dao.UsrUserInfoDAO;
import knou.lms.user.vo.UsrUserInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.dao.DataRetrievalFailureException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@Service("crecrsService")
public class CrecrsServiceImpl extends ServiceBase implements CrecrsService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CrecrsServiceImpl.class);

    /**
     * crecrsDAO
     */
    @Resource(name="crecrsDAO")
    private CrecrsDAO crecrsDAO;

    /**
     * crsDAO
     */
    @Resource(name="crsDAO")
    private CrsDAO crsDAO;

    /**
     * stdDAO
     */
    @Resource(name="stdDAO")
    private StdDAO stdDAO;

    /**
     * termDAO
     */
    @Resource(name="termDAO")
    private TermDAO termDAO;

    /**
     * crsService
     */
    @Resource(name="crsService")
    private CrsService crsService;

    /**
     * scoreService
     */
    @Resource(name="scoreService")
    private ScoreService scoreService;

    @Resource(name="lessonScheduleDAO")
    private LessonScheduleDAO lessonScheduleDAO;

    @Resource(name="lessonTimeDAO")
    private LessonTimeDAO lessonTimeDAO;

    @Resource(name="lessonCntsDAO")
    private LessonCntsDAO lessonCntsDAO;

    /**
     * orgCodeService
     */
    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name="bbsInfoDAO")
    private BbsInfoDAO bbsInfoDAO;

    @Resource(name="bbsAtclDAO")
    private BbsAtclDAO bbsAtclDAO;

    /**
     * sysFileService
     */
    @Autowired
    private SysFileService sysFileService;

    /**
     * 과목 분류 정보 service
     */
    @Autowired
    private CrsCtgrService crsCtgrService;

    @Resource(name="lessonPageDAO")
    private LessonPageDAO lessonPageDAO;

    @Resource(name="usrUserInfoDAO")
    private UsrUserInfoDAO usrUserInfoDAO;

    @Resource(name="bbsAtclService")
    private BbsAtclService bbsAtclService;

    @Resource(name="asmtProService")
    private AsmtProService asmtProService;

    @Resource(name="forumService")
    private ForumService forumService;

    @Resource(name="reshService")
    private ReshService reshService;

    @Resource(name="examService")
    private ExamService examService;

    @Resource(name="lessonCntsService")
    private LessonCntsService lessonCntsService;

    @Resource(name="lessonStudyDAO")
    private LessonStudyDAO lessonStudyDAO;

    @Resource(name="asmtDAO")
    private AsmtDAO asmtDAO;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    /**
     * 강의실 교수 세션설정
     *
     * @param request
     * @param crsCreCd
     * @return
     * @throws Exception
     */
    public void setCreCrsProfSession(HttpServletRequest request, CreCrsVO creCrsVO) throws Exception {
        if(creCrsVO != null) {
            String uri = request.getRequestURI();
            Locale locale = LocaleUtil.getLocale(request);
            // 개설과목 세션 설정값
            String termCd = creCrsVO.getTermCd();
            String creYear = creCrsVO.getCreYear();
            String creTerm = creCrsVO.getCreTerm();
            String crsCreCd = creCrsVO.getCrsCreCd();
            String crsCreNm = creCrsVO.getCrsCreNm();
            String uniCd = creCrsVO.getUniCd();
            String univGbn = creCrsVO.getUnivGbn();
            String deptNm = creCrsVO.getDeptNm();

            if("en".equals(SessionInfo.getLocaleKey(request))) {
                crsCreNm = creCrsVO.getCrsCreNmEng();
            }

            crsCreNm += " (" + creCrsVO.getDeclsNo() + messageSource.getMessage("dashboard.cor.dev_class", null, locale) + ")";

            // 이전학기 과목여부 체크
            String prevCourseYn = this.checkPrevCourseYn(crsCreCd);
            // 과목 교수자 목록 조회
            List<EgovMap> tchList = this.listCrecrsTchEgov(creCrsVO);
            boolean isTut = false;
            for(EgovMap map : tchList) {
                /* if (map.get("userId").equals(SessionInfo.getUserId(request))) { */
                if(Objects.equals(map.get("userId"), SessionInfo.getUserId(request))) {
                    if("ASSISTANT".equals(map.get("tchType"))) {
                        isTut = true;
                        // 강의실 조교 권한 세팅
                        SessionInfo.setClassUserType(request, "tut");
                        break;
                    }
                }
            }
            // 수업계획서 링크정보
            String sSmt = creCrsVO.getCreTerm().length() < 2 ? creCrsVO.getCreTerm() + "0" : creCrsVO.getCreTerm();
            String sCuriCls = creCrsVO.getDeclsNo().length() < 2 ? "0" + creCrsVO.getDeclsNo() : creCrsVO.getDeclsNo();
            String plnParam = "{\"sYear\":\"" + creCrsVO.getCreYear() + "\",\"sSmt\":\"" + sSmt + "\",\"sCuriNum\":\"" + creCrsVO.getCrsCd() + "\",\"sCuriCls\":\"" + sCuriCls + "\"}";
            String lsnPlanUrl = CommConst.LSNPLAN_POP_URL_STD + new String((Base64.getEncoder()).encode(plnParam.getBytes()));

            SessionInfo.setCurCrsYearTerm(request, creYear + creTerm);
            SessionInfo.setCrsCreCd(request, crsCreCd);
            SessionInfo.setCurCrsCreCd(request, crsCreCd);
            SessionInfo.setCurCorHome(request, "/crs/crsHomeProf.do");
            SessionInfo.setClassUserType(request, "prof");
            SessionInfo.setCrsCreNm(request, crsCreNm);
            SessionInfo.setPrevCourseYn(request, prevCourseYn);
            SessionInfo.setCurTerm(request, termCd);
            SessionInfo.setCourseUniCd(request, uniCd);
            SessionInfo.setCreDeptNm(request, deptNm);
            SessionInfo.setLessonPlanUrl(request, lsnPlanUrl);
            SessionInfo.setUnivGbn(request, univGbn);
            if(isTut) {
                SessionInfo.setClassUserType(request, "tut");
            }

            if(uri.contains("/crsHomeProf.do")) {
                SessionInfo.setCurParMenuCd(request, "");
                SessionInfo.setCurMenuCd(request, "");
            }
        }
    }

    /**
     * 강의실 학생 세션설정
     *
     * @param request
     * @param crsCreCd
     * @return
     * @throws Exception
     */
    @Override
    public void setCreCrsStuSession(HttpServletRequest request, CreCrsVO creCrsVO, StdVO stdVO) throws Exception {
        if(creCrsVO != null) {
            String uri = request.getRequestURI();
            Locale locale = LocaleUtil.getLocale(request);
            // 개설과목 세션 설정값
            String termCd = creCrsVO.getTermCd();
            String creYear = creCrsVO.getCreYear();
            String creTerm = creCrsVO.getCreTerm();
            String crsCreCd = creCrsVO.getCrsCreCd();
            String crsCreNm = creCrsVO.getCrsCreNm();
            String uniCd = creCrsVO.getUniCd();
            String univGbn = creCrsVO.getUnivGbn();
            String deptNm = creCrsVO.getDeptNm();

            if("en".equals(SessionInfo.getLocaleKey(request))) {
                crsCreNm = creCrsVO.getCrsCreNmEng();
            }

            crsCreNm += " (" + creCrsVO.getDeclsNo() + messageSource.getMessage("dashboard.cor.dev_class", null, locale) + ")";

            // 이전학기 과목여부 체크
            String prevCourseYn = this.checkPrevCourseYn(crsCreCd);

            // 수업계획서 링크정보
            String sSmt = creCrsVO.getCreTerm().length() < 2 ? creCrsVO.getCreTerm() + "0" : creCrsVO.getCreTerm();
            String sCuriCls = creCrsVO.getDeclsNo().length() < 2 ? "0" + creCrsVO.getDeclsNo() : creCrsVO.getDeclsNo();
            String plnParam = "{\"sYear\":\"" + creCrsVO.getCreYear() + "\",\"sSmt\":\"" + sSmt + "\",\"sCuriNum\":\"" + creCrsVO.getCrsCd() + "\",\"sCuriCls\":\"" + sCuriCls + "\"}";
            String lsnPlanUrl = CommConst.LSNPLAN_POP_URL_STD + new String((Base64.getEncoder()).encode(plnParam.getBytes()));

            // 개설과목 세션SET
            SessionInfo.setCurCrsYearTerm(request, creYear + creTerm);
            SessionInfo.setCrsCreCd(request, crsCreCd);
            SessionInfo.setCurCrsCreCd(request, crsCreCd);
            SessionInfo.setCurCorHome(request, "/crs/crsHomeStd.do");
            SessionInfo.setClassUserType(request, "learner");
            SessionInfo.setCrsCreNm(request, crsCreNm);
            SessionInfo.setPrevCourseYn(request, prevCourseYn);
            SessionInfo.setCurTerm(request, termCd);
            SessionInfo.setCourseUniCd(request, uniCd);
            SessionInfo.setCreDeptNm(request, deptNm);
            SessionInfo.setLessonPlanUrl(request, lsnPlanUrl);
            SessionInfo.setUnivGbn(request, univGbn);

            if(uri.contains("/crsHomeStd.do")) {
                SessionInfo.setCurParMenuCd(request, "");
                SessionInfo.setCurMenuCd(request, "");
            }

            if(stdVO != null) {
                // 학생 세션 설정값
                String auditYn = StringUtil.nvl(stdVO.getAuditYn(), "N");
                String repeatYn = StringUtil.nvl(stdVO.getRepeatYn(), "N");
                String tmswPreScYn = StringUtil.nvl(creCrsVO.getTmswPreScYn(), "N");
                String gvupYn = StringUtil.nvl(stdVO.getGvupYn(), "N");

                // 학생 세션 SET
                SessionInfo.setAuditYn(request, auditYn);
                SessionInfo.setRepeatYn(request, repeatYn);
                SessionInfo.setPreCrsYn(request, tmswPreScYn);
                SessionInfo.setGvupYn(request, gvupYn);
            }
        }
    }

    @Override
    public CreCrsVO select(CreCrsVO vo) throws Exception {
        return crecrsDAO.select(vo);
    }

    @Override
    public int count(CreCrsVO vo) throws Exception {
        return crecrsDAO.count(vo);
    }

    @Override
    public List<CreCrsVO> list(CreCrsVO vo) throws Exception {
        return crecrsDAO.list(vo);
    }

    @Override
    public ProcessResultVO<CreCrsVO> listPaging(CreCrsVO vo) throws Exception {
        ProcessResultVO<CreCrsVO> processResultVO = new ProcessResultVO<>();

        try {
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getPageScale());

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());

            int totCnt = crecrsDAO.count(vo);

            paginationInfo.setTotalRecordCount(totCnt);

            List<CreCrsVO> resultList = crecrsDAO.listPaging(vo);

            processResultVO.setReturnList(resultList);
            processResultVO.setPageInfo(paginationInfo);
            processResultVO.setResult(1);
        } catch(Exception e) {
            processResultVO.setResult(-1);
            e.printStackTrace();
            throw e;
        }

        return processResultVO;
    }

    /**
     * 강의실 드롭다운 목록
     *
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> listCrsCreDropdown(CreCrsVO vo) throws Exception {
        if("".equals(StringUtil.nvl(vo.getOrgId()))) {
            vo.setOrgId(CommConst.KNOU_ORG_ID);
        }
        return crecrsDAO.listCrsCreDropdown(vo);
    }

    @Override
    public ProcessResultVO<CreCrsVO> selectStdCreCrsList(CreCrsVO vo) throws Exception {

        String userId = "";
        vo.setGubun("PROF");
        //vo.setGubun("LEARNER");
        vo.setTermStatus("SERVICE");

        if("PROF".equals(vo.getGubun())) {
            userId = "USR000001004";
        } else {
            userId = "USR000000089";
        }
        vo.setUserId(userId);

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = crecrsDAO.selectStdCreCrsListTotCnt(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<CreCrsVO> resultList = crecrsDAO.selectStdCreCrsList(vo);

        ProcessResultVO<CreCrsVO> rList = new ProcessResultVO<CreCrsVO>();

        rList.setReturnList(resultList);
        rList.setPageInfo(paginationInfo);
        rList.setResult(1);

        return rList;
    }

    @Override
    public List<CreCrsVO> listTchCrsCreByTerm(CreCrsVO vo) throws Exception {
        return crecrsDAO.listTchCrsCreByTerm(vo);
    }

    @Override
    public List<CreCrsVO> listCreCrsDeclsNo(CreCrsVO vo) throws Exception {
        return crecrsDAO.listCreCrsDeclsNo(vo);
    }

    @Override
    public CreCrsVO selectCreCrs(CreCrsVO vo) throws Exception {
        return crecrsDAO.selectCreCrs(vo);
    }

    @Override
    public CreCrsVO infoCreCrs(CreCrsVO vo) throws Exception {
        return crecrsDAO.infoCreCrs(vo);
    }

    @Override
    public List<CreCrsVO> listCrsCreByTerm(CreCrsVO vo) throws Exception {
        return crecrsDAO.listCrsCreByTerm(vo);
    }

    @Override
    public CreCrsVO selectTchCreCrs(CreCrsVO vo) throws Exception {
        return crecrsDAO.selectTchCreCrs(vo);
    }

    /**
     * 개설 과정 전체 목록을 조회한다 : 과정 단위에서 구성
     *
     * @param CreCrsVO
     * @throws Exception
     */
    @Override
    public List<CreCrsVO> creCrsTchJoinList(CreCrsVO vo) throws Exception {

        String[] tchArray = vo.getUserId().split(",");
        vo.setSqlForeach(tchArray);

        return crecrsDAO.creCrsTchJoinList(vo);
    }

    /**
     * 메인 > 학생 > 마이페이지 리스트
     *
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    @Override
    public List<CreCrsVO> listMainMypageStd(CreCrsVO vo) throws Exception {
        return crecrsDAO.listMainMypageStd(vo);
    }

    /**
     * 과목 > 조교/교수 정보 조회
     *
     * @param CreCrsTchRltnVO
     * @return CreCrsTchRltnVO
     * @throws Exception
     */
    @Override
    public CreCrsTchRltnVO selectCrecrsTch(CreCrsTchRltnVO vo) throws Exception {

        CreCrsTchRltnVO tchVO = crecrsDAO.selectCrecrsTch(vo);
        if(tchVO != null) {
            if(tchVO.getPhtFileByte() != null && tchVO.getPhtFileByte().length > 0) {
                tchVO.setPhtFile("data:image/png;base64," + new String(Base64.getEncoder().encode(tchVO.getPhtFileByte())));
            }
        }
        return tchVO;
    }

    /**
     * 과목 > 조교/교수 목록
     *
     * @param CreCrsVO
     * @return List<CreCrsTchRltnVO>
     * @throws Exception
     */
    @Override
    public List<CreCrsTchRltnVO> listCrecrsTch(CreCrsVO vo) throws Exception {

        List<CreCrsTchRltnVO> tchList = crecrsDAO.listCrecrsTch(vo);

        for(CreCrsTchRltnVO tchVO : tchList) {
            byte[] phtFileByte = tchVO.getPhtFileByte();
            if(phtFileByte != null && phtFileByte.length > 0) {
                tchVO.setPhtFile("data:image/png;base64," + new String(Base64.getEncoder().encode(tchVO.getPhtFileByte())));
            }
        }
        return tchList;
    }

    /**
     * 과목과 동일 학과 교수 목록 페이징
     *
     * @param CreCrsTchRltnVO
     * @return ProcessResultVO<CreCrsTchRltnVO>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<CreCrsTchRltnVO> listCrecrsTchByMenuType(CreCrsTchRltnVO vo) throws Exception {

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<CreCrsTchRltnVO> tchList = crecrsDAO.listCrecrsTchByMenuType(vo);

        if(tchList.size() > 0) {
            paginationInfo.setTotalRecordCount(tchList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<CreCrsTchRltnVO> resultVO = new ProcessResultVO<CreCrsTchRltnVO>();

        resultVO.setReturnList(tchList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 과목 > 조교/교수 등록
     *
     * @param CreCrsTchRltnVO
     * @return void
     * @throws Exception
     */
    @Override
    public void insertCrecrsTch(CreCrsTchRltnVO vo) throws Exception {

        crecrsDAO.insertCrecrsTch(vo);
    }

    /**
     * 과목 > 조교/교수 수정
     *
     * @param CreCrsTchRltnVO
     * @return void
     * @throws Exception
     */
    @Override
    public void updateCrecrsTch(CreCrsTchRltnVO vo) throws Exception {
        String tchType = vo.getTchType();

        if("PROF".equals(tchType)) {
            vo.setRepYn("Y");
        } else if("ASSOCIATE".equals(tchType)) {
            vo.setRepYn("N");
            vo.setTchType("PROF");
        }

        // 조교/교수 수정
        crecrsDAO.updateCrecrsTch(vo);
    }

    /**
     * 과목 > 조교/교수 삭제
     *
     * @param CreCrsTchRltnVO
     * @return void
     * @throws Exception
     */
    @Override
    public void deleteCrecrsTch(CreCrsTchRltnVO vo) throws Exception {
        crecrsDAO.deleteCrecrsTch(vo);
    }

    /**
     * 사용자와 동일 학과 과목 목록 페이징
     *
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<CreCrsVO> listCrecrsByUserDept(CreCrsVO vo) throws Exception {

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<CreCrsVO> crecrsList = crecrsDAO.listCrecrsByUserDept(vo);

        if(crecrsList.size() > 0) {
            paginationInfo.setTotalRecordCount(crecrsList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();

        resultVO.setReturnList(crecrsList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 사용자 관리 > 사용자 상세 강의(수강) 과목 리스트
     *
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<CreCrsVO> listUserCreCrsPaging(CreCrsVO vo) throws Exception {

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<CreCrsVO> crecrsList = crecrsDAO.listUserCreCrsPaging(vo);

        if(crecrsList.size() > 0) {
            paginationInfo.setTotalRecordCount(crecrsList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();

        resultVO.setReturnList(crecrsList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 교수/조교 관리 > 개설과목 리스트
     *
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<CreCrsVO> listCreCrs(CreCrsVO vo) throws Exception {

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<CreCrsVO> crecrsList = crecrsDAO.listCreCrs(vo);

        if(crecrsList.size() > 0) {
            paginationInfo.setTotalRecordCount(crecrsList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();

        resultVO.setReturnList(crecrsList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 교수/조교 정보 > 교수/조교 목록
     *
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<CreCrsVO> listTchStatus(CreCrsVO vo) throws Exception {

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        if(ValidationUtils.isNotEmpty(vo.getCrsTypeCds())) {
            vo.setCrsTypeCdList(vo.getCrsTypeCds().split(","));
        }

        List<CreCrsVO> list = crecrsDAO.listTchStatus(vo);

        if(list.size() > 0) {
            paginationInfo.setTotalRecordCount(list.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();

        resultVO.setReturnList(list);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 강의실 상단 정보
     *
     * @param CreCrsVO
     * @return CreCrsVO
     * @throws Exception
     */
    @Override
    public CreCrsVO crsCreTopInfo(CreCrsVO vo) throws Exception {
        return crecrsDAO.crsCreTopInfo(vo);
    }

    /**
     * 메인 > 교수 > 마이페이지 리스트
     *
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    @Override
    public List<CreCrsVO> listMainMypageTch(CreCrsVO vo) throws Exception {
        return crecrsDAO.listMainMypageTch(vo);
    }

    @Override
    public ProcessResultVO<CreCrsVO> selectListPage(CreCrsVO vo) throws Exception {
        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();

        try {

            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getListScale());

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());

            List<CreCrsVO> listPaging = crecrsDAO.selectListPage(vo);

            if(listPaging.size() > 0) {
                paginationInfo.setTotalRecordCount(listPaging.get(0).getTotalCnt());
            } else {
                paginationInfo.setTotalRecordCount(0);
            }

            resultVO.setReturnList(listPaging);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }

    @Override
    public CreCrsVO selectCrsCre(CreCrsVO vo) throws Exception {

        return crecrsDAO.selectCrsCre(vo);
    }

    @Override
    public ProcessResultVO<DefaultVO> crsCreAdd(CreCrsVO vo) throws Exception {

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<DefaultVO>();
        CreCrsVO returnVO = new CreCrsVO();
        returnVO = crecrsDAO.selectCrsCre(vo);
        System.out.println("returnVO====================>" + returnVO);
        if(vo.getEnrlAplcStartDttm() != null && !vo.getEnrlAplcStartDttm().equals("")) {
            Date enrlAplcStartDttm = DateTimeUtil.stringToDate("yyyy-MM-dd", vo.getEnrlAplcStartDttm());
            vo.setEnrlAplcStartDttm(DateTimeUtil.dateToString(enrlAplcStartDttm, "yyyyMMdd"));
        }
        if(vo.getEnrlAplcEndDttm() != null && !vo.getEnrlAplcEndDttm().equals("")) {
            Date enrlAplcEndDttm = DateTimeUtil.stringToDate("yyyy-MM-dd", vo.getEnrlAplcEndDttm());
            vo.setEnrlAplcEndDttm(DateTimeUtil.dateToString(enrlAplcEndDttm, "yyyyMMdd"));
        }
        if(vo.getEnrlStartDttm() != null && !vo.getEnrlStartDttm().equals("")) {
            Date enrlStartDttm = DateTimeUtil.stringToDate("yyyy-MM-dd", vo.getEnrlStartDttm());
            vo.setEnrlStartDttm(DateTimeUtil.dateToString(enrlStartDttm, "yyyyMMdd"));
        }
        if(vo.getEnrlEndDttm() != null && !vo.getEnrlEndDttm().equals("")) {
            Date enrlEndDttm = DateTimeUtil.stringToDate("yyyy-MM-dd", vo.getEnrlEndDttm());
            vo.setEnrlEndDttm(DateTimeUtil.dateToString(enrlEndDttm, "yyyyMMdd"));
        }
        if(vo.getScoreHandlStartDttm() != null && !vo.getScoreHandlStartDttm().equals("")) {
            Date scoreHandlStartDttm = DateTimeUtil.stringToDate("yyyy-MM-dd", vo.getScoreHandlStartDttm());
            vo.setScoreHandlStartDttm(DateTimeUtil.dateToString(scoreHandlStartDttm, "yyyyMMdd"));
        }
        if(vo.getScoreHandlEndDttm() != null && !vo.getScoreHandlEndDttm().equals("")) {
            Date scoreHandlEndDttm = DateTimeUtil.stringToDate("yyyy-MM-dd", vo.getScoreHandlEndDttm());
            vo.setScoreHandlEndDttm(DateTimeUtil.dateToString(scoreHandlEndDttm, "yyyyMMdd"));
        }
        if("".equals(StringUtil.nvl(vo.getCrsYear()))) {
            vo.setCrsYear(DateTimeUtil.getYear());
        }
        if("".equals(StringUtil.nvl(vo.getCrsTerm()))) {
            vo.setCrsTerm("1");
        }
        if(returnVO != null) {
            try {
                this.update(vo);
                returnVo.setResult(1);
                returnVo.setReturnVO(vo);
            } catch(Exception e) {
                e.getMessage();
                returnVo.setResult(-1);
            }
        } else {

            try {
                this.add(vo);

                // [기관 성적 항목 설정 -> 개설과정 성적 항목 설정] 복사
                CrsVO cVO = new CrsVO();
                cVO.setCrsCd(vo.getCrsCd());
                cVO = crsService.selectCrsInfo(cVO);
                ScoreVO sVO = new ScoreVO();
                sVO.setOrgId(vo.getOrgId());
                sVO.setCrsCreCd(vo.getCrsCreCd());
                sVO.setCrsTypeCd(cVO.getCrsTypeCd());
                sVO.setRgtrId(vo.getUserId());
                sVO.setMdfrId(vo.getUserId());
                scoreService.copyScoreItemConf(sVO);

                returnVo.setResult(1);
                returnVo.setReturnVO(vo);

            } catch(Exception e) {
                e.getMessage();
                returnVo.setResult(-1);
            }
        }
        return returnVo;
    }

    @Override
    public List<CreCrsVO> listCreCrsDeclsNoByTch(CreCrsVO vo) throws Exception {
        return crecrsDAO.listCreCrsDeclsNoByTch(vo);
    }

    /**
     * 분반 중복 체크
     *
     * @param CreCrsVO
     * @return CreCrsVO
     * @throws Exception
     */
    @Override
    public CreCrsVO checkDeclsNo(CreCrsVO vo) throws Exception {
        return crecrsDAO.checkDeclsNo(vo);

    }

    @Override
    public int checkDeclsCnt(CreCrsVO vo) throws Exception {
        return crecrsDAO.checkDeclsCnt(vo);
    }

    @Override
    public List<CreCrsVO> selectListCreTch(CreCrsVO vo) throws Exception {
        return crecrsDAO.selectListCreTch(vo);
    }

    @Override
    public CreCrsVO selectTch(CreCrsVO vo) throws Exception {

        CreCrsVO creCrsVo = crecrsDAO.selectTch(vo);
        if(ValidationUtils.isNotEmpty(creCrsVo)) {
            vo = creCrsVo;
        } else {
            throw new DataRetrievalFailureException("Database Error!, There is no returned data.");
        }
        return vo;
    }

    @Override
    public void addTch(CreCrsVO vo) throws Exception {
        crecrsDAO.deleteTch(vo);

        String[] tchNoList = vo.getTchNoArr();
        String[] tchTypeList = vo.getTchTypeArr();

        for(int i = 0; i < tchNoList.length; i++) {
            vo.setUserId(tchNoList[i]);

            if(tchTypeList[i].equals("PROF")) {
                vo.setRepYn("Y");
            } else {
                if(tchTypeList[i].equals("ASSOCIATE")) {
                    tchTypeList[i] = "PROF";
                }

                vo.setRepYn("N");
            }

            vo.setTchType(tchTypeList[i]);

            crecrsDAO.insertTch(vo);
        }
    }

    @Override
    public ProcessResultVO<UsrUserInfoVO> selectUsrTchList(UsrUserInfoVO vo) throws Exception {

        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();

        try {
            List<UsrUserInfoVO> listPaging = crecrsDAO.selectUsrTchList(vo);

            resultVO.setReturnList(listPaging);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    @Override
    public ProcessResultVO<CreCrsVO> selectCreTchList(CreCrsVO vo) throws Exception {

        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();

        List<OrgCodeVO> userTypeCode = orgCodeService.selectOrgCodeList("CRE_TCH_TYPE");
        List<CreCrsVO> resultList = this.selectListCreTch(vo);

        CreCrsVO rVo = new CreCrsVO();
        rVo.setOrgList(userTypeCode);
        rVo.setCreList(resultList);

        resultVO.setReturnVO(rVo);

        return resultVO;
    }

    @Override
    public ProcessResultVO<DefaultVO> addCreStd(CreCrsVO vo) throws Exception {
        StdVO stdVo = new StdVO();

        ProcessResultVO<DefaultVO> returnVo = new ProcessResultVO<DefaultVO>();
        if("".equals(StringUtil.nvl(stdVo.getRgtrId(), ""))) {
            vo.setDeclsNo("1");
            vo.setRgtrId(vo.getUserId());
            vo.setMdfrId(vo.getUserId());
        }

        try {
            this.mergeEditStd(vo);
            returnVo.setResult(1);
            returnVo.setReturnVO(vo);
        } catch(Exception e) {
            returnVo.setResult(-1);
            e.printStackTrace();
        }
        return returnVo;
    }

    /**
     * 개설 과목 삭제 .
     *
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    @Override
    public void deleteCreCrs(CreCrsVO vo) throws Exception {
        crecrsDAO.deleteCreCrsEval(vo);
        crecrsDAO.deleteCreCrsRltn(vo);
        crecrsDAO.deleteCreCrs(vo);
    }

    @Override
    public CreCrsVO creOpenList(CreCrsVO vo) throws Exception {
        if("".equals(StringUtil.nvl(vo.getSearchValue(), ""))) {
            vo.setSearchValue(null);
        }

        CrsCtgrVO crsCtgrVo = new CrsCtgrVO();
        List<CrsCtgrVO> crsCtgrList = crsCtgrService.ctgrTree(crsCtgrVo);

        vo.setCrsTypeCd("OPEN");
        ProcessResultVO<CreCrsVO> resultList = this.coListPageing(vo);

        CreCrsVO returnVo = new CreCrsVO();

        returnVo.setCrsCtgrList(crsCtgrList);
        returnVo.setCoResultList(resultList);

        return returnVo;
    }

    @Override
    public ProcessResultVO<CreCrsVO> coListPageing(CreCrsVO vo) throws Exception {

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<CreCrsVO> crecrsList = crecrsDAO.coListPageing(vo);

        if(crecrsList.size() > 0) {
            paginationInfo.setTotalRecordCount(crecrsList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<CreCrsVO> resultVO = new ProcessResultVO<CreCrsVO>();

        resultVO.setReturnList(crecrsList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    @Override
    public int editUseYn(CreCrsVO vo) throws Exception {
        return crecrsDAO.updateUseYn(vo);
    }

    @Override
    public void deletecrsCreCo(CreCrsVO vo) throws Exception {
        crecrsDAO.deleteCreCrs(vo);
    }

    @Override
    public List<EgovMap> listCrecrsTchEgov(CreCrsVO vo) throws Exception {
        return crecrsDAO.listCrecrsTchEgov(vo);
    }

    /**
     * 개설과목관리 > 등록된 운영자 정보 리스트
     *
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    @Override
    public List<CreCrsVO> listCreTch(CreCrsVO vo) throws Exception {
        return crecrsDAO.listCreTch(vo);
    }

    /**
     * 개설 과목 한개 조회 .
     *
     * @param CreCrsVO
     * @return CreCrsVO
     * @throws Exception
     */
    @Override
    public CreCrsVO viewCrsCre(CreCrsVO vo) throws Exception {
        // ProcessResultVO<CreCrsVO> resultVo = new ProcessResultVO<CreCrsVO>();
        try {
            vo = crecrsDAO.selectCrsCre(vo);
            // resultVo.setResult(1);
            // resultVo.setReturnVO(vo);
            /*
            if(vo != null) {
                if("OPEN".equals(vo.getCrsTypeCd())) {
                    vo = sysFileService.getFile(vo , new CrsCreFileHandler());
                }
            }*/
        } catch(Exception e) {
            e.printStackTrace();
            // resultVo.setResult(-1);
            // resultVo.setMessage(e.getMessage());
        }
        return vo;
    }

    /**
     * 개설 과목 한개 수정 .
     *
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    @Override
    public void update(CreCrsVO vo) throws Exception {
        crecrsDAO.update(vo);

        /*
         * if(!"Y".equals(vo.getHaksaDataYn())) { crecrsDAO.updateEvalInfo(vo); }
         */
        // 과목 썸네일 이미지
        /*
        if("OPEN".equals(vo.getCrsTypeCd())) {
            this.saveFile(vo);
        }
        */
        String erpLessonYn = vo.getErpLessonYn();

        if("N".equals(StringUtil.nvl(erpLessonYn)) && vo.getLessonScheduleList() != null) {
            List<LessonScheduleVO> lessonScheduleList = vo.getLessonScheduleList();

            for(LessonScheduleVO lessonScheduleVO : lessonScheduleList) {
                LessonScheduleVO updateVO = new LessonScheduleVO();
                updateVO.setLessonScheduleId(lessonScheduleVO.getLessonScheduleId());
                updateVO.setLessonStartDt(lessonScheduleVO.getLessonStartDt());
                updateVO.setLessonEndDt(lessonScheduleVO.getLessonEndDt());
                updateVO.setLtDetmFrDt(lessonScheduleVO.getLtDetmFrDt());
                updateVO.setLtDetmToDt(lessonScheduleVO.getLtDetmToDt());
                updateVO.setMdfrId(vo.getMdfrId());
                lessonScheduleDAO.update(updateVO);
            }
        }
    }

    /**
     * 개설 과목 한개 등록 .
     *
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    @Override
    public void add(CreCrsVO vo) throws Exception {
        if(vo.getCrsCreCd() == null || vo.getCrsCreCd().equals("")) {
            vo.setCrsCreCd(IdGenerator.getNewId("CE"));
        }

        if(vo.getTermCd() != null || !vo.getTermCd().equals("")) {
            TermVO termVO = new TermVO();
            termVO.setOrgId(vo.getOrgId());
            termVO.setTermCd(vo.getTermCd());

            termVO = termDAO.select(termVO);
            vo.setCreYear(termVO.getHaksaYear());
            vo.setCreTerm(termVO.getHaksaTerm());
        }

        // 분반 중복체크
        int dupCnt = crecrsDAO.checkDeclsCnt(vo);

        if(dupCnt > 0) {
            // 선택한 학기와 과목에 이미 개설된 분반이 있습니다.
            throw processException("crs.alert.term.select.crecrs.double");
        }

        crecrsDAO.insert(vo);
        /* crecrsDAO.updateEvalInfo(vo); */
        crecrsDAO.insertCreCrsRltn(vo);
    }

    /**
     * 개설과목관리 > 수강생 관리 > 수강생 추가 목록
     *
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<CreCrsVO> creUserlistPageing(CreCrsVO vo) throws Exception {
        ProcessResultVO<CreCrsVO> resultList = new ProcessResultVO<>();

        /** start of paging */
        PagingInfo paginationInfo = new PagingInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        String[] creCrsArray = vo.getSearchAuthGrp().split(",");
        vo.setSqlForeach(creCrsArray);

        int totalCount = 0;
        totalCount = crecrsDAO.countCreUser(vo);

        paginationInfo.setTotalRecordCount(totalCount);

        List<CreCrsVO> creCrsListPageing = crecrsDAO.creUserlistPageing(vo);
        resultList.setResult(1);
        resultList.setReturnList(creCrsListPageing);
        resultList.setPageInfo(paginationInfo);

        return resultList;
    }

    /**
     * 개설과목관리 > 릴레이션 테이블에 수강생 수정
     *
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    @Override
    public void editStd(CreCrsVO vo) throws Exception {

        StdVO stdvo = new StdVO();
        stdvo.setCrsCreCd(vo.getCrsCreCd());
        stdvo.setEnrlStartDttm(vo.getEnrlStartDttm());
        stdvo.setEnrlEndDttm(vo.getEnrlEndDttm());
        stdvo.setEnrlAplcDttm(vo.getEnrlAplcDttm());
        stdvo.setEnrlCancelDttm(vo.getEnrlCancelDttm());
        stdvo.setOrgId(vo.getOrgId());
        stdvo.setEnrlSts(vo.getEnrlSts());
        stdvo.setRgtrId(vo.getRgtrId());
        stdvo.setMdfrId(vo.getMdfrId());

        String[] userIdList = StringUtil.split(StringUtil.nvl(vo.getUserId(), ""), ",");
        String[] stdNoList = StringUtil.split(StringUtil.nvl(vo.getStdId(), ""), ",");

        try {
            // std 릴레이션 다 삭제
            // creCrsMapper.deleteStd(vo);

            // std 테이블 한명씩 삭제
            /*
             * for(int i = 0; i < stdNoList.length; i++) { stdvo.setStdId(stdNoList[i]);
             * stdMapper.delete(stdvo); }
             */

            for(int i = 0; i < userIdList.length; i++) {
                if(!userIdList[i].isEmpty()) {

                    StdVO checkStdVo = new StdVO();

                    checkStdVo.setCrsCreCd(vo.getCrsCreCd());
                    checkStdVo.setUserId(userIdList[i]);

                    checkStdVo = stdDAO.stdSelect(checkStdVo);

                    String stdNo = "";

                    if(checkStdVo == null) {
                        stdNo = "";
                    } else {
                        stdNo = StringUtil.nvl(checkStdVo.getStdId());
                    }

                    if(stdNo == null || "".equals(stdNo)) {
                        String subString = vo.getCrsCreCd().substring(0, 2);

                        if("CE".equals(subString)) {
                            stdvo.setStdId(IdGenerator.getNewId("STD"));
                        } else {
                            stdvo.setStdId(vo.getCrsCreCd() + userIdList[i]);
                        }

                    } else {
                        stdvo.setStdId(stdNo);
                    }

                    stdvo.setUserId(userIdList[i]);
                    stdDAO.mergeStd(stdvo);
                    // stdMapper.insert(stdvo);
                    // creCrsMapper.insertStd(vo);
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * 개설과목관리 > 릴레이션 테이블에 수강생 수정(머지문)
     *
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    @Override
    public void mergeEditStd(CreCrsVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsDAO.select(creCrsVO);

        if(creCrsVO == null) {
            throw new ServiceProcessException("유효한 강의실 코드가 아닙니다.");
        }

        String crsTypeCd = creCrsVO.getCrsTypeCd();

        if("OPEN".equals(StringUtil.nvl(crsTypeCd))) {

        }

        StdVO stdVO = new StdVO();
        stdVO.setOrgId(vo.getOrgId());
        stdVO.setCrsCreCd(vo.getCrsCreCd());
        stdVO.setRgtrId(vo.getRgtrId());
        stdVO.setMdfrId(vo.getMdfrId());

        String[] userIdList = null;

        if(!"".equals(StringUtil.nvl(vo.getUserId()))) {
            userIdList = StringUtil.split(StringUtil.nvl(vo.getUserId()), ",");
        }
        Set<String> userIdSet = new HashSet<>();

        if(userIdList != null) {
            for(String userId : userIdList) {
                userIdSet.add(userId);
            }
        }

        StdVO stdVO1 = new StdVO();
        stdVO1.setOrgId(vo.getOrgId());
        stdVO1.setCrsCreCd(crsCreCd);
        List<StdVO> listStudentInfo = stdDAO.listRegistStd(stdVO1);

        List<String> deleteStdList = new ArrayList<>();

        List<StdVO> mergeUpdateList = new ArrayList<>();

        for(StdVO stdVO2 : listStudentInfo) {
            String userId = stdVO2.getUserId();
            String enrlSts = stdVO2.getEnrlSts();

            if(!"T".equals(enrlSts)) { // 학생화면보기 사용자 제외
                if(userIdSet.contains(userId)) {
                    if("D".equals(enrlSts)) {
                        StdVO stdVO3 = new StdVO();
                        stdVO3.setStdId(vo.getCrsCreCd() + userId);
                        stdVO3.setOrgId(vo.getOrgId());
                        stdVO3.setCrsCreCd(crsCreCd);
                        stdVO3.setUserId(userId);
                        stdVO3.setEnrlSts("S");
                        stdVO3.setRgtrId(vo.getMdfrId());
                        stdVO3.setMdfrId(vo.getMdfrId());
                        mergeUpdateList.add(stdVO3);
                    }
                } else {
                    // 삭제대상자 추가
                    deleteStdList.add(userId);
                }

                userIdSet.remove(userId);
            }
        }

        if(mergeUpdateList.size() > 0) {
            int batchSize = 500;
            for(int i = 0; i < mergeUpdateList.size(); i += batchSize) {
                int endIndex = Math.min(i + batchSize, mergeUpdateList.size());
                List<StdVO> sublist = mergeUpdateList.subList(i, endIndex);

                stdDAO.mergeStdBatch(sublist);
            }
        }

        if(deleteStdList.size() > 0) {
            int batchSize = 500;
            for(int i = 0; i < deleteStdList.size(); i += batchSize) {
                int endIndex = Math.min(i + batchSize, deleteStdList.size());
                List<String> sublist = deleteStdList.subList(i, endIndex);

                // 대상자 삭제
                StdVO stdVO3 = new StdVO();
                stdVO3.setCrsCreCd(crsCreCd);
                stdVO3.setSqlForeach(sublist.toArray(new String[sublist.size()]));
                stdVO3.setMdfrId(vo.getMdfrId());
                stdDAO.deleteStd(stdVO3);
            }
        }

        // 추가
        if(!userIdSet.isEmpty() && userIdSet.size() > 0) {
            List<StdVO> mergeList = new ArrayList<>();

            for(String userId : userIdList) {
                if(userIdSet.contains(userId)) {
                    StdVO stdVO2 = new StdVO();
                    stdVO2.setStdId(vo.getCrsCreCd() + userId);
                    stdVO2.setOrgId(vo.getOrgId());
                    stdVO2.setCrsCreCd(crsCreCd);
                    stdVO2.setUserId(userId);
                    stdVO2.setEnrlSts("S");
                    stdVO2.setRgtrId(vo.getMdfrId());
                    stdVO2.setMdfrId(vo.getMdfrId());
                    mergeList.add(stdVO2);
                }
            }

            int batchSize = 500;
            for(int i = 0; i < mergeList.size(); i += batchSize) {
                int endIndex = Math.min(i + batchSize, mergeList.size());
                List<StdVO> sublist = mergeList.subList(i, endIndex);

                stdDAO.mergeStdBatch(sublist);
            }
        }
    }

    @Override
    public void addStdexcelUpload(CreCrsVO vo, List<Map<String, Object>> list) throws Exception {
        String orgId = vo.getOrgId();
        String crsCreCd = vo.getCrsCreCd();

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsDAO.select(creCrsVO);

        if(creCrsVO == null) {
            throw new ServiceProcessException("유효한 강의실 코드가 아닙니다.");
        }

        String crsTypeCd = creCrsVO.getCrsTypeCd();

        // 등록된 수강생 조회
        StdVO stdVO = new StdVO();
        stdVO.setOrgId(vo.getOrgId());
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setRgtrId(vo.getRgtrId());
        stdVO.setMdfrId(vo.getMdfrId());
        List<StdVO> listStudentInfo = stdDAO.listRegistStd(stdVO);

        // 엑셀 사용자 목록
        Set<String> excelUserIdSet = new HashSet<>();
        int line = 4;  // 샘플 엑셀파일 row 시작위치
        String errPrefix;

        int batchSize = 300;
        for(int i = 0; i < list.size(); i += batchSize) {
            int endIndex = Math.min(i + batchSize, list.size());
            List<Map<String, Object>> sublist = list.subList(i, endIndex);

            // 엑셀의 사용자번호로 사용자 조회
            String[] userIdList = new String[sublist.size()];
            for(int j = 0; j < sublist.size(); j++) {
                userIdList[j] = StringUtil.nvl(sublist.get(j).get("A"));
            }

            UsrUserInfoVO usrUserInfoVO = new UsrUserInfoVO();
            usrUserInfoVO.setOrgId(orgId);
            usrUserInfoVO.setSqlForeach(userIdList);
            List<UsrUserInfoVO> listAvailableUser = usrUserInfoDAO.listAvailableUser(usrUserInfoVO);
            Set<String> userIdSet = listAvailableUser.stream().map(UsrUserInfoVO::getUserId).collect(Collectors.toCollection(HashSet::new));

            for(Map<String, Object> subMap : sublist) {
                errPrefix = line + "번 행의 ";

                String userId = StringUtil.nvl(subMap.get("A"));
                // 1.공백 체크
                Map<String, Object> emptyCheckMap = new HashMap<String, Object>();
                emptyCheckMap.put("학번", userId);

                for(Map.Entry<String, Object> elem : emptyCheckMap.entrySet()) {
                    if("".equals(StringUtil.nvl(elem.getValue()))) {
                        throw new ServiceProcessException(errPrefix + "'" + elem.getKey() + "' (은)는 필수입력항목입니다.");
                    }
                }

                // 2.학번 유효성 체크
                if(!userIdSet.contains(userId)) {
                    throw new ServiceProcessException(errPrefix + "학번" + " [" + userId + "] " + "등록된 사용자가 아닙니다.");
                }

                excelUserIdSet.add(userId);
            }

            List<StdVO> mergeUpdateList = new ArrayList<>();

            for(StdVO stdVO2 : listStudentInfo) {
                String userId = stdVO2.getUserId();
                String enrlSts = stdVO2.getEnrlSts();

                if(!"T".equals(enrlSts)) { // 학생화면보기 사용자 제외
                    if(excelUserIdSet.contains(userId)) {
                        if("D".equals(enrlSts)) {
                            StdVO stdVO3 = new StdVO();
                            stdVO3.setStdId(vo.getCrsCreCd() + userId);
                            stdVO3.setOrgId(vo.getOrgId());
                            stdVO3.setCrsCreCd(crsCreCd);
                            stdVO3.setUserId(userId);
                            stdVO3.setEnrlSts("S");
                            stdVO3.setRgtrId(vo.getMdfrId());
                            stdVO3.setMdfrId(vo.getMdfrId());
                            mergeUpdateList.add(stdVO3);
                        }

                        excelUserIdSet.remove(userId);
                    }
                }
            }

            if(mergeUpdateList.size() > 0) {
                stdDAO.mergeStdBatch(mergeUpdateList);
            }

            // 추가
            if(!excelUserIdSet.isEmpty() && excelUserIdSet.size() > 0) {
                List<String> excelUserIdList = new ArrayList<>(excelUserIdSet);
                List<StdVO> mergeList = new ArrayList<>();

                for(String userId : excelUserIdList) {
                    StdVO stdVO2 = new StdVO();
                    stdVO2.setStdId(vo.getCrsCreCd() + userId);
                    stdVO2.setOrgId(vo.getOrgId());
                    stdVO2.setCrsCreCd(crsCreCd);
                    stdVO2.setUserId(userId);
                    stdVO2.setEnrlSts("S");
                    stdVO2.setRgtrId(vo.getMdfrId());
                    stdVO2.setMdfrId(vo.getMdfrId());
                    mergeList.add(stdVO2);
                }

                stdDAO.mergeStdBatch(mergeList);
            }
        }
    }

    /**
     * 개설 과목 목록 (기수제)
     *
     * @param CreCrsVO
     * @return List
     * @throws Exception
     */
    @Override
    public List<CreCrsVO> coList(CreCrsVO vo) throws Exception {
        List<CreCrsVO> resultList = crecrsDAO.coList(vo);
        return resultList;
    }

    /**
     * 개설과목 관리 목록
     *
     * @param CreCrsVO
     * @return List
     * @throws Exception
     */
    public List<CreCrsVO> listManageCourse(CreCrsVO vo) throws Exception {
        return crecrsDAO.listManageCourse(vo);
    }

    /**
     * 공개강좌 과목 목록
     *
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<CreCrsVO> listPagingManageCourse(CreCrsVO vo) throws Exception {
        ProcessResultVO<CreCrsVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = crecrsDAO.countManageCourse(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<CreCrsVO> resultList = crecrsDAO.listPagingManageCourse(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    @Override
    public void addCoCreCrs(CreCrsVO vo) throws Exception {
        crecrsDAO.insert(vo);
    }

    /**
     * 학기/과목 > 법정 교육 개설 관리 > 법정교육 등록
     *
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public CreCrsVO insertCreCrsLegal(CreCrsVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String rgtrId = vo.getRgtrId();
        String crsCd = "LEG001"; // 임의의 값 세팅

        // form1
        String termCd = vo.getTermCd();
        String crsCreNm = vo.getCrsCreNm();
        String crsCreNmEng = vo.getCrsCreNmEng();
        String crsCreDesc = vo.getCrsCreDesc();
        // form2
        String enrlAplcMthd = vo.getEnrlAplcMthd();
        String nopLimitYn = vo.getNopLimitYn();
        Integer enrlNop = vo.getEnrlNop();
        String useYn = vo.getUseYn();
        String enrlStartDttm = DateTimeUtil.dateToString(DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlStartDttm()), "yyyyMMdd") + "000000";
        String enrlEndDttm = DateTimeUtil.dateToString(DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlEndDttm()), "yyyyMMdd") + "235959";

        // form1
        LOGGER.debug("학기                    : " + termCd);
        LOGGER.debug("개설 과목명(KO) : " + crsCreNm);
        LOGGER.debug("개설 과목명(EN) : " + crsCreNmEng);
        LOGGER.debug("강의 설명             : " + crsCreDesc);
        // form2
        LOGGER.debug("수강 승인 방법      : " + enrlAplcMthd);
        LOGGER.debug("수강인원 제한       : " + nopLimitYn);
        LOGGER.debug("수강인원 수          : " + enrlNop);
        LOGGER.debug("사용여부              : " + useYn);
        LOGGER.debug("강의기간 시작       : " + enrlStartDttm);
        LOGGER.debug("강의기간 종료       : " + enrlEndDttm);

        // 학기정보 조회
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO.setTermCd(termCd);
        termVO = termDAO.select(termVO);

        String haksaYear = termVO.getHaksaYear();
        String haksaTerm = termVO.getHaksaTerm();

        // 법정교육의 학수번호 조회
        CrsVO crsVO = new CrsVO();
        crsVO.setOrgId(orgId);
        crsVO.setCrsCd(crsCd); // 임의의 값 세팅
        crsVO = crsDAO.selectCrsView(crsVO);

        if(crsVO == null) {
            crsVO = new CrsVO();
            crsVO.setCrsCd(crsCd);
            crsVO.setOrgId(orgId);
            crsVO.setCrsTypeCd("LEGAL");
            crsVO.setCrsOperTypeCd("ONLINE");
            crsVO.setCrsNm("법정과목");
            crsVO.setUseYn("Y");
            crsVO.setDelYn("N");
            crsVO.setRgtrId(rgtrId);
            crsVO.setMdfrId(rgtrId);
            crsDAO.insert(crsVO);
        }

        // 키 생성
        Date currentDate = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMddHHmmss");
        String formattedDate = dateFormat.format(currentDate);
        String crsCreCd = haksaYear + haksaTerm + crsCd + formattedDate;

        // 개설과목 등록
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setCrsCd(crsCd);
        creCrsVO.setCreYear(haksaYear);
        creCrsVO.setCreTerm(haksaTerm);
        creCrsVO.setDeclsNo("01");
        creCrsVO.setCrsTypeCd("LEGAL"); // 법정교육
        creCrsVO.setProgressTypeCd("TOPIC");
        creCrsVO.setCrsOperTypeCd("ONLINE");
        creCrsVO.setEnrlAplcMthd("ADM"); // ADMIN: 관리자 승인, USER: 학습자 신청
        creCrsVO.setEnrlCertStatus("NORMAL");
        creCrsVO.setUserId(rgtrId);
        // 폼 입력 1
        creCrsVO.setCrsCreNm(crsCreNm);
        creCrsVO.setCrsCreNmEng(crsCreNmEng);
        creCrsVO.setCrsCreDesc(crsCreDesc);
        // 폼 입력 2
        creCrsVO.setNopLimitYn(nopLimitYn);
        creCrsVO.setEnrlNop(enrlNop);
        creCrsVO.setEnrlStartDttm(enrlStartDttm);
        creCrsVO.setEnrlEndDttm(enrlEndDttm);
        creCrsVO.setUseYn(useYn);
        creCrsVO.setLcdmsLinkYn("N");
        creCrsVO.setErpLessonYn("N");
        crecrsDAO.insert(creCrsVO);

        // PF 평가방법 등록
        /*
         * CreCrsVO creCrsVO2 = new CreCrsVO(); creCrsVO2.setCrsCreCd(crsCreCd);
         * creCrsVO2.setScoreEvalType("PF"); crecrsDAO.updateEvalInfo(creCrsVO2);
         */

        // 학기 맵핑
        CreCrsVO creCrsVO3 = new CreCrsVO();
        creCrsVO3.setCrsCreCd(crsCreCd);
        creCrsVO3.setTermCd(termCd);
        crecrsDAO.insertCreCrsPltn(creCrsVO3);

        // 기본 주차 등록
        String lessonScheduleId = IdGenerator.getNewId("LESN");
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLessonScheduleNm(crsCreNm);
        lessonScheduleVO.setLessonScheduleOrder(1);
        lessonScheduleVO.setLessonStartDt(enrlStartDttm.substring(0, 8));
        lessonScheduleVO.setLessonEndDt(enrlEndDttm.substring(0, 8));
        lessonScheduleVO.setOpenYn("Y");
        lessonScheduleVO.setLbnTm(0);
        lessonScheduleVO.setWekClsfGbn("01");
        lessonScheduleVO.setDelYn("N");
        lessonScheduleVO.setRgtrId(rgtrId);
        lessonScheduleVO.setMdfrId(rgtrId);
        lessonScheduleDAO.insert(lessonScheduleVO);

        // 기본 교시 등록
        String lessonTimeId = IdGenerator.getNewId("LESN");
        LessonTimeVO lessonTimeVO = new LessonTimeVO();
        lessonTimeVO.setLessonTimeId(lessonTimeId);
        lessonTimeVO.setLessonScheduleId(lessonScheduleId);
        lessonTimeVO.setCrsCreCd(crsCreCd);
        lessonTimeVO.setLessonTimeNm(crsCreNm);
        lessonTimeVO.setLessonTimeOrder(1);
        lessonTimeVO.setStdyMethod("RND");
        lessonTimeVO.setRgtrId(rgtrId);
        lessonTimeVO.setMdfrId(rgtrId);
        lessonTimeDAO.insert(lessonTimeVO);

        // 기본 컨텐츠 등록
        String lessonCntsId = IdGenerator.getNewId("LECN");
        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setLessonCntsId(lessonCntsId);
        lessonCntsVO.setCrsCreCd(crsCreCd);
        lessonCntsVO.setLessonTimeId(lessonTimeId);
        lessonCntsVO.setLessonScheduleId(lessonScheduleId);
        lessonCntsVO.setLessonTypeCd("ONLINE");
        lessonCntsVO.setLessonCntsNm(crsCreNm);
        lessonCntsVO.setLessonCntsOrder(1);
        lessonCntsVO.setCntsGbn("VIDEO");
        lessonCntsVO.setPrgrYn("Y");
        lessonCntsVO.setViewYn("Y");
        lessonCntsVO.setRgtrId(rgtrId);
        lessonTimeVO.setMdfrId(rgtrId);
        lessonCntsDAO.insert(lessonCntsVO);

        return creCrsVO;
    }

    /**
     * 학기/과목 > 법정 교육 개설 관리 > 법정교육 수정
     *
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public CreCrsVO updateCreCrsLegal(CreCrsVO vo) throws Exception {
        String mdfrId = vo.getMdfrId();

        String crsCreCd = vo.getCrsCreCd();

        // form1
        String termCd = vo.getTermCd();
        String crsCreNm = vo.getCrsCreNm();
        String crsCreNmEng = vo.getCrsCreNmEng();
        String crsCreDesc = vo.getCrsCreDesc();
        // form2
        String enrlAplcMthd = vo.getEnrlAplcMthd();
        String nopLimitYn = vo.getNopLimitYn();
        Integer enrlNop = vo.getEnrlNop();
        String useYn = vo.getUseYn();
        String enrlStartDttm = DateTimeUtil.dateToString(DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlStartDttm()), "yyyyMMdd") + "000000";
        String enrlEndDttm = DateTimeUtil.dateToString(DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlEndDttm()), "yyyyMMdd") + "235959";

        // form1
        LOGGER.debug("학기                    : " + termCd);
        LOGGER.debug("개설 과목명(KO) : " + crsCreNm);
        LOGGER.debug("개설 과목명(EN) : " + crsCreNmEng);
        LOGGER.debug("강의 설명             : " + crsCreDesc);
        // form2
        LOGGER.debug("수강 승인 방법      : " + enrlAplcMthd);
        LOGGER.debug("수강인원 제한       : " + nopLimitYn);
        LOGGER.debug("수강인원 수          : " + enrlNop);
        LOGGER.debug("사용여부              : " + useYn);
        LOGGER.debug("강의기간 시작       : " + enrlStartDttm);
        LOGGER.debug("강의기간 종료       : " + enrlEndDttm);

        vo.setEnrlStartDttm(enrlStartDttm);
        vo.setEnrlEndDttm(enrlEndDttm);

        crecrsDAO.update(vo);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setCrsTypeCd("LEGAL");
        creCrsVO = crecrsDAO.select(creCrsVO);

        // 기본주차 Update
        String lessonScheduleId = creCrsVO.getLessonScheduleId();
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO.setLessonScheduleNm(crsCreNm);
        lessonScheduleVO.setLessonStartDt(enrlStartDttm.substring(0, 8));
        lessonScheduleVO.setLessonEndDt(enrlEndDttm.substring(0, 8));
        lessonScheduleVO.setMdfrId(mdfrId);
        lessonScheduleDAO.update(lessonScheduleVO);

        // 기본 교시 Update
        String lessonTimeId = creCrsVO.getLessonTimeId();
        LessonTimeVO lessonTimeVO = new LessonTimeVO();
        lessonTimeVO.setLessonTimeId(lessonTimeId);
        lessonTimeVO.setLessonTimeNm(crsCreNm);
        lessonTimeVO.setMdfrId(mdfrId);
        lessonTimeDAO.update(lessonTimeVO);

        // 기본 컨텐츠 Update
        String lessonCntsId = creCrsVO.getLessonCntsId();
        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setLessonCntsId(lessonCntsId);
        lessonCntsVO.setLessonCntsNm(crsCreNm);
        lessonCntsVO.setMdfrId(mdfrId);
        lessonCntsDAO.updateCntsNm(lessonCntsVO);

        // 강의 페이지명 Update
        LessonPageVO lessonPageVO = new LessonPageVO();
        lessonPageVO.setLessonCntsId(lessonCntsId);
        List<LessonPageVO> listLessonPage2 = lessonPageDAO.list(lessonPageVO);

        for(int i = 0; i < listLessonPage2.size(); i++) {
            String pageCnt = listLessonPage2.get(i).getPageCnt();
            String idx;

            if((i + 1) < 10) {
                idx = "0" + (i + 1);
            } else {
                idx = "" + (i + 1);
            }

            String pageNm = creCrsVO.getCrsCreNm() + "_" + idx;

            LessonPageVO updateLessonPageVO = new LessonPageVO();
            updateLessonPageVO.setLessonCntsId(lessonCntsId);
            updateLessonPageVO.setPageCnt(pageCnt);
            updateLessonPageVO.setPageNm(pageNm);
            updateLessonPageVO.setMdfrId(mdfrId);
            lessonPageDAO.update(updateLessonPageVO);
        }

        return vo;
    }

    /**
     * 학기/과목 > 공개 강좌 개설 관리 > 공개강좌 등록
     *
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public CreCrsVO insertCreCrsOpen(CreCrsVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String rgtrId = vo.getRgtrId();
        String crsCd = "OPE001"; // 임의의 값 세팅

        // form1
        String termCd = vo.getTermCd();
        String crsCreNm = vo.getCrsCreNm();
        String crsCreNmEng = vo.getCrsCreNmEng();
        String crsCreDesc = vo.getCrsCreDesc();
        // form2
        String enrlAplcMthd = vo.getEnrlAplcMthd();
        String useYn = vo.getUseYn();
        String enrlStartDttm = DateTimeUtil.dateToString(DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlStartDttm()), "yyyyMMdd") + "000000";
        String enrlEndDttm = DateTimeUtil.dateToString(DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlEndDttm()), "yyyyMMdd") + "235959";

        // form1
        LOGGER.debug("학기                    : " + termCd);
        LOGGER.debug("개설 과목명(KO) : " + crsCreNm);
        LOGGER.debug("개설 과목명(EN) : " + crsCreNmEng);
        LOGGER.debug("강의 설명             : " + crsCreDesc);
        // form2
        LOGGER.debug("수강 승인 방법      : " + enrlAplcMthd);
        LOGGER.debug("사용여부              : " + useYn);
        LOGGER.debug("강의기간 시작       : " + enrlStartDttm);
        LOGGER.debug("강의기간 종료       : " + enrlEndDttm);

        // 학기정보 조회
        TermVO termVO = new TermVO();
        termVO.setOrgId(orgId);
        termVO.setTermCd(termCd);
        termVO = termDAO.select(termVO);

        String haksaYear = termVO.getHaksaYear();
        String haksaTerm = termVO.getHaksaTerm();

        // 공개강좌의 학수번호 조회
        CrsVO crsVO = new CrsVO();
        crsVO.setOrgId(orgId);
        crsVO.setCrsCd(crsCd); // 임의의 값 세팅
        crsVO = crsDAO.selectCrsView(crsVO);

        if(crsVO == null) {
            crsVO = new CrsVO();
            crsVO.setCrsCd(crsCd);
            crsVO.setOrgId(orgId);
            crsVO.setCrsTypeCd("OPEN");
            crsVO.setCrsOperTypeCd("ONLINE");
            crsVO.setCrsNm("공개강좌");
            crsVO.setUseYn("Y");
            crsVO.setDelYn("N");
            crsVO.setRgtrId(rgtrId);
            crsVO.setMdfrId(rgtrId);
            crsDAO.insert(crsVO);
        }

        // 키 생성
        Date currentDate = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMddHHmmss");
        String formattedDate = dateFormat.format(currentDate);
        String crsCreCd = haksaYear + haksaTerm + crsCd + formattedDate;

        // 개설과목 등록
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setCrsCd(crsCd);
        creCrsVO.setCreYear(haksaYear);
        creCrsVO.setCreTerm(haksaTerm);
        creCrsVO.setDeclsNo("01");
        creCrsVO.setCrsTypeCd("OPEN"); // 공개강좌
        creCrsVO.setProgressTypeCd("TOPIC");
        creCrsVO.setCrsOperTypeCd("ONLINE");
        creCrsVO.setEnrlAplcMthd("ADM"); // ADMIN: 관리자 승인, USER: 학습자 신청
        creCrsVO.setEnrlCertStatus("NORMAL");
        creCrsVO.setUserId(rgtrId);
        // 폼 입력 1
        creCrsVO.setCrsCreNm(crsCreNm);
        creCrsVO.setCrsCreNmEng(crsCreNmEng);
        creCrsVO.setCrsCreDesc(crsCreDesc);
        // 폼 입력 2
        creCrsVO.setEnrlStartDttm(enrlStartDttm);
        creCrsVO.setEnrlEndDttm(enrlEndDttm);
        creCrsVO.setUseYn(useYn);
        creCrsVO.setLcdmsLinkYn("N");
        creCrsVO.setErpLessonYn("N");
        crecrsDAO.insert(creCrsVO);

        // 학기 맵핑
        CreCrsVO creCrsVO3 = new CreCrsVO();
        creCrsVO3.setCrsCreCd(crsCreCd);
        creCrsVO3.setTermCd(termCd);
        crecrsDAO.insertCreCrsPltn(creCrsVO3);

        // 기본 주차 등록
        String lessonScheduleId = IdGenerator.getNewId("LESN");
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO.setLessonScheduleNm(crsCreNm);
        lessonScheduleVO.setLessonScheduleOrder(1);
        lessonScheduleVO.setLessonStartDt(enrlStartDttm.substring(0, 8));
        lessonScheduleVO.setLessonEndDt(enrlEndDttm.substring(0, 8));
        lessonScheduleVO.setOpenYn("Y");
        lessonScheduleVO.setLbnTm(0);
        lessonScheduleVO.setWekClsfGbn("01");
        lessonScheduleVO.setDelYn("N");
        lessonScheduleVO.setRgtrId(rgtrId);
        lessonScheduleVO.setMdfrId(rgtrId);
        lessonScheduleDAO.insert(lessonScheduleVO);

        // 기본 교시 등록
        String lessonTimeId = IdGenerator.getNewId("LESN");
        LessonTimeVO lessonTimeVO = new LessonTimeVO();
        lessonTimeVO.setLessonTimeId(lessonTimeId);
        lessonTimeVO.setLessonScheduleId(lessonScheduleId);
        lessonTimeVO.setCrsCreCd(crsCreCd);
        lessonTimeVO.setLessonTimeNm(crsCreNm);
        lessonTimeVO.setLessonTimeOrder(1);
        lessonTimeVO.setStdyMethod("RND");
        lessonTimeVO.setRgtrId(rgtrId);
        lessonTimeVO.setMdfrId(rgtrId);
        lessonTimeDAO.insert(lessonTimeVO);

        // 기본 컨텐츠 등록
        String lessonCntsId = IdGenerator.getNewId("LECN");
        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setLessonCntsId(lessonCntsId);
        lessonCntsVO.setCrsCreCd(crsCreCd);
        lessonCntsVO.setLessonTimeId(lessonTimeId);
        lessonCntsVO.setLessonScheduleId(lessonScheduleId);
        lessonCntsVO.setLessonTypeCd("ONLINE");
        lessonCntsVO.setLessonCntsNm(crsCreNm);
        lessonCntsVO.setLessonCntsOrder(1);
        lessonCntsVO.setCntsGbn("VIDEO");
        lessonCntsVO.setPrgrYn("N");
        lessonCntsVO.setViewYn("Y");
        lessonCntsVO.setRgtrId(rgtrId);
        lessonTimeVO.setMdfrId(rgtrId);
        lessonCntsDAO.insert(lessonCntsVO);

        return creCrsVO;
    }

    /**
     * 학기/과목 > 공개 강좌 개설 관리 > 공개강좌 수정
     *
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public CreCrsVO updateCreCrsOpen(CreCrsVO vo) throws Exception {
        String mdfrId = vo.getMdfrId();

        String crsCreCd = vo.getCrsCreCd();
        String[] delFileIds = vo.getDelFileIds();

        // form1
        String termCd = vo.getTermCd();
        String crsCreNm = vo.getCrsCreNm();
        String crsCreNmEng = vo.getCrsCreNmEng();
        String crsCreDesc = vo.getCrsCreDesc();
        // form2
        String useYn = vo.getUseYn();
        String enrlStartDttm = DateTimeUtil.dateToString(DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlStartDttm()), "yyyyMMdd") + "000000";
        String enrlEndDttm = DateTimeUtil.dateToString(DateTimeUtil.stringToDate("yyyy.MM.dd", vo.getEnrlEndDttm()), "yyyyMMdd") + "235959";

        // form1
        LOGGER.debug("학기                    : " + termCd);
        LOGGER.debug("개설 과목명(KO) : " + crsCreNm);
        LOGGER.debug("개설 과목명(EN) : " + crsCreNmEng);
        LOGGER.debug("강의 설명             : " + crsCreDesc);
        // form2
        LOGGER.debug("사용여부              : " + useYn);
        LOGGER.debug("강의기간 시작       : " + enrlStartDttm);
        LOGGER.debug("강의기간 종료       : " + enrlEndDttm);

        vo.setEnrlStartDttm(enrlStartDttm);
        vo.setEnrlEndDttm(enrlEndDttm);

        crecrsDAO.update(vo);

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setCrsTypeCd("OPEN");
        creCrsVO = crecrsDAO.select(creCrsVO);

        // 기본주차 Update
        String lessonScheduleId = creCrsVO.getLessonScheduleId();
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO.setLessonScheduleNm(crsCreNm);
        lessonScheduleVO.setLessonStartDt(enrlStartDttm.substring(0, 8));
        lessonScheduleVO.setLessonEndDt(enrlEndDttm.substring(0, 8));
        lessonScheduleVO.setMdfrId(mdfrId);
        lessonScheduleDAO.update(lessonScheduleVO);

        // 기본 교시 Update
        String lessonTimeId = creCrsVO.getLessonTimeId();
        LessonTimeVO lessonTimeVO = new LessonTimeVO();
        lessonTimeVO.setLessonTimeId(lessonTimeId);
        lessonTimeVO.setLessonTimeNm(crsCreNm);
        lessonTimeVO.setMdfrId(mdfrId);
        lessonTimeDAO.update(lessonTimeVO);

        // 기본 컨텐츠 Update
        String lessonCntsId = creCrsVO.getLessonCntsId();
        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setLessonCntsId(lessonCntsId);
        lessonCntsVO.setLessonCntsNm(crsCreNm);
        lessonCntsVO.setMdfrId(mdfrId);
        lessonCntsDAO.updateCntsNm(lessonCntsVO);

        // 강의 페이지명 Update
        LessonPageVO lessonPageVO = new LessonPageVO();
        lessonPageVO.setLessonCntsId(lessonCntsId);
        List<LessonPageVO> listLessonPage2 = lessonPageDAO.list(lessonPageVO);

        for(int i = 0; i < listLessonPage2.size(); i++) {
            String pageCnt = listLessonPage2.get(i).getPageCnt();
            String idx;

            if((i + 1) < 10) {
                idx = "0" + (i + 1);
            } else {
                idx = "" + (i + 1);
            }

            String pageNm = creCrsVO.getCrsCreNm() + "_" + idx;

            LessonPageVO updateLessonPageVO = new LessonPageVO();
            updateLessonPageVO.setLessonCntsId(lessonCntsId);
            updateLessonPageVO.setPageCnt(pageCnt);
            updateLessonPageVO.setPageNm(pageNm);
            updateLessonPageVO.setMdfrId(mdfrId);
            lessonPageDAO.update(updateLessonPageVO);
        }

        return vo;
    }

    @Override
    public List<CreCrsVO> listAuthCrsCreByTerm(CreCrsVO vo) throws Exception {
        return crecrsDAO.listAuthCrsCreByTerm(vo);
    }

    /**
     * 관리/설정 > 이전과목 가져오기
     *
     * @param CreCrsVO
     * @return String
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    @Override
    public Map<String, Object> copyPrevCourse(CreCrsVO vo, String copyCrsCreCd) throws Exception {
        Map<String, Object> resultMap = new HashMap<>();

        String orgId = vo.getOrgId();
        String crsCreCd = vo.getCrsCreCd();
        String gubun = vo.getGubun();
        String rgtrId = vo.getRgtrId();

        if(ValidationUtils.isEmpty(orgId)
                || ValidationUtils.isEmpty(crsCreCd)
                || ValidationUtils.isEmpty(gubun)
                || ValidationUtils.isEmpty(rgtrId)
                || ValidationUtils.isEmpty(copyCrsCreCd)) {
            throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
        }

        // 강의실 정보
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setOrgId(orgId);
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsDAO.select(creCrsVO);

        String repUserId = creCrsVO.getUserId();

        if(ValidationUtils.isNotEmpty(repUserId)) {
            rgtrId = repUserId;
        }

        // 가져올 강의실 정보
        CreCrsVO copyCreCrsVO = new CreCrsVO();
        copyCreCrsVO.setOrgId(orgId);
        copyCreCrsVO.setCrsCreCd(copyCrsCreCd);
        copyCreCrsVO.setGubun(gubun);
        EgovMap prevSubjectItem = crecrsDAO.selectPrevCourseItem(copyCreCrsVO);

        List<LessonCntsVO> listLesson = (List<LessonCntsVO>) prevSubjectItem.get("listLesson");
        List<BbsAtclVO> listNotice = (List<BbsAtclVO>) prevSubjectItem.get("listNotice");
        List<BbsAtclVO> listPds = (List<BbsAtclVO>) prevSubjectItem.get("listPds");
        List<AsmtVO> listAsmnt = (List<AsmtVO>) prevSubjectItem.get("listAsmnt");
        List<ForumVO> listForum = (List<ForumVO>) prevSubjectItem.get("listForum");
        List<ExamVO> listQuiz = (List<ExamVO>) prevSubjectItem.get("listQuiz");
        List<ReshVO> listResch = (List<ReshVO>) prevSubjectItem.get("listResch");

        System.out.println("이전 과목 가져오기 > 학습자료  : " + listLesson.size());
        System.out.println("이전 과목 가져오기 > 과목공지  : " + listNotice.size());
        System.out.println("이전 과목 가져오기 > 강의자료실 : " + listPds.size());
        System.out.println("이전 과목 가져오기 > 과제 : " + listAsmnt.size());
        System.out.println("이전 과목 가져오기 > 토론 : " + listForum.size());
        System.out.println("이전 과목 가져오기 > 퀴즈 : " + listQuiz.size());
        System.out.println("이전 과목 가져오기 > 설문 : " + listResch.size());

        if("ALL".equals(gubun) || "LESSON".equals(gubun)) {
            int copyCnt = 0;

            for(LessonCntsVO lessonCntsVO : listLesson) {
                String copyLessonCntsId = lessonCntsVO.getLessonCntsId();

                LessonCntsVO copyLessonCntsVO = new LessonCntsVO();
                copyLessonCntsVO.setOrgId(orgId);
                copyLessonCntsVO.setCrsCreCd(crsCreCd);
                copyLessonCntsVO.setCopyLessonCntsId(copyLessonCntsId);
                copyLessonCntsVO.setRgtrId(rgtrId);

                lessonCntsService.copyLessonCnts(copyLessonCntsVO);

                copyCnt++;
            }

            resultMap.put("LESSON", copyCnt);
        }

        if("ALL".equals(gubun) || "NOTICE".equals(gubun)) {
            int copyCnt = 0;

            for(BbsAtclVO bbsAtclVO : listNotice) {
                String copyAtclId = bbsAtclVO.getAtclId();

                BbsAtclVO copyBbsAtclVO = new BbsAtclVO();
                copyBbsAtclVO.setOrgId(orgId);
                copyBbsAtclVO.setCrsCreCd(crsCreCd);
                copyBbsAtclVO.setCopyAtclId(copyAtclId);
                copyBbsAtclVO.setRgtrId(rgtrId);
                copyBbsAtclVO.setBbsId("NOTICE");
                copyBbsAtclVO.setLineNo(bbsAtclVO.getLineNo());

                bbsAtclService.copyAtclToNewCourse(copyBbsAtclVO);
                copyCnt++;
            }

            resultMap.put("NOTICE", copyCnt);
        }

        if("ALL".equals(gubun) || "PDS".equals(gubun)) {
            int copyCnt = 0;

            for(BbsAtclVO bbsAtclVO : listPds) {
                String copyAtclId = bbsAtclVO.getAtclId();

                BbsAtclVO copyBbsAtclVO = new BbsAtclVO();
                copyBbsAtclVO.setOrgId(orgId);
                copyBbsAtclVO.setCrsCreCd(crsCreCd);
                copyBbsAtclVO.setCopyAtclId(copyAtclId);
                copyBbsAtclVO.setRgtrId(rgtrId);
                copyBbsAtclVO.setBbsId("PDS");
                copyBbsAtclVO.setLineNo(bbsAtclVO.getLineNo());

                bbsAtclService.copyAtclToNewCourse(copyBbsAtclVO);

                copyCnt++;
            }

            resultMap.put("PDS", copyCnt);
        }

        if("ALL".equals(gubun) || "ASMNT".equals(gubun)) {
            int copyCnt = 0;

            for(AsmtVO asmtVO : listAsmnt) {
                String copyAsmntCd = asmtVO.getAsmtId();

                AsmtVO copyAsmtVO = new AsmtVO();
                copyAsmtVO.setOrgId(orgId);
                copyAsmtVO.setCrsCreCd(crsCreCd);
                copyAsmtVO.setCopyAsmtId(copyAsmntCd);
                copyAsmtVO.setRgtrId(rgtrId);
                copyAsmtVO.setLineNo(asmtVO.getLineNo());

                asmtProService.copyAsmnt(copyAsmtVO);

                copyCnt++;
            }

            resultMap.put("ASMNT", copyCnt);
        }

        if("ALL".equals(gubun) || "FORUM".equals(gubun)) {
            int copyCnt = 0;

            for(ForumVO forumVO : listForum) {
                String copyForumCd = forumVO.getForumCd();

                ForumVO copyForumVO = new ForumVO();
                copyForumVO.setOrgId(orgId);
                copyForumVO.setCrsCreCd(crsCreCd);
                copyForumVO.setCopyForumCd(copyForumCd);
                copyForumVO.setRgtrId(rgtrId);
                copyForumVO.setLineNo(forumVO.getLineNo());

                forumService.copyForum(copyForumVO);

                copyCnt++;
            }

            resultMap.put("FORUM", copyCnt);
        }

        if("ALL".equals(gubun) || "QUIZ".equals(gubun)) {
            int copyCnt = 0;

            for(ExamVO examVO : listQuiz) {
                String copyExamCd = examVO.getExamCd();

                ExamVO copyExamVO = new ExamVO();
                copyExamVO.setOrgId(orgId);
                copyExamVO.setCrsCreCd(crsCreCd);
                copyExamVO.setCopyExamCd(copyExamCd);
                copyExamVO.setRgtrId(rgtrId);
                copyExamVO.setLineNo(examVO.getLineNo());

                examService.copyQuiz(copyExamVO);

                copyCnt++;
            }

            resultMap.put("QUIZ", copyCnt);
        }

        if("ALL".equals(gubun) || "RESCH".equals(gubun)) {
            int copyCnt = 0;

            for(ReshVO reshVO : listResch) {
                String copyReschCd = reshVO.getReschCd();

                ReshVO copyReschVO = new ReshVO();
                copyReschVO.setOrgId(orgId);
                copyReschVO.setCrsCreCd(crsCreCd);
                copyReschVO.setCopyReschCd(copyReschCd);
                copyReschVO.setRgtrId(rgtrId);
                copyReschVO.setLineNo(reshVO.getLineNo());

                reshService.copyResh(copyReschVO);

                copyCnt++;
            }

            resultMap.put("RESCH", copyCnt);
        }

        return resultMap;
    }

    /**
     * 이전학기 과목여부 체크
     *
     * @param CreCrsVO
     * @return String
     * @throws Exception
     */
    @Override
    public String checkPrevCourseYn(String crsCreCd) throws Exception {
        TermVO termVO = new TermVO();
        termVO.setCrsCreCd(crsCreCd);
        termVO = termDAO.selectTermByCrsCreCd(termVO);

        boolean isPrevCourse = false;

        if(!"Y".equals(termVO.getNowSmstryn()) && !"WAIT".equals(termVO.getTermStatus())) {
            isPrevCourse = true;
        }

        return isPrevCourse ? "Y" : "N";
    }

    /**
     * 선수강과목 이전학기 자료 이관
     *
     * @param CreCrsVO
     * @return int
     * @throws Exception
     */
    @Override
    public int transPrevTermCorsData(CreCrsVO vo) throws Exception {
        int result = 1;

        String crsCreCd = vo.getCrsCreCd();
        String creYear = vo.getCreYear();
        String creTerm = vo.getCreTerm();

        if("10".equals(creTerm)) {
            creTerm = "21";
            creYear = (Integer.parseInt(creYear) - 1) + "";

        } else if("20".equals(creTerm)) {
            creTerm = "11";
        } else {
            return -2;
        }

        String prvCrsCreCd = creYear + creTerm + crsCreCd.substring(6);

        // 수강생
        StdVO stdVO = new StdVO();
        stdVO.setCrsCreCd(prvCrsCreCd);
        List<StdVO> stdList = stdDAO.listStdForTrans(stdVO);

        if(stdList.size() > 0) {
            for(StdVO pStdVO : stdList) {
                pStdVO.setStdId(crsCreCd + pStdVO.getUserId());
                pStdVO.setCrsCreCd(crsCreCd);
            }

            // 수강생목록 저장
            stdDAO.insertStdListForTrans(stdList);
        }

        // 학습주차
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(prvCrsCreCd);
        List<LessonScheduleVO> scheduleList = lessonScheduleDAO.listLessonScheduleForTrans(lessonScheduleVO);

        if(scheduleList.size() > 0) {
            for(LessonScheduleVO pScheduleVO : scheduleList) {
                pScheduleVO.setLessonScheduleId(pScheduleVO.getLessonScheduleId().replaceAll(prvCrsCreCd, crsCreCd));
                pScheduleVO.setCrsCreCd(crsCreCd);
            }

            // 학습주차 저장
            lessonScheduleDAO.insertLessonScheduleListForTrans(scheduleList);
        }

        // 학습일정 교시
        LessonTimeVO lessonTimeVO = new LessonTimeVO();
        lessonTimeVO.setCrsCreCd(prvCrsCreCd);
        List<LessonTimeVO> lessonTimeLIst = lessonTimeDAO.list(lessonTimeVO);

        if(lessonTimeLIst.size() > 0) {
            for(LessonTimeVO pLessonTimeVO : lessonTimeLIst) {
                pLessonTimeVO.setCrsCreCd(crsCreCd);
                pLessonTimeVO.setLessonTimeId(pLessonTimeVO.getLessonTimeId().replaceAll(prvCrsCreCd, crsCreCd));
                pLessonTimeVO.setLessonScheduleId(pLessonTimeVO.getLessonScheduleId().replaceAll(prvCrsCreCd, crsCreCd));
            }

            // 학습일정 교시 저장
            lessonTimeDAO.insertLessonTimeListForTrans(lessonTimeLIst);
        }

        // 학습콘텐츠
        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setCrsCreCd(prvCrsCreCd);
        List<LessonCntsVO> lessonCntsList = lessonCntsDAO.list(lessonCntsVO);

        if(lessonCntsList.size() > 0) {
            for(LessonCntsVO pLessonCntsVO : lessonCntsList) {
                pLessonCntsVO.setCrsCreCd(crsCreCd);
                pLessonCntsVO.setLessonCntsId(pLessonCntsVO.getLessonCntsId().replaceAll(prvCrsCreCd, crsCreCd));
                pLessonCntsVO.setLessonTimeId(pLessonCntsVO.getLessonTimeId().replaceAll(prvCrsCreCd, crsCreCd));
                pLessonCntsVO.setLessonScheduleId(pLessonCntsVO.getLessonScheduleId().replaceAll(prvCrsCreCd, crsCreCd));
            }

            // 학습콘텐츠 저장
            lessonCntsDAO.insertLessonCntsListForTrans(lessonCntsList);
        }

        // 학습페이지
        LessonPageVO lessonPageVO = new LessonPageVO();
        lessonPageVO.setCrsCreCd(prvCrsCreCd);
        List<LessonPageVO> lessonPageList = lessonPageDAO.listLessonCntsForTrans(lessonPageVO);

        if(lessonPageList.size() > 0) {
            for(LessonPageVO pLessonPageVO : lessonPageList) {
                pLessonPageVO.setLessonCntsId(pLessonPageVO.getLessonCntsId().replaceAll(prvCrsCreCd, crsCreCd));
            }

            // 학습페이지 저장
            lessonPageDAO.insertLessonPageListForTrans(lessonPageList);
        }

        // 학습기록
        LessonStudyRecordVO lessonStudyRecordVO = new LessonStudyRecordVO();
        lessonStudyRecordVO.setCrsCreCd(prvCrsCreCd);
        List<LessonStudyRecordVO> recordList = lessonStudyDAO.listStdRecordForTrans(lessonStudyRecordVO);

        if(recordList.size() > 0) {
            for(LessonStudyRecordVO pLessonStudyRecordVO : recordList) {
                pLessonStudyRecordVO.setCrsCreCd(crsCreCd);
                pLessonStudyRecordVO.setStdId(pLessonStudyRecordVO.getStdId().replaceAll(prvCrsCreCd, crsCreCd));
                pLessonStudyRecordVO.setLessonCntsId(pLessonStudyRecordVO.getLessonCntsId().replaceAll(prvCrsCreCd, crsCreCd));
            }

            // 학습기록 저장
            lessonStudyDAO.insertStdRecordListForTrans(recordList);
        }

        // 학습상태
        LessonStudyStateVO lessonStudyStateVO = new LessonStudyStateVO();
        lessonStudyStateVO.setCrsCreCd(prvCrsCreCd);
        List<LessonStudyStateVO> stateList = lessonStudyDAO.listStdStateForTrans(lessonStudyStateVO);

        if(stateList.size() > 0) {
            for(LessonStudyStateVO pLessonStudyStateVO : stateList) {
                pLessonStudyStateVO.setCrsCreCd(crsCreCd);
                pLessonStudyStateVO.setLessonScheduleId(pLessonStudyStateVO.getLessonScheduleId().replaceAll(prvCrsCreCd, crsCreCd));
                pLessonStudyStateVO.setStdId(pLessonStudyStateVO.getStdId().replaceAll(prvCrsCreCd, crsCreCd));
            }

            // 학습상태 저장
            lessonStudyDAO.insertStdStateListForTrans(stateList);
        }

        // 페이지 학습기록
        LessonStudyPageVO lessonStudyPageVO = new LessonStudyPageVO();
        lessonStudyPageVO.setCrsCreCd(prvCrsCreCd);
        List<LessonStudyPageVO> studyPageList = lessonStudyDAO.listLessonStudyPageForTrans(lessonStudyPageVO);

        if(studyPageList.size() > 0) {
            for(LessonStudyPageVO pLessonStudyPageVO : studyPageList) {
                pLessonStudyPageVO.setCrsCreCd(crsCreCd);
                pLessonStudyPageVO.setLessonCntsId(pLessonStudyPageVO.getLessonCntsId().replaceAll(prvCrsCreCd, crsCreCd));
                pLessonStudyPageVO.setStdId(pLessonStudyPageVO.getStdId().replaceAll(prvCrsCreCd, crsCreCd));
            }

            // 페이지 학습기록
            lessonStudyDAO.insertLessonStudyPageListForTrans(studyPageList);
        }

        // 게시판
        BbsAtclVO bbsAtclVO = new BbsAtclVO();
        bbsAtclVO.setRltnRefCd(prvCrsCreCd);
        bbsAtclVO.setCrsCreCd(crsCreCd);

        // 게시글 수정
        bbsAtclDAO.updateBbsAtclForTrans(bbsAtclVO);

        // 과제
        AsmtVO asmtVO = new AsmtVO();
        asmtVO.setCrsCreCd(prvCrsCreCd);
        asmtVO.setNewSbjctId(crsCreCd);

        // 과제 수정
        asmtDAO.updateAsmntForTrans(asmtVO);

        // 과목 이관상태 업데이트
        vo.setTmswPreTransYn("Y");
        crecrsDAO.updateTmswPreTransState(vo);

        return result;
    }

    /**
     * JLPT과목 학기 이관
     *
     * @param CreCrsVO
     * @return int
     * @throws Exception
     */
    public int transJlptCorsData(CreCrsVO vo) throws Exception {
        int result = 1;

        TermVO termVO = new TermVO();
        termVO.setTermCd(vo.getTransTermCd());
        termVO = termDAO.select(termVO);
        if(termVO == null) {
            return -1;
        }

        vo.setCreYear(termVO.getHaksaYear());
        vo.setCreTerm(termVO.getHaksaTerm());

        // 과목정보의 학기 변경
        crecrsDAO.updateCreCrsTermForTrans(vo);

        // 학습활동 기록 삭제
        crecrsDAO.deleteCreCrsDataForTrans(vo);

        return result;
    }

    /**
     * 사용자 학기별 대학구분 조회
     *
     * @param CreCrsVO
     * @return List
     * @throws Exception
     */
    public List<EgovMap> listUserUnivGbn(HttpServletRequest request, CreCrsVO vo) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String userType = SessionInfo.getAuthrtCd(request);

        vo.setOrgId(orgId);
        vo.setUserId(userId);

        List<EgovMap> list = null;

        if(menuType.contains("USR")) {
            list = crecrsDAO.listStdUnivGbn(vo);
        } else if(menuType.contains("PROF") && (userType.contains("PFS") || userType.contains("TUT"))) {
            list = crecrsDAO.listProfUnivGbn(vo);
        }

        return list;
    }

    /**
     * 수강중인 학번 수 조회
     *
     * @param CreCrsVO
     * @return int
     * @throws Exception
     */
    public int countStdUserId(CreCrsVO vo) throws Exception {
        if(vo.getSqlForeach() != null && vo.getSqlForeach().length > 0) {
            return crecrsDAO.countStdUserId(vo);
        } else {
            return 0;
        }
    }

    /**
     * 개설 과목 조회 (학위연도, 기관, 학기기수, 학과 기준)
     *
     * @param SubjectVO
     * @return List<SubjectVO>
     * @throws Exception
     */
    /**
     * 개설 과목 조회 (학위연도, 기관, 학기기수, 학과 기준)
     * @param SubjectVO
     * @return List<SubjectVO>
     * @throws Exception
     */
    public List<EgovMap> listSbjctOfrng (SubjectVO sbjctOfrngVO)throws Exception {
    	List<EgovMap> returnList = new ArrayList<EgovMap>();
    	
    	returnList= crecrsDAO.listSbjctOfring(sbjctOfrngVO);
    	
    	return returnList;
    }
}
