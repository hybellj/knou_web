package knou.lms.contents.excel;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Component;

import knou.framework.context2.UserContext;
import knou.framework.util.ExcelUtilPoi;
import knou.lms.contents.facade.ContsAuthHelper;
import knou.lms.contents.service.ContsService;
import knou.lms.contents.vo.ContsSbjctListVO;
import knou.lms.contents.web.paging.ContsPageInfo;

/**
 * 관리자 콘텐츠 관리 엑셀 다운로드 모델을 생성한다.
 */
@Component("admContsExcelHandler")
public class AdmContsExcelHandler {

    @Resource(name = "contsAuthHelper")
    private ContsAuthHelper contsAuthHelper;

    @Resource(name = "contsService")
    private ContsService contsService;

    @Resource(name = "messageSource")
    private MessageSource messageSource;

    /**
     * 현재 검색 조건으로 과목 목록 엑셀 모델을 생성한다.
     * @param pageInfo
     * @param userCtx
     * @return
     */
    public Map<String, Object> listExcel(ContsPageInfo pageInfo, UserContext userCtx) {
        pageInfo.setOrgId(contsAuthHelper.resolveSearchOrgId(pageInfo.getOrgId(), userCtx));
        pageInfo.setLangCd(userCtx.getLangCd());

        String title = createSbjctListExcelTitle();
        List<ContsSbjctListVO> list = contsService.selectAdmLctrContsSbjctListExcelDown(pageInfo);
        applySbjctDisplayUnits(list);

        HashMap<String, Object> excelMap = new HashMap<String, Object>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", pageInfo.getExcelGrid());
        excelMap.put("list", list);

        return toExcelModel(title, excelMap);
    }

    /**
     * 과목 목록의 학사년도와 학기/기수 값에 단위 문구를 붙인다.
     * @param list
     */
    private void applySbjctDisplayUnits(List<ContsSbjctListVO> list) {
        if(list == null || list.isEmpty()) {
            return;
        }

        String yearUnit = getMessage("date.year");/*년*/
        String smstrUnit = getMessage("contents.label.semester.unit");/*학기*/
        String cohortUnit = getMessage("contents.label.cohort.unit");/*기수*/
        for(ContsSbjctListVO vo : list) {
            if(vo == null) {
                continue;
            }
            if(vo.getSbjctYr() != null && !vo.getSbjctYr().isEmpty()) {
                vo.setSbjctYr(vo.getSbjctYr() + yearUnit);
            }
            if(vo.getSbjctSmstr() != null && !vo.getSbjctSmstr().isEmpty()) {
                String unit = vo.getSmstrChrtGbncd() == null || "SMSTR".equals(vo.getSmstrChrtGbncd()) ? smstrUnit : cohortUnit;
                vo.setSbjctSmstr(vo.getSbjctSmstr() + unit);
            }
        }
    }

    /**
     * 엑셀 파일명에 사용할 업무 단어를 메시지에서 조회해 구분자로 조합한다.
     * @return
     */
    private String createSbjctListExcelTitle() {
        return getMessage("contents.excel.file.contents")/*콘텐츠*/
                + "_" + getMessage("contents.excel.file.learning.toc")/*학습목차*/
                + "_" + getMessage("contents.excel.file.subject.list");/*과목목록*/
    }

    /**
     * 현재 Locale에 맞는 메시지 문구를 조회한다.
     * @param messageKey
     * @return
     */
    private String getMessage(String messageKey) {
        return messageSource.getMessage(messageKey, null, messageKey, LocaleContextHolder.getLocale());
    }

    /**
     * 엑셀 워크북과 다운로드 파일명을 컨트롤러 모델 속성으로 감싼다.
     * @param title
     * @param excelMap
     * @return
     */
    private Map<String, Object> toExcelModel(String title, HashMap<String, Object> excelMap) {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("outFileName", title + "_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")));
        resultMap.put("workbook", new ExcelUtilPoi().simpleGrid(excelMap));
        return resultMap;
    }
}
