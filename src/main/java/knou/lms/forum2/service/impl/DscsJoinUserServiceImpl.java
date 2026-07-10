package knou.lms.forum2.service.impl;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.dao.DscsDAO;
import knou.lms.forum2.dao.DscsFdbkDAO;
import knou.lms.forum2.dao.DscsJoinUserDAO;
import knou.lms.forum2.service.DscsJoinUserService;
import knou.lms.forum2.vo.DscsFdbkVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsVO;
import knou.lms.forum2.vo.DscsTeamDscsVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service("dscsJoinUserService")
public class DscsJoinUserServiceImpl extends ServiceBase implements DscsJoinUserService {
    
    @Resource(name="dscsJoinUserDAO")
    private DscsJoinUserDAO dscsJoinUserDAO;

    @Resource(name = "dscsDAO")
    private DscsDAO dscsDAO;
    
    @Resource(name="dscsFdbkDAO")
    private DscsFdbkDAO dscsFdbkDAO;
    
    
    /**
     * 토론 참여자 목록을 페이징 조건에 맞게 조회한다.
     * @param vo
     * @return
     */
    @Override
    public ProcessResultVO<DscsJoinUserVO> listPaging(DscsJoinUserVO vo) {

        /** start of paging */
        PagingInfo paginationInfo = new PagingInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        if ("all".equalsIgnoreCase(StringUtil.nvl(vo.getTeamId()))) {
            vo.setTeamId("");
        }

        List<DscsJoinUserVO> dscsJoinUserList = dscsJoinUserDAO.listPaging(vo);

        if (!dscsJoinUserList.isEmpty()) {
            paginationInfo.setTotalRecordCount(dscsJoinUserList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        ProcessResultVO<DscsJoinUserVO> resultVO = new ProcessResultVO<>();
        resultVO.setReturnList(dscsJoinUserList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 선택된 토론 참여자의 점수를 일괄/가감/개별 방식으로 반영한다.
     * @param vo
     */
    @Override
    public void updateDscsJoinUserScore(DscsJoinUserVO vo) {
        String scoreType = StringUtil.nvl(vo.getScoreType(),"");
        
        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
        dscsJoinUserVO.setDscsId(vo.getDscsId());
        dscsJoinUserVO.setRgtrId(vo.getRgtrId());
        dscsJoinUserVO.setMdfrId(vo.getMdfrId());
        dscsJoinUserVO.setTeamId(vo.getTeamId());

        // 일괄 점수 등록
        if("batch".equals(scoreType)) {
            // 선택 학습자를 토론/팀 단위 대상 목록으로 변환하여 자식토론별 점수를 반영한다.
            List<DscsJoinUserVO> targetList = parsePtcpTargets(vo);
            List<DscsJoinUserVO> stdScoreList = new ArrayList<DscsJoinUserVO>();
            Double score = clampScore(vo.getScr());
            for(DscsJoinUserVO target : targetList) {
                stdScoreList.add(createStdScoreVO(dscsJoinUserVO, target.getStdId(), null, target.getDscsId(), target.getTeamId(), score));
            }
            insertStdScoreBatch(stdScoreList);
         // 전체 점수 가감
        } else if("addition".equals(scoreType)) {
            // 선택 대상의 현재 점수를 조회한 뒤 가감 점수를 계산한다.
            List<DscsJoinUserVO> joinUserList = dscsJoinUserDAO.listStdScoreByTargets(parsePtcpTargets(vo));
            List<DscsJoinUserVO> stdScoreList = new ArrayList<DscsJoinUserVO>();
            for (int i = 0; i < joinUserList.size(); i++) {
                DscsJoinUserVO joinUserVO = joinUserList.get(i);
                String stdNo = StringUtil.nvl(joinUserVO.getStdId());
                String targetDscsId = StringUtil.nvl(joinUserVO.getDscsId());
                String targetTeamId = StringUtil.nvl(joinUserVO.getTeamId());
                if("".equals(targetDscsId)) {
                    targetDscsId = dscsJoinUserVO.getDscsId();
                }
                if("".equals(targetTeamId)) {
                    targetTeamId = dscsJoinUserVO.getTeamId();
                }
//                int preScore = Integer.parseInt(StringUtil.nvl(joinUserVO.getScr()));
                int preScore = (int) Double.parseDouble(StringUtil.nvl(joinUserVO.getScr(), "0"));
                //점수계산
                dscsJoinUserVO.setScr(clampScore(preScore+vo.getScr()));
                dscsJoinUserVO.setStdId(stdNo);
                stdScoreList.add(createStdScoreVO(dscsJoinUserVO, stdNo, null, targetDscsId, targetTeamId, dscsJoinUserVO.getScr()));
            }
            insertStdScoreBatch(stdScoreList);
         // 개별 점수 등록
        } else if("each".equals(scoreType)) {
            String[] dscsScoreList = vo.getScoreArr().split(",");
            List<DscsJoinUserVO> stdScoreList = new ArrayList<DscsJoinUserVO>();
            for(int i=0; i<dscsScoreList.length; i++) {
                String[] scoreStdArr = StringUtil.nvl(dscsScoreList[i]).split("\\|");
                String stdNo = StringUtil.nvl(scoreStdArr[0]);
                double score = Double.parseDouble(StringUtil.nvl(scoreStdArr[1],"0.0"));
                String dscsFdbkCts = "";
                String dscsFdbkId = "";
                if(scoreStdArr.length >= 3) {
                    dscsFdbkCts = StringUtil.nvl(scoreStdArr[2]);
                }
                if(scoreStdArr.length == 4) {
                    dscsFdbkId = StringUtil.nvl(scoreStdArr[3]);
                }
                
                dscsJoinUserVO.setStdId(stdNo);
                dscsJoinUserVO.setScr(score);
                if(dscsJoinUserVO.getScr() > 100) {
                    //최대 평가점수 초과 방지
                    dscsJoinUserVO.setScr(100.0);
                }else if(dscsJoinUserVO.getScr() < 0) {
                    //최소 평가점수 미만 방지
                    dscsJoinUserVO.setScr(0.0);
                }
                stdScoreList.add(createStdScoreVO(dscsJoinUserVO, stdNo, null, dscsJoinUserVO.getDscsId(), dscsJoinUserVO.getTeamId(), dscsJoinUserVO.getScr()));
                DscsFdbkVO dscsFdbkVO = new DscsFdbkVO();
                dscsFdbkVO.setDscsId(vo.getDscsId());
                dscsFdbkVO.setStdId(stdNo);
                dscsFdbkVO.setRgtrId(vo.getRgtrId());
                dscsFdbkVO.setMdfrId(vo.getMdfrId());
                if(!"".equals(dscsFdbkId)) {
                    dscsFdbkVO.setDscsFdbkId(dscsFdbkId);
                    // 피드백 수정
                    if(!"".equals(dscsFdbkCts)) {
                        dscsFdbkVO.setDscsFdbkCts(dscsFdbkCts);
                        dscsFdbkDAO.updateFdbk(dscsFdbkVO);
                    // 피드백 삭제
                    } else {
                        dscsFdbkVO.setDelYn("Y");
                        dscsFdbkDAO.updateFdbk(dscsFdbkVO);
                    }
                } else {
                    // 피드백 등록
                    if(!"".equals(dscsFdbkCts)) {
                        dscsFdbkId = IdGenerator.getNewId(IdPrefixType.DSFDK.getCode());
                        dscsFdbkVO.setDscsFdbkId(dscsFdbkId);
                        dscsFdbkVO.setDscsFdbkCts(dscsFdbkCts);
                        dscsFdbkVO.setDelYn("N");
                        dscsFdbkDAO.insertFdbk(dscsFdbkVO);
                    }
                }
            }
            insertStdScoreBatch(stdScoreList);
        }
    }

    /**
     * 점수관리/간편채점에서 사용할 토론 참여자 데이터를 준비한다.
     * 다중 인스턴스 환경의 중복 row 방지는 DB 제약 또는 INSERT SQL에서 보장되어야 한다.
     * @param vo
     */
    @Override
    public void prepareJoinUsersForScoring(DscsVO vo) {
        setJoinUserTargetStdIds(vo);

        dscsJoinUserDAO.updateExistingJoinUsers(vo);

        List<DscsJoinUserVO> newStudents = dscsJoinUserDAO.selectStudentsNotInPtcp(vo);
        for (DscsJoinUserVO student : newStudents) {
            student.setDscsPtcpId(IdGenerator.getNewId(IdPrefixType.DSPTC.getCode()));
            student.setRgtrId(vo.getRgtrId());
            student.setMdfrId(vo.getRgtrId());
        }
        if (!newStudents.isEmpty()) {
            dscsJoinUserDAO.insertDscsJoinUserBatch(newStudents);
        }
    }

    /**
     * 대상 학습자가 지정된 경우 참여자 준비 SQL의 foreach 조건으로 전달한다.
     * @param vo
     */
    private void setJoinUserTargetStdIds(DscsVO vo) {
        List<String> targetStdIds = getJoinUserTargetStdIds(vo);
        if (!targetStdIds.isEmpty()) {
            vo.setSqlForeach(targetStdIds.toArray(new String[targetStdIds.size()]));
        }
    }

    /**
     * stdList/stdId로 전달된 대상 학습자 ID를 중복 없이 추출한다.
     * @param vo
     * @return
     */
    private List<String> getJoinUserTargetStdIds(DscsVO vo) {
        Set<String> targetStdIds = new LinkedHashSet<String>();
        addJoinUserTargetStdIds(targetStdIds, vo.getStdList());
        if (targetStdIds.isEmpty()) {
            addJoinUserTargetStdIds(targetStdIds, vo.getStdId());
        }
        return new ArrayList<String>(targetStdIds);
    }

    /**
     * 쉼표로 전달된 학습자 ID를 trim 후 중복 제거 Set에 추가한다.
     * @param targetStdIds
     * @param stdIds
     */
    private void addJoinUserTargetStdIds(Set<String> targetStdIds, String stdIds) {
        if (stdIds == null || "".equals(stdIds.trim())) {
            return;
        }

        String[] stdArr = stdIds.split(",");
        for (String stdId : stdArr) {
            if (stdId != null && !"".equals(stdId.trim())) {
                targetStdIds.add(stdId.trim());
            }
        }
    }

    /*****************************************************
     * <p>
     * TODO 토론 참여 정보 조회
     * </p>
     * 토론 참여 정보 조회
     * 
     * @param DscsJoinUserVO
     * @return
     * @throws Exception
     ******************************************************/
    /**
     * 토론 참여자 단건 정보를 조회한다.
     * @param vo
     * @return
     */
    @Override
    public DscsJoinUserVO selectDscsJoinUser(DscsJoinUserVO vo) {
        return dscsJoinUserDAO.selectDscsJoinUser(vo);
    }

    /**
     * 성적분포 차트 등에서 사용할 토론 참여자 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public List<?> dscsJoinUserList(DscsJoinUserVO vo) {
        return dscsJoinUserDAO.dscsJoinUserList(vo);
    }

    /**
     * 교수 메모 팝업에 표시할 참여자 정보와 메모를 조회한다.
     * 메모 대상 참여자 row가 없으면 점수 덮어쓰기 없이 기본 row만 생성한다.
     * @param vo
     * @return
     */
    @Override
    public DscsJoinUserVO selectProfMemo(DscsJoinUserVO vo) {
        // ensureJoinUser: WHEN NOT MATCHED THEN INSERT 만 실행 (기존 점수 덮어쓰기 없음)
        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
        dscsJoinUserVO.setDscsId(vo.getDscsId());
        dscsJoinUserVO.setTeamId(vo.getTeamId());
        dscsJoinUserVO.setStdId(vo.getStdId());
        dscsJoinUserVO.setRgtrId(vo.getUserId());
        dscsJoinUserVO.setMdfrId(vo.getUserId());
        dscsJoinUserVO.setDscsPtcpId(IdGenerator.getNewId(IdPrefixType.DSPTC.getCode()));
        try {
            dscsJoinUserDAO.ensureJoinUser(dscsJoinUserVO);
        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            // ORA-00001: UNIQUE 제약 위반 = row 이미 존재 → 무시하고 진행
        }
        return dscsJoinUserDAO.selectProfMemo(vo);
    }

    /**
     * 교수 메모를 수정한다.
     * @param vo
     */
    @Override
    public void editDscsProfMemo(DscsJoinUserVO vo) {
        dscsJoinUserDAO.editDscsProfMemo(vo);
    }

    /**
     * 업로드된 엑셀 점수를 토론 참여자 점수에 반영한다.
     * 팀토론은 학습자별 자식 토론 ID를 찾아 해당 토론의 참여자 점수로 저장한다.
     * @param vo
     * @param stdNoList
     * @param dscsUnitTycd
     */
    @Override
    public void updateExampleExcelScore(DscsJoinUserVO vo, List<?> stdNoList, String dscsUnitTycd) {
        if(stdNoList != null) {
            boolean teamDscs = "TEAM".equals(dscsUnitTycd);
            Map<String, DscsJoinUserVO> teamTargetMap = teamDscs ? getExcelScoreTeamTargetMap(vo) : null;
            String requestDscsId = vo.getDscsId();
            String requestTeamId = vo.getTeamId();
            List<DscsJoinUserVO> stdScoreList = new ArrayList<DscsJoinUserVO>();

            try {
                for (int i = 0; i < stdNoList.size(); i++) {
                    Map<String, Object> stdNoMap = (Map<String, Object>)stdNoList.get(i);

                    String userId = "";
                    double score;
                    if(teamDscs) {
                        userId = StringUtil.nvl((String) stdNoMap.get("C"));
                        score = Math.round(Math.floor(Double.parseDouble(StringUtil.nvl((String) stdNoMap.get("F"),"0"))));
                        setExcelScoreTeamTarget(vo, teamTargetMap, userId);
                    } else {
                        userId = StringUtil.nvl((String) stdNoMap.get("B"));
                        score = Math.round(Math.floor(Double.parseDouble(StringUtil.nvl((String) stdNoMap.get("D"),"0"))));
                        vo.setDscsId(requestDscsId);
                        vo.setTeamId(requestTeamId);
                    }
                    stdScoreList.add(createStdScoreVO(vo, null, userId, vo.getDscsId(), vo.getTeamId(), score));
                }
                insertStdScoreBatch(stdScoreList);
            } finally {
                vo.setDscsId(requestDscsId);
                vo.setTeamId(requestTeamId);
            }
        }
    }

    /**
     * 팀토론 엑셀 점수 업로드 시 학습자별 자식 토론/팀 매핑 정보를 조회한다.
     * @param vo
     * @return
     */
    private Map<String, DscsJoinUserVO> getExcelScoreTeamTargetMap(DscsJoinUserVO vo) {
        DscsJoinUserVO searchVO = new DscsJoinUserVO();
        searchVO.setDscsId(vo.getDscsId());
        searchVO.setSbjctId(vo.getSbjctId());
        searchVO.setDscsUnitTycd("TEAM");

        List<DscsJoinUserVO> teamTargetList = dscsJoinUserDAO.listPaging(searchVO);
        Map<String, DscsJoinUserVO> teamTargetMap = new HashMap<String, DscsJoinUserVO>();
        for (DscsJoinUserVO target : teamTargetList) {
            if (target != null && StringUtil.isNotNull(target.getUserId()) && StringUtil.isNotNull(target.getDscsId())) {
                teamTargetMap.put(target.getUserId(), target);
            }
        }
        return teamTargetMap;
    }

    /**
     * 팀토론 학습자 기준으로 점수를 반영할 자식 토론 ID와 팀 ID를 설정한다.
     * @param vo
     * @param teamTargetMap
     * @param userId
     */
    private void setExcelScoreTeamTarget(DscsJoinUserVO vo, Map<String, DscsJoinUserVO> teamTargetMap, String userId) {
        DscsJoinUserVO target = teamTargetMap.get(userId);
        if (target == null || StringUtil.isNull(target.getDscsId())) {
            throw new MediopiaDefineException("팀토론 엑셀 업로드 대상자를 찾을 수 없습니다. userId=" + userId);
        }

        vo.setDscsId(target.getDscsId());
        vo.setTeamId(target.getTeamId());
    }

    /**
     * 메모 정보를 조회한다.
     * @param vo
     * @return
     */
    @Override
    public DscsJoinUserVO getMemo(DscsVO vo) {
        return dscsJoinUserDAO.getMemo(vo);
    }

    /**
     * 글자수 조건을 만족한 참여자에게 점수를 반영한다.
     * @param vo
     */
    @Override
    public void updateDscsJoinUserLenScore(DscsJoinUserVO vo) {
        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
        dscsJoinUserVO.setDscsId(vo.getDscsId());
        dscsJoinUserVO.setRgtrId(vo.getRgtrId());
        dscsJoinUserVO.setMdfrId(vo.getMdfrId());
        dscsJoinUserVO.setTeamId(vo.getTeamId());

        dscsJoinUserVO.setScr(clampScore(vo.getScr()));

        // 선택 대상 중 글자수 조건을 만족하는 학습자만 배치 점수 대상으로 조회한다.
        List<DscsJoinUserVO> targetList = dscsJoinUserDAO.listCtsLenScoreTargets(parsePtcpTargets(vo), vo.getCtsLen(), vo.getChkCmnt());
        List<DscsJoinUserVO> stdScoreList = new ArrayList<DscsJoinUserVO>();
        for(DscsJoinUserVO target : targetList) {
            stdScoreList.add(createStdScoreVO(dscsJoinUserVO, target.getStdId(), null, target.getDscsId(), target.getTeamId(), dscsJoinUserVO.getScr()));
        }
        insertStdScoreBatch(stdScoreList);
    }

    /**
     * 참여 여부 기준으로 참여자 점수를 일괄 반영한다.
     * @param vo
     */
	@Override
	public void participateScore(DscsJoinUserVO vo) {
        // 참여형 일괄평가는 전달된 토론ID 기준으로 전체 대상의 참여 여부 점수를 배치 반영한다.
        dscsJoinUserDAO.participateScoreBatch(vo);
	}

    /**
     * 개별 참여자 점수를 반영한다.
     * @param vo
     */
	@Override
	public void setScoreRatio(DscsJoinUserVO vo) {
		DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
		dscsJoinUserVO.setDscsId(vo.getDscsId());
		dscsJoinUserVO.setRgtrId(vo.getRgtrId());
		dscsJoinUserVO.setMdfrId(vo.getMdfrId());
        dscsJoinUserVO.setTeamId(vo.getTeamId());
		dscsJoinUserVO.setStdId(vo.getStdId());
		dscsJoinUserVO.setScr(vo.getScr());
		dscsJoinUserVO.setUserId(vo.getUserId());
		dscsJoinUserVO.setSbjctId(vo.getSbjctId());

		insertStdScore(dscsJoinUserVO);
	}

    /**
     * 점수 처리 대상 문자열을 토론/팀/학습자 단위 목록으로 변환한다.
     * @param vo
     * @return
     */
    private List<DscsJoinUserVO> parsePtcpTargets(DscsJoinUserVO vo) {
        String ptcpTargets = StringUtil.nvl(vo.getPtcpTargets());
        if("".equals(ptcpTargets)) {
            throw new MediopiaDefineException("점수 처리 대상이 없습니다.");
        }

        Map<String, DscsJoinUserVO> targetMap = new LinkedHashMap<String, DscsJoinUserVO>();
        String[] targetGroups = ptcpTargets.split(";");
        for(String targetGroup : targetGroups) {
            if(targetGroup == null || "".equals(targetGroup.trim())) {
                continue;
            }

            String[] targetParts = targetGroup.split("\\|", -1);
            if(targetParts.length < 3) {
                continue;
            }

            String dscsId = StringUtil.nvl(targetParts[0]).trim();
            String teamId = StringUtil.nvl(targetParts[1]).trim();
            String stdIds = StringUtil.nvl(targetParts[2]);
            if("".equals(dscsId) || "".equals(stdIds)) {
                continue;
            }

            String[] stdIdArr = stdIds.split(",");
            for(String stdId : stdIdArr) {
                String targetStdId = StringUtil.nvl(stdId).trim();
                if("".equals(targetStdId)) {
                    continue;
                }

                DscsJoinUserVO target = new DscsJoinUserVO();
                target.setDscsId(dscsId);
                target.setTeamId(teamId);
                target.setStdId(targetStdId);
                target.setRgtrId(vo.getRgtrId());
                target.setMdfrId(vo.getMdfrId());
                targetMap.put(dscsId + "|" + targetStdId, target);
            }
        }

        if(targetMap.isEmpty()) {
            throw new MediopiaDefineException("점수 처리 대상이 없습니다.");
        }
        return new ArrayList<DscsJoinUserVO>(targetMap.values());
    }

    /**
     * 평가 점수 범위를 0~100점으로 제한한다.
     * @param score
     * @return
     */
    private Double clampScore(Double score) {
        double targetScore = score == null ? 0.0 : score;
        if(targetScore > 100) {
            // 최대 평가점수 초과 방지
            return 100.0;
        } else if(targetScore < 0) {
            // 최소 평가점수 미만 방지
            return 0.0;
        }
        return targetScore;
    }

    /**
     * 토론 참여 점수 단건 반영 전 참여 PK를 생성한다.
     * @param vo
     */
	private void insertStdScore(DscsJoinUserVO vo) {
		vo.setDscsPtcpId(IdGenerator.getNewId(IdPrefixType.DSPTC.getCode()));
		dscsJoinUserDAO.insertStdScore(vo);
	}

    /**
     * 토론 참여 점수 배치 반영 전 중복을 제거하고 참여 PK를 생성한다.
     * @param stdScoreList
     */
	private void insertStdScoreBatch(List<DscsJoinUserVO> stdScoreList) {
		if (stdScoreList == null || stdScoreList.isEmpty()) {
			return;
		}

		Map<String, DscsJoinUserVO> dedupedStdScoreMap = new LinkedHashMap<String, DscsJoinUserVO>();
		for (DscsJoinUserVO stdScoreVO : stdScoreList) {
			String userId = StringUtil.nvl(stdScoreVO.getStdId());
			if ("".equals(userId)) {
				userId = StringUtil.nvl(stdScoreVO.getUserId());
			}
			dedupedStdScoreMap.put(userId + "|" + StringUtil.nvl(stdScoreVO.getDscsId()), stdScoreVO);
		}

		List<DscsJoinUserVO> dedupedStdScoreList = new ArrayList<DscsJoinUserVO>(dedupedStdScoreMap.values());
		for (DscsJoinUserVO stdScoreVO : dedupedStdScoreList) {
			stdScoreVO.setDscsPtcpId(IdGenerator.getNewId(IdPrefixType.DSPTC.getCode()));
		}
		dscsJoinUserDAO.insertStdScoreBatch(dedupedStdScoreList);
	}

    /**
     * 토론 참여 점수 배치 반영용 VO를 생성한다.
     * @param source
     * @param stdId
     * @param userId
     * @param dscsId
     * @param teamId
     * @param scr
     * @return
     */
	private DscsJoinUserVO createStdScoreVO(DscsJoinUserVO source, String stdId, String userId, String dscsId, String teamId, Double scr) {
		DscsJoinUserVO stdScoreVO = new DscsJoinUserVO();
		stdScoreVO.setStdId(stdId);
		stdScoreVO.setUserId(userId);
		stdScoreVO.setDscsId(dscsId);
		stdScoreVO.setTeamId(teamId);
		stdScoreVO.setScr(scr);
		stdScoreVO.setRgtrId(source.getRgtrId());
		stdScoreVO.setMdfrId(source.getMdfrId());
		return stdScoreVO;
	}

}
