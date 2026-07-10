package knou.lms.crs.opHstry.service.impl;

import knou.lms.common.dto.ResultDTO;
import knou.lms.crs.opHstry.dao.SbjctEvlRfltrtStatusDAO;
import knou.lms.crs.opHstry.service.SbjctEvlRfltrtStatusService;
import knou.lms.crs.opHstry.vo.SbjctEvlRfltrtStatusVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("sbjctEvlRfltrtStatusService")
public class SbjctEvlRfltrtStatusServiceImpl implements SbjctEvlRfltrtStatusService {

    @Resource(name = "sbjctEvlRfltrtStatusDAO")
    private SbjctEvlRfltrtStatusDAO sbjctEvlRfltrtStatusDAO;

    /**
     * 과목별 평가비중 시행현황 목록을 조회한다.
     * 평가항목 필터는 화면에서 배열 또는 콤마 문자열로 들어올 수 있어 서비스 진입 시 한 번 정규화한다.
     */
    @Override
    public ResultDTO<EgovMap> sbjctEvlRfltrtStatusList(SbjctEvlRfltrtStatusVO vo) throws Exception {
        vo.normalizeItemTypeParams();

        return new ResultDTO<EgovMap>().setReturnList(sbjctEvlRfltrtStatusDAO.listSbjctEvlRfltrtStatus(vo));
    }

    /**
     * 과목별 평가비중 시행현황 엑셀 다운로드 목록을 조회한다.
     * 화면과 동일한 검색 조건을 사용하고, 엑셀 컬럼에서 바로 사용할 표시값을 추가한다.
     */
    @Override
    public List<EgovMap> sbjctEvlRfltrtStatusExcelList(SbjctEvlRfltrtStatusVO vo) throws Exception {
        vo.normalizeItemTypeParams();

        List<EgovMap> list = sbjctEvlRfltrtStatusDAO.listSbjctEvlRfltrtStatus(vo);
        for (int i = 0; i < list.size(); i++) {
            EgovMap item = list.get(i);
            item.put("no", list.size() - i);
            item.put("asmt", getEvlRfltrtStatusText(item, "asmt"));
            item.put("dscs", getEvlRfltrtStatusText(item, "dscs"));
            item.put("quiz", getEvlRfltrtStatusText(item, "quiz"));
            item.put("srvy", getEvlRfltrtStatusText(item, "srvy"));
            item.put("smnr", getEvlRfltrtStatusText(item, "smnr"));
            item.put("exam", getEvlRfltrtStatusText(item, "exam"));
        }
        return list;
    }

    /**
     * 평가항목별 개설상태와 평가비중을 엑셀 표시 문자열로 변환한다.
     */
    private String getEvlRfltrtStatusText(EgovMap item, String prefix) {
        String statusCd = toStringValue(item.get(prefix + "StatusCd"));
        String openCnt = toStringValue(item.get(prefix + "OpenCnt"));
        String rfltrt = toStringValue(item.get(prefix + "Rfltrt"));

        if (statusCd.isEmpty() && rfltrt.isEmpty()) {
            return "-";
        }

        String statusText = getStatusName(statusCd);
        if (!"MISS".equals(statusCd) && !openCnt.isEmpty()) {
            statusText += "(" + openCnt + ")";
        }

        return statusText + "\n" + (rfltrt.isEmpty() ? "-" : rfltrt + "%");
    }

    /**
     * 개설상태 코드를 화면 표시명으로 변환한다.
     */
    private String getStatusName(String statusCd) {
        if ("MISS".equals(statusCd)) {
            return "미개설";
        }
        if ("WRONG".equals(statusCd)) {
            return "오개설";
        }
        if ("OPEN".equals(statusCd)) {
            return "개설";
        }
        return "-";
    }

    /**
     * EgovMap 조회값을 null 안전 문자열로 변환한다.
     */
    private String toStringValue(Object value) {
        return value == null ? "" : String.valueOf(value);
    }
}
