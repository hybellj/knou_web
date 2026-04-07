package knou.lms.log2.user.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.log2.user.vo.LogUserActvVO;

@Mapper("logUserActvDAO")
public interface LogUserActvDAO {

	/*
	 * Object userSbjctOfrngActvHstryList(@Param("sbjctOfrngId") String
	 * sbjctOfrngId,
	 *
	 * @Param("timeRange") int timeRange) throws Exception;
	 */

    /*****************************************************
     * 강의실 활동 로그 조회 현황 목록 페이징 (TB_LMS_LOG_USER_ACTV)
     * @param LogUserActvVO
     * @return List<LogUserActvVO>
     * @throws Exception
     ******************************************************/
    public List<LogUserActvVO> selectLogUserActvList(LogUserActvVO vo) throws Exception;

}
