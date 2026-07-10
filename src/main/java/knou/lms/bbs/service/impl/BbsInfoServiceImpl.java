package knou.lms.bbs.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.IdGenerator;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.bbs.dao.BbsInfoDAO;
import knou.lms.bbs.dao.BbsInfoLangDAO;
import knou.lms.bbs.dao.BbsRltnDAO;
import knou.lms.bbs.service.BbsInfoService;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.bbs.vo.BbsInfoLangVO;
import knou.lms.bbs.vo.BbsInfoVO;
import knou.lms.bbs.vo.BbsRltnVO;
import knou.lms.bbs.vo.BbsVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.lesson.service.LessonScheduleService;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.team.service.TeamService;
import knou.lms.team.vo.TeamVO;

@Service("bbsInfoService")
public class BbsInfoServiceImpl extends ServiceBase implements BbsInfoService {

    private static final Logger LOGGER = LoggerFactory.getLogger(BbsInfoServiceImpl.class);

    @Resource(name = "bbsInfoDAO")
    private BbsInfoDAO bbsInfoDAO;

    @Resource(name = "bbsInfoLangDAO")
    private BbsInfoLangDAO bbsInfoLangDAO;

    @Resource(name = "bbsRltnDAO")
    private BbsRltnDAO bbsRltnDAO;

    @Resource(name = "teamService")
    private TeamService teamService;

