package knou.framework.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import knou.framework.util.SessionUtil;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.org.vo.OrgVO;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.SubjectVO;

/**
 * 과목정보 세션 관리
 */
public class SubjectInfo {
    private static Log log = LogFactory.getLog(SubjectInfo.class);
    private static String SBJCT_MAP_KEY = "SUBJECT_INFO_MAP";    // 과목정보 세션키
    private static String SBJCT_LIST_KEY = "SUBJECT_LIST_KEY";    // 과목정보 목록 세션키
    private static String ORG_LIST_KEY = "SUBJECT_ORG_LIST";    // 기관정보 목록 세션키
    private static String SMSTR_LIST_KEY = "SUBJECT_SMSTR_LIST";    // 기관정보 목록 세션키

    /**
     * 과목정보 세션에서 가져오기
     *
     * @param request
     * @param sbjctId
     * @return
     * @throws Exception
     */
    public static SubjectVO getSubjectInfo(HttpServletRequest request, String sbjctId) {
        SubjectVO subjectVO = null;

        try {
            String userId = SessionInfo.getUserId(request);

            if(sbjctId != null && !"".equals(sbjctId) && userId != null && !"".equals(userId)) {
                @SuppressWarnings("unchecked")
                Map<String, SubjectVO> subjectInfoMap = (Map<String, SubjectVO>) SessionUtil.getSessionValue(request, SBJCT_MAP_KEY);

                if(subjectInfoMap != null && subjectInfoMap.containsKey(sbjctId)) {
                    subjectVO = subjectInfoMap.get(sbjctId);
                } else {
                    // 과목정보 로드
                    loadSubjectInfoAll(request, userId);

                    @SuppressWarnings("unchecked")
                    Map<String, SubjectVO> infoMap = (Map<String, SubjectVO>) SessionUtil.getSessionValue(request, SBJCT_MAP_KEY);
                    if(infoMap != null && infoMap.containsKey(sbjctId)) {
                        subjectVO = infoMap.get(sbjctId);
                    }
                }
            }

        } catch(Exception e) {
            log.error(e.getMessage());
            throw new RuntimeException(e);
        }

        return subjectVO;
    }

    /**
     * 과목명 가져오기
     *
     * @param request
     * @param sbjctId
     * @return
     */
    public static String getSbjctnm(HttpServletRequest request, String sbjctId) {
        String sbjctnm = "";

        try {
            SubjectVO subjectVO = getSubjectInfo(request, sbjctId);
            if(subjectVO != null) {
                sbjctnm = subjectVO.getSbjctnm();

                Integer dvclsNo = subjectVO.getDvclasNo();
                if(dvclsNo != null) {
                    String dvclsNicknm = subjectVO.getDvclasNcknm();
                    String dvcls = (dvclsNicknm == null || "".equals(dvclsNicknm)) ? dvclsNo + "" : dvclsNicknm;
                    sbjctnm += "-" + dvcls;
                }
            }
        } catch(Exception e) {
            log.error(e.getMessage());
        }

        return sbjctnm;
    }


    /**
     * 과목 기관정보 세션에서 가져오기
     *
     * @param request
     * @param sbjctId
     * @return
     */
    public static OrgVO getSubjectOrgInfo(HttpServletRequest request, String sbjctId) {
        OrgVO orgVO = null;

        try {
            SubjectVO subjectVO = getSubjectInfo(request, sbjctId);

            if(subjectVO != null) {
                @SuppressWarnings("unchecked")
                List<OrgVO> orgList = (List<OrgVO>) SessionUtil.getSessionValue(request, ORG_LIST_KEY);
                if(orgList.size() > 0 && orgList.stream().anyMatch(vo -> vo.getOrgId().equals(subjectVO.getOrgId()))) {
                    orgVO = orgList.stream().filter(vo -> vo.getOrgId().equals(subjectVO.getOrgId())).findFirst().get();
                }
            }

        } catch(Exception e) {
            log.error(e.getMessage());
        }

        return orgVO;
    }

