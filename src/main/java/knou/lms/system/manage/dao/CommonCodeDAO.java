package knou.lms.system.manage.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.system.manage.vo.CommonCodeVO;

@Mapper("commonCodeDAO")
public interface CommonCodeDAO {

    public int admUpCmmnCdRegist(CommonCodeVO vo);
    public int admUpCmmnCdModify(CommonCodeVO vo);
    public int admUpCmmnCdDelete(CommonCodeVO vo);    
    
    public int admUpCmmnCdCnt(PageInfo pageInfo);
    public List<EgovMap> admUpCmmnCdListPaging(PageInfo pageInfo);

    public int admCmmnCdRegist(CommonCodeVO vo);
    public int admCmmnCdModify(CommonCodeVO vo);
    public int admCmmnCdDelete(CommonCodeVO vo);

    public List<EgovMap> admCmmnCdListPaging(PageInfo pageInfo);
    public List<EgovMap> admCmmnCdList(PageInfo pageInfo);
    
    public List<EgovMap> admCmmnCdListASIS(CommonCodeVO vo);
    
    public int admCmmnCdCnt(PageInfo pageInfo);
    
    public int admCmmnCdCntChild(CommonCodeVO vo);
    
    public List<CommonCodeVO> selectSysCmmnCdAll();
    
	public List<EgovMap> admCntnPermitIpListPaging(PageInfo pageInfo);
	public int	admCntnPermitIpCnt(PageInfo pageInfo);
	
	//공통코드조회
	public List<EgovMap> childCdList(String upCd);
}