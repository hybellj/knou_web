package knou.lms.system.code.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.system.code.vo.SysCmmnCdVO;

public interface SysCmmnCdService {

    /*****************************************************
     * 상위 코드 관련 메서드
     *****************************************************/

    // 시스템 상위 공통코드 분류 등록
    public void insertSysCmmnUpCd(SysCmmnCdVO vo) throws Exception;

    // 시스템 상위 공통코드 분류 목록 페이징
    public ProcessResultVO<SysCmmnCdVO> listSysCmmnUpCdPaging(SysCmmnCdVO vo) throws Exception;

    // 시스템 상위 공통코드 분류 수정
    public void updateSysCmmnUpCd(SysCmmnCdVO vo) throws Exception;

    // 시스템 상위 공통코드 분류 삭제
    public void deleteSysCmmnUpCd(SysCmmnCdVO vo) throws Exception;

    /*****************************************************
     * 공통 코드 관련 메서드
     *****************************************************/

    // 시스템 공통코드 등록
    public void insertSysCmmnCd(SysCmmnCdVO vo) throws Exception;

    // 시스템 공통코드 목록 조회
    public ProcessResultVO<SysCmmnCdVO> listSysCmmnCdPaging(SysCmmnCdVO vo) throws Exception;

    // 시스템 공통코드 수정
    public void updateSysCmmnCd(SysCmmnCdVO vo) throws Exception;

    // 시스템 공통코드 삭제
    public void deleteSysCmmnCd(SysCmmnCdVO vo) throws Exception;


    // 시스템 공통코드 전체 목록 조회
    public List<SysCmmnCdVO> selectSysCmmnCdAll() throws Exception;
}