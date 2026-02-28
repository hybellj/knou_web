package knou.lms.system.manager.dao;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.system.manager.vo.SysMgrErrVO;

@Mapper("sysMgrErrDAO")
public interface SysMgrErrDAO {

    // 시스템 오류현황 목록 카운트
    public int countSysErr(SysMgrErrVO vo) throws Exception;

    // 시스템 오류현황 목록 페이징
    public List<SysMgrErrVO> listSysErrPaging(SysMgrErrVO vo) throws Exception;

    // 시스템 오류현황 목록 조회
    public List<SysMgrErrVO> listSysErr(SysMgrErrVO vo) throws Exception;

    // 시스템 오류현황 상세 조회
    public SysMgrErrVO selectSysErrDtl(SysMgrErrVO vo) throws Exception;
}