package knou.lms.team.service.impl;

import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.team.dao.TeamLrnGrpMgrDAO;
import knou.lms.team.service.TeamLrnGrpMgrService;
import knou.lms.team.vo.TeamLrnGrpMgrVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.dao.DataRetrievalFailureException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service("teamLrnGrpMgrService")
public class TeamLrnGrpMgrServiceImpl extends ServiceBase implements TeamLrnGrpMgrService {

    @Resource(name="teamLrnGrpMgrDAO")
    private TeamLrnGrpMgrDAO teamLrnGrpMgrDAO;

    /*****************************************************
     * 학습 그룹 목록 페이징
     * @param vo
     * @return ProcessResultVO<TeamLrnGrpMgrVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<TeamLrnGrpMgrVO> listTeamLrnGrpPaging(TeamLrnGrpMgrVO vo) throws Exception{
        ProcessResultVO<TeamLrnGrpMgrVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = teamLrnGrpMgrDAO.countAbsnceUserHstr(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<TeamLrnGrpMgrVO> resultList = teamLrnGrpMgrDAO.listTeamLrnGrpPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 수강생 목록 페이징
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listAtndlcUser(TeamLrnGrpMgrVO vo) throws Exception{
        return teamLrnGrpMgrDAO.listAtndlcUser(vo);
    }

    /*****************************************************
     * 수강생 목록 카운트
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int countAtndlcUser(TeamLrnGrpMgrVO vo) throws Exception{
        return teamLrnGrpMgrDAO.countAtndlcUser(vo);
    }
}
