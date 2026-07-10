package knou.lms.msg.dao;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper("msgRcptnAuthDAO")
public interface MsgRcptnAuthDAO {

    List<String> selectRcptnPrmNoUserIdList(Map<String, Object> param);

    String selectRcptnPrmYn(Map<String, Object> param);

}
