package knou.lms.score.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.context.MessageSource;

import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.score.dao.ScoreConfDAO;
import knou.lms.score.service.ScoreConfService;
import knou.lms.score.vo.ScoreConfVO;


@Service("scoreConfService")
public class ScoreConfServiceImpl  implements ScoreConfService {

    @Resource(name="scoreConfDAO")
    private ScoreConfDAO scoreConfDAO;

    @Resource(name="messageSource")
    private MessageSource messageSource;

    /**
     * 성적환산등급 목록 조회
     * 
     * @param scoreConfVO
     * @return ResultVO
     * @throws Exception
     */
    @Override
    public List<ScoreConfVO> selectConvertCClassList(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectConvertCClassList(vo);
    }
    
    @Override
    public List<ScoreConfVO> selectConvertGClassList(ScoreConfVO vo) throws Exception {
    	return scoreConfDAO.selectConvertGClassList(vo);
    }
    
    public List<ScoreConfVO> editConvertClassView(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.editConvertClassView(vo);
    }
    
    /**
     * 성적환산등급 목록 수정
     * 
     * @param scoreConfVO
     * @return ResultVO
     * @throws Exception
     */
    @Override
    public void editConvertClass(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editConvertClass(vo);
    }

    // 사용여부 수정
    @Override
    public ProcessResultVO<ScoreConfVO> editConvertUseYn(ScoreConfVO vo) {
        ProcessResultVO<ScoreConfVO> resultVO = new ProcessResultVO<ScoreConfVO>();

        try {
            scoreConfDAO.editConvertUseYn(vo);

            resultVO.setResult(1);
            resultVO.setMessage("사용여부를 수정하였습니다.");
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("사용여부를 수정하지 못하였습니다.");
        }

        return resultVO;
    }
    
    /**
     * 상대평가비율 목록 조회
     * 
     * @param scoreConfVO
     * @return ResultVO
     * @throws Exception
     */
    @Override
    public List<ScoreConfVO> selectRelativeCClassList(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectRelativeCClassList(vo);
    }
    
    @Override
    public List<ScoreConfVO> selectRelativeGClassList(ScoreConfVO vo) throws Exception {
    	return scoreConfDAO.selectRelativeGClassList(vo);
    }
    
    public List<ScoreConfVO> editRelativeClassView(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.editRelativeClassView(vo);
    }
    
    /**
     * 상대평가비율 목록 수정
     * 
     * @param scoreConfVO
     * @return ResultVO
     * @throws Exception
     */
    @Override
    public void editRelativeClass(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editRelativeClass(vo);
    }
    
    // 사용여부 수정
    @Override
    public ProcessResultVO<ScoreConfVO> editRelativeUseYn(ScoreConfVO vo) {
        ProcessResultVO<ScoreConfVO> resultVO = new ProcessResultVO<ScoreConfVO>();

        try {
            scoreConfDAO.editRelativeUseYn(vo);

            resultVO.setResult(1);
            resultVO.setMessage("사용여부를 수정하였습니다.");
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("사용여부를 수정하지 못하였습니다.");
        }

        return resultVO;
    }
    
    @Override
    public ScoreConfVO selectAttendOpenClassWeek(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectAttendOpenClassWeek(vo);
    }
    @Override
    public ScoreConfVO selectAttendOpenClassTm(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectAttendOpenClassTm(vo);
    }
    @Override
    public ScoreConfVO selectAttendOpenClassWeekAp(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectAttendOpenClassWeekAp(vo);
    }
    @Override
    public ScoreConfVO selectAttendOpenClassWeekTm(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectAttendOpenClassWeekTm(vo);
    }
    
    /**
     * 출석점수기준 출석인정기간 정보 조회
     * 
     * @param ScoreConfVO vo
     * @return List
     * @throws Exception
     */
    @Override
    public ScoreConfVO selectAttendAnceClassTerm(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectAttendAnceClassTerm(vo);
    }
    @Override
    public ScoreConfVO selectAttendAnceClassTermWeek(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectAttendAnceClassTermWeek(vo);
    }
    
