package knou.lms.mrk.dao;

import knou.lms.mrk.vo.MrkProcStatusVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("mrkProcStatusDAO")
public interface MrkProcStatusDAO {
    /**
     * 성적처리현황 목록을 조회한다.
     */
    List<EgovMap> listMrkProcStatus(MrkProcStatusVO vo);

    /**
     * 성적처리 로그 목록의 전체 건수를 조회한다.
     */
    int countMrkProcHstry(MrkProcStatusVO vo);

    /**
     * 성적처리 로그 목록을 페이징 조회한다.
     */
    List<EgovMap> listMrkProcHstryPaging(MrkProcStatusVO vo);

    /**
     * 성적처리 로그 엑셀 다운로드 목록을 조회한다.
     */
    List<EgovMap> listMrkProcHstry(MrkProcStatusVO vo);

    void mrkProcStsBatchInsert(List<MrkProcStatusVO> mrkProcStsList);
}
