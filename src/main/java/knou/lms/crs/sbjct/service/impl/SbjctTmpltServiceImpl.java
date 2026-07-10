package knou.lms.crs.sbjct.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.crs.sbjct.dao.SbjctTmpltDAO;
import knou.lms.crs.sbjct.service.SbjctTmpltService;
import knou.lms.crs.sbjct.vo.SbjctTmpltListVO;
import knou.lms.crs.sbjct.vo.SbjctTmpltVO;
import knou.lms.crs.sbjct.web.paging.SbjctTmpltPageInfo;
import knou.lms.file.vo.AtflVO;
import knou.lms.crs.sbjct.web.validation.SbjctTmpltSaveValidator;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;

@Service("sbjctTmpltService")
public class SbjctTmpltServiceImpl extends ServiceBase implements SbjctTmpltService {

    private static final String CHRT_SMSTR_CHRT_GBNCD = "CHRT";
    private static final String CHRT_SYSTEM_SBJCT_TYCD = "CHRT_SYSTEM";
    private static final String SMSTR_SYSTEM_SBJCT_TYCD = "SMSTR_SYSTEM";

    @Resource(name = "sbjctTmpltDAO")
    private SbjctTmpltDAO sbjctTmpltDAO;

    @Resource(name = "messageSource")
    private MessageSource messageSource;

    @Resource(name = "cmmnCdService")
    private CmmnCdService cmmnCdService;

    @Resource(name = "semesterService")
    private SemesterService semesterService;

    @Resource(name = "sbjctTmpltSaveValidator")
    private SbjctTmpltSaveValidator sbjctTmpltSaveValidator;

    /**
     * 과목목록조회(페이징)을 수행한다.
     * @param pageInfo
     * @return
     */
    @Override
    public ResultDTO<SbjctTmpltListVO> selectSbjctTmpltList(SbjctTmpltPageInfo pageInfo) {
        List<SbjctTmpltListVO> sbjctTmpltList = sbjctTmpltDAO.selectSbjctTmpltList(pageInfo);
        ResultDTO<SbjctTmpltListVO> resultDTO = new ResultDTO<>(pageInfo);
        resultDTO.setReturnList(sbjctTmpltList);
        resultDTO.getPageInfo().setTotalRecordCount(getSbjctTmpltListTotalCount(sbjctTmpltList));
        resultDTO.setResultSuccess();

        return resultDTO;
    }

    /**
     * 과목목록 엑셀 다운로드 목록을 조회한다.
     * @param pageInfo
     * @return
     */
    @Override
    public List<SbjctTmpltListVO> selectSbjctTmpltListExcelDown(SbjctTmpltPageInfo pageInfo) {
        return sbjctTmpltDAO.selectSbjctTmpltListExcelDown(pageInfo);
    }

    /**
     * 과목개설 등록 화면에서 선택할 과목목록을 조회한다.
     * @param sbjctTmpltListVO
     * @return
     */
    @Override
    public ResultDTO<SbjctTmpltListVO> selectSbjctTmpltOfringList(SbjctTmpltListVO sbjctTmpltListVO) {
        ResultDTO<SbjctTmpltListVO> resultDTO = new ResultDTO<>();
        resultDTO.setReturnList(sbjctTmpltDAO.selectSbjctTmpltOfringList(sbjctTmpltListVO));
        resultDTO.setResultSuccess();
        return resultDTO;
    }

    /**
     * 과목사용여부를 수정한다.
     * @param sbjctTmpltListVO
     * @return
     */
    @Override
    public ResultDTO<SbjctTmpltListVO> updateSbjctTmpltUseyn(SbjctTmpltListVO sbjctTmpltListVO) {
        ResultDTO<SbjctTmpltListVO> resultDTO = new ResultDTO<>();
        resultDTO.setSuccessCount(sbjctTmpltDAO.updateSbjctTmpltUseyn(sbjctTmpltListVO));
        return resultDTO;
    }

    /**
     * 과목을 논리삭제한다.
     * @param sbjctTmpltListVO
     * @return
     */
    @Override
    public ResultDTO<Integer> deleteSbjctTmplt(SbjctTmpltListVO sbjctTmpltListVO) {
        ResultDTO<Integer> resultDTO = new ResultDTO<>();
        resultDTO.setSuccessCount(sbjctTmpltDAO.deleteSbjctTmplt(sbjctTmpltListVO));
        return resultDTO;
    }

