package knou.lms.log2.user.dao;

import knou.lms.log2.user.vo.LogLrnActvInqHstryVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper("logLrnActvDAO")
public interface LogLrnActvDAO {

    int mergeLrnActvInqHstry(LogLrnActvInqHstryVO vo);
}