    /**
     * 과목 기관명 가져오기
     *
     * @param request
     * @param sbjctId
     * @return
     */
    public static String getOrgnm(HttpServletRequest request, String sbjctId) {
        String orgnm = "";

        try {
            OrgVO orgVO = getSubjectOrgInfo(request, sbjctId);
            if(orgVO != null) {
                orgnm = orgVO.getOrgnm();
            }
        } catch(Exception e) {
            log.error(e.getMessage());
        }

        return orgnm;
    }


    /**
     * 과목권한 가져오기
     *
     * @param request
     * @param sbjctId
     * @return
     */
    public static String getSubjectAuth(HttpServletRequest request, String sbjctId) {
        String auth = "";

        try {
            SubjectVO subjectVO = getSubjectInfo(request, sbjctId);
            if(subjectVO != null) {
                auth = subjectVO.getSbjctAuth();
            }

        } catch(Exception e) {
            log.error(e.getMessage());
        }

        return auth;
    }

    /**
     * 과목 기관목록 가져오기
     *
     * @param request
     * @param sbjctId
     * @return
     */
    @SuppressWarnings("unchecked")
    public static List<OrgVO> getSubjectOrgList(HttpServletRequest request) {
        List<OrgVO> orgList = null;

        try {
            String userId = SessionInfo.getUserId(request);
            orgList = (List<OrgVO>) SessionUtil.getSessionValue(request, ORG_LIST_KEY);

            if((orgList == null || orgList.size() == 0) && userId != null && !"".equals(userId)) {
                loadSubjectInfoAll(request, userId);

                orgList = (List<OrgVO>) SessionUtil.getSessionValue(request, ORG_LIST_KEY);
            }

        } catch(Exception e) {
            log.error(e.getMessage());
        }

        return orgList;
    }

    /**
     * 과목 기관의 학기목록 가져오기
     *
     * @param request
     * @param orgId
     * @return List<SmstrChrtVO>
     */
    @SuppressWarnings("unchecked")
    public static List<SmstrChrtVO> getSubjectSemesterList(HttpServletRequest request, String orgId) {
        List<SmstrChrtVO> semesterList = null;

        try {
            String userId = SessionInfo.getUserId(request);
            Map<String, List<SmstrChrtVO>> semesterMap = (Map<String, List<SmstrChrtVO>>) SessionUtil.getSessionValue(request, SMSTR_LIST_KEY);

            if(semesterMap == null) {
                loadSubjectInfoAll(request, userId);
                semesterMap = (Map<String, List<SmstrChrtVO>>) SessionUtil.getSessionValue(request, SMSTR_LIST_KEY);
            }

            if(semesterMap != null && orgId != null && !"".equals(orgId)) {
                semesterList = semesterMap.get(orgId);
            }

        } catch(Exception e) {
            log.error(e.getMessage());
        }

        return semesterList;
    }

    /**
     * 학기의 과목목록 가져오기
     *
     * @param request
     * @param orgId
     * @param smstrChrtId
     * @return List<SubjectVO>
     */
    @SuppressWarnings("unchecked")
    public static List<SubjectVO> getSubjectListBySemester(HttpServletRequest request, String orgId, String smstrChrtId) {
        List<SubjectVO> subjectList = null;

        try {
            String userId = SessionInfo.getUserId(request);
            Map<String, List<SubjectVO>> subjectListMap = (Map<String, List<SubjectVO>>) SessionUtil.getSessionValue(request, SBJCT_LIST_KEY);

            if(subjectListMap == null) {
                loadSubjectInfoAll(request, userId);
                subjectListMap = (Map<String, List<SubjectVO>>) SessionUtil.getSessionValue(request, SBJCT_LIST_KEY);
            }

            String sbjKey = orgId + ":" + smstrChrtId;
            if(subjectListMap != null && orgId != null && !"".equals(orgId) && smstrChrtId != null && !"".equals(smstrChrtId) && subjectListMap.containsKey(sbjKey)) {
                subjectList = subjectListMap.get(sbjKey);
            }

        } catch(Exception e) {
            log.error(e.getMessage());
        }

        return subjectList;
    }

