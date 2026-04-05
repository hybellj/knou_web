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
    private DscsJoinUserDAO forumJoinUserDAO;

    @Resource(name = "dscsDAO")
    private DscsDAO dscsDAO;
    
    @Resource(name="dscsFdbkDAO")
    private DscsFdbkDAO forumFdbkDAO;
    
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
        return forumJoinUserDAO.selectDscsScoreStatus(vo);
    }
    
    /*****************************************************
     * 토론 참여 목록 조회
     * @param DscsJoinUserVO
     * @return List<DscsJoinUserVO>
     * @throws Exception
     ******************************************************/
    public List<DscsJoinUserVO> list(DscsJoinUserVO vo) throws Exception {
        vo.setPagingYn("N");
        return forumJoinUserDAO.listPaging(vo);
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

        if ("all".equalsIgnoreCase(StringUtil.nvl(vo.getTeamCd()))) {
            vo.setTeamCd("");
        }

        List<DscsJoinUserVO> forumJoinUserList = forumJoinUserDAO.listPaging(vo);

        if (!forumJoinUserList.isEmpty()) {
            paginationInfo.setTotalRecordCount(forumJoinUserList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        ProcessResultVO<DscsJoinUserVO> resultVO = new ProcessResultVO<>();
        resultVO.setReturnList(forumJoinUserList);
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
        
        DscsJoinUserVO forumJoinUserVO = new DscsJoinUserVO();
        forumJoinUserVO.setDscsId(vo.getDscsId());
        forumJoinUserVO.setRgtrId(vo.getRgtrId());
        forumJoinUserVO.setMdfrId(vo.getMdfrId());
        forumJoinUserVO.setTeamCd(vo.getTeamCd());
        
        DscsJoinUserVO selectJoinUserVO = new DscsJoinUserVO();
        selectJoinUserVO.setDscsId(vo.getDscsId());
        selectJoinUserVO.setCrsCreCd(vo.getCrsCreCd());
        selectJoinUserVO.setStdIdList(listTargetStdId);
        selectJoinUserVO.setConditionType(vo.getConditionType());
        List<DscsJoinUserVO> joinUserList = forumJoinUserDAO.listStdScore(selectJoinUserVO);

        // 일괄 점수 등록
        if("batch".equals(StringUtil.nvl(vo.getScoreType(),""))) {
            forumJoinUserVO.setScore(vo.getScore());
            if(forumJoinUserVO.getScore() > 100) {
                // 최대 평가점수 초과 방지
                forumJoinUserVO.setScore(100.0);
            } else if(forumJoinUserVO.getScore() < 0) {
                // 최소 평가점수 미만 방지
                forumJoinUserVO.setScore(0.0);
            }

            String[] stdArr = vo.getStdIds().split(",");

            if(stdArr.length > 0) {
                for(int i = 0; i < stdArr.length; i++) {
                    vo.setStdId(stdArr[i]);
                    forumJoinUserDAO.insertStdScore(vo);
                }
            }
         // 전체 점수 가감
        } else if("addition".equals(StringUtil.nvl(vo.getScoreType(),""))) {
            for (int i = 0; i < joinUserList.size(); i++) {
                DscsJoinUserVO joinUserVO = joinUserList.get(i);
                String stdNo = StringUtil.nvl(joinUserVO.getStdId());
//                String teamCd = StringUtil.nvl(joinUserVO.getTeamCd());
//                int preScore = Integer.parseInt(StringUtil.nvl(joinUserVO.getScore()));
                int preScore = (int) Double.parseDouble(StringUtil.nvl(joinUserVO.getScore(), "0"));
                //점수계산
                forumJoinUserVO.setScore(preScore+vo.getScore());
                if(forumJoinUserVO.getScore() > 100) {
                    //최대 평가점수 초과 방지
                    forumJoinUserVO.setScore(100.0);
                }else if(forumJoinUserVO.getScore() < 0) {
                    //최소 평가점수 미만 방지
                    forumJoinUserVO.setScore(0.0);
                }
                forumJoinUserVO.setStdId(stdNo);
//                forumJoinUserVO.setTeamCd(teamCd);
                forumJoinUserDAO.insertStdScore(forumJoinUserVO);
            }
         // 개별 점수 등록
        } else if("each".equals(StringUtil.nvl(vo.getScoreType(),""))) {
            String[] forumScoreList = vo.getScoreArr().split(",");
            for(int i=0; i<forumScoreList.length; i++) {
                String[] scoreStdArr = StringUtil.nvl(forumScoreList[i]).split("\\|");
                String stdNo = StringUtil.nvl(scoreStdArr[0]);
                double score = Double.parseDouble(StringUtil.nvl(scoreStdArr[1],"0.0"));
                String fdbkCts = "";
                String forumFdbkCd = "";
                if(scoreStdArr.length >= 3) {
                    fdbkCts = StringUtil.nvl(scoreStdArr[2]);
                }
                if(scoreStdArr.length == 4) {
                    forumFdbkCd = StringUtil.nvl(scoreStdArr[3]);
                }
                
                forumJoinUserVO.setStdId(stdNo);
                forumJoinUserVO.setScore(score);
                if(forumJoinUserVO.getScore() > 100) {
                    //최대 평가점수 초과 방지
                    forumJoinUserVO.setScore(100.0);
                }else if(forumJoinUserVO.getScore() < 0) {
                    //최소 평가점수 미만 방지
                    forumJoinUserVO.setScore(0.0);
                }
                forumJoinUserDAO.insertStdScore(forumJoinUserVO);
                DscsFdbkVO forumFdbkVO = new DscsFdbkVO();
                forumFdbkVO.setDscsId(vo.getDscsId());
                forumFdbkVO.setStdId(stdNo);
                forumFdbkVO.setRgtrId(vo.getRgtrId());
                forumFdbkVO.setMdfrId(vo.getMdfrId());
                if(!"".equals(forumFdbkCd)) {
                    forumFdbkVO.setForumFdbkCd(forumFdbkCd);
                    // 피드백 수정
                    if(!"".equals(fdbkCts)) {
                        forumFdbkVO.setFdbkCts(fdbkCts);
                        forumFdbkDAO.updateDscsFdbk(forumFdbkVO);
                    // 피드백 삭제
                    } else {
                        forumFdbkDAO.deleteDscsFdbk(forumFdbkVO);
                    }
                } else {
                    // 피드백 등록
                    if(!"".equals(fdbkCts)) {
                        forumFdbkCd = IdGenerator.getNewId(IdPrefixType.DSFDK.getCode());
                        forumFdbkVO.setForumFdbkCd(forumFdbkCd);
                        forumFdbkVO.setFdbkCts(fdbkCts);
                        forumFdbkVO.setDelYn("N");
                        forumFdbkDAO.insertDscsFdbk(forumFdbkVO);
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
        return forumJoinUserDAO.selectDscsJoinUser(vo);
    }

    // 성적분포현황차트
    @Override
    public List<?> dscsJoinUserList(DscsJoinUserVO vo) throws Exception {
        return forumJoinUserDAO.dscsJoinUserList(vo);
    }

    // 성적평가 성적 등록
    @Override
    public void addStdScore(DscsJoinUserVO vo) throws Exception {
        String[] stdArr = vo.getStdIds().split(",");

        if(stdArr.length > 0) {
            for(int i = 0; i < stdArr.length; i++) {
                vo.setStdId(stdArr[i]);
                forumJoinUserDAO.insertStdScore(vo);
            }
        }
    }

    // 교수 메모 팝업창 정보
    @Override
    public DscsJoinUserVO selectProfMemo(DscsJoinUserVO vo) throws Exception {
        // ensureJoinUser: WHEN NOT MATCHED THEN INSERT 만 실행 (기존 점수 덮어쓰기 없음)
        DscsJoinUserVO forumJoinUserVO = new DscsJoinUserVO();
        forumJoinUserVO.setDscsId(vo.getDscsId());
        forumJoinUserVO.setTeamCd(vo.getTeamCd());
        forumJoinUserVO.setStdId(vo.getStdId());
        forumJoinUserVO.setRgtrId(vo.getUserId());
        forumJoinUserVO.setMdfrId(vo.getUserId());
        forumJoinUserVO.setDscsPtcpId(IdGenerator.getNewId(IdPrefixType.DSPTC.getCode()));
        try {
            forumJoinUserDAO.ensureJoinUser(forumJoinUserVO);
        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            // ORA-00001: UNIQUE 제약 위반 = row 이미 존재 → 무시하고 진행
        }
        return forumJoinUserDAO.selectProfMemo(vo);
    }

    // 교수 메모 수정
    @Override
    public void editForumProfMemo(DscsJoinUserVO vo) throws Exception {
        forumJoinUserDAO.editForumProfMemo(vo);
    }

    // 토론 참여자 페이징 목록 조회
    @Override
    public ProcessResultVO<DscsJoinUserVO> listPageing(DscsJoinUserVO vo) throws Exception {
        return this.listPaging(vo, "");
    }

    // 엑셀 성적등록 엑셀 업로드
    @Override
    public void updateExampleExcelScore(DscsJoinUserVO vo, List<?> stdNoList, String forumCtgrCd) throws Exception {
        if(stdNoList != null) {
            for (int i = 0; i < stdNoList.size(); i++) {
                Map<String, Object> stdNoMap = (Map<String, Object>)stdNoList.get(i);
                
                String userId = "";
                double score;
                if("TEAM".equals(forumCtgrCd)) {
                    userId = StringUtil.nvl((String) stdNoMap.get("C"));
                    score = Math.round(Math.floor(Double.parseDouble(StringUtil.nvl((String) stdNoMap.get("F"),"0"))));
                } else {
                    userId = StringUtil.nvl((String) stdNoMap.get("B"));
                    score = Math.round(Math.floor(Double.parseDouble(StringUtil.nvl((String) stdNoMap.get("D"),"0"))));
                }
                vo.setUserId(userId);
                vo.setScore(score);
               forumJoinUserDAO.insertStdScore(vo);
            }
        }
    }

    @Override
    public List<DscsJoinUserVO> listDscsJoinUser(DscsJoinUserVO vo) throws Exception {
        return forumJoinUserDAO.listDscsJoinUser(vo);
    }

    @Override
    public List<DscsEzGraderTeamVO> listDscsJoinTeam(DscsJoinUserVO vo) throws Exception {
        List<DscsEzGraderTeamVO> memberList = forumJoinUserDAO.listDscsJoinTeam(vo);
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
        
        return forumJoinUserDAO.getMemo(vo);
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
        
        DscsJoinUserVO forumJoinUserVO = new DscsJoinUserVO();
        forumJoinUserVO.setDscsId(vo.getDscsId());
        forumJoinUserVO.setRgtrId(vo.getRgtrId());
        forumJoinUserVO.setMdfrId(vo.getMdfrId());
        forumJoinUserVO.setTeamCd(vo.getTeamCd());

        forumJoinUserVO.setScore(vo.getScore());
        if(forumJoinUserVO.getScore() > 100) {
            // 최대 평가점수 초과 방지
            forumJoinUserVO.setScore(100.0);
        } else if(forumJoinUserVO.getScore() < 0) {
            // 최소 평가점수 미만 방지
            forumJoinUserVO.setScore(0.0);
        }

        String[] stdArr = vo.getStdIds().split(",");
        if(stdArr.length > 0) {
            for(int i = 0; i < stdArr.length; i++) {
                vo.setStdId(stdArr[i]);
                
                // 넘겨 받은 글자수에 해당하는 토론 참여자 조회
                int chkCtsLen = forumJoinUserDAO.getSelectCtsLen(vo);
                if(chkCtsLen > 0) {
                    forumJoinUserDAO.insertStdScore(vo);
                }
            }
        }
    }

    // 참여자가 없을 때 토론 참여자 테이블 삽입
	@Override
	public void chkStdNoInsert(DscsMutVO vo) throws Exception {
		forumJoinUserDAO.chkStdNoInsert(vo);
	}

	// 모든 토론 참여자를 토론 참여자 테이블에 삽입
	@Override
	public void insertJoinUser(DscsVO vo) throws Exception {
		// 1. 기존 레코드 팀 갱신 (WHEN MATCHED UPDATE)
		forumJoinUserDAO.insertJoinUser(vo);

		// 2. 미등록 학생 목록 조회 후 ID 생성하여 단건 INSERT
		List<DscsJoinUserVO> newStudents = forumJoinUserDAO.selectStudentsNotInPtcp(vo);
		for (DscsJoinUserVO student : newStudents) {
			student.setDscsPtcpId(IdGenerator.getNewId(IdPrefixType.DSPTC.getCode()));
			student.setRgtrId(vo.getRgtrId());
			student.setMdfrId(vo.getRgtrId());
			forumJoinUserDAO.insertDscsJoinUser(student);
		}
	}

	// 참여형 일괄평가
	@Override
	public void participateScore(DscsJoinUserVO vo) throws Exception {
        forumJoinUserDAO.participateScore(vo);
	}

	// 개별 평가점수
	@Override
	public void setScoreRatio(DscsJoinUserVO vo) throws Exception {
		DscsJoinUserVO forumJoinUserVO = new DscsJoinUserVO();
		forumJoinUserVO.setDscsId(vo.getDscsId());
		forumJoinUserVO.setRgtrId(vo.getRgtrId());
		forumJoinUserVO.setMdfrId(vo.getMdfrId());
		forumJoinUserVO.setTeamCd(vo.getTeamCd());
		forumJoinUserVO.setStdId(vo.getStdId());
		forumJoinUserVO.setScore(vo.getScore());
		forumJoinUserVO.setUserId(vo.getUserId());
		forumJoinUserVO.setCrsCreCd(vo.getCrsCreCd());

		forumJoinUserDAO.insertStdScore(forumJoinUserVO);
	}

}
