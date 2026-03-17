package knou.lms.forum2.service.impl;

import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.dao.ForumFdbkDAO;
import knou.lms.forum2.dao.ForumJoinUserDAO;
import knou.lms.forum2.service.ForumJoinUserService;
import knou.lms.forum.vo.*;
import knou.lms.std.dao.StdDAO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Service("forum2JoinUserService")
public class ForumJoinUserServiceImpl extends ServiceBase implements ForumJoinUserService {
    
    @Resource(name="forum2JoinUserDAO")
    private ForumJoinUserDAO forumJoinUserDAO;
    
    @Resource(name="forum2FdbkDAO")
    private ForumFdbkDAO forumFdbkDAO;
    
    @Resource(name = "stdDAO")
    private StdDAO stdDAO;

    /*****************************************************
     * <p>
     * TODO 토론 현황 조회
     * </p>
     * 토론 현황 조회
     * 
     * @param ForumJoinUserVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectForumScoreStatus(ForumJoinUserVO vo) throws Exception {
        return forumJoinUserDAO.selectForumScoreStatus(vo);
    }
    
    /*****************************************************
     * 토론 참여 목록 조회
     * @param ForumJoinUserVO
     * @return List<ForumJoinUserVO>
     * @throws Exception
     ******************************************************/
    public List<ForumJoinUserVO> list(ForumJoinUserVO vo) throws Exception {
        vo.setPagingYn("N");
        return forumJoinUserDAO.listPaging(vo);
    }
    
    /*****************************************************
     * <p>
     * 토론 참여 목록 조회
     * </p>
     * 토론 참여 목록 조회
     * 
     * @param ForumJoinUserVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ForumJoinUserVO> listPaging(ForumJoinUserVO vo) throws Exception {
        
        /** start of paging */
        PagingInfo paginationInfo = new PagingInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        List<ForumJoinUserVO> forumJoinUserList = forumJoinUserDAO.listPaging(vo);

