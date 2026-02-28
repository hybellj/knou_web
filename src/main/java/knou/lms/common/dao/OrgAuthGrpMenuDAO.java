package knou.lms.common.dao;

import org.apache.ibatis.annotations.Param;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.common.vo.OrgAuthGrpMenuVO;

/**
 *  <b>기관 - 기관 권한 그룹 메뉴 관리</b> 영역  DAO 클래스
 * @author Jamfam
 *
 */
@Mapper("orgAuthGrpMenuDAO")
public interface OrgAuthGrpMenuDAO{

    /**
     * 권한 그룹 메뉴의 상세 정보를 등록한다.  
     * @param  OrgAuthGrpMenuVO
     * @return String
     * @throws Exception
     */
    public void merge(OrgAuthGrpMenuVO vo) throws Exception;
    
    /**
     * 권한 그룹 메뉴의 상세 정보를 삭제한다.  
     * @param  OrgAuthGrpMenuVO
     * @return int
     * @throws Exception
     */
    public int delete(OrgAuthGrpMenuVO vo) throws Exception ;
    
    /**
     * 권한 그룹 메뉴를 초기화 등록한다.  
     * @param  OrgAuthGrpMenuVO
     * @return String
     * @throws Exception
     */
    public void insertInit(OrgAuthGrpMenuVO vo) throws Exception;
    
    /**
     * 권한 그룹 메뉴를 초기화 삭제한다.  
     * @param  OrgAuthGrpMenuVO
     * @return int
     * @throws Exception
     */
    public int deleteInit(OrgAuthGrpMenuVO vo) throws Exception;
    
    /**
     * 사용자의 개설과목 MENU_TYPE 및 권한 정보
     * @param orgId
     * @param crsCreCd
     * @param userId
     * @return
     * @throws Exception
     */
    public OrgAuthGrpMenuVO selectCrsCreAuth(@Param("orgId")String orgId, @Param("crsCreCd")String crsCreCd, @Param("userId")String userId) throws Exception;
}