    /**
     * 출석점수기준 강의 출석/지각/결석 기준(정규학기) 정보 조회
     * 
     * @param ScoreConfVO vo
     * @return List
     * @throws Exception
     */
    @Override
    public ScoreConfVO selectAttendRatioRegularClass(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectAttendRatioRegularClass(vo);
    }
    @Override
    public ScoreConfVO selectLateRatioRegularClass(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectLateRatioRegularClass(vo);
    }
    @Override
    public ScoreConfVO selectAbsentRatioRegularClass(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectAbsentRatioRegularClass(vo);
    }
    
    /**
     * 출석점수기준 강의 출석/지각/결석 기준(계절학기) 정보 조회
     * 
     * @param ScoreConfVO vo
     * @return List
     * @throws Exception
     */
    @Override
    public ScoreConfVO selectAbsentRatioSeasonClass(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectAbsentRatioSeasonClass(vo);
    }
    @Override
    public ScoreConfVO selectAtndRatioSeasonClass(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectAtndRatioSeasonClass(vo);
    }
    @Override
    public ScoreConfVO selectAtndWeekSeasonClass(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectAtndWeekSeasonClass(vo);
    }
    @Override
    public ScoreConfVO selectWeek1SeasonClass(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectWeek1SeasonClass(vo);
    }
    @Override
    public ScoreConfVO selectWeek2SeasonClass(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectWeek2SeasonClass(vo);
    }
    @Override
    public ScoreConfVO selectWeek3SeasonClass(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectWeek3SeasonClass(vo);
    }
    @Override
    public ScoreConfVO selectWeek4SeasonClass(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectWeek4SeasonClass(vo);
    }

    /**
     * 출석점수기준 강의 출석평가기준, 지각감점기준 정보 조회
     * 
     * @param ScoreConfVO vo
     * @return List
     * @throws Exception
     */
    @Override
    public ScoreConfVO selectAbsentScoreClass(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectAbsentScoreClass(vo);
    }
    @Override
    public ScoreConfVO selectLateScoreClass(ScoreConfVO vo) throws Exception{
        return scoreConfDAO.selectLateScoreClass(vo);
    }

    // 출석점수기준 강의오픈일 수정
    @Override
    public void editAttendOpenClassWeek(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAttendOpenClassWeek(vo);
    }

    // 출석점수기준 강의오픈시간 수정
    @Override
    public void editAttendOpenClassTm(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAttendOpenClassTm(vo);
    }

    // 출석점수기준 강의1주 오픈일 수정
    @Override
    public void editAttendOpenClassWeekAp(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAttendOpenClassWeekAp(vo);
    }

    // 출석점수기준 강의1주 오픈 시간 수정
    @Override
    public void editAttendOpenClassWeekTm(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAttendOpenClassWeekTm(vo);
    }

    // 출석점수기준 출석인정기간 주차 수정
    @Override
    public void editAttendAnceClassTerm(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAttendAnceClassTerm(vo);
    }

    // 출석점수기준 출석인정기간 1주차 수정
    @Override
    public void editAttendAnceClassTermWeek(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAttendAnceClassTermWeek(vo);
    }

    // 출석점수기준 강의 출석률(정규학기) 수정
    @Override
    public void editAttendRatioRegularClass(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAttendRatioRegularClass(vo);
    }

    // 출석점수기준 강의 지각률(정규학기) 수정
    @Override
    public void editLateRatioRegularClass(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editLateRatioRegularClass(vo);
    }

    // 출석점수기준 강의 결석률(정규학기) 수정
    @Override
    public void editAbsentRatioRegularClass(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAbsentRatioRegularClass(vo);
    }

    // 출석점수기준 강의 계절학기 출석주차 수정
    @Override
    public void editAtndWeekSeasonClass(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAtndWeekSeasonClass(vo);
    }

    // 출석점수기준 강의 계절학기 출석비율 수정
    @Override
    public void editAtndRatioSeasonClass(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAtndRatioSeasonClass(vo);
    }

    // 출석점수기준 강의 계절학기 결석비율 정보 수정
    @Override
    public void editAbsentRatioSeasonClass(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAbsentRatioSeasonClass(vo);
    }

