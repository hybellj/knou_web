package knou.lms.forum2.service.impl;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.dao.DscsDAO;
import knou.lms.forum2.dao.DscsFdbkDAO;
import knou.lms.forum2.dao.DscsJoinUserDAO;
import knou.lms.forum2.service.DscsJoinUserService;
import knou.lms.forum2.vo.DscsMutVO;
import knou.lms.forum2.vo.DscsFdbkVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsVO;
import knou.lms.forum2.vo.DscsEzGraderTeamVO;
import knou.lms.forum2.vo.DscsTeamDscsVO;
import knou.lms.std.dao.StdDAO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Service("dscsJoinUserService")
public class DscsJoinUserServiceImpl extends ServiceBase implements DscsJoinUserService {
    
    @Resource(name="dscsJoinUserDAO")
    private DscsJoinUserDAO dscsJoinUserDAO;

    @Resource(name = "dscsDAO")
    private DscsDAO dscsDAO;
    
    @Resource(name="dscsFdbkDAO")
    private DscsFdbkDAO dscsFdbkDAO;
    
    @Resource(name = "stdDAO")
    private StdDAO stdDAO;

    /*****************************************************
     * <p>
     * TODO 토론 현황 조회
     * </p>
     * 토론 현황 조회
     * 
     * @param DscsJoinUserVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectDscsScoreStatus(DscsJoinUserVO vo) throws Exception {
        return dscsJoinUserDAO.selectDscsScoreStatus(vo);
    }
    
    /*****************************************************
     * 토론 참여 목록 조회
     * @param DscsJoinUserVO
     * @return List<DscsJoinUserVO>
     * @throws Exception
     ******************************************************/
    public List<DscsJoinUserVO> list(DscsJoinUserVO vo) throws Exception {
        vo.setPagingYn("N");
        return dscsJoinUserDAO.listPaging(vo);
    }
    
