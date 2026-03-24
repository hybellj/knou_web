package knou.lms.exam.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.*;
import knou.framework.vo.FileVO;
import knou.lms.asmt.dao.AsmtProDAO;
import knou.lms.asmt.service.AsmtProService;
import knou.lms.asmt.vo.AsmtVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.dao.*;
import knou.lms.exam.service.ExamService;
import knou.lms.exam.vo.*;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.forum.dao.ForumDAO;
import knou.lms.forum.service.ForumService;
import knou.lms.forum.vo.ForumVO;
import knou.lms.lesson.dao.LessonScheduleDAO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.std.dao.StdDAO;
import knou.lms.std.vo.StdVO;
import knou.lms.team.dao.TeamDAO;
import knou.lms.team.vo.TeamVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service("examService")
public class ExamServiceImpl extends ServiceBase implements ExamService {

    @Resource(name="examDAO")
    private ExamDAO examDAO;

    @Resource(name="examStareDAO")
    private ExamStareDAO examStareDAO;

    @Resource(name="examStareHstyDAO")
    private ExamStareHstyDAO examStareHstyDAO;

    @Resource(name="examStarePaperDAO")
    private ExamStarePaperDAO examStarePaperDAO;

    @Resource(name="examStarePaperHstyDAO")
    private ExamStarePaperHstyDAO examStarePaperHstyDAO;

    @Resource(name="examQstnDAO")
    private ExamQstnDAO examQstnDAO;

    @Resource(name="stdDAO")
    private StdDAO stdDAO;

    @Resource(name="forumDAO")
    private ForumDAO forumDAO;

    @Resource(name="asmtProDAO")
    private AsmtProDAO asmntDAO;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    @Autowired
    private SysFileService sysFileService;

    @Autowired
    private AsmtProService asmntService;

    @Autowired
    private ForumService forumService;

    @Resource(name="lessonScheduleDAO")
    private LessonScheduleDAO lessonScheduleDAO;

    @Resource(name="teamDAO")
    private TeamDAO teamDAO;

    @Resource(name="attachFileService")
    private AttachFileService attachFileService;

    /*****************************************************
     * 신규 작성 Service 영역
     *****************************************************/

    /*****************************************************
     * 시험 등록
     * @param vo
     * @throws Exception
     ******************************************************/
    public ExamBscVO examRegist(ExamBscVO vo) throws Exception {
        String bscId = IdGenUtil.genNewId(IdPrefixType.EXBSC);  // 시험 기본 ID 생성

        vo.setExamBscId(bscId);
        vo.getExamDtlVO().setExamBscId(vo.getExamBscId());
        vo.getExamDtlVO().setExamtmLmtyn("Y");  // 시험시간 제한여부    (임시)
        vo.getExamDtlVO().setCnsdrAddMnts(0);   // 배려 추가시간       (임시)
        vo.getExamDtlVO().setReexamyn("N");     // 재시험 가능여부     (임시)

        // 1. 팀 여부 분기
        switch (vo.getByteamSubrexamUseyn()) {
            // case 1. 팀 시험일 경우 - 시험상세 등록 & 시험 대상자 등록
            case "Y":
                // 구분 코드를 팀 구분 코드로 변경
                switch (vo.getExamGbncd()) {
                    case "EXAM_MID": vo.setExamGbncd("EXAM_MID_TEAM"); break;   // 팀 중간고사
                    case "EXAM_LST": vo.setExamGbncd("EXAM_LST_TEAM"); break;   // 팀 기말고사
                    case "EXAM":     vo.setExamGbncd("EXAM_TEAM");     break;   // 팀 시험
                    case "EXAM_CMP": vo.setExamGbncd("EXAM_CMP_TEAM"); break;   // 팀 종합시험 (졸업시험)
                }
                // 2. 시험기본 등록 (BSC)
                examDAO.examBscRegist2(vo);

                vo.getLrnGrpIds().removeIf(item -> "".equals(item));	// 빈 값 제거
                Map<Object, Map<String, Object>> idMap = vo.getExamDtlVO().getDtlInfos().stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));

