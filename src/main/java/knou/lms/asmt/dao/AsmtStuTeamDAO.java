package knou.lms.asmt.dao;

import knou.lms.asmt.vo.AsmtVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("asmtStuTeamDAO")
public interface AsmtStuTeamDAO {

    // 팀 목록 조회
    public List<AsmtVO> selectTeamList(AsmtVO vo) throws Exception;

    // 학습자 팀 수정
    public void updateStdTeam(AsmtVO vo) throws Exception;
}