    /*****************************************************
     * <p>
     * 토론 참여 목록 조회
     * </p>
     * 토론 참여 목록 조회
     * 
     * @param DscsJoinUserVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DscsJoinUserVO> listPaging(DscsJoinUserVO vo, String byteamDscsUseyn) throws Exception {

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
    
    /*****************************************************
     * <p>
     * 토론 참여 성적 반영
     * </p>
     * 토론 참여 성적 반영
     * 
     * @param DscsJoinUserVO
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void updateDscsJoinUserScore(DscsJoinUserVO vo) throws Exception {
        List<String> listTargetStdId = Arrays.asList(StringUtil.nvl(vo.getStdIds()).split(","));
        if("".equals(listTargetStdId.get(0))) {
            listTargetStdId = null;
        }
        
        if(!"checked".equals(StringUtil.nvl(vo.getConditionType(),""))) {
            listTargetStdId = null;
        }
        
        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
        dscsJoinUserVO.setDscsId(vo.getDscsId());
        dscsJoinUserVO.setRgtrId(vo.getRgtrId());
        dscsJoinUserVO.setMdfrId(vo.getMdfrId());
        dscsJoinUserVO.setTeamId(vo.getTeamId());
        
        DscsJoinUserVO selectJoinUserVO = new DscsJoinUserVO();
        selectJoinUserVO.setDscsId(vo.getDscsId());
        selectJoinUserVO.setSbjctId(vo.getSbjctId());
        selectJoinUserVO.setStdIdList(listTargetStdId);
        selectJoinUserVO.setConditionType(vo.getConditionType());
        List<DscsJoinUserVO> joinUserList = dscsJoinUserDAO.listStdScore(selectJoinUserVO);

        // 일괄 점수 등록
        if("batch".equals(StringUtil.nvl(vo.getScoreType(),""))) {
            dscsJoinUserVO.setScore(vo.getScore());
            if(dscsJoinUserVO.getScore() > 100) {
                // 최대 평가점수 초과 방지
                dscsJoinUserVO.setScore(100.0);
            } else if(dscsJoinUserVO.getScore() < 0) {
                // 최소 평가점수 미만 방지
                dscsJoinUserVO.setScore(0.0);
            }

            String[] stdArr = vo.getStdIds().split(",");

            if(stdArr.length > 0) {
                for(int i = 0; i < stdArr.length; i++) {
                    vo.setStdId(stdArr[i]);
                    dscsJoinUserDAO.insertStdScore(vo);
                }
            }
         // 전체 점수 가감
        } else if("addition".equals(StringUtil.nvl(vo.getScoreType(),""))) {
            for (int i = 0; i < joinUserList.size(); i++) {
                DscsJoinUserVO joinUserVO = joinUserList.get(i);
                String stdNo = StringUtil.nvl(joinUserVO.getStdId());
//                String teamId = StringUtil.nvl(joinUserVO.getTeamId());
//                int preScore = Integer.parseInt(StringUtil.nvl(joinUserVO.getScore()));
                int preScore = (int) Double.parseDouble(StringUtil.nvl(joinUserVO.getScore(), "0"));
                //점수계산
                dscsJoinUserVO.setScore(preScore+vo.getScore());
                if(dscsJoinUserVO.getScore() > 100) {
                    //최대 평가점수 초과 방지
                    dscsJoinUserVO.setScore(100.0);
                }else if(dscsJoinUserVO.getScore() < 0) {
                    //최소 평가점수 미만 방지
                    dscsJoinUserVO.setScore(0.0);
                }
                dscsJoinUserVO.setStdId(stdNo);
//                dscsJoinUserVO.setTeamId(teamId);
                dscsJoinUserDAO.insertStdScore(dscsJoinUserVO);
            }
         // 개별 점수 등록
        } else if("each".equals(StringUtil.nvl(vo.getScoreType(),""))) {
            String[] dscsScoreList = vo.getScoreArr().split(",");
            for(int i=0; i<dscsScoreList.length; i++) {
                String[] scoreStdArr = StringUtil.nvl(dscsScoreList[i]).split("\\|");
                String stdNo = StringUtil.nvl(scoreStdArr[0]);
                double score = Double.parseDouble(StringUtil.nvl(scoreStdArr[1],"0.0"));
                String fdbkCts = "";
                String dscsFdbkId = "";
                if(scoreStdArr.length >= 3) {
                    fdbkCts = StringUtil.nvl(scoreStdArr[2]);
                }
                if(scoreStdArr.length == 4) {
                    dscsFdbkId = StringUtil.nvl(scoreStdArr[3]);
                }
                
                dscsJoinUserVO.setStdId(stdNo);
                dscsJoinUserVO.setScore(score);
                if(dscsJoinUserVO.getScore() > 100) {
                    //최대 평가점수 초과 방지
                    dscsJoinUserVO.setScore(100.0);
                }else if(dscsJoinUserVO.getScore() < 0) {
                    //최소 평가점수 미만 방지
                    dscsJoinUserVO.setScore(0.0);
                }
                dscsJoinUserDAO.insertStdScore(dscsJoinUserVO);
                DscsFdbkVO dscsFdbkVO = new DscsFdbkVO();
                dscsFdbkVO.setDscsId(vo.getDscsId());
                dscsFdbkVO.setStdId(stdNo);
                dscsFdbkVO.setRgtrId(vo.getRgtrId());
                dscsFdbkVO.setMdfrId(vo.getMdfrId());
                if(!"".equals(dscsFdbkId)) {
                    dscsFdbkVO.setDscsFdbkId(dscsFdbkId);
                    // 피드백 수정
                    if(!"".equals(fdbkCts)) {
                        dscsFdbkVO.setFdbkCts(fdbkCts);
                        dscsFdbkDAO.updateDscsFdbk(dscsFdbkVO);
                    // 피드백 삭제
                    } else {
                        dscsFdbkDAO.deleteDscsFdbk(dscsFdbkVO);
                    }
                } else {
                    // 피드백 등록
                    if(!"".equals(fdbkCts)) {
                        dscsFdbkId = IdGenerator.getNewId(IdPrefixType.DSFDK.getCode());
                        dscsFdbkVO.setDscsFdbkId(dscsFdbkId);
                        dscsFdbkVO.setFdbkCts(fdbkCts);
                        dscsFdbkVO.setDelYn("N");
                        dscsFdbkDAO.insertDscsFdbk(dscsFdbkVO);
                    }
                }
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
     * @return DscsJoinUserVO
     * @throws Exception
     ******************************************************/
    @Override
    public DscsJoinUserVO selectDscsJoinUser(DscsJoinUserVO vo) throws Exception {
        return dscsJoinUserDAO.selectDscsJoinUser(vo);
    }

