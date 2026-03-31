package knou.lms.msg.facade;

import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.MsgSndngCostService;
import knou.lms.msg.service.MsgSndrDsctnService;
import knou.lms.msg.vo.MsgSndngCostVO;
import knou.lms.msg.vo.MsgSndrDsctnVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("msgSndrDsctnFacadeService")
public class MsgSndrDsctnFacadeServiceImpl extends ServiceBase implements MsgSndrDsctnFacadeService {

    @Resource(name = "msgSndrDsctnService")
    private MsgSndrDsctnService msgSndrDsctnService;

    @Resource(name = "msgSndngCostService")
    private MsgSndngCostService msgSndngCostService;

    /*****************************************************
     * 발송내역 목록 조회 (페이징)
     * @param vo
     * @return ProcessResultVO<MsgSndrDsctnVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgSndrDsctnVO> selectSndrDsctnListPage(MsgSndrDsctnVO vo) throws Exception {
        return msgSndrDsctnService.selectSndrDsctnListPage(vo);
    }

    /*****************************************************
     * 발송내역 채널별 요약 조회
     * @param vo
     * @return MsgSndrDsctnVO
     ******************************************************/
    @Override
    public MsgSndrDsctnVO selectSndrDsctnSmry(MsgSndrDsctnVO vo) throws Exception {
        return msgSndrDsctnService.selectSndrDsctnSmry(vo);
    }

    /*****************************************************
     * 발송내역 엑셀 목록 조회
     * @param vo
     * @return List<MsgSndrDsctnVO>
     ******************************************************/
    @Override
    public List<MsgSndrDsctnVO> selectSndrDsctnExcelList(MsgSndrDsctnVO vo) throws Exception {
        return msgSndrDsctnService.selectSndrDsctnExcelList(vo);
    }

    /*****************************************************
     * 학사년도 목록 조회
     * @param vo
     * @return List<MsgSndrDsctnVO>
     ******************************************************/
    @Override
    public List<MsgSndrDsctnVO> selectSndrDsctnYrList(MsgSndrDsctnVO vo) throws Exception {
        return msgSndrDsctnService.selectSndrDsctnYrList(vo);
    }

    /*****************************************************
     * 학기 목록 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    @Override
    public List<EgovMap> selectSndrDsctnSmstrList(MsgSndrDsctnVO vo) throws Exception {
        return msgSndrDsctnService.selectSndrDsctnSmstrList(vo);
    }

    /*****************************************************
     * 학과 목록 조회
     * @param vo
     * @return List<MsgSndrDsctnVO>
     ******************************************************/
    @Override
    public List<MsgSndrDsctnVO> selectSndrDsctnDeptList(MsgSndrDsctnVO vo) throws Exception {
        return msgSndrDsctnService.selectSndrDsctnDeptList(vo);
    }

    /*****************************************************
     * 운영과목 목록 조회
     * @param vo
     * @return List<MsgSndrDsctnVO>
     ******************************************************/
    @Override
    public List<MsgSndrDsctnVO> selectSndrDsctnSbjctList(MsgSndrDsctnVO vo) throws Exception {
        return msgSndrDsctnService.selectSndrDsctnSbjctList(vo);
    }

    /*****************************************************
     * 발송단가 Map 조회 (유형코드 → 단가)
     * @return Map<String, BigDecimal>
     ******************************************************/
    @Override
    public Map<String, BigDecimal> selectSndngCostMap() throws Exception {
        List<MsgSndngCostVO> list = msgSndngCostService.selectSndngCostList();
        Map<String, BigDecimal> costMap = new HashMap<>();
        for (MsgSndngCostVO c : list) {
            costMap.put(c.getMsgTycd(), c.getSndngCost() != null ? c.getSndngCost() : BigDecimal.ZERO);
        }
        return costMap;
    }

