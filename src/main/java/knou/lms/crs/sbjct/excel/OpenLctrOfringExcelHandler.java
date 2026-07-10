package knou.lms.crs.sbjct.excel;

import knou.framework.context2.UserContext;
import knou.framework.util.ExcelUtilPoi;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.crs.sbjct.facade.SbjctAuthHelper;
import knou.lms.crs.sbjct.web.paging.SbjctOfringPageInfo;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

/**
 * 공개강좌개설 엑셀 다운로드 모델을 생성한다.
 */
@Component("openLctrOfringExcelHandler")
public class OpenLctrOfringExcelHandler {

    private static final String OPEN_LCTR_SYSTEM_SBJCT_TYCD = "OPEN_LCTR_SYSTEM";   // 공개강좌
    private static final String OPEN_CRS_GBNCD = "OPEN_CRS"; // 공개과정

    @Resource(name="sbjctAuthHelper")
    private SbjctAuthHelper sbjctAuthHelper;

    @Resource(name="sbjctService")
    private SbjctService sbjctService;

    /**
     * 현재 검색 조건에 공개강좌 전용 코드를 적용해 공개강좌개설 목록 엑셀 모델을 생성한다.
     */
    public Map<String, Object> listExcel(SbjctOfringPageInfo pageInfo, UserContext userCtx, String title) {
        pageInfo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(pageInfo.getOrgId(), userCtx));
        pageInfo.setLangCd(userCtx.getLangCd());
        pageInfo.setCrsGbncd(OPEN_CRS_GBNCD);
        pageInfo.setSbjctTycd(OPEN_LCTR_SYSTEM_SBJCT_TYCD);

        HashMap<String, Object> excelMap = new HashMap<>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", pageInfo.getExcelGrid());
        excelMap.put("list", sbjctService.selectOpenLctrOfringListExcelDown(pageInfo));

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("outFileName", title + "_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")));
        resultMap.put("workbook", new ExcelUtilPoi().simpleGrid(excelMap));
        return resultMap;
    }
}
