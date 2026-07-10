package knou.lms.lecture2.facade.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.StringUtil;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.lecture2.facade.LctrPlandocFacadeService;
import knou.lms.lecture2.service.LctrPlandocService;
import knou.lms.lecture2.service.LectureScheduleService;
import knou.lms.lecture2.vo.LctrPlandocVO;
import knou.lms.lecture2.vo.LctrPlandocView;
import knou.lms.mrk.service.MarkItemSettingService;
import knou.lms.mrk.vo.MarkItemSettingVO;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.user.CurrentUser;

@Service("lctrPlandocFacadeService")
public class LctrPlandocFacadeServiceImpl extends ServiceBase implements LctrPlandocFacadeService {
    private static final Logger log = LoggerFactory.getLogger(LctrPlandocFacadeServiceImpl.class);


    @Resource(name="lctrPlandocService")
    private LctrPlandocService lctrPlandocService;

    @Resource(name="subjectService")
    private SubjectService subjectService;

    @Resource(name="cmmnCdService")
    private CmmnCdService cmmnCdService;

    @Resource(name="lectureScheduleService")
    private LectureScheduleService lectureScheduleService;

    @Resource(name="markItemSettingService")
    private MarkItemSettingService markItemSettingService;
    @Resource(name="attachFileService")
    private AttachFileService attachFileService;
    @Resource(name="semesterService")
    private SemesterService semesterService;


    private static final String LCTR_NOTE_FILE_TYCD = "LCTR_NOTE";
    private static final String LCTR_VOICE_FILE_TYCD = "LCTR_VOICE";
    private static final String LCTR_TRAINING_FILE_TYCD = "LCTR_TRAINING";


    /**
     * 강의계획서 상세
     *
     * @param userCtx
     * @param lctrPlandocVO
     * @return
     * @throws Exception
     */
    @Override
    public LctrPlandocView loadLctrPlandocView(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx) throws Exception {
        LctrPlandocView lpv = new LctrPlandocView();
        String sbjctId = lctrPlandocVO.getSbjctId();

        SubjectDTO sbjctDto = new SubjectDTO(userCtx, sbjctId);

        log.info("sbjctId={}", sbjctId);

        // 과목정보, 장애인/고령자 지원
        SubjectVO subjectVO = subjectService.subjectSelect(sbjctDto);
        lpv.setSubjectInfo(subjectVO);

        // 교수/튜터/조교 정보
        List<EgovMap> sbjctAdmList = subjectService.sbjctAdmList(sbjctDto);
        List<EgovMap> profList = new ArrayList<>();
        List<EgovMap> coprofList = new ArrayList<>();
        List<EgovMap> tutList = new ArrayList<>();
        List<EgovMap> assiList = new ArrayList<>();

        for(EgovMap m : sbjctAdmList) {
            String sbjctAdmTycd = String.valueOf(m.get("sbjctAdmTycd"));

            if(CommConst.SBJCT_ADM_TYCD_PROF.equals(sbjctAdmTycd)) {
                profList.add(m);
            } else if(CommConst.SBJCT_ADM_TYCD_COPROF.equals(sbjctAdmTycd)) {
                coprofList.add(m);
            } else if(CommConst.SBJCT_ADM_TYCD_TUT.equals(sbjctAdmTycd)) {
                tutList.add(m);
            } else if(CommConst.SBJCT_ADM_TYCD_ASSI.equals(sbjctAdmTycd)) {
                assiList.add(m);
            }
        }

        if(!profList.isEmpty()) {
            lpv.setProfInfo(profList.get(0));
        }

        lpv.setCoprofList(coprofList);
        lpv.setTutList(tutList);
        lpv.setAssiList(assiList);

        // 강의계획서 정보
        LctrPlandocVO lctrPlandocInfo = lctrPlandocService.lctrPlandocSelect(sbjctId);
        if(lctrPlandocInfo == null) {
            lctrPlandocInfo = new LctrPlandocVO(sbjctId);
        }
        lpv.setLctrPlandocInfo(lctrPlandocInfo);


        // 교재
        lpv.setTxtbkList(lctrPlandocService.txtbkList(sbjctId));

        // 강의노트, 음성파일, 실습지도 첨부파일
        Map<String, List<AtflVO>> fileMap = lctrPlandocService.selectPlandocFileMap(lctrPlandocInfo.getLctrPlandocId());
        lpv.setNoteFileList(fileMap.get(LCTR_NOTE_FILE_TYCD));
        lpv.setVoiceFileList(fileMap.get(LCTR_VOICE_FILE_TYCD));
        lpv.setTrainingFileList(fileMap.get(LCTR_TRAINING_FILE_TYCD));

        // 평가방법 - 현재 절대평가만 사용
        if(StringUtil.isNull(subjectVO.getMrkEvlGbncd())) {
            subjectVO.setMrkEvlGbncd("ABSOLUTE");
        }
        lpv.setMrkEvlInfo(cmmnCdService.viewCode(userCtx.getOrgId(), "EVL_GBNCD", subjectVO.getMrkEvlGbncd()));

        // 평가비율
        MarkItemSettingVO mrkItmStngVO = new MarkItemSettingVO();
        mrkItmStngVO.setSbjctId(sbjctId);
        mrkItmStngVO.setOrgId(userCtx.getOrgId());
        lpv.setMrkItmStngList(markItemSettingService.mrkItmStngList(mrkItmStngVO));

        // 주차별 강의내용
        lpv.setLectureScheduleList(lectureScheduleService.profLectureScheduleList(sbjctDto));
        return lpv;
    }