    /*****************************************************
     * 발송비용 계산 (성공 건수 × 단가)
     * @param smry
     * @return Map<String, Long> 채널별 비용 + totalCost
     ******************************************************/
    @Override
    public Map<String, Long> calculateSmryCost(MsgSndrDsctnVO smry) throws Exception {
        Map<String, BigDecimal> costMap = selectSndngCostMap();
        Map<String, Long> result = new HashMap<>();

        result.put("push",     BigDecimal.valueOf(smry.getPushSuccCnt()).multiply(costMap.getOrDefault("PUSH", BigDecimal.ZERO)).setScale(0, java.math.RoundingMode.HALF_UP).longValue());
        result.put("shrtnt",   BigDecimal.valueOf(smry.getShrtntSuccCnt()).multiply(costMap.getOrDefault("SHRTNT", BigDecimal.ZERO)).setScale(0, java.math.RoundingMode.HALF_UP).longValue());
        result.put("eml",      BigDecimal.valueOf(smry.getEmlSuccCnt()).multiply(costMap.getOrDefault("EML", BigDecimal.ZERO)).setScale(0, java.math.RoundingMode.HALF_UP).longValue());
        result.put("alimTalk", BigDecimal.valueOf(smry.getAlimtalkSuccCnt()).multiply(costMap.getOrDefault("ALIM_TALK", BigDecimal.ZERO)).setScale(0, java.math.RoundingMode.HALF_UP).longValue());
        result.put("sms",      BigDecimal.valueOf(smry.getSmsSuccCnt()).multiply(costMap.getOrDefault("SMS", BigDecimal.ZERO)).setScale(0, java.math.RoundingMode.HALF_UP).longValue());
        result.put("lms",      BigDecimal.valueOf(smry.getLmsSuccCnt()).multiply(costMap.getOrDefault("LMS", BigDecimal.ZERO)).setScale(0, java.math.RoundingMode.HALF_UP).longValue());
        result.put("mms",      BigDecimal.valueOf(smry.getMmsSuccCnt()).multiply(costMap.getOrDefault("MMS", BigDecimal.ZERO)).setScale(0, java.math.RoundingMode.HALF_UP).longValue());

        long totalCost = result.values().stream().mapToLong(Long::longValue).sum();
        result.put("totalCost", totalCost);

        return result;
    }

    /*****************************************************
     * 발송비용금액 엑셀 행 데이터 생성
     * @param smry
     * @param labels 메시지 라벨 (totalSndCnt, totalSuccCnt, totalFailCnt, sndCost, totalSndCost)
     * @return List<Map<String, Object>>
     ******************************************************/
    @Override
    public List<Map<String, Object>> buildSmryExcelRows(MsgSndrDsctnVO smry, Map<String, String> labels) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();

        Map<String, Object> row1 = new HashMap<>();
        row1.put("sndngGbn", labels.get("totalSndCnt"));
        row1.put("push", String.valueOf(smry.getPushTotalCnt()));
        row1.put("shrtnt", String.valueOf(smry.getShrtntTotalCnt()));
        row1.put("eml", String.valueOf(smry.getEmlTotalCnt()));
        row1.put("alimTalk", String.valueOf(smry.getAlimtalkTotalCnt()));
        row1.put("sms", String.valueOf(smry.getSmsTotalCnt()));
        row1.put("lms", String.valueOf(smry.getLmsTotalCnt()));
        row1.put("mms", String.valueOf(smry.getMmsTotalCnt()));
        list.add(row1);

        Map<String, Object> row2 = new HashMap<>();
        row2.put("sndngGbn", labels.get("totalSuccCnt"));
        row2.put("push", String.valueOf(smry.getPushSuccCnt()));
        row2.put("shrtnt", String.valueOf(smry.getShrtntSuccCnt()));
        row2.put("eml", String.valueOf(smry.getEmlSuccCnt()));
        row2.put("alimTalk", String.valueOf(smry.getAlimtalkSuccCnt()));
        row2.put("sms", String.valueOf(smry.getSmsSuccCnt()));
        row2.put("lms", String.valueOf(smry.getLmsSuccCnt()));
        row2.put("mms", String.valueOf(smry.getMmsSuccCnt()));
        list.add(row2);

        Map<String, Object> row3 = new HashMap<>();
        row3.put("sndngGbn", labels.get("totalFailCnt"));
        row3.put("push", String.valueOf(smry.getPushFailCnt()));
        row3.put("shrtnt", String.valueOf(smry.getShrtntFailCnt()));
        row3.put("eml", String.valueOf(smry.getEmlFailCnt()));
        row3.put("alimTalk", String.valueOf(smry.getAlimtalkFailCnt()));
        row3.put("sms", String.valueOf(smry.getSmsFailCnt()));
        row3.put("lms", String.valueOf(smry.getLmsFailCnt()));
        row3.put("mms", String.valueOf(smry.getMmsFailCnt()));
        list.add(row3);

        Map<String, Long> costData = calculateSmryCost(smry);

        Map<String, Object> row4 = new HashMap<>();
        row4.put("sndngGbn", labels.get("sndCost"));
        row4.put("push", String.valueOf(costData.getOrDefault("push", 0L)));
        row4.put("shrtnt", String.valueOf(costData.getOrDefault("shrtnt", 0L)));
        row4.put("eml", String.valueOf(costData.getOrDefault("eml", 0L)));
        row4.put("alimTalk", String.valueOf(costData.getOrDefault("alimTalk", 0L)));
        row4.put("sms", String.valueOf(costData.getOrDefault("sms", 0L)));
        row4.put("lms", String.valueOf(costData.getOrDefault("lms", 0L)));
        row4.put("mms", String.valueOf(costData.getOrDefault("mms", 0L)));
        list.add(row4);

        return list;
    }

    @Override
    public String selectOrgNm(String orgId) throws Exception {
        return msgSndrDsctnService.selectOrgNm(orgId);
    }

}