    /**
     * 학기의 과목목록 가져오기(현재과목과 같은 학기)
     *
     * @param request
     * @param orgId
     * @param sbjctId
     * @return List<SubjectVO>
     */
    public static List<SubjectVO> getSubjectListBySbjctId(HttpServletRequest request, String orgId, String sbjctId) {
        List<SubjectVO> subjectList = null;
        SubjectVO subjectVO = getSubjectInfo(request, sbjctId);

        if(subjectVO != null) {
            subjectList = getSubjectListBySemester(request, orgId, subjectVO.getSmstrChrtId());
        }

        return subjectList;
    }

    /**
     * 사용자의 전체 과목정보 로드
     *
     * @param request
     * @param userId
     * @throws Exception
     */
    private static void loadSubjectInfoAll(HttpServletRequest request, String userId) throws Exception {
        
    	ApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
        SubjectService subjectService = (SubjectService) applicationContext.getBean("subjectService");

        String authrtGrpcd = SessionInfo.getAuthrtGrpcd(request);
        List<SubjectVO> subjectList = null;

        if(CommConst.AUTHRT_GRPCD_ADM.equals(authrtGrpcd) || CommConst.AUTHRT_GRPCD_PROF.equals(authrtGrpcd)) {
            // 교수 과목목록 조회
            subjectList = subjectService.subjectListAllByProf(userId);
        } else if(CommConst.AUTHRT_GRPCD_STDNT.equals(authrtGrpcd)) {
            // 학생 과목목록 조회
            subjectList = subjectService.subjectListAllByStdnt(userId);
        }

        if(subjectList != null && subjectList.size() > 0) {
            Map<String, SubjectVO> subjectInfoMap = new HashMap<>();
            Map<String, List<SmstrChrtVO>> semesterMap = new HashMap<>();
            Map<String, List<SubjectVO>> subjectListMap = new HashMap<>();
            List<OrgVO> orgList = new ArrayList<>();

            String orgId = null;
            String sbjKey = null;
            OrgVO orgVO = null;
            SmstrChrtVO smstrChrtVO = null;

            for(SubjectVO subjectVO : subjectList) {
                orgId = subjectVO.getOrgId();
                sbjKey = orgId + ":" + subjectVO.getSmstrChrtId();

                if(orgList.size() == 0 || !orgList.stream().anyMatch(vo -> vo.getOrgId().equals(subjectVO.getOrgId()))) {
                    orgVO = new OrgVO();
                    orgVO.setOrgId(orgId);
                    orgVO.setOrgnm(subjectVO.getOrgnm());
                    orgList.add(orgVO);
                }

                List<SmstrChrtVO> smtrList = semesterMap.containsKey(orgId) ? semesterMap.get(orgId) : new ArrayList<>();
                if(smtrList.size() == 0 || !smtrList.stream().anyMatch(vo -> vo.getSmstrChrtId().equals(subjectVO.getDgrsYr() + ":" + subjectVO.getDgrsSmstrChrt()))) {
                    smstrChrtVO = new SmstrChrtVO();
                    smstrChrtVO.setSmstrChrtId(subjectVO.getSmstrChrtId());
                    smstrChrtVO.setDgrsYr(subjectVO.getDgrsYr());
                    smstrChrtVO.setDgrsSmstrChrt(subjectVO.getDgrsSmstrChrt());
                    smstrChrtVO.setSmstrChrtnm(subjectVO.getSmstrChrtnm());
                    smtrList.add(smstrChrtVO);
                    semesterMap.put(orgId, smtrList);
                }

                List<SubjectVO> sbjList = subjectListMap.containsKey(sbjKey) ? subjectListMap.get(sbjKey) : new ArrayList<>();
                sbjList.add(subjectVO);
                subjectListMap.put(sbjKey, sbjList);
                subjectInfoMap.put(subjectVO.getSbjctId(), subjectVO);
            }

            SessionUtil.setSessionValue(request, ORG_LIST_KEY, orgList);
            SessionUtil.setSessionValue(request, SMSTR_LIST_KEY, semesterMap);
            SessionUtil.setSessionValue(request, SBJCT_LIST_KEY, subjectListMap);
            SessionUtil.setSessionValue(request, SBJCT_MAP_KEY, subjectInfoMap);
        }
    }
}