    /**
     * 과목명/과목코드 중복 여부를 확인한다.
     * @param sbjctTmpltVO
     * @return
     */
    @Override
    public ResultDTO<SbjctTmpltVO> checkSbjctTmpltDup(SbjctTmpltVO sbjctTmpltVO) {
        ResultDTO<SbjctTmpltVO> resultDTO = new ResultDTO<>();

        String validationMessage = validateDupCheckRequest(sbjctTmpltVO);
        if (validationMessage != null) {
            return resultDTO.setResultFailed(validationMessage);
        }

        if (sbjctTmpltDAO.selectSbjctTmpltDupCnt(sbjctTmpltVO) > 0) {
            if ("NAME".equals(sbjctTmpltVO.getCheckType())) {
                return resultDTO.setResultFailed(getMessage("crs.sbjct.alert.dup.name"));/*이미 등록된 과목명입니다.*/
            }
            return resultDTO.setResultFailed(getMessage("crs.sbjct.alert.dup.code"));/*이미 등록된 과목코드입니다.*/
        }

        if ("NAME".equals(sbjctTmpltVO.getCheckType())) {
            return resultDTO.setResultSuccess(getMessage("crs.sbjct.alert.dup.name.available"));/*사용 가능한 과목명입니다.*/
        }
        return resultDTO.setResultSuccess(getMessage("crs.sbjct.alert.dup.code.available"));/*사용 가능한 과목코드입니다.*/
    }

    /**
     * 과목 상세 정보를 조회한다.
     * @param sbjctTmpltVO
     * @return
     */
    @Override
    public SbjctTmpltVO selectSbjctTmplt(SbjctTmpltVO sbjctTmpltVO) {
        return sbjctTmpltDAO.selectSbjctTmplt(sbjctTmpltVO);
    }

    /**
     * 과목을 등록한다.
     * @param sbjctTmpltVO
     * @return
     */
    @Override
    public ResultDTO<SbjctTmpltVO> insertSbjctTmplt(SbjctTmpltVO sbjctTmpltVO) {
        ResultDTO<SbjctTmpltVO> resultDTO = new ResultDTO<>();

        String validationMessage = validateSbjctTmplt(sbjctTmpltVO, true);
        if (validationMessage != null) {
            return resultDTO.setResultFailed(validationMessage);
        }

        normalizeForSave(sbjctTmpltVO);
        sbjctTmpltVO.setSbjctTmpltId(IdGenerator.getNewId(IdPrefixType.SBTML.getCode()));
        sbjctTmpltVO.setDelyn("N");

        return saveSbjctTmplt(resultDTO, sbjctTmpltVO, true);
    }