    // 출석점수기준 강의 계절학기 1주차 강의수 수정
    @Override
    public void editWeek1SeasonClass(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editWeek1SeasonClass(vo);
    }

    // 출석점수기준 강의 계절학기 2주차 강의수 수정
    @Override
    public void editWeek2SeasonClass(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editWeek2SeasonClass(vo);
    }

    // 출석점수기준 강의 계절학기 3주차 강의수 수정
    @Override
    public void editWeek3SeasonClass(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editWeek3SeasonClass(vo);
    }

    // 출석점수기준 강의 계절학기 4주차 강의수 수정 
    @Override
    public void editWeek4SeasonClass(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editWeek4SeasonClass(vo);
    }

    // 출석점수기준 강의 출석평가 정보 수정    
    @Override
    public void editAbsentScoreClass5(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAbsentScoreClass5(vo);
    }
    @Override
    public void editAbsentScoreClass4(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAbsentScoreClass4(vo);
    }
    @Override
    public void editAbsentScoreClass3(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAbsentScoreClass3(vo);
    }
    @Override
    public void editAbsentScoreClass2(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAbsentScoreClass2(vo);
    }
    @Override
    public void editAbsentScoreClass1(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editAbsentScoreClass1(vo);
    }
    
    // 출석점수기준 강의 지각감전기준 정보 수정
    @Override
    public void editLateScoreClass1(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editLateScoreClass1(vo);
    }
    @Override
    public void editLateScoreClass2(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editLateScoreClass2(vo);
    }
    @Override
    public void editLateScoreClass3(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editLateScoreClass3(vo);
    }
    @Override
    public void editLateScoreClass4(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editLateScoreClass4(vo);
    }
    @Override
    public void editLateScoreClass5(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editLateScoreClass5(vo);
    }
    @Override
    public void editLateScoreClass6(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editLateScoreClass6(vo);
    }
    @Override
    public void editLateScoreClass7(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editLateScoreClass7(vo);
    }
    
    /**
     * 세미나 출석기준
     * 
     * @param ScoreConfVO vo
     * @return List
     * @throws Exception
     */
    // 출석 비율
    @Override
    public ScoreConfVO selectSeminarRatio(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectSeminarRatio(vo);
    }
    // 출석 시간
    @Override
    public ScoreConfVO selectSeminarTm(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectSeminarTm(vo);
    }
    // 지각 비율
    @Override
    public ScoreConfVO selectSeminarLateRatio(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectSeminarLateRatio(vo);
    }
    // 지각 시간
    @Override
    public ScoreConfVO selectSeminarLateTm(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectSeminarLateTm(vo);
    }
    // 결석 비율
    @Override
    public ScoreConfVO selectSeminarAbsentRatio(ScoreConfVO vo) throws Exception {
        return scoreConfDAO.selectSeminarAbsentRatio(vo);
    }

    // 출석비율 수정
    @Override   
    public void editSeminarAtndRatio(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editSeminarAtndRatio(vo);
    }
    // 출석시간 수정
    @Override
    public void editSeminarAtndTm(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editSeminarAtndTm(vo);
    }
    // 지각비율 수정
    @Override
    public void editSeminarLateRatio(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editSeminarLateRatio(vo);
    }
    // 지각시간 수정
    @Override
    public void editSeminarLateTm(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editSeminarLateTm(vo);
    }
    // 결석비율 수정
    @Override
    public void editSeminarAbsentRatio(ScoreConfVO vo) throws Exception {
        scoreConfDAO.editSeminarAbsentRatio(vo);
    }

    // 등록된 등급 조회
	@Override
	public List<ScoreConfVO> selectCRelCdLList(ScoreConfVO vo) throws Exception {
		return scoreConfDAO.selectCRelCdLList(vo);
	}

	// 등록된 등급 조회
	@Override
	public List<ScoreConfVO> selectGRelCdLList(ScoreConfVO vo) throws Exception {
		return scoreConfDAO.selectGRelCdLList(vo);
	}

   

}