    @Resource(name="lessonScheduleService")
    private LessonScheduleService lessonScheduleService;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    /*****************************************************
     * 게시판 정보
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    @Override
    public BbsVO selectBbsInfo(BbsVO vo) throws Exception {
        return bbsInfoDAO.selectBbsInfo(vo);
    }

    // 삭제 예정
    @Override
    public BbsInfoVO selectBbsInfo(BbsInfoVO vo) throws Exception {
        return null;
    }

    /*****************************************************
     * 게시판 목록
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<BbsVO> listBbsInfo(BbsVO vo) throws Exception {
        return bbsInfoDAO.listBbsInfo(vo);
    }

    /*****************************************************
     * 게시판 목록 페이징
     * @param vo
     * @return ProcessResultVO<BbsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<BbsVO> listBbsInfoPaging(BbsVO vo) throws Exception {
        ProcessResultVO<BbsVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = bbsInfoDAO.countBbsInfo(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<BbsVO> resultList = bbsInfoDAO.listBbsInfoPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 게시판 정보 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void insertBbsInfo(BbsVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        String bbsCd = vo.getBbsId();

        LOGGER.debug("bbsId             : " + vo.getBbsId());
        LOGGER.debug("orgId             : " + vo.getOrgId());
        LOGGER.debug("bbsCd             : " + vo.getBbsId());
        LOGGER.debug("bbsNm             : " + vo.getBbsnm());
        LOGGER.debug("bbsDesc           : " + vo.getBbsExpln());
        LOGGER.debug("bbsTypeCd         : " + vo.getBbsTycd());
        LOGGER.debug("dfltLangCd        : " + vo.getBbsBscLangCd());
        LOGGER.debug("menuCd            : " + vo.getMenuCd());
        LOGGER.debug("mainImgFileSn     : " + vo.getMnImgFileId());
        LOGGER.debug("sysUseYn          : " + vo.getSysUseYn());
        LOGGER.debug("sysDefaultYn      : " + vo.getSysDefaultYn());
        LOGGER.debug("writeUseYn        : " + vo.getWriteUseYn());
        LOGGER.debug("cmntUseYn         : " + vo.getCmntUseYn());
        LOGGER.debug("ansrUseYn         : " + vo.getAnsrUseYn());
        LOGGER.debug("notiUseYn         : " + vo.getNotiUseYn());
        LOGGER.debug("goodUseYn         : " + vo.getGoodUseYn());
        LOGGER.debug("atchUseYn         : " + vo.getAtflUseyn());
        LOGGER.debug("atchFileCnt       : " + vo.getAtflMaxCnt());
        LOGGER.debug("atchFileSizeLimit : " + vo.getAtflMaxsz());
        LOGGER.debug("atchCvsnUseYn     : " + vo.getAtchCvsnUseYn());
        LOGGER.debug("editorUseYn       : " + vo.getEditorUseYn());
        LOGGER.debug("mobileUseYn       : " + vo.getMobileUseYn());
        LOGGER.debug("secrtAtclUseYn    : " + vo.getSecrtAtclUseYn());
        LOGGER.debug("viwrUseYn         : " + vo.getViwrUseYn());
        LOGGER.debug("nmbrViewYn        : " + vo.getNmbrViewYn());
        LOGGER.debug("nmbrCreYn         : " + vo.getNmbrCreYn());
        LOGGER.debug("headUseYn         : " + vo.getHeadUseYn());
        LOGGER.debug("listViewCnt       : " + vo.getListCnt());
        LOGGER.debug("useYn             : " + vo.getUseYn());
        LOGGER.debug("delYn             : " + vo.getDelyn());
        LOGGER.debug("lockUseYn         : " + vo.getLockUseYn());
        LOGGER.debug("stdViewYn         : " + vo.getStdViewYn());

        String bbsId = IdGenerator.getNewId("BBS");
        vo.setBbsId(bbsId);

        if("PHOTO".equals(StringUtil.nvl(bbsCd))) {
            vo.setBbsTycd("ALBUM");
        } else {
            vo.setBbsTycd("BOARD");
        }

        bbsInfoDAO.insertBbsInfo(vo);

        // 게시판 언어 저장
        BbsInfoLangVO bbsInfoLangVO = new BbsInfoLangVO();
        bbsInfoLangVO.setBbsId(bbsId);
        bbsInfoLangVO.setLangCd(vo.getBbsBscLangCd());
        bbsInfoLangVO.setBbsNm(vo.getBbsnm());
        bbsInfoLangVO.setBbsDesc(vo.getBbsExpln());
        bbsInfoLangDAO.updateBbsInfoLang(bbsInfoLangVO);

        // 강의실 게시판 연결
        if(ValidationUtils.isNotEmpty(crsCreCd)) {
            BbsRltnVO bbsRltnVO = new BbsRltnVO();
            bbsRltnVO.setBbsId(bbsId);
            bbsRltnVO.setRltnRefCd(crsCreCd);
            bbsRltnVO.setRltnType("COURSE");
            bbsRltnDAO.insertBbsRltn(bbsRltnVO);
        }
    }

    /*****************************************************
     * 게시판 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void updateBbsInfo(BbsVO vo) throws Exception {
        String bbsCd = vo.getBbsId();

        LOGGER.debug("bbsId             : " + vo.getBbsId());
        LOGGER.debug("orgId             : " + vo.getOrgId());
        LOGGER.debug("bbsCd             : " + vo.getBbsId());
        LOGGER.debug("bbsNm             : " + vo.getBbsnm());
        LOGGER.debug("bbsDesc           : " + vo.getBbsExpln());
        LOGGER.debug("bbsTypeCd         : " + vo.getBbsTycd());
        LOGGER.debug("dfltLangCd        : " + vo.getBbsBscLangCd());
        LOGGER.debug("menuCd            : " + vo.getMenuCd());
        LOGGER.debug("mainImgFileSn     : " + vo.getMnImgFileId());
        LOGGER.debug("sysUseYn          : " + vo.getSysUseYn());
        LOGGER.debug("sysDefaultYn      : " + vo.getSysDefaultYn());
        LOGGER.debug("writeUseYn        : " + vo.getWriteUseYn());
        LOGGER.debug("cmntUseYn         : " + vo.getCmntUseYn());
        LOGGER.debug("ansrUseYn         : " + vo.getAnsrUseYn());
        LOGGER.debug("notiUseYn         : " + vo.getNotiUseYn());
        LOGGER.debug("goodUseYn         : " + vo.getGoodUseYn());
        LOGGER.debug("atchUseYn         : " + vo.getAtflUseyn());
        LOGGER.debug("atchFileCnt       : " + vo.getAtflMaxCnt());
        LOGGER.debug("atchFileSizeLimit : " + vo.getAtflMaxsz());
        LOGGER.debug("atchCvsnUseYn     : " + vo.getAtchCvsnUseYn());
        LOGGER.debug("editorUseYn       : " + vo.getEditorUseYn());
        LOGGER.debug("mobileUseYn       : " + vo.getMobileUseYn());
        LOGGER.debug("secrtAtclUseYn    : " + vo.getSecrtAtclUseYn());
        LOGGER.debug("viwrUseYn         : " + vo.getViwrUseYn());
        LOGGER.debug("nmbrViewYn        : " + vo.getNmbrViewYn());
        LOGGER.debug("nmbrCreYn         : " + vo.getNmbrCreYn());
        LOGGER.debug("headUseYn         : " + vo.getHeadUseYn());
        LOGGER.debug("listViewCnt       : " + vo.getListCnt());
        LOGGER.debug("useYn             : " + vo.getUseYn());
        LOGGER.debug("delYn             : " + vo.getDelyn());
        LOGGER.debug("lockUseYn         : " + vo.getLockUseYn());
        LOGGER.debug("stdViewYn         : " + vo.getStdViewYn());

        if("PHOTO".equals(StringUtil.nvl(bbsCd))) {
            vo.setBbsTycd("ALBUM");
        } else {
            vo.setBbsTycd("BOARD");
        }

        bbsInfoDAO.updateBbsInfo(vo);

        // 게시판 언어 저장
        BbsInfoLangVO bbsInfoLangVO = new BbsInfoLangVO();
        bbsInfoLangVO.setBbsId(vo.getBbsId());
        bbsInfoLangVO.setLangCd(vo.getBbsBscLangCd());
        bbsInfoLangVO.setBbsNm(vo.getBbsnm());
        bbsInfoLangVO.setBbsDesc(vo.getBbsExpln());
        bbsInfoLangDAO.updateBbsInfoLang(bbsInfoLangVO);
    }

    /*****************************************************
     * 게시판 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteBbsInfo(BbsVO vo) throws Exception {
        bbsInfoDAO.deleteBbsInfo(vo);
    }

    /*****************************************************
     * 게시판 사용여부 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void updateBbsInfoUseYn(BbsVO vo) throws Exception {
        bbsInfoDAO.updateBbsInfoUseYn(vo);
    }

    /*****************************************************
     * 게시판 학생 공개 여부 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsInfoStdViewYn(BbsVO vo) throws Exception {
        bbsInfoDAO.updateBbsInfoStdViewYn(vo);
    }

    /*****************************************************
     * 게시판 강의실 탭
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listBbsInfoCourseTab(HttpServletRequest request) throws Exception {
        Locale locale   = LocaleUtil.getLocale(request);
        String langCd   = SessionInfo.getLocaleKey(request);
        String orgId    = SessionInfo.getOrgId(request);
        String crsCreCd = request.getParameter("crsCreCd");
        String bbsId    = request.getParameter("bbsId");
        String bbsCd    = request.getParameter("bbsCd");

        EgovMap egovMap = new EgovMap();
        egovMap.put("orgId", orgId);
        egovMap.put("crsCreCd", crsCreCd);
        egovMap.put("langCd", langCd);
        egovMap.put("bbsId", bbsId);
        egovMap.put("bbsCd", bbsCd);

        List<EgovMap> list;

        if("ALARM".equals(StringUtil.nvl(bbsCd))) {
            egovMap.put("bbsId", CommConst.BBS_ID_SYSTEM_NOTICE);
            list = bbsInfoDAO.listBbsInfoCourseAlarmTab(egovMap);
        } else {
            if("TEAM".equals(StringUtil.nvl(bbsCd))) {
                egovMap.put("bbsId", null);
                list = bbsInfoDAO.listBbsInfoCourseTab(egovMap);

                List<EgovMap> returnList = new ArrayList<>();
                String[] bbsIds = new String[list.size()];
                int i = 0;
                long totalCnt = 0;

                for(EgovMap row : list) {
                    bbsIds[i++] = (String) row.get("bbsId");
                    totalCnt += (long) row.get("totalCnt");
                }

                EgovMap teamInfo = new EgovMap();
                teamInfo.put("bbsId", String.join(",", bbsIds));
                teamInfo.put("bbsCd", "TEAM");
                teamInfo.put("bbsNm", messageSource.getMessage("bbs.label.bbs_team", null, locale));
                teamInfo.put("totalCnt", totalCnt);

                returnList.add(teamInfo);

                list = returnList;
            } else {
                list = bbsInfoDAO.listBbsInfoCourseTab(egovMap);
            }
        }

        return list;
    }

    /*****************************************************
     * 게시판 강의실 학생 강의공지 탭
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listBbsInfoCourseStudentTab(BbsVO vo) throws Exception {
        return bbsInfoDAO.listBbsInfoCourseStudentTab(vo);
    }

    /*****************************************************
     * 게시판 선택된 탭 조회
     * @param vo
     * @return String
     * @throws Exception
     ******************************************************/
    @Override
    public String getSelectedTab(HttpServletRequest request, List<EgovMap> tabList) throws Exception {
        String tab = request.getParameter("tab");
        String bbsId = request.getParameter("bbsId");
        String bbsCd = request.getParameter("bbsCd");

        if("ALARM".equals(bbsCd)) {
            if(ValidationUtils.isEmpty(tab)) {
                if("".equals(StringUtil.nvl(bbsId)) || tabList.size() == 1) {
                    tab = "0";
                } else {
                    for(int i = tabList.size() - 1; i >= 0; i--) {
                        String bbsIds = (String) tabList.get(i).get("bbsId");

                        if(bbsIds.contains(bbsId)) {
                            tab = String.valueOf(i);
                            break;
                        }
                    }
                }
            }
        } else {
            tab = StringUtil.nvl(tab, "0");
        }

        return tab;
    }

