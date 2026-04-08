package knou.lms.team.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.team.vo.TeamLrnGrpMgrVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface TeamLrnGrpMgrService {

    // 학습 그룹 목록 페이징
    public ProcessResultVO<TeamLrnGrpMgrVO> listTeamLrnGrpPaging(TeamLrnGrpMgrVO vo) throws Exception;

}
