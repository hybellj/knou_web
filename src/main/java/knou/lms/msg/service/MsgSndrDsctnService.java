package knou.lms.msg.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgSndrDsctnVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface MsgSndrDsctnService {

    ProcessResultVO<MsgSndrDsctnVO> selectSndrDsctnListPage(MsgSndrDsctnVO vo) throws Exception;

    List<MsgSndrDsctnVO> selectSndrDsctnExcelList(MsgSndrDsctnVO vo);

    MsgSndrDsctnVO selectSndrDsctnSmry(MsgSndrDsctnVO vo);

}
