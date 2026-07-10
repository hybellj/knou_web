package knou.lms.forum2.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsVO;

public interface DscsJoinUserService {

    // 토론 참여자 목록을 페이징 조건에 맞게 조회한다.
    public ProcessResultVO<DscsJoinUserVO> listPaging(DscsJoinUserVO vo);
    // 선택된 토론 참여자의 점수를 일괄/가감/개별 방식으로 반영한다.
    public void updateDscsJoinUserScore(DscsJoinUserVO vo);
    // 점수관리/간편채점에서 사용할 토론 참여자 데이터를 준비한다.
    public void prepareJoinUsersForScoring(DscsVO vo);
    // 토론 참여자 단건 정보를 조회한다.
    public DscsJoinUserVO selectDscsJoinUser(DscsJoinUserVO vo);
    // 성적분포 차트 등에 사용할 토론 참여자 목록을 조회한다.
    public List<?> dscsJoinUserList(DscsJoinUserVO vo);
    // 교수 메모 팝업에 표시할 참여자 정보와 메모를 조회한다.
    public DscsJoinUserVO selectProfMemo(DscsJoinUserVO vo);
    // 교수 메모를 저장한다.
    public void editDscsProfMemo(DscsJoinUserVO vo);
    // 업로드된 엑셀 점수를 토론 참여자 점수에 반영한다.
    public void updateExampleExcelScore(DscsJoinUserVO vo, List<?> stdNoList, String dscsUnitTycd);
    // 간편채점에서 사용할 메모 정보를 조회한다.
    public DscsJoinUserVO getMemo(DscsVO vo);
    // 글자수 조건을 만족한 참여자에게 점수를 반영한다.
    public void updateDscsJoinUserLenScore(DscsJoinUserVO vo);
    // 참여 여부 기준으로 참여자 점수를 일괄 반영한다.
    public void participateScore(DscsJoinUserVO vo);
    // 개별 참여자 점수를 반영한다.
    public void setScoreRatio(DscsJoinUserVO vo);
}