        if(forumJoinUserList.size() > 0) {
            paginationInfo.setTotalRecordCount(forumJoinUserList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<ForumJoinUserVO> resultVO = new ProcessResultVO<>();
        
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
     * @param ForumJoinUserVO
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void updateForumJoinUserScore(ForumJoinUserVO vo) throws Exception {
        List<String> listTargetStdId = Arrays.asList(StringUtil.nvl(vo.getStdIds()).split(","));
        if("".equals(listTargetStdId.get(0))) {
            listTargetStdId = null;
        }
        
        if(!"checked".equals(StringUtil.nvl(vo.getConditionType(),""))) {
            listTargetStdId = null;
        }
        
        ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
        forumJoinUserVO.setForumCd(vo.getForumCd());
        forumJoinUserVO.setRgtrId(vo.getRgtrId());
        forumJoinUserVO.setMdfrId(vo.getMdfrId());
        forumJoinUserVO.setTeamCd(vo.getTeamCd());
        
        ForumJoinUserVO selectJoinUserVO = new ForumJoinUserVO();
        selectJoinUserVO.setForumCd(vo.getForumCd());
        selectJoinUserVO.setCrsCreCd(vo.getCrsCreCd());
        selectJoinUserVO.setStdIdList(listTargetStdId);
        selectJoinUserVO.setConditionType(vo.getConditionType());
        List<ForumJoinUserVO> joinUserList = forumJoinUserDAO.listStdScore(selectJoinUserVO);

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
                ForumJoinUserVO joinUserVO = joinUserList.get(i);
                String stdNo = StringUtil.nvl(joinUserVO.getStdId());
//                String teamCd = StringUtil.nvl(joinUserVO.getTeamCd());
                int preScore = Integer.parseInt(StringUtil.nvl(joinUserVO.getScore()));
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
                ForumFdbkVO forumFdbkVO = new ForumFdbkVO();
                forumFdbkVO.setForumCd(vo.getForumCd());
                forumFdbkVO.setStdId(stdNo);
                forumFdbkVO.setRgtrId(vo.getRgtrId());
                forumFdbkVO.setMdfrId(vo.getMdfrId());
                if(!"".equals(forumFdbkCd)) {
                    forumFdbkVO.setForumFdbkCd(forumFdbkCd);
                    // 피드백 수정
                    if(!"".equals(fdbkCts)) {
                        forumFdbkVO.setFdbkCts(fdbkCts);
                        forumFdbkDAO.updateForumFdbk(forumFdbkVO);
                    // 피드백 삭제
                    } else {
                        forumFdbkDAO.deleteForumFdbk(forumFdbkVO);
                    }
                } else {
                    // 피드백 등록
                    if(!"".equals(fdbkCts)) {
                        forumFdbkCd = IdGenerator.getNewId("FFDBK");
                        forumFdbkVO.setForumFdbkCd(forumFdbkCd);
                        forumFdbkVO.setFdbkCts(fdbkCts);
                        forumFdbkVO.setDelYn("N");
                        forumFdbkDAO.insertForumFdbk(forumFdbkVO);
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
     * @param ForumJoinUserVO
     * @return ForumJoinUserVO
     * @throws Exception
     ******************************************************/
    @Override
    public ForumJoinUserVO selectForumJoinUser(ForumJoinUserVO vo) throws Exception {
        return forumJoinUserDAO.selectForumJoinUser(vo);
    }

    // 성적분포현황차트
    @Override
    public List<?> forumJoinUserList(ForumJoinUserVO vo) throws Exception {
        return forumJoinUserDAO.forumJoinUserList(vo);
    }

    // 성적평가 성적 등록
    @Override
    public void addStdScore(ForumJoinUserVO vo) throws Exception {
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
    public ForumJoinUserVO selectProfMemo(ForumJoinUserVO vo) throws Exception {
        int cnt = forumJoinUserDAO.getForumJoinUser(vo);
        if(cnt == 0) {
            // 토론 참여자(tb_lms_forum_join_user) 테이블에 등록
            ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
            forumJoinUserVO.setScore(null);
            forumJoinUserVO.setForumCd(vo.getForumCd());
            forumJoinUserVO.setTeamCd(vo.getTeamCd());
            forumJoinUserVO.setStdId(vo.getStdId());
            forumJoinUserVO.setRgtrId(vo.getUserId());
            forumJoinUserVO.setMdfrId(vo.getUserId());
            forumJoinUserDAO.insertStdScore(forumJoinUserVO);
        }
        return forumJoinUserDAO.selectProfMemo(vo);
    }

    // 교수 메모 수정
    @Override
    public void editForumProfMemo(ForumJoinUserVO vo) throws Exception {
        forumJoinUserDAO.editForumProfMemo(vo);
    }

    // 토론 참여자 페이징 목록 조회
    @Override
    public ProcessResultVO<ForumJoinUserVO> listPageing(ForumJoinUserVO vo) throws Exception {
        return this.listPaging(vo);
    }

    // 엑셀 성적등록 엑셀 업로드
    @Override
    public void updateExampleExcelScore(ForumJoinUserVO vo, List<?> stdNoList, String forumCtgrCd) throws Exception {
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
    public List<ForumJoinUserVO> listForumJoinUser(ForumJoinUserVO vo) throws Exception {
        return forumJoinUserDAO.listForumJoinUser(vo);
    }

    @Override
    public List<ForumEzGraderTeamVO> listForumJoinTeam(ForumJoinUserVO vo) throws Exception {
        List<ForumEzGraderTeamVO> memberList = forumJoinUserDAO.listForumJoinTeam(vo);
        if(memberList != null && !memberList.isEmpty() && memberList.size() > 0) {
            for(ForumEzGraderTeamVO teamVo : memberList) {
                String teamStdNos = "";
                if (teamVo.getTeamMembers() != null && !teamVo.getTeamMembers().isEmpty() && teamVo.getTeamMembers().size() > 0) {
                    int idx = 0;
                    for(ForumJoinUserVO joinUserVo : teamVo.getTeamMembers()) {
                        if (idx > 0 ) {
                            teamStdNos += ",";
                        }
                        teamStdNos += joinUserVo.getStdId();
                        idx++;
                    }
                }
                teamVo.setTeamStdNos(teamStdNos);
            }
        }
        return memberList;
    }

    // 메모
    @Override
    public ForumJoinUserVO getMemo(ForumVO vo) throws Exception {
        
        return forumJoinUserDAO.getMemo(vo);
    }

    // 글자수로 점수 주기
    @Override
    public void updateForumJoinUserLenScore(ForumJoinUserVO vo) throws Exception {
        List<String> listTargetStdId = Arrays.asList(StringUtil.nvl(vo.getStdIds()).split(","));
        if("".equals(listTargetStdId.get(0))) {
            listTargetStdId = null;
        }
        
        if(!"checked".equals(StringUtil.nvl(vo.getConditionType(),""))) {
            listTargetStdId = null;
        }
        
        ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
        forumJoinUserVO.setForumCd(vo.getForumCd());
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
	public void chkStdNoInsert(ForumMutVO vo) throws Exception {
		forumJoinUserDAO.chkStdNoInsert(vo);
	}

	// 모든 토론 참여자를 토론 참여자 테이블에 삽입
	@Override
	public void insertJoinUser(ForumVO vo) throws Exception {
		forumJoinUserDAO.insertJoinUser(vo);
	}

	// 참여형 일괄평가
	@Override
	public void participateScore(ForumJoinUserVO vo) throws Exception {
        forumJoinUserDAO.participateScore(vo);
	}

	// 개별 평가점수
	@Override
	public void setScoreRatio(ForumJoinUserVO vo) throws Exception {
		ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
		forumJoinUserVO.setForumCd(vo.getForumCd());
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
