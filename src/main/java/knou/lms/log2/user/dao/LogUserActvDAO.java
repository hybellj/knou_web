package knou.lms.log2.user.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.framework.common.PageInfo;
import knou.lms.log2.user.vo.UserActvHstryVO;
import knou.lms.log2.user.vo.LectCntnInfoVO;
import knou.lms.log2.user.vo.LogTutActvVO;
import knou.lms.log2.user.vo.LogUserActvVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

@Mapper("logUserActvDAO")
public interface LogUserActvDAO {
	
    public List<LectCntnInfoVO> selectProfSbjctStngCntnInfoList(LectCntnInfoVO vo) throws Exception;

    public List<EgovMap> userCntnStsList(LogUserActvVO vo);

    public List<EgovMap> userCntnCntByOrgId(LogUserActvVO vo);

	public void userActvLogInsert(LogUserActvVO userActv) throws Exception;

	public void tutorActvLogInsert(LogTutActvVO tutorActv) throws Exception;

	public int admCntnLogListCnt(PageInfo pageInfo);

	public List<EgovMap> admCntnLogListPaging(PageInfo pageInfo);

	public int countUserActvHstry(UserActvHstryVO vo);

	public List<EgovMap> listUserActvHstryPaging(UserActvHstryVO vo);

	public List<EgovMap> listUserActvHstry(UserActvHstryVO vo);

	public List<EgovMap> listUserActvHstrySbjct(UserActvHstryVO vo);
}
