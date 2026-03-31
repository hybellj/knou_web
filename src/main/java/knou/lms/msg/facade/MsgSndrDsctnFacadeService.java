package knou.lms.msg.facade;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgSndrDsctnVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface MsgSndrDsctnFacadeService {

    ProcessResultVO<MsgSndrDsctnVO> selectSndrDsctnListPage(MsgSndrDsctnVO vo) throws Exception;

    MsgSndrDsctnVO selectSndrDsctnSmry(MsgSndrDsctnVO vo) throws Exception;

    List<MsgSndrDsctnVO> selectSndrDsctnExcelList(MsgSndrDsctnVO vo) throws Exception;

    List<MsgSndrDsctnVO> selectSndrDsctnYrList(MsgSndrDsctnVO vo) throws Exception;

    List<EgovMap> selectSndrDsctnSmstrList(MsgSndrDsctnVO vo) throws Exception;

    List<MsgSndrDsctnVO> selectSndrDsctnDeptList(MsgSndrDsctnVO vo) throws Exception;

    List<MsgSndrDsctnVO> selectSndrDsctnSbjctList(MsgSndrDsctnVO vo) throws Exception;

    Map<String, BigDecimal> selectSndngCostMap() throws Exception;

    Map<String, Long> calculateSmryCost(MsgSndrDsctnVO smry) throws Exception;

    List<Map<String, Object>> buildSmryExcelRows(MsgSndrDsctnVO smry, Map<String, String> labels) throws Exception;

    String selectOrgNm(String orgId) throws Exception;
}