    /**
     * 강의계획서 수정 화면
     *
     * @param userCtx
     * @param lctrPlandocVO
     * @return
     * @throws Exception
     */
    @Override
    public LctrPlandocView loadLctrPlandocModifyView(LctrPlandocVO lctrPlandocVO, @CurrentUser UserContext userCtx) throws Exception {
        LctrPlandocView lpv = new LctrPlandocView();
        String sbjctId = lctrPlandocVO.getSbjctId();

        SubjectDTO sbjctDto = new SubjectDTO(userCtx, sbjctId);

        // 과목정보, 장애인/고령자 지원
        SubjectVO subjectVO = subjectService.subjectSelect(sbjctDto);
        lpv.setSubjectInfo(subjectVO);

        // 교수/튜터/조교 정보
        List<EgovMap> sbjctAdmList = subjectService.sbjctAdmList(sbjctDto);
        List<EgovMap> profList = new ArrayList<>();
        List<EgovMap> coprofList = new ArrayList<>();
        List<EgovMap> tutList = new ArrayList<>();
        List<EgovMap> assiList = new ArrayList<>();

        for(EgovMap m : sbjctAdmList) {
            String sbjctAdmTycd = String.valueOf(m.get("sbjctAdmTycd"));

            if(CommConst.SBJCT_ADM_TYCD_PROF.equals(sbjctAdmTycd)) {
                profList.add(m);
            } else if(CommConst.SBJCT_ADM_TYCD_COPROF.equals(sbjctAdmTycd)) {
                coprofList.add(m);
            } else if(CommConst.SBJCT_ADM_TYCD_TUT.equals(sbjctAdmTycd)) {
                tutList.add(m);
            } else if(CommConst.SBJCT_ADM_TYCD_ASSI.equals(sbjctAdmTycd)) {
                assiList.add(m);
            }
        }

        if(!profList.isEmpty()) {
            lpv.setProfInfo(profList.get(0));
        }

        lpv.setCoprofList(coprofList);
        lpv.setTutList(tutList);
        lpv.setAssiList(assiList);

        // 강의계획서 정보
        LctrPlandocVO lctrPlandocInfo = lctrPlandocService.lctrPlandocSelect(sbjctId);
        if(lctrPlandocInfo == null) {
            lctrPlandocInfo = new LctrPlandocVO(sbjctId);
        }
        lpv.setLctrPlandocInfo(lctrPlandocInfo);


        // 교재
        lpv.setTxtbkList(lctrPlandocService.txtbkList(sbjctId));

        // 강의노트, 음성파일, 실습지도 첨부파일
        Map<String, List<AtflVO>> fileMap = lctrPlandocService.selectPlandocFileMap(lctrPlandocInfo.getLctrPlandocId());
        lpv.setNoteFileList(fileMap.get(LCTR_NOTE_FILE_TYCD));
        lpv.setVoiceFileList(fileMap.get(LCTR_VOICE_FILE_TYCD));
        lpv.setTrainingFileList(fileMap.get(LCTR_TRAINING_FILE_TYCD));


        // 평가방법 - 현재 절대평가만 사용
        if(StringUtil.isNull(subjectVO.getMrkEvlGbncd())) {
            subjectVO.setMrkEvlGbncd("ABSOLUTE");
        }
        lpv.setMrkEvlInfo(cmmnCdService.viewCode(userCtx.getOrgId(), "EVL_GBNCD", subjectVO.getMrkEvlGbncd()));

        // 평가비율
        MarkItemSettingVO mrkItmStngVO = new MarkItemSettingVO();
        mrkItmStngVO.setSbjctId(sbjctId);
        mrkItmStngVO.setOrgId(userCtx.getOrgId());
        lpv.setMrkItmStngList(markItemSettingService.mrkItmStngList(mrkItmStngVO));

        // 주차별 강의내용
        lpv.setLectureScheduleList(lectureScheduleService.profLectureScheduleList(sbjctDto));

        // 공통코드 목록
        Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
        // 교재구분코드 목록 조회
        List<CmmnCdVO> txtbkGbncdList = cmmnCdService.listCode(userCtx.getOrgId(), "TXTBK_GBNCD").getReturnList();
        txtbkGbncdList.removeIf(item -> item.getCd().equals(item.getUpCd()));
        cmmnCdList.put("txtbkGbncdList", txtbkGbncdList);
        // 강의유형코드 목록 조회
        List<CmmnCdVO> lctrTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "LCTR_TYCD").getReturnList();
        lctrTycdList.removeIf(item -> item.getCd().equals(item.getUpCd()));
        cmmnCdList.put("lctrTycdList", lctrTycdList);