    /*****************************************************
     * 게시판 상담교수 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listBbsInfoCouncelProf(BbsVO vo) throws Exception {
        return bbsInfoDAO.listBbsInfoCouncelProf(vo);
    }

    /*****************************************************
     * 게시판 분반 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listBbsInfoDecls(BbsVO vo) throws Exception {
        return bbsInfoDAO.listBbsInfoDecls(vo);
    }

    /*****************************************************
     * 게시판 문의, 상담 현황 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listQnaSecretCountByLsnOdr(BbsVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();

        // 주차 목록 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        List<LessonScheduleVO> lessonScheduleList = lessonScheduleService.list(lessonScheduleVO);

        String midLessonScheduleId = "";
        String finalLessonScheduleId = "";

        for(LessonScheduleVO lessonScheduleVO2 : lessonScheduleList) {
            if("M".equals(StringUtil.nvl(lessonScheduleVO2.getExamStareTypeCd()))) {
                midLessonScheduleId = lessonScheduleVO2.getLessonScheduleId();
            }

            if("L".equals(StringUtil.nvl(lessonScheduleVO2.getExamStareTypeCd()))) {
                finalLessonScheduleId = lessonScheduleVO2.getLessonScheduleId();
            }
        }

        // 시험 주차 체크
        List<EgovMap> list = bbsInfoDAO.listQnaSecretCountByLsnOdr(vo);

        for(EgovMap egovMap : list) {
            String lessonScheduleIdMin = egovMap.get("lessonScheduleIdMin").toString();
            String lessonScheduleIdMax = egovMap.get("lessonScheduleIdMax").toString();

            if(lessonScheduleIdMin.equals(midLessonScheduleId)) {
                egovMap.put("examStareTypeCdMin", "M");
            } else if(lessonScheduleIdMin.equals(finalLessonScheduleId)) {
                egovMap.put("examStareTypeCdMin", "L");
            }

            if(lessonScheduleIdMax.equals(midLessonScheduleId)) {
                egovMap.put("examStareTypeCdMax", "M");
            } else if(lessonScheduleIdMax.equals(finalLessonScheduleId)) {
                egovMap.put("examStareTypeCdMax", "L");
            }
        }

        return list;
    }

    /*****************************************************
     * 팀 게시판 등록
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    @Override
    public BbsVO insertTeamBbs(BbsVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String rgtrId = vo.getRgtrId();
        String teamCd = vo.getTeamCd();
        String langCd = "ko";

        if(ValidationUtils.isEmpty(orgId) || ValidationUtils.isEmpty(rgtrId) || ValidationUtils.isEmpty(teamCd)) {
            LOGGER.debug("orgId             : " + orgId);
            LOGGER.debug("rgtrId             : " + rgtrId);
            LOGGER.debug("teamCd            : " + teamCd);
            throw processException("필수값 입력");
        }

        TeamVO teamVO = new TeamVO();
        teamVO.setTeamCd(teamCd);
        teamVO = teamService.select(teamVO);

        String teamBbsNm = teamVO.getTeamNm() + " 게시판";

        String bbsId = IdGenerator.getNewId("BBS");

        BbsVO bbsVO = new BbsVO();
        bbsVO.setBbsId(bbsId);
        bbsVO.setOrgId(orgId);
        bbsVO.setBbsId("TEAM");
        bbsVO.setBbsnm(teamBbsNm);
        bbsVO.setBbsTycd("BOARD");
        bbsVO.setBbsBscLangCd(langCd);
        bbsVO.setSysUseYn("N");
        bbsVO.setSysDefaultYn("N");
        bbsVO.setWriteUseYn("Y");   // 학생 글쓰기 여부
        bbsVO.setCmntUseYn("Y");    // 댓글 사용여부
        bbsVO.setAnsrUseYn("N");    // 답글 사용여부
        bbsVO.setNotiUseYn("N");    // 공지 사용여부
        bbsVO.setGoodUseYn("N");    // 좋아요 사용여부
        bbsVO.setAtflUseyn("Y");    // 첨부파일 사용여부
        bbsVO.setAtflMaxCnt(3);    // 첨부파일 최대수
        bbsVO.setAtflMaxsz(1000);
        bbsVO.setHeadUseYn("N");    // 말머리 사용여부
        bbsVO.setUseYn("Y");
        bbsVO.setLockUseYn("Y");    // 비밀글 사용여부
        bbsVO.setRgtrId(rgtrId);

        bbsInfoDAO.insertBbsInfo(bbsVO);

        // 게시판 언어 저장
        BbsInfoLangVO bbsInfoLangVO = new BbsInfoLangVO();
        bbsInfoLangVO.setBbsId(bbsId);
        bbsInfoLangVO.setLangCd(langCd);
        bbsInfoLangVO.setBbsNm(teamBbsNm);
        bbsInfoLangVO.setBbsDesc(null);
        bbsInfoLangDAO.updateBbsInfoLang(bbsInfoLangVO);

        // 팀 게시판 연결
        BbsRltnVO bbsRltnVO = new BbsRltnVO();
        bbsRltnVO.setBbsId(bbsId);
        bbsRltnVO.setRltnRefCd(teamCd);
        bbsRltnVO.setRltnType("TEAM");
        bbsRltnDAO.insertBbsRltn(bbsRltnVO);

        return bbsVO;
    }

    /*****************************************************
     * 게시판 팀 카테고리 목록
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<BbsVO> listBbsInfoTeamCtgr(BbsVO vo) throws Exception {
        return bbsInfoDAO.listBbsInfoTeamCtgr(vo);
    }

    /*****************************************************
     * 게시판 팀 목록
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<BbsVO> listTeamBbsId(BbsVO vo) throws Exception {
        return bbsInfoDAO.listTeamBbsId(vo);
    }

    /*****************************************************
     * 팀 게시판 조회
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    public BbsVO selectTeamBbsInfo(BbsVO vo) throws Exception {
        return bbsInfoDAO.selectTeamBbsInfo(vo);
    }

    /*****************************************************
     * 게시판 팀원여부 체크
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int countTeamBbsMember(EgovMap vo) throws Exception {
        return bbsInfoDAO.countTeamBbsMember(vo);
    }

    /*****************************************************
     * 게시판 코드별 생성일 빠른 게시판 조회
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    @Override
    public BbsVO selectBbsInfoByOldRegDttm(BbsVO vo) throws Exception {
        return bbsInfoDAO.selectBbsInfoByOldRegDttm(vo);
    }


    /*
    TODO 새로 생성되거나 명칭 변경해서 작업하는 메쏘드는 여기 아래에......
    */



