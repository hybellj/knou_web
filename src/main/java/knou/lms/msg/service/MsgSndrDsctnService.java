package knou.lms.msg.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgSndrDsctnVO;

public interface MsgSndrDsctnService {

    ProcessResultVO<MsgSndrDsctnVO> selectSndrDsctnListPage(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnExcelList(MsgSndrDsctnVO vo);

    MsgSndrDsctnVO selectSndrDsctnSummary(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnYrList(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnSmstrList(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnDeptList(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnSbjctList(MsgSndrDsctnVO vo);
}