                for(String lrnGrp : vo.getLrnGrpIds()) {
                    if(lrnGrp.split(":")[1].equals(vo.getSbjctId())) {
                        TeamVO teamVO = new TeamVO();
                        teamVO.setTeamCtgrCd(lrnGrp.split(":")[0]);
                        List<TeamVO> teamList = teamDAO.list(teamVO);    // 팀 목록 조회
                        for (TeamVO team : teamList) {
                            vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL)); // 시험 상세 ID 생성
                            Map<String, Object> target = idMap.get(team.getTeamId());    // 팀아이디로 조회
                            if (target != null) {
                                // 학습그룹별 시험 설정 [O] - 시험지 + 주제가 다름
                                vo.getExamDtlVO().setExamTtl((String) target.get("ttl"));
                                vo.getExamDtlVO().setExamCts((String) target.get("cts"));
                            } else {
                                // 학습그룹별 시험 설정 [X] - 주제는 같지만 시험지가 다름
                                vo.getExamDtlVO().setExamTtl(vo.getExamTtl());
                                vo.getExamDtlVO().setExamCts(vo.getExamCts());
                            }

                            examDAO.examDtlRegist(vo.getExamDtlVO());	// 시험 상세 등록

                            // 시험 대상자 등록에 사용할 param 생성
                            ExamTrgtrVO trgtr = new ExamTrgtrVO();
                            trgtr.setExamTrgtrId(IdGenUtil.genNewId(IdPrefixType.EXTGT));   // 시험 대상자 ID 생성
                            trgtr.setTeamId(team.getTeamId());
                            trgtr.setExamDtlId(vo.getExamDtlVO().getExamDtlId());
                            trgtr.setRgtrId(vo.getRgtrId());

                            examDAO.examTrgtrRegist(trgtr);		// 시험 대상자 등록
                        }
                    }
                }
                break;
            // case 2. 팀 시험이 아닐 경우 - 시험 상세만 등록
            case "N":
                vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL));
                // 2. 시험기본 등록 (BSC)
                examDAO.examBscRegist2(vo);
                examDAO.examDtlRegist(vo.getExamDtlVO());
                break;
        }
        vo.setExamBscId(bscId);
        return vo;
    }

    /*****************************************************
     * 교수 시험목록 페이징
     * @param vo
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamVO> listProfExamPaging(ExamVO vo) throws Exception{
        ProcessResultVO<ExamVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = examDAO.countProfExam(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<ExamVO> resultList = examDAO.listProfExamPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 교수 시험 상세조회
     * @param vo
     * @throws Exception
     ******************************************************/
    public ExamVO selectProfExamDtl(ExamVO vo) throws Exception {
        return examDAO.selectProfExamDtl(vo);
    }

    /*****************************************************
     * 교수 팀 시험 상세조회
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamVO> selectProfExamTeamDtl(ExamVO vo) throws Exception {
        return examDAO.selectProfExamTeamDtl(vo);
    }

    /*****************************************************
     * 팀 시험 평가대상자 목록 페이징
     * @param vo
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamVO> listTkexamTeamUserPaging(ExamVO vo) throws Exception{
        ProcessResultVO<ExamVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = examDAO.countTkexamTeamUser(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<ExamVO> resultList = examDAO.listTkexamTeamUserPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 시험 평가대상자 목록 페이징
     * @param vo
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamVO> listTkexamUserPaging(ExamVO vo) throws Exception{
        ProcessResultVO<ExamVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = examDAO.countTkexamUser(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<ExamVO> resultList = examDAO.listTkexamUserPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 팀 시험 평가대상자 인원 수 조회
     * @param vo
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @Override
    public int countTkexamTeamUser(ExamVO vo) throws Exception{
        int totCnt = examDAO.countTkexamTeamUser(vo);
        return totCnt;
    }

    /*****************************************************
     * 시험 평가대상자 인원 수 조회
     * @param vo
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @Override
    public int countTkexamUser(ExamVO vo) throws Exception{
        int totCnt = examDAO.countTkexamUser(vo);
        return totCnt;
    }

    /*****************************************************
     * 성적 공개여부 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateMrkOyn(ExamVO vo) throws Exception{
        examDAO.updateMrkOyn(vo);
    }

    /*****************************************************
     * 시험 성적 반영비율 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void examMrkRfltrtListModify(List<ExamBscVO> list) throws Exception {
        examDAO.examMrkRfltrtListModify(list);
    }

    /*****************************************************
     * 시험 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateExamDtlInfo(ExamVO vo) throws Exception {
        // 기존 시험의 팀 여부 조회
        ExamVO examTeamYn = examDAO.selectBscTeamYn(vo);

        switch (examTeamYn.getByteamSubrexamUseyn()) {
            // Case A. 기존 데이터가 팀 시험이 아닐 경우
            case "N":
                if (vo.getByteamSubrexamUseyn().equals(examTeamYn.getByteamSubrexamUseyn())) {
                    // Case A-a. 둘 다 동일할 경우 (일반 시험 -> 일반 시험)
                    // Case A-a-1. BSC 수정
                    examDAO.updateExamBscInfo(vo);

                    // Case A-a-2. DTL 수정
                    vo.setExamMnts(vo.getExamDtlVO().getExamMnts());
                    vo.setExamPsblSdttm(vo.getExamDtlVO().getExamPsblSdttm());
                    vo.setExamPsblEdttm(vo.getExamDtlVO().getExamPsblEdttm());
                    examDAO.updateExamDtlInfo(vo);
                } else {
                    // Case A-b. 다를 경우 (일반 시험 -> 팀 시험)
                    // Case A-b-1. 구분 코드를 팀 구분 코드로 변경
                    switch (vo.getExamGbncd()) {
                        case "EXAM_MID": vo.setExamGbncd("EXAM_MID_TEAM"); break;   // 팀 중간고사
                        case "EXAM_LST": vo.setExamGbncd("EXAM_LST_TEAM"); break;   // 팀 기말고사
                        case "EXAM":     vo.setExamGbncd("EXAM_TEAM");     break;   // 팀 시험
                        case "EXAM_CMP": vo.setExamGbncd("EXAM_CMP_TEAM"); break;   // 팀 종합시험 (졸업시험)
                    }
                    // Case A-b-2. BSC 수정
                    examDAO.updateExamBscInfo(vo);

                    // Case A-b-3. 기존 DTL 전부 삭제 (BSC ID로)
                    examDAO.deleteExamDtlInfo(vo);

                    // Case A-b-4. 학습 그룹 ID 추출 및 조회
                    vo.getLrnGrpIds().removeIf(item -> "".equals(item));	// 빈 값 제거
                    Map<Object, Map<String, Object>> idMap = vo.getExamDtlVO().getDtlInfos().stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
                    for(String lrnGrp : vo.getLrnGrpIds()) {
                        if(lrnGrp.split(":")[1].equals(vo.getSbjctId())) {
                            TeamVO teamVO = new TeamVO();
                            teamVO.setTeamCtgrCd(lrnGrp.split(":")[0]);   // lrnGrpIds:sbjctId 에서 그룹 ID 추출
                            List<TeamVO> teamList = teamDAO.list(teamVO);       // 팀 목록 조회
                            // Case A-b-5. 조회한 팀 목록 수 만큼 for 문 실행
                            for (TeamVO team : teamList) {
                                vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL)); // 시험 상세 ID 생성
                                vo.getExamDtlVO().setExamBscId(vo.getExamBscId());
                                Map<String, Object> target = idMap.get(team.getTeamId());
                                if (target != null) {
                                    // 학습그룹별 시험 설정 [O] - 시험지 + 주제가 다름
                                    vo.getExamDtlVO().setExamTtl((String) target.get("ttl"));
                                    vo.getExamDtlVO().setExamCts((String) target.get("cts"));
                                } else {
                                    // 학습그룹별 시험 설정 [X] - 주제는 같지만 시험지가 다름
                                    vo.getExamDtlVO().setExamTtl(vo.getExamTtl());
                                    vo.getExamDtlVO().setExamCts(vo.getExamCts());
                                }

                                // Case A-b-6. DTL 등록
                                examDAO.examDtlRegist2(vo.getExamDtlVO());	// 시험 상세 등록

                                // Case A-b-7. TRGTR 등록에 사용할 param 생성
                                ExamTrgtrVO trgtr = new ExamTrgtrVO();
                                trgtr.setExamTrgtrId(IdGenUtil.genNewId(IdPrefixType.EXTGT));   // 시험 대상자 ID 생성
                                trgtr.setTeamId(team.getTeamId());
                                trgtr.setExamDtlId(vo.getExamDtlVO().getExamDtlId());
                                trgtr.setRgtrId(vo.getRgtrId());
                                trgtr.setMdfrId(vo.getMdfrId());

                                // Case. A-b-8. TRGTR 등록
                                examDAO.examTrgtrRegist2(trgtr);		// 시험 대상자 등록
                            }
                        }
                    }
                }
                break;
            // Case B. 기존 데이터가 팀 시험일 경우
            case "Y":
                if (vo.getByteamSubrexamUseyn().equals(examTeamYn.getByteamSubrexamUseyn())) {
                    // Case B-a. 둘 다 동일할 경우 (팀 시험 -> 팀 시험)
                    // Case B-a-1. 구분 코드를 팀 구분 코드로 변경
                    switch (vo.getExamGbncd()) {
                        case "EXAM_MID": vo.setExamGbncd("EXAM_MID_TEAM"); break;   // 팀 중간고사
                        case "EXAM_LST": vo.setExamGbncd("EXAM_LST_TEAM"); break;   // 팀 기말고사
                        case "EXAM":     vo.setExamGbncd("EXAM_TEAM");     break;   // 팀 시험
                        case "EXAM_CMP": vo.setExamGbncd("EXAM_CMP_TEAM"); break;   // 팀 종합시험 (졸업시험)
                    }
                    // Case B-a-2. BSC 수정
                    examDAO.updateExamBscInfo(vo);

                    // Case B-a-3. 기존 TRGTR 삭제
                    examDAO.deleteExamTrgtr(vo);

                    // Case B-a-4. 기존 DTL 삭제
                    examDAO.deleteExamDtlInfo(vo);

                    // Case B-a-5. 학습 그룹 ID 추출 및 조회
                    vo.getLrnGrpIds().removeIf(item -> "".equals(item));	// 빈 값 제거
                    Map<Object, Map<String, Object>> idMap = vo.getExamDtlVO().getDtlInfos().stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
                    for(String lrnGrp : vo.getLrnGrpIds()) {
                        if(lrnGrp.split(":")[1].equals(vo.getSbjctId())) {
                            TeamVO teamVO = new TeamVO();
                            teamVO.setTeamCtgrCd(lrnGrp.split(":")[0]);   // lrnGrpIds:sbjctId 에서 그룹 ID 추출
                            List<TeamVO> teamList = teamDAO.list(teamVO);       // 팀 목록 조회
                            // Case B-a-6. 조회한 팀 목록 수 만큼 for 문 실행
                            for (TeamVO team : teamList) {
                                vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL)); // 시험 상세 ID 생성
                                vo.getExamDtlVO().setExamBscId(vo.getExamBscId());
                                Map<String, Object> target = idMap.get(team.getTeamId());
                                if (target != null) {
                                    // 학습그룹별 시험 설정 [O] - 시험지 + 주제가 다름
                                    vo.getExamDtlVO().setExamTtl((String) target.get("ttl"));
                                    vo.getExamDtlVO().setExamCts((String) target.get("cts"));
                                } else {
                                    // 학습그룹별 시험 설정 [X] - 주제는 같지만 시험지가 다름
                                    vo.getExamDtlVO().setExamTtl(vo.getExamTtl());
                                    vo.getExamDtlVO().setExamCts(vo.getExamCts());
                                }
                                // Case B-a-7. DTL 등록
                                examDAO.examDtlRegist2(vo.getExamDtlVO());	// 시험 상세 등록

                                // Case B-a-8. TRGTR 등록에 사용할 param 생성
                                ExamTrgtrVO trgtr = new ExamTrgtrVO();
                                trgtr.setExamTrgtrId(IdGenUtil.genNewId(IdPrefixType.EXTGT));   // 시험 대상자 ID 생성
                                trgtr.setTeamId(team.getTeamId());
                                trgtr.setExamDtlId(vo.getExamDtlVO().getExamDtlId());
                                trgtr.setRgtrId(vo.getRgtrId());
                                trgtr.setMdfrId(vo.getMdfrId());

                                // Case. B-a-9. TRGTR 등록
                                examDAO.examTrgtrRegist2(trgtr);		// 시험 대상자 등록
                            }
                        }
                    }
                } else {
                    // Case B-b. 다를 경우 (팀 시험 -> 일반 시험)
                    // Case B-b-1. 기존 TRGTR 전체 삭제
                    examDAO.deleteExamTrgtr(vo);

                    // Case B-b-2. 기존 DTL 전체 삭제
                    examDAO.deleteExamDtlInfo(vo);

                    // Case B-b-3. 신규 DTL 내용 등록
                    ExamDtlVO dtlVO = new ExamDtlVO();
                    dtlVO.setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL));
                    dtlVO.setExamBscId(vo.getExamBscId());
                    dtlVO.setExamTtl(vo.getExamTtl());
                    dtlVO.setExamCts(vo.getExamCts());
                    dtlVO.setExamMnts(vo.getExamDtlVO().getExamMnts());
                    dtlVO.setExamPsblSdttm(vo.getExamDtlVO().getExamPsblSdttm());
                    dtlVO.setExamPsblEdttm(vo.getExamDtlVO().getExamPsblEdttm());
                    dtlVO.setRgtrId(vo.getRgtrId());
                    dtlVO.setMdfrId(vo.getMdfrId());

                    examDAO.examDtlRegist2(dtlVO);

                    // Case B-b-4. BSC 수정
                    examDAO.updateExamBscInfo(vo);
                }
                break;
        }
    }

    /*****************************************************
     * 시험 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public void deleteExamBsc(ExamVO vo) throws Exception {
        // Case A. 팀 시험인 경우
        if ("Y".equals(vo.getByteamSubrexamUseyn())) {
            // A-1. 시험 대상자 삭제
            System.out.println("A-1. : deleteExamTrgtr");
            examDAO.deleteExamTrgtr(vo);

            // A-2. 시험 상세정보 삭제
            System.out.println("A-2. : deleteExamDtlInfo");
            examDAO.deleteExamDtlInfo(vo);

            // A-3. 시험 기본정보 삭제
            System.out.println("A-3. : deleteExamBscInfo");
            examDAO.deleteExamBscInfo(vo);
        } else {
            // Case B. 일반 시험인 경우
            // B-1. 시험 상세정보 삭제
            System.out.println("B-1. : deleteExamDtlInfo");
            examDAO.deleteExamDtlInfo(vo);

            // B-2. 시험 기본정보 삭제
            System.out.println("B-2. : deleteExamBscInfo");
            examDAO.deleteExamBscInfo(vo);
        }
    }

    /*****************************************************
     * 기존에 있던 Service 영역
     *****************************************************/
    /**
     * 교수퀴즈목록조회
     *
     * @param sbjctId 	과목아이디
     * @param searchValue  검색내용(퀴즈명)
     * @return 퀴즈목록 페이징
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> profQuizListPaging(ExamBscVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<EgovMap> quizList = examDAO.profQuizListPaging(vo);

        if(quizList.size() > 0) {
            paginationInfo.setTotalRecordCount(((BigDecimal)quizList.get(0).get("totalCnt")).intValue());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        resultVO.setReturnList(quizList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
    * 퀴즈정보조회
    *
    * @param examBscId 퀴즈기본아이디
    * @return 퀴즈 정보
    * @throws Exception
    */
    @Override
    public ExamBscVO quizSelect(ExamBscVO vo) throws Exception {
        ExamBscVO bscVO = examDAO.quizBscSelect(vo);	// 퀴즈기본 정보 조회
        if(bscVO != null) {
        	ExamDtlVO dtlVO = new ExamDtlVO();
        	dtlVO.setExamBscId(vo.getExamBscId());
        	if(vo.getExamDtlVO() != null) dtlVO.setExamDtlId(vo.getExamDtlVO().getExamDtlId());
            bscVO.setExamDtlVO(examDAO.quizDtlSelect(dtlVO));	// 퀴즈상세 정보 조회

            if(bscVO.getFileCnt() > 0) {
            	String examBscId = bscVO.getExamBscId();
            	FileVO fileVO = new FileVO();
            	fileVO.setRepoCd(CommConst.REPO_EXAM);
            	fileVO.setFileBindDataSn(examBscId);
            	ProcessResultVO<FileVO> resultVO = (ProcessResultVO<FileVO>) sysFileService.list(fileVO);

                List<FileVO> fileList = resultVO.getReturnList();
                bscVO.setFileList(fileList);
            }
        }

        return bscVO;
    }

    /**
    * 퀴즈등록
    *
    * @param ExamBscVO
    * @throws Exception
    */
    @Override
    public ExamBscVO quizRegist(ExamBscVO vo) throws Exception {
    	// 1. 퀴즈기본 등록
        vo.setExamBscId(IdGenUtil.genNewId(IdPrefixType.EXBSC));
        vo.getExamDtlVO().setExamBscId(vo.getExamBscId());
        if(vo.getLrnGrpSubasmtStngyns() != null) {
            vo.setLrnGrpSubasmtStngyn(vo.getLrnGrpSubasmtStngyns().stream().anyMatch(item -> item.contains(vo.getSbjctId())) ? "Y" : "N");
        } else {
            vo.setLrnGrpSubasmtStngyn("N");
        }
        examDAO.examBscRegist(vo);

        // 팀 퀴즈
        if("QUIZ_TEAM".equals(vo.getExamGbncd())) {
        	vo.getLrnGrpIds().removeIf(item -> "".equals(item));	// 빈 값 제거
            Map<Object, Map<String, Object>> idMap = vo.getExamDtlVO().getDtlInfos().stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
            for(String lrnGrp : vo.getLrnGrpIds()) {
                if(lrnGrp.split(":")[1].equals(vo.getSbjctId())) {
                    TeamVO teamVO = new TeamVO();
                    teamVO.setTeamCtgrCd(lrnGrp.split(":")[0]);
                    List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀 목록 조회
                    for(TeamVO team : teamList) {
                        vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL));
                        Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                        if(target != null) {
                            vo.getExamDtlVO().setExamTtl((String) target.get("ttl"));
                            vo.getExamDtlVO().setExamCts((String) target.get("cts"));
                        } else {
                            vo.getExamDtlVO().setExamTtl(vo.getExamTtl());
                            vo.getExamDtlVO().setExamCts(vo.getExamCts());
                        }
                        examDAO.examDtlRegist(vo.getExamDtlVO());	// 퀴즈상세 등록

                        ExamTrgtrVO trgtr = new ExamTrgtrVO();
                        trgtr.setExamTrgtrId(IdGenUtil.genNewId(IdPrefixType.EXTGT));
                        trgtr.setTeamId(team.getTeamId());
                        trgtr.setExamDtlId(vo.getExamDtlVO().getExamDtlId());
                        trgtr.setRgtrId(vo.getRgtrId());
                        examDAO.examTrgtrRegist(trgtr);		// 퀴즈대상자 등록
                    }
                }
            }
            // 등록 과목아이디 목록 삭제
            vo.getLrnGrpIds().removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
        // 일반 퀴즈
        } else {
            vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL));
            examDAO.examDtlRegist(vo.getExamDtlVO());	// 퀴즈상세 등록
        }

        if("QUIZ".equals(vo.getExamTycd())) {
            quizMrkRfltrtModify(vo);	// 퀴즈 성적반영비율 수정
        }

        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());

        // 첨부파일
        if (uploadFileList.size() > 0) {
        	for (AtflVO atflVO : uploadFileList) {
        		atflVO.setRefId(vo.getExamBscId());
        		atflVO.setRgtrId(vo.getRgtrId());
        		atflVO.setMdfrId(vo.getMdfrId());
        		atflVO.setAtflRepoId(CommConst.REPO_EXAM); // 첨부파일 저장소 아이디
        	}

        	// 첨부파일 저장
        	attachFileService.insertAtflList(uploadFileList);
        }

        // 분반 등록
        if("Y".equals(vo.getDvclasRegyn())) {
        	String examBscId = vo.getExamBscId();
            vo.getSbjctIds().removeIf(item -> item.equals(vo.getSbjctId()));	// 퀴즈등록 분반 목록 제거

            ExamGrpVO grpVO = new ExamGrpVO();
            grpVO.setExamGrpId(IdGenUtil.genNewId(IdPrefixType.EXGRP));
            grpVO.setExamGrpnm("퀴즈그룹");
            grpVO.setRgtrId(vo.getRgtrId());
            examDAO.examGrpRegist(grpVO); // 퀴즈그룹 등록
            vo.setExamGrpId(grpVO.getExamGrpId());
            vo.setMrkRfltrt(null);
            examDAO.examBscModify(vo);	// 퀴즈기본 수정

            for(String sbjctId : vo.getSbjctIds()) {
                vo.setExamBscId(IdGenUtil.genNewId(IdPrefixType.EXBSC));
                vo.setSbjctId(sbjctId);
                vo.getExamDtlVO().setExamBscId(vo.getExamBscId());
                if(vo.getLrnGrpSubasmtStngyns() != null) {
                    vo.setLrnGrpSubasmtStngyn(vo.getLrnGrpSubasmtStngyns().stream().anyMatch(item -> item.contains(sbjctId)) ? "Y" : "N");
                } else {
                    vo.setLrnGrpSubasmtStngyn("N");
                }
                examDAO.examBscRegist(vo);					// 퀴즈기본 등록

                // 팀 퀴즈
                if("QUIZ_TEAM".equals(vo.getExamGbncd())) {
                    Map<Object, Map<String, Object>> idMap = vo.getExamDtlVO().getDtlInfos().stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
                    for(String lrnGrp : vo.getLrnGrpIds()) {
                        if(lrnGrp.split(":")[1].equals(sbjctId)) {
                            TeamVO teamVO = new TeamVO();
                            teamVO.setTeamCtgrCd(lrnGrp.split(":")[0]);
                            List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀 목록 조회
                            for(TeamVO team : teamList) {
                                vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL));
                                Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                                if(target != null) {
                                    vo.getExamDtlVO().setExamTtl((String) target.get("ttl"));
                                    vo.getExamDtlVO().setExamCts((String) target.get("cts"));
                                } else {
                                    vo.getExamDtlVO().setExamTtl(vo.getExamTtl());
                                    vo.getExamDtlVO().setExamCts(vo.getExamCts());
                                }
                                examDAO.examDtlRegist(vo.getExamDtlVO());	// 퀴즈상세 등록

                                ExamTrgtrVO trgtr = new ExamTrgtrVO();
                                trgtr.setExamTrgtrId(IdGenUtil.genNewId(IdPrefixType.EXTGT));
                                trgtr.setTeamId(team.getTeamId());
                                trgtr.setExamDtlId(vo.getExamDtlVO().getExamDtlId());
                                trgtr.setRgtrId(vo.getRgtrId());
                                examDAO.examTrgtrRegist(trgtr);		// 퀴즈대상자 등록
                            }
                        }
                    }
                // 일반 퀴즈
                } else {
                    vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL));
                    examDAO.examDtlRegist(vo.getExamDtlVO());	// 퀴즈상세 등록
                }

                if("QUIZ".equals(vo.getExamTycd())) {
                    quizMrkRfltrtModify(vo);	// 퀴즈 성적반영비율 수정
                }