    /*****************************************************
     * 게시판 조회
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    @Override
    public BbsVO selectBbs(BbsVO vo) throws Exception {
        return bbsInfoDAO.selectBbs(vo);
    }

    /*****************************************************
     * 게시판 정보 조회
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    @Override
    public BbsVO isValidBbsInfo(BbsVO vo, boolean isAdmin) throws Exception {
    	vo.setSysUseYn("Y"); // 시스템 게시판 여부

        if (!isAdmin) {
        	vo.setUseYn("Y");
        }

        BbsVO resultVO = bbsInfoDAO.selectBbs(vo);

        return resultVO;
    }

    /*****************************************************
     * 게시판 정보 조회_강의실
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    @Override
    public BbsVO isValidBbsLectInfo(BbsVO vo, boolean isStudent) throws Exception {
    	vo.setSysUseYn("Y"); // 시스템 게시판 여부

        if (!isStudent) {
        	vo.setUseYn("Y");
        }

        BbsVO resultVO = bbsInfoDAO.selectBbsLect(vo);

        return resultVO;
    }

    /*****************************************************
     * 게시판 정보 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void bbsInfoRegist(BbsVO vo) throws Exception {
    	String bbsId = vo.getBbsId();

    	if(bbsId == null) {
    		bbsId = IdGenerator.getNewId("BBS");
    		vo.setBbsId(bbsId);
    	}

    	bbsInfoDAO.bbsInfoRegist(vo);
    }

    /*****************************************************
     * 게시판 정보 옵션 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void bbsInfoOptnRegist(BbsVO vo) throws Exception {
        List<String> optnList = vo.getOptnCdList();

        if (optnList != null) {
            for (String optnCd : optnList) {
                String bbsOptnId = IdGenerator.getNewId("BBOPT");
                vo.setBbsOptnId(bbsOptnId);
                vo.setOptnCd(optnCd);

                bbsInfoDAO.bbsInfoOptnRegist(vo);
            }
        }
    }


    /*****************************************************
     * 강의실 메뉴의 게시판 목록 조회
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<BbsVO> selectBbsForSbjctMenu(BbsVO vo) throws Exception {
    	return bbsInfoDAO.selectBbsForSbjctMenu(vo);
    }

    /*****************************************************
     * 게시판 목록 페이징
     * @param vo
     * @return ProcessResultVO<BbsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<BbsVO> bbsMngList(BbsVO vo) throws Exception {
        ProcessResultVO<BbsVO> processResultVO = new ProcessResultVO<>();

        // 페이지 정보 설정
        PageInfo pageInfo = new PageInfo(vo);

        List<BbsVO> resultList = bbsInfoDAO.listBbsMngInfoPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(pageInfo);

        return processResultVO;
    }

    /*****************************************************
     * 게시판 정보 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void bbsMngInfoRegist(BbsVO vo) throws Exception {

    	// 게시판 추가
    	String bbsId = vo.getBbsId();
    	String bbsOptnId = vo.getBbsOptnId();

    	if(bbsId == null) {
    		bbsId = IdGenerator.getNewId("BBS");
    	}
        vo.setBbsId(bbsId);

        bbsInfoDAO.bbsMngInfoRegist(vo);

        // 게시판 옵션 추가
        List<String> optnList = new ArrayList<>();
        if (vo.getOptnCd() != null && !vo.getOptnCd().isEmpty()) {
            optnList = new ArrayList<>(Arrays.asList(vo.getOptnCd().split(",")));
        }

        bbsInfoDAO.bbsMngInfoOptnDelete(vo); // 게시판 옵션 삭제

        if (optnList != null) {
            for (String optnCd : optnList) {
            	bbsOptnId = IdGenerator.getNewId("BBOPT");

            	vo.setBbsId(bbsId);
                vo.setBbsOptnId(bbsOptnId);
                vo.setOptnCd(optnCd);

                bbsInfoDAO.bbsMngInfoOptnRegist(vo);
            }
        }

		/*
		 * if("PHOTO".equals(StringUtil.nvl(bbsCd))) { vo.setBbsTycd("ALBUM"); } else {
		 * vo.setBbsTycd("BOARD"); }
		 */
        // 게시판 언어 저장
		/*
		 * BbsInfoLangVO bbsInfoLangVO = new BbsInfoLangVO();
		 * bbsInfoLangVO.setBbsId(bbsId); bbsInfoLangVO.setLangCd(vo.getBbsBscLangCd());
		 * bbsInfoLangVO.setBbsNm(vo.getBbsnm());
		 * bbsInfoLangVO.setBbsDesc(vo.getBbsExpln());
		 * bbsInfoLangDAO.updateBbsInfoLang(bbsInfoLangVO);
		 */

