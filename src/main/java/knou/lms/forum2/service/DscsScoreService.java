package knou.lms.forum2.service;

import java.util.HashMap;
import java.util.Map;

import knou.framework.context2.UserContext;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsVO;

// 교수자 점수관리 화면의 참여자 보정, 점수 요약, 엑셀 처리 흐름을 담당한다.
public interface DscsScoreService {

    // 점수관리 화면 진입 시 토론 참여자 기준 데이터를 보정한다.
    void ensureScoreManageJoinUsers(DscsVO dscsVO, String userId);
    // 교수자 성적관리 참여자 목록 조회
    ProcessResultVO<DscsJoinUserVO> listScoreJoinUsers(DscsJoinUserVO vo);
    // 교수자 성적관리 점수 저장
    ProcessResultVO<DefaultVO> updateScore(DscsJoinUserVO vo, String userId);
    // 교수자 성적관리 글길이 점수 반영
    ProcessResultVO<DefaultVO> updateLenScore(DscsJoinUserVO vo, String userId);
    // 성적분포 차트 조회
    ProcessResultVO<HashMap<String, Object>> scoreSummaryChart(DscsVO vo);
    // 차트와 화면 표시용 최소/최대/평균 점수를 계산한다.
    Map<String, Integer> calculateScoreSummary(String dscsId);
    // 참여점수 반영
    ProcessResultVO<DefaultVO> participateScore(DscsJoinUserVO vo, String userId);
    // 점수 비율 반영
    ProcessResultVO<DefaultVO> setScoreRatio(DscsJoinUserVO vo, String userId);
    // 업로드된 점수 엑셀 파일을 읽어 참여자 점수에 반영한다.
    ProcessResultVO<DscsJoinUserVO> uploadScoreExcel(DscsJoinUserVO dscsJoinUserVO, UserContext userCtx);
}
