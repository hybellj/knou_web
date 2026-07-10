package knou.lms.system.manage.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.common.dto.ResultDTO;
import knou.lms.system.manage.vo.AdmCntnPermitIpVO;
import knou.lms.system.manage.vo.CommonCodeVO;

public interface CommonCodeService {

    public int admUpCmmnCdRegist(CommonCodeVO vo);
    public int admUpCmmnCdModify(CommonCodeVO vo);
    public int admUpCmmnCdDelete(CommonCodeVO vo);    

    //	관리자상위공통코드목록조회페이징
    public ResultDTO<EgovMap> admUpCmmnCdListPaging(PageInfo page);
    
    public ResultDTO<EgovMap> childCdList(String	upCd);

    public int admCmmnCdRegist(CommonCodeVO vo);
    public int admCmmnCdModify(CommonCodeVO vo);
    public int admCmmnCdDelete(CommonCodeVO vo);

    //	관리자공통코드목록조회페이징
    public ResultDTO<EgovMap> admCmmnCdListPaging(PageInfo page);

    //	관리자공통코드목록조회
    public List<EgovMap> admCmmnCdList(PageInfo pageInfo); 
    
    //	관리자공통코드목록조회
    public List<EgovMap> admCmmnCdListASIS(CommonCodeVO vo); 
    
    

    //	시스템공통코드전체목록조회
    public List<CommonCodeVO> selectSysCmmnCdAll();

    //	관리자접속허용아이피목록조회페이징
	public ResultDTO<EgovMap> admCntnPermitIpListPaging(PageInfo pageInfo);
}