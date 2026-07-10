package knou.lms.crs.sbjct.excel;

import knou.framework.context2.UserContext;
import knou.framework.util.ExcelUtilPoi;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.crs.sbjct.facade.SbjctCodeHelper;
import knou.lms.crs.sbjct.service.SbjctTmpltService;
import knou.lms.crs.sbjct.facade.SbjctAuthHelper;
import knou.lms.crs.sbjct.vo.SbjctTmpltVO;
import knou.lms.crs.sbjct.web.paging.SbjctTmpltPageInfo;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 과목 템플릿 엑셀 다운로드 모델을 생성한다.
 */
@Component("sbjctTmpltExcelHandler")
public class SbjctTmpltExcelHandler {

    @Resource(name="sbjctAuthHelper")
    private SbjctAuthHelper sbjctAuthHelper;

    @Resource(name="sbjctTmpltService")
    private SbjctTmpltService sbjctTmpltService;

    @Resource(name="sbjctCodeHelper")
    private SbjctCodeHelper sbjctCodeHelper;

    /**
     * 현재 검색 조건으로 과목 템플릿 목록 엑셀 모델을 생성한다.
     */
    public Map<String, Object> listExcel(SbjctTmpltPageInfo pageInfo, UserContext userCtx, String title) {
        pageInfo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(pageInfo.getOrgId(), userCtx));
        pageInfo.setLangCd(userCtx.getLangCd());

        HashMap<String, Object> excelMap = new HashMap<>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", pageInfo.getExcelGrid());
        excelMap.put("list", sbjctTmpltService.selectSbjctTmpltListExcelDown(pageInfo));

        return toExcelModel(title, excelMap);
    }

    /**
     * 과목 템플릿 엑셀 업로드 샘플에 표시할 안내 행과 워크북 모델을 생성한다.
     */
    public Map<String, Object> sampleExcel(
            SbjctTmpltVO vo,
            UserContext userCtx,
            String title,
            String useGuide) throws Exception {

        vo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(vo.getOrgId(), userCtx));

        HashMap<String, Object> guideRow = new HashMap<>();
        guideRow.put("lctrGbncd", formatCodeGuide(vo.getOrgId(), "LCTR_GBNCD"));
        guideRow.put("sbjctCd", "");
        guideRow.put("sbjctnm", "");
        guideRow.put("useyn", useGuide);
        guideRow.put("sbjctExpln", "");

        List<Map<String, Object>> guideList = new ArrayList<>();
        guideList.add(guideRow);

        HashMap<String, Object> excelMap = new HashMap<>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", vo.getExcelGrid());
        excelMap.put("list", guideList);

        return toExcelModel(title, excelMap);
    }

    /**
     * 샘플 엑셀 안내행에 표시할 공통코드 입력값 목록을 코드명:코드 형식으로 생성한다.
     */
    private String formatCodeGuide(String orgId, String upCd) throws Exception {
        List<CmmnCdVO> codeList = sbjctCodeHelper.listCodeWithoutDefault(orgId, upCd);
        List<String> guideList = new ArrayList<>();
        if(codeList != null) {
            for(CmmnCdVO code : codeList) {
                if(code.getCdnm() != null && code.getCd() != null) {
                    guideList.add(code.getCdnm() + ":" + code.getCd());
                }
            }
        }
        return String.join(", ", guideList);
    }

    /**
     * 엑셀 워크북과 다운로드 파일명을 컨트롤러 모델 속성으로 감싼다.
     */
    private Map<String, Object> toExcelModel(String title, HashMap<String, Object> excelMap) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("outFileName", title + "_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")));
        resultMap.put("workbook", new ExcelUtilPoi().simpleGrid(excelMap));
        return resultMap;
    }
}