    /**
     * 과목 엑셀 업로드 파일을 읽어 일괄 등록한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<SbjctTmpltVO> uploadSbjctTmpltExcel(SbjctTmpltVO vo) {
        ResultDTO<SbjctTmpltVO> resultDTO = new ResultDTO<>();
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
            return insertSbjctTmpltExcel(vo, excelUtilPoi.simpleReadGrid(excelMap));
        } catch (Exception e) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        } finally {
            deleteUploadFiles(uploadFiles, uploadPath);
        }
    }

    /**
     * 과목 엑셀 업로드 데이터를 일괄 등록한다.
     * @param baseVO
     * @param excelList
     * @return
     */
    private ResultDTO<SbjctTmpltVO> insertSbjctTmpltExcel(SbjctTmpltVO baseVO, List<?> excelList) {
        ResultDTO<SbjctTmpltVO> resultDTO = new ResultDTO<>();

        try {
            // 목록 화면에서 고정 전달된 기관/년도/학기/기수 기준값을 먼저 검증한다.
            String baseValidationMessage = validateExcelBase(baseVO);
            if (baseValidationMessage != null) {
                return resultDTO.setResultFailed(baseValidationMessage);
            }

            normalizeForSave(baseVO);

            // 엑셀 코드값 유효성 검증에 사용할 기준 공통코드 목록을 미리 조회한다.
            Set<String> lctrGbncdSet = buildCodeSet(baseVO.getOrgId(), "LCTR_GBNCD");
            Set<String> excelNameSet = new HashSet<>();
            Set<String> excelCodeSet = new HashSet<>();
            List<SbjctTmpltVO> sbjctTmpltList = new ArrayList<>();

            if (excelList == null || excelList.isEmpty()) {
                return resultDTO.setResultFailed(getMessage("crs.sbjct.alert.excel.empty"));/*등록할 과목 데이터가 없습니다.*/
            }

            // 엑셀 읽기 결과를 과목 값 객체로 변환하고 행 단위 검증을 수행한다.
            for (int i = 0; i < excelList.size(); i++) {
                if (!(excelList.get(i) instanceof Map)) {
                    continue;
                }

                @SuppressWarnings("unchecked")
                Map<String, Object> rowMap = (Map<String, Object>) excelList.get(i);
                if (isEmptyExcelRow(rowMap)) {
                    continue;
                }

                int excelRowNo = i + 5;
                SbjctTmpltVO rowVO = toSbjctTmpltVO(baseVO, rowMap);

                String validationMessage = validateExcelRow(rowVO, lctrGbncdSet, excelNameSet, excelCodeSet);
                if (validationMessage != null) {
                    return resultDTO.setResultFailed(getMessage("crs.sbjct.alert.excel.row.error", new Object[] { excelRowNo, validationMessage }));/*엑셀 {0}행: {1}*/
                }

                // 모든 검증이 끝난 행에 대해서만 기본값 보정과 식별자 선생성을 수행한다.
                normalizeForSave(rowVO);
                rowVO.setSbjctTmpltId(IdGenerator.getNewId(IdPrefixType.SBTML.getCode()));
                rowVO.setDelyn("N");
                sbjctTmpltList.add(rowVO);
            }

            if (sbjctTmpltList.isEmpty()) {
                return resultDTO.setResultFailed(getMessage("crs.sbjct.alert.excel.empty"));/*등록할 과목 데이터가 없습니다.*/
            }

            // 트랜잭션 안에서 벌크 insert를 수행하므로 오류 발생 시 일괄 롤백된다.
            int result = sbjctTmpltDAO.insertSbjctTmpltList(sbjctTmpltList);
            resultDTO.setReturnList(sbjctTmpltList);
            resultDTO.setSuccessCount(result);
            return resultDTO;
        } catch (DataIntegrityViolationException e) {
            return resultDTO.setResultFailed(getMessage("crs.sbjct.alert.dup.name.or.code"));/*이미 등록된 과목명 또는 과목코드입니다.*/
        } catch (Exception e) {
            return resultDTO.setResultFailed(getMessage("fail.common.msg"));/*에러가 발생했습니다!*/
        }
    }

    /**
     * 과목을 수정한다.
     * @param sbjctTmpltVO
     * @return
     */
    @Override
    public ResultDTO<SbjctTmpltVO> updateSbjctTmplt(SbjctTmpltVO sbjctTmpltVO) {
        ResultDTO<SbjctTmpltVO> resultDTO = new ResultDTO<>();

        String validationMessage = validateSbjctTmplt(sbjctTmpltVO, false);
        if (validationMessage != null) {
            return resultDTO.setResultFailed(validationMessage);
        }

        normalizeForSave(sbjctTmpltVO);

        return saveSbjctTmplt(resultDTO, sbjctTmpltVO, false);
    }

    /**
     * 과목 중복 검증 후 등록/수정을 수행한다.
     * @param resultDTO
     * @param sbjctTmpltVO
     * @param regist
     * @return
     */
    private ResultDTO<SbjctTmpltVO> saveSbjctTmplt(ResultDTO<SbjctTmpltVO> resultDTO, SbjctTmpltVO sbjctTmpltVO, boolean regist) {
        try {
            String validationMessage = validateSbjctTmpltRelation(sbjctTmpltVO);
            if (validationMessage != null) {
                return resultDTO.setResultFailed(validationMessage);
            }

            if (isDuplicatedSbjctTmplt(sbjctTmpltVO)) {
                return resultDTO.setResultFailed(getMessage("crs.sbjct.alert.dup.name.or.code"));/*이미 등록된 과목명 또는 과목코드입니다.*/
            }

            int result = regist ? sbjctTmpltDAO.insertSbjctTmplt(sbjctTmpltVO) : sbjctTmpltDAO.updateSbjctTmplt(sbjctTmpltVO);
            resultDTO.setData(sbjctTmpltVO);
            resultDTO.setSuccessCount(result);
            return resultDTO;
        } catch (DataIntegrityViolationException e) {
            return resultDTO.setResultFailed(getMessage("crs.sbjct.alert.dup.name.or.code"));/*이미 등록된 과목명 또는 과목코드입니다.*/
        }
    }