    // 성적분포현황차트
    @Override
    public List<?> dscsJoinUserList(DscsJoinUserVO vo) throws Exception {
        return dscsJoinUserDAO.dscsJoinUserList(vo);
    }

    // 성적평가 성적 등록
    @Override
    public void addStdScore(DscsJoinUserVO vo) throws Exception {
        String[] stdArr = vo.getStdIds().split(",");

        if(stdArr.length > 0) {
            for(int i = 0; i < stdArr.length; i++) {
                vo.setStdId(stdArr[i]);
                dscsJoinUserDAO.insertStdScore(vo);
            }
        }
    }

    // 교수 메모 팝업창 정보
    @Override
    public DscsJoinUserVO selectProfMemo(DscsJoinUserVO vo) throws Exception {
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

    // 교수 메모 수정
    @Override
    public void editDscsProfMemo(DscsJoinUserVO vo) throws Exception {
        dscsJoinUserDAO.editDscsProfMemo(vo);
    }

    // 토론 참여자 페이징 목록 조회
    @Override
    public ProcessResultVO<DscsJoinUserVO> listPageing(DscsJoinUserVO vo) throws Exception {
        return this.listPaging(vo, "");
    }

    // 엑셀 성적등록 엑셀 업로드
    @Override
    public void updateExampleExcelScore(DscsJoinUserVO vo, List<?> stdNoList, String dscsUnitTycd) throws Exception {
        if(stdNoList != null) {
            for (int i = 0; i < stdNoList.size(); i++) {
                Map<String, Object> stdNoMap = (Map<String, Object>)stdNoList.get(i);
                
                String userId = "";
                double score;
                if("TEAM".equals(dscsUnitTycd)) {
                    userId = StringUtil.nvl((String) stdNoMap.get("C"));
                    score = Math.round(Math.floor(Double.parseDouble(StringUtil.nvl((String) stdNoMap.get("F"),"0"))));
                } else {
                    userId = StringUtil.nvl((String) stdNoMap.get("B"));
                    score = Math.round(Math.floor(Double.parseDouble(StringUtil.nvl((String) stdNoMap.get("D"),"0"))));
                }
                vo.setUserId(userId);
                vo.setScore(score);
               dscsJoinUserDAO.insertStdScore(vo);
            }
        }
    }

    @Override
    public List<DscsJoinUserVO> listDscsJoinUser(DscsJoinUserVO vo) throws Exception {
        return dscsJoinUserDAO.listDscsJoinUser(vo);
    }

    @Override
    public List<DscsEzGraderTeamVO> listDscsJoinTeam(DscsJoinUserVO vo) throws Exception {
        List<DscsEzGraderTeamVO> memberList = dscsJoinUserDAO.listDscsJoinTeam(vo);
        if(memberList != null && !memberList.isEmpty() && memberList.size() > 0) {
            for(DscsEzGraderTeamVO teamVo : memberList) {
                String teamStdIds = "";
                if (teamVo.getTeamMembers() != null && !teamVo.getTeamMembers().isEmpty() && teamVo.getTeamMembers().size() > 0) {
                    int idx = 0;
                    for(DscsJoinUserVO joinUserVo : teamVo.getTeamMembers()) {
                        if (idx > 0 ) {
                            teamStdIds += ",";
                        }
                        teamStdIds += joinUserVo.getStdId();
                        idx++;
                    }
                }
                teamVo.setTeamStdIds(teamStdIds);
            }
        }
        return memberList;
    }

    // 메모
    @Override
    public DscsJoinUserVO getMemo(DscsVO vo) throws Exception {
        
        return dscsJoinUserDAO.getMemo(vo);
    }

    // 글자수로 점수 주기
    @Override
    public void updateDscsJoinUserLenScore(DscsJoinUserVO vo) throws Exception {
        List<String> listTargetStdId = Arrays.asList(StringUtil.nvl(vo.getStdIds()).split(","));
        if("".equals(listTargetStdId.get(0))) {
            listTargetStdId = null;
        }
        
        if(!"checked".equals(StringUtil.nvl(vo.getConditionType(),""))) {
            listTargetStdId = null;
        }
        
        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
        dscsJoinUserVO.setDscsId(vo.getDscsId());
        dscsJoinUserVO.setRgtrId(vo.getRgtrId());
        dscsJoinUserVO.setMdfrId(vo.getMdfrId());
        dscsJoinUserVO.setTeamId(vo.getTeamId());

        dscsJoinUserVO.setScore(vo.getScore());
        if(dscsJoinUserVO.getScore() > 100) {
            // 최대 평가점수 초과 방지
            dscsJoinUserVO.setScore(100.0);
        } else if(dscsJoinUserVO.getScore() < 0) {
            // 최소 평가점수 미만 방지
            dscsJoinUserVO.setScore(0.0);
        }

        String[] stdArr = vo.getStdIds().split(",");
        if(stdArr.length > 0) {
            for(int i = 0; i < stdArr.length; i++) {
                vo.setStdId(stdArr[i]);
                
                // 넘겨 받은 글자수에 해당하는 토론 참여자 조회
                int chkCtsLen = dscsJoinUserDAO.getSelectCtsLen(vo);
                if(chkCtsLen > 0) {
                    dscsJoinUserDAO.insertStdScore(vo);
                }
            }
        }
    }

    // 참여자가 없을 때 토론 참여자 테이블 삽입
	@Override
	public void chkStdNoInsert(DscsMutVO vo) throws Exception {
		dscsJoinUserDAO.chkStdNoInsert(vo);
	}

	// 모든 토론 참여자를 토론 참여자 테이블에 삽입
	@Override
	public void insertJoinUser(DscsVO vo) throws Exception {
		// 1. 기존 레코드 팀 갱신 (WHEN MATCHED UPDATE)
		dscsJoinUserDAO.insertJoinUser(vo);

		// 2. 미등록 학생 목록 조회 후 ID 생성하여 단건 INSERT
		List<DscsJoinUserVO> newStudents = dscsJoinUserDAO.selectStudentsNotInPtcp(vo);
		for (DscsJoinUserVO student : newStudents) {
			student.setDscsPtcpId(IdGenerator.getNewId(IdPrefixType.DSPTC.getCode()));
			student.setRgtrId(vo.getRgtrId());
			student.setMdfrId(vo.getRgtrId());
			dscsJoinUserDAO.insertDscsJoinUser(student);
		}
	}

	// 참여형 일괄평가
	@Override
	public void participateScore(DscsJoinUserVO vo) throws Exception {
        dscsJoinUserDAO.participateScore(vo);
	}

	// 개별 평가점수
	@Override
	public void setScoreRatio(DscsJoinUserVO vo) throws Exception {
		DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
		dscsJoinUserVO.setDscsId(vo.getDscsId());
		dscsJoinUserVO.setRgtrId(vo.getRgtrId());
		dscsJoinUserVO.setMdfrId(vo.getMdfrId());
        dscsJoinUserVO.setTeamId(vo.getTeamId());
		dscsJoinUserVO.setStdId(vo.getStdId());
		dscsJoinUserVO.setScore(vo.getScore());
		dscsJoinUserVO.setUserId(vo.getUserId());
		dscsJoinUserVO.setSbjctId(vo.getSbjctId());

		dscsJoinUserDAO.insertStdScore(dscsJoinUserVO);
	}

}
