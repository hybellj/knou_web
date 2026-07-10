package knou.lms.crs.sbjct.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.common.CommConst;
import knou.framework.context2.UserContext;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.IdGenerator;
import knou.lms.common.dto.ResultDTO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.crs.sbjct.dao.SbjctDAO;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.crs.sbjct.service.SbjctTmpltService;
import knou.lms.crs.sbjct.vo.SbjctAdmVO;
import knou.lms.crs.sbjct.vo.SbjctAtndlcVO;
import knou.lms.crs.sbjct.vo.SbjctListVO;
import knou.lms.crs.sbjct.vo.SbjctSchdlVO;
import knou.lms.crs.sbjct.vo.SbjctTmpltVO;
import knou.lms.crs.sbjct.vo.SbjctVO;
import knou.lms.crs.sbjct.web.paging.SbjctOfringPageInfo;
import knou.lms.crs.sbjct.web.validation.SbjctOpenLctrOfringSaveValidator;
import knou.lms.crs.sbjct.web.validation.SbjctOfringSaveValidator;
import knou.lms.crs.sbjct.web.validation.SbjctOfringSchdlSaveValidator;
import knou.lms.file.vo.AtflVO;
import knou.lms.schedule.service.CalendarService;
import knou.lms.schedule.vo.OrgTaskScheduleVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;

@Service("sbjctService")
public class SbjctServiceImpl extends ServiceBase implements SbjctService {

    // 공개강좌개설은 과목개설 테이블을 사용하되 과목유형을 공개강좌 시스템으로 고정한다.
    private static final String OPEN_LCTR_SYSTEM_SBJCT_TYCD = "OPEN_LCTR_SYSTEM";
    private static final String OPEN_CRS_GBNCD = "OPEN_CRS";
    private static final String CHRT_SMSTR_CHRT_GBNCD = "CHRT";
    private static final String CHRT_SYSTEM_SBJCT_TYCD = "CHRT_SYSTEM";
    private static final String SMSTR_SYSTEM_SBJCT_TYCD = "SMSTR_SYSTEM";
    private static final String LCTR_PLANDOC_ENRL_PRD = "LCTR_PLANDOC_ENRL_PRD";

    @Resource(name = "sbjctDAO")
    private SbjctDAO sbjctDAO;

    @Resource(name = "semesterService")
    private SemesterService semesterService;

    @Resource(name = "calendarService")
    private CalendarService calendarService;

    @Resource(name = "sbjctTmpltService")
    private SbjctTmpltService sbjctTmpltService;

    @Resource(name = "messageSource")
    private MessageSource messageSource;

    @Resource(name = "sbjctOfringSaveValidator")
    private SbjctOfringSaveValidator sbjctOfringSaveValidator;

    @Resource(name = "sbjctOpenLctrOfringSaveValidator")
    private SbjctOpenLctrOfringSaveValidator sbjctOpenLctrOfringSaveValidator;

    @Resource(name = "sbjctOfringSchdlSaveValidator")
    private SbjctOfringSchdlSaveValidator sbjctOfringSchdlSaveValidator;

    /**
     * 과목을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public List<SbjctVO> list(SbjctVO vo) {
        return sbjctDAO.list(vo);
    }

    /**
     * 과목개설목록조회(페이징)을 수행한다.
     * @param pageInfo
     * @return
     */
    @Override
    public ResultDTO<SbjctListVO> selectSbjctOfringList(SbjctOfringPageInfo pageInfo) {
        List<SbjctListVO> sbjctOfringList = sbjctDAO.selectSbjctOfringList(pageInfo);
        ResultDTO<SbjctListVO> resultDTO = new ResultDTO<>(pageInfo);
        resultDTO.setReturnList(sbjctOfringList);
        resultDTO.getPageInfo().setTotalRecordCount(getSbjctListTotalCount(sbjctOfringList));
        resultDTO.setResultSuccess();

        return resultDTO;
    }

    /**
     * 과목개설목록 엑셀 다운로드 목록을 조회한다.
     * @param pageInfo
     * @return
     */
    @Override
    public List<SbjctListVO> selectSbjctOfringListExcelDown(SbjctOfringPageInfo pageInfo) {
        return sbjctDAO.selectSbjctOfringListExcelDown(pageInfo);
    }

    /**
     * 공개강좌개설 목록을 공개강좌 과목유형만 대상으로 조회한다.
     * @param pageInfo
     * @return
     */
    @Override
    public ResultDTO<SbjctListVO> selectOpenLctrOfringList(SbjctOfringPageInfo pageInfo) {
        List<SbjctListVO> list = sbjctDAO.selectOpenLctrOfringList(pageInfo);
        ResultDTO<SbjctListVO> resultDTO = new ResultDTO<>(pageInfo);
        resultDTO.setReturnList(list);
        resultDTO.getPageInfo().setTotalRecordCount(getSbjctListTotalCount(list));
        resultDTO.setResultSuccess();

        return resultDTO;
    }

    /**
     * 공개강좌개설 목록 엑셀 다운로드 데이터를 조회한다.
     * @param pageInfo
     * @return
     */
    @Override
    public List<SbjctListVO> selectOpenLctrOfringListExcelDown(SbjctOfringPageInfo pageInfo) {
        return sbjctDAO.selectOpenLctrOfringListExcelDown(pageInfo);
    }

