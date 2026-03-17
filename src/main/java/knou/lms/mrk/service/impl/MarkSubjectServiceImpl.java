package knou.lms.mrk.service.impl;

import knou.framework.util.StringUtil;
import knou.lms.mrk.dao.MarkSubjectDAO;
import knou.lms.mrk.service.MarkItemSettingService;
import knou.lms.mrk.service.MarkSubjectService;
import knou.lms.mrk.vo.MarkSubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service("markSubjectService")
public class MarkSubjectServiceImpl implements MarkSubjectService {

    @Resource(name="markSubjectDAO")
    private MarkSubjectDAO markSubjectDAO;

    @Override
    public List<EgovMap> stdMrkList(MarkSubjectVO mrkSbjctVO) throws Exception {
        List<EgovMap> stdMrkList = new ArrayList<>();

        String searchType = StringUtil.nvl(mrkSbjctVO.getSearchType());

        // 해당하는 학생 목록 가져오기
        String[] stdNos = null;
        switch (searchType) {
            case "btnZero": // 미평가

                // todo
                break;

            case "btnApprove": // 결시원 승인

                // todo

                break;

            case "btnApplicate": // 결시원 신청

                // todo

                break;
        }

//        stdMrkList = markSubjectDAO.stdMrkList(mrkSbjctVO);

        return stdMrkList;
    }
}
