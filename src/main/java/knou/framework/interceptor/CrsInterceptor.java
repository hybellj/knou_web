package knou.framework.interceptor;

import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// 과목 공통
public class CrsInterceptor extends HandlerInterceptorAdapter {

    @Resource(name="crecrsService")
    private CrecrsService crecrsService;

    @Resource(name="stdService")
    private StdService stdService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        String crsCreCd = StringUtil.nvl(request.getParameter("crsCreCd"));

        if(!"".equals(crsCreCd) && !crsCreCd.equals(SessionInfo.getCurCrsCreCd(request))) {
            String uri = request.getRequestURI();

            if(uri.contains("/bbs/bbsLect/Form/")
                    // 강의목록
                    || uri.contains("/crs/Form/crsStuLesson.do")
                    // 과제
                    || uri.contains("/asmt/profAsmtListView.do")
                    || uri.contains("/asmt/profAsmtEvlView.do")
                    || uri.contains("/asmt/profAsmtRegistView.do")
                    || uri.contains("/asmt/stu/listView.do")
                    || uri.contains("/asmt/stu/asmtInfoManage.do")
                    || uri.contains("/asmt/stu/asmtScoreManage.do")
                    // 토론
                    || uri.contains("/forum/forumLect/Form/forumList.do")
                    || uri.contains("/forum/forumLect/Form/bbsManage.do")
                    || uri.contains("/forum/forumLect/Form/scoreManage.do")
                    || uri.contains("/forum/forumLect/Form/addForumForm.do")
                    || uri.contains("/forum/forumLect/Form/editForumForm.do")
                    || uri.contains("/forum/forumHome/Form/forumView.do")
                    || uri.contains("/forum/forumHome/Form/forumList.do")
                    // 퀴즈
                    || uri.contains("/quiz/quizQstnManage.do")
                    || uri.contains("/quiz/quizRetakeManage.do")
                    || uri.contains("/quiz/quizScoreManage.do")
                    || uri.contains("/quiz/stuQuizView.do")
                    || uri.contains("/quiz/profQuizListView.do")
                    || uri.contains("/quiz/profQuizRegistView.do")
                    || uri.contains("/quiz/Form/")
                    // 설문
                    || uri.contains("/resh/Form/reshList.do")
                    || uri.contains("/resh/Form/writeResh.do")
                    || uri.contains("/resh/Form/editResh.do")
                    || uri.contains("/resh/Form/stuReshList.do")
                    || uri.contains("/resh/stuReshView.do")
                    || uri.contains("/resh/Form/lectEvalList.do")
                    || uri.contains("/resh/Form/lectEvalView.do")
                    || uri.contains("/resh/Form/levelEvalList.do")
                    || uri.contains("/resh/Form/levelEvalView.do")
                    || uri.contains("/resh/reshResultManage.do")
                    || uri.contains("/resh/reshQstnManage.do")
                    // 세미나
                    || uri.contains("/seminar/seminarHome/Form/seminarList.do")
                    || uri.contains("/seminar/seminarHome/Form/seminarWrite.do")
                    || uri.contains("/seminar/seminarHome/Form/seminarEdit.do")
                    || uri.contains("/seminar/seminarHome/seminarAttendManage.do")
                    || uri.contains("/seminar/seminarHome/Form/stuSeminarList.do")
                    || uri.contains("/seminar/seminarHome/stuSeminarView.do")
                    // 학습메모
                    || uri.contains("/lesson/lessonLect/Form/lessonStudyMemo.do")
                    // 시험
                    || uri.contains("/exam/Form/examList.do")
                    || uri.contains("/exam/Form/examWrite.do")
                    || uri.contains("/exam/Form/examEdit.do")
                    || uri.contains("/exam/Form/examStareJoinList.do")
                    || uri.contains("/exam/examInfoManage.do")
                    || uri.contains("/exam/Form/stuExamList.do")
                    || uri.contains("/exam/stuExamView.do")
                    // 수강정보
                    || uri.contains("/std/stdLect/Form/studentList.do") // 수강생 정보 (교수)
                    || uri.contains("/std/stdLect/Form/attendList.do") // 출석현황/학습현황
                    || uri.contains("/std/stdHome/Form/stuAttendList.do") // 출석현황  (학생)
                    || uri.contains("/std/stdHome/Form/stuStudentList.do") // 수강생 정보 (학생)
                    || uri.contains("/crs/creCrsHome/creCrsTchList.do") // 교수/조교 정보
                    // 종합성적
                    || uri.contains("/score/scoreOverallLect/Form/")
                    // 관리
                    || uri.contains("/crs/creCrsHome/Form/")
                    // 팀관리
                    || uri.contains("/team/teamMgr/teamList.do")
                    || uri.contains("/team/teamMgr/teamWrite.do")
                    || uri.contains("/team/teamMgr/editTeamForm.do")
                    // 개인자료실
                    || uri.contains("/file/fileHome/Form/crsFileBox.do")) {
                String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
                String orgId = SessionInfo.getOrgId(request);
                String userId = SessionInfo.getUserId(request);

                // 과목정보 조회
                CreCrsVO creCrsVO = new CreCrsVO();
                creCrsVO.setCrsCreCd(crsCreCd);
                creCrsVO.setOrgId(orgId);
                creCrsVO = crecrsService.select(creCrsVO);

                if(StringUtil.nvl(menuType).contains("USR")) {
                    // 수강중인 학생정보 조회
                    StdVO stdVO = new StdVO();
                    stdVO.setOrgId(orgId);
                    stdVO.setCrsCreCd(crsCreCd);
                    stdVO.setUserId(userId);
                    stdVO = stdService.selectStd(stdVO);

                    crecrsService.setCreCrsStuSession(request, creCrsVO, stdVO);
                } else {
                    crecrsService.setCreCrsProfSession(request, creCrsVO);
                }
            }
        }

        return super.preHandle(request, response, handler);
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
                           ModelAndView modelAndView) throws Exception {
        // TODO Auto-generated method stub
        super.postHandle(request, response, handler, modelAndView);
    }

}
