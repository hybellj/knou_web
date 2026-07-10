package knou.lms.evalwgtmng.service.impl;

import knou.framework.common.PageInfo;
import knou.framework.common.IdPrefixType;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.lms.file.vo.AtflVO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.evalwgtmng.dao.EvalWgtMngDAO;
import knou.lms.evalwgtmng.service.EvalWgtMngService;
import knou.lms.evalwgtmng.vo.EvalWgtMngVO;
import knou.lms.mrk.vo.MarkItemSettingVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service("evalWgtMngService")
public class EvalWgtMngServiceImpl implements EvalWgtMngService {

    @Resource(name = "evalWgtMngDAO")
    private EvalWgtMngDAO evalWgtMngDAO;

    /*****************************************************
     * 평가비중관리 목록 조회
     * @param pageInfo
     * @return ResultDTO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ResultDTO<EgovMap> listEvalWgtMng(PageInfo pageInfo) throws Exception {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>(pageInfo);

        if (pageInfo.getCurrentPageNo() <= 0 && pageInfo.getPageIndex() > 0) {
            pageInfo.setCurrentPageNo(pageInfo.getPageIndex());
        }
        if (pageInfo.getCurrentPageNo() <= 0) {
            pageInfo.setCurrentPageNo(1);
        }
        if (pageInfo.getRecordCountPerPage() <= 0 && pageInfo.getListScale() > 0) {
            pageInfo.setRecordCountPerPage(pageInfo.getListScale());
        }
        if (pageInfo.getRecordCountPerPage() <= 0) {
            pageInfo.setRecordCountPerPage(10);
        }
        if (pageInfo.getPageSize() <= 0 && pageInfo.getPageScale() > 0) {
            pageInfo.setPageSize(pageInfo.getPageScale());
        }
        if (pageInfo.getPageSize() <= 0) {
            pageInfo.setPageSize(10);
        }
        pageInfo.setPageIndex(pageInfo.getCurrentPageNo());
        pageInfo.setListScale(pageInfo.getRecordCountPerPage());
        pageInfo.setPageScale(pageInfo.getPageSize());

        int totalCount = evalWgtMngDAO.countEvalWgtMng(pageInfo);
        resultDTO.getPageInfo().setTotalRecordCount(totalCount);

        if (totalCount == 0) {
            resultDTO.setReturnList(Collections.<EgovMap>emptyList());
            return resultDTO.setResultSuccess();
        }

        resultDTO.setReturnList(evalWgtMngDAO.listEvalWgtMng(pageInfo));
        return resultDTO.setResultSuccess();
    }

    /*****************************************************
     * 평가비중관리 과목 목록 조회
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listEvalWgtMngSubject(EvalWgtMngVO vo) throws Exception {
        if (isBlank(vo.getLangCd())) {
            vo.setLangCd("ko");
        }
        return evalWgtMngDAO.listEvalWgtMngSubject(vo);
    }

    /*****************************************************
     * 평가비중관리 과목 정보 조회
     * @param vo
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectEvalWgtMngSubject(EvalWgtMngVO vo) throws Exception {
        return evalWgtMngDAO.selectEvalWgtMngSubject(vo);
    }

    /*****************************************************
     * 평가비중관리 분반 목록 조회
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listEvalWgtMngDvclasSubject(EvalWgtMngVO vo) throws Exception {
        if (isBlank(vo.getSbjctId())) {
            return Collections.emptyList();
        }
        return evalWgtMngDAO.listEvalWgtMngDvclasSubject(vo);
    }

    /*****************************************************
     * 평가비중관리 평가항목 목록 조회
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listEvalWgtMngItem(EvalWgtMngVO vo) throws Exception {
        if (isBlank(vo.getLangCd())) {
            vo.setLangCd("ko");
        }
        return evalWgtMngDAO.listEvalWgtMngItem(vo);
    }

    /*****************************************************
     * 평가비중관리 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void saveEvalWgtMng(EvalWgtMngVO vo) throws Exception {
        if (isBlank(vo.getSbjctId())) {
            throw new IllegalArgumentException("과목을 선택해 주세요.");
        }
        if (isBlank(vo.getOrgId())) {
            throw new IllegalArgumentException("기관을 확인할 수 없습니다.");
        }

        List<MarkItemSettingVO> itemList = vo.getMrkItmStngList();
        if (itemList == null || itemList.isEmpty()) {
            throw new IllegalArgumentException("평가비중 항목을 확인할 수 없습니다.");
        }

        BigDecimal totalRate = BigDecimal.ZERO;
        for (MarkItemSettingVO item : itemList) {
            if (item == null || isBlank(item.getMrkItmTycd())) {
                continue;
            }

            String useYn = "Y".equals(StringUtil.nvl(item.getMrkItmUseyn())) ? "Y" : "N";
            item.setMrkItmUseyn(useYn);
            item.setMrkOyn("N".equals(StringUtil.nvl(item.getMrkOyn())) ? "N" : "Y");

            if ("Y".equals(useYn)) {
                if (item.getMrkRfltrt() == null) {
                    throw new IllegalArgumentException("사용할 평가항목의 비중을 입력해 주세요.");
                }
                if (item.getMrkRfltrt().compareTo(BigDecimal.ZERO) < 0 || item.getMrkRfltrt().compareTo(new BigDecimal("100")) > 0) {
                    throw new IllegalArgumentException("평가비중은 0부터 100 사이로 입력해 주세요.");
                }
                totalRate = totalRate.add(item.getMrkRfltrt());
            } else {
                item.setMrkRfltrt(BigDecimal.ZERO);
            }
        }

        if (totalRate.compareTo(new BigDecimal("100")) != 0) {
            throw new IllegalArgumentException("사용 평가항목의 평가비중 합계는 100이어야 합니다.");
        }

        Set<String> targetSbjctIdSet = resolveTargetSbjctIds(vo);
        for (String targetSbjctId : targetSbjctIdSet) {
            for (MarkItemSettingVO item : itemList) {
                if (item == null || isBlank(item.getMrkItmTycd())) {
                    continue;
                }
                item.setSbjctId(targetSbjctId);
                item.setOrgId(vo.getOrgId());
                item.setRgtrId(vo.getRgtrId());
                item.setMdfrId(vo.getMdfrId());
                item.setMrkItmStngId(IdGenUtil.genNewId(IdPrefixType.MRSET));

                evalWgtMngDAO.mergeEvalWgtMngItem(item);
            }
        }
    }

    /*****************************************************
     * 평가비중관리 엑셀 업로드
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @SuppressWarnings("unchecked")
    @Override
    public int evalWgtMngExcelUpload(EvalWgtMngVO vo) throws Exception {
        if (isBlank(vo.getOrgId())) {
            throw new IllegalArgumentException("기관 정보를 확인할 수 없습니다.");
        }
        if (isBlank(vo.getUploadFiles()) || isBlank(vo.getUploadPath())) {
            throw new IllegalArgumentException("업로드 파일 정보를 확인할 수 없습니다.");
        }
        if (isBlank(vo.getExcelGrid())) {
            throw new IllegalArgumentException("엑셀 템플릿 정보를 확인할 수 없습니다.");
        }

        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        if (uploadFileList == null || uploadFileList.isEmpty()) {
            throw new IllegalArgumentException("업로드된 엑셀 파일을 확인할 수 없습니다.");
        }

        HashMap<String, Object> excelMap = new HashMap<String, Object>();
        excelMap.put("startRaw", 4);
        excelMap.put("excelGrid", vo.getExcelGrid());
        excelMap.put("atflVO", uploadFileList.get(0));
        excelMap.put("searchKey", "excelUpload");

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        List<Map<String, Object>> rows = (List<Map<String, Object>>) excelUtilPoi.simpleReadGrid(excelMap);
        if (rows == null || rows.isEmpty()) {
            throw new IllegalArgumentException("엑셀 업로드 데이터가 없습니다.");
        }

        EvalWgtMngVO codeVo = new EvalWgtMngVO();
        codeVo.setOrgId(vo.getOrgId());
        codeVo.setLangCd("ko");
        codeVo.setMode("regist");
        List<EgovMap> itemCodeList = evalWgtMngDAO.listEvalWgtMngItem(codeVo);
        if (itemCodeList == null || itemCodeList.isEmpty()) {
            throw new IllegalArgumentException("평가항목 코드를 확인할 수 없습니다.");
        }

        Map<String, String> itemCodeMap = new LinkedHashMap<String, String>();
        for (EgovMap codeInfo : itemCodeList) {
            String code = StringUtil.nvl((String) codeInfo.get("mrkItmTycd")).trim();
            String name = StringUtil.nvl((String) codeInfo.get("mrkItmTynm")).trim();
            if (!isBlank(code)) {
                itemCodeMap.put(code.toUpperCase(), code);
            }
            if (!isBlank(name)) {
                itemCodeMap.put(name.toUpperCase(), code);
            }
        }

        Map<String, ExcelUploadGroup> groupMap = new LinkedHashMap<String, ExcelUploadGroup>();
        for (int i = 0; i < rows.size(); i++) {
            Map<String, Object> row = rows.get(i);
            int lineNo = i + 4;

            String orgNm = getCellValue(row, "A");
            String haksaYear = fallbackValue(getCellValue(row, "B"), vo.getHaksaYear());
            String haksaTerm = fallbackValue(getCellValue(row, "C"), vo.getHaksaTerm());
            String crclmnNo = getCellValue(row, "D");
            String sbjctNm = getCellValue(row, "E");
            String itemInput = getCellValue(row, "F");
            String rateInput = getCellValue(row, "G");
            String openInput = getCellValue(row, "H");

            if (isBlank(orgNm) && isBlank(haksaYear) && isBlank(haksaTerm)
                && isBlank(crclmnNo) && isBlank(sbjctNm) && isBlank(itemInput) && isBlank(rateInput) && isBlank(openInput)) {
                continue;
            }

            if (isBlank(haksaYear) || isBlank(haksaTerm) || isBlank(crclmnNo) || isBlank(sbjctNm) || isBlank(itemInput) || isBlank(rateInput)) {
                throw new IllegalArgumentException(lineNo + "행 필수값을 확인해 주세요.");
            }

            String itemCode = resolveItemCode(itemCodeMap, itemInput, lineNo);
            BigDecimal rate = parseRate(rateInput, lineNo);
            String openYn = parseOpenYn(openInput, lineNo);

            String groupKey = StringUtil.nvl(orgNm) + "|" + haksaYear + "|" + haksaTerm + "|" + crclmnNo + "|" + sbjctNm;
            ExcelUploadGroup group = groupMap.get(groupKey);
            if (group == null) {
                group = new ExcelUploadGroup();
                group.orgNm = orgNm;
                group.haksaYear = haksaYear;
                group.haksaTerm = haksaTerm;
                group.crclmnNo = crclmnNo;
                group.sbjctNm = sbjctNm;
                groupMap.put(groupKey, group);
            }

            if (group.itemMap.containsKey(itemCode)) {
                throw new IllegalArgumentException(lineNo + "행 평가항목코드가 중복되었습니다.");
            }

            MarkItemSettingVO item = new MarkItemSettingVO();
            item.setMrkItmTycd(itemCode);
            item.setMrkRfltrt(rate);
            item.setMrkOyn(openYn);
            item.setMrkItmUseyn("Y");
            group.itemMap.put(itemCode, item);
        }

        if (groupMap.isEmpty()) {
            throw new IllegalArgumentException("엑셀 업로드 데이터가 없습니다.");
        }

        int saveCount = 0;
        for (ExcelUploadGroup group : groupMap.values()) {
            EvalWgtMngVO subjectVo = new EvalWgtMngVO();
            subjectVo.setOrgId(vo.getOrgId());
            subjectVo.setOrgNm(group.orgNm);
            subjectVo.setHaksaYear(group.haksaYear);
            subjectVo.setHaksaTerm(group.haksaTerm);
            subjectVo.setCrclmnNo(group.crclmnNo);
            subjectVo.setSbjctNm(group.sbjctNm);

            List<EgovMap> subjectList = evalWgtMngDAO.listEvalWgtMngExcelSubjectMatch(subjectVo);
            if (subjectList == null || subjectList.isEmpty()) {
                throw new IllegalArgumentException(group.haksaYear + " / " + group.haksaTerm + " / " + group.sbjctNm + " 과목을 찾을 수 없습니다.");
            }

            String baseSbjctId = StringUtil.nvl(String.valueOf(subjectList.get(0).get("sbjctId")));
            if (isBlank(baseSbjctId)) {
                throw new IllegalArgumentException(group.sbjctNm + " 과목 아이디를 확인할 수 없습니다.");
            }

            List<EgovMap> dvclasList = evalWgtMngDAO.listEvalWgtMngDvclasSubject(buildDvclasVo(vo.getOrgId(), baseSbjctId));
            List<String> targetSbjctIds = new ArrayList<String>();
            if (dvclasList != null) {
                for (EgovMap dvclas : dvclasList) {
                    String targetSbjctId = StringUtil.nvl(String.valueOf(dvclas.get("sbjctId")));
                    if (!isBlank(targetSbjctId) && !targetSbjctIds.contains(targetSbjctId)) {
                        targetSbjctIds.add(targetSbjctId);
                    }
                }
            }
            if (targetSbjctIds.isEmpty()) {
                targetSbjctIds.add(baseSbjctId);
            }

            EvalWgtMngVO saveVo = new EvalWgtMngVO();
            saveVo.setOrgId(vo.getOrgId());
            saveVo.setSbjctId(baseSbjctId);
            saveVo.setTargetSbjctIds(targetSbjctIds.toArray(new String[0]));
            saveVo.setRgtrId(vo.getRgtrId());
            saveVo.setMdfrId(vo.getMdfrId());
            saveVo.setMrkItmStngList(buildExcelItemList(itemCodeList, group.itemMap));

            saveEvalWgtMng(saveVo);
            saveCount++;
        }

        return saveCount;
    }

    private Set<String> resolveTargetSbjctIds(EvalWgtMngVO vo) throws Exception {
        Set<String> requested = new LinkedHashSet<String>();
        if (vo.getTargetSbjctIds() != null) {
            for (String targetSbjctId : vo.getTargetSbjctIds()) {
                if (!isBlank(targetSbjctId)) {
                    requested.add(targetSbjctId);
                }
            }
        }
        if (requested.isEmpty()) {
            throw new IllegalArgumentException("분반을 선택해 주세요.");
        }

        Set<String> allowed = new LinkedHashSet<String>();
        List<EgovMap> dvclasList = listEvalWgtMngDvclasSubject(vo);
        for (EgovMap dvclas : dvclasList) {
            Object sbjctId = dvclas.get("sbjctId");
            if (sbjctId != null) {
                allowed.add(String.valueOf(sbjctId));
            }
        }
        if (allowed.isEmpty()) {
            allowed.add(vo.getSbjctId());
        }

        Set<String> targetSbjctIds = new LinkedHashSet<String>();
        for (String requestedSbjctId : requested) {
            if (allowed.contains(requestedSbjctId)) {
                targetSbjctIds.add(requestedSbjctId);
            }
        }
        if (targetSbjctIds.isEmpty()) {
            throw new IllegalArgumentException("분반 정보를 확인할 수 없습니다.");
        }
        return targetSbjctIds;
    }

    private String getCellValue(Map<String, Object> row, String columnKey) {
        Object value = row.get(columnKey);
        return value == null ? "" : StringUtil.nvl(String.valueOf(value)).trim();
    }

    private String fallbackValue(String primary, String fallback) {
        return isBlank(primary) ? StringUtil.nvl(fallback).trim() : primary;
    }

    private String resolveItemCode(Map<String, String> itemCodeMap, String itemInput, int lineNo) {
        String itemKey = StringUtil.nvl(itemInput).trim().toUpperCase();
        String itemCode = itemCodeMap.get(itemKey);
        if (isBlank(itemCode)) {
            throw new IllegalArgumentException(lineNo + "행 평가항목코드를 확인해 주세요.");
        }
        return itemCode;
    }

    private BigDecimal parseRate(String rateInput, int lineNo) {
        String value = StringUtil.nvl(rateInput).trim();
        try {
            BigDecimal rate = new BigDecimal(value);
            if (rate.scale() > 2) {
                throw new NumberFormatException("scale");
            }
            return rate;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(lineNo + "행 평가비중은 0~100 사이 숫자로 입력해 주세요. 소수점은 둘째자리까지 가능합니다.");
        }
    }

    private String parseOpenYn(String openInput, int lineNo) {
        String value = StringUtil.nvl(openInput).trim().toUpperCase();
        if (isBlank(value) || "Y".equals(value) || "공개".equals(value) || "TRUE".equals(value) || "1".equals(value)) {
            return "Y";
        }
        if ("N".equals(value) || "비공개".equals(value) || "FALSE".equals(value) || "0".equals(value)) {
            return "N";
        }
        throw new IllegalArgumentException(lineNo + "행 공개여부는 Y/N 또는 공개/비공개로 입력해 주세요.");
    }

    private List<MarkItemSettingVO> buildExcelItemList(List<EgovMap> itemCodeList, Map<String, MarkItemSettingVO> selectedItemMap) {
        List<MarkItemSettingVO> itemList = new ArrayList<MarkItemSettingVO>();
        for (EgovMap codeInfo : itemCodeList) {
            String itemCode = StringUtil.nvl((String) codeInfo.get("mrkItmTycd")).trim();
            if (isBlank(itemCode)) {
                continue;
            }

            MarkItemSettingVO selectedItem = selectedItemMap.get(itemCode);
            if (selectedItem != null) {
                itemList.add(selectedItem);
                continue;
            }

            MarkItemSettingVO item = new MarkItemSettingVO();
            item.setMrkItmTycd(itemCode);
            item.setMrkRfltrt(BigDecimal.ZERO);
            item.setMrkOyn("Y");
            item.setMrkItmUseyn("N");
            itemList.add(item);
        }
        return itemList;
    }

    private EvalWgtMngVO buildDvclasVo(String orgId, String sbjctId) {
        EvalWgtMngVO vo = new EvalWgtMngVO();
        vo.setOrgId(orgId);
        vo.setSbjctId(sbjctId);
        return vo;
    }

    private boolean isBlank(String value) {
        return StringUtil.nvl(value).trim().length() == 0;
    }

    private static final class ExcelUploadGroup {
        private String orgNm;
        private String haksaYear;
        private String haksaTerm;
        private String crclmnNo;
        private String sbjctNm;
        private final Map<String, MarkItemSettingVO> itemMap = new LinkedHashMap<String, MarkItemSettingVO>();
    }
}