        // 강의실 게시판 연결
		/*
		 * if(ValidationUtils.isNotEmpty(crsCreCd)) { BbsRltnVO bbsRltnVO = new
		 * BbsRltnVO(); bbsRltnVO.setBbsId(bbsId); bbsRltnVO.setRltnRefCd(crsCreCd);
		 * bbsRltnVO.setRltnType("COURSE"); bbsRltnDAO.insertBbsRltn(bbsRltnVO); }
		 */
    }

    @Override
    public String getBbsTycd(BbsVO vo) throws Exception {
    	return bbsInfoDAO.getBbsTycd(vo);
    }

    @Override
    public String getBbsId(BbsVO vo) throws Exception {
    	return bbsInfoDAO.getBbsId(vo);
    }

    /**
     * 토론성적공개여부 수정
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<BbsVO> modifyBbsUseyn(BbsVO vo) throws Exception {
        ProcessResultVO<BbsVO> resultVO = new ProcessResultVO<>();

        int affected = bbsInfoDAO.modifyBbsUseyn(vo);
        if (affected > 0) {
            resultVO.setReturnVO(vo);
            resultVO.setResultSuccess();
        } else {
            resultVO.setResultFailed("update target not found");
        }

        return resultVO;
    }

    /*****************************************************
     * 학습그룹 목록 조회
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<BbsVO> listTeamGrp(BbsVO vo) throws Exception {
    	return bbsInfoDAO.listTeamGrp(vo);
    }

    /*****************************************************
     * 학습그룹 팀 목록 조회
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<BbsVO> listLrnTeam(BbsVO vo) throws Exception {
    	return bbsInfoDAO.listLrnTeam(vo);
    }

    /*****************************************************
     * 과제 목록 조회
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<BbsVO> listLrnElemtList(BbsVO vo) throws Exception {
    	return bbsInfoDAO.listLrnElemtList(vo);
    }

    @Override
    public List<BbsAtclVO> listWkno(BbsAtclVO vo) throws Exception {
    	return bbsInfoDAO.listWkno(vo);
    }

    /*****************************************************
     * 교수 운영 학기 목록을 조회한다.
     * @param ClsVO
     * @return List<SmstrChrtVO>
     ******************************************************/
    @Override
    public List<SmstrChrtVO> selectBbsTermList(BbsVO vo) {
        return bbsInfoDAO.selectBbsTermList(vo);
    }

    /*****************************************************
     * 교수 운영 기관 목록을 조회한다.
     * @param ClsVO
     * @return List<OrgInfoVO>
     ******************************************************/
    @Override
    public List<OrgInfoVO> selectBbsOrgList(BbsVO vo) {
        return bbsInfoDAO.selectBbsOrgList(vo);
    }

    /*****************************************************
     * 운영과목 드롭다운 목록을 조회한다.
     * @param ClsVO
     * @return List<ClsVO>
     ******************************************************/
    @Override
    public List<BbsVO> selectBbsSubjectList(BbsVO vo) {
        return bbsInfoDAO.selectBbsSubjectList(vo);
    }
}