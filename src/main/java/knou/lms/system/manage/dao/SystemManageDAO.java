package knou.lms.system.manage.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.system.manage.vo.SysErrVO;
import knou.lms.system.manage.vo.SysMgrErrVO;

@Mapper("systemManageDAO")
public interface SystemManageDAO {
    
    public int admExceptionCnt(PageInfo pageInfo);

    public List<EgovMap> admExceptionListPaging( PageInfo pageInfo);
    
    public SysErrVO admExceptionDtl(SysErrVO vo);

    public List<SysMgrErrVO> exceptionList(SysMgrErrVO vo);
    
}