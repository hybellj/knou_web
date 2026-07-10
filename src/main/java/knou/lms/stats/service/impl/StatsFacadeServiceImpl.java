package knou.lms.stats.service.impl;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.stats.service.StatsFacadeService;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service("statsFacadeService")
public class StatsFacadeServiceImpl extends ServiceBase implements StatsFacadeService {

    @Resource(name="semesterService")
    private SemesterService semesterService;

    @Override
    public EgovMap loadFilterOptions(UserContext userCtx) {

        EgovMap filterOptions = new EgovMap();

        // 기관 아이디 세팅
        String orgId = userCtx.getOrgId();
        filterOptions.put("orgId", orgId);

        // 학사연도/학기 세팅 (현재연도 기준 -> yyyy)
        String curYear = DateTimeUtil.getYear();
//        filterOptions.put("curYear", curYear);

        SmstrChrtVO curSmstrVO = new SmstrChrtVO();
        curSmstrVO.setOrgId(orgId);
//        curSmstrVO.setDgrsYr(curYear);





        return filterOptions;
    }
}
