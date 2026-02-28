package knou.lms.score.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.SessionBrokenException;
import knou.framework.util.StringUtil;
import knou.framework.util.URLBuilder;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.score.service.ScoreConfService;
import knou.lms.score.vo.ScoreConfVO;


@Controller
@RequestMapping(value= {"/score/scoreConf"})
public class ScoreConfController  extends ControllerBase {

    private static final Logger logger = LoggerFactory.getLogger(ScoreConfController.class);
    
    /** MessageSource */
    @Resource(name = "messageSource")
    private MessageSource messageSource;

    /**
     * ScoreConfService Service
     */
    @Resource(name = "scoreConfService")
    private ScoreConfService scoreConfService;

    // 성적환산등급 목록
    // tb_lms_score_grade_conf 성적환산등급
    @RequestMapping(value = "/convertClassList.do")
    public String convertClassListForm(ScoreConfVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
    	String tabOrd = StringUtil.nvl(vo.getTabOrd(), "C");
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        vo.setOrgId(orgId);
        List<ScoreConfVO> convertCClassList = scoreConfService.selectConvertCClassList(vo);
        model.addAttribute("convertCClassList", convertCClassList);
        List<ScoreConfVO> convertGClassList = scoreConfService.selectConvertGClassList(vo);
        model.addAttribute("convertGClassList", convertGClassList);
        
        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항
        
        String page = "score/conf/convertClassList";

        model.addAttribute("tabOrd", tabOrd);
        return page;
    }

    // 성적환산등급 수정 페이지
    // tb_lms_score_grade_conf 성적환산등급
    @RequestMapping(value = "/editConvertClass.do")
    public String editConvertClassForm(ScoreConfVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        List<ScoreConfVO> editConvertClassView = scoreConfService.editConvertClassView(vo);
        model.addAttribute("editConvertClassView", editConvertClassView);

        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항
        
        String page = "score/conf/convertClassWrite";

        return page;
    }
    
