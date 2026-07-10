package knou.lms.lecture2.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.lecture2.dao.LctrPlandocDAO;
import knou.lms.lecture2.dao.LectureScheduleDAO;
import knou.lms.lecture2.service.LctrPlandocService;
import knou.lms.lecture2.vo.LctrPlandocVO;
import knou.lms.lecture2.vo.LectureScheduleVO;
import knou.lms.lecture2.vo.RltmExamVO;
import knou.lms.lecture2.vo.TxtbkVO;
import knou.lms.mrk.dao.MarkItemSettingDAO;
import knou.lms.mrk.vo.MarkItemSettingVO;
import org.apache.commons.lang.StringUtils;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@Service("lctrPlandocService")
public class LctrPlandocServiceImpl implements LctrPlandocService {

    @Resource(name="lctrPlandocDAO")
    private LctrPlandocDAO lctrPlandocDAO;
    @Resource(name="markItemSettingDAO")
    private MarkItemSettingDAO markItemSettingDAO;
    @Resource(name="lectureScheduleDAO")
    private LectureScheduleDAO lectureScheduleDAO;
    @Resource(name="attachFileService")
    private AttachFileService attachFileService;

    private static final String LCTR_NOTE_FILE_TYCD = "LCTR_NOTE";
    private static final String LCTR_VOICE_FILE_TYCD = "LCTR_VOICE";
    private static final String LCTR_TRAINING_FILE_TYCD = "LCTR_TRAINING";
    private static final String RLTM_EXAM_MID = "EXAM_MID";
    private static final String RLTM_EXAM_LST = "EXAM_LST";

    @Override
    public List<EgovMap> lctrPlandocList(LctrPlandocVO vo) throws Exception {
        return lctrPlandocDAO.lctrPlandocList(vo);
    }

    @Override
    public ProcessResultVO<EgovMap> lctrPlandocListPaging(LctrPlandocVO vo) throws Exception {
        ProcessResultVO<EgovMap> processResultVO = new ProcessResultVO<>();
        PageInfo pageInfo = new PageInfo(vo);
        List<EgovMap> plandocList = lctrPlandocDAO.lctrPlandocListPaging(vo);

        pageInfo.setTotalRecord(plandocList);
        processResultVO.setReturnList(plandocList);
        processResultVO.setPageInfo(pageInfo);
        return processResultVO;
    }

    @Override
    public LctrPlandocVO lctrPlandocSelect(String sbjctId) throws Exception {
        return lctrPlandocDAO.lctrPlandocSelect(sbjctId);
    }