    /**
     * 과목개설 상세 정보를 조회한다.
     * @param vo
     * @return
     */
    @Override
    public SbjctVO selectSbjctOfring(SbjctVO vo) {
        return sbjctDAO.selectSbjctOfring(vo);
    }

    /**
     * 과목개설 접근 권한 체크용 정보를 조회한다.
     * @param vo
     * @return
     */
    @Override
    public SbjctVO selectSbjctOfringAccess(SbjctVO vo) {
        return sbjctDAO.selectSbjctOfringAccess(vo);
    }

    /**
     * 과목개설 주차 기간 설정 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public List<SbjctSchdlVO> selectSbjctOfringSchdlList(SbjctVO vo) {
        return sbjctDAO.selectSbjctOfringSchdlList(vo);
    }

    /**
     * 과목개설을 등록한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<SbjctVO> insertSbjctOfring(SbjctVO vo) {
        ResultDTO<SbjctVO> resultDTO = new ResultDTO<>();

        if (vo == null) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        }
        normalizeForSave(vo);
        String validationMessage = validateSbjctOfring(vo, true);
        if (validationMessage != null) {
            return resultDTO.setResultFailed(validationMessage);
        }

        vo.setSbjctId(IdGenerator.getNewId(IdPrefixType.SBJCT.getCode()));

        int result = sbjctDAO.insertSbjctOfring(vo);
        resultDTO.setData(vo);
        resultDTO.setSuccessCount(result);
        return resultDTO;
    }

    /**
     * 공개강좌개설 정보를 등록한다.
     * 공개강좌는 과목개설 테이블을 사용하되 과목유형과 기간 정책을 공개강좌 기준으로 고정한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<SbjctVO> insertOpenLctrOfring(SbjctVO vo) {
        ResultDTO<SbjctVO> resultDTO = new ResultDTO<>();

        if (vo == null) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        }
        normalizeOpenLctrForSave(vo);
        String validationMessage = validateOpenLctrOfring(vo, true);
        if (validationMessage != null) {
            return resultDTO.setResultFailed(validationMessage);
        }

        vo.setSbjctId(IdGenerator.getNewId(IdPrefixType.SBJCT.getCode()));

        int result = sbjctDAO.insertSbjctOfring(vo);
        resultDTO.setData(vo);
        resultDTO.setSuccessCount(result);
        return resultDTO;
    }

    /**
     * 과목개설을 수정한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<SbjctVO> updateSbjctOfring(SbjctVO vo) {
        ResultDTO<SbjctVO> resultDTO = new ResultDTO<>();

        if (vo == null) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        }
        normalizeForSave(vo);
        String validationMessage = validateSbjctOfring(vo, false);
        if (validationMessage != null) {
            return resultDTO.setResultFailed(validationMessage);
        }

        int result = sbjctDAO.updateSbjctOfring(vo);
        resultDTO.setData(vo);
        resultDTO.setSuccessCount(result);
        return resultDTO;
    }

    /**
     * 공개강좌개설 정보를 수정한다.
     * 과목개설 공통 저장 로직을 재사용하기 전에 공개강좌에서 쓰지 않는 항목은 저장 대상에서 제외한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<SbjctVO> updateOpenLctrOfring(SbjctVO vo) {
        ResultDTO<SbjctVO> resultDTO = new ResultDTO<>();

        if (vo == null) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        }
        normalizeOpenLctrForSave(vo);
        String validationMessage = validateOpenLctrOfring(vo, false);
        if (validationMessage != null) {
            return resultDTO.setResultFailed(validationMessage);
        }

        int result = sbjctDAO.updateSbjctOfring(vo);
        resultDTO.setData(vo);
        resultDTO.setSuccessCount(result);
        return resultDTO;
    }

    /**
     * 과목개설을 삭제한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<Integer> deleteSbjctOfring(SbjctVO vo) {
        ResultDTO<Integer> resultDTO = new ResultDTO<>();

        if (vo == null || isBlank(vo.getSbjctId())) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        }

        int result = sbjctDAO.deleteSbjctOfring(vo);
        resultDTO.setSuccessCount(result);
        return resultDTO;
    }

    /**
     * 과목개설 목록에서 사용여부만 즉시 수정한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<SbjctVO> updateSbjctOfringUseyn(SbjctVO vo) {
        ResultDTO<SbjctVO> resultDTO = new ResultDTO<>();

        if (vo == null || isBlank(vo.getSbjctId()) || (!"Y".equals(vo.getUseyn()) && !"N".equals(vo.getUseyn()))) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        }

        int result = sbjctDAO.updateSbjctOfringUseyn(vo);
        resultDTO.setData(vo);
        resultDTO.setSuccessCount(result);
        return resultDTO;
    }

    /**
     * 공개강좌개설 목록에서 사용여부만 즉시 수정한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<SbjctVO> updateOpenLctrOfringUseyn(SbjctVO vo) {
        ResultDTO<SbjctVO> resultDTO = new ResultDTO<>();

        if (vo == null || isBlank(vo.getSbjctId()) || (!"Y".equals(vo.getUseyn()) && !"N".equals(vo.getUseyn()))) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        }

        int result = sbjctDAO.updateOpenLctrOfringUseyn(vo);
        resultDTO.setData(vo);
        resultDTO.setSuccessCount(result);
        return resultDTO;
    }

    /**
     * 관리자 과목개설 주차 기간 설정을 저장한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<SbjctSchdlVO> saveSbjctOfringSchdl(SbjctSchdlVO vo) {
        ResultDTO<SbjctSchdlVO> resultDTO = new ResultDTO<>();

        if (vo == null) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        }
        if (!isBeforeLctrPlandocEnrlPrd(vo.getOrgId())) {
            return resultDTO.setResultFailed(getMessage("crs.sbjct.ofring.alert.schdl.edit.before.plandoc"));/*강의계획서등록기간 전까지만 주차 일정을 수정할 수 있습니다.*/
        }

        normalizeSchdlListForSave(vo);
        String validationMessage = validateSbjctOfringSchdl(vo);
        if (validationMessage != null) {
            return resultDTO.setResultFailed(validationMessage);
        }

        for (SbjctSchdlVO schdlVO : vo.getSchdlList()) {
            schdlVO.setSbjctSchdlId(IdGenerator.getNewId(IdPrefixType.SBSCH.getCode()));
        }

        int result = sbjctDAO.deleteSbjctOfringSchdlList(vo);
        result += sbjctDAO.insertSbjctOfringSchdlList(vo);

        resultDTO.setData(vo);
        resultDTO.setSuccessCount(result);
        return resultDTO;
    }

    /**
     * 과목개설 과목관리자 등록용 사용자 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<SbjctAdmVO> admSbjctOfringAdmUserList(SbjctAdmVO vo) {
        ResultDTO<SbjctAdmVO> resultDTO = new ResultDTO<>();

        if (vo == null || isBlank(vo.getSearchValue())) {
            resultDTO.setReturnList(java.util.Collections.emptyList());
            resultDTO.setResultSuccess();
            return resultDTO;
        }

        resultDTO.setReturnList(sbjctDAO.admSbjctOfringAdmUserList(vo));
        resultDTO.setResultSuccess();
        return resultDTO;
    }

    /**
     * 과목개설 과목관리자 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public List<SbjctAdmVO> admSbjctOfringAdmList(SbjctAdmVO vo) {
        return sbjctDAO.admSbjctOfringAdmList(vo);
    }

    /**
     * 관리자 과목개설 과목관리자를 저장한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<SbjctAdmVO> admSbjctOfringAdmRegist(SbjctAdmVO vo) {
        ResultDTO<SbjctAdmVO> resultDTO = new ResultDTO<>();

        if (vo == null || isBlank(vo.getSbjctId())) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        }

        String profId = normalizeAndFindProfId(vo);
        if (profId == null || vo.getAdmList().isEmpty()) {
            return resultDTO.setResultFailed(getMessage("crs.sbjct.ofring.alert.select.prof.adm"));/*담당교수를 1명 이상 등록해 주세요.*/
        }

        int result = sbjctDAO.deleteSbjctOfringAdmList(vo);
        result += sbjctDAO.insertSbjctOfringAdmList(vo);

        SbjctAdmVO profVO = new SbjctAdmVO();
        profVO.setSbjctId(vo.getSbjctId());
        profVO.setUserId(profId);
        profVO.setMdfrId(vo.getMdfrId());
        result += sbjctDAO.updateSbjctOfringProfId(profVO);

        resultDTO.setData(vo);
        resultDTO.setSuccessCount(result);
        return resultDTO;
    }

    /**
     * 과목개설 수강생 등록용 사용자 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<SbjctAtndlcVO> admSbjctOfringStdntUserList(SbjctAtndlcVO vo) {
        ResultDTO<SbjctAtndlcVO> resultDTO = new ResultDTO<>();

        if (vo == null || isBlank(vo.getSbjctId()) || isBlank(vo.getSearchValue())) {
            resultDTO.setReturnList(java.util.Collections.emptyList());
            resultDTO.setResultSuccess();
            return resultDTO;
        }

        resultDTO.setReturnList(sbjctDAO.admSbjctOfringStdntUserList(vo));
        resultDTO.setResultSuccess();
        return resultDTO;
    }

    /**
     * 과목개설 수강생 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public List<SbjctAtndlcVO> admSbjctOfringStdntList(SbjctAtndlcVO vo) {
        return sbjctDAO.admSbjctOfringStdntList(vo);
    }

    /**
     * 과목개설 수강생 엑셀 업로드 학생 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public List<SbjctAtndlcVO> admSbjctOfringStdntExcelList(SbjctAtndlcVO vo) {
        if (vo == null || vo.getAtndlcList() == null || vo.getAtndlcList().isEmpty()) {
            return java.util.Collections.emptyList();
        }
        return sbjctDAO.admSbjctOfringStdntExcelList(vo);
    }

    /**
     * 과목개설 수강생 엑셀 업로드 파일을 읽어 수강생 목록 조회 결과를 반환한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<SbjctAtndlcVO> admSbjctOfringStdntExcelUpload(SbjctAtndlcVO vo) {
        ResultDTO<SbjctAtndlcVO> resultDTO = new ResultDTO<>();
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        try {
            List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(uploadFiles, uploadPath);
            if(uploadFileList == null || uploadFileList.isEmpty()) {
                return resultDTO.setResultFailed(getMessage("crs.sbjct.alert.excel.file.empty"));/*업로드할 엑셀 파일을 선택해 주세요.*/
            }

            HashMap<String, Object> excelMap = new HashMap<>();
            excelMap.put("startRaw", 5);
            excelMap.put("excelGrid", vo.getExcelGrid());
            excelMap.put("atflVO", uploadFileList.get(0));
            excelMap.put("searchKey", "excelUpload");

            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            List<?> excelList = excelUtilPoi.simpleReadGrid(excelMap);

            List<SbjctAtndlcVO> requestList = toStdntExcelRequestList(excelList);
            if(requestList.isEmpty()) {
                return resultDTO.setResultFailed(getMessage("crs.sbjct.ofring.alert.excel.stdnt.empty"));/*추가할 수강생 데이터가 없습니다.*/
            }

            vo.setAtndlcList(requestList);
            List<SbjctAtndlcVO> stdntList = admSbjctOfringStdntExcelList(vo);

            String validationMessage = validateStdntExcelRows(requestList, stdntList);
            if(validationMessage != null) {
                return resultDTO.setResultFailed(validationMessage);
            }

            resultDTO.setReturnList(orderStdntExcelResult(requestList, stdntList));
            return resultDTO.setResultSuccess();
        } catch (Exception e) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        } finally {
            deleteUploadFiles(uploadFiles, uploadPath);
        }
    }

    /**
     * 관리자 과목개설 수강생을 저장한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<SbjctAtndlcVO> admSbjctOfringStdntRegist(SbjctAtndlcVO vo) {
        ResultDTO<SbjctAtndlcVO> resultDTO = new ResultDTO<>();

        if (vo == null || isBlank(vo.getSbjctId())) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        }
        if (vo.getAtndlcList() == null || vo.getAtndlcList().isEmpty()) {
            return resultDTO.setResultFailed(getMessage("crs.sbjct.ofring.alert.select.stdnt"));/*수강생을 1명 이상 등록해 주세요.*/
        }

        normalizeAtndlcList(vo);
        if (vo.getAtndlcList().isEmpty()) {
            return resultDTO.setResultFailed(getMessage("crs.sbjct.ofring.alert.select.stdnt"));/*수강생을 1명 이상 등록해 주세요.*/
        }
        int result = sbjctDAO.deleteSbjctOfringStdntList(vo);
        result += sbjctDAO.insertSbjctOfringStdntList(vo);

        resultDTO.setData(vo);
        resultDTO.setResultSuccess();
        return resultDTO;
    }

    /**
     * 권한그룹별 과목 목록 조회
     * - 관리자    : 전체관리자 -> 전체 / 그 외 -> 본인 기관 소속
     * - 교수     : 본인 계정들이 강의하는 과목 - 대표아이디 기준
     * - 학생     : 본인 계정들이 수강하는 과목 - 대표아이디 기준
     * @param userCtx
     * @return
     */
    @Override
    public List<EgovMap> sbjctListByAuthrt(UserContext userCtx) {
        List<EgovMap> sbjctList;

        PageInfo pageInfo = new PageInfo();
        pageInfo.setUserId(userCtx.getUserId());
//        pageInfo.setRprsId(userCtx.getUserRprsId());
        pageInfo.setOrgId(userCtx.getOrgId());

        if (userCtx.isAdmin()) {
            // 전체관리자인 경우 학과 전체 조회
            if (CommConst.AUTHRT_CD_ADM.equals(userCtx.getAuthrtCd())) {
                pageInfo.setOrgId("");
            }
            sbjctList = sbjctDAO.admSbjctList(pageInfo);
        } else if (userCtx.isProfessor()) {
            sbjctList = sbjctDAO.profSbjctList(pageInfo);
        } else {
            sbjctList = sbjctDAO.stdntSbjctList(pageInfo);
        }

        return sbjctList;
    }

    /**
     * 엑셀 업로드 결과를 학번 기준 조회 요청 목록으로 변환한다.
     * @param excelList
     * @return
     */
    private List<SbjctAtndlcVO> toStdntExcelRequestList(List<?> excelList) {
        LinkedHashMap<String, SbjctAtndlcVO> stdntNoMap = new LinkedHashMap<>();
        if(excelList == null) {
            return new ArrayList<>();
        }

        for(int i = 0; i < excelList.size(); i++) {
            if(!(excelList.get(i) instanceof Map)) {
                continue;
            }

            Map<?, ?> rowMap = (Map<?, ?>) excelList.get(i);

            String stdntNo = trimToNull(rowMap.get("A"));
            if(isBlank(stdntNo) || stdntNoMap.containsKey(stdntNo)) {
                continue;
            }

            SbjctAtndlcVO rowVO = new SbjctAtndlcVO();
            rowVO.setStdntNo(stdntNo);
            rowVO.setLineNo(String.valueOf(i + 5));
            stdntNoMap.put(stdntNo, rowVO);
        }

        return new ArrayList<>(stdntNoMap.values());
    }

    /**
     * 엑셀 업로드 학번이 실제 학생으로 조회되었는지 확인한다.
     * @param requestList
     * @param stdntList
     * @return
     */
    private String validateStdntExcelRows(List<SbjctAtndlcVO> requestList, List<SbjctAtndlcVO> stdntList) {
        Map<String, SbjctAtndlcVO> stdntMap = new HashMap<>();
        if(stdntList != null) {
            for(SbjctAtndlcVO stdntVO : stdntList) {
                if(stdntVO != null && !isBlank(stdntVO.getStdntNo())) {
                    stdntMap.put(stdntVO.getStdntNo(), stdntVO);
                }
            }
        }

        for(SbjctAtndlcVO requestVO : requestList) {
            if(!stdntMap.containsKey(requestVO.getStdntNo())) {
                return getMessage("crs.sbjct.alert.excel.row.error",/*엑셀 {0}행 : {1}*/
                        new Object[] {
                                requestVO.getLineNo(),
                                getMessage("crs.sbjct.ofring.alert.excel.stdnt.not.found",/*학번 {0}에 해당하는 학생을 찾을 수 없습니다.*/
                                        new Object[] { requestVO.getStdntNo() }) });
            }
        }

        return null;
    }

    /**
     * 엑셀 업로드 학생 조회 결과를 업로드 행 순서대로 정렬한다.
     * @param requestList
     * @param stdntList
     * @return
     */
    private List<SbjctAtndlcVO> orderStdntExcelResult(List<SbjctAtndlcVO> requestList, List<SbjctAtndlcVO> stdntList) {
        Map<String, SbjctAtndlcVO> stdntMap = new HashMap<>();
        for(SbjctAtndlcVO stdntVO : stdntList) {
            stdntMap.put(stdntVO.getStdntNo(), stdntVO);
        }

        List<SbjctAtndlcVO> resultList = new ArrayList<>();
        for(SbjctAtndlcVO requestVO : requestList) {
            SbjctAtndlcVO stdntVO = stdntMap.get(requestVO.getStdntNo());
            if(stdntVO != null) {
                resultList.add(stdntVO);
            }
        }
        return resultList;
    }

    /**
     * 업로드 처리 후 임시 파일을 삭제한다.
     * @param uploadFiles
     * @param uploadPath
     */
    private void deleteUploadFiles(String uploadFiles, String uploadPath) {
        if(uploadFiles == null || uploadFiles.trim().isEmpty()
                || uploadPath == null || uploadPath.trim().isEmpty()) {
            return;
        }

        try {
            FileUtil.delUploadFileList(uploadFiles, uploadPath);
        } catch (Exception e) {
            // 임시 파일은 업로드 읽기 과정에서 이미 제거되었을 수 있다.
        }
    }

    /**
     * 과목개설 저장 기본값과 조건부 값을 보정한다.
     * @param vo
     */
    private void normalizeForSave(SbjctVO vo) {
        SmstrChrtVO smstrChrtVO = selectSmstrChrtForSave(vo);
        normalizeSbjctYrSmstr(vo, smstrChrtVO);
        // 과목분류는 전송값을 신뢰하지 않고 선택된 학기기수 구분값으로 확정한다.
        normalizeSbjctTycdBySmstrChrt(vo, smstrChrtVO);
        // 과목참조유형은 학기차수 기준 과목개설로 고정한다.
        if (isBlank(vo.getSbjctRefTycd())) {
            vo.setSbjctRefTycd("SMSTR_CHRT");
        }
        // 사용여부가 전달되지 않으면 사용으로 저장한다.
        if (isBlank(vo.getUseyn())) {
            vo.setUseyn("Y");
        }
        // 삭제여부가 전달되지 않으면 미삭제로 저장한다.
        if (isBlank(vo.getDelyn())) {
            vo.setDelyn("N");
        }
        // 강의평가여부가 전달되지 않으면 사용으로 저장한다.
        if (isBlank(vo.getLctrEvlyn())) {
            vo.setLctrEvlyn("Y");
        }
        // PASS/FAIL 평가가 아니면 PASS/FAIL 점수를 저장하지 않는다.
        if (!"PASSFAIL".equals(vo.getEvlGbncd())) {
            vo.setPassfailScr(null);
        }
        // 복습기간 유형이 기간설정이 아니면 복습 시작/종료일을 저장하지 않는다.
        if (!"PRD_STNG".equals(vo.getRvwPsblGbncd())) {
            vo.setRvwSdttm(null);
            vo.setRvwEdttm(null);
        }
        // 인원제한을 사용하지 않으면 수강정원은 0으로 저장한다.
        if (!"Y".equals(vo.getLimitYn())) {
            vo.setAtndlcQuota(0);
        }
    }

    /**
     * 공개강좌 저장 전에 과목개설 공통값을 공개강좌 정책에 맞게 보정한다.
     * 화면에서 받지 않는 수강신청, 평가, 복습, 성적처리 관련 값은 기존 과목개설 검증 대상에서 제외한다.
     * @param vo
     */
    private void normalizeOpenLctrForSave(SbjctVO vo) {
        normalizeForSave(vo);
        normalizeOpenLctrTmpltFields(vo);
        vo.setSbjctTycd(OPEN_LCTR_SYSTEM_SBJCT_TYCD);
        vo.setCrsGbncd(OPEN_CRS_GBNCD);
        vo.setAtndlcCertStscd(null);
        vo.setLctrEvlyn(null);
        vo.setLimitYn("N");
        vo.setAtndlcQuota(0);
        vo.setRvwPsblGbncd(null);
        vo.setRvwSdttm(null);
        vo.setRvwEdttm(null);
        vo.setAtndlcAplySdttm(null);
        vo.setAtndlcAplyEdttm(null);
        vo.setAuditEdttm(null);
        vo.setMrkProcSdttm(null);
        vo.setMrkProcEdttm(null);
        vo.setSbjctLateRecgDttm(null);
        vo.setEvlGbncd(null);
        vo.setCmcrsGbncd(null);
        vo.setLctrFrmtGbncd(null);
        vo.setLrnCntrlGbncd(null);
        vo.setPassfailScr(null);
        if (vo.getCrdts() == null) {
            vo.setCrdts(0);
        }
        // 공개강좌에서 사용하지 않는 과목개설 항목은 NOT NULL 해제 기준에 맞춰 null로 저장한다.
        vo.setDvclasNo(null);
        vo.setDvclasNcknm(null);
        vo.setLctrPrvwWkno(null);
        // 강의기간 영구 여부는 라디오 값만 신뢰하고, 영구일 때 조작된 기간값은 저장하지 않는다.
        if ("Y".equals(vo.getLctrPermYn())) {
            vo.setSbjctLctrSdttm(null);
            vo.setSbjctLctrEdttm(null);
        } else if ("N".equals(vo.getLctrPermYn())) {
            vo.setSbjctLctrSdttm(normalizeOpenLctrStartDttm(vo.getSbjctLctrSdttm()));
            vo.setSbjctLctrEdttm(normalizeOpenLctrEndDttm(vo.getSbjctLctrEdttm()));
        }
    }

    /**
     * 공개강좌 화면에 노출하지 않는 과목코드는 선택한 과목템플릿 기준으로 서버에서 확정한다.
     * @param vo
     */
    private void normalizeOpenLctrTmpltFields(SbjctVO vo) {
        if (vo == null || isBlank(vo.getSbjctTmpltId())) {
            return;
        }

        SbjctTmpltVO searchVO = new SbjctTmpltVO();
        searchVO.setSbjctTmpltId(vo.getSbjctTmpltId());
        SbjctTmpltVO tmpltVO = sbjctTmpltService.selectSbjctTmplt(searchVO);
        if (tmpltVO == null || (!isBlank(vo.getOrgId()) && !vo.getOrgId().equals(tmpltVO.getOrgId()))) {
            vo.setSbjctCd(null);
            return;
        }

        vo.setSbjctCd(tmpltVO.getSbjctCd());
        if (isBlank(vo.getSbjctnm())) {
            vo.setSbjctnm(tmpltVO.getSbjctnm());
        }
        if (isBlank(vo.getLctrGbncd())) {
            vo.setLctrGbncd(tmpltVO.getLctrGbncd());
        }
    }

    /**
     * 저장 요청의 학기기수 정보를 조회한다.
     * @param vo
     * @return
     */
    private SmstrChrtVO selectSmstrChrtForSave(SbjctVO vo) {
        if (vo == null || isBlank(vo.getOrgId()) || isBlank(vo.getSmstrChrtId())) {
            return null;
        }

        SmstrChrtVO searchVO = new SmstrChrtVO();
        searchVO.setOrgId(vo.getOrgId());
        searchVO.setSmstrChrtId(vo.getSmstrChrtId());

        List<SmstrChrtVO> smstrChrtList = semesterService.listSmstrChrtByDgrsYr(searchVO);
        return smstrChrtList == null || smstrChrtList.isEmpty() ? null : smstrChrtList.get(0);
    }

    /**
     * 선택한 학기기수 기준으로 년도/학기 저장값을 서버에서 확정한다.
     * @param vo
     * @param smstrChrtVO
     */
    private void normalizeSbjctYrSmstr(SbjctVO vo, SmstrChrtVO smstrChrtVO) {
        if (vo == null || smstrChrtVO == null) {
            return;
        }

        vo.setSbjctYr(smstrChrtVO.getDgrsYr());
        vo.setSbjctSmstr(smstrChrtVO.getDgrsSmstrChrt());
    }

    /**
     * 선택된 학기기수 구분값에 맞춰 과목분류를 서버에서 다시 확정한다.
     * @param vo
     * @param smstrChrtVO
     */
    private void normalizeSbjctTycdBySmstrChrt(SbjctVO vo, SmstrChrtVO smstrChrtVO) {
        if (vo == null || smstrChrtVO == null) {
            return;
        }

        String smstrChrtGbncd = smstrChrtVO.getSmstrChrtGbncd();

        vo.setSbjctTycd(CHRT_SMSTR_CHRT_GBNCD.equals(smstrChrtGbncd)
                ? CHRT_SYSTEM_SBJCT_TYCD
                : SMSTR_SYSTEM_SBJCT_TYCD);
    }

    /**
     * 공개강좌 시작일은 시간 선택 없이 00:00:00으로 저장한다.
     * @param value
     * @return
     */
    private String normalizeOpenLctrStartDttm(String value) {
        String digits = onlyDigits(value);
        if (digits == null || digits.length() < 8) {
            return digits;
        }
        return digits.substring(0, 8) + "000000";
    }

    /**
     * 공개강좌 종료일은 시간 선택 없이 23:59:59로 저장한다.
     * @param value
     * @return
     */
    private String normalizeOpenLctrEndDttm(String value) {
        String digits = onlyDigits(value);
        if (digits == null || digits.length() < 8) {
            return digits;
        }
        return digits.substring(0, 8) + "235959";
    }

    /**
     * 강의계획서 등록기간 시작 전인지 확인한다.
     * @param orgId
     * @return
     */
    private boolean isBeforeLctrPlandocEnrlPrd(String orgId) {
        if (isBlank(orgId)) {
            return false;
        }

        OrgTaskScheduleVO schdlVO = calendarService.orgTaskSchdlSelect(orgId, LCTR_PLANDOC_ENRL_PRD);
        return schdlVO != null
                && schdlVO.getTaskSdttm() != null
                && schdlVO.getTaskSdttm().matches("\\d{14}")
                && DateTimeUtil.getCurrentString().compareTo(schdlVO.getTaskSdttm()) < 0;
    }

    /**
     * 화면에 남은 주차 순서대로 과목 주차 일정을 보정한다.
     * @param requestVO
     */
    private void normalizeSchdlListForSave(SbjctSchdlVO requestVO) {
        List<SbjctSchdlVO> validList = new ArrayList<>();
        if (requestVO.getSchdlList() != null) {
            int seqNo = 1;
            for (SbjctSchdlVO schdlVO : requestVO.getSchdlList()) {
                if (schdlVO == null) {
                    continue;
                }

                normalizeSchdlForSave(requestVO, schdlVO);
                schdlVO.setSbjctSchdlWkno(seqNo);
                schdlVO.setTocSeqno(seqNo);
                validList.add(schdlVO);
                seqNo++;
            }
        }
        requestVO.setSchdlList(validList);
    }

    /**
     * 과목개설 주차 기간 설정 저장 기본값을 보정한다.
     * @param requestVO
     * @param schdlVO
     */
    private void normalizeSchdlForSave(SbjctSchdlVO requestVO, SbjctSchdlVO schdlVO) {
        schdlVO.setSbjctId(requestVO.getSbjctId());
        schdlVO.setSmstrChrtSchdlId(trimToNull(schdlVO.getSmstrChrtSchdlId()));
        schdlVO.setRgtrId(requestVO.getRgtrId());
        schdlVO.setMdfrId(requestVO.getMdfrId());
        schdlVO.setSbjctSchdlWknonm(trimToNull(schdlVO.getSbjctSchdlWknonm()));
        schdlVO.setSbjctSymd(onlyDigits(schdlVO.getSbjctSymd()));
        schdlVO.setSbjctEymd(onlyDigits(schdlVO.getSbjctEymd()));
        schdlVO.setSbjctAtndcRcgSymd(onlyDigits(schdlVO.getSbjctAtndcRcgSymd()));
        schdlVO.setSbjctAtndcRcgEymd(onlyDigits(schdlVO.getSbjctAtndcRcgEymd()));
    }

    /**
     * 과목관리자 저장 기본값을 보정하고 대표 교수아이디를 반환한다.
     * @param vo
     * @return
     */
    private String normalizeAndFindProfId(SbjctAdmVO vo) {
        if (vo.getAdmList() == null || vo.getAdmList().isEmpty()) {
            return null;
        }

        List<SbjctAdmVO> validList = new ArrayList<>();
        java.util.Set<String> userIdSet = new java.util.HashSet<>();
        String profId = null;
        int seqNo = 1;
        for (SbjctAdmVO admVO : vo.getAdmList()) {
            if (admVO == null || isBlank(admVO.getUserId()) || isBlank(admVO.getSbjctAdmTycd())) {
                continue;
            }

            String userId = trimToNull(admVO.getUserId());
            String sbjctAdmTycd = trimToNull(admVO.getSbjctAdmTycd());
            if (!userIdSet.add(userId)) {
                continue;
            }

            admVO.setSbjctAdmId(IdGenerator.getNewId(IdPrefixType.SBADM.getCode()));
            admVO.setSbjctId(vo.getSbjctId());
            admVO.setUserId(userId);
            admVO.setSbjctAdmTycd(sbjctAdmTycd);
            admVO.setRgtrId(vo.getRgtrId());
            admVO.setMdfrId(vo.getMdfrId());
            admVO.setSbjctAdmSeqno(seqNo++);
            validList.add(admVO);
            if (profId == null && CommConst.SBJCT_ADM_TYCD_PROF.equals(admVO.getSbjctAdmTycd())) {
                profId = admVO.getUserId();
            }
        }

        vo.setAdmList(validList);
        return profId;
    }

    /**
     * 수강생 저장 기본값을 보정한다.
     * @param vo
     */
    private void normalizeAtndlcList(SbjctAtndlcVO vo) {
        List<SbjctAtndlcVO> validList = new java.util.ArrayList<>();
        java.util.Set<String> userIdSet = new java.util.HashSet<>();
        for (SbjctAtndlcVO atndlcVO : vo.getAtndlcList()) {
            if (atndlcVO == null || isBlank(atndlcVO.getUserId())) {
                continue;
            }
            String userId = trimToNull(atndlcVO.getUserId());
            if (!userIdSet.add(userId)) {
                continue;
            }

            atndlcVO.setAtndlcId(IdGenerator.getNewId(IdPrefixType.ATDLC.getCode()));
            atndlcVO.setSbjctId(vo.getSbjctId());
            atndlcVO.setUserId(userId);
            atndlcVO.setRptyn("N");
            atndlcVO.setAtndlcStscd("APPROVE");
            atndlcVO.setRgtrId(vo.getRgtrId());
            atndlcVO.setMdfrId(vo.getMdfrId());
            validList.add(atndlcVO);
        }
        vo.setAtndlcList(validList);
    }

    /**
     * 과목개설 저장 요청값을 검증하고 첫 번째 오류 메시지를 반환한다.
     * @param vo
     * @param regist
     * @return
     */
    private String validateSbjctOfring(SbjctVO vo, boolean regist) {
        BindingResult bindingResult = new BeanPropertyBindingResult(vo, "sbjctVO");
        if (regist) {
            sbjctOfringSaveValidator.validateForRegist(vo, bindingResult);
        } else {
            sbjctOfringSaveValidator.validateForModify(vo, bindingResult);
        }
        if (!bindingResult.hasErrors()) {
            return null;
        }

        ObjectError error = bindingResult.getAllErrors().get(0);
        return messageSource.getMessage(error, LocaleContextHolder.getLocale());
    }

    /**
     * 공개강좌개설 등록/수정에 필요한 최소 입력값만 검증한다.
     * 과목개설 공통 필수값 중 공개강좌에서 사용하지 않는 항목은 normalizeOpenLctrForSave에서 기본값 또는 null로 처리한다.
     * @param vo
     * @param regist
     * @return
     */
    private String validateOpenLctrOfring(SbjctVO vo, boolean regist) {
        BindingResult bindingResult = new BeanPropertyBindingResult(vo, "sbjctVO");
        if (regist) {
            sbjctOpenLctrOfringSaveValidator.validateForRegist(vo, bindingResult);
        } else {
            sbjctOpenLctrOfringSaveValidator.validateForModify(vo, bindingResult);
        }
        if (!bindingResult.hasErrors()) {
            return null;
        }

        ObjectError error = bindingResult.getAllErrors().get(0);
        return messageSource.getMessage(error, LocaleContextHolder.getLocale());
    }

    /**
     * 과목개설 주차 기간 설정 저장 요청값을 검증하고 첫 번째 오류 메시지를 반환한다.
     * @param vo
     * @return
     */
    private String validateSbjctOfringSchdl(SbjctSchdlVO vo) {
        BindingResult bindingResult = new BeanPropertyBindingResult(vo, "sbjctSchdlVO");
        sbjctOfringSchdlSaveValidator.validateForSave(vo, bindingResult);
        if (!bindingResult.hasErrors()) {
            return null;
        }

        ObjectError error = bindingResult.getAllErrors().get(0);
        return messageSource.getMessage(error, LocaleContextHolder.getLocale());
    }

    /**
     * 문자열이 null 이거나 공백인지 확인한다.
     * @param value
     * @return
     */
    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    /**
     * 공백 문자열을 null로 변환한다.
     * @param value
     * @return
     */
    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }

    /**
     * 공백 문자열을 null로 변환한다.
     * @param value
     * @return
     */
    private String trimToNull(Object value) {
        if(value == null) {
            return null;
        }
        String text = String.valueOf(value).trim();
        return text.isEmpty() ? null : text;
    }

    /**
     * 숫자만 남긴 문자열을 반환한다.
     * @param value
     * @return
     */
    private String onlyDigits(String value) {
        if (value == null) {
            return null;
        }
        return value.replaceAll("[^0-9]", "");
    }

    /**
     * COUNT(*) OVER() 조회 결과에서 전체 건수를 추출한다.
     * @param list
     * @return
     */
    private int getSbjctListTotalCount(List<SbjctListVO> list) {
        return list == null || list.isEmpty() ? 0 : list.get(0).getTotalCnt();
    }

    /**
     * 메시지 코드를 현재 Locale의 메시지로 변환한다.
     * @param messageKey
     * @return
     */
    private String getMessage(String messageKey) {
        return messageSource.getMessage(messageKey, null, messageKey, LocaleContextHolder.getLocale());
    }

    /**
     * 메시지 코드를 현재 Locale의 메시지로 변환한다.
     * @param messageKey
     * @param args
     * @return
     */
    private String getMessage(String messageKey, Object[] args) {
        return messageSource.getMessage(messageKey, args, messageKey, LocaleContextHolder.getLocale());
    }
}
