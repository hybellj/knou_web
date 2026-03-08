package knou.lms.lecture2.facade.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.StringUtil;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.lecture2.facade.LctrPlandocFacadeService;
import knou.lms.lecture2.service.LctrPlandocService;
import knou.lms.lecture2.service.LectureScheduleService;
import knou.lms.lecture2.vo.LctrPlandocVO;
import knou.lms.lecture2.vo.LctrPlandocView;
import knou.lms.mrk.service.MarkItemSettingService;
import knou.lms.mrk.vo.MarkItemSettingVO;
import knou.lms.subject2.dto.SubjectParam;
import knou.lms.subject2.service.SubjectService;
import knou.lms.subject2.vo.SubjectVO;

@Service("lctrPlandocFacadeService")
public class LctrPlandocFacadeServiceImpl extends ServiceBase implements LctrPlandocFacadeService {
    private static final Logger LOGGER = LoggerFactory.getLogger(LctrPlandocFacadeServiceImpl.class);


    @Resource(name="lctrPlandocService")
    private LctrPlandocService lctrPlandocService;

    @Resource(name="subjectService")
    private SubjectService subjectService;

    @Resource(name="cmmnCdService")
    private CmmnCdService cmmnCdService;

    @Resource(name="lectureScheduleService")
    private LectureScheduleService lectureScheduleService;

    @Resource(name="markItemSettingService")
    private MarkItemSettingService markItemSettingService;

    /**
     * 강의계획서 상세
     *
     * @param userCtx
     * @param lctrPlandocVO
     * @return
     * @throws Exception
     */
    @Override
    public LctrPlandocView loadLctrPlandocView(UserContext userCtx, LctrPlandocVO lctrPlandocVO) throws Exception {
        LctrPlandocView lpv = new LctrPlandocView();
        String sbjctId = lctrPlandocVO.getSbjctId();

        // 과목정보, 장애인/고령자 지원
        SubjectVO subjectVO = subjectService.subjectSelect(sbjctId);
        lpv.setSubjectInfo(subjectVO);

        // 교수/튜터/조교 정보
        List<EgovMap> sbjctAdmList = subjectService.sbjctAdmList(sbjctId);
        List<EgovMap> profList = new ArrayList<>();
        List<EgovMap> coprofList = new ArrayList<>();
        List<EgovMap> tutList = new ArrayList<>();
        List<EgovMap> assiList = new ArrayList<>();

        for(EgovMap m : sbjctAdmList) {
            String tycd = String.valueOf(m.get("sbjctAdmTycd"));
            if("PROF".equals(tycd)) {
                profList.add(m);
            } else if("COPROF".equals(tycd)) {
                coprofList.add(m);
            } else if("TUT".equals(tycd)) {
                tutList.add(m);
            } else if("ASSI".equals(tycd)) {
                assiList.add(m);
            }
        }

        if(!profList.isEmpty()) {
            lpv.setProfInfo(profList.get(0));
        }

        lpv.setCoprofList(coprofList);
        lpv.setTutList(tutList);
        lpv.setAssiList(assiList);

        // 강의계획서 정보
        lpv.setLctrPlandocInfo(lctrPlandocService.lctrPlandocSelect(sbjctId));
        // 교재
        lpv.setTxtbkList(lctrPlandocService.txtbkList(sbjctId));

        // 강의노트, 음성파일, 실습지도 첨부파일
        // 첨부파일로만 가져와야함 ATFL_REF_TYCD


        // 평가방법 - 현재 절대평가만 사용
        if(StringUtil.isNull(subjectVO.getMrkEvlGbncd())) {
            subjectVO.setMrkEvlGbncd("ABSOLUTE");
        }
        lpv.setMrkEvlInfo(cmmnCdService.viewCode(userCtx.getOrgId(), "EVL_GBNCD", subjectVO.getMrkEvlGbncd()));

        // 평가비율
        MarkItemSettingVO mrkItmStngVO = new MarkItemSettingVO();
        mrkItmStngVO.setSbjctId(sbjctId);
        mrkItmStngVO.setOrgId(userCtx.getOrgId());
        lpv.setMrkItmStngList(markItemSettingService.mrkItmStngList(mrkItmStngVO));

        // 주차별 강의내용
        lpv.setLectureScheduleList(lectureScheduleService.profLectureScheduleList(new SubjectParam(sbjctId)));

        return lpv;
    }

