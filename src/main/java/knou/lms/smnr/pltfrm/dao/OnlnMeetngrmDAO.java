package knou.lms.smnr.pltfrm.dao;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.smnr.pltfrm.vo.OnlnMeetngrmVO;

@Mapper("onlnMeetngrmDAO")
public interface OnlnMeetngrmDAO {

	/**
	 * 온라인회의실등록
	 *
	 * @param OnlnMeetngrmVO
	 * @throws Exception
	 */
	public void onlnMeetngrmRegist(OnlnMeetngrmVO vo) throws Exception;

	/**
	 * 온라인회의실수정
	 *
	 * @param OnlnMeetngrmVO
	 * @throws Exception
	 */
	public void onlnMeetngrmModify(OnlnMeetngrmVO vo) throws Exception;

	/**
	 * 온라인회의실삭제
	 *
	 * @param smnrId		세미나아이디
	 * @param meetngrmId	회의실아이디
	 * @throws Exception
	 */
	public void onlnMeetngrmDelete(@Param("smnrId") String smnrId, @Param("meetngrmId") String meetngrmId) throws Exception;

}
