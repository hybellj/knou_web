package knou.lms.log2.user.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.log2.user.vo.LectCntnInfoVO;

@Mapper("logUserActvDAO")
public interface LogUserActvDAO {

	/*
	 * Object userSbjctOfrngActvHstryList(@Param("sbjctOfrngId") String
	 * sbjctOfrngId,
	 *
	 * @Param("timeRange") int timeRange) throws Exception;
	 */

    public List<LectCntnInfoVO> selectProfSbjctStngCntnInfoList(LectCntnInfoVO vo) throws Exception;

}