//                if(!"EXAM".equals(StringUtil.nvl(vo.getGoUrl())) || "QUIZ".equals(StringUtil.nvl(vo.getExamCtgrCd()))) {
//                    // 첨부파일 복사
//                    copyFile(vo, fileVO);
//                }

            }
            vo.setExamBscId(examBscId);
        }

        return vo;
    }

    /**
    * 퀴즈수정
    *
    * @param ExamBscVO
    * @throws Exception
    */
    @Override
    public ExamBscVO quizModify(ExamBscVO vo) throws Exception {
        ExamBscVO bfrQuiz = examDAO.quizBscSelect(vo);	// 기존 퀴즈기본 조회

        if(vo.getLrnGrpSubasmtStngyns() != null) {
            vo.setLrnGrpSubasmtStngyn(vo.getLrnGrpSubasmtStngyns().stream().anyMatch(item -> item.contains(vo.getSbjctId())) ? "Y" : "N");
        } else {
            vo.setLrnGrpSubasmtStngyn("N");
        }
        examDAO.examBscModify(vo);	// 퀴즈기본 수정
        vo.getExamDtlVO().setExamBscId(vo.getExamBscId());

        // 기존 팀 퀴즈
        if("QUIZ_TEAM".equals(bfrQuiz.getExamGbncd())) {
            // 신규 팀 퀴즈
            if("QUIZ_TEAM".equals(vo.getExamGbncd())) {
                Map<Object, Map<String, Object>> idMap = vo.getExamDtlVO().getDtlInfos().stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
                for(String lrnGrp : vo.getLrnGrpIds()) {
                    if(lrnGrp.split(":")[1].equals(vo.getSbjctId())) {
                        String lrnGbnId = lrnGrp.split(":")[0];		// 신규 학습그룹아이디
                        String bfrLrnGbnId = bfrQuiz.getLrnGrpId();	// 기존 학습그룹아이디

                        TeamVO teamVO = new TeamVO();
                        teamVO.setTeamCtgrCd(lrnGbnId);
                        List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀 목록 조회

                        // 학습그룹 불일치시
                        if(!lrnGbnId.equals(bfrLrnGbnId)) {
                            examDAO.examTrgtrDelete(vo.getExamBscId());	// 기존 퀴즈대상자 삭제
                            examDAO.examDtlDelete(vo.getExamBscId());	// 기존 퀴즈상세 삭제

                            for(TeamVO team : teamList) {
                                vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL));
                                Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                                if(target != null) {
                                    vo.getExamDtlVO().setExamTtl((String) target.get("ttl"));
                                    vo.getExamDtlVO().setExamCts((String) target.get("cts"));
                                } else {
                                    vo.getExamDtlVO().setExamTtl(vo.getExamTtl());
                                    vo.getExamDtlVO().setExamCts(vo.getExamCts());
                                }
                                examDAO.examDtlRegist(vo.getExamDtlVO());	// 신규 퀴즈상세 등록

                                ExamTrgtrVO trgtr = new ExamTrgtrVO();
                                trgtr.setExamTrgtrId(IdGenUtil.genNewId(IdPrefixType.EXTGT));
                                trgtr.setTeamId(team.getTeamId());
                                trgtr.setExamDtlId(vo.getExamDtlVO().getExamDtlId());
                                trgtr.setRgtrId(vo.getRgtrId());
                                examDAO.examTrgtrRegist(trgtr);		// 신규 퀴즈대상자 등록
                            }
                        // 학습그룹 일치시
                        } else {
                        	List<EgovMap> quizDtlList = examDAO.quizTeamList(vo.getExamBscId());
                        	for(TeamVO team : teamList) {
                        		Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                                if(target != null) {
                                    vo.getExamDtlVO().setExamTtl((String) target.get("ttl"));
                                    vo.getExamDtlVO().setExamCts((String) target.get("cts"));
                                } else {
                                    vo.getExamDtlVO().setExamTtl(vo.getExamTtl());
                                    vo.getExamDtlVO().setExamCts(vo.getExamCts());
                                }
                                String examDtlId = quizDtlList.stream()
                                	    .filter(map -> team.getTeamId().equals(map.get("teamId")))
                                	    .map(map -> String.valueOf(map.get("examDtlId")))
                                	    .findFirst()
                                	    .orElse(null);
                                vo.getExamDtlVO().setExamDtlId(examDtlId);
                                examDAO.examDtlModify(vo.getExamDtlVO());	// 퀴즈상세 수정
                        	}
                        }
                    }
                }
                // 등록 과목아이디 목록 삭제
                vo.getLrnGrpIds().removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
            // 신규 일반 퀴즈
            } else {
                examDAO.examTrgtrDelete(vo.getExamBscId());	// 기존 퀴즈대상자 삭제
                examDAO.examDtlDelete(vo.getExamBscId());	// 기존 퀴즈상세 삭제

                vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL));
                examDAO.examDtlRegist(vo.getExamDtlVO());	// 신규 퀴즈상세 등록
            }
        // 기존 일반 퀴즈
        } else {
            // 신규 팀 퀴즈
            if("QUIZ_TEAM".equals(vo.getExamGbncd())) {
                Map<Object, Map<String, Object>> idMap = vo.getExamDtlVO().getDtlInfos().stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
                examDAO.examDtlDelete(vo.getExamBscId());	// 기존 퀴즈상세 삭제

                for(String lrnGrp : vo.getLrnGrpIds()) {
                    if(lrnGrp.split(":")[1].equals(vo.getSbjctId())) {
                        TeamVO teamVO = new TeamVO();
                        teamVO.setTeamCtgrCd(lrnGrp.split(":")[0]);
                        List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀 목록 조회
                        for(TeamVO team : teamList) {
                            vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL));
                            Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                            if(target != null) {
                                vo.getExamDtlVO().setExamTtl((String) target.get("ttl"));
                                vo.getExamDtlVO().setExamCts((String) target.get("cts"));
                            } else {
                                vo.getExamDtlVO().setExamTtl(vo.getExamTtl());
                                vo.getExamDtlVO().setExamCts(vo.getExamCts());
                            }
                            examDAO.examDtlRegist(vo.getExamDtlVO());	// 신규 퀴즈상세 등록

                            ExamTrgtrVO trgtr = new ExamTrgtrVO();
                            trgtr.setExamTrgtrId(IdGenUtil.genNewId(IdPrefixType.EXTGT));
                            trgtr.setTeamId(team.getTeamId());
                            trgtr.setExamDtlId(vo.getExamDtlVO().getExamDtlId());
                            trgtr.setRgtrId(vo.getRgtrId());
                            examDAO.examTrgtrRegist(trgtr);		// 신규 퀴즈대상자 등록
                        }
                    }
                }
                // 등록 과목아이디 목록 삭제
                vo.getLrnGrpIds().removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
            // 신규 일반 퀴즈
            } else {
                examDAO.examDtlModify(vo.getExamDtlVO());	// 퀴즈상세 수정
            }
        }

        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());

        // 첨부파일
        if (uploadFileList.size() > 0) {
        	for (AtflVO atflVO : uploadFileList) {
        		atflVO.setRefId(vo.getExamBscId());
        		atflVO.setRgtrId(vo.getRgtrId());
        		atflVO.setMdfrId(vo.getMdfrId());
        		atflVO.setAtflRepoId(CommConst.REPO_EXAM);
        	}

        	// 첨부파일 저장
        	attachFileService.insertAtflList(uploadFileList);
        }

        // 첨부파일 삭제
        attachFileService.deleteAtflByAtflIds(vo.getDelFileIds());

        if("QUIZ".equals(StringUtil.nvl(bfrQuiz.getExamTycd())) || "EXAM".equals(StringUtil.nvl(vo.getGoUrl()))) {
            quizMrkRfltrtModify(vo);	// 퀴즈 성적반영비율 수정
        }

        // 분반 수정
        if("Y".equals(vo.getDvclasRegyn())) {
            vo.getSbjctIds().removeIf(item -> item.equals(vo.getSbjctId()));	// 퀴즈수정 분반 목록 제거

            for(String sbjctId : vo.getSbjctIds()) {
                vo.setSbjctId(sbjctId);
                vo.setExamBscId(examDAO.examBscIdSelect(vo));			// 시험기본아이디 조회
                ExamBscVO dvclasBfrQuiz = examDAO.quizBscSelect(vo);	// 기존 퀴즈기본 조회

                if(vo.getLrnGrpSubasmtStngyns() != null) {
                    vo.setLrnGrpSubasmtStngyn(vo.getLrnGrpSubasmtStngyns().stream().anyMatch(item -> item.contains(sbjctId)) ? "Y" : "N");
                } else {
                    vo.setLrnGrpSubasmtStngyn("N");
                }
                examDAO.examBscModify(vo);	// 퀴즈기본 수정
                vo.getExamDtlVO().setExamBscId(vo.getExamBscId());

                // 기존 팀 퀴즈
                if("QUIZ_TEAM".equals(dvclasBfrQuiz.getExamGbncd())) {
                    // 신규 팀 퀴즈
                    if("QUIZ_TEAM".equals(vo.getExamGbncd())) {
                        Map<Object, Map<String, Object>> idMap = vo.getExamDtlVO().getDtlInfos().stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
                        for(String lrnGrp : vo.getLrnGrpIds()) {
                            if(lrnGrp.split(":")[1].equals(sbjctId)) {
                                String lrnGbnId = lrnGrp.split(":")[0];				// 신규 학습그룹아이디
                                String bfrLrnGbnId = dvclasBfrQuiz.getLrnGrpId();	// 기존 학습그룹아이디

                                if(!lrnGbnId.equals(bfrLrnGbnId)) {
                                    examDAO.examTrgtrDelete(vo.getExamBscId());	// 기존 퀴즈대상자 삭제
                                    examDAO.examDtlDelete(vo.getExamBscId());	// 기존 퀴즈상세 삭제

                                    TeamVO teamVO = new TeamVO();
                                    teamVO.setTeamCtgrCd(lrnGbnId);
                                    List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀 목록 조회
                                    for(TeamVO team : teamList) {
                                        vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL));
                                        Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                                        if(target != null) {
                                            vo.getExamDtlVO().setExamTtl((String) target.get("ttl"));
                                            vo.getExamDtlVO().setExamCts((String) target.get("cts"));
                                        } else {
                                            vo.getExamDtlVO().setExamTtl(vo.getExamTtl());
                                            vo.getExamDtlVO().setExamCts(vo.getExamCts());
                                        }
                                        examDAO.examDtlRegist(vo.getExamDtlVO());	// 신규 퀴즈상세 등록

                                        ExamTrgtrVO trgtr = new ExamTrgtrVO();
                                        trgtr.setExamTrgtrId(IdGenUtil.genNewId(IdPrefixType.EXTGT));
                                        trgtr.setTeamId(team.getTeamId());
                                        trgtr.setExamDtlId(vo.getExamDtlVO().getExamDtlId());
                                        trgtr.setRgtrId(vo.getRgtrId());
                                        examDAO.examTrgtrRegist(trgtr);		// 신규 퀴즈대상자 등록
                                    }
                                }
                            }
                        }
                        // 등록 과목아이디 목록 삭제
                        vo.getLrnGrpIds().removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
                    // 신규 일반 퀴즈
                    } else {
                        examDAO.examTrgtrDelete(vo.getExamBscId());	// 기존 퀴즈대상자 삭제
                        examDAO.examDtlDelete(vo.getExamBscId());	// 기존 퀴즈상세 삭제

                        vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL));
                        examDAO.examDtlRegist(vo.getExamDtlVO());	// 신규 퀴즈상세 등록
                    }
                // 기존 일반 퀴즈
                } else {
                    // 신규 팀 퀴즈
                    if("QUIZ_TEAM".equals(vo.getExamGbncd())) {
                        Map<Object, Map<String, Object>> idMap = vo.getExamDtlVO().getDtlInfos().stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
                        examDAO.examDtlDelete(vo.getExamBscId());	// 기존 퀴즈상세 삭제

                        for(String lrnGrp : vo.getLrnGrpIds()) {
                            if(lrnGrp.split(":")[1].equals(sbjctId)) {
                                TeamVO teamVO = new TeamVO();
                                teamVO.setTeamCtgrCd(lrnGrp.split(":")[0]);
                                List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀 목록 조회
                                for(TeamVO team : teamList) {
                                    vo.getExamDtlVO().setExamDtlId(IdGenUtil.genNewId(IdPrefixType.EXDTL));
                                    Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                                    if(target != null) {
                                        vo.getExamDtlVO().setExamTtl((String) target.get("ttl"));
                                        vo.getExamDtlVO().setExamCts((String) target.get("cts"));
                                    } else {
                                        vo.getExamDtlVO().setExamTtl(vo.getExamTtl());
                                        vo.getExamDtlVO().setExamCts(vo.getExamCts());
                                    }
                                    examDAO.examDtlRegist(vo.getExamDtlVO());	// 신규 퀴즈상세 등록

                                    ExamTrgtrVO trgtr = new ExamTrgtrVO();
                                    trgtr.setExamTrgtrId(IdGenUtil.genNewId(IdPrefixType.EXTGT));
                                    trgtr.setTeamId(team.getTeamId());
                                    trgtr.setExamDtlId(vo.getExamDtlVO().getExamDtlId());
                                    trgtr.setRgtrId(vo.getRgtrId());
                                    examDAO.examTrgtrRegist(trgtr);		// 신규 퀴즈대상자 등록
                                }
                            }
                        }
                    // 신규 일반 퀴즈
                    } else {
                    	ExamDtlVO searchDtlVO = new ExamDtlVO();
                    	searchDtlVO.setExamBscId(vo.getExamBscId());
                        ExamDtlVO dvclasBfrQuizDtl = examDAO.quizDtlSelect(searchDtlVO);	// 기존 퀴즈상세 조회
                        vo.getExamDtlVO().setExamDtlId(dvclasBfrQuizDtl.getExamDtlId());
                        examDAO.examDtlModify(vo.getExamDtlVO());	// 퀴즈상세 수정
                    }
                }

                if("QUIZ".equals(vo.getExamTycd())) {
                    quizMrkRfltrtModify(vo);	// 퀴즈 성적반영비율 수정
                }

