package knou.lms.crs.sbjct.excel;

import knou.framework.context2.UserContext;
import knou.framework.util.ExcelUtilPoi;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.crs.sbjct.facade.SbjctAuthHelper;
import knou.lms.crs.sbjct.vo.SbjctAtndlcVO;
import knou.lms.crs.sbjct.web.paging.SbjctOfringPageInfo;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 일반 과목개설 엑셀 다운로드 모델을 생성한다.
 */
@Component("sbjctOfringExcelHandler")
public class SbjctOfringExcelHandler {

    @Resource(name="sbjctAuthHelper")
    private SbjctAuthHelper sbjctAuthHelper;

    @Resource(name="sbjctService")
    private SbjctService sbjctService;

    /**
     * 현재 검색 조건으로 일반 과목개설 목록 엑셀 모델을 생성한다.
     */
    public Map<String, Object> listExcel(SbjctOfringPageInfo pageInfo, UserContext userCtx, String title) {
        pageInfo.setOrgId(sbjctAuthHelper.resolveSearchOrgId(pageInfo.getOrgId(), userCtx));
        pageInfo.setLangCd(userCtx.getLangCd());

        HashMap<String, Object> excelMap = new HashMap<>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", pageInfo.getExcelGrid());
        excelMap.put("list", sbjctService.selectSbjctOfringListExcelDown(pageInfo));

        return toExcelModel(title, excelMap);
    }

    /**
     * 선택한 과목개설의 수강생 목록 엑셀 모델을 생성한다.
     */
    public Map<String, Object> stdntListExcel(SbjctAtndlcVO vo, UserContext userCtx, String title) {
        vo.setLangCd(userCtx.getLangCd());

        HashMap<String, Object> excelMap = new HashMap<>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", vo.getExcelGrid());
        excelMap.put("list", sbjctService.admSbjctOfringStdntList(vo));

        return toExcelModel(title, excelMap);
    }

    /**
     * 수강생 엑셀 업로드 샘플에 표시할 학번 안내 행과 워크북 모델을 생성한다.
     */
    public Map<String, Object> stdntExcelSample(SbjctAtndlcVO vo, String title, String stdntNoGuide) {
        HashMap<String, Object> guideRow = new HashMap<>();
        guideRow.put("stdntNo", stdntNoGuide);

        List<HashMap<String, Object>> guideList = new ArrayList<>();
        guideList.add(guideRow);

        HashMap<String, Object> excelMap = new HashMap<>();
        excelMap.put("title", title);
        excelMap.put("sheetName", title);
        excelMap.put("excelGrid", vo.getExcelGrid());
        excelMap.put("list", guideList);

        return toExcelModel(title, excelMap);
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
