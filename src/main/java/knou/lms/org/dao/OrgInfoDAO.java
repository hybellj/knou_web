package knou.lms.org.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.org.vo.OrgInfoVO;

@Mapper("orgInfoDAO")
public interface OrgInfoDAO {
    
    /*****************************************************
     * 소속(테넌시)관리 정보
     * @param vo
     * @return OrgInfoVO
     * @throws Exception
     ******************************************************/
    public OrgInfoVO select(OrgInfoVO vo);

    /*****************************************************
     * 소속(테넌시)관리 목록 수
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int count(OrgInfoVO vo) throws Exception;
    
    /*****************************************************
     * 소속(테넌시)관리 목록
     * @param vo
     * @return List<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    public List<OrgInfoVO> list(OrgInfoVO vo);
    
    /*****************************************************
     * 소속(테넌시)관리 페이징 목록
     * @param vo
     * @return List<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listPaging(OrgInfoVO vo);

    /*****************************************************
     * 소속(테넌시)관리 등록
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void insert(OrgInfoVO vo) throws Exception;

    /*****************************************************
     * 소속(테넌시)관리 수정
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void update(OrgInfoVO vo) throws Exception;
    
    /*****************************************************
     * 소속(테넌시)관리 사용안함
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void updateUseN(OrgInfoVO vo) throws Exception;
    
    /*****************************************************
     * 소속(테넌시)관리 전체운영자 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listOrgAdmUser(OrgInfoVO vo) ;
    
    /*****************************************************
     * 운영 기관 전체 조회
     * @return List<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    public List<OrgInfoVO> listActiveOrg();

    /*****************************************************
     * 사용자에 연결된 운영 기관 조회
     * @param userId
     * @return List<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    public List<OrgInfoVO> listActiveOrgByUser(String userId) throws Exception;

}