package knou.lms.forum2.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import knou.lms.forum2.vo.*;
import org.springframework.stereotype.Service;

import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.dao.Forum2DAO;
import knou.lms.forum2.service.ForumService;

@Service("forum2Service")
public class ForumServiceImpl extends ServiceBase implements ForumService {

    @Resource(name = "forum2DAO")
    private Forum2DAO forumDAO;

    @Override
    public List<Forum2VO> selectForumDvclasList(Forum2VO vo) throws Exception {
        return forumDAO.selectForumDvclasList(vo);
    }

    /**
     * 토론목록조회
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<Forum2ListVO> selectForumList(Forum2ListVO vo) throws Exception {
        ProcessResultVO<Forum2ListVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<Forum2ListVO> list = forumDAO.selectForumList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);
        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * 토론단건상세조회
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public Forum2VO selectForum(Forum2VO vo) throws Exception {
        Forum2VO  resultVo = forumDAO.selectForum(vo);
        // 부토론 존재여부 체크
        if (resultVo.getByteamDscsUseyn().equalsIgnoreCase("Y")) {
            resultVo.setTeamDscsList(forumDAO.selectTeamDscsList(vo.getDscsId()));
        }
        return resultVo;
    }

    /**
     * 토론성적공개여부 수정
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<Forum2VO> modifyForumMrkOyn(Forum2VO vo) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        int affected = forumDAO.updateForumMrkOyn(vo);
        if (affected > 0) {
            resultVO.setReturnVO(vo);
            resultVO.setResultSuccess();
        } else {
            resultVO.setResultFailed("update target not found");
        }

        return resultVO;
    }

    /**
     * 토론성적반영비율 수정
     * @param list
     * @throws Exception
     */
    @Override
    public void updateForumMrkRfltrt(List<Forum2VO> list) throws Exception {
        forumDAO.updateForumMrkRfltrt(list);
    }

    /**
     * 토론등록/수정
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<Forum2VO> saveForum(Forum2VO vo) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(vo.getOknokStngyn())) {
            vo.setOknokStngyn("N");
        }

        boolean isInsertMode = StringUtil.isNull(vo.getDscsId());
        boolean isTeamDiscussion = "TEAM".equalsIgnoreCase(vo.getDscsUnitTycd()) || "Y".equalsIgnoreCase(vo.getDscsUnitTycd());
        vo.setDscsUnitTycd(isTeamDiscussion ? "TEAM" : "NORMAL");

        if (!isInsertMode) {
            // 수정(mode=E): 기존 dscsId 단건 update만 수행
            vo.setDvclsNo(null); // 수정 시 분반 변경 금지
            forumDAO.updateForum(vo);
        } else {
            List<Forum2DvclasSelVO> dvclasSelList = vo.getDvclasSelList();
            if (dvclasSelList == null || dvclasSelList.isEmpty()) {
                resultVO.setResultFailed("등록 시 분반 정보가 필요합니다.");
                return resultVO;
            }

            Map<String, String> lrnGrpMapByDvclasNo = new HashMap<>();
            Map<String, String> lrnGrpNmMapByDvclasNo = new HashMap<>();
            List<Forum2LrnGrpVO> lrnGrpInfoList = vo.getLrnGrpInfoList();
            if (lrnGrpInfoList != null) {
                for (Forum2LrnGrpVO info : lrnGrpInfoList) {
                    if (info == null) {
                        continue;
                    }
                    if (!StringUtil.isNull(info.getDvclasNo()) && !StringUtil.isNull(info.getLrnGrpId())) {
                        lrnGrpMapByDvclasNo.put(info.getDvclasNo(), info.getLrnGrpId());
                    }
                    if (!StringUtil.isNull(info.getDvclasNo()) && !StringUtil.isNull(info.getLrnGrpnm())) {
                        lrnGrpNmMapByDvclasNo.put(info.getDvclasNo(), info.getLrnGrpnm());
                    }
                }
            }

            if (isTeamDiscussion) {
                if (lrnGrpMapByDvclasNo.isEmpty()) {
                    resultVO.setResultFailed("팀토론 등록 시 분반별 학습그룹 정보가 필요합니다.");
                    return resultVO;
                }
            }

            String firstDscsId = null;
            for (Forum2DvclasSelVO dvclasSelVO : dvclasSelList) {
                // 분반별 과목개설ID 를 등록한다.
                vo.setSbjctId(dvclasSelVO.getSbjctId());
                if (dvclasSelVO == null) {
                    continue;
                }
                if (!"Y".equalsIgnoreCase(dvclasSelVO.getCheckedYn())) {
                    continue;
                }

                String dvclasNo = dvclasSelVO.getDvclasNo();
                String dvclsNo = dvclasNo; 
                if (StringUtil.isNull(dvclsNo)) {
                    resultVO.setResultFailed("등록 시 분반 정보가 필요합니다.");
                    return resultVO;
                }

                if (isTeamDiscussion) {
                    String lrnGrpId = lrnGrpMapByDvclasNo.get(dvclasNo);
                    String lrnGrpnm = lrnGrpNmMapByDvclasNo.get(dvclasNo);
                    if (StringUtil.isNull(lrnGrpId)) {
                        resultVO.setResultFailed("팀토론 등록 시 분반별 학습그룹 정보가 필요합니다.");
                        return resultVO;
                    }
                    if (StringUtil.isNull(lrnGrpnm)) {
                        resultVO.setResultFailed("팀토론 등록 시 분반별 학습그룹 정보가 필요합니다.");
                        return resultVO;
                    }
                    String dscsGrpId = IdGenerator.getNewId("DGRP");
                    vo.setDscsGrpId(dscsGrpId);
                    vo.setLrnGrpId(lrnGrpId);
                    vo.setDscsGrpnm(lrnGrpnm);
                    forumDAO.insertForumGrp(vo);
                } else {
                    vo.setDscsGrpId(null);
                    vo.setLrnGrpId(null);
                    vo.setDscsGrpnm(null);
                }

                String newDscsId = IdGenerator.getNewId("DSCS");
                vo.setDscsId(newDscsId);
                vo.setDvclsNo(dvclsNo);
                forumDAO.insertForum(vo);

                // TODO : 팀별 부주제 정보 저장(저장 정보 체크)
                // - 분반 * 팀갯수만큼 토론 생성되는 것으로 변경 예정(26.3.16)
                /*
                if (vo.getByteamSubdscsUseyn().equalsIgnoreCase("Y")) {
                    for (Forum2TeamDscsVO teamDtlVO : vo.getTeamForumDtlList()) {
                        String newSubDscsId = IdGenerator.getNewId("SUBDSCS");
                        teamDtlVO.setSubdscsId(newSubDscsId);
                        teamDtlVO.setDscsId(newDscsId);
                        forumDAO.insertSubDscs(teamDtlVO);
                    }
                }
                */

