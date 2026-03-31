package knou.lms.msg.dao;

import knou.lms.msg.vo.MsgSndrDsctnVO;
import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("msgSndrDsctnDAO")
public interface MsgSndrDsctnDAO {

    int selectSndrDsctnCnt(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnList(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnExcelList(MsgSndrDsctnVO vo);

    MsgSndrDsctnVO selectSndrDsctnSmry(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnYrList(MsgSndrDsctnVO vo);

    List<EgovMap> selectSndrDsctnSmstrList(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnDeptList(MsgSndrDsctnVO vo);

    List<MsgSndrDsctnVO> selectSndrDsctnSbjctList(MsgSndrDsctnVO vo);

    String selectOrgNm(@Param("orgId") String orgId);
}