    /**
     * 과목 저장 요청값을 검증하고 첫 번째 오류 메시지를 반환한다.
     * @param vo
     * @param regist
     * @return
     */
    private String validateSbjctTmplt(SbjctTmpltVO vo, boolean regist) {
        BindingResult bindingResult = new BeanPropertyBindingResult(vo, "sbjctTmpltVO");
        if (regist) {
            sbjctTmpltSaveValidator.validateForRegist(vo, bindingResult);
        } else {
            sbjctTmpltSaveValidator.validateForModify(vo, bindingResult);
        }
        return bindingResult.hasErrors() ? getBindingMessage(bindingResult) : null;
    }

    /**
     * 과목 중복체크 요청값을 검증한다.
     * @param sbjctTmpltVO
     * @return
     */
    private String validateDupCheckRequest(SbjctTmpltVO sbjctTmpltVO) {
        if (isBlank(sbjctTmpltVO.getOrgId())) {
            return getMessage("crs.sbjct.alert.select.org");/*기관을 선택해 주세요.*/
        }
        if (isBlank(sbjctTmpltVO.getSmstrChrtId())) {
            return getMessage("crs.sbjct.alert.select.smstr.chrt");/*학기/기수 명을 선택해 주세요.*/
        }
        String checkType = sbjctTmpltVO.getCheckType();
        if ("NAME".equals(checkType)) {
            if (isBlank(sbjctTmpltVO.getSbjctnm())) {
                return getMessage("crs.sbjct.alert.input.name");/*과목명을 입력해 주세요.*/
            }
        } else if ("CODE".equals(checkType)) {
            if (isBlank(sbjctTmpltVO.getSbjctCd())) {
                return getMessage("crs.sbjct.alert.input.code");/*과목코드를 입력해 주세요.*/
            }
        } else {
            return getMessage("crs.sbjct.alert.dup.type.invalid");/*중복체크 유형이 올바르지 않습니다.*/
        }
        return null;
    }

    /**
     * 과목 저장 시 학기/기수와 학과 관계를 검증한다.
     * @param sbjctTmpltVO
     * @return
     */
    private String validateSbjctTmpltRelation(SbjctTmpltVO sbjctTmpltVO) {
        if (sbjctTmpltDAO.selectSbjctTmpltSmstrChrtCnt(sbjctTmpltVO) <= 0) {
            return getMessage("crs.sbjct.alert.invalid.smstr.chrt");/*선택한 학기/기수 정보가 올바르지 않습니다.*/
        }
        return null;
    }

    /**
     * 과목명/과목코드 중복 여부를 확인한다.
     * @param sbjctTmpltVO
     * @return
     */
    private boolean isDuplicatedSbjctTmplt(SbjctTmpltVO sbjctTmpltVO) {
        String checkType = sbjctTmpltVO.getCheckType();
        sbjctTmpltVO.setCheckType("NAME");
        boolean duplicated = sbjctTmpltDAO.selectSbjctTmpltDupCnt(sbjctTmpltVO) > 0;
        sbjctTmpltVO.setCheckType("CODE");
        duplicated = duplicated || sbjctTmpltDAO.selectSbjctTmpltDupCnt(sbjctTmpltVO) > 0;
        sbjctTmpltVO.setCheckType(checkType);
        return duplicated;
    }