    // 성적환산등급 수정 Ajax
    @RequestMapping(value = "/editConvertClassAjax.do")
    @ResponseBody
    public ProcessResultVO<ScoreConfVO> editConvertClassAjax(ScoreConfVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreConfVO> resultVO = new ProcessResultVO<>();
    	
    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));
    	
    	try {
    		String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
    		String[] scorCds = StringUtil.nvl(vo.getScorCds()).split("\\|");
    		
			String[] avgScors = StringUtil.nvl(vo.getAvgScors()).split("\\|");
			String[] baseScors = StringUtil.nvl(vo.getBaseScors()).split("\\|");
			String[] startScors = StringUtil.nvl(vo.getStartScors()).split("\\|");
			String[] endScors = StringUtil.nvl(vo.getEndScors()).split("\\|");
			if(avgScors.length > 0 && !"".equals(avgScors[0])) {
				for(int i = 0; i < avgScors.length; i++) {
					vo.setOrgId(orgId);
					vo.setScorCd(scorCds[i]);
					vo.setUniCd(vo.getUniCd());
					vo.setAvgScor(Float.parseFloat(avgScors[i]));
					vo.setBaseScor(Float.parseFloat(baseScors[i]));
					vo.setStartScor(Float.parseFloat(startScors[i]));
					vo.setEndScor(Float.parseFloat(endScors[i]));
					vo.setMdfrId(userId);
					
					scoreConfService.editConvertClass(vo);
				}
			}
			resultVO.setResult(1);
		} catch (Exception e) {
			resultVO.setResult(-1);
		}
    	return resultVO;
    }
    
    // 성적환산등급 수정
    // tb_lms_score_grade_conf 성적환산등급
    @RequestMapping(value="/editConvert.do")
    public String editConvertClass(ScoreConfVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);
        
        scoreConfService.editConvertClass(vo);
        
        return "redirect:"+new URLBuilder("score/scoreConf", "/convertClassList.do",request).toString();
    }
    
    // 성적환산등급 사용여부수정
    // tb_lms_score_grade_conf 성적환산등급
    @RequestMapping(value="/editConvertUseYn.do" )
    @ResponseBody
    public ProcessResultVO<ScoreConfVO> editConvertUseYn(HttpServletRequest request, HttpServletResponse response, ModelMap model, ScoreConfVO vo) throws Exception {
        
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
//        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setMdfrId(userId);
//        vo.setOrgId(orgId);
        
        return scoreConfService.editConvertUseYn(vo);
    }

    // 상대평가비율 목록
    // tb_lms_score_rel_conf 성적 상대평가비율 기준
    @RequestMapping(value = "/relativeClassList.do")
    public String relativeClassListForm(ScoreConfVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

    	String tabOrd = StringUtil.nvl(vo.getTabOrd(), "C");
        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        vo.setOrgId(orgId);
        // 등록된 등급 조회
        List<ScoreConfVO> relativeCRelCdList = scoreConfService.selectCRelCdLList(vo);
        model.addAttribute("relativeCRelCdList", relativeCRelCdList);
        List<ScoreConfVO> relativeGRelCdList = scoreConfService.selectGRelCdLList(vo);
        model.addAttribute("relativeGRelCdList", relativeGRelCdList);
        
        List<ScoreConfVO> relativeCClassList = scoreConfService.selectRelativeCClassList(vo);
        model.addAttribute("relativeCClassList", relativeCClassList);
        List<ScoreConfVO> relativeGClassList = scoreConfService.selectRelativeGClassList(vo);
        model.addAttribute("relativeGClassList", relativeGClassList);

        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항
        
        String page = "score/conf/relativeClassList";

        model.addAttribute("tabOrd", tabOrd);
        return page;
    }

    // 상대평가비율 수정 페이지
    // tb_lms_score_rel_conf 성적 상대평가비율 기준
    @RequestMapping(value = "/editRelativeClass.do")
    public String editRelativeClassForm(ScoreConfVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        List<ScoreConfVO> editRelativeClassView = scoreConfService.editRelativeClassView(vo);
        model.addAttribute("editRelativeClassView", editRelativeClassView);
        
        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항
        
        String page = "score/conf/relativeClassWrite";

        return page;
    }
    
    // 상대평가비율 수정 Ajax
    // tb_lms_score_rel_conf 성적 상대평가비율 기준
    @RequestMapping(value = "/editRelativeClassAjax.do")
    @ResponseBody
    public ProcessResultVO<ScoreConfVO> editRelativeClassAjax(ScoreConfVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<ScoreConfVO> resultVO = new ProcessResultVO<>();
    	
    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));
    	
    	try {
    		String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
    		String[] scorRelCds = StringUtil.nvl(vo.getScorRelCds()).split("\\|");
    		
			String[] endScorCds = StringUtil.nvl(vo.getEndScorCds()).split("\\|");
			String[] startRatios = StringUtil.nvl(vo.getStartRatios()).split("\\|");
			String[] endRatios = StringUtil.nvl(vo.getEndRatios()).split("\\|");

			if(endScorCds.length > 0 && !"".equals(endScorCds[0])) {
				for(int i = 0; i < endScorCds.length; i++) {
					vo.setOrgId(orgId);
					vo.setScorRelCd(scorRelCds[i]);
					vo.setUniCd(vo.getUniCd());
					vo.setStartScorCd(scorRelCds[i]);
					vo.setEndScorCd(endScorCds[i]);
					vo.setStartRatio(Integer.parseInt(startRatios[i]));
					vo.setEndRatio(Integer.parseInt(endRatios[i]));
					vo.setMdfrId(userId);
					
					scoreConfService.editRelativeClass(vo);
				}
			}
			resultVO.setResult(1);
		} catch (Exception e) {
			resultVO.setResult(-1);
		}
    	return resultVO;
    }
    
    // 상대평가비율 수정
    // tb_lms_score_rel_conf 성적 상대평가비율 기준
    @RequestMapping(value="/editRelative.do")
    public String editRelativeClass(ScoreConfVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);
        
        scoreConfService.editRelativeClass(vo);
        
        return "redirect:"+new URLBuilder("score/scoreConf", "/relativeClassList.do",request).toString();
    }
    
    // 상대평가비율 사용여부수정
    // tb_lms_score_rel_conf 성적 상대평가비율 기준
    @RequestMapping(value="/editRelativeUseYn.do" )
    @ResponseBody
    public ProcessResultVO<ScoreConfVO> editRelativeUseYn(HttpServletRequest request, HttpServletResponse response, ModelMap model, ScoreConfVO vo) throws Exception {
        
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
//        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setMdfrId(userId);
//        vo.setOrgId(orgId);
        
        return scoreConfService.editRelativeUseYn(vo);
    }
    
    // 출석점수기준 설정 정보 조회
    // tb_lms_score_atnd_conf  성적 출석점수기준(분기)
    @RequestMapping(value = "/attendClassList.do")
    public String attendClassListForm(ScoreConfVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        ScoreConfVO scoreConfVO = new ScoreConfVO();

        /* 강의오픈일 정보_시작 */

            // 강의오픈 요일
            String openWeekNm, openWeekVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendOpenClassWeek(vo);

            openWeekNm = scoreConfVO.getOpenWeekNm();
            openWeekVal = scoreConfVO.getOpenWeekVal();
            
            // 강의오픈 시간
            String openTmNm, openTmVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendOpenClassTm(vo);

            openTmNm = scoreConfVO.getOpenTmNm();
            openTmVal = scoreConfVO.getOpenTmVal();
            
            // 강의 1주차 오픈 요일
            String openWeek1ApNm, openWeek1ApVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendOpenClassWeekAp(vo);
            
            openWeek1ApNm = scoreConfVO.getOpenWeek1ApNm();
            openWeek1ApVal = scoreConfVO.getOpenWeek1ApVal();
            
            // 강의 1주차 오픈 시간
            String openWeek1TmNm, openWeek1TmVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendOpenClassWeekTm(vo);

            openWeek1TmNm = scoreConfVO.getOpenWeek1TmNm();
            openWeek1TmVal = scoreConfVO.getOpenWeek1TmVal();
            
        /* 강의오픈일 정보_끝 */

        /* 출석인정 기간_시작 */

            // 출석점수기준 출석인정기간 주차 조회
            String atendTermNm, atendTermVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendAnceClassTerm(vo);

            atendTermNm = scoreConfVO.getAtendTermNm();
            atendTermVal = scoreConfVO.getAtendTermVal();
            
            // 출석점수기준 출석인정기간 1주차 조회
            String atendWeekNm, atendWeekVal;            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendAnceClassTermWeek(vo);

            atendWeekNm = scoreConfVO.getAtendWeekNm();
            atendWeekVal = scoreConfVO.getAtendWeekVal();
            
        /* 출석인정 기간_끝 */

        /* 강의 출석/지각/결석 기준_정규학기_시작 */

            // 출석비율
            String atndRatioNm, atndRatioVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendRatioRegularClass(vo);

            atndRatioNm = scoreConfVO.getAtndRatioNm();
            atndRatioVal = scoreConfVO.getAtndRatioVal();
            
            // 지각비율
            String lateRatioNm, lateRatioVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectLateRatioRegularClass(vo);

            lateRatioNm = scoreConfVO.getLateRatioNm();
            lateRatioVal = scoreConfVO.getLateRatioVal();
            
            // 결석비율
            String absentRatioNm, absentRatioVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAbsentRatioRegularClass(vo);

            absentRatioNm = scoreConfVO.getAbsentRatioNm();
            absentRatioVal = scoreConfVO.getAbsentRatioVal();
            
        /* 강의 출석/지각/결석 기준_정규학기_끝 */

        /* 강의 출석/지각/결석 기준_계절학기_시작 */

            // 출석주차
            String senLesnWeekNm, senLesnWeekVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAtndWeekSeasonClass(vo);

            senLesnWeekNm = scoreConfVO.getSenLesnWeekNm();
            senLesnWeekVal = scoreConfVO.getSenLesnWeekVal();
            
            // 출석비율
            String senAtndRatioNm, senAtndRatioVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAtndRatioSeasonClass(vo);
            
            senAtndRatioNm = scoreConfVO.getSenAtndRatioNm();
            senAtndRatioVal = scoreConfVO.getSenAtndRatioVal();
            
            // 결석비율
            String senAbsentRatioNm, senAbsentRatioVal;            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAbsentRatioSeasonClass(vo);

            senAbsentRatioNm = scoreConfVO.getSenAbsentRatioNm();
            senAbsentRatioVal = scoreConfVO.getSenAbsentRatioVal();
            
            // 1주차강좌수
            String senLesnWeek1Nm, senLesnWeek1Val;            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectWeek1SeasonClass(vo);

            senLesnWeek1Nm = scoreConfVO.getSenLesnWeek1Nm();
            senLesnWeek1Val = scoreConfVO.getSenLesnWeek1Val();
            
            // 2주차강좌수
            String senLesnWeek2Nm, senLesnWeek2Val;            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectWeek2SeasonClass(vo);

            senLesnWeek2Nm = scoreConfVO.getSenLesnWeek2Nm();
            senLesnWeek2Val = scoreConfVO.getSenLesnWeek2Val();
            
            // 3주차강좌수
            String senLesnWeek3Nm, senLesnWeek3Val;            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectWeek3SeasonClass(vo);

            senLesnWeek3Nm = scoreConfVO.getSenLesnWeek3Nm();
            senLesnWeek3Val = scoreConfVO.getSenLesnWeek3Val();
            
            // 4주차강좌수
            String senLesnWeek4Nm, senLesnWeek4Val;            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectWeek4SeasonClass(vo);

            senLesnWeek4Nm = scoreConfVO.getSenLesnWeek4Nm();
            senLesnWeek4Val = scoreConfVO.getSenLesnWeek4Val();
        
        /* 강의 출석/지각/결석 기준_계절학기_끝 */
        
        /* 강의 출석/지각/결석 기준_출석평가기준_시작 */

            String absentScoreNm5, absentScoreNm4, absentScoreNm3, absentScoreNm2, absentScoreNm1;
            String absentScoreVal5, absentScoreVal4, absentScoreVal3, absentScoreVal2, absentScoreVal1;
            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAbsentScoreClass(vo);

            absentScoreNm5 = scoreConfVO.getAbsentScoreNm5();
            absentScoreNm4 = scoreConfVO.getAbsentScoreNm4();
            absentScoreNm3 = scoreConfVO.getAbsentScoreNm3();
            absentScoreNm2 = scoreConfVO.getAbsentScoreNm2();
            absentScoreNm1 = scoreConfVO.getAbsentScoreNm1();
            absentScoreVal5 = scoreConfVO.getAbsentScoreVal5();
            absentScoreVal4 = scoreConfVO.getAbsentScoreVal4();
            absentScoreVal3 = scoreConfVO.getAbsentScoreVal3();
            absentScoreVal2 = scoreConfVO.getAbsentScoreVal2();
            absentScoreVal1 = scoreConfVO.getAbsentScoreVal1();
            
        /* 강의 출석/지각/결석 기준_출석평가기준_끝 */

        /* 강의 출석/지각/결석 기준_지각감점기준_시작 */
      
            String lateScoreNm1, lateScoreNm2, lateScoreNm3, lateScoreNm4, lateScoreNm5, lateScoreNm6, lateScoreNm7;
            String lateScoreVal1, lateScoreVal2, lateScoreVal3, lateScoreVal4, lateScoreVal5, lateScoreVal6, lateScoreVal7;
            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectLateScoreClass(vo);

            lateScoreNm1 = scoreConfVO.getLateScoreNm1();
            lateScoreNm2 = scoreConfVO.getLateScoreNm2();
            lateScoreNm3 = scoreConfVO.getLateScoreNm3();
            lateScoreNm4 = scoreConfVO.getLateScoreNm4();
            lateScoreNm5 = scoreConfVO.getLateScoreNm5();
            lateScoreNm6 = scoreConfVO.getLateScoreNm6();
            lateScoreNm7 = scoreConfVO.getLateScoreNm7();
            lateScoreVal1 = scoreConfVO.getLateScoreVal1();
            lateScoreVal2 = scoreConfVO.getLateScoreVal2();
            lateScoreVal3 = scoreConfVO.getLateScoreVal3();
            lateScoreVal4 = scoreConfVO.getLateScoreVal4();
            lateScoreVal5 = scoreConfVO.getLateScoreVal5();
            lateScoreVal6 = scoreConfVO.getLateScoreVal6();
            lateScoreVal7 = scoreConfVO.getLateScoreVal7();

        /* 강의 출석/지각/결석 기준_지각감점기준_끝 */

        /* 출석점수 기준설정 화면 표시 설정 시작 */
            
            // 강의오픈
            vo.setOpenWeekNm(openWeekNm);
            vo.setOpenWeekVal(openWeekVal);
            vo.setOpenTmNm(openTmNm);
            vo.setOpenTmVal(openTmVal);
            vo.setOpenWeek1ApNm(openWeek1ApNm);
            vo.setOpenWeek1ApVal(openWeek1ApVal);
            vo.setOpenWeek1TmNm(openWeek1TmNm);
            vo.setOpenWeek1TmVal(openWeek1TmVal);
            
            // 출석인정기간
            vo.setAtendTermVal(atendTermVal);
            vo.setAtendWeekVal(atendWeekVal);
            
            // 강의 출석/지각/결석 기준 정규학기
            // 출석비율
            vo.setAtndRatioVal(atndRatioVal);
            
            // 지각비율
            vo.setLateRatioVal(lateRatioVal);
            
            // 결석비율
            vo.setAbsentRatioVal(absentRatioVal);
            
            // 강의 출석/지각/결석 기준 계절학기

            // 출석주차
            vo.setSenLesnWeekVal(senLesnWeekVal);
            
            // 출석비율
            vo.setSenAtndRatioVal(senAtndRatioVal);
            
            // 결석비율
            vo.setSenAbsentRatioVal(senAbsentRatioVal);
            
            // 1주차강좌수
            vo.setSenLesnWeek1Val(senLesnWeek1Val);
            
            // 2주차강좌수
            vo.setSenLesnWeek2Val(senLesnWeek2Val);
            
            // 3주차강좌수
            vo.setSenLesnWeek3Val(senLesnWeek3Val);
            
            // 4주차강좌수
            vo.setSenLesnWeek4Val(senLesnWeek4Val);
            
            // 출석평가 기준
            vo.setAbsentScoreNm5(absentScoreNm5);
            vo.setAbsentScoreNm4(absentScoreNm4);
            vo.setAbsentScoreNm3(absentScoreNm3);
            vo.setAbsentScoreNm2(absentScoreNm2);
            vo.setAbsentScoreNm1(absentScoreNm1);
            vo.setAbsentScoreVal5(absentScoreVal5);
            vo.setAbsentScoreVal4(absentScoreVal4);
            vo.setAbsentScoreVal3(absentScoreVal3);
            vo.setAbsentScoreVal2(absentScoreVal2);
            vo.setAbsentScoreVal1(absentScoreVal1);
            
            // 지각 감점 기준
            vo.setLateScoreNm1(lateScoreNm1);
            vo.setLateScoreNm2(lateScoreNm2);
            vo.setLateScoreNm3(lateScoreNm3);
            vo.setLateScoreNm4(lateScoreNm4);
            vo.setLateScoreNm5(lateScoreNm5);
            vo.setLateScoreNm6(lateScoreNm6);
            vo.setLateScoreNm7(lateScoreNm7);
            vo.setLateScoreVal1(lateScoreVal1);
            vo.setLateScoreVal2(lateScoreVal2);
            vo.setLateScoreVal3(lateScoreVal3);
            vo.setLateScoreVal4(lateScoreVal4);
            vo.setLateScoreVal5(lateScoreVal5);
            vo.setLateScoreVal6(lateScoreVal6);
            vo.setLateScoreVal7(lateScoreVal7);
            
        /* 출석점수 기준설정 화면 표시 설정 끝 */

        request.setAttribute("vo", vo); 

        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항
        
        String page = "score/conf/attendClassList";

        return page;
    }

    // 출석점수기준 설정 정보 수정 페이지
    // tb_lms_score_atnd_conf  성적 출석점수기준(분기)
    @RequestMapping(value = "/editAttendClass.do")
    public String editAttendClassForm(ScoreConfVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        ScoreConfVO scoreConfVO = new ScoreConfVO();

        /* 강의오픈일 정보_시작 */

            // 강의오픈 요일
            String openWeekCd, openWeekNm, openWeekVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendOpenClassWeek(vo);

            openWeekCd = scoreConfVO.getOpenWeekCd();
            openWeekNm = scoreConfVO.getOpenWeekNm();
            openWeekVal = scoreConfVO.getOpenWeekVal();
            
            // 강의오픈 시간
            String openTmCd, openTmNm, openTmVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendOpenClassTm(vo);

            openTmCd = scoreConfVO.getOpenTmCd();
            openTmNm = scoreConfVO.getOpenTmNm();
            openTmVal = scoreConfVO.getOpenTmVal();
            
            // 강의 1주차 오픈 요일
            String openWeek1ApCd, openWeek1ApNm, openWeek1ApVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendOpenClassWeekAp(vo);
            
            openWeek1ApCd = scoreConfVO.getOpenWeek1ApCd();
            openWeek1ApNm = scoreConfVO.getOpenWeek1ApNm();
            openWeek1ApVal = scoreConfVO.getOpenWeek1ApVal();
            
            // 강의 1주차 오픈 시간
            String openWeek1TmCd, openWeek1TmNm, openWeek1TmVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendOpenClassWeekTm(vo);

            openWeek1TmCd = scoreConfVO.getOpenWeek1TmCd();
            openWeek1TmNm = scoreConfVO.getOpenWeek1TmNm();
            openWeek1TmVal = scoreConfVO.getOpenWeek1TmVal();
            
        /* 강의오픈일 정보_끝 */

        /* 출석인정 기간_시작 */

            // 출석점수기준 출석인정기간 주차 조회
            String atendTermCd, atendTermNm, atendTermVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendAnceClassTerm(vo);

            atendTermCd = scoreConfVO.getAtendTermCd();
            atendTermNm = scoreConfVO.getAtendTermNm();
            atendTermVal = scoreConfVO.getAtendTermVal();
            
            // 출석점수기준 출석인정기간 1주차 조회
            String atendWeekCd, atendWeekNm, atendWeekVal;            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendAnceClassTermWeek(vo);

            atendWeekCd = scoreConfVO.getAtendWeekCd();
            atendWeekNm = scoreConfVO.getAtendWeekNm();
            atendWeekVal = scoreConfVO.getAtendWeekVal();
            
        /* 출석인정 기간_끝 */

        /* 강의 출석/지각/결석 기준_정규학기_시작 */

            // 출석비율
            String atndRatioCd, atndRatioNm, atndRatioVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAttendRatioRegularClass(vo);

            atndRatioCd = scoreConfVO.getAtndRatioCd();
            atndRatioNm = scoreConfVO.getAtndRatioNm();
            atndRatioVal = scoreConfVO.getAtndRatioVal();
            
            // 지각비율
            String lateRatioCd, lateRatioNm, lateRatioVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectLateRatioRegularClass(vo);

            lateRatioCd = scoreConfVO.getLateRatioCd();
            lateRatioNm = scoreConfVO.getLateRatioNm();
            lateRatioVal = scoreConfVO.getLateRatioVal();
            
            // 결석비율
            String absentRatioCd, absentRatioNm, absentRatioVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAbsentRatioRegularClass(vo);

            absentRatioCd = scoreConfVO.getAbsentRatioCd();
            absentRatioNm = scoreConfVO.getAbsentRatioNm();
            absentRatioVal = scoreConfVO.getAbsentRatioVal();
            
        /* 강의 출석/지각/결석 기준_정규학기_끝 */

        /* 강의 출석/지각/결석 기준_계절학기_시작 */

            // 출석주차
            String senLesnWeekCd, senLesnWeekNm, senLesnWeekVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAtndWeekSeasonClass(vo);

            senLesnWeekCd = scoreConfVO.getSenLesnWeekCd();
            senLesnWeekNm = scoreConfVO.getSenLesnWeekNm();
            senLesnWeekVal = scoreConfVO.getSenLesnWeekVal();
            
            // 출석비율
            String senAtndRatioCd, senAtndRatioNm, senAtndRatioVal;
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAtndRatioSeasonClass(vo);
            
            senAtndRatioCd = scoreConfVO.getSenAtndRatioCd();
            senAtndRatioNm = scoreConfVO.getSenAtndRatioNm();
            senAtndRatioVal = scoreConfVO.getSenAtndRatioVal();
            
            // 결석비율
            String senAbsentRatioCd, senAbsentRatioNm, senAbsentRatioVal;            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAbsentRatioSeasonClass(vo);

            senAbsentRatioCd = scoreConfVO.getSenAbsentRatioCd();
            senAbsentRatioNm = scoreConfVO.getSenAbsentRatioNm();
            senAbsentRatioVal = scoreConfVO.getSenAbsentRatioVal();
            
            // 1주차강좌수
            String senLesnWeek1Cd, senLesnWeek1Nm, senLesnWeek1Val;            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectWeek1SeasonClass(vo);

            senLesnWeek1Cd = scoreConfVO.getSenLesnWeek1Cd();
            senLesnWeek1Nm = scoreConfVO.getSenLesnWeek1Nm();
            senLesnWeek1Val = scoreConfVO.getSenLesnWeek1Val();
            
            // 2주차강좌수
            String senLesnWeek2Cd, senLesnWeek2Nm, senLesnWeek2Val;            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectWeek2SeasonClass(vo);

            senLesnWeek2Cd = scoreConfVO.getSenLesnWeek2Cd();
            senLesnWeek2Nm = scoreConfVO.getSenLesnWeek2Nm();
            senLesnWeek2Val = scoreConfVO.getSenLesnWeek2Val();
            
            // 3주차강좌수
            String senLesnWeek3Cd, senLesnWeek3Nm, senLesnWeek3Val;            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectWeek3SeasonClass(vo);

            senLesnWeek3Cd = scoreConfVO.getSenLesnWeek3Cd();
            senLesnWeek3Nm = scoreConfVO.getSenLesnWeek3Nm();
            senLesnWeek3Val = scoreConfVO.getSenLesnWeek3Val();
            
            // 4주차강좌수
            String senLesnWeek4Cd, senLesnWeek4Nm, senLesnWeek4Val;            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectWeek4SeasonClass(vo);

            senLesnWeek4Cd = scoreConfVO.getSenLesnWeek4Cd();
            senLesnWeek4Nm = scoreConfVO.getSenLesnWeek4Nm();
            senLesnWeek4Val = scoreConfVO.getSenLesnWeek4Val();
        
        /* 강의 출석/지각/결석 기준_계절학기_끝 */
        
        /* 강의 출석/지각/결석 기준_출석평가기준_시작 */

            String absentScoreNm5, absentScoreNm4, absentScoreNm3, absentScoreNm2, absentScoreNm1;
            String absentScoreVal5, absentScoreVal4, absentScoreVal3, absentScoreVal2, absentScoreVal1;
            String absentScoreCd5, absentScoreCd4, absentScoreCd3, absentScoreCd2, absentScoreCd1;
            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectAbsentScoreClass(vo);

            absentScoreNm5 = scoreConfVO.getAbsentScoreNm5();
            absentScoreNm4 = scoreConfVO.getAbsentScoreNm4();
            absentScoreNm3 = scoreConfVO.getAbsentScoreNm3();
            absentScoreNm2 = scoreConfVO.getAbsentScoreNm2();
            absentScoreNm1 = scoreConfVO.getAbsentScoreNm1();
            
            absentScoreVal5 = scoreConfVO.getAbsentScoreVal5();
            absentScoreVal4 = scoreConfVO.getAbsentScoreVal4();
            absentScoreVal3 = scoreConfVO.getAbsentScoreVal3();
            absentScoreVal2 = scoreConfVO.getAbsentScoreVal2();
            absentScoreVal1 = scoreConfVO.getAbsentScoreVal1();
            
            absentScoreCd5 = scoreConfVO.getAbsentScoreCd5();
            absentScoreCd4 = scoreConfVO.getAbsentScoreCd4();
            absentScoreCd3 = scoreConfVO.getAbsentScoreCd3();
            absentScoreCd2 = scoreConfVO.getAbsentScoreCd2();
            absentScoreCd1 = scoreConfVO.getAbsentScoreCd1();
            
        /* 강의 출석/지각/결석 기준_출석평가기준_끝 */

        /* 강의 출석/지각/결석 기준_지각감점기준_시작 */
      
            String lateScoreNm1, lateScoreNm2, lateScoreNm3, lateScoreNm4, lateScoreNm5, lateScoreNm6, lateScoreNm7;
            String lateScoreVal1, lateScoreVal2, lateScoreVal3, lateScoreVal4, lateScoreVal5, lateScoreVal6, lateScoreVal7;
            String lateScoreCd1, lateScoreCd2, lateScoreCd3, lateScoreCd4, lateScoreCd5, lateScoreCd6, lateScoreCd7;
            
            scoreConfVO = (ScoreConfVO)scoreConfService.selectLateScoreClass(vo);

            lateScoreNm1 = scoreConfVO.getLateScoreNm1();
            lateScoreNm2 = scoreConfVO.getLateScoreNm2();
            lateScoreNm3 = scoreConfVO.getLateScoreNm3();
            lateScoreNm4 = scoreConfVO.getLateScoreNm4();
            lateScoreNm5 = scoreConfVO.getLateScoreNm5();
            lateScoreNm6 = scoreConfVO.getLateScoreNm6();
            lateScoreNm7 = scoreConfVO.getLateScoreNm7();
            
            lateScoreVal1 = scoreConfVO.getLateScoreVal1();
            lateScoreVal2 = scoreConfVO.getLateScoreVal2();
            lateScoreVal3 = scoreConfVO.getLateScoreVal3();
            lateScoreVal4 = scoreConfVO.getLateScoreVal4();
            lateScoreVal5 = scoreConfVO.getLateScoreVal5();
            lateScoreVal6 = scoreConfVO.getLateScoreVal6();
            lateScoreVal7 = scoreConfVO.getLateScoreVal7();

            lateScoreCd1 = scoreConfVO.getLateScoreCd1();
            lateScoreCd2 = scoreConfVO.getLateScoreCd2();
            lateScoreCd3 = scoreConfVO.getLateScoreCd3();
            lateScoreCd4 = scoreConfVO.getLateScoreCd4();
            lateScoreCd5 = scoreConfVO.getLateScoreCd5();
            lateScoreCd6 = scoreConfVO.getLateScoreCd6();
            lateScoreCd7 = scoreConfVO.getLateScoreCd7();
            
        /* 강의 출석/지각/결석 기준_지각감점기준_끝 */

        /* 출석점수 기준설정 화면 표시 설정 시작 */
            
            // 강의오픈
            vo.setOpenWeekCd(openWeekCd);
            vo.setOpenWeekNm(openWeekNm);
            vo.setOpenWeekVal(openWeekVal);
            vo.setOpenTmCd(openTmCd);
            vo.setOpenTmNm(openTmNm);
            vo.setOpenTmVal(openTmVal);
            vo.setOpenWeek1ApCd(openWeek1ApCd);
            vo.setOpenWeek1ApNm(openWeek1ApNm);
            vo.setOpenWeek1ApVal(openWeek1ApVal);
            vo.setOpenWeek1TmCd(openWeek1TmCd);
            vo.setOpenWeek1TmNm(openWeek1TmNm);
            vo.setOpenWeek1TmVal(openWeek1TmVal);
            
            // 출석인정기간
            vo.setAtendTermCd(atendTermCd);
            vo.setAtendTermVal(atendTermVal);
            vo.setAtendWeekCd(atendWeekCd);
            vo.setAtendWeekVal(atendWeekVal);
            
            // 강의 출석/지각/결석 기준 정규학기
            // 출석비율
            vo.setAtndRatioCd(atndRatioCd);
            vo.setAtndRatioVal(atndRatioVal);
            
            // 지각비율
            vo.setLateRatioCd(lateRatioCd);
            vo.setLateRatioVal(lateRatioVal);
            
            // 결석비율
            vo.setAbsentRatioCd(absentRatioCd);
            vo.setAbsentRatioVal(absentRatioVal);
            
            // 강의 출석/지각/결석 기준 계절학기

            // 출석주차
            vo.setSenLesnWeekCd(senLesnWeekCd);
            vo.setSenLesnWeekVal(senLesnWeekVal);
            
            // 출석비율
            vo.setSenAtndRatioCd(senAtndRatioCd);
            vo.setSenAtndRatioVal(senAtndRatioVal);
            
            // 결석비율
            vo.setSenAbsentRatioCd(senAbsentRatioCd);
            vo.setSenAbsentRatioVal(senAbsentRatioVal);
            
            // 1주차강좌수
            vo.setSenLesnWeek1Cd(senLesnWeek1Cd);
            vo.setSenLesnWeek1Val(senLesnWeek1Val);
            
            // 2주차강좌수
            vo.setSenLesnWeek2Cd(senLesnWeek2Cd);
            vo.setSenLesnWeek2Val(senLesnWeek2Val);
            
            // 3주차강좌수
            vo.setSenLesnWeek3Cd(senLesnWeek3Cd);
            vo.setSenLesnWeek3Val(senLesnWeek3Val);
            
            // 4주차강좌수
            vo.setSenLesnWeek4Cd(senLesnWeek4Cd);
            vo.setSenLesnWeek4Val(senLesnWeek4Val);
            
            // 출석평가 기준
            vo.setAbsentScoreNm5(absentScoreNm5);
            vo.setAbsentScoreNm4(absentScoreNm4);
            vo.setAbsentScoreNm3(absentScoreNm3);
            vo.setAbsentScoreNm2(absentScoreNm2);
            vo.setAbsentScoreNm1(absentScoreNm1);
            
            vo.setAbsentScoreVal5(absentScoreVal5);
            vo.setAbsentScoreVal4(absentScoreVal4);
            vo.setAbsentScoreVal3(absentScoreVal3);
            vo.setAbsentScoreVal2(absentScoreVal2);
            vo.setAbsentScoreVal1(absentScoreVal1);
            
            vo.setAbsentScoreCd5(absentScoreCd5);
            vo.setAbsentScoreCd4(absentScoreCd4);
            vo.setAbsentScoreCd3(absentScoreCd3);
            vo.setAbsentScoreCd2(absentScoreCd2);
            vo.setAbsentScoreCd1(absentScoreCd1);
            
            // 지각 감점 기준
            vo.setLateScoreNm1(lateScoreNm1);
            vo.setLateScoreNm2(lateScoreNm2);
            vo.setLateScoreNm3(lateScoreNm3);
            vo.setLateScoreNm4(lateScoreNm4);
            vo.setLateScoreNm5(lateScoreNm5);
            vo.setLateScoreNm6(lateScoreNm6);
            vo.setLateScoreNm7(lateScoreNm7);
            
            vo.setLateScoreVal1(lateScoreVal1);
            vo.setLateScoreVal2(lateScoreVal2);
            vo.setLateScoreVal3(lateScoreVal3);
            vo.setLateScoreVal4(lateScoreVal4);
            vo.setLateScoreVal5(lateScoreVal5);
            vo.setLateScoreVal6(lateScoreVal6);
            vo.setLateScoreVal7(lateScoreVal7);
            
            vo.setLateScoreCd1(lateScoreCd1);
            vo.setLateScoreCd2(lateScoreCd2);
            vo.setLateScoreCd3(lateScoreCd3);
            vo.setLateScoreCd4(lateScoreCd4);
            vo.setLateScoreCd5(lateScoreCd5);
            vo.setLateScoreCd6(lateScoreCd6);
            vo.setLateScoreCd7(lateScoreCd7);
            
        /* 출석점수 기준설정 화면 표시 설정 끝 */

        request.setAttribute("vo", vo); 

        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항
        
        String page = "score/conf/attendClassWrite";

        return page;
    }
    
    // 출석점수기준 설정 정보 수정
    // tb_lms_score_atnd_conf  성적 출석점수기준(분기)
    @RequestMapping(value = "/editAttend.do")
    public String editAttendClass(ScoreConfVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
 
        // 로그인 체크
        if(ValidationUtils.isEmpty(userId)) {
            // 사용권한이 없거나 로그아웃되었습니다.<br><br>다시 로그인하세요.
            throw new SessionBrokenException(getMessage("common.system.no_auth"));
        }
        
        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }
                
        // 출석점수기준 강의오픈일 수정
        scoreConfService.editAttendOpenClassWeek(vo);
        
        // 출석점수기준 강의오픈시간 수정 
        scoreConfService.editAttendOpenClassTm(vo);
        
        // 출석점수기준 강의1주 오픈일 수정 
        scoreConfService.editAttendOpenClassWeekAp(vo);
        
        // 출석점수기준 강의1주 오픈 시간 수정 
        scoreConfService.editAttendOpenClassWeekTm(vo);
        
        // 출석점수기준 출석인정기간 주차 수정 
        scoreConfService.editAttendAnceClassTerm(vo);
        
        // 출석점수기준 출석인정기간 1주차 수정 
        scoreConfService.editAttendAnceClassTermWeek(vo);
        
        // 출석점수기준 강의 출석률(정규학기) 수정 
        scoreConfService.editAttendRatioRegularClass(vo);
        
        // 출석점수기준 강의 지각률(정규학기) 수정 
        scoreConfService.editLateRatioRegularClass(vo);
        
        // 출석점수기준 강의 결석률(정규학기) 수정 
        scoreConfService.editAbsentRatioRegularClass(vo);
        
        // 출석점수기준 강의 계절학기 출석주차 수정 
        scoreConfService.editAtndWeekSeasonClass(vo);
        
        // 출석점수기준 강의 계절학기 출석비율 수정 
        scoreConfService.editAtndRatioSeasonClass(vo);
        
        // 출석점수기준 강의 계절학기 결석비율 정보 수정 
        scoreConfService.editAbsentRatioSeasonClass(vo);
        
        // 출석점수기준 강의 계절학기 1주차 강의수 수정 
        scoreConfService.editWeek1SeasonClass(vo);
        
        // 출석점수기준 강의 계절학기 2주차 강의수 수정 
        scoreConfService.editWeek2SeasonClass(vo);
        
        // 출석점수기준 강의 계절학기 3주차 강의수 수정 
        scoreConfService.editWeek3SeasonClass(vo);
        
        // 출석점수기준 강의 계절학기 4주차 강의수 수정 
        scoreConfService.editWeek4SeasonClass(vo);

        // 출석점수기준 강의 출석평가 정보 수정
        scoreConfService.editAbsentScoreClass5(vo);
        scoreConfService.editAbsentScoreClass4(vo);
        scoreConfService.editAbsentScoreClass3(vo);
        scoreConfService.editAbsentScoreClass2(vo);
        scoreConfService.editAbsentScoreClass1(vo);
        
        // 출석점수기준 강의 지각감전기준 정보 수정
        scoreConfService.editLateScoreClass1(vo);
        scoreConfService.editLateScoreClass2(vo);
        scoreConfService.editLateScoreClass3(vo);
        scoreConfService.editLateScoreClass4(vo);
        scoreConfService.editLateScoreClass5(vo);
        scoreConfService.editLateScoreClass6(vo);
        scoreConfService.editLateScoreClass7(vo);
        
        return "redirect:"+new URLBuilder("score/scoreConf", "/attendClassList.do",request).toString();
    }

    // 세미나출석기준 설정 정보 조회
    // tb_lms_score_atnd_conf  성적 출석점수기준(분기)
    @RequestMapping(value = "/seminarClassList.do")
    public String seminarClassListForm(ScoreConfVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        ScoreConfVO scoreConfVO = new ScoreConfVO();

        /* 세미나 출석기준 설정 시작 */

            // 출석 비율
            String seminarAtndRatioNm = "";
            String seminarAtndRatioVal = "";
            scoreConfVO = (ScoreConfVO)scoreConfService.selectSeminarRatio(vo);
            
            seminarAtndRatioNm = scoreConfVO.getSeminarAtndRatioNm();
            seminarAtndRatioVal = scoreConfVO.getSeminarAtndRatioVal();

            // 출석 시간
            String seminarAtndTmNm = "";
            String seminarAtndTmVal = "";
            scoreConfVO = (ScoreConfVO)scoreConfService.selectSeminarTm(vo);
            
            seminarAtndTmNm = scoreConfVO.getSeminarAtndTmNm();
            seminarAtndTmVal = scoreConfVO.getSeminarAtndTmVal();

            // 지각 비율
            String seminarLateRatioNm = "";
            String seminarLateRatioVal = "";
            scoreConfVO = (ScoreConfVO)scoreConfService.selectSeminarLateRatio(vo);
        
            seminarLateRatioNm = scoreConfVO.getSeminarLateRatioNm();
            seminarLateRatioVal = scoreConfVO.getSeminarLateRatioVal();

            // 지각 시간
            String seminarLateTmNm = "";
            String seminarLateTmVal = "";
            scoreConfVO = (ScoreConfVO)scoreConfService.selectSeminarLateTm(vo);

            seminarLateTmNm = scoreConfVO.getSeminarLateTmNm();
            seminarLateTmVal = scoreConfVO.getSeminarLateTmVal();

            // 결석 비율
            String seminarAbsentRatioCd = "";
            String seminarAbsentRatioNm = "";
            String seminarAbsentRatioVal = "";
            scoreConfVO = (ScoreConfVO)scoreConfService.selectSeminarAbsentRatio(vo);

            seminarAbsentRatioCd = scoreConfVO.getSeminarAbsentRatioCd();
            seminarAbsentRatioNm = scoreConfVO.getSeminarAbsentRatioNm();
            seminarAbsentRatioVal = scoreConfVO.getSeminarAbsentRatioVal();

        /* 세미나 출석기준 설정 끝 */
        
        /* 세미나 출석기준 화면 표시 설정 시작 */
            // 출석 비율_설정    
            vo.setSeminarAtndRatioNm(seminarAtndRatioNm);
            vo.setSeminarAtndRatioVal(seminarAtndRatioVal);
            
            // 출석 시간_설정
            vo.setSeminarAtndTmNm(seminarAtndTmNm);
            vo.setSeminarAtndTmVal(seminarAtndTmVal);
            
            // 지각 비율_설정
            vo.setSeminarLateRatioNm(seminarLateRatioNm);
            vo.setSeminarLateRatioVal(seminarLateRatioVal);
            
            // 지각 시간_설정
            vo.setSeminarLateTmNm(seminarLateTmNm);
            vo.setSeminarLateTmVal(seminarLateTmVal);
            
            // 결석 비율_설정
            vo.setSeminarAbsentRatioNm(seminarAbsentRatioNm);
            vo.setSeminarAbsentRatioVal(seminarAbsentRatioVal);
            
        /* 세미나 출석기준 화면 표시 설정 끝 */
            
        request.setAttribute("vo", vo);

        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항
        
        String page = "score/conf/seminarClassList";

        return page;
    }

    // 세미나출석기준 설정 정보 수정 페이지
    // tb_lms_score_atnd_conf  성적 출석점수기준(분기)
    @RequestMapping(value = "/editSeminarClass.do")
    public String editSeminarClassForm(ScoreConfVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String admYn = StringUtil.nvl(SessionInfo.getAdmYn(request));

        // 페이지 접근 권한 체크
        if(!("Y".equals(admYn))) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new AccessDeniedException(getMessage("common.system.error"));
        }

        ScoreConfVO scoreConfVO = new ScoreConfVO();

        /* 세미나 출석기준 설정 시작 */

            // 출석 비율
            String seminarAtndRatioCd = "";
            String seminarAtndRatioNm = "";
            String seminarAtndRatioVal = "";
            scoreConfVO = (ScoreConfVO)scoreConfService.selectSeminarRatio(vo);
            
            seminarAtndRatioCd =  scoreConfVO.getSeminarAtndRatioCd();
            seminarAtndRatioNm = scoreConfVO.getSeminarAtndRatioNm();
            seminarAtndRatioVal = scoreConfVO.getSeminarAtndRatioVal();

            // 출석 시간
            String seminarAtndTmCd = "";
            String seminarAtndTmNm = "";
            String seminarAtndTmVal = "";
            scoreConfVO = (ScoreConfVO)scoreConfService.selectSeminarTm(vo);
            
            seminarAtndTmCd = scoreConfVO.getSeminarAtndTmCd();
            seminarAtndTmNm = scoreConfVO.getSeminarAtndTmNm();
            seminarAtndTmVal = scoreConfVO.getSeminarAtndTmVal();

            // 지각 비율
            String seminarLateRatioCd = "";
            String seminarLateRatioNm = "";
            String seminarLateRatioVal = "";
            scoreConfVO = (ScoreConfVO)scoreConfService.selectSeminarLateRatio(vo);
        
            seminarLateRatioCd =  scoreConfVO.getSeminarLateRatioCd();
            seminarLateRatioNm = scoreConfVO.getSeminarLateRatioNm();
            seminarLateRatioVal = scoreConfVO.getSeminarLateRatioVal();
            
            // 지각 시간
            String seminarLateTmCd = "";
            String seminarLateTmNm = "";
            String seminarLateTmVal = "";
            scoreConfVO = (ScoreConfVO)scoreConfService.selectSeminarLateTm(vo);

            seminarLateTmCd = scoreConfVO.getSeminarLateTmCd();
            seminarLateTmNm = scoreConfVO.getSeminarLateTmNm();
            seminarLateTmVal = scoreConfVO.getSeminarLateTmVal();

            // 결석 비율
            String seminarAbsentRatioCd = "";
            String seminarAbsentRatioNm = "";
            String seminarAbsentRatioVal = "";
            scoreConfVO = (ScoreConfVO)scoreConfService.selectSeminarAbsentRatio(vo);

            seminarAbsentRatioCd = scoreConfVO.getSeminarAbsentRatioCd();
            seminarAbsentRatioNm = scoreConfVO.getSeminarAbsentRatioNm();
            seminarAbsentRatioVal = scoreConfVO.getSeminarAbsentRatioVal();

        /* 세미나 출석기준 설정 끝 */
        
        /* 세미나 출석기준 화면 표시 설정 시작 */
            // 출석 비율_설정
            vo.setSeminarAtndRatioCd(seminarAtndRatioCd);
            vo.setSeminarAtndRatioNm(seminarAtndRatioNm);
            vo.setSeminarAtndRatioVal(seminarAtndRatioVal);
            
            // 출석 시간_설정
            vo.setSeminarAtndTmCd(seminarAtndTmCd);
            vo.setSeminarAtndTmNm(seminarAtndTmNm);
            vo.setSeminarAtndTmVal(seminarAtndTmVal);
            
            // 지각 비율_설정
            vo.setSeminarLateRatioCd(seminarLateRatioCd);
            vo.setSeminarLateRatioNm(seminarLateRatioNm);
            vo.setSeminarLateRatioVal(seminarLateRatioVal);
            
            // 지각 시간_설정
            vo.setSeminarLateTmCd(seminarLateTmCd);
            vo.setSeminarLateTmNm(seminarLateTmNm);
            vo.setSeminarLateTmVal(seminarLateTmVal);
            
            // 결석 비율_설정
            vo.setSeminarAbsentRatioCd(seminarAbsentRatioCd);
            vo.setSeminarAbsentRatioNm(seminarAbsentRatioNm);
            vo.setSeminarAbsentRatioVal(seminarAbsentRatioVal);
            
        /* 세미나 출석기준 화면 표시 설정 끝 */
            
        request.setAttribute("vo", vo);

        // 관리자 메뉴 관련 추가사항
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        // 관리자 메뉴 관련 추가사항
        
        String page = "score/conf/seminarClassWrite";

        return page;
    }
    
    // 세미나출석기준 설정 정보 수정
    // tb_lms_score_atnd_conf  성적 출석점수기준(분기)
    @RequestMapping(value="/editSeminar.do")
    public String editSeminarClass(ScoreConfVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setMdfrId(userId);
        vo.setOrgId(orgId);

        // 출석비율 수정
        scoreConfService.editSeminarAtndRatio(vo);
        
        // 출석시간 수정
        scoreConfService.editSeminarAtndTm(vo);
        
        // 지각비율 수정
        scoreConfService.editSeminarLateRatio(vo);
        
        // 지각시간 수정
        scoreConfService.editSeminarLateTm(vo);
        
        // 결석비율 수정
        scoreConfService.editSeminarAbsentRatio(vo);
        
        return "redirect:"+new URLBuilder("score/scoreConf", "/seminarClassList.do",request).toString();
    }
}
