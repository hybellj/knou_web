package knou.lms.msg.facade;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgSndrDsctnVO;
import knou.lms.org.vo.OrgInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;


public interface MsgSndrDsctnFacadeService {

    ProcessResultVO<MsgSndrDsctnVO> selectSndrDsctnListPage(MsgSndrDsctnVO vo) throws Exception;

    List<OrgInfoVO> selectActiveOrgListByAuth(String userId, boolean isAdmin) throws Exception;

    List<OrgInfoVO> selectProfSbjctOrgList(String userId);

    MsgSndrDsctnVO selectSndrDsctnSmry(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnExcelList(MsgSndrDsctnVO vo);

    Map<String, BigDecimal> selectSndngCostMap();

    List<Map<String, Object>> buildSmryExcelRows(MsgSndrDsctnVO smry, Map<String, String> labels);

    MsgSndrDsctnVO loadListViewInfo(MsgSndrDsctnVO vo) throws Exception;

    EgovMap loadFilterOptions(MsgSndrDsctnVO vo) throws Exception;

}
