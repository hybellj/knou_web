package knou.lms.crs.termlink.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.crs.termlink.dao.TermLinkDAO;
import knou.lms.crs.termlink.service.TermLinkService;
import knou.lms.crs.termlink.vo.TermLinkVO;

@Service("termLinkService")
public class TermLinkServiceImpl extends ServiceBase implements TermLinkService {
    
    @Resource(name="termLinkDAO")
    private TermLinkDAO termLinkDAO;

    /*****************************************************
     * <p>
     * TODO 학사 연동 처리 구현
     * </p>
     * 연동 유형에 따라  연동 프로시저를 호출한다.
     *
     * @param TermLinkVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void runLink(TermLinkVO vo) throws Exception {
        try {

            String linkType = vo.getLinkType();
            
            switch (linkType) {

                // 소속 정보 연동
                case "DEPARTMENT"         : termLinkDAO.linkDepartmentProc(vo);
                                            break;
                // 사용자 정보 중 학습자 정보 연동
                case "USER_LEARNER"       : vo.setUserType("L");
                                            termLinkDAO.linkUserProc(vo);
                                            break;
                // 사용자 정보 중 교수자 정보 연동
                case "PROF"          : vo.setUserType("P");
                                            termLinkDAO.linkUserProc(vo);
                                            break;
                // 사용자 정보 중 기타 사용자 정보 연동
                case "ETC_USER"           : vo.setUserType("U");
                                            termLinkDAO.linkUserProc(vo);
                                            break;
                // 운영 과목 정보 연동
                case "COURSE"             : termLinkDAO.linkCourseProc(vo);
                                            break;
                // 과목 운영자 정보 연동
                case "COURSE_PROFESSOR"   : termLinkDAO.linkCourseProfessorProc(vo);
                                            break;
                // 과목 수강생 정보 연동
                case "LEARNER"            : termLinkDAO.linklearnerProc(vo);
                                            break;
                // 강의계획서 정보 연동
                case "LESSON_PLAN"        : termLinkDAO.linkLessonPlanProc(vo);
                                            break;
                // 평가비율 정보 연동
                case "COURSE_SCORE"       : termLinkDAO.linkCourseScoreProc(vo);
                                            break;
                // 주차별 강의 정보 연동
                case "LESSON_SCHEDULE"    : termLinkDAO.linkLessonScheduleProc(vo);
                                            break;
                default           : vo.setResultYn("N");
                                    break;
            }
            
            if (!ValidationUtils.isEmpty(vo.getUpdateDttm())) {
                vo.setUpdateDttm(DateTimeUtil.getDateType(13, vo.getUpdateDttm(), "."));
            }

            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