        lpv.setCmmnCdList(cmmnCdList);

        return lpv;
    }

    /**
     * 관리자 강의계획서 등록/수정 화면에 필요한 기본 강의계획서 정보, 첨부파일,
     * 시험정보, 출제위임대상자, 공통코드를 구성한다.
     */
    @Override
    public LctrPlandocView loadAdmLctrPlandocWriteView(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception {
        LctrPlandocView lpv = loadLctrPlandocModifyView(lctrPlandocVO, userCtx);
        if("regist".equals(lctrPlandocVO.getGubun())) {
            lpv.setLectureScheduleList(lctrPlandocService.admSbjctSchdlListForPlandocRegist(lctrPlandocVO.getSbjctId()));
        }

        return setAdmRltmExamInfo(lpv, userCtx);
    }

    @Override
    public LctrPlandocView loadAdmLctrPlandocView(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception {
        LctrPlandocView lpv = loadLctrPlandocView(lctrPlandocVO, userCtx);

        return setAdmRltmExamInfo(lpv, userCtx);
    }

    /**
     * 관리자 강의계획서 화면에서 사용하는 시험정보, 출제위임대상자, 시험 공통코드를 구성한다.
     */
    protected LctrPlandocView setAdmRltmExamInfo(LctrPlandocView lpv, UserContext userCtx) throws Exception {
        LctrPlandocVO lctrPlandocInfo = lpv.getLctrPlandocInfo();
        lpv.setRltmExamList(lctrPlandocService.rltmExamFormList(lctrPlandocInfo.getLctrPlandocId()));

        List<EgovMap> examQstnsTrgtrList = new ArrayList<>();
        if(lpv.getProfInfo() != null) {
            examQstnsTrgtrList.add(lpv.getProfInfo());
        }
        if(lpv.getCoprofList() != null) {
            examQstnsTrgtrList.addAll(lpv.getCoprofList());
        }
        lpv.setExamQstnsTrgtrList(examQstnsTrgtrList);

        Map<String, List<CmmnCdVO>> cmmnCdList = lpv.getCmmnCdList();
        if(cmmnCdList == null) {
            cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
        }

        List<CmmnCdVO> examTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "EXAM_TYCD").getReturnList();
        examTycdList.removeIf(item -> item.getCd().equals(item.getUpCd()));
        cmmnCdList.put("examTycdList", examTycdList);

        List<CmmnCdVO> rltmTkexamGbncdList = cmmnCdService.listCode(userCtx.getOrgId(), "RLTM_TKEXAM_GBNCD").getReturnList();
        rltmTkexamGbncdList.removeIf(item -> item.getCd().equals(item.getUpCd()));
        cmmnCdList.put("rltmTkexamGbncdList", rltmTkexamGbncdList);

        List<CmmnCdVO> openOptnGbncdList = cmmnCdService.listCode(userCtx.getOrgId(), "OPEN_OPTN_GBNCD").getReturnList();
        openOptnGbncdList.removeIf(item -> item.getCd().equals(item.getUpCd()));
        cmmnCdList.put("openOptnGbncdList", openOptnGbncdList);
        lpv.setCmmnCdList(cmmnCdList);

        return lpv;
    }

    /**
     * 검색 옵션 필터링
     *
     * @param userCtx
     * @return
     */
    @Override
    public EgovMap loadFilterOptions(UserContext userCtx) {
        EgovMap filterOptions = new EgovMap();

        String orgId = userCtx.getOrgId();
        filterOptions.put("orgId", orgId);

        // 연도 목록
        filterOptions.put("yearList", DateTimeUtil.getYearList(10, "mix"));

        // 현재 연도 : yyyy
        String curYear = DateTimeUtil.getYear();
        filterOptions.put("curYear", curYear);

        // 조회기준연도에 개설된 학기기수 조회
        SmstrChrtVO curSmstrChrtVO = new SmstrChrtVO();
        curSmstrChrtVO.setOrgId(orgId);
        curSmstrChrtVO.setDgrsYr(curYear);
        filterOptions.put("smstrChrtList", semesterService.listSmstrChrtByDgrsYr(curSmstrChrtVO));

        // 기관 목록 조회(수강/운영 중인 과목)
        LctrPlandocVO planParamVO = new LctrPlandocVO();
        planParamVO.setUserId(userCtx.getUserId());
        planParamVO.setSbjctYr(curYear);
        filterOptions.put("orgList", lctrPlandocService.orgList(planParamVO, userCtx));
        filterOptions.put("sbjctList", lctrPlandocService.sbjctList(planParamVO, userCtx));

        return filterOptions;
    }

    @Override
    public EgovMap loadAdmFilterOptions(UserContext userCtx) {
        EgovMap filterOptions = new EgovMap();

        String orgId = userCtx.getOrgId();
        filterOptions.put("orgId", orgId);
        filterOptions.put("yearList", DateTimeUtil.getYearList(10, "mix"));

        String curYear = DateTimeUtil.getYear();
        filterOptions.put("curYear", curYear);

        SmstrChrtVO curSmstrChrtVO = new SmstrChrtVO();
        curSmstrChrtVO.setOrgId(orgId);
        curSmstrChrtVO.setDgrsYr(curYear);
        filterOptions.put("smstrChrtList", semesterService.listSmstrChrtByDgrsYr(curSmstrChrtVO));

        LctrPlandocVO planParamVO = new LctrPlandocVO();
        planParamVO.setSbjctYr(curYear);
        filterOptions.put("orgList", lctrPlandocService.orgList(planParamVO, userCtx));
        filterOptions.put("sbjctList", lctrPlandocService.sbjctList(planParamVO, userCtx));

        return filterOptions;
    }


}
