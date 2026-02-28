package knou.lms.score.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.score.vo.ScoreConfVO;

public interface ScoreConfService {

    /**
     * 성적환산등급 목록 조회
     * 
     * @param scoreConfVO
     * @return ProcessResultVO
     * @throws Exception
     */
    public List<ScoreConfVO> selectConvertCClassList(ScoreConfVO vo) throws Exception;
    public List<ScoreConfVO> selectConvertGClassList(ScoreConfVO vo) throws Exception;
    public List<ScoreConfVO> editConvertClassView(ScoreConfVO vo) throws Exception;
    public void editConvertClass(ScoreConfVO vo) throws Exception;
    public ProcessResultVO<ScoreConfVO> editConvertUseYn(ScoreConfVO vo)throws Exception;
    
    /**
     * 상대평가비율 목록 조회
     * 
     * @param scoreConfVO
     * @return ProcessResultVO
     * @throws Exception
     */
    public List<ScoreConfVO> selectRelativeCClassList(ScoreConfVO vo) throws Exception;
    public List<ScoreConfVO> selectRelativeGClassList(ScoreConfVO vo) throws Exception;
    public List<ScoreConfVO> editRelativeClassView(ScoreConfVO vo) throws Exception;
    public void editRelativeClass(ScoreConfVO vo) throws Exception;
    public ProcessResultVO<ScoreConfVO> editRelativeUseYn(ScoreConfVO vo)throws Exception;

    /**
     * 출석점수기준 강의오픈일 정보 조회
     * 
     * @param ScoreConfVO vo
     * @return List
     * @throws Exception
     */
    public ScoreConfVO selectAttendOpenClassWeek(ScoreConfVO vo) throws Exception;
    public ScoreConfVO selectAttendOpenClassTm(ScoreConfVO vo) throws Exception;
    public ScoreConfVO selectAttendOpenClassWeekAp(ScoreConfVO vo) throws Exception;
    public ScoreConfVO selectAttendOpenClassWeekTm(ScoreConfVO vo) throws Exception;
    
    /**
     * 출석점수기준 출석인정기간 정보 조회
     * 
     * @param ScoreConfVO vo
     * @return List
     * @throws Exception
     */
    public ScoreConfVO selectAttendAnceClassTerm(ScoreConfVO vo) throws Exception;
    public ScoreConfVO selectAttendAnceClassTermWeek(ScoreConfVO vo) throws Exception;
    
    /**
     * 출석점수기준 강의 출석/지각/결석 기준(정규학기) 정보 조회
     * 
     * @param ScoreConfVO vo
     * @return List
     * @throws Exception
     */
    public ScoreConfVO selectAttendRatioRegularClass(ScoreConfVO vo) throws Exception;
    public ScoreConfVO selectLateRatioRegularClass(ScoreConfVO vo) throws Exception;
    public ScoreConfVO selectAbsentRatioRegularClass(ScoreConfVO vo) throws Exception;
    
    /**
     * 출석점수기준 강의 출석/지각/결석 기준(계절학기) 정보 조회
     * 
     * @param ScoreConfVO vo
     * @return List
     * @throws Exception
     */
    public ScoreConfVO selectAtndRatioSeasonClass(ScoreConfVO vo) throws Exception;
    public ScoreConfVO selectAbsentRatioSeasonClass(ScoreConfVO vo) throws Exception;
    public ScoreConfVO selectAtndWeekSeasonClass(ScoreConfVO vo) throws Exception;
    public ScoreConfVO selectWeek1SeasonClass(ScoreConfVO vo) throws Exception;
    public ScoreConfVO selectWeek2SeasonClass(ScoreConfVO vo) throws Exception;
    public ScoreConfVO selectWeek3SeasonClass(ScoreConfVO vo) throws Exception;
    public ScoreConfVO selectWeek4SeasonClass(ScoreConfVO vo) throws Exception;
    
