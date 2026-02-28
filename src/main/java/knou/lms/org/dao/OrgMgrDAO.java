package knou.lms.org.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.org.vo.OrgInfoVO;

@Mapper("orgMgrDAO")
public interface OrgMgrDAO {

    public List<OrgInfoVO> listPagingOrgInfo(OrgInfoVO vo) throws Exception;

    public List<OrgInfoVO> selectOrgMgrList(OrgInfoVO vo) throws Exception;

    public OrgInfoVO selectOrgMgrInfo(OrgInfoVO vo) throws Exception;

    public void insertOrg(OrgInfoVO vo) throws Exception;

    public void updateOrg(OrgInfoVO vo) throws Exception;

    public int selectUserIdDupChk(OrgInfoVO vo) throws Exception;

    public void deleteUserInfo(OrgInfoVO vo) throws Exception;

    public void deleteUserLogin(OrgInfoVO vo) throws Exception;

    public void deleteUserAuthGrp(OrgInfoVO vo) throws Exception;
    
    public void insertUserInfo(OrgInfoVO vo) throws Exception;

    public void insertUserLogin(OrgInfoVO vo) throws Exception;

    public void insertUserAuthGrp(OrgInfoVO vo) throws Exception;

    public void deleteOrg(OrgInfoVO vo) throws Exception;

    public void deleteDept(OrgInfoVO vo) throws Exception;


}
