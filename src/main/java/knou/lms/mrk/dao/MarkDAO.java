package knou.lms.mrk.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.mrk.vo.MarkItemSettingVO;

@Mapper("markDAO")

public interface MarkDAO {

	List<EgovMap> markActivityEvalRateSelect(MarkItemSettingVO vo);

}