                if (firstDscsId == null) {
                    // 입력된 분반 선택 순서 기준으로 첫 번째 DSCS를 대표 dscsId로 사용
                    firstDscsId = newDscsId;
                }
            }

            if (StringUtil.isNull(firstDscsId)) {
                resultVO.setResultFailed("팀토론 등록 시 유효한 분반 정보가 없습니다.");
                return resultVO;
            }
            vo.setDscsId(firstDscsId);
        }

        // TODO : 확인용 코드 제거.
        /*Forum2VO detailParam = new Forum2VO();
        detailParam.setDscsId(vo.getDscsId());
        if (vo.getByteamSubdscsUseyn().equalsIgnoreCase("Y")) {
            detailParam.setTeamDscsList(vo.getDscsId());
        }
        Forum2VO detailVO = forumDAO.selectForum(detailParam);
        resultVO.setReturnVO(detailVO);*/
        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * 토론삭제
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<Forum2VO> deleteForum(Forum2VO vo) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        int affected = forumDAO.deleteForum(vo);
        if (affected > 0) {
            resultVO.setReturnVO(vo);
            resultVO.setResultSuccess();
        } else {
            resultVO.setResultFailed("delete target not found");
        }

        return resultVO;
    }

    /**
     * 팀토론토론방OPEN여부 수정
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<Forum2TeamDscsVO> modifyTeamDscsOyn(Forum2TeamDscsVO vo) throws Exception {
        ProcessResultVO<Forum2TeamDscsVO> resultVO = new ProcessResultVO<>();

        int affected = forumDAO.updateTeamDscsOyn(vo);
        if (affected > 0) {
            resultVO.setReturnVO(vo);
            resultVO.setResultSuccess();
        } else {
            resultVO.setResultFailed("update target not found");
        }

        return resultVO;
    }

    /**
     * 토론복사
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<Forum2VO> copyForum(Forum2VO vo) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        String newDscsId = IdGenerator.getNewId("DSCS");
        vo.setDscsId(newDscsId);

        /*TODO_copyForum파라미터매핑프로젝트표준확정필요*/
        forumDAO.copyForum(vo);

        Forum2VO detailParam = new Forum2VO();
        detailParam.setDscsId(newDscsId);
        Forum2VO detailVO = forumDAO.selectForum(detailParam);

        resultVO.setReturnVO(detailVO);
        resultVO.setResultSuccess();

        return resultVO;
    }
}