    /**
     * 강의계획서 수정 화면
     *
     * @param userCtx
     * @param lctrPlandocVO
     * @return
     * @throws Exception
     */
    @Override
    public LctrPlandocView loadLctrPlandocModifyView(UserContext userCtx, LctrPlandocVO lctrPlandocVO) throws Exception {
        LctrPlandocView lpv = new LctrPlandocView();
        String sbjctId = lctrPlandocVO.getSbjctId();

        // 과목정보, 장애인/고령자 지원
        SubjectVO subjectVO = subjectService.subjectSelect(sbjctId);
        lpv.setSubjectInfo(subjectVO);

        // 교수/튜터/조교 정보
        List<EgovMap> sbjctAdmList = subjectService.sbjctAdmList(sbjctId);
        List<EgovMap> profList = new ArrayList<>();
        List<EgovMap> coprofList = new ArrayList<>();
        List<EgovMap> tutList = new ArrayList<>();
        List<EgovMap> assiList = new ArrayList<>();

        for(EgovMap m : sbjctAdmList) {
            String tycd = String.valueOf(m.get("sbjctAdmTycd"));
            if("PROF".equals(tycd)) {
                profList.add(m);
            } else if("COPROF".equals(tycd)) {
                coprofList.add(m);
            } else if("TUT".equals(tycd)) {
                tutList.add(m);
            } else if("ASSI".equals(tycd)) {
                assiList.add(m);
            }
        }

        if(!profList.isEmpty()) {
            lpv.setProfInfo(profList.get(0));
        }

        lpv.setCoprofList(coprofList);
        lpv.setTutList(tutList);
        lpv.setAssiList(assiList);

        // 강의계획서 정보
        lpv.setLctrPlandocInfo(lctrPlandocService.lctrPlandocSelect(sbjctId));
        // 교재
        lpv.setTxtbkList(lctrPlandocService.txtbkList(sbjctId));

        // 강의노트, 음성파일, 실습지도 첨부파일
        // 첨부파일로만 가져와야함 ATFL_REF_TYCD


        // 평가방법 - 현재 절대평가만 사용
        if(StringUtil.isNull(subjectVO.getMrkEvlGbncd())) {
            subjectVO.setMrkEvlGbncd("ABSOLUTE");
        }
        lpv.setMrkEvlInfo(cmmnCdService.viewCode(userCtx.getOrgId(), "EVL_GBNCD", subjectVO.getMrkEvlGbncd()));

        // 평가비율
        MarkItemSettingVO mrkItmStngVO = new MarkItemSettingVO();
        mrkItmStngVO.setSbjctId(sbjctId);
        mrkItmStngVO.setOrgId(userCtx.getOrgId());
        lpv.setMrkItmStngList(markItemSettingService.mrkItmStngList(mrkItmStngVO));

        // 주차별 강의내용
        lpv.setLectureScheduleList(lectureScheduleService.profLectureScheduleList(new SubjectParam(sbjctId)));

        // 공통코드 목록
        Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
        // 교재구분코드 목록 조회
        List<CmmnCdVO> txtbkGbncdList = cmmnCdService.listCode(userCtx.getOrgId(), "TXTBK_GBNCD").getReturnList();
        txtbkGbncdList.removeIf(item -> item.getCd().equals(item.getUpCd()));
        cmmnCdList.put("txtbkGbncdList", txtbkGbncdList);
        // 강의유형코드 목록 조회
        List<CmmnCdVO> lctrTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "LCTR_TYCD").getReturnList();
        lctrTycdList.removeIf(item -> item.getCd().equals(item.getUpCd()));
        cmmnCdList.put("lctrTycdList", lctrTycdList);

        lpv.setCmmnCdList(cmmnCdList);

        return lpv;
    }


}
