package knou.lms.lecture2.service.impl;

import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.IdGenUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.lecture2.dao.LctrPlandocDAO;
import knou.lms.lecture2.dao.LectureScheduleDAO;
import knou.lms.lecture2.service.LctrPlandocService;
import knou.lms.lecture2.vo.LctrPlandocVO;
import knou.lms.lecture2.vo.LectureScheduleVO;
import knou.lms.lecture2.vo.TxtbkVO;
import knou.lms.mrk.dao.MarkItemSettingDAO;
import knou.lms.mrk.vo.MarkItemSettingVO;
import org.apache.commons.lang.StringUtils;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service("lctrPlandocService")
public class LctrPlandocServiceImpl implements LctrPlandocService {

    @Resource(name="lctrPlandocDAO")
    private LctrPlandocDAO lctrPlandocDAO;
    @Autowired
    private MarkItemSettingDAO markItemSettingDAO;
    @Autowired
    private LectureScheduleDAO lectureScheduleDAO;

    /**
     * 강의계획서 목록
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> lctrPlandocList(LctrPlandocVO vo) throws Exception {
        return lctrPlandocDAO.lctrPlandocList(vo);
    }

    /**
     * 강의계획서 목록 페이징
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> lctrPlandocListPaging(LctrPlandocVO vo) throws Exception {
        ProcessResultVO<EgovMap> processResultVO = new ProcessResultVO<>();
        // 페이지 정보 설정
        PageInfo pageInfo = new PageInfo(vo);

        List<EgovMap> plandocList = lctrPlandocDAO.lctrPlandocListPaging(vo);

        // 페이지 전체 건수정보 설정
        pageInfo.setTotalRecord(plandocList);

        processResultVO.setReturnList(plandocList);
        processResultVO.setPageInfo(pageInfo);

        return processResultVO;
    }

    /**
     * 강의계획서 조회
     *
     * @param sbjctId 과목아이디
     * @return
     * @throws Exception
     */
    @Override
    public LctrPlandocVO lctrPlandocSelect(String sbjctId) throws Exception {
        return lctrPlandocDAO.lctrPlandocSelect(sbjctId);
    }

    /**
     * 강의계획서 수정
     *
     * @param lctrPlandocVO
     * @throws Exception
     */
    @Transactional
    @Override
    public LctrPlandocVO lctrPlandocModify(UserContext userCtx, LctrPlandocVO lctrPlandocVO) throws Exception {
        String sbjctId = lctrPlandocVO.getSbjctId();

        /**
         * 강의계획서 정보 저장
         */
        lctrPlandocVO.setMdfrId(userCtx.getUserId());
        lctrPlandocDAO.lctrPlandocModify(lctrPlandocVO);

        /**
         * 교재 정보 저장
         */
        // 전체 삭제 후 재등록
        if(lctrPlandocVO.getTxtbkList() != null) {
            lctrPlandocDAO.allTxtbkDelete(sbjctId);
            for(TxtbkVO txtbkVO : lctrPlandocVO.getTxtbkList()) {
                // 교재명 없으면 skip
                if(StringUtils.isBlank(txtbkVO.getTxtbknm())) continue;

                txtbkVO.setSbjctId(sbjctId);
                txtbkVO.setTxtbkId(IdGenUtil.genNewId(IdPrefixType.TBK));

                lctrPlandocDAO.txtbkRegist(txtbkVO);
            }
        }

        /**
         * 성적 항목 정보 저장
         */
        List<MarkItemSettingVO> mrkList = lctrPlandocVO.getMrkItmStngList();
        if(mrkList == null) mrkList = Collections.emptyList();

        // 관리자-평가비중관리에서 사용하는 항목만 대상
        List<MarkItemSettingVO> active = mrkList.stream()
                .filter(it -> "Y".equals(it.getMrkItmUseyn()))
                .collect(Collectors.toList());


        // 관리자-평가비중관리 미등록 시 합계체크 X, 저장 X
        if(!active.isEmpty()) {
            int sum = active.stream()
                    .filter(it -> it.getMrkRfltrt() != null)
                    .map(MarkItemSettingVO::getMrkRfltrt)
                    .reduce(0, Integer::sum);

            if(sum != 100) {
                throw new RuntimeException("평가비율 합계는 100이어야 합니다.");
            }

            for(MarkItemSettingVO mrkItmStngVO : active) {
                mrkItmStngVO.setSbjctId(sbjctId);
                mrkItmStngVO.setMdfrId(userCtx.getUserId());

                markItemSettingDAO.mrkItmStngForProfModify(mrkItmStngVO);
            }
        }

        /**
         * 주차 정보 저장
         */
        // 주차 정보 변경된 것만 저장
        if(lctrPlandocVO.getWkList() != null) {
            for(LectureScheduleVO wkVO : lctrPlandocVO.getWkList()) {

                if(!"Y".equals(wkVO.getWkChgyn())) continue;

                wkVO.setMdfrId(userCtx.getUserId());
                lectureScheduleDAO.wknoSchdlForPlandocModify(wkVO);
            }
        }

        return lctrPlandocVO;
    }

    /**
     * 교재 목록
     *
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public List<TxtbkVO> txtbkList(String sbjctId) throws Exception {
        return lctrPlandocDAO.txtbkList(sbjctId);
    }

}