    /**
     * 엑셀 일괄 등록 기준값인 기관/학기기수/년도/학기를 검증한다.
     * @param baseVO
     * @return
     */
    private String validateExcelBase(SbjctTmpltVO baseVO) {
        if (baseVO == null || isBlank(baseVO.getOrgId())) {
            return getMessage("crs.sbjct.alert.select.org");/*기관을 선택해 주세요.*/
        }
        if (isBlank(baseVO.getSmstrChrtId())) {
            return getMessage("crs.sbjct.alert.select.smstr.chrt");/*학기/기수 명을 선택해 주세요.*/
        }
        if (isBlank(baseVO.getSbjctYr())) {
            return getMessage("crs.sbjct.alert.select.year");/*년도를 선택해 주세요.*/
        }
        if (isBlank(baseVO.getSbjctSmstr())) {
            return getMessage("crs.sbjct.alert.select.term");/*학기/기수를 선택해 주세요.*/
        }
        if (sbjctTmpltDAO.selectSbjctTmpltSmstrChrtCnt(baseVO) <= 0) {
            return getMessage("crs.sbjct.alert.invalid.smstr.chrt");/*선택한 학기/기수 정보가 올바르지 않습니다.*/
        }
        return null;
    }

    /**
     * 엑셀 한 행의 A~F 컬럼 값을 과목 VO로 변환한다.
     * @param baseVO
     * @param rowMap
     * @return
     */
    private SbjctTmpltVO toSbjctTmpltVO(SbjctTmpltVO baseVO, Map<String, Object> rowMap) {
        SbjctTmpltVO rowVO = new SbjctTmpltVO();
        rowVO.setOrgId(baseVO.getOrgId());
        rowVO.setSmstrChrtId(baseVO.getSmstrChrtId());
        rowVO.setSbjctYr(baseVO.getSbjctYr());
        rowVO.setSbjctSmstr(baseVO.getSbjctSmstr());
        rowVO.setLangCd(baseVO.getLangCd());
        rowVO.setUserId(baseVO.getUserId());
        rowVO.setRgtrId(baseVO.getRgtrId());
        rowVO.setMdfrId(baseVO.getMdfrId());
        rowVO.setSbjctTycd(baseVO.getSbjctTycd());
        rowVO.setLctrGbncd(cell(rowMap, "A"));
        rowVO.setSbjctCd(cell(rowMap, "B"));
        rowVO.setSbjctnm(cell(rowMap, "C"));
        rowVO.setUseyn(cell(rowMap, "D"));
        rowVO.setSbjctExpln(cell(rowMap, "E"));
        return rowVO;
    }

    /**
     * 엑셀 한 행의 필수값, 코드값, 엑셀 내부 중복, DB 중복을 검증한다.
     * @param rowVO
     * @param lctrGbncdSet
     * @param excelNameSet
     * @param excelCodeSet
     * @return
     */
    private String validateExcelRow(
            SbjctTmpltVO rowVO,
            Set<String> lctrGbncdSet,
            Set<String> excelNameSet,
            Set<String> excelCodeSet) {

        BindingResult bindingResult = new BeanPropertyBindingResult(rowVO, "sbjctTmpltVO");
        sbjctTmpltSaveValidator.validateForRegist(rowVO, bindingResult);
        if (bindingResult.hasErrors()) {
            return getBindingMessage(bindingResult);
        }

        // 엑셀에 입력한 공통코드가 현재 기관에서 사용 가능한 값인지 확인한다.
        if (!lctrGbncdSet.contains(rowVO.getLctrGbncd())) {
            return getMessage("crs.sbjct.alert.invalid.lctr.gbn");/*강의형태 코드가 올바르지 않습니다.*/
        }

        // 같은 업로드 파일 안의 과목명/과목코드 중복을 먼저 차단한다.
        if (!excelNameSet.add(normalizeKey(rowVO.getSbjctnm()))) {
            return getMessage("crs.sbjct.alert.excel.dup.name");/*엑셀 내 과목명이 중복되었습니다.*/
        }
        if (!excelCodeSet.add(normalizeKey(rowVO.getSbjctCd()))) {
            return getMessage("crs.sbjct.alert.excel.dup.code");/*엑셀 내 과목코드가 중복되었습니다.*/
        }

        // 데이터베이스에 이미 등록된 과목명/과목코드와의 중복을 확인한다.
        rowVO.setCheckType("NAME");
        if (sbjctTmpltDAO.selectSbjctTmpltDupCnt(rowVO) > 0) {
            return getMessage("crs.sbjct.alert.dup.name");/*이미 등록된 과목명입니다.*/
        }
        rowVO.setCheckType("CODE");
        if (sbjctTmpltDAO.selectSbjctTmpltDupCnt(rowVO) > 0) {
            return getMessage("crs.sbjct.alert.dup.code");/*이미 등록된 과목코드입니다.*/
        }
        rowVO.setCheckType(null);

        return null;
    }

