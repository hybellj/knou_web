package knou.lms.team.dao;

import knou.lms.team.vo.TeamLrnGrpMgrVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("teamLrnGrpMgrDAO")
public interface TeamLrnGrpMgrDAO {

    // 학습 그룹 목록 페이징
    public List<TeamLrnGrpMgrVO> listTeamLrnGrpPaging(TeamLrnGrpMgrVO vo) throws Exception;

    // 학습 그룹 목록 카운트
    public int countAbsnceUserHstr(TeamLrnGrpMgrVO vo) throws Exception;
}
