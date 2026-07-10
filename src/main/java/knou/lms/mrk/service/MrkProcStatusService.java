package knou.lms.mrk.service;

import knou.lms.common.dto.ResultDTO;
import knou.lms.mrk.vo.MrkProcStatusVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface MrkProcStatusService {
    /**
     * 성적처리현황 목록을 조회한다.
     */
    ResultDTO<EgovMap> mrkProcStatusList(MrkProcStatusVO vo) throws Exception;

    /**
     * 성적처리현황 엑셀 다운로드 목록을 조회한다.
     */
    List<EgovMap> mrkProcStatusExcelList(MrkProcStatusVO vo) throws Exception;

    /**
     * 성적처리 로그 목록을 페이징 조회한다.
     */
    ResultDTO<EgovMap> mrkProcHstryList(MrkProcStatusVO vo) throws Exception;

    /**
     * 성적처리 로그 엑셀 다운로드 목록을 조회한다.
     */
    List<EgovMap> mrkProcHstryExcelList(MrkProcStatusVO vo) throws Exception;

    void mrkProcStsBatchInsert(String sbjctId, List<MrkProcStatusVO> list);
}