    /**
     * 기관별 공통코드 목록을 검증용 Set으로 생성한다.
     * @param orgId
     * @param upCd
     * @return
     * @throws Exception
     */
    private Set<String> buildCodeSet(String orgId, String upCd) throws Exception {
        Set<String> codeSet = new HashSet<>();
        List<CmmnCdVO> codeList = cmmnCdService.listCode(null, upCd).getReturnList();
        if (codeList != null) {
            for (CmmnCdVO code : codeList) {
                if (code.getCdSeqno() != null && code.getCdSeqno() == 0) {
                    continue;
                }
                if (!isBlank(code.getCd())) {
                    codeSet.add(code.getCd());
                }
            }
        }
        return codeSet;
    }

    /**
     * 엑셀 행의 등록 대상 컬럼이 모두 비어 있는지 확인한다.
     * @param rowMap
     * @return
     */
    private boolean isEmptyExcelRow(Map<String, Object> rowMap) {
        return isBlank(cell(rowMap, "A"))
                && isBlank(cell(rowMap, "B"))
                && isBlank(cell(rowMap, "C"))
                && isBlank(cell(rowMap, "D"))
                && isBlank(cell(rowMap, "E"));
    }

    /**
     * 엑셀 컬럼 값을 문자열로 변환하고 앞뒤 공백을 제거한다.
     * @param rowMap
     * @param column
     * @return
     */
    private String cell(Map<String, Object> rowMap, String column) {
        return StringUtil.nvl(rowMap.get(column)).trim();
    }

    /**
     * 과목명/과목코드 중복 비교용 문자열로 정규화한다.
     * @param value
     * @return
     */
    private String normalizeKey(String value) {
        return StringUtil.nvl(value).trim().toLowerCase();
    }

    /**
     * Validator 오류 중 첫 번째 메시지를 현재 Locale 기준 메시지로 변환한다.
     * @param bindingResult
     * @return
     */
    private String getBindingMessage(BindingResult bindingResult) {
        ObjectError error = bindingResult.getAllErrors().get(0);
        return messageSource.getMessage(error, LocaleContextHolder.getLocale());
    }

    /**
     * 과목 저장 기본값을 보정한다.
     * @param vo
     */
    private void normalizeForSave(SbjctTmpltVO vo) {
        SmstrChrtVO smstrChrtVO = selectSmstrChrtForSave(vo);
        normalizeSbjctYrSmstr(vo, smstrChrtVO);
        normalizeSbjctTycdBySmstrChrt(vo, smstrChrtVO);
        if (isBlank(vo.getSbjctRefTycd())) {
            vo.setSbjctRefTycd("CHRT");
        }
        if (isBlank(vo.getUseyn())) {
            vo.setUseyn("Y");
        }
        if (isBlank(vo.getDelyn())) {
            vo.setDelyn("N");
        }
    }

    /**
     * 저장 요청의 학기기수 정보를 조회한다.
     * @param vo
     * @return
     */
    private SmstrChrtVO selectSmstrChrtForSave(SbjctTmpltVO vo) {
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
    private void normalizeSbjctYrSmstr(SbjctTmpltVO vo, SmstrChrtVO smstrChrtVO) {
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
    private void normalizeSbjctTycdBySmstrChrt(SbjctTmpltVO vo, SmstrChrtVO smstrChrtVO) {
        if (vo == null || smstrChrtVO == null) {
            return;
        }

        vo.setSbjctTycd(CHRT_SMSTR_CHRT_GBNCD.equals(smstrChrtVO.getSmstrChrtGbncd())
                ? CHRT_SYSTEM_SBJCT_TYCD
                : SMSTR_SYSTEM_SBJCT_TYCD);
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
     * COUNT(*) OVER() 조회 결과에서 전체 건수를 추출한다.
     * @param list
     * @return
     */
    private int getSbjctTmpltListTotalCount(List<SbjctTmpltListVO> list) {
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