    @Override
    public LctrPlandocVO lctrPlandocModify(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception {
        lctrPlandocVO.setRgtrId(userCtx.getUserId());
        lctrPlandocVO.setMdfrId(userCtx.getUserId());
        lctrPlandocDAO.lctrPlandocModify(lctrPlandocVO);

        savePlandocDetail(lctrPlandocVO, userCtx);
        return lctrPlandocVO;
    }

    @Override
    public LctrPlandocVO admLctrPlandocRegist(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception {
        return saveAdmLctrPlandoc(lctrPlandocVO, userCtx);
    }

    @Override
    public LctrPlandocVO admLctrPlandocModify(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception {
        return saveAdmLctrPlandoc(lctrPlandocVO, userCtx);
    }

    /**
     * 관리자 강의계획서 삭제.
     * 강의계획서를 참조하는 하위 데이터를 먼저 삭제한 뒤 부모 강의계획서를 삭제한다.
     */
    @Override
    public int admLctrPlandocDelete(LctrPlandocVO lctrPlandocVO) throws Exception {
        LctrPlandocVO saved = lctrPlandocDAO.lctrPlandocSelect(lctrPlandocVO.getSbjctId());
        if(saved == null || StringUtils.isBlank(saved.getLctrPlandocId())) {
            return 0;
        }

        // 부모 TB_LMS_LCTR_PLANDOC 삭제 전에 FK 참조 가능성이 있는 데이터를 먼저 정리한다.
        lctrPlandocDAO.lctrWknoSchdlDeleteByPlandocId(saved.getLctrPlandocId());
        lctrPlandocDAO.rltmExamDeleteByPlandocId(saved.getLctrPlandocId());
        return lctrPlandocDAO.lctrPlandocDelete(saved.getLctrPlandocId());
    }

    @Override
    public List<EgovMap> admSbjctSchdlListForPlandocRegist(String sbjctId) throws Exception {
        return lctrPlandocDAO.admSbjctSchdlListForPlandocRegist(sbjctId);
    }

    /**
     * 관리자 강의계획서는 등록/수정 버튼이 나뉘어 있어도 저장 대상은 동일하다.
     * 기존 강의계획서 존재 여부에 따라 신규 등록 또는 수정 후 관리자 전용 시험정보를 함께 저장한다.
     */
    private LctrPlandocVO saveAdmLctrPlandoc(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception {
        LctrPlandocVO saved = lctrPlandocDAO.lctrPlandocSelect(lctrPlandocVO.getSbjctId());
        lctrPlandocVO.setRgtrId(userCtx.getUserId());
        lctrPlandocVO.setMdfrId(userCtx.getUserId());

        if(saved == null || StringUtils.isBlank(saved.getLctrPlandocId())) {
            lctrPlandocVO.setLctrPlandocId(IdGenUtil.genNewId(IdPrefixType.SBLPD));
            lctrPlandocDAO.lctrPlandocRegist(lctrPlandocVO);
            registLctrWknoSchdlFromSbjctSchdl(lctrPlandocVO, userCtx);
        } else {
            lctrPlandocVO.setLctrPlandocId(saved.getLctrPlandocId());
            lctrPlandocDAO.lctrPlandocModify(lctrPlandocVO);
        }

        savePlandocDetail(lctrPlandocVO, userCtx);
        saveRltmExams(lctrPlandocVO, userCtx);
        return lctrPlandocVO;
    }

    private void registLctrWknoSchdlFromSbjctSchdl(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception {
        List<LectureScheduleVO> wkList = lctrPlandocVO.getWkList();
        if(wkList == null || wkList.isEmpty()) {
            return;
        }

        // 등록 시점에는 TB_LMS_LCTR_WKNO_SCHDL이 없으므로 과목일정 주차를 기준으로 전체 주차를 생성한다.
        for(LectureScheduleVO wkVO : wkList) {
            wkVO.setLctrWknoSchdlId(IdGenUtil.genNewId(IdPrefixType.SBLCS));
            wkVO.setSbjctId(lctrPlandocVO.getSbjctId());
            wkVO.setLctrPlandocId(lctrPlandocVO.getLctrPlandocId());
            wkVO.setRgtrId(userCtx.getUserId());
            wkVO.setMdfrId(userCtx.getUserId());

            lctrPlandocDAO.lctrWknoSchdlRegistFromSbjctSchdl(wkVO);
        }
    }

    /**
     * 교재 목록
     *
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public List<TxtbkVO> txtbkList(String sbjctId) throws Exception {
        return lctrPlandocDAO.txtbkList(sbjctId);
    }

    /**
     * 교수/관리자 강의계획서에서 공통으로 수정 가능한 상세 항목을 저장한다.
     * - 교재, 평가비율, 주차별 강의내용, 첨부파일을 처리
     */
    private void savePlandocDetail(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception {
        String sbjctId = lctrPlandocVO.getSbjctId();

        if(lctrPlandocVO.getTxtbkList() != null) {
            lctrPlandocDAO.allTxtbkDelete(sbjctId);
            for(TxtbkVO txtbkVO : lctrPlandocVO.getTxtbkList()) {
                // 교재명 없으면 skip
                if(StringUtils.isBlank(txtbkVO.getTxtbknm())) continue;

                txtbkVO.setSbjctId(sbjctId);
                txtbkVO.setTxtbkId(IdGenUtil.genNewId(IdPrefixType.TBK));

                lctrPlandocDAO.txtbkRegist(txtbkVO);
            }
        }

        /**
         * 성적 항목 정보 저장
         */
        List<MarkItemSettingVO> mrkList = lctrPlandocVO.getMrkItmStngList();
        if(mrkList == null) mrkList = Collections.emptyList();


        // 출석(진도/연습문제)의 성적공개여부가 한개로 관리 됨. 저장 시는 각각 등록.
        String atndcMrkOyn = null; // 출석그룹 공개여부
        for(MarkItemSettingVO mrkItmStngVO : mrkList) {
            if("PRG".equals(mrkItmStngVO.getMrkItmTycd()) || "EXRCS_QSTN".equals(mrkItmStngVO.getMrkItmTycd())) {
                atndcMrkOyn = mrkItmStngVO.getMrkOyn();
                break;
            }
        }
        if(StringUtils.isNotBlank(atndcMrkOyn)) {
            for(MarkItemSettingVO mrkItmStngVO : mrkList) {
                if("PRG".equals(mrkItmStngVO.getMrkItmTycd()) || "EXRCS_QSTN".equals(mrkItmStngVO.getMrkItmTycd())) {
                    mrkItmStngVO.setMrkOyn(atndcMrkOyn);
                }
            }
        }

        // 관리자-평가비중관리에서 사용하는 항목만 대상
        List<MarkItemSettingVO> active = mrkList.stream()
                .filter(it -> "Y".equals(it.getMrkItmUseyn()))
                .collect(Collectors.toList());


        // 관리자-평가비중관리 미등록 시 합계체크 X, 저장 X
        if(!active.isEmpty()) {
            BigDecimal sum = active.stream()
                    .filter(it -> it.getMrkRfltrt() != null)
                    .map(MarkItemSettingVO::getMrkRfltrt)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            if(sum.compareTo(new BigDecimal("100")) != 0) {
                throw new RuntimeException("평가비율 합계는 100이어야 합니다.");
            }

            for(MarkItemSettingVO mrkItmStngVO : active) {
                mrkItmStngVO.setSbjctId(sbjctId);
                mrkItmStngVO.setMdfrId(userCtx.getUserId());

                markItemSettingDAO.mrkItmStngForProfModify(mrkItmStngVO);
            }
        }

        /**
         * 주차 정보 저장
         */
        // 주차 정보 변경된 것만 저장
        if(lctrPlandocVO.getWkList() != null) {
            for(LectureScheduleVO wkVO : lctrPlandocVO.getWkList()) {

                if(!"Y".equals(wkVO.getWkChgyn())) continue;
                if(StringUtils.isBlank(wkVO.getLctrWknoSchdlId())) continue;

                wkVO.setMdfrId(userCtx.getUserId());
                lectureScheduleDAO.wknoSchdlForPlandocModify(wkVO);
            }
        }

        /*
         * 첨부파일 저장(강의노트, 음성파일, 실습지도 첨부파일)
         */
        savePlandocFiles(lctrPlandocVO);
    }

    /**
     * 관리자 강의계획서의 시험정보를 등록 또는 수정한다.
     */
    private void saveRltmExams(LctrPlandocVO lctrPlandocVO, UserContext userCtx) {
        List<RltmExamVO> examList = lctrPlandocVO.getRltmExamList();
        if(examList == null || examList.isEmpty()) {
            return;
        }

        for(RltmExamVO examVO : examList) {
            if(examVO == null || StringUtils.isBlank(examVO.getRltmExamGbncd())) continue;

            if(!"Y".equals(examVO.getExamQstnsDlgtnyn())) {
                examVO.setQstnsTrgtr(null);
            }
            if(!"Y".equals(examVO.getEndExampprOyn())) {
                examVO.setOpenOptnGbncd(null);
            }

            examVO.setLctrPlandocId(lctrPlandocVO.getLctrPlandocId());
            examVO.setRgtrId(userCtx.getUserId());
            examVO.setMdfrId(userCtx.getUserId());

            RltmExamVO saved = lctrPlandocDAO.rltmExamSelect(examVO);
            if(saved == null || StringUtils.isBlank(saved.getRltmExamId())) {
                examVO.setRltmExamId(IdGenUtil.genNewId(IdPrefixType.SBRTE));
                lctrPlandocDAO.rltmExamRegist(examVO);
            } else {
                examVO.setRltmExamId(saved.getRltmExamId());
                lctrPlandocDAO.rltmExamModify(examVO);
            }
        }
    }

    /**
     * 강의계획서 파일을 조회하여 Map 담는다
     *
     * @param lctrPlandocId
     * @return
     */
    @Override
    public Map<String, List<AtflVO>> selectPlandocFileMap(String lctrPlandocId) {
        Map<String, List<AtflVO>> fileMap = new HashMap<>();

        fileMap.put(LCTR_NOTE_FILE_TYCD, new ArrayList<>());
        fileMap.put(LCTR_VOICE_FILE_TYCD, new ArrayList<>());
        fileMap.put(LCTR_TRAINING_FILE_TYCD, new ArrayList<>());

        if(StringUtil.isNull(lctrPlandocId)) {
            return fileMap;
        }

        AtflVO atflVO = new AtflVO();
        atflVO.setRefId(lctrPlandocId);

        List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);

        if(fileList == null) {
            return fileMap;
        }

        for(AtflVO fileVO : fileList) {
            String fileTycd = fileVO.getEtcInfo1();

            if(fileMap.containsKey(fileTycd)) {
                fileMap.get(fileTycd).add(fileVO);
            }
        }

        return fileMap;
    }

    /**
     * 관리자 강의계획서 페이징
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> admLctrPlandocListPaging(LctrPlandocVO vo) throws Exception {
        ProcessResultVO<EgovMap> processResultVO = new ProcessResultVO<>();
        PageInfo pageInfo = new PageInfo(vo);
        List<EgovMap> plandocList = lctrPlandocDAO.admLctrPlandocListPaging(vo);

        pageInfo.setTotalRecord(plandocList);
        processResultVO.setReturnList(plandocList);
        processResultVO.setPageInfo(pageInfo);
        return processResultVO;
    }

    /**
     * 시험정보 목록
     *
     * @param lctrPlandocId
     * @return
     */
    @Override
    public List<RltmExamVO> rltmExamList(String lctrPlandocId) {
        if(StringUtils.isBlank(lctrPlandocId)) {
            return Collections.emptyList();
        }
        return lctrPlandocDAO.rltmExamList(lctrPlandocId);
    }

    /**
     * 관리자 강의계획서 등록/수정 화면에 표시할 중간/기말 시험정보 목록을 구성한다.
     *
     * @param lctrPlandocId
     * @return
     */
    @Override
    public List<RltmExamVO> rltmExamFormList(String lctrPlandocId) {
        List<RltmExamVO> savedList = rltmExamList(lctrPlandocId);
        Map<String, RltmExamVO> savedMap = new HashMap<>();
        for(RltmExamVO examVO : savedList) {
            savedMap.put(examVO.getRltmExamGbncd(), examVO);
        }

        List<RltmExamVO> result = new ArrayList<>();
        for(String rltmExamGbncd : Arrays.asList(RLTM_EXAM_MID, RLTM_EXAM_LST)) {
            RltmExamVO examVO = savedMap.get(rltmExamGbncd);
            if(examVO == null) {
                examVO = new RltmExamVO();
                examVO.setRltmExamGbncd(rltmExamGbncd);
            }
            result.add(examVO);
        }
        return result;
    }

    /**
     * 학습자 강의계획서 목록 조회
     *
     * @param vo
     * @return
     */
    @Override
    public List<EgovMap> stdntLctrPlandocList(LctrPlandocVO vo) {
        return lctrPlandocDAO.stdntLctrPlandocList(vo);
    }

    /**
     * 학생 강의계획서 목록 페이징 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> stdntLctrPlandocListPaging(LctrPlandocVO vo) throws Exception {
        ProcessResultVO<EgovMap> processResultVO = new ProcessResultVO<>();
        PageInfo pageInfo = new PageInfo(vo);
        List<EgovMap> plandocList = lctrPlandocDAO.stdntLctrPlandocListPaging(vo);

        pageInfo.setTotalRecord(plandocList);
        processResultVO.setReturnList(plandocList);
        processResultVO.setPageInfo(pageInfo);
        return processResultVO;
    }

    /**
     * 기관 목록 조회
     *
     * @param planParamVO
     * @param userCtx
     * @return
     */
    @Override
    public List<EgovMap> orgList(LctrPlandocVO planParamVO, UserContext userCtx) {
        if(userCtx.isAdmin()) {
            return lctrPlandocDAO.admOrgList(planParamVO);
        }
        if(userCtx.isStudent()) {
            return lctrPlandocDAO.stdntOrgList(planParamVO);
        }
        return lctrPlandocDAO.profOrgList(planParamVO);
    }

    /**
     * 과목 목록 조회
     *
     * @param planParamVO
     * @param userCtx
     * @return
     */
    @Override
    public List<EgovMap> sbjctList(LctrPlandocVO planParamVO, UserContext userCtx) {
        if(userCtx.isAdmin()) {
            return lctrPlandocDAO.admSbjctList(planParamVO);
        }
        if(userCtx.isStudent()) {
            return lctrPlandocDAO.stdntSbjctList(planParamVO);
        }
        return lctrPlandocDAO.profSbjctList(planParamVO);
    }

    /**
     * 강의게획서 파일 저장
     * 강의노트, 음성파일, 실습지도
     *
     * @param vo
     * @throws Exception
     */
    private void savePlandocFiles(LctrPlandocVO vo) throws Exception {
        attachFileService.deleteAtflByAtflIds(vo.getNoteDelFileIds());
        attachFileService.deleteAtflByAtflIds(vo.getVoiceDelFileIds());
        attachFileService.deleteAtflByAtflIds(vo.getTrainingDelFileIds());

        // 강의노트
        insertPlandocFileList(vo.getNoteUploadFiles(), vo.getUploadPath(), LCTR_NOTE_FILE_TYCD, vo);
        // 음성파일
        insertPlandocFileList(vo.getVoiceUploadFiles(), vo.getUploadPath(), LCTR_VOICE_FILE_TYCD, vo);
        // 실습지도
        insertPlandocFileList(vo.getTrainingUploadFiles(), vo.getUploadPath(), LCTR_TRAINING_FILE_TYCD, vo);
    }

    private void insertPlandocFileList(String uploadFiles, String uploadPath, String fileTycd, LctrPlandocVO vo) throws Exception {
        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(uploadFiles, uploadPath);
        if(uploadFileList == null || uploadFileList.isEmpty()) {
            return;
        }

        for(AtflVO atflVO : uploadFileList) {
            atflVO.setRefId(vo.getLctrPlandocId());
            atflVO.setEtcInfo1(fileTycd);
            atflVO.setRgtrId(vo.getRgtrId());
            atflVO.setMdfrId(vo.getMdfrId());
            atflVO.setAtflRepoId(CommConst.REPO_PLANDOC);
        }

        attachFileService.insertAtflList(uploadFileList);
    }
}