    /**
     * 출석점수기준 강의 출석평가기준, 지각감점기준 정보 조회
     * 
     * @param ScoreConfVO vo
     * @return List
     * @throws Exception
     */
    public ScoreConfVO selectAbsentScoreClass(ScoreConfVO vo) throws Exception;
    public ScoreConfVO selectLateScoreClass(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의오픈일 수정
    public void editAttendOpenClassWeek(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의오픈시간 수정 
    public void editAttendOpenClassTm(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의1주 오픈일 수정 
    public void editAttendOpenClassWeekAp(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의1주 오픈 시간 수정 
    public void editAttendOpenClassWeekTm(ScoreConfVO vo) throws Exception;

    // 출석점수기준 출석인정기간 주차 수정 
    public void editAttendAnceClassTerm(ScoreConfVO vo) throws Exception;

    // 출석점수기준 출석인정기간 1주차 수정 
    public void editAttendAnceClassTermWeek(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의 출석률(정규학기) 수정 
    public void editAttendRatioRegularClass(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의 지각률(정규학기) 수정 
    public void editLateRatioRegularClass(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의 결석률(정규학기) 수정 
    public void editAbsentRatioRegularClass(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의 계절학기 출석주차 수정 
    public void editAtndWeekSeasonClass(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의 계절학기 출석비율 수정 
    public void editAtndRatioSeasonClass(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의 계절학기 결석비율 정보 수정 
    public void editAbsentRatioSeasonClass(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의 계절학기 1주차 강의수 수정 
    public void editWeek1SeasonClass(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의 계절학기 2주차 강의수 수정 
    public void editWeek2SeasonClass(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의 계절학기 3주차 강의수 수정 
    public void editWeek3SeasonClass(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의 계절학기 4주차 강의수 수정 
    public void editWeek4SeasonClass(ScoreConfVO vo) throws Exception;

    // 출석점수기준 강의 출석평가 정보 수정
    public void editAbsentScoreClass5(ScoreConfVO vo) throws Exception;
    public void editAbsentScoreClass4(ScoreConfVO vo) throws Exception;
    public void editAbsentScoreClass3(ScoreConfVO vo) throws Exception;
    public void editAbsentScoreClass2(ScoreConfVO vo) throws Exception;
    public void editAbsentScoreClass1(ScoreConfVO vo) throws Exception;
    
    // 출석점수기준 강의 지각감전기준 정보 수정
    public void editLateScoreClass1(ScoreConfVO vo) throws Exception;
    public void editLateScoreClass2(ScoreConfVO vo) throws Exception;
    public void editLateScoreClass3(ScoreConfVO vo) throws Exception;
    public void editLateScoreClass4(ScoreConfVO vo) throws Exception;
    public void editLateScoreClass5(ScoreConfVO vo) throws Exception;
    public void editLateScoreClass6(ScoreConfVO vo) throws Exception;
    public void editLateScoreClass7(ScoreConfVO vo) throws Exception;
    
    /**
     * 세미나-출석인정
     * 
     * @param ScoreConfVO vo
     * @return List
     * @throws Exception
     */
    // 출석비율
    public ScoreConfVO selectSeminarRatio(ScoreConfVO vo) throws Exception;
    // 출석시간
    public ScoreConfVO selectSeminarTm(ScoreConfVO vo) throws Exception;
    // 지각비율
    public ScoreConfVO selectSeminarLateRatio(ScoreConfVO vo) throws Exception;
    // 지각시간
    public ScoreConfVO selectSeminarLateTm(ScoreConfVO vo) throws Exception;
    //결석비율
    public ScoreConfVO selectSeminarAbsentRatio(ScoreConfVO vo) throws Exception;

    // 출석비율 수정
    public void editSeminarAtndRatio(ScoreConfVO vo) throws Exception;
    // 출석시간 수정
    public void editSeminarAtndTm(ScoreConfVO vo) throws Exception;
    // 지각비율 수정
    public void editSeminarLateRatio(ScoreConfVO vo) throws Exception;
    // 지각시간 수정
    public void editSeminarLateTm(ScoreConfVO vo) throws Exception;
    // 결석비율 수정
    public void editSeminarAbsentRatio(ScoreConfVO vo) throws Exception;
    // 등록된 등급 조회
	public List<ScoreConfVO> selectCRelCdLList(ScoreConfVO vo) throws Exception;
	public List<ScoreConfVO> selectGRelCdLList(ScoreConfVO vo) throws Exception;
}
