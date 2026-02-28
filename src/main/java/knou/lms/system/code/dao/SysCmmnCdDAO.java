package knou.lms.system.code.dao;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.system.code.vo.SysCmmnCdVO;

@Mapper("sysCmmnCdDAO")
public interface SysCmmnCdDAO {

    /*****************************************************
     * 상위 코드 관련 메서드
     *****************************************************/

    // 시스템 상위 공통코드 등록
    public void insertSysCmmnUpCd(SysCmmnCdVO vo) throws Exception;

    // 시스템 상위 공통코드 목록 카운트
    public int countSysCmmnUpCd(SysCmmnCdVO vo) throws Exception;

    // 시스템 상위 공통코드 목록 페이징
    public List<SysCmmnCdVO> listSysCmmnUpCdPaging(SysCmmnCdVO vo) throws Exception;

    // 시스템 상위 공통코드 수정    
    public void updateSysCmmnUpCd(SysCmmnCdVO vo) throws Exception;

    // 시스템 상위 공통코드 삭제
    public void deleteSysCmmnUpCd(SysCmmnCdVO vo) throws Exception;

    /*****************************************************
     * 공통 코드 관련 메서드
     *****************************************************/

    // 시스템 공통코드 등록
    public void insertSysCmmnCd(SysCmmnCdVO vo) throws Exception;

    // 시스템 공통코드 목록 조회
    public List<SysCmmnCdVO> listSysCmmnCdPaging(SysCmmnCdVO vo) throws Exception;

    // 시스템 공통코드 목록 카운트
    public int countSysCmmnCd(SysCmmnCdVO vo) throws Exception;

    // 시스템 공통코드 수정
    public void updateSysCmmnCd(SysCmmnCdVO vo) throws Exception;

    // 시스템 공통코드 삭제
    public void deleteSysCmmnCd(SysCmmnCdVO vo) throws Exception;
}