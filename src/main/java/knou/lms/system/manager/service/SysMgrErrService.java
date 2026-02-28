package knou.lms.system.manager.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.system.manager.vo.SysMgrErrVO;

public interface SysMgrErrService {

    // 시스템 오류현황 목록 페이징
    public ProcessResultVO<SysMgrErrVO> listSysErrPaging(SysMgrErrVO vo) throws Exception;

    // 시스템 오류현황 목록 조회
    public List<SysMgrErrVO> listSysErr(SysMgrErrVO vo) throws Exception;

    // 시스템 오류현황 상세 조회
    public SysMgrErrVO selectSysErrDtl(SysMgrErrVO vo) throws Exception;
}