//                if(!"EXAM".equals(StringUtil.nvl(vo.getGoUrl())) || "QUIZ".equals(StringUtil.nvl(vo.getExamCtgrCd()))) {
//                    // 첨부파일 복사
//                    copyFile(vo, fileVO);
//                }
            }
        }

        vo.setExamBscId(bfrQuiz.getExamBscId());

        return vo;
    }

    /**
    * 시험기본수정
    *
    * @param ExamBscVO
    * @throws Exception
    */
    @Override
    public void examBscModify(ExamBscVO vo) throws Exception {
        examDAO.examBscModify(vo);
    }

    /**
     * 시험상세수정
     *
     * @param ExamDtlVO
     * @throws Exception
     */
    @Override
    public void examDtlModify(ExamDtlVO vo) throws Exception {
        examDAO.examDtlModify(vo);
    }

    /**
     * 퀴즈성적반영비율수정
     *
     * @param sbjctId	과목개설아이디
     * @param mdfrId		수정자아이디
     * @throws Exception
     */
    @Override
    public void quizMrkRfltrtModify(ExamBscVO vo) throws Exception {
        List<ExamBscVO> quizList = examDAO.mrkRfltQuizList(vo);	// 성적반영 퀴즈 목록 조회
        if(quizList.size() > 0) {
            int totalMrk = 100;
            int mrkRfltrt = (int) (totalMrk / quizList.size());
            for(int i = 0; i < quizList.size(); i++) {
                if(i == quizList.size() - 1) {
                    mrkRfltrt = totalMrk;
                }
                totalMrk -= mrkRfltrt;
                ExamBscVO bscVO = quizList.get(i);
                bscVO.setMrkRfltrt(mrkRfltrt);
                bscVO.setMdfrId(vo.getMdfrId());
            }
            examDAO.quizMrkRfltrtListModify(quizList);
        }
    }

    /**
     * 퀴즈삭제
     *
     * @param examBscId		시험기본아이디
     * @param mdfrId		수정자아이디
     * @throws Exception
     */
    @Override
    public void quizDelete(ExamBscVO vo) throws Exception {
        ExamBscVO bscVO = examDAO.quizBscSelect(vo);
        // 대체퀴즈인 경우 시험평가대체 삭제
        if("SBST".contains(bscVO.getExamGbncd())) {
            examDAO.examEvlSbstDelete(vo.getExamBscId());
        }

        examDAO.examDtlDelynModify(vo); // 퀴즈상세 삭제여부 수정
        examDAO.examBscModify(vo);		// 퀴즈기본 삭제여부 수정

        quizMrkRfltrtModify(vo);		// 퀴즈 성적반영비율 수정

//        FileVO fileVO = new FileVO();
//        fileVO.setRepoCd("EXAM_CD");
//        fileVO.setFileBindDataSn(vo.getExamBscId());
//        List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
//        for(FileVO fvo : fileList) {
//            sysFileService.removeFile(fvo.getFileSn());
//        }
    }

    /**
    * 교수권한과목퀴즈목록조회
    *
    * @param userId 		교수아이디
    * @param smstrChrtId 	학기기수아이디
    * @param sbjctId 		과목아이디
    * @param searchValue 	검색내용(퀴즈명)
    * @return 퀴즈목록
    * @throws Exception
    */
    @Override
    public List<EgovMap> profAuthrtSbjctQuizList(Map<String, Object> params) throws Exception {
        return examDAO.profAuthrtSbjctQuizList(params);
    }

    /**
    * 퀴즈그룹과목목록조회
    *
    * @param examBscId 	시험기본아이디
    * @return 과목 목록
    * @throws Exception
    */
    @Override
    public List<EgovMap> quizGrpSbjctList(String examBscId) throws Exception {
        return examDAO.quizGrpSbjctList(examBscId);
    }

    /**
    * 퀴즈학습그룹부과제목록조회
    *
    * @param lrnGrpId 	학습그룹아이디
    * @param examBscId 	시험기본아이디
    * @return 퀴즈 부과제 목록
    * @throws Exception
    */
    @Override
    public List<ExamDtlVO> quizLrnGrpSubAsmtList(ExamDtlVO vo) throws Exception {
        return examDAO.quizLrnGrpSubAsmtList(vo);
    }

    /**
     * 퀴즈문제출제완료수정
     *
     * @param examBscId		시험기본아이디
     * @param examDtlId		시험상세아이디
     * @param searchGubun 	수정상태 ( save, edit )
     * @throws Exception
     */
    @Override
    public void quizQstnsCmptnModify(ExamBscVO vo) throws Exception {
    	String examQstnsCmptyn = "edit".equals(StringUtil.nvl(vo.getSearchGubun())) ? "M" : "Y";

    	// 팀퀴즈
    	if("QUIZ_TEAM".equals(vo.getExamGbncd())) {
    		// 시험기본 시험문제출제완료여부
    		if("bsc".equals(vo.getSearchKey())) {
    			vo.setExamQstnsCmptnyn(examQstnsCmptyn);
        		examDAO.examBscModify(vo);
    		// 시험상세 시험문제출제완료여부
    		} else {
    			vo.getExamDtlVO().setMdfrId(vo.getMdfrId());
    	        vo.getExamDtlVO().setExamQstnsCmptnyn(examQstnsCmptyn);
    	        examDAO.examDtlModify(vo.getExamDtlVO());
    		}

    	// 일반퀴즈
    	} else {
    		// 시험기본 수정
    		vo.setExamQstnsCmptnyn(examQstnsCmptyn);
    		examDAO.examBscModify(vo);

    		// 시험상세 수정
    		vo.getExamDtlVO().setMdfrId(vo.getMdfrId());
            vo.getExamDtlVO().setExamQstnsCmptnyn(examQstnsCmptyn);
            examDAO.examDtlModify(vo.getExamDtlVO());
    	}
    }

    /**
     * 퀴즈팀목록조회
     *
     * @param examBscId 	시험기본아이디
     * @return 퀴즈 팀 목록
     * @throws Exception
     */
     @Override
     public List<EgovMap> quizTeamList(String examBscId) throws Exception {
         return examDAO.quizTeamList(examBscId);
     }

     /**
 	 * 퀴즈팀문제출제완료여부조회
 	 *
 	 * @param examBscId 시험기본아이디
 	 * @throws Exception
 	 */
     @Override
 	 public Boolean quizTeamQstnsCmptnynSelect(String examBscId) throws Exception {
 	 	return examDAO.quizTeamQstnsCmptnynSelect(examBscId);
 	 }

 	 /**
	  * 시험응시시작사용자수조회
	  *
	  * @param examBscId 시험기본아이디
	  * @param examDtlId 시험상세아이디
	  * @throws Exception
	  */
     @Override
	 public Integer tkexamStrtUserCntSelect(ExamDtlVO vo) throws Exception {
	 	return examDAO.tkexamStrtUserCntSelect(vo);
	 }

	/**
	 * 과목분반목록조회
	 *
	 * @param sbjctId		과목아이디
	 * @return 과목분반목록
	 * @throws Exception
	 */
     @Override
	 public List<EgovMap> sbjctDvclasList(String sbjctId) throws Exception {
	 	return examDAO.sbjctDvclasList(sbjctId);
	 }

	 /**
	 * 퀴즈성적반영비율목록수정
	 *
	 * @param List<ExamBscVO>
	 * @throws Exception
	 */
     @Override
	 public void quizMrkRfltrtListModify(List<ExamBscVO> list) throws Exception {
	 	examDAO.quizMrkRfltrtListModify(list);
	 }

	 /**
	 * 시험지일괄엑셀다운퀴즈대상자목록조회
	 *
	 * @param examBscId 	시험기본아이디
     * @param sbjctId 		과목이이디
	 * @return 시험지일괄엑셀다운퀴즈대상자목록
	 * @throws Exception
	 */
     @Override
	 public List<EgovMap> exampprBulkExcelDownQuizTrgtrList(ExamBscVO vo) throws Exception {
    	 return examDAO.exampprBulkExcelDownQuizTrgtrList(vo);
     }

    /**
 	* 문제가져오기학기기수목록조회
 	*
 	* @return 학기기수목록
 	* @throws Exception
 	*/
    @Override
 	public List<EgovMap> qstnCopySmstrList() throws Exception {
 		return examDAO.qstnCopySmstrList();
 	}

 	/**
 	* 문제가져오기과목목록조회
 	*
 	* @param smstrChrtId 	학기기수아이디
     * @param sbjctId 		과목이이디
 	* @return 과목목록
 	* @throws Exception
 	*/
    @Override
 	public List<EgovMap> qstnCopySbjctList(String smstrChrtId, String sbjctId) throws Exception {
 		return examDAO.qstnCopySbjctList(smstrChrtId, sbjctId);
 	}

 	/**
 	* 문제가져오기퀴즈목록조회
 	*
     * @param sbjctId 		과목이이디
 	* @return 퀴즈목록
 	* @throws Exception
 	*/
    @Override
 	public List<ExamDtlVO> qstnCopyQuizList(String sbjctId) throws Exception {
    	return examDAO.qstnCopyQuizList(sbjctId);
    }







    /*****************************************************
     * <p>
     * TODO 시험 정보 조회
     * </p>
     * 시험 정보 조회
     *
     * @param ExamVO
     * @return ExamVO
     * @throws Exception
     ******************************************************/
    @Override
    public ExamVO select(ExamVO vo) throws Exception {
        vo = examDAO.select(vo);
        if(vo != null) {
            String examTypeCd = StringUtil.nvl(vo.getExamTypeCd());
            List<FileVO> fileList = new ArrayList<FileVO>();
            if("ASMNT".equals(examTypeCd)) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("ASMNT");
                fileVO.setFileBindDataSn(vo.getInsRefCd());
                fileList = sysFileService.list(fileVO).getReturnList();
            } else if("FORUM".equals(examTypeCd)) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("FORUM");
                fileVO.setFileBindDataSn(vo.getInsRefCd());
                fileList = sysFileService.list(fileVO).getReturnList();
            } else if("QUIZ".equals(examTypeCd) || "EXAM".equals(examTypeCd) || "SUBS".equals(examTypeCd)) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("EXAM_CD");
                if(!"".equals(StringUtil.nvl(vo.getInsRefCd()))) {
                    fileVO.setFileBindDataSn(vo.getInsRefCd());
                } else {
                    fileVO.setFileBindDataSn(vo.getExamCd());
                }
                fileList = sysFileService.list(fileVO).getReturnList();
            }
            vo.setFileList(fileList);
        }
        return vo;
    }

    /*****************************************************
     * <p>
     * TODO 시험 목록 조회
     * </p>
     * 시험 목록 조회
     *
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamVO> list(ExamVO vo) throws Exception {
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        List<ExamVO> examList = examDAO.list(vo);
        resultVO.setReturnList(examList);

        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 시험 목록 조회
     * </p>
     * 시험 목록 조회
     *
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamVO> listPaging(ExamVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<ExamVO> examList = examDAO.listPaging(vo);

        if(examList.size() > 0) {
            paginationInfo.setTotalRecordCount(examList.get(0).getTotalCnt());
            int sumScoreRatio = examDAO.sumScoreRatio(vo);
            ExamVO examVO = examList.get(0);
            examVO.setSumScoreRatio(sumScoreRatio);
            examList.set(0, examVO);
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        resultVO.setReturnList(examList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 내 강의에 등록된 시험 목록 조회
     * </p>
     * 내 강의에 등록된 시험 목록 조회
     *
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamVO> listMyCreCrsExam(ExamVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<ExamVO> examList = examDAO.listMyCreCrsExam(vo);

        if(examList.size() > 0) {
            paginationInfo.setTotalRecordCount(examList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        resultVO.setReturnList(examList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 시험과 같이 등록된 분반 또는 다른 과목 목록 조회
     * </p>
     * 시험과 같이 등록된 분반 또는 다른 과목 목록 조회
     *
     * @param ExamVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listExamCreCrsDecls(ExamVO vo) throws Exception {

        return examDAO.listExamCreCrsDecls(vo);
    }

    /*****************************************************
     * <p>
     * TODO 시험 등록
     * </p>
     * 시험 등록
     *
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public ExamVO insertExam(ExamVO vo) throws Exception {
        // 시험 등록
        String crsCreCd = StringUtil.nvl(vo.getCrsCreCd());
        String examCd = StringUtil.nvl(vo.getExamCd());
        if("".equals(StringUtil.nvl(vo.getExamCd()))) {
            examCd = IdGenerator.getNewId("EXAM");
            vo.setExamCd(examCd);
        }
        examDAO.insertExam(vo);

        // 시험 강의 연결 등록
        ExamVO examCreCrsRltnVO = new ExamVO();
        examCreCrsRltnVO.setExamCd(vo.getExamCd());
        examCreCrsRltnVO.setCrsCreCd(vo.getCrsCreCd());
        examCreCrsRltnVO.setGrpCd(IdGenerator.getNewId("GRP"));
        examDAO.insertExamCreCrsRltn(examCreCrsRltnVO);
        if("QUIZ".equals(StringUtil.nvl(vo.getExamCtgrCd())) || "EXAM".equals(StringUtil.nvl(vo.getGoUrl()))) {
            // 성적 반영 비율 수정
            setScoreRatio(vo);
        }

        FileVO fileVO = new FileVO();
        if(!"EXAM".equals(StringUtil.nvl(vo.getGoUrl())) || "QUIZ".equals(StringUtil.nvl(vo.getExamCtgrCd()))) {
            // 파일 등록
            fileVO = addFile(vo);
        }
        // 응시 정보 사전 등록
        vo.setStareSn(vo.getStdId() + examCd);    // 신규키값_모사
        insertExamStare(vo, vo.getCrsCreCd());
        // 가져오기 문제 복사
        insertExamQstn(vo);

        // 분반 등록
        if("Y".equals(StringUtil.nvl(vo.getDeclsRegYn()))) {
            Map<String, String> declsLessonScheduleIdMap = new HashMap<>();

            // 주차 선택한경우
            if(!"DEFAULT".equals(StringUtil.nvl(vo.getLessonScheduleId()))) {
                LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
                lessonScheduleVO.setLessonScheduleId(vo.getLessonScheduleId());
                lessonScheduleVO.setSqlForeach(vo.getCrsCreCds().toArray(new String[vo.getCrsCreCds().size()]));
                List<LessonScheduleVO> declsLessonScheduleList = lessonScheduleDAO.listDeclsLessonSchedule(lessonScheduleVO);

                for(LessonScheduleVO lessonScheduleVO2 : declsLessonScheduleList) {
                    declsLessonScheduleIdMap.put(lessonScheduleVO2.getCrsCreCd(), lessonScheduleVO2.getLessonScheduleId());
                }
            }

            for(String declsCrsCreCd : vo.getCrsCreCds()) {
                if(!declsCrsCreCd.equals(crsCreCd) && !"".equals(crsCreCd) && !"".equals(declsCrsCreCd)) {
                    if(declsLessonScheduleIdMap.containsKey(declsCrsCreCd)) {
                        vo.setLessonScheduleId(declsLessonScheduleIdMap.get(declsCrsCreCd));
                    } else {
                        vo.setLessonScheduleId(null);
                    }

                    String newExamCd = IdGenerator.getNewId("EXAM");
                    vo.setExamCd(newExamCd);
                    examDAO.insertExam(vo);
                    examCreCrsRltnVO.setCrsCreCd(declsCrsCreCd);
                    examCreCrsRltnVO.setExamCd(newExamCd);
                    examCreCrsRltnVO.setMdfrId(vo.getMdfrId());
                    examDAO.insertExamCreCrsRltn(examCreCrsRltnVO);
                    if("QUIZ".equals(StringUtil.nvl(vo.getExamCtgrCd()))) {
                        // 성적 반영 비율 수정
                        setScoreRatio(examCreCrsRltnVO);
                    }
                    if(!"EXAM".equals(StringUtil.nvl(vo.getGoUrl())) || "QUIZ".equals(StringUtil.nvl(vo.getExamCtgrCd()))) {
                        // 첨부파일 복사
                        copyFile(vo, fileVO);
                    }
                    // 응시 정보 사전 등록
                    insertExamStare(vo, declsCrsCreCd);
                    // 가져오기 문제 복사
                    insertExamQstn(vo);
                }
            }
        }
        vo.setExamCd(examCd);

        return vo;
    }

    /*****************************************************
     * <p>
     * TODO 시험 수정
     * </p>
     * 시험 수정
     *
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public ExamVO updateExam(ExamVO vo) throws Exception {
        String examStareTypeCd = StringUtil.nvl(vo.getExamStareTypeCd());
        vo.setExamStareTypeCd("");
        ExamVO examVO = examDAO.select(vo);
        String oldExamTypeCd = StringUtil.nvl(examVO.getExamTypeCd());
        String newInsRefCd = StringUtil.nvl(vo.getInsRefCd());
        // 실시간 시험 유형 코드 유지
        if(!"EDIT".equals(StringUtil.nvl(vo.getSearchFrom()))) {
            if(!"".equals(oldExamTypeCd) && "EXAM".equals(oldExamTypeCd)) {
                vo.setExamTypeCd("EXAM");
            }
            if(!"EXAM".equals(newInsRefCd.split("_")[0]) && !"A".equals(StringUtil.nvl(vo.getExamStareTypeCd()))) {
                vo.setExamSubmitYn("Y");
            }
        }

        vo.setExamStareTypeCd(examStareTypeCd);
        examDAO.updateExam(vo);
        // 가져오기 문제 복사
        insertExamQstn(vo);
        vo.setExamStareTypeCd("");
        if("QUIZ".equals(StringUtil.nvl(examVO.getExamCtgrCd())) || "EXAM".equals(StringUtil.nvl(vo.getGoUrl()))) {
            // 성적 반영 비율 수정
            setScoreRatio(vo);
        }
        if(!"EXAM".equals(StringUtil.nvl(vo.getGoUrl()))) {
            if(vo.getDelFileIds().length > 0) {
                for(String delFileId : vo.getDelFileIds()) {
                    FileVO fileVO = new FileVO();
                    fileVO.setRepoCd("EXAM_CD");
                    if("QUIZ".equals(oldExamTypeCd)) {
                        fileVO.setFileBindDataSn(vo.getInsRefCd());
                    } else {
                        fileVO.setFileBindDataSn(vo.getExamCd());
                    }
                    List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
                    for(FileVO fvo : fileList) {
                        if(delFileId.equals(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")))) {
                            sysFileService.removeFile(fvo.getFileSn());
                        }
                    }
                }
            }
            if("QUIZ".equals(oldExamTypeCd) && "EXAM".equals(StringUtil.nvl(examVO.getExamCtgrCd()))) {
                vo.setExamCd(vo.getInsRefCd());
            }
            // 파일 등록
            addFile(vo);
        }

        return vo;
    }

    /*****************************************************
     * <p>
     * TODO 시험 삭제 상태로 수정
     * </p>
     * 시험 삭제 상태로 수정
     *
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateExamDelYn(ExamVO vo) throws Exception {
        // 대체 과제 여부 조회 및 삭제
        examInsDelete(vo.getExamCd());
        examDAO.updateExamCreCrsRltnDelYn(vo);
        examDAO.updateExamDelYn(vo);

        if("QUIZ".equals(StringUtil.nvl(vo.getSearchKey()))) {
            // 성적 반영 비율 수정
            setScoreRatio(vo);
        }

        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("EXAM_CD");
        fileVO.setFileBindDataSn(vo.getExamCd());
        List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
        for(FileVO fvo : fileList) {
            sysFileService.removeFile(fvo.getFileSn());
        }
    }

    /*****************************************************
     * <p>
     * 퀴즈 복사
     * </p>
     * 퀴즈 복사
     *
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void copyQuiz(ExamVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String crsCreCd = vo.getCrsCreCd();
        String copyExamCd = vo.getCopyExamCd();
        String rgtrId = vo.getRgtrId();
        String lineNo = vo.getLineNo();

        if(ValidationUtils.isEmpty(orgId)
                || ValidationUtils.isEmpty(crsCreCd)
                || ValidationUtils.isEmpty(copyExamCd)
                || ValidationUtils.isEmpty(rgtrId)
                || ValidationUtils.isEmpty(lineNo)) {
            throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
        }

        String examCd = IdGenerator.getNewId("EXAM");

        ExamVO copyQuizVO = new ExamVO();
        copyQuizVO.setCopyExamCd(copyExamCd);
        copyQuizVO.setExamCd(examCd);
        copyQuizVO.setCrsCreCd(crsCreCd);
        copyQuizVO.setRgtrId(rgtrId);
        copyQuizVO.setLineNo(lineNo);
        examDAO.copyQuiz(copyQuizVO);

        // 시험 강의 연결 등록
        ExamVO examCreCrsRltnVO = new ExamVO();
        examCreCrsRltnVO.setExamCd(examCd);
        examCreCrsRltnVO.setCrsCreCd(crsCreCd);
        examCreCrsRltnVO.setGrpCd(IdGenerator.getNewId("GRP"));
        examDAO.insertExamCreCrsRltn(examCreCrsRltnVO);

        // 파일 정보 복사
        FileVO copyFileVO;
        copyFileVO = new FileVO();
        copyFileVO.setOrgId(orgId);
        copyFileVO.setRepoCd("EXAM_CD");
        copyFileVO.setFileBindDataSn(examCd);
        copyFileVO.setCopyFileBindDataSn(copyExamCd);
        copyFileVO.setRgtrId(rgtrId);

        sysFileService.copyFileInfoFromOrigin(copyFileVO);

        // 가져오기 문제 복사
        ExamVO copyQstnVO = new ExamVO();
        copyQstnVO.setSearchTo(copyExamCd);
        copyQstnVO.setExamCd(examCd);
        copyQstnVO.setMdfrId(rgtrId);
        copyQstnVO.setRgtrId(rgtrId);
        insertExamQstn(copyQstnVO);
    }

    /*****************************************************
     * <p>
     * TODO 시험 성적 반영 비율 자동 계산
     * </p>
     * 시험 성적 반영 비율 자동 계산
     *
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void setScoreRatio(ExamVO vo) throws Exception {
        ExamVO examVO = new ExamVO();
        examVO.setCrsCreCd(vo.getCrsCreCd());
        examVO.setExamCtgrCd("EXAM".equals(StringUtil.nvl(vo.getGoUrl())) ? "EXAM" : "QUIZ");
        List<ExamVO> quizList = examDAO.listQuizScoreAply(examVO);
        if(quizList.size() > 0) {
            int total = 100;
            int scoreRatio = (int) (total / quizList.size());
            for(int i = 0; i < quizList.size(); i++) {
                if(i == quizList.size() - 1) {
                    scoreRatio = total;
                }
                total -= scoreRatio;
                ExamVO evo = quizList.get(i);
                evo.setScoreRatio(scoreRatio);
                evo.setMdfrId(vo.getMdfrId());
                examDAO.updateExam(evo);
            }
        }
    }

    /*****************************************************
     * <p>
     * TODO 시험 문항 출제 완료
     * </p>
     * 시험 문항 출제 완료
     *
     * @param ExamVO
     * @return ProcessResultVO<ExamVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamVO> updateExamSubmitYn(ExamVO vo, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<ExamVO> resultVO = new ProcessResultVO<ExamVO>();

        ExamVO examVO = examDAO.select(vo);
        examVO.setRgtrId(vo.getRgtrId());
        examVO.setMdfrId(vo.getMdfrId());
        String examSubmitYn = "edit".equals(StringUtil.nvl(vo.getSearchGubun())) ? "M" : "Y";

        if("Y".equals(StringUtil.nvl(examVO.getExamSubmitYn())) && examSubmitYn.equals(StringUtil.nvl(examVO.getExamSubmitYn()))) {
            throw processException("exam.alert.already.submit"); // 이미 처리 되었습니다. 페이지를 새로고침하세요.
        } else if("M".equals(StringUtil.nvl(examVO.getExamSubmitYn())) && examSubmitYn.equals(StringUtil.nvl(examVO.getExamSubmitYn()))) {
            throw processException("exam.alert.already.submit"); // 이미 처리 되었습니다. 페이지를 새로고침하세요.
        }

        LocalDateTime today = LocalDateTime.now();
        String now = today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");

        // 시작일자 이전 && 참여자 0명이면 임시저장으로 수정
        if(sdf.parse(examVO.getExamStartDttm()).after(sdf.parse(now)) && examVO.getExamStartUserCnt() == 0) {
            examSubmitYn = "N";
        }

        // 시험일 경우
        if("EXAM".equals(StringUtil.nvl(vo.getSearchKey()))) {
            vo.setExamSubmitYn(examSubmitYn);
            examDAO.updateExam(vo);
            vo.setExamCd(StringUtil.nvl(examVO.getInsRefCd()));
            examVO.setExamCd(StringUtil.nvl(examVO.getInsRefCd()));
            examDAO.updateExam(vo);
        } else if("QUIZ".equals(StringUtil.nvl(vo.getSearchKey()))) {
            ExamVO evo = new ExamVO();
            evo.setExamSubmitYn(examSubmitYn);
            evo.setMdfrId(vo.getMdfrId());
            evo.setExamCd(vo.getExamCd());
            examDAO.updateExam(evo);
            ExamVO insVO = new ExamVO();
            insVO.setInsRefCd(vo.getExamCd());
            insVO = examDAO.selectByInsRefCd(insVO);
            //if(insVO != null) {
            //    insVO.setMdfrId(vo.getMdfrId());
            //    insVO.setExamSubmitYn(examSubmitYn);
            //    examDAO.updateExam(insVO);
            //}
        }
        if("edit".equals(StringUtil.nvl(vo.getSearchGubun()))) {
            resultVO.setResult(1);
            return resultVO;
        }

        // 임시 저장 후 재 출제시 문제 유지
        if("M".equals(StringUtil.nvl(examVO.getExamSubmitYn())) && (sdf.parse(now).after(sdf.parse(examVO.getExamStartDttm())) || examVO.getExamStartUserCnt() > 0)) {
            ExamVO exVO = new ExamVO();
            exVO.setMdfrId(vo.getMdfrId());
            exVO.setExamSubmitYn("Y");
            exVO.setExamCd(vo.getExamCd());
            examDAO.updateExam(exVO);
            resultVO.setResult(1);
            return resultVO;
        }
        examVO.setLoginIp(StringUtil.nvl(vo.getLoginIp()));

        // 학습자 리스트 조회
        StdVO stdVO = new StdVO();
        stdVO.setCrsCreCd(vo.getCrsCreCd());
        List<StdVO> stdList = stdDAO.list(stdVO);

        if(stdList.size() > 0) {
            // 제출 상태 변경
            ExamVO exVO = new ExamVO();
            exVO.setMdfrId(vo.getMdfrId());
            exVO.setExamSubmitYn("Y");
            exVO.setExamCd(vo.getExamCd());
            examDAO.updateExam(exVO);

            if(examVO.getExamStartUserCnt() > 0) {
                // 퀴즈 응시자가 있어 요청을 실행할 수 없습니다.
                throw processException("exam.alert.warning.quiz.data");
            }

            insertRandomPaper(examVO, stdList);
            resultVO.setMessage(messageSource.getMessage("exam.alert.qstn.submit", null, locale));/* 문항 출제가 완료되었습니다. */
            resultVO.setResult(1);
        } else {
            ExamVO exVO = new ExamVO();
            exVO.setMdfrId(vo.getMdfrId());
            exVO.setExamSubmitYn("Y");
            exVO.setExamCd(vo.getExamCd());
            examDAO.updateExam(exVO);

            resultVO.setMessage(messageSource.getMessage("exam.alert.qstn.submit", null, locale));/* 문항 출제가 완료되었습니다. */
            resultVO.setResult(1);
        }

        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 시험지 랜덤 등록
     * </p>
     * 시험지 랜덤 등록
     *
     * @param ExamVO, List<StdVO>
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insertRandomPaper(ExamVO vo, List<StdVO> stdList) throws Exception {
        // 이전 시험지 삭제
        if(!"ONE".equals(StringUtil.nvl(vo.getSearchKey()))) {
            examStarePaperHstyDAO.deleteAllPaperHsty(vo);
            examStarePaperDAO.deleteAllPaper(vo);
            examStareHstyDAO.deleteAllStareHsty(vo);
            examStareDAO.deleteAllStare(vo);
        }

        String qstnSetTypeCd = StringUtil.nvl(vo.getQstnSetTypeCd(), "RANDOM");
        String emplRandomYn = StringUtil.nvl(vo.getEmplRandomYn(), "Y");
        List<ExamStareVO> examStareList = new ArrayList<>();
        List<String> stdNoList = new ArrayList<>();

        for(int i = 0; i < stdList.size(); i++) {
            StdVO stdVO = (StdVO) stdList.get(i);
            stdNoList.add(stdVO.getStdId());

            // 시험 응시 등록
            ExamStareVO stareVO = new ExamStareVO();
            stareVO.setStdId(stdVO.getStdId());
            stareVO.setExamCd(vo.getExamCd());
            stareVO.setStareSn(stdVO.getStdId() + vo.getExamCd());    // 신규키값_모사
            //stareVO.setTotGetScore(0.0f);
            stareVO.setStareCnt(0);
            stareVO.setStareTm(0);
            stareVO.setEvalYn("N");
            stareVO.setRgtrId(vo.getRgtrId());
            stareVO.setMdfrId(vo.getMdfrId());
            stareVO.setReExamYn("N");
            examStareList.add(stareVO);
        }

        // 시험 응시 등록
        if(examStareList.size() > 0) {
            examStareDAO.insertExamStareBatch(examStareList);
        }

        if(stdNoList.size() > 0) {
            // 시험 응시 이력 등록
            ExamStareHstyVO stareHstyVO = new ExamStareHstyVO();
            stareHstyVO.setExamCd(vo.getExamCd());
            stareHstyVO.setRgtrId(vo.getRgtrId());
            stareHstyVO.setMdfrId(vo.getMdfrId());
            stareHstyVO.setConnIp(StringUtil.nvl(vo.getLoginIp(), "0:0:0:0:0:0:0:1"));
            stareHstyVO.setHstyTypeCd("SET");
            stareHstyVO.setSqlForeach(stdNoList.toArray(new String[stdNoList.size()]));
            examStareHstyDAO.insertExamStareHstyBatch(stareHstyVO);

            // 문제 등록 체크
            ExamStarePaperVO examStarePaperVO = new ExamStarePaperVO();
            examStarePaperVO.setExamCd(vo.getExamCd());
            examStarePaperVO.setSqlForeach(stdNoList.toArray(new String[stdNoList.size()]));
            List<ExamStarePaperVO> paperNotExistsList = examStarePaperDAO.listStdStarePaperNotExists(examStarePaperVO);

            // 문제 등록
            if(paperNotExistsList.size() > 0) {
                List<ExamStarePaperVO> starePaperList = new ArrayList<>();
                List<ExamStarePaperHstyVO> starePaperHstyList = new ArrayList<>();
                List<ExamQstnVO> qstnList = null;
                ExamQstnVO qstnVO = new ExamQstnVO();
                qstnVO.setExamCd(vo.getExamCd());

                if(!"RANDOM".equals(qstnSetTypeCd)) {
                    qstnList = examQstnDAO.seqQstnList(qstnVO);
                }

                for(ExamStarePaperVO examStarePaperVO2 : paperNotExistsList) {
                    String stdNo = examStarePaperVO2.getStdNo();

                    if("RANDOM".equals(qstnSetTypeCd)) {
                        qstnList = examQstnDAO.randomQstnList(qstnVO);
                    }

                    if(qstnList != null) {
                        for(int j = 0; j < qstnList.size(); j++) {
                            ExamQstnVO examQstnVO = (ExamQstnVO) qstnList.get(j);
                            ExamStarePaperVO starePaperVO = new ExamStarePaperVO();
                            Random random = new Random();
                            int dataArray[] = new int[10];
                            String data = "";
                            for(int k = 0; k < 10; k++) {
                                if("Y".equals(emplRandomYn)) {
                                    dataArray[k] = Integer.valueOf(random.nextInt(10) + 1);
                                    for(int l = 0; l < k; l++) {
                                        if(dataArray[k] == dataArray[l]) {
                                            k--;
                                        }
                                    }
                                } else {
                                    dataArray[k] = k + 1;
                                }
                            }
                            for(int m = 0; m < dataArray.length; m++) {
                                if(m > 0) {
                                    data += ",";
                                }
                                data += dataArray[m];
                            }
                            // 응시 시험지 등록
                            starePaperVO.setExamCd(examQstnVO.getExamCd());
                            starePaperVO.setExamQstnSn(examQstnVO.getExamQstnSn());
                            starePaperVO.setStdNo(stdNo);
                            starePaperVO.setQstnNo(examQstnVO.getQstnNo());
                            starePaperVO.setSubNo(1);
                            starePaperVO.setGetScore(0.0f);
                            starePaperVO.setRgtrId(vo.getRgtrId());
                            starePaperVO.setMdfrId(vo.getMdfrId());
                            starePaperVO.setExamOdr(data);
                            starePaperList.add(starePaperVO);
                        }

                        if(qstnList.size() > 0) {
                            // 응시 시험지 이력 등록
                            stareHstyVO = new ExamStareHstyVO();
                            stareHstyVO.setStdNo(stdNo);
                            stareHstyVO.setExamCd(vo.getExamCd());
                            ExamStareHstyVO eshvo = examStareHstyDAO.selectStareHsty(stareHstyVO);
                            ExamStarePaperHstyVO starePaperHstyVO = new ExamStarePaperHstyVO();
                            starePaperHstyVO.setExamCd(vo.getExamCd());
                            starePaperHstyVO.setStdNo(stdNo);
                            starePaperHstyVO.setRgtrId(vo.getRgtrId());
                            starePaperHstyVO.setMdfrId(vo.getMdfrId());
                            starePaperHstyVO.setStareHstySn(eshvo.getStareHstySn());
                            starePaperHstyList.add(starePaperHstyVO);
                        }
                    }
                }

                // 응시 시험지 등록
                if(starePaperList.size() > 0) {
                    examStarePaperDAO.insertExamStarePaperBatch(starePaperList);
                }

                // 응시 시험지 이력 등록
                if(starePaperHstyList.size() > 0) {
                    for(ExamStarePaperHstyVO examStarePaperHstyVO : starePaperHstyList) {
                        examStarePaperHstyDAO.insertExamStarePaperHsty(examStarePaperHstyVO);
                    }
                }
            }
        }
    }

    /*****************************************************
     * <p>
     * TODO 시험지 점수 재산정
     * </p>
     * 시험지 점수 재산정
     *
     * @param ExamVO, List<ExamStareVO>
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateReScore(ExamVO vo, List<ExamStareVO> stareList, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        for(int i = 0; i < stareList.size(); i++) {
            ExamStareVO stareVO = (ExamStareVO) stareList.get(i);
            ExamStarePaperVO starePaperVO = new ExamStarePaperVO();
            starePaperVO.setExamCd(stareVO.getExamCd());
            starePaperVO.setStdNo(stareVO.getStdId());
            List<?> paperList = examStarePaperDAO.paperQstnlist(starePaperVO);

            ExamQstnVO qstnVO = new ExamQstnVO();
            List<ExamQstnVO> seqQstnList = new ArrayList<>();
            qstnVO.setExamCd(vo.getExamCd());
            seqQstnList = examQstnDAO.seqQstnList(qstnVO);

            List<EgovMap> qstnAllList = new ArrayList<>();
            qstnAllList = examQstnDAO.egovList(qstnVO);

            if(seqQstnList.size() == paperList.size()) {
                for(int m = 0; m < paperList.size(); m++) {
                    EgovMap paperMap = (EgovMap) paperList.get(m);
                    String paperExamQstnSnStr = StringUtil.nvl(paperMap.get("examQstnSn"));
                    int paperExamQstnSn = Integer.valueOf(StringUtil.nvl(paperMap.get("examQstnSn"), 0));
                    int paperExamQstnNo = Integer.valueOf(StringUtil.nvl(paperMap.get("qstnNo"), 0));
                    float getScore = Float.valueOf(StringUtil.nvl(paperMap.get("getScore"), 0));
                    String stareAnsr = StringUtil.nvl(paperMap.get("stareAnsr"));
                    String paperExamCd = stareVO.getExamCd();
                    String paperStdNo = stareVO.getStdId();
                    boolean deleteYn = true;

                    //삭제할 시험지문제 구하기
                    for(int k = 0; k < qstnAllList.size(); k++) {
                        EgovMap qstnMap = (EgovMap) qstnAllList.get(k);
                        String qstnExamQstnSnStr = StringUtil.nvl(qstnMap.get("examQstnSn"));
                        if(paperExamQstnSnStr.equals(qstnExamQstnSnStr)) {
                            deleteYn = false;
                            break;
                        }
                    }

                    if(deleteYn) {
                        if(getScore > 0 && !"".equals(stareAnsr)) {
                            throw new BadRequestUrlException(messageSource.getMessage("exam.error.submit.join.user", null, locale));
                        }
                        //시험지에서 문제 삭제 후
                        ExamStarePaperVO espvo = new ExamStarePaperVO();
                        espvo.setExamCd(paperExamCd);
                        espvo.setExamQstnSn(paperExamQstnSn);
                        espvo.setStdNo(paperStdNo);
                        examStarePaperDAO.deleteStarePaper(espvo);

                        EgovMap insertMap = new EgovMap();
                        //문제번호 구하기
                        for(int k = 0; k < qstnAllList.size(); k++) {
                            EgovMap qstnMap = (EgovMap) qstnAllList.get(k);
                            int qstnNo = Integer.valueOf(StringUtil.nvl(qstnMap.get("qstnNo"), 0));
                            if(paperExamQstnNo == qstnNo) {
                                insertMap = qstnMap;
                                break;
                            }
                        }

                        if(seqQstnList.size() < paperList.size()) {
                            //시험쪽문항이 더적을때 시험지에 번호 재배정
                            int cnt = Integer.valueOf(StringUtil.nvl(insertMap.get("qstnNo"), 0));
                            for(int r = cnt + 1; r < paperList.size(); r++) {
                                EgovMap updateMap = (EgovMap) paperList.get(r);
                                ExamStarePaperVO updateVO = new ExamStarePaperVO();
                                updateVO.setExamCd(StringUtil.nvl(updateMap.get("examCd")));
                                updateVO.setExamQstnSn(Integer.valueOf(StringUtil.nvl(updateMap.get("examQstnSn"))));
                                updateVO.setStdNo(paperStdNo);
                                updateVO.setMdfrId(vo.getMdfrId());
                                updateVO.setQstnNo(r);
                                examStarePaperDAO.updateStarePaper(updateVO);
                            }
                        } else {
                            //시험쪽문항과 시험지문항이 같을떄 동일한 문항번호에 문제 추가

                            insertMap.put("emplRandomYn", StringUtil.nvl(vo.getEmplRandomYn(), "Y"));
                            insertMap.put("stdNo", stareVO.getStdId());
                            insertMap.put("rgtrId", vo.getMdfrId());
                            insertStarePaper(insertMap);
                        }
                    }
                }

            } else if(seqQstnList.size() > paperList.size()) {
                for(int p = 0; p < seqQstnList.size(); p++) {
                    ExamQstnVO examQstnVO = (ExamQstnVO) seqQstnList.get(p);
                    int qstnExamQstnNo = Integer.valueOf(StringUtil.nvl(examQstnVO.getQstnNo(), 0));
                    boolean insertYn = true;
                    for(int q = 0; q < paperList.size(); q++) {
                        EgovMap paperMap = (EgovMap) paperList.get(q);
                        int paperExamQstnNo = Integer.valueOf(StringUtil.nvl(paperMap.get("qstnNo"), 0));
                        if(qstnExamQstnNo == paperExamQstnNo) {
                            insertYn = false;
                            break;
                        }
                    }
                    if(insertYn) {
                        EgovMap insertMap = new EgovMap();
                        insertMap.put("emplRandomYn", StringUtil.nvl(vo.getEmplRandomYn(), "Y"));
                        insertMap.put("examCd", StringUtil.nvl(stareVO.getExamCd()));
                        insertMap.put("examQstnSn", StringUtil.nvl(examQstnVO.getExamQstnSn()));
                        insertMap.put("stdNo", StringUtil.nvl(stareVO.getStdId()));
                        insertMap.put("qstnNo", examQstnVO.getQstnNo());
                        insertMap.put("rgtrId", vo.getMdfrId());
                        insertStarePaper(insertMap);
                    }
                }
            }

            float totScore = 0.0f;
            for(int j = 0; j < paperList.size(); j++) {//점수 재산정
                EgovMap egovMap = (EgovMap) paperList.get(j);
                int examQstnSn = Integer.valueOf(StringUtil.nvl(egovMap.get("examQstnSn"), 0));
                float getScore = Float.valueOf(StringUtil.nvl(egovMap.get("getScore"), 0));
                float qstnScore = Float.valueOf(StringUtil.nvl(egovMap.get("qstnScore"), 0));

                //객관식 점수처리
                String qstnTypeCd = StringUtil.nvl(egovMap.get("qstnTypeCd"));
                int emplCnt = Integer.parseInt(StringUtil.nvl(egovMap.get("emplCnt"), "0"));
                String[] emplOdrArray = StringUtil.nvl(egovMap.get("examOdr")).split(",");
                String[] examOdrStr = new String[emplCnt];
                int examOdrCnt = 0;
                for(int m = 0; m < emplOdrArray.length; m++) {
                    if(Integer.parseInt(emplOdrArray[m]) <= emplCnt) {
                        examOdrStr[examOdrCnt] = emplOdrArray[m];
                        examOdrCnt++;
                    }
                }
                String ansr = StringUtil.nvl(egovMap.get("stareAnsr"));
                String rgtAnsr1 = StringUtil.nvl(egovMap.get("rgtAnsr1"));
                String multiRgtChoiceTypeCd = StringUtil.nvl(egovMap.get("multiRgtChoiceTypeCd"));
                String multiRgtChoiceYn = StringUtil.nvl(egovMap.get("multiRgtChoiceYn"));
                String errorAnsrYn = StringUtil.nvl(egovMap.get("errorAnsrYn"), "N");
                boolean grading = true;
                if("N".equals(errorAnsrYn)) {//전체정답처리 유무
                    if("CHOICE".equals(qstnTypeCd) || "MULTICHOICE".equals(qstnTypeCd)) {//객관식
                        if("Y".equals(multiRgtChoiceYn)) {//복수정답 여부(복수)
                            String[] ansrArr = ansr.split(",");
                            //랜덤문항 답안생성(응시답기준)
                            grading = false;
                            if(!"".equals(ansrArr[0])) {
                                for(int l = 0; l < ansrArr.length; l++) {
                                    if(rgtAnsr1.contains(examOdrStr[Integer.valueOf(ansrArr[l]) - 1])) {
                                        grading = true;
                                        break;
                                    }
                                }
                            }
                        } else {
                            String[] ansrArr = ansr.split(",");
                            if(!"".equals(ansrArr[0])) {
                                if(rgtAnsr1.split(",").length > 1) {//복수정답 여부(복수)
                                    String qstnAnsr = "";
                                    //랜덤문항 답안생성(응시답기준)
                                    for(int l = 0; l < ansrArr.length; l++) {
                                        if(l == 0) {
                                            qstnAnsr = examOdrStr[Integer.valueOf(ansrArr[l]) - 1];
                                        } else {
                                            qstnAnsr += "," + examOdrStr[Integer.valueOf(ansrArr[l]) - 1];
                                        }
                                    }
                                    if(!qstnAnsr.equals(rgtAnsr1)) {//정답비교
                                        grading = false;
                                    }
                                } else {//복수정답 여부(단수)
                                    if(!"".equals(ansr)) {//값유무 여부(있을때)
                                        if(!examOdrStr[Integer.valueOf(ansr) - 1].equals(rgtAnsr1)) {//정답비교
                                            grading = false;
                                        }
                                    } else {//값유무 여부(없을떄)
                                        grading = false;
                                    }
                                }
                            } else {
                                grading = false;
                            }
                        }
                    } else if("SHORT".equals(qstnTypeCd)) {//주관식 단답형
                        grading = false;
                        if("Y".equals(multiRgtChoiceYn)) {//복수정답 여부(복수)
                            if("A".equals(multiRgtChoiceTypeCd)) {//복수정답 유형(순서에 맞게정담)
                                String[] ansrArr = ansr.split("\\|");
                                for(int k = 0; k < ansrArr.length; k++) {
                                    String[] rgtAnsrArr = StringUtil.nvl(egovMap.get("rgtAnsr" + (k + 1))).split("\\|");
                                    for(int t = 0; t < rgtAnsrArr.length; t++) {
                                        if(ansrArr[k].equals(rgtAnsrArr[t])) { // 정답비교
                                            grading = true;
                                        }
                                    }
                                    if(!grading) {
                                        break;
                                    } else if(k != ansrArr.length - 1) {
                                        grading = false;
                                    }
                                }
                            } else if("B".equals(multiRgtChoiceTypeCd) || "C".equals(multiRgtChoiceTypeCd)) {//복수정답 유형(순서에 상관없이 정답)
                                String[] ansrArr = ansr.split("\\|");
                                if(!"".equals(ansrArr[0])) {
                                    for(int k = 0; k < ansrArr.length; k++) {
                                        for(int t = 0; t < ansrArr.length; t++) {
                                            String rgtAnsr = StringUtil.nvl(egovMap.get("rgtAnsr" + (t + 1)));
                                            if(!"".equals(rgtAnsr)) {
                                                if(rgtAnsr.contains(ansrArr[k])) {
                                                    grading = true;
                                                    break;
                                                }
                                            }
                                        }
                                        if(!grading) {
                                            break;
                                        } else if(k != ansrArr.length - 1) {
                                            grading = false;
                                        }
                                    }
                                }
                            }
                        } else {//복수정답 여부(단수)
                            String[] rgtAnsrArr = rgtAnsr1.split("\\|");
                            for(int k = 0; k < rgtAnsrArr.length; k++) {
                                if(ansr.equals(rgtAnsrArr[k])) { // 정답비교
                                    grading = true;
                                    break;
                                }
                            }
                        }
                    } else if("MATCH".equals(qstnTypeCd)) {//짝짓기형

                        String[] rgtAnsrArr = rgtAnsr1.split("\\|");
                        String qstnAnsr = "";
                        //랜덤문항 답안생성(정답기준)
                        for(int l = 0; l < examOdrStr.length; l++) {
                            if(Integer.valueOf(examOdrStr[l]) <= rgtAnsrArr.length) {
                                if(qstnAnsr.length() == 0) {
                                    qstnAnsr = rgtAnsrArr[(Integer.valueOf(examOdrStr[l]) - 1)];
                                } else {
                                    qstnAnsr += "|" + rgtAnsrArr[(Integer.valueOf(examOdrStr[l]) - 1)];
                                }
                            }
                        }
                        if(!qstnAnsr.equals(ansr)) {//정답비교
                            grading = false;
                        }
                    } else {
                        if(!ansr.equals(rgtAnsr1)) {//정답비교
                            grading = false;
                        }
                    }
                }
                if(grading && !"".equals(ansr)) {//정답유무
                    getScore = qstnScore;
                    totScore += qstnScore;
                } else {
                    getScore = 0;
                }
                //취득점수 등록
                starePaperVO.setExamCd(stareVO.getExamCd());
                starePaperVO.setExamQstnSn(examQstnSn);
                starePaperVO.setStdNo(stareVO.getStdId());
                starePaperVO.setGetScore(getScore);
                starePaperVO.setMdfrId(vo.getMdfrId());
                examStarePaperDAO.updateStarePaper(starePaperVO);
            }

            //stare테이블에 update
            stareVO.setTotGetScore(totScore);
            stareVO.setMdfrId(vo.getMdfrId());
            examStareDAO.updateExamStare(stareVO);
        }
    }

    public void insertStarePaper(EgovMap egovMap) throws Exception {
        String emplRandomYn = StringUtil.nvl(egovMap.get("emplRandomYn"), "Y");
        String examCd = StringUtil.nvl(egovMap.get("examCd"));
        int examQstnSn = Integer.valueOf(StringUtil.nvl(egovMap.get("examQstnSn")));
        String stdNo = StringUtil.nvl(egovMap.get("stdNo"));
        int qstnNo = Integer.valueOf(StringUtil.nvl(egovMap.get("qstnNo")));
        String rgtrId = StringUtil.nvl(egovMap.get("rgtrId"));
        ExamStarePaperVO espvo = new ExamStarePaperVO();
        // 보기순서 1~10까지의 정수를 랜덤하게 출력
        // nextInt 에 10 을 입력하면 0~9 까지의 데이타가 추출되므로 +1 을 한것이다.
        Random random = new Random();
        int dataArray[] = new int[10];
        String data = "";
        for(int k = 0; k < 10; k++) {
            if("Y".equals(emplRandomYn)) {
                dataArray[k] = Integer.valueOf(random.nextInt(10) + 1);
                for(int l = 0; l < k; l++) {
                    if(dataArray[k] == dataArray[l]) {
                        k--;
                    }
                }
            } else {
                dataArray[k] = k + 1;
            }
        }
        for(int m = 0; m < dataArray.length; m++) {
            if(m == 0) {
                data += dataArray[m];
            } else {
                data += "," + dataArray[m];
            }
        }
        espvo.setExamCd(examCd);
        espvo.setExamQstnSn(examQstnSn);
        espvo.setStdNo(stdNo);
        espvo.setQstnNo(qstnNo);
        espvo.setSubNo(1);
        espvo.setGetScore(0.0f);
        espvo.setRgtrId(rgtrId);
        espvo.setMdfrId(rgtrId);
        espvo.setExamOdr(data);
        examStarePaperDAO.insertExamStarePaper(espvo);
    }

    /*****************************************************
     * <p>
     * TODO 시험 성적 반영 점수 합산 조회
     * </p>
     * 시험 성적 반영 점수 합산 조회
     *
     * @param ExamVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int sumScoreRatio(ExamVO vo) throws Exception {
        return examDAO.sumScoreRatio(vo);
    }

    /*****************************************************
     * <p>
     * TODO 시험 문제 보기문항 통계 바차트
     * </p>
     * 시험 문제 보기문항 통계 바차트
     *
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<EgovMap> examQstnBarChart(ExamStarePaperVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        List<EgovMap> returnList = new ArrayList<>();
        EgovMap returnMap = new EgovMap();
        List<EgovMap> examQstnList = (List<EgovMap>) examStarePaperDAO.paperQstnlist(vo);
        int emplCnt = Integer.parseInt(StringUtil.nvl(examQstnList.get(0).get("emplCnt")));
        String typeCd = StringUtil.nvl(examQstnList.get(0).get("qstnTypeCd"));
        if("OX".equals(typeCd)) {
            emplCnt = 2;
        }

        EgovMap emplMap = new EgovMap();
        String[] emplAlphabetArray = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J"};
        List<String> backgroundColorArray = new ArrayList<String>();

        //보기 항목 세팅 및 백그라운드 색배치
        for(int i = 0; i < emplCnt; i++) {
            emplMap.put(emplAlphabetArray[i], 0);
            backgroundColorArray.add("rgba(153, 102, 255, .8)");
        }

        Double stareAnsrTotalCnt = 0.0;
        //각보기별 답변개수
        for(int i = 0; i < examQstnList.size(); i++) {
            EgovMap examQstnMap = examQstnList.get(i);
            String[] emplOdrArray = StringUtil.nvl(examQstnMap.get("examOdr")).split("\\,");
            List<String> realEmplOdrArray = new ArrayList<>();
            for(int j = 0; j < emplOdrArray.length; j++) {
                if(Integer.parseInt(emplOdrArray[j]) <= emplCnt) {
                    realEmplOdrArray.add(emplOdrArray[j]);
                }
            }
            String[] stareAnsrArray = StringUtil.nvl(examQstnMap.get("stareAnsr")).split("\\|");
            String qstnTypeCd = StringUtil.nvl(examQstnMap.get("qstnTypeCd"));
            for(int j = 0; j < emplCnt; j++) {
                for(int l = 0; l < stareAnsrArray.length; l++) {
                    if(qstnTypeCd.equals("CHOICE") || qstnTypeCd.equals("MULTICHOICE")) {
                        String stareAnsr = "";
                        for(int k = 0; k < realEmplOdrArray.size(); k++) {
                            String[] answerArray = StringUtil.nvl(stareAnsrArray[l]).split(",");
                            for(int t = 0; t < answerArray.length; t++) {
                                if((k + 1) == Integer.parseInt(StringUtil.nvl(answerArray[t], "0"))) {
                                    stareAnsr = realEmplOdrArray.get(k);
                                    break;
                                }
                            }
                        }
                        if(Integer.parseInt(StringUtil.nvl(stareAnsr, "0")) == (j + 1)) {
                            stareAnsrTotalCnt++;
                            String emplAlphabet = StringUtil.nvl(emplAlphabetArray[j]).toLowerCase();
                            emplMap.put(emplAlphabetArray[j], Integer.parseInt(StringUtil.nvl(emplMap.get(emplAlphabet), "0")) + 1);
                        }
                    }
                }
            }
        }

        //각보기별 답변 백분율
        for(int i = 0; i < emplCnt; i++) {
            Double emplTotalCnt = Double.parseDouble(StringUtil.nvl(emplMap.get(StringUtil.nvl(emplAlphabetArray[i]).toLowerCase())));
            emplMap.put(emplAlphabetArray[i], Math.round(((emplTotalCnt / stareAnsrTotalCnt) * 100)));
        }

        returnMap.put("backgroundColorArray", JsonUtil.getJsonString(backgroundColorArray));
        returnMap.put("emplMap", JsonUtil.getJsonString(emplMap));
        returnMap.put("examQstnList", examQstnList);
        returnList.add(returnMap);
        resultVO.setReturnList(returnList);

        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 시험 문제 정답 통계 파이차트
     * </p>
     * 시험 문제 정답 통계 파이차트
     *
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<EgovMap> examQstnPieChart(ExamStarePaperVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        List<EgovMap> returnList = new ArrayList<>();
        EgovMap returnMap = new EgovMap();
        List<EgovMap> examQstnList = (List<EgovMap>) examStarePaperDAO.paperQstnlist(vo);

        List<String> backgroundColorArray = new ArrayList<>();
        backgroundColorArray.add("#36a2eb");
        backgroundColorArray.add("#ff6384");
        EgovMap emplMap = new EgovMap();
        emplMap.put("정답", 0);
        emplMap.put("오답", 0);

        Double stareAnsrTotalCnt = 0.0;
        //각보기별 답변개수
        for(int i = 0; i < examQstnList.size(); i++) {
            EgovMap examQstnMap = examQstnList.get(i);
            int getScore = Integer.parseInt(StringUtil.nvl(examQstnMap.get("getScore"), "0"));
            if(getScore > 0) {
                emplMap.put("정답", Integer.parseInt(StringUtil.nvl(emplMap.get("정답"), "0")) + 1);
            } else {
                emplMap.put("오답", Integer.parseInt(StringUtil.nvl(emplMap.get("오답"), "0")) + 1);
            }
            stareAnsrTotalCnt++;
        }

        returnMap.put("backgroundColorArray", JsonUtil.getJsonString(backgroundColorArray));
        returnMap.put("emplMap", JsonUtil.getJsonString(emplMap));
        returnMap.put("examQstnList", examQstnList);
        returnList.add(returnMap);
        resultVO.setReturnList(returnList);

        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 시험지 문항 전체정답처리 및 성적 점수 수정
     * </p>
     * 시험지 문항 전체정답처리 및 성적 점수 수정
     *
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateQstnAllRightScore(ExamStarePaperVO vo) throws Exception {
        vo.setExamCd(vo.getExamCd());
        vo.setExamQstnSn(vo.getExamQstnSn());
        vo.setGetScore(Float.parseFloat(StringUtil.nvl(vo.getQstnScoreArr(), "0")));
        vo.setMdfrId(vo.getMdfrId());
        examStarePaperDAO.updateStarePaper(vo);

        //학습자정보
        ExamStareVO esvo = new ExamStareVO();
        esvo.setExamCd(vo.getExamCd());
        esvo.setStareStatusCd("C");
        List<EgovMap> listStdVo = examStareDAO.listExamTargetStd(esvo);

        //전체점수 가감
        for(int i = 0; i < listStdVo.size(); i++) {
            ExamStareVO examStareVO = new ExamStareVO();
            examStareVO.setExamCd(vo.getExamCd());
            examStareVO.setMdfrId(vo.getMdfrId());
            examStareVO.setStareStatusCd("C");
            EgovMap egovMap = listStdVo.get(i);
            String stdNo = StringUtil.nvl(egovMap.get("stdNo"));
            String totGetScore = StringUtil.nvl(egovMap.get("totGetScore"), "0.0f");
            float preScore = Float.parseFloat(totGetScore);
            String qstnScoreArr = StringUtil.nvl(vo.getQstnScoreArr(), "0");
            //점수계산
            examStareVO.setTotGetScore(preScore + Float.parseFloat(qstnScoreArr));
            if(examStareVO.getTotGetScore() > 100) {
                //최대 평가점수 초과 방지
                examStareVO.setTotGetScore(100.0f);
            } else if(examStareVO.getTotGetScore() < 0) {
                //최소 평가점수 미만 방지
                examStareVO.setTotGetScore(0.0f);
            }

            List<String> listTargetStdNo = new ArrayList<>();
            listTargetStdNo.add(stdNo);
            examStareVO.setStdNoList(listTargetStdNo);
            examStareDAO.updateExamStareScore(examStareVO);
        }

        //시험문제
        ExamQstnVO examQstnVO = new ExamQstnVO();
        examQstnVO.setExamCd(vo.getExamCd());
        examQstnVO.setExamQstnSn(vo.getExamQstnSn());
        examQstnVO.setErrorAnsrYn("Y");
        examQstnVO.setMdfrId(vo.getMdfrId());
        examQstnDAO.updateExamQstn(examQstnVO);
    }

    // 첨부파일 등록
    private FileVO addFile(ExamVO vo) throws Exception {
        FileVO fileVO = new FileVO();
        if(!"".equals(StringUtil.nvl(vo.getUploadFiles()))) {
            fileVO.setUploadFiles(StringUtil.nvl(vo.getUploadFiles()));
            fileVO.setCopyFiles(StringUtil.nvl(vo.getCopyFiles()));
            fileVO.setFilePath(vo.getUploadPath());
            fileVO.setRepoCd(vo.getRepoCd());
            fileVO.setRgtrId(vo.getRgtrId());
            fileVO.setFileBindDataSn(vo.getExamCd());
            fileVO = sysFileService.addFile(fileVO);
        }
        return fileVO;
    }

    // 첨부파일 복사
    private void copyFile(ExamVO vo, FileVO fileVO) throws Exception {
        if(!"".equals(StringUtil.nvl(vo.getUploadFiles()))) {
            FileVO fvo = new FileVO();
            fvo.setUploadFiles(StringUtil.nvl(vo.getUploadFiles()));
            fvo.setCopyFiles(StringUtil.nvl(vo.getCopyFiles()));
            fvo.setFilePath(vo.getUploadPath());
            fvo.setRepoCd(vo.getRepoCd());
            fvo.setRgtrId(vo.getRgtrId());
            fvo.setFileBindDataSn(vo.getExamCd());
            fvo.setFileList(fileVO.getFileList());
            sysFileService.copyFile(fvo);
        }
    }

    /*****************************************************
     * <p>
     * TODO 시험 성적 공개 여부 수정
     * </p>
     * 시험 성적 공개 여부 수정
     *
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateExamScoreOpen(ExamVO vo) throws Exception {
        ExamVO examVO = examDAO.select(vo);
        String examTypeCd = StringUtil.nvl(examVO.getExamTypeCd());
        String insRefCd = StringUtil.nvl(examVO.getInsRefCd());
        String type = insRefCd.split("-")[0];
        String scoreOpenYn = StringUtil.nvl(vo.getScoreOpenYn());

        examDAO.updateExam(vo);
        if("QUIZ".equals(examTypeCd) || "EXAM".equals(type)) {
            ExamVO quizVO = new ExamVO();
            quizVO.setScoreOpenYn(scoreOpenYn);
            quizVO.setGradeViewYn(StringUtil.nvl(vo.getGradeViewYn()));
            quizVO.setMdfrId(StringUtil.nvl(vo.getMdfrId()));
            examDAO.updateExam(quizVO);
        } else if("ASMNT".equals(examTypeCd) || "ASMNT".equals(type)) {
            AsmtVO asmtVO = new AsmtVO();
            asmtVO.setMrkOyn(scoreOpenYn);
            asmtVO.setAsmtId(insRefCd);
            asmntDAO.updateScoreOpen(asmtVO);
        } else if("FORUM".equals(examTypeCd) || "FORUM".equals(type)) {
            ForumVO forumVO = new ForumVO();
            forumVO.setScoreOpenYn(scoreOpenYn);
            forumVO.setForumCd(insRefCd);
            forumDAO.updateForum(forumVO);
        }
    }

    /*****************************************************
     * <p>
     * TODO 시험 암호화용 파라미터 정보 조회
     * </p>
     * 시험 암호화용 파라미터 정보 조회
     *
     * @param ExamVO
     * @return ExamVO
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectExamEncryptoInfo(ExamVO vo) throws Exception {
        return examDAO.selectExamEncryptoInfo(vo);
    }

    /*****************************************************
     * <p>
     * TODO 시험과목 정보 조회
     * </p>
     * 시험과목 정보 조회
     *
     * @param ExamVO
     * @return ExamVO
     * @throws Exception
     ******************************************************/
    @Override
    public ExamVO selectCreCrsByExam(ExamVO vo) throws Exception {
        return examDAO.selectCreCrsByExam(vo);
    }

    /*****************************************************
     * <p>
     * TODO 중간/기말 대체 목록 조회
     * </p>
     * 중간/기말 대체 목록 조회
     *
     * @param ExamVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listExamByInsRef(ExamVO vo) throws Exception {
        return examDAO.listExamByInsRef(vo);
    }

    /*****************************************************
     * <p>
     * TODO 중간/기말 수시, 외국어 시험 목록 조회
     * </p>
     * 중간/기말 수시, 외국어 시험 목록 조회
     *
     * @param ExamVO
     * @return List<ExamVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamVO> listExamByEtc(ExamVO vo) throws Exception {
        return examDAO.listExamByEtc(vo);
    }

    /*****************************************************
     * <p>
     * TODO 시험 응시 유형 카운트
     * </p>
     * 시험 응시 유형 카운트
     *
     * @param ExamVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int selectStareTypeCount(ExamVO vo) throws Exception {
        return examDAO.selectStareTypeCount(vo);
    }

    /*****************************************************
     * <p>
     * TODO 시험 기타, 대체 과제 정보 조회
     * </p>
     * 시험 기타, 대체 과제 정보 조회
     *
     * @param ExamVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectExamInsInfo(ExamVO vo) throws Exception {
        EgovMap eMap = examDAO.selectExamInsInfo(vo);
        if(eMap != null) {
            List<FileVO> fileList = new ArrayList<FileVO>();
            if("ASMNT".equals(eMap.get("typeCd"))) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("ASMNT");
                fileVO.setFileBindDataSn(vo.getInsRefCd());
                fileList = sysFileService.list(fileVO).getReturnList();
            } else if("FORUM".equals(eMap.get("typeCd"))) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("FORUM");
                fileVO.setFileBindDataSn(vo.getInsRefCd());
                fileList = sysFileService.list(fileVO).getReturnList();
            } else if("EXAM".equals(eMap.get("typeCd"))) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("EXAM_CD");
                if(!"".equals(StringUtil.nvl(vo.getInsRefCd()))) {
                    fileVO.setFileBindDataSn(vo.getInsRefCd());
                } else {
                    fileVO.setFileBindDataSn(vo.getExamCd());
                }
                fileList = sysFileService.list(fileVO).getReturnList();
            }
            eMap.put("fileList", fileList);
        }

        return eMap;
    }

    /*****************************************************
     * <p>
     * TODO 시험 기타, 대체 과제 미참여자 목록 조회
     * </p>
     * 시험 기타, 대체 과제 미참여자 목록 조회
     *
     * @param ExamVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listExamInsUser(ExamVO vo) throws Exception {
        return examDAO.listExamInsUser(vo);
    }

    // 시험 응시 사전 등록
    @Override
    public void insertExamStare(ExamVO vo, String crsCreCd) throws Exception {
        ExamStareVO examStareVO = new ExamStareVO();
        examStareVO.setCrsCreCd(crsCreCd);
        examStareVO.setExamCd(vo.getExamCd());
        List<ExamStareVO> stdList = examStareDAO.listExamNonStare(examStareVO);
        List<ExamStareVO> list = new ArrayList<>();

        for(ExamStareVO svo : stdList) {
            ExamStareVO stareVO = new ExamStareVO();
            stareVO.setStdId(svo.getStdId());
            stareVO.setExamCd(vo.getExamCd());
            stareVO.setStareSn(svo.getStdId() + vo.getExamCd());  // 신규키값_모사
            stareVO.setStareCnt(0);
            stareVO.setStareTm(0);
            stareVO.setEvalYn("N");
            stareVO.setRgtrId(vo.getRgtrId());
            stareVO.setMdfrId(vo.getMdfrId());
            stareVO.setReExamYn("N");

            list.add(stareVO);
        }

        if(list.size() > 0) {
            examStareDAO.insertExamStareBatch(list);
        }
    }

    /*****************************************************
     * <p>
     * TODO 대체 과제, 토론, 퀴즈 삭제시 시험 대체코드 삭제
     * </p>
     * 대체 과제, 토론, 퀴즈 삭제시 시험 대체코드 삭제
     *
     * @param String
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void examInsDelete(String insRefCd) throws Exception {
        // 대체과제 여부 조회
        ExamVO examVO = new ExamVO();
        examVO.setInsRefCd(insRefCd);
        examVO = examDAO.selectByInsRefCd(examVO);
        if(examVO != null) {
            examVO = examDAO.select(examVO);
            ExamVO evo = new ExamVO();
            evo.setExamCd(examVO.getExamCd());
            if("EXAM".equals(StringUtil.nvl(examVO.getExamCtgrCd())) && "A".equals(StringUtil.nvl(examVO.getExamStareTypeCd()))) {
                evo.setMdfrId(examVO.getMdfrId());
                examDAO.updateExamCreCrsRltnDelYn(evo);
                examDAO.updateExamDelYn(evo);
            } else if(!"EXAM".equals(StringUtil.nvl(examVO.getExamTypeCd()))) {
                evo.setExamTypeCd("ETC");
                examDAO.resetInsRef(evo);
            }
        }
    }

    /*****************************************************
     * <p>
     * TODO 대체 과제, 토론, 퀴즈 등록, 수정
     * </p>
     * 대체 과제, 토론, 퀴즈 등록, 수정
     *
     * @param examVO, quizVO, asmtVO, forumVO
     * @return ExamVO
     * @throws Exception
     ******************************************************/
    @Override
    public ExamVO examInsRefManage(ExamVO examVO, AsmtVO asmtVO, ForumVO forumVO, HttpServletRequest request) throws Exception {
        ExamVO evo = examDAO.select(examVO);
        String oldInsTypeCd = StringUtil.nvl(evo.getInsRefCd()).split("_")[0];
        String newInsTypeCd = "QUIZ".equals(StringUtil.nvl(examVO.getExamTypeCd())) ? "EXAM" : StringUtil.nvl(examVO.getExamTypeCd());
        // 대체 과제 유형 변경 시 이전 과제 삭제
        if(!"ETC".equals(evo.getExamTypeCd()) && !"".equals(oldInsTypeCd) && !oldInsTypeCd.equals(newInsTypeCd)) {
            if("EXAM".equals(oldInsTypeCd)) {
                ExamVO qvo = new ExamVO();
                qvo.setExamCd(StringUtil.nvl(evo.getInsRefCd()));
                qvo.setMdfrId(examVO.getMdfrId());
                updateExamDelYn(qvo);
                examInsDelete(StringUtil.nvl(evo.getInsRefCd()));
            } else if("ASMNT".equals(oldInsTypeCd)) {
                AsmtVO avo = new AsmtVO();
                avo.setSearchMenu("delete");
                avo.setAsmtId(StringUtil.nvl(evo.getInsRefCd()));
                avo.setMdfrId(examVO.getMdfrId());
                asmntService.examAsmntManage(avo, request);
            } else if("FORUM".equals(oldInsTypeCd)) {
                ForumVO fvo = new ForumVO();
                fvo.setSearchMenu("delete");
                fvo.setForumCd(StringUtil.nvl(evo.getInsRefCd()));
                fvo.setMdfrId(examVO.getMdfrId());
                forumService.examForumManage(fvo, request);
            }
        }

        // 값 설정
        ExamVO quizVO = new ExamVO();
        quizVO.setRgtrId(examVO.getRgtrId());
        quizVO.setMdfrId(examVO.getMdfrId());
        quizVO.setOrgId(examVO.getOrgId());
        quizVO.setExamTitle(examVO.getInsTitle());
        quizVO.setExamCts(examVO.getInsCts());
        quizVO.setExamStartDttm(examVO.getInsStartDttm());
        quizVO.setExamEndDttm(examVO.getInsEndDttm());
        quizVO.setScoreAplyYn(examVO.getInsScoreAplyYn());
        quizVO.setScoreOpenYn(examVO.getInsScoreOpenYn());
        quizVO.setExamStareTm(examVO.getExamStareTm());
        quizVO.setViewQstnTypeCd(examVO.getViewQstnTypeCd());
        quizVO.setQstnSetTypeCd(examVO.getQstnSetTypeCd());
        quizVO.setEmplRandomYn(examVO.getEmplRandomYn());
        quizVO.setGradeViewYn(examVO.getGradeViewYn());
        quizVO.setDeclsRegYn("N");
        quizVO.setReExamYn(StringUtil.nvl(examVO.getReExamYn(), "Y"));
        quizVO.setCrsCreCd(examVO.getCrsCreCd());
        quizVO.setRepoCd(examVO.getRepoCd());
        quizVO.setUploadFiles(examVO.getUploadFiles());
        quizVO.setUploadPath(examVO.getUploadPath());
        asmtVO.setUserId(examVO.getRgtrId());
        asmtVO.setRgtrId(examVO.getRgtrId());
        asmtVO.setMdfrId(examVO.getMdfrId());
        asmtVO.setAsmtTtl(examVO.getInsTitle());
        asmtVO.setAsmtCts(examVO.getInsCts());
        asmtVO.setAsmtSbmsnSdttm(examVO.getInsStartDttm());
        asmtVO.setSendEndDttm(examVO.getInsEndDttm());
        asmtVO.setMrkRfltyn(examVO.getInsScoreAplyYn());
        asmtVO.setMrkOyn(examVO.getInsScoreOpenYn());
        asmtVO.setOrgId(examVO.getOrgId());
        forumVO.setRgtrId(examVO.getRgtrId());
        forumVO.setMdfrId(examVO.getMdfrId());
        forumVO.setForumTitle(examVO.getInsTitle());
        forumVO.setForumArtl(examVO.getInsCts());
        forumVO.setForumStartDttm(examVO.getInsStartDttm());
        forumVO.setForumEndDttm(examVO.getInsEndDttm());
        forumVO.setScoreAplyYn(examVO.getInsScoreAplyYn());
        forumVO.setScoreOpenYn(examVO.getInsScoreOpenYn());
        examVO.setExamStartDttm("".equals(examVO.getExamStartDttm()) ? examVO.getInsStartDttm() : examVO.getExamStartDttm());
        examVO.setExamEndDttm("".equals(examVO.getExamEndDttm()) ? examVO.getInsEndDttm() : examVO.getExamEndDttm());

        // 대체 과제 등록
        if("ETC".equals(evo.getExamTypeCd()) || "".equals(oldInsTypeCd) || (!"".equals(oldInsTypeCd) && !oldInsTypeCd.equals(newInsTypeCd))) {
            if("EXAM".equals(newInsTypeCd)) {
                quizVO.setExamCd("");
                quizVO.setExamCtgrCd("QUIZ");
                quizVO.setExamTypeCd(examVO.getInsTypeCd());
                quizVO.setExamStareTypeCd(StringUtil.nvl(examVO.getExamStareTypeCd(), "A"));
                quizVO.setExamTmTypeCd("REMAINDER");
                quizVO.setViewTmTypeCd("LEFT");
                quizVO.setUseYn("Y");
                quizVO.setRegYn("Y");
                quizVO = insertExam(quizVO);
                examVO.setInsRefCd(quizVO.getExamCd());
            } else if("ASMNT".equals(newInsTypeCd)) {
                asmtVO.setSearchMenu("insert");
                asmtVO.setAsmtGbncd(examVO.getInsTypeCd());
                asmntService.examAsmntManage(asmtVO, request);
                examVO.setInsRefCd(asmtVO.getAsmtId());
            } else if("FORUM".equals(newInsTypeCd)) {
                forumVO.setSearchMenu("insert");
                forumVO.setForumCtgrCd(examVO.getInsTypeCd());
                forumService.examForumManage(forumVO, request);
                examVO.setInsRefCd(forumVO.getForumCd());
            }
            if(!"".equals(evo.getExamTypeCd()) && "EXAM".equals(evo.getExamTypeCd())) {
                examVO.setExamTypeCd("EXAM");
            }
            ExamVO evo2 = new ExamVO();
            evo2.setExamCd(examVO.getExamCd());
            evo2.setMdfrId(examVO.getMdfrId());
            evo2.setInsRefCd(examVO.getInsRefCd());
            evo2.setExamTypeCd(examVO.getExamTypeCd());
            evo2.setExamStartDttm(examVO.getExamStartDttm());
            evo2.setExamEndDttm(examVO.getExamEndDttm());
            examDAO.updateExam(evo2);
            // 대체 과제 수정
        } else {
            if("EXAM".equals(newInsTypeCd)) {
                quizVO.setExamCd(examVO.getInsRefCd());
                examDAO.updateExam(quizVO);
            } else if("ASMNT".equals(newInsTypeCd)) {
                asmtVO.setAsmtId(examVO.getInsRefCd());
                asmtVO.setSearchMenu("update");
                asmntService.examAsmntManage(asmtVO, request);
            } else if("FORUM".equals(newInsTypeCd)) {
                forumVO.setForumCd(examVO.getInsRefCd());
                forumVO.setSearchMenu("update");
                forumService.examForumManage(forumVO, request);
            }
        }

        return examVO;
    }

    // 퀴즈 가져오기 문제 복사
    public void insertExamQstn(ExamVO vo) throws Exception {
        if(!"".equals(StringUtil.nvl(vo.getSearchTo()))) {
            // 기존 문제 삭제
            ExamQstnVO qvo = new ExamQstnVO();
            qvo.setExamCd(vo.getExamCd());
            examQstnDAO.updateExamQstnDelYn(qvo);

            // 복사
            ExamQstnVO qstnVO = new ExamQstnVO();
            qstnVO.setExamCd(StringUtil.nvl(vo.getSearchTo()));
            List<ExamQstnVO> qstnList = examQstnDAO.list(qstnVO);
            for(ExamQstnVO qsvo : qstnList) {
                qsvo.setExamCd(StringUtil.nvl(vo.getExamCd()));
                int examQstnSn = examQstnDAO.selectKey();
                qsvo.setExamQstnSn(examQstnSn);
                qsvo.setRgtrId(StringUtil.nvl(vo.getRgtrId()));
                qsvo.setMdfrId(StringUtil.nvl(vo.getMdfrId()));
                examQstnDAO.insertExamQstn(qsvo);
            }
        }
    }

    // 중간/기말 시작 여부
    @Override
    public ExamVO selectExamWait(ExamVO vo) throws Exception {
        return examDAO.selectExamWait(vo);
    }

    /*****************************************************
     * <p>
     * TODO 중간/기말 대체평가 연결 가능 목록
     * </p>
     * 중간/기말 대체평가 연결 가능 목록
     *
     * @param ExamVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<EgovMap> listSetInsRef(ExamVO vo) throws Exception {
        ProcessResultVO<EgovMap> returnVO = new ProcessResultVO<EgovMap>();

        try {
            List<EgovMap> returnList = examDAO.listSetInsRef(vo);
            returnVO.setReturnList(returnList);
            returnVO.setResult(1);
        } catch(Exception e) {
            returnVO.setResult(-1);
        }

        return returnVO;
    }

    /*****************************************************
     * <p>
     * TODO 중간/기말 대체평가 연결
     * </p>
     * 중간/기말 대체평가 연결
     *
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void setInsRef(ExamVO vo) throws Exception {
        if("QUIZ".equals(vo.getExamTypeCd())) {
            ExamVO evo = new ExamVO();
            evo.setExamCd(vo.getInsRefCd());
            evo.setExamTypeCd("EXAM");
            evo.setExamStareTypeCd(vo.getExamStareTypeCd());
            evo.setMdfrId(vo.getMdfrId());
            examDAO.updateExam(evo);
        } else if("ASMNT".equals(vo.getExamTypeCd())) {
            AsmtVO avo = new AsmtVO();
            avo.setAsmtId(vo.getInsRefCd());
            avo.setAsmtGbncd("EXAM");
            avo.setMdfrId(vo.getMdfrId());
            asmntDAO.updateAsmnt(avo);
        } else if("FORUM".equals(vo.getExamTypeCd())) {
            ForumVO fvo = new ForumVO();
            fvo.setForumCd(vo.getInsRefCd());
            fvo.setForumCtgrCd("EXAM");
            fvo.setMdfrId(vo.getMdfrId());
            forumDAO.updateForum(fvo);
        }
        examDAO.updateExam(vo);
    }

    /*****************************************************
     * <p>
     * TODO 중간/기말 대체평가 연결해제
     * </p>
     * 중간/기말 대체평가 연결해제
     *
     * @param ExamVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void setInsRefCancel(ExamVO vo) throws Exception {
        if("QUIZ".equals(vo.getExamTypeCd())) {
            ExamVO evo = new ExamVO();
            evo.setExamCd(vo.getInsRefCd());
            evo.setExamTypeCd("QUIZ");
            evo.setExamStareTypeCd("A");
            evo.setMdfrId(vo.getMdfrId());
            examDAO.updateExam(evo);
        } else if("ASMNT".equals(vo.getExamTypeCd())) {
            AsmtVO asmtVO = new AsmtVO();
            asmtVO.setAsmtId(vo.getInsRefCd());
            asmtVO = asmntDAO.selectObject(asmtVO);

            AsmtVO avo = new AsmtVO();
            avo.setAsmtId(vo.getInsRefCd());
            if("Y".equals(StringUtil.nvl(asmtVO.getTeamAsmtStngyn()))) {
                avo.setAsmtGbncd("TEAM");
            } else {
                avo.setAsmtGbncd("NOMAL");
            }
            avo.setMdfrId(vo.getMdfrId());
            asmntDAO.updateAsmnt(avo);
        } else if("FORUM".equals(vo.getExamTypeCd())) {
            ForumVO fvo = new ForumVO();
            fvo.setForumCd(vo.getInsRefCd());
            fvo.setForumCtgrCd("NOMAL");
            fvo.setMdfrId(vo.getMdfrId());
            forumDAO.updateForum(fvo);
        }
        vo.setExamTypeCd("ETC");
        examDAO.resetInsRef(vo);
    }

}
