package knou.lms.asmt.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.SessionInfo;
import knou.framework.util.*;
import knou.framework.vo.FileVO;
import knou.lms.asmt.dao.*;
import knou.lms.asmt.service.AsmtProService;
import knou.lms.asmt.vo.AsmtVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.service.ExamService;
import knou.lms.lesson.dao.LessonScheduleDAO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.mut.dao.MutEvalRltnDAO;
import knou.lms.mut.vo.MutEvalRltnVO;
import net.sf.json.JSONArray;
import org.apache.commons.lang3.ArrayUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.*;

@Service("asmtProService")
public class AsmtProServiceImpl extends EgovAbstractServiceImpl implements AsmtProService {

    /**
     * service
     */
    @Autowired
    private SysFileService sysFileService;

    @Autowired
    private ExamService examService;

    @Resource(name="asmtDAO")
    private AsmtDAO asmtDAO;

    @Resource(name="asmtProDAO")
    private AsmtProDAO asmtProDAO;

    @Resource(name="asmtProIndiDAO")
    private AsmtProIndiDAO asmtProIndiDAO;

    @Resource(name="asmtProTeamDAO")
    private AsmtProTeamDAO asmtProTeamDAO;

    @Resource(name="mutEvalRltnDAO")
    private MutEvalRltnDAO mutEvalRltnDAO;

    @Resource(name="asmtCmntDAO")
    private AsmtCmntDAO asmtCmntDAO;

    @Resource(name="asmtStuIndiDAO")
    private AsmtStuIndiDAO asmtStuIndiDAO;

    @Resource(name="asmtStuTeamDAO")
    private AsmtStuTeamDAO asmtStuTeamDAO;

    @Resource(name="lessonScheduleDAO")
    private LessonScheduleDAO lessonScheduleDAO;

    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    // 과제 조회
    @Override
    public AsmtVO select(AsmtVO vo) throws Exception {
        return asmtProDAO.selectObject(vo);
    }

    // 다건 조회
    @Override
    public List<AsmtVO> list(AsmtVO vo) throws Exception {
        return asmtProDAO.selectList(vo);
    }

    // 페이징 조회
    @Override
    public ProcessResultVO<AsmtVO> listPaging(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<AsmtVO> listPaging = asmtProDAO.selectListPaging(vo);

        if(listPaging.size() > 0) {
            paginationInfo.setTotalRecordCount(listPaging.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        processResultVO.setReturnList(listPaging);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    // 과제 조회
    @Override
    public ProcessResultVO<AsmtVO> selectAsmnt(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        if("OBJECT".equals(vo.getSelectType())) {
            resultVO = selectObject(vo);
        } else if("LIST".equals(vo.getSelectType())) {
            resultVO = selectList(vo);
        } else if("PAGE".equals(vo.getSelectType())) {
            resultVO = selectListPaging(vo);
        }
        return resultVO;
    }

    // 단건 조회
    @Override
    public ProcessResultVO<AsmtVO> selectObject(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            AsmtVO rVo = asmtProDAO.selectObject(vo);

            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("ASMNT");
            fileVO.setFileBindDataSn(rVo.getAsmtId());

            rVo.setFileList(sysFileService.list(fileVO).getReturnList());
            resultVO.setReturnVO(rVo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 다건 조회
    @Override
    public ProcessResultVO<AsmtVO> selectList(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            resultVO.setReturnList(asmtProDAO.selectList(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 페이징 조회
    @Override
    public ProcessResultVO<AsmtVO> selectListPaging(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {

            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getListScale());

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());

            List<AsmtVO> listPaging = asmtProDAO.selectListPaging(vo);

            if(listPaging.size() > 0) {
                paginationInfo.setTotalRecordCount(listPaging.get(0).getTotalCnt());
            } else {
                paginationInfo.setTotalRecordCount(0);
            }

            resultVO.setReturnList(listPaging);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 이전과제 목록 페이징 조회
    @Override
    public ProcessResultVO<AsmtVO> selectPrevAsmntList(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {

            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getListScale());

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());

            List<AsmtVO> listPaging = asmtProDAO.selectPrevAsmntList(vo);

            if(listPaging.size() > 0) {
                paginationInfo.setTotalRecordCount(listPaging.get(0).getTotalCnt());
            } else {
                paginationInfo.setTotalRecordCount(0);
            }

            resultVO.setReturnList(listPaging);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 분반 목록 조회
    @Override
    public List<AsmtVO> selectDeclsList(AsmtVO vo) throws Exception {
        return asmtProDAO.selectDeclsList(vo);
    }

    // 과제 등록
    @Override
    public void insertAsmnt(AsmtVO vo) throws Exception {
        String[] dvclasArray = vo.getDvclasList().split(",");

        dvclasArray = ArrayUtils.removeElement(dvclasArray, "ALL");

        Map<String, String> declsLessonScheduleIdMap = new HashMap<>();

        if(dvclasArray.length == 1) {
            vo.setDvclasCncrntRegyn("N");
        } else {
            vo.setDvclasCncrntRegyn("Y");

            // 주차 선택한경우 -> 방통대는 주차 상관없이 등록
            /*if(!"DEFAULT".equals(StringUtil.nvl(vo.getLctrWknoSchdlId()))) {
                LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
                lessonScheduleVO.setLessonScheduleId(vo.getLctrWknoSchdlId());
                lessonScheduleVO.setSqlForeach(dvclasArray);
                List<LessonScheduleVO> declsLessonScheduleList = lessonScheduleDAO.listDeclsLessonSchedule(lessonScheduleVO);

                for(LessonScheduleVO lessonScheduleVO2 : declsLessonScheduleList) {
                    declsLessonScheduleIdMap.put(lessonScheduleVO2.getCrsCreCd(), lessonScheduleVO2.getLessonScheduleId());
                }
            }*/
        }

        // 과제그룹 등록
        vo.setAsmtGrpId(IdGenUtil.genNewId(IdPrefixType.ASGRP));
        asmtProDAO.insertAsmtGrp(vo);

        for(int i = 0; i < dvclasArray.length; i++) {
            String SbjctId = dvclasArray[i];

            // 과제코드
            if(!"".equals(StringUtil.nvl(vo.getNewAsmtId())) && i == 0) {
                vo.setAsmtId(vo.getNewAsmtId());
            } else {
                String asmtId = IdGenUtil.genNewId(IdPrefixType.ASMT);
                vo.setAsmtId(asmtId);
            }

            /*if(dvclasArray.length > 1) {
                if(declsLessonScheduleIdMap.containsKey(SbjctId)) {
                    vo.setLctrWknoSchdlId(declsLessonScheduleIdMap.get(SbjctId));
                } else {
                    vo.setLctrWknoSchdlId(null);
                }
            }*/

            // 과목개설코드
            vo.setSbjctId(SbjctId);

            // 학습그룹 설정
            if("Y".equals(vo.getTeamAsmtStngyn())) {
                vo.setLrnGrpId("");

                String[] lrnGrpArray = vo.getLrnGrpList().split(",");

                for(String lrnGrp : lrnGrpArray) {
                    String[] team = lrnGrp.split(":");

                    if(SbjctId.equals(team[1])) {
                        vo.setLrnGrpId(team[0]);
                    }
                }
            } else {
                vo.setLrnGrpId("");
            }

            if("N".equals(vo.getExtdSbmsnPrmyn())) {
                vo.setExtdSbmsnSdttm(null);
                vo.setExtdSbmsnEdttm(null);
            }
            if("N".equals(vo.getSbasmtOstdOyn())) {
                vo.setSbasmtOstdOpenSdttm(null);
                vo.setSbasmtOstdOpenEdttm(null);
            }

            // 과제테이블 insert
            asmtProDAO.insertAsmnt(vo);

            // 개설과정 과제 연결 테이블 insert
//            asmtProDAO.insertAsmntCreCrsRltn(vo);

            // 파일저장
            //this.insertFileInfo(vo, vo.getAsmtId(), vo.getPrevAsmtId(), i == dvclasArray.length - 1 ? "Y" : "N");

            // 평가방식 - 루브릭
            if("RUBRIC_SCR".equals(StringUtil.nvl(vo.getEvlScrTycd()))) {
                MutEvalRltnVO mutEvalRltnVO = new MutEvalRltnVO();
                mutEvalRltnVO.setEvalDivCd("PROFESSOR_EVAL");
                mutEvalRltnVO.setRltnCd(StringUtil.nvl(vo.getAsmtId()));
                mutEvalRltnVO.setCrsCreCd(StringUtil.nvl(vo.getCrsCreCd()));
//                mutEvalRltnVO.setAsmtEvlId(StringUtil.nvl(vo.getAsmtEvlId()));
                //mutEvalRltnDAO.insertMutEvalRltn(mutEvalRltnVO);
            }

            // 과제 종류에 따라 과제제출 대상자 추가
            if("Y".equals(vo.getIndvAsmtyn())) { // 개별 과제 (해당 대상자)

                String[] indvAsmtList = vo.getIndvAsmtList().split(",");
                List<AsmtVO> insertindvAsmtList = new ArrayList<>();

                for(String userId : indvAsmtList) {
                    AsmtVO jLVO = new AsmtVO();
                    jLVO.setAsmtSbmsnTrgtId(IdGenUtil.genNewId(IdPrefixType.ASTRG));
                    jLVO.setAsmtId(vo.getAsmtId());
                    jLVO.setUserId(userId); // userId로 넣어야함..
                    jLVO.setRgtrId(vo.getRgtrId());

                    insertindvAsmtList.add(jLVO);
                }

                if(insertindvAsmtList.size() > 0) {
                    asmtProIndiDAO.insertTargetList(insertindvAsmtList);
                    //asmtProIndiDAO.insertTargetFileList(insertindvAsmtList);
                }
            } else if("Y".equals(vo.getTeamAsmtStngyn())) {

                // 팀 과제 (팀)
                List<AsmtVO> jlist = asmtProTeamDAO.selectTarget(vo);

                for(AsmtVO jLVO : jlist) {
                    jLVO.setAsmtSbmsnTrgtId(IdGenUtil.genNewId(IdPrefixType.ASTRG));
                    jLVO.setAsmtId(vo.getAsmtId());
                    jLVO.setRgtrId(vo.getRgtrId());
                }

                if(jlist.size() > 0) {
                    asmtProTeamDAO.insertTargetList(jlist);
                    //asmtProIndiDAO.insertTargetFileList(jlist);
                }
            } else {

                // 일반 과제 (전체 대상자)
                List<AsmtVO> jlist = asmtProIndiDAO.selectTarget(vo);

                for(AsmtVO jLVO : jlist) {
                    jLVO.setAsmtSbmsnTrgtId(IdGenUtil.genNewId(IdPrefixType.ASTRG));
                    jLVO.setAsmtId(vo.getAsmtId());
                    jLVO.setRgtrId(vo.getRgtrId());
                }

                if(jlist.size() > 0) {
                    asmtProIndiDAO.insertTargetList(jlist);
                    //asmtProIndiDAO.insertTargetFileList(jlist);
                }
            }

            this.setScoreRatio(vo);
        }
    }

    // 과제 복사
    @Override
    public void copyAsmnt(AsmtVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String crsCreCd = vo.getCrsCreCd();
        String copyAsmntCd = vo.getCopyAsmtId();
        String rgtrId = vo.getRgtrId();
        String lineNo = vo.getLineNo();

        if(ValidationUtils.isEmpty(orgId)
                || ValidationUtils.isEmpty(crsCreCd)
                || ValidationUtils.isEmpty(copyAsmntCd)
                || ValidationUtils.isEmpty(rgtrId)
                || ValidationUtils.isEmpty(lineNo)) {
            throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
        }

        // 복사대상 과제 조회
        AsmtVO originAsmtVO = new AsmtVO();
        originAsmtVO.setAsmtId(copyAsmntCd);
        originAsmtVO = asmtProDAO.selectObject(originAsmtVO);

        // 과제 복사
        String asmntCd = IdGenerator.getNewId("ASMNT");

        AsmtVO copyAsmtVO = new AsmtVO();
        copyAsmtVO.setCopyAsmtId(copyAsmntCd);
        copyAsmtVO.setAsmtId(asmntCd);
        copyAsmtVO.setCrsCreCd(crsCreCd);
        copyAsmtVO.setRgtrId(rgtrId);
        copyAsmtVO.setLineNo(lineNo);
        asmtProDAO.copyAsmnt(copyAsmtVO);

        // 개설과정 과제 연결 테이블 insert
        asmtProDAO.insertAsmntCreCrsRltn(copyAsmtVO);

        // 평가방식 - 루브릭
        if("R".equals(StringUtil.nvl(originAsmtVO.getEvlScrTycd()))) {
            MutEvalRltnVO mutEvalRltnVO = new MutEvalRltnVO();
            mutEvalRltnVO.setEvalDivCd("PROFESSOR_EVAL");
            mutEvalRltnVO.setRltnCd(asmntCd);
            mutEvalRltnVO.setCrsCreCd(crsCreCd);
            mutEvalRltnVO.setEvalCd(originAsmtVO.getAsmtEvlId());
            mutEvalRltnDAO.insertMutEvalRltn(mutEvalRltnVO);
        }

        FileVO copyFileVO;
        copyFileVO = new FileVO();
        copyFileVO.setOrgId(orgId);
        copyFileVO.setRepoCd("ASMNT");
        copyFileVO.setFileBindDataSn(asmntCd);
        copyFileVO.setCopyFileBindDataSn(copyAsmntCd);
        copyFileVO.setRgtrId(rgtrId);

        sysFileService.copyFileInfoFromOrigin(copyFileVO);
    }

    // 과제 수정
    @Override
    public void updateAsmnt(AsmtVO vo) throws Exception {
        if("N".equals(vo.getExtdSbmsnPrmyn())) {
            vo.setExtdSbmsnSdttm(null);
        }

        if(!"Y".equals(StringUtil.nvl(vo.getEvlRfltyn()))) {
//            vo.setTeamEvalYn("N");
        }

        asmtProDAO.updateAsmnt(vo);

        // 파일저장
        this.insertFileInfo(vo, vo.getAsmtId(), vo.getPrevAsmtId(), "Y");

        AsmtVO asmtVO = new AsmtVO();
        asmtVO.setAsmtId(vo.getAsmtId());
        asmtVO.setCrsCreCd(vo.getCrsCreCd());
        asmtVO = asmtProDAO.selectObject(asmtVO);

        // 평가방식 - 루브릭
        if("R".equals(StringUtil.nvl(vo.getEvlScrTycd())) && !StringUtil.nvl(asmtVO.getAsmtEvlId()).equals(StringUtil.nvl(vo.getAsmtEvlId()))) {
            AsmtVO avo = new AsmtVO();
//            avo.setRltnCd(vo.getAsmtId());
            asmtProDAO.deleteMutEvalRslt(avo);

            MutEvalRltnVO mutEvalRltnVO = new MutEvalRltnVO();
            mutEvalRltnVO.setRltnCd(StringUtil.nvl(vo.getAsmtId()));
            mutEvalRltnDAO.delMutEvalRltnByRltnCd(mutEvalRltnVO);

            mutEvalRltnVO = new MutEvalRltnVO();
            mutEvalRltnVO.setEvalDivCd("PROFESSOR_EVAL");
            mutEvalRltnVO.setRltnCd(StringUtil.nvl(vo.getAsmtId()));
            mutEvalRltnVO.setCrsCreCd(StringUtil.nvl(vo.getCrsCreCd()));
            mutEvalRltnVO.setEvalCd(StringUtil.nvl(vo.getAsmtEvlId()));
            mutEvalRltnDAO.insertMutEvalRltn(mutEvalRltnVO);
        }

        if("0".equals(asmtVO.getSubmitCnt())) {
            // 과제 대상자 삭제
            asmtProIndiDAO.deleteTargetFile(vo);
            asmtProIndiDAO.deleteTarget(vo);

            // 과제 종류에 따라 과제 대상자 추가
            if("Y".equals(vo.getIndvAsmtyn())) { // 개별 과제 (해당 대상자)

                String[] indvAsmtList = vo.getIndvAsmtList().split(",");
                List<AsmtVO> insertindvAsmtList = new ArrayList<>();

                for(String stdNo : indvAsmtList) {
                    AsmtVO jLVO = new AsmtVO();
                    jLVO.setAsmtSbmsnId(IdGenerator.getNewId("SEND"));
                    jLVO.setAsmtId(vo.getAsmtId());
                    jLVO.setUserId(stdNo);
                    jLVO.setUserId(vo.getUserId());

                    insertindvAsmtList.add(jLVO);
                }

                if(insertindvAsmtList.size() > 0) {
                    asmtProIndiDAO.insertTargetList(insertindvAsmtList);
                    asmtProIndiDAO.insertTargetFileList(insertindvAsmtList);
                }
            } else if("Y".equals(vo.getTeamAsmtStngyn())) {
                vo.setLrnGrpId(StringUtil.nvl(vo.getLrnGrpId(), asmtVO.getLrnGrpId()));
                // 팀 과제 (팀)
                List<AsmtVO> jlist = asmtProTeamDAO.selectTarget(vo);

                for(AsmtVO jLVO : jlist) {
                    jLVO.setAsmtSbmsnId(IdGenerator.getNewId("SEND"));
                    jLVO.setAsmtId(vo.getAsmtId());
                    jLVO.setUserId(vo.getUserId());
                }

                if(jlist.size() > 0) {
                    asmtProTeamDAO.insertTargetList(jlist);
                    asmtProIndiDAO.insertTargetFileList(jlist);
                }
            } else {
                // 일반 과제 (전체 대상자)
                List<AsmtVO> jlist = asmtProIndiDAO.selectTarget(vo);

                for(AsmtVO jLVO : jlist) {
                    jLVO.setAsmtSbmsnId(IdGenerator.getNewId("SEND"));
                    jLVO.setAsmtId(vo.getAsmtId());
                    jLVO.setUserId(vo.getUserId());
                }

                if(jlist.size() > 0) {
                    asmtProIndiDAO.insertTargetList(jlist);
                    asmtProIndiDAO.insertTargetFileList(jlist);
                }
            }
        } else {
            // 제출 인원 있을시 개별과제만
            if("Y".equals(vo.getIndvAsmtyn())) {
                // 개별 과제 (해당 대상자)
                List<AsmtVO> stdList = asmtProIndiDAO.selectList(vo);

                // 개별 학습자 삭제
                for(AsmtVO avo : stdList) {
                    if(vo.getIndvAsmtList().indexOf(avo.getUserId()) == -1) {
                        asmtProIndiDAO.deleteTargetFdbkByStdNo(avo);
                        asmtProIndiDAO.deleteTargetHstyByStdNo(avo);
                        asmtProIndiDAO.deleteTargetFileByStdNo(avo);
                        asmtProIndiDAO.deleteTargetByStdNo(avo);
                    }
                }

                String[] indvAsmtList = vo.getIndvAsmtList().split(",");

                for(String stdNo : indvAsmtList) {
                    AsmtVO avo = new AsmtVO();
                    avo.setAsmtId(vo.getAsmtId());
                    avo.setUserId(stdNo);
                    avo = asmtProIndiDAO.selectObject(avo);

                    // 추가된 학습자 등록
                    if(avo == null) {
                        AsmtVO jLVO = new AsmtVO();
                        jLVO.setAsmtSbmsnId(IdGenerator.getNewId("SEND"));
                        jLVO.setAsmtId(vo.getAsmtId());
                        jLVO.setUserId(stdNo);
                        jLVO.setUserId(vo.getUserId());

                        asmtProIndiDAO.insertTarget(jLVO);
                        asmtProIndiDAO.insertTargetFile(jLVO);
                    }
                }
            }
        }

        this.setScoreRatio(vo);
    }

    // 과제 성적공개여부 수정
    @Override
    public ProcessResultVO<AsmtVO> updateScoreOpen(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            asmtProDAO.updateScoreOpen(vo);

            resultVO.setResult(1);
            resultVO.setMessage("수정하였습니다.");
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정하지 못하였습니다.");
            throw e;
        }
        return resultVO;
    }

    // 과제 성적반영비율 수정
    @Override
    public ProcessResultVO<AsmtVO> updateScoreRatio(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {

            String[] asmntArray = vo.getAsmntArray();
            String[] mrkRfltrtArray = vo.getMrkRfltrtArray();

            for(int i = 0; i < asmntArray.length; i++) {
                vo.setAsmtId(asmntArray[i]);
                vo.setMrkRfltrt(mrkRfltrtArray[i]);
                asmtProDAO.updateScoreRatio(vo);
            }
            resultVO.setResult(1);
            resultVO.setMessage("수정하였습니다.");
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정하지 못하였습니다.");
            throw e;
        }
        return resultVO;
    }

    // 과제 삭제
    @Override
    public ProcessResultVO<AsmtVO> deleteAsmnt(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            // 대체 과제 여부 조회 및 삭제
            examService.examInsDelete(vo.getAsmtId());
            asmtProDAO.deleteAsmnt(vo);
            // 개설과정과제 연결 삭제
            asmtProDAO.deleteAsmntCreCrsRltn(vo);
            // 파일 삭제
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
            throw e;
        }
        return resultVO;
    }

    // 과제 대상자 조회
    @Override
    public ProcessResultVO<AsmtVO> selectTargetIndi(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            List<AsmtVO> resultList = asmtProIndiDAO.selectTarget(vo);

            resultVO.setReturnList(resultList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 제재출 수정
    @Override
    public void updateResend(AsmtVO vo) throws Exception {
        AsmtVO asmtVO = asmtProDAO.selectObject(vo);

        String extSendAcptYn = asmtVO.getExtdSbmsnPrmyn();
        String extSendDttm = asmtVO.getExtdSbmsnSdttm();

        if("Y".equals(StringUtil.nvl(extSendAcptYn)) && ValidationUtils.isNotEmpty(extSendDttm)) {
            String resendStartDttm = vo.getResbmsnSdttm();
            String resendEndDttm = vo.getResbmsnEdttm();

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");

            Date extSendDate = dateFormat.parse(extSendDttm);
            Date resendStartDate = dateFormat.parse(resendStartDttm);
            Date resendEndDate = dateFormat.parse(resendEndDttm);

            if(!(extSendDate.before(resendStartDate) && extSendDate.before(resendEndDate))) {
                SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                String[] argu = {outputFormat.format(extSendDate)};
                // 지각 제출 사용중 입니다.\n지각 제출 일시 [{0}] 이후의 날짜를 입력하세요.
                throw processException("asmnt.alert.invalid.range.resend.dttm", argu);
            }
        }

        // 정보 수정
        asmtProDAO.updateResendInfo(vo);

        String[] indvAsmtList = StringUtil.nvl(vo.getIndvAsmtList()).split(",");

        // 대상자 삭제
        AsmtVO deleteResendVO = new AsmtVO();
        deleteResendVO.setAsmtId(vo.getAsmtId());
        if(indvAsmtList.length > 0) {
            deleteResendVO.setSqlForeach(indvAsmtList);
        }
        asmtProIndiDAO.deleteResend(deleteResendVO);

        for(String stdNo : indvAsmtList) {
            vo.setUserId(stdNo);
            asmtProIndiDAO.updateResend(vo); // 대상자 저장
        }
    }

    // (개인)참여자 조회
    @Override
    public ProcessResultVO<AsmtVO> selectJoinIndi(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            if("OBJECT".equals(vo.getSelectType())) {
                AsmtVO rVo = asmtProIndiDAO.selectObject(vo);

                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("ASMNT");
                fileVO.setFileBindDataSn(rVo.getAsmtSbmsnId());

                rVo.setFileList(sysFileService.list(fileVO).getReturnList());
                resultVO.setReturnVO(rVo);
            } else if("LIST".equals(vo.getSelectType())) {
                resultVO.setReturnList(asmtProIndiDAO.selectList(vo));
            } else if("PAGE".equals(vo.getSelectType())) {
                PaginationInfo paginationInfo = new PaginationInfo();
                paginationInfo.setCurrentPageNo(vo.getPageIndex());
                paginationInfo.setRecordCountPerPage(vo.getListScale());
                paginationInfo.setPageSize(vo.getListScale());

                vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
                vo.setLastIndex(paginationInfo.getLastRecordIndex());

                List<AsmtVO> listPaging = asmtProIndiDAO.selectListPaging(vo);

                if(listPaging.size() > 0) {
                    paginationInfo.setTotalRecordCount(listPaging.get(0).getTotalCnt());
                } else {
                    paginationInfo.setTotalRecordCount(0);
                }

                resultVO.setReturnList(listPaging);
                resultVO.setPageInfo(paginationInfo);
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // (개인)성적 수정
    @Override
    public void updateScoreIndi(AsmtVO vo) throws Exception {
        String[] stdArr = vo.getUserId().split(",");

        if(stdArr.length > 0) {
            for(int i = 0; i < stdArr.length; i++) {
                vo.setUserId(stdArr[i]);
                asmtProIndiDAO.updateScore(vo);
            }
        }
    }

    // (개인)성적 일괄 수정
    public void updateScoreIndiBatch(HttpServletRequest request, List<AsmtVO> list) throws Exception {
        String userId = SessionInfo.getUserId(request);

        if(list != null) {
            for(AsmtVO asmtVO : list) {
                asmtVO.setMdfrId(userId);
            }

            asmtProIndiDAO.updateScoreBatch(list);
        }
    }

    // (개인)메모 수정
    @Override
    public ProcessResultVO<AsmtVO> updateMemoIndi(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {

            String[] stdArr = vo.getUserId().split(",");

            if(stdArr.length > 0) {
                for(int i = 0; i < stdArr.length; i++) {
                    vo.setUserId(stdArr[i]);
                    asmtProIndiDAO.updateMemo(vo);
                }
            }

            resultVO.setResult(1);
            resultVO.setMessage("수정하였습니다.");
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정하지 못하였습니다.");
            throw e;
        }
        return resultVO;
    }

    // (개인)우수과제 선정
    @Override
    public ProcessResultVO<AsmtVO> updateBestIndi(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {

            String[] stdList = vo.getIndvAsmtList().split(",");

            if(stdList.length > 0) {
                for(int i = 0; i < stdList.length; i++) {
                    vo.setUserId(stdList[i]);

                    asmtProIndiDAO.updateBest(vo);
                }
            }

            resultVO.setResult(1);
            resultVO.setMessage("수정하였습니다.");
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정하지 못하였습니다.");
            throw e;
        }
        return resultVO;
    }

    // 피드백 조회
    @Override
    public ProcessResultVO<AsmtVO> selectFdbk(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getListScale());

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());

            List<AsmtVO> listPaging = asmtDAO.selectFdbk(vo);

            if(listPaging.size() > 0) {
                paginationInfo.setTotalRecordCount(listPaging.get(0).getTotalCnt());

                for(int i = 0; i < listPaging.size(); i++) {

                    FileVO fileVO = new FileVO();
                    fileVO.setRepoCd("ASMNT");
                    fileVO.setFileBindDataSn(listPaging.get(i).getAsmntFdbkId());

                    listPaging.get(i).setFileList(sysFileService.list(fileVO).getReturnList());
                }
            } else {
                paginationInfo.setTotalRecordCount(0);
            }
            resultVO.setReturnList(listPaging);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
            throw e;
        }
        return resultVO;
    }

    // (팀)참여자 조회
    @Override
    public ProcessResultVO<AsmtVO> selectJoinTeam(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            if("OBJECT".equals(vo.getSelectType())) {
                AsmtVO rVo = asmtProTeamDAO.selectObject(vo);

                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("ASMNT");
                fileVO.setFileBindDataSn(rVo.getAsmtSbmsnId());

                rVo.setFileList(sysFileService.list(fileVO).getReturnList());
                resultVO.setReturnVO(rVo);
            } else if("LIST".equals(vo.getSelectType())) {
                resultVO.setReturnList(asmtProTeamDAO.selectList(vo));
            } else if("PAGE".equals(vo.getSelectType())) {
                PaginationInfo paginationInfo = new PaginationInfo();
                paginationInfo.setCurrentPageNo(vo.getPageIndex());
                paginationInfo.setRecordCountPerPage(vo.getListScale());
                paginationInfo.setPageSize(vo.getListScale());

                vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
                vo.setLastIndex(paginationInfo.getLastRecordIndex());

                List<AsmtVO> listPaging = asmtProTeamDAO.selectListPaging(vo);

                if(listPaging.size() > 0) {
                    paginationInfo.setTotalRecordCount(listPaging.get(0).getTotalCnt());
                } else {
                    paginationInfo.setTotalRecordCount(0);
                }

                resultVO.setReturnList(listPaging);
                resultVO.setPageInfo(paginationInfo);
            }

            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 과목 목록 조회
    @Override
    public ProcessResultVO<AsmtVO> selectCrsCreList(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            resultVO.setReturnList(asmtDAO.selectCrsCreList(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 팀 목록 조회
    @Override
    public ProcessResultVO<AsmtVO> selectTeamList(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            resultVO.setReturnList(asmtProTeamDAO.selectTeamList(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 피드백 저장
    @Override
    public ProcessResultVO<AsmtVO> insertFdbk(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {

            String[] stdArr = vo.getUserId().split(",");

            if(stdArr.length > 0) {
                for(int i = 0; i < stdArr.length; i++) {
                    vo.setUserId(stdArr[i]);
                    vo.setAsmntFdbkId(IdGenerator.getNewId("FDBK"));
                    asmtProDAO.insertFdbk(vo);

                    // 파일저장
                    this.insertFileInfo(vo, vo.getAsmntFdbkId(), "", stdArr.length == (i + 1) ? "Y" : "N");
                }
            }

            resultVO.setResult(1);
            resultVO.setMessage("저장하였습니다.");
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("저장하지 못하였습니다.");
            throw e;
        }
        return resultVO;
    }

    // 피드백 수정
    @Override
    public ProcessResultVO<AsmtVO> updateFdbk(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {

            asmtProDAO.updateFdbk(vo);

            // 파일저장
            this.insertFileInfo(vo, vo.getAsmntFdbkId(), "", "Y");

            resultVO.setResult(1);
            resultVO.setMessage("수정하였습니다.");
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정하지 못하였습니다.");
            throw e;
        }
        return resultVO;
    }

    // 피드백 삭제
    @Override
    public ProcessResultVO<AsmtVO> deleteFdbk(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {

            // 파일 삭제
            /*
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("ASMNT");
            fileVO.setFileBindDataSn(vo.getAsmtId());
            List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
            
            for(FileVO fvo : fileList) {
                sysFileService.removeFile(fvo.getFileSn());
            }
            */

            asmtProDAO.deleteFdbk(vo);

            resultVO.setResult(1);
            resultVO.setMessage("삭제하였습니다.");
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("삭제하지 못하였습니다.");
            throw e;
        }
        return resultVO;
    }

    // 이전과제 제출파일 조회
    @Override
    public ProcessResultVO<AsmtVO> selectPrevAsmntFiles(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {

            List<AsmtVO> oList = asmtProDAO.selectPrevAsmntFiles(vo);

            for(int i = 0; i < oList.size(); i++) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("ASMNT");
                fileVO.setFileBindDataSn(oList.get(i).getAsmtSbmsnId());
                oList.get(i).setFileList(sysFileService.list(fileVO).getReturnList());
            }

            resultVO.setReturnList(oList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 참여이력 조회
    public AsmtVO selectAsmntJoinUser(AsmtVO vo) throws Exception {
        return asmtProDAO.selectAsmntJoinUser(vo);
    }

    // 제출이력 조회
    @Override
    public ProcessResultVO<AsmtVO> selectSubmitHystList(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            resultVO.setReturnList(asmtProDAO.selectSubmitHystList(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 엑셀 업로드(엑셀 성적등록)
    @Override
    public ProcessResultVO<AsmtVO> uploadExcel(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            // 파일저장
            FileVO fileVO = this.insertFileInfo(vo, vo.getAsmntFdbkId(), "", "Y");

            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("startRaw", 4);
            map.put("excelGrid", vo.getExcelGrid());
            map.put("fileVO", fileVO.getFileList().get(0));
            map.put("searchKey", "excelUpload");

            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            List<?> list = excelUtilPoi.simpleReadGrid(map);

            for(int i = 0; i < list.size(); i++) {
                Map<String, Object> stdNoMap = (Map<String, Object>) list.get(i);

                String stdNo = "";
                int score = 0;

                if("TEAM".equals(vo.getAsmtGbncd())) {
                    stdNo = StringUtil.nvl((String) stdNoMap.get("C"));
                    score = (int) Math.round(Math.floor(Double.parseDouble(StringUtil.nvl((String) stdNoMap.get("F"), "0"))));
                } else {
                    stdNo = StringUtil.nvl((String) stdNoMap.get("B"));
                    score = (int) Math.round(Math.floor(Double.parseDouble(StringUtil.nvl((String) stdNoMap.get("D"), "0"))));
                }

                vo.setUserId(stdNo);
                vo.setScr(String.valueOf(score));

                asmtProIndiDAO.updateScoreExcel(vo);
            }

            resultVO.setResult(1);
            resultVO.setMessage("저장하였습니다.");
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("저장하지 못하였습니다.");
            throw e;
        }
        return resultVO;
    }

    // 선택 대상자 과제 파일다운로드 (미사용)
    @Override
    public ProcessResultVO<AsmtVO> getAsmntFileDown(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            String[] stdList = vo.getIndvAsmtList().split(",");
            List<AsmtVO> rList = new ArrayList<AsmtVO>();

            for(int i = 0; i < stdList.length; i++) {
                vo.setUserId(stdList[i]);
                AsmtVO rVo = asmtProIndiDAO.selectObject(vo);

                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("ASMNT");
                if(rVo.getTeamId() != null) {
                    fileVO.setFileBindDataSn(rVo.getTeamId());
                } else {
                    fileVO.setFileBindDataSn(rVo.getAsmtSbmsnId());
                }

                List<FileVO> fList = sysFileService.list(fileVO).getReturnList();

                // 다운로드 파일명 변경 (이름_학번)
                for(int j = 0; j < fList.size(); j++) {
                    String fName = rVo.getUserNm() + "_" + rVo.getUserId();
                    if(j > 0) {
                        fName += "_(" + j + ")";
                    }
                    fList.get(j).setFileNm(fName + "." + fList.get(j).getFileExt());
                }
                rVo.setFileList(fList);

                rList.add(rVo);
            }

            resultVO.setReturnList(rList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }

    // 선택 대상자 과제 파일다운로드
    @Override
    public List<FileVO> getAsmntZipFileDown(AsmtVO vo) throws Exception {
        String[] stdList = vo.getIndvAsmtList().split(",");
        List<FileVO> rList = new ArrayList<>();

        for(int i = 0; i < stdList.length; i++) {
            vo.setUserId(stdList[i]);
            AsmtVO rVo = asmtProIndiDAO.selectObject(vo);

            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("ASMNT");
            fileVO.setFileBindDataSn(rVo.getAsmtSbmsnId());

            List<FileVO> fList = sysFileService.list(fileVO).getReturnList();

            // 다운로드 파일명 변경 (이름_학번)
            for(FileVO fileVO2 : fList) {
                String fName = rVo.getUserNm() + "_" + rVo.getUserId() + "_" + fileVO2.getFileNm();
                fName = fName.replace("." + fileVO2.getFileExt(), "") + "." + fileVO2.getFileExt();

                fileVO2.setFileNm(fName);
            }
            rList.addAll(fList);
        }
        return rList;
    }

    public FileVO insertFileInfo(AsmtVO vo, String nSn, String oSn, String delYn) throws Exception {

        FileVO fVo = new FileVO();
        fVo.setOrgId(vo.getOrgId());
        fVo.setUserId(vo.getUserId());
        fVo.setRepoCd("ASMNT");
        fVo.setFilePath(vo.getUploadPath());

        fVo.setFileBindDataSn(nSn);
        fVo.setCopyFileBindDataSn(oSn);
        fVo.setUploadFiles(vo.getUploadFiles());
        fVo.setCopyFiles(vo.getCopyFiles());
        fVo.setDelFileIds(vo.getDelFileIds());

        fVo.setAudioData(vo.getAudioData());
        fVo.setAudioFile(vo.getAudioFile());

        fVo.setOrginDelYn(delYn);
        sysFileService.insertFileInfo(fVo);

        return fVo;
    }

    // 시험 과제 등록, 수정
    @Override
    public ProcessResultVO<AsmtVO> examAsmntManage(AsmtVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            // 등록
            if("insert".equals(StringUtil.nvl(vo.getSearchMenu()))) {
                // 과제코드
                vo.setAsmtId(IdGenerator.getNewId("ASMNT"));

                // 팀그룹 설정
                if("Y".equals(vo.getTeamAsmtStngyn())) {
                    vo.setLrnGrpId("");

                    String[] teamCtgrArray = vo.getLrnGrpList().split(",");

                    for(String teamCtgr : teamCtgrArray) {
                        String[] team = teamCtgr.split(":");

                        if(vo.getCrsCreCd().equals(team[1])) {
                            vo.setLrnGrpId(team[0]);
                        }
                    }
                } else {
                    vo.setLrnGrpId("");
                }

                // 과제테이블 insert
                asmtProDAO.insertAsmnt(vo);

                // 개설과정 과제 연결 테이블 insert
                asmtProDAO.insertAsmntCreCrsRltn(vo);

                prevCopyFlieAdd(vo);
                // 파일첨부
                if(!"".equals(StringUtil.nvl(vo.getUploadFiles()))) {
                    FileVO fileVO = new FileVO();
                    fileVO.setUploadFiles(vo.getUploadFiles());
                    fileVO.setFilePath(vo.getUploadPath());
                    fileVO.setRepoCd("ASMNT");
                    fileVO.setRgtrId(vo.getUserId());
                    fileVO.setFileBindDataSn(vo.getAsmtId());
                    sysFileService.addFile(fileVO);
                }

                // 평가방식 - 루브릭
                if("R".equals(StringUtil.nvl(vo.getEvlScrTycd()))) {
                    MutEvalRltnVO mutEvalRltnVO = new MutEvalRltnVO();
                    mutEvalRltnVO.setEvalDivCd("PROFESSOR_EVAL");
                    mutEvalRltnVO.setRltnCd(StringUtil.nvl(vo.getAsmtId()));
                    mutEvalRltnVO.setCrsCreCd(StringUtil.nvl(vo.getCrsCreCd()));
                    mutEvalRltnVO.setEvalCd(StringUtil.nvl(vo.getAsmtEvlId()));
                    mutEvalRltnDAO.insertMutEvalRltn(mutEvalRltnVO);
                }

                // 과제 종류에 따라 과제 대상자 추가
                if("Y".equals(vo.getIndvAsmtyn())) {
                    // 개별 과제 (해당 대상자)
                    String[] indvAsmtList = vo.getIndvAsmtList().split(",");
                    List<AsmtVO> insertindvAsmtList = new ArrayList<>();

                    for(String stdNo : indvAsmtList) {
                        AsmtVO jLVO = new AsmtVO();
                        jLVO.setAsmtSbmsnId(IdGenerator.getNewId("SEND"));
                        jLVO.setAsmtId(vo.getAsmtId());
                        jLVO.setUserId(stdNo);
                        jLVO.setUserId(vo.getUserId());

                        insertindvAsmtList.add(jLVO);
                    }

                    if(insertindvAsmtList.size() > 0) {
                        asmtProIndiDAO.insertTargetList(insertindvAsmtList);
                        asmtProIndiDAO.insertTargetFileList(insertindvAsmtList);
                    }
                } else if("Y".equals(vo.getTeamAsmtStngyn())) {
                    // 팀 과제 (팀)
                    List<AsmtVO> jlist = asmtProTeamDAO.selectTarget(vo);

                    for(AsmtVO jLVO : jlist) {
                        jLVO.setAsmtSbmsnId(IdGenerator.getNewId("SEND"));
                        jLVO.setAsmtId(vo.getAsmtId());
                    }

                    if(jlist.size() > 0) {
                        asmtProTeamDAO.insertTargetList(jlist);
                        asmtProIndiDAO.insertTargetFileList(jlist);
                    }
                } else {
                    // 일반 과제 (전체 대상자)
                    List<AsmtVO> jlist = asmtProIndiDAO.selectTarget(vo);

                    for(AsmtVO jLVO : jlist) {
                        jLVO.setAsmtSbmsnId(IdGenerator.getNewId("SEND"));
                        jLVO.setAsmtId(vo.getAsmtId());
                    }

                    if(jlist.size() > 0) {
                        asmtProIndiDAO.insertTargetList(jlist);
                        asmtProIndiDAO.insertTargetFileList(jlist);
                    }
                }
            } else if("update".equals(StringUtil.nvl(vo.getSearchMenu()))) {
                AsmtVO asmtVO = new AsmtVO();
                asmtVO.setAsmtId(vo.getAsmtId());
                asmtVO.setCrsCreCd(vo.getCrsCreCd());
                asmtVO = asmtProDAO.selectObject(asmtVO);

                // 평가방식 - 루브릭
                if("R".equals(StringUtil.nvl(vo.getEvlScrTycd())) && !StringUtil.nvl(asmtVO.getAsmtEvlId()).equals(StringUtil.nvl(vo.getAsmtEvlId()))) {
                    AsmtVO avo = new AsmtVO();
//                    avo.setRltnCd(vo.getAsmtId());
                    asmtProDAO.deleteMutEvalRslt(avo);

                    MutEvalRltnVO mutEvalRltnVO = new MutEvalRltnVO();
                    mutEvalRltnVO.setRltnCd(StringUtil.nvl(vo.getAsmtId()));
                    mutEvalRltnDAO.delMutEvalRltnByRltnCd(mutEvalRltnVO);

                    mutEvalRltnVO = new MutEvalRltnVO();
                    mutEvalRltnVO.setEvalDivCd("PROFESSOR_EVAL");
                    mutEvalRltnVO.setRltnCd(StringUtil.nvl(vo.getAsmtId()));
                    mutEvalRltnVO.setCrsCreCd(StringUtil.nvl(vo.getCrsCreCd()));
                    mutEvalRltnVO.setEvalCd(StringUtil.nvl(vo.getAsmtEvlId()));
                    mutEvalRltnDAO.insertMutEvalRltn(mutEvalRltnVO);
                }

                // 수정
                asmtProDAO.updateAsmnt(vo);

                if(vo.getDelFileIds().length > 0) {
                    for(String delFileId : vo.getDelFileIds()) {
                        FileVO fileVO = new FileVO();
                        fileVO.setRepoCd("ASMNT");
                        fileVO.setFileBindDataSn(vo.getAsmtId());
                        List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

                        for(FileVO fvo : fileList) {
                            if(delFileId.equals(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")))) {
                                sysFileService.removeFile(fvo.getFileSn());
                            }
                        }
                    }
                }
                prevCopyFlieAdd(vo);
                if(!"".equals(StringUtil.nvl(vo.getUploadFiles()))) {
                    FileVO fileVO = new FileVO();
                    fileVO.setUploadFiles(vo.getUploadFiles());
                    fileVO.setFilePath(vo.getUploadPath());
                    fileVO.setRepoCd("ASMNT");
                    fileVO.setRgtrId(vo.getRgtrId());
                    fileVO.setFileBindDataSn(vo.getAsmtId());
                    sysFileService.addFile(fileVO);
                }

            } else if("delete".equals(StringUtil.nvl(vo.getSearchMenu()))) {
                // 대체 과제 여부 조회 및 삭제
                examService.examInsDelete(vo.getAsmtId());
                asmtProDAO.deleteAsmnt(vo);

                // 개설과정과제 연결 삭제
                asmtProDAO.deleteAsmntCreCrsRltn(vo);

                // 파일 삭제
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("ASMNT");
                fileVO.setFileBindDataSn(vo.getAsmtId());
                List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

                for(FileVO fvo : fileList) {
                    sysFileService.removeFile(fvo.getFileSn());
                }
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
            throw e;
        }
        resultVO.setReturnVO(vo);

        return resultVO;
    }

    // 이전 첨부파일 복사
    private void prevCopyFlieAdd(AsmtVO vo) throws Exception {

        if(!"".equals(StringUtil.nvl(vo.getSearchTo())) && !"".equals(StringUtil.nvl(vo.getFileSns()))) {
            // 기존 파일 삭제
            FileVO delFileVO = new FileVO();
            delFileVO.setRepoCd(vo.getRepoCd());
            delFileVO.setFileBindDataSn(vo.getAsmtId());
            List<FileVO> delFileList = sysFileService.list(delFileVO).getReturnList();

            for(FileVO dfvo : delFileList) {
                sysFileService.removeFile(dfvo);
            }

            // 이전 시험 파일 복사
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd(vo.getRepoCd());
            fileVO.setFileBindDataSn(vo.getSearchTo());
            fileVO.setFileSnList(StringUtil.nvl(vo.getFileSns()).split(","));
            List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

            String fileSns = "";
            // 이전 파일 중 삭제 클릭 파일 제외
            for(FileVO list : fileList) {
                String fileId = list.getFileId();
                boolean isChk = true;
                for(String delFileId : vo.getDelFileIds()) {
                    if(fileId.equals(delFileId)) {
                        isChk = false;
                    }
                }
                if(isChk) {
                    fileSns += list.getFileSn() + ",";
                }
            }
            if(!"".equals(fileSns)) {
                fileVO.setFileSnList(fileSns.split(","));
            }
            fileList = sysFileService.list(fileVO).getReturnList();
            fileVO.setFileList(fileList);
            List<Map<String, String>> uploadFiles = new ArrayList<Map<String, String>>();

            for(FileVO fvo2 : fileList) {
                Map<String, String> map = new HashMap<String, String>();
                map.put("fileNm", fvo2.getFileNm());
                map.put("fileId", fvo2.getFileId());
                map.put("fileSize", fvo2.getFileSize().toString());
                uploadFiles.add(map);
            }
            JSONArray uploadFile = JSONArray.fromObject(uploadFiles);
            fileVO.setUploadFiles(uploadFile.toString());
            fileVO.setFilePath(vo.getUploadPath());
            fileVO.setRgtrId(vo.getRgtrId());
            fileVO.setFileBindDataSn(vo.getAsmtId());
            sysFileService.copyFile(fileVO);
        }
    }

    // 과제 수정
    @Override
    public void chkNewStd(AsmtVO vo) throws Exception {

        // 과제 목록 조회
        List<AsmtVO> aList = asmtDAO.selectAsmntList(vo);

        if(aList.size() > 0) {
            // 과제에 신규 수강생 추가
            for(AsmtVO aVo : aList) {
                // 과제 종류에 따라 과제 대상자 추가
                if("SBST".contains(aVo.getAsmtGbncd())) {
                    // 대체과제 추가 안함
                    continue;
                } else if("Y".equals(aVo.getIndvAsmtyn())) {
                    // 개별 과제 (해당 대상자)
                    // 개별과제는 신규 수강생 자동 추가 안함
                    continue;
                } else if("Y".equals(aVo.getTeamAsmtStngyn())) {
                    // 팀 과제 (팀)
                    // 신규 수강생 목록 조회
                    List<AsmtVO> sList = asmtDAO.selectChkUpdateStd(aVo);
                    if(sList.size() > 0) {
                        for(AsmtVO sVo : sList) {

                            AsmtVO tVo = asmtProTeamDAO.selectTeamCd(sVo);
                            sVo.setAsmtSbmsnId(IdGenUtil.genNewId(IdPrefixType.ASTRG));
                            sVo.setAsmtId(aVo.getAsmtId());
                            sVo.setLrnGrpId(aVo.getLrnGrpId());
                            if(tVo != null) {
                                sVo.setTeamId(tVo.getTeamId());
                            }
                        }

                        if(sList.size() > 0) {
                            asmtProTeamDAO.insertTargetList(sList);
                            //asmtProIndiDAO.insertTargetFileList(sList); // 파일 등록을 왜하지?
                        }
                    }
                } else {
                    // 일반 과제 (전체 대상자)
                    List<AsmtVO> sList = asmtDAO.selectChkUpdateStd(aVo);

                    if(sList.size() > 0) {
                        for(AsmtVO sVo : sList) {
                            sVo.setAsmtId(aVo.getAsmtId());
                            sVo.setAsmtSbmsnId(IdGenUtil.genNewId(IdPrefixType.ASTRG));
                        }

                        if(sList.size() > 0) {
                            asmtProIndiDAO.insertTargetList(sList);
                            //asmtProIndiDAO.insertTargetFileList(sList);
                        }
                    }
                }

                // 과제에 삭제 수강생 업데이트
                List<AsmtVO> dList = asmtDAO.selectChkDeleteStd(aVo);
                for(AsmtVO dVo : dList) {
                    dVo.setAsmtId(aVo.getAsmtId());
                }

                if(dList.size() > 0) {
                    asmtDAO.deleteStdList(dList);
                }
            }
        }
    }

    // 성적반영비율 초기화
    @Override
    public void setScoreRatio(AsmtVO vo) throws Exception {
        List<AsmtVO> scoreAplyList = asmtProDAO.getScoreRatio(vo);

        if(!scoreAplyList.isEmpty()) {
            int scoreAplyCnt = scoreAplyList.size();
            int share = 100 / scoreAplyCnt;
            int rest = 100 % scoreAplyCnt;
            int cnt = 0;
            Integer scoreRatio = 0;

            for(AsmtVO asmtVO : scoreAplyList) {
                if(cnt == 0) {
                    scoreRatio = share + rest;
                } else {
                    scoreRatio = share;
                }
                vo.setMrkRfltrt(scoreRatio + "");
                vo.setAsmtId(asmtVO.getAsmtId());
                asmtProDAO.setScoreRatio(vo);
                cnt++;
            }
        }
    }

    // 과제 댓글 목록 조회
    @Override
    public ProcessResultVO<AsmtVO> listCmnt(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            List<AsmtVO> cmntList = asmtCmntDAO.listCmnt(vo);
            resultVO.setReturnList(cmntList);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 과제 댓글 등록
    @Override
    public ProcessResultVO<AsmtVO> insertCmnt(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            vo.setAsmntCmntId(IdGenerator.getNewId("CMNT"));
            asmtCmntDAO.insertCmnt(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
            throw e;
        }
        return resultVO;
    }

    // 과제 댓글 수정
    @Override
    public ProcessResultVO<AsmtVO> updateCmnt(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            asmtCmntDAO.updateCmnt(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
            throw e;
        }
        return resultVO;
    }

    // 루브릭 수정
    @Override
    public ProcessResultVO<AsmtVO> updateMutEval(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            MutEvalRltnVO mutEvalRltnVO = new MutEvalRltnVO();
            mutEvalRltnVO.setRltnCd(StringUtil.nvl(vo.getAsmtId()));
            mutEvalRltnDAO.delMutEvalRltnByRltnCd(mutEvalRltnVO);

            mutEvalRltnVO = new MutEvalRltnVO();
            mutEvalRltnVO.setEvalDivCd("PROFESSOR_EVAL");
            mutEvalRltnVO.setRltnCd(StringUtil.nvl(vo.getAsmtId()));
            mutEvalRltnVO.setCrsCreCd(StringUtil.nvl(vo.getCrsCreCd()));
            mutEvalRltnVO.setEvalCd(StringUtil.nvl(vo.getAsmtEvlId()));
            mutEvalRltnDAO.insertMutEvalRltn(mutEvalRltnVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
            throw e;
        }
        return resultVO;
    }

    // 과제 루브릭 저장
    @Override
    public void insertMutEvalRslt(AsmtVO vo) throws Exception {
        String qstnCd = StringUtil.nvl(vo.getQstnCd());
        String gradeCd = StringUtil.nvl(vo.getGradeCd());
        String evalScore = StringUtil.nvl(vo.getEvalScore());
        if(!"".equals(qstnCd)) {
            for(String stdNo : vo.getUserId().split(",")) {
                for(int i = 0; i < qstnCd.split(",").length; i++) {
                    AsmtVO avo = new AsmtVO();
                    avo.setUserId(stdNo);
                    avo.setAsmtEvlId(vo.getAsmtEvlId());
                    avo.setRltnCd(vo.getRltnCd());
                    avo.setQstnCd(qstnCd.split(",")[i]);
                    avo = asmtProDAO.selectMutEvalRslt(avo);
                    vo.setQstnCd(qstnCd.split(",")[i]);
                    vo.setGradeCd(gradeCd.split(",")[i]);
                    vo.setEvalScore(evalScore.split(",")[i]);
                    if(avo == null) {
                        vo.setMutEvalCd(IdGenerator.getNewId("MUT"));
                        asmtProDAO.insertMutEvalRslt(vo);
                    } else {
                        asmtProDAO.updateMutEvalRslt(vo);
                    }
                }
            }
        }
    }

    // 과제 루브릭 평가 연결 목록 조회
    @Override
    public ProcessResultVO<AsmtVO> listMutEvalRslt(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            List<AsmtVO> returnList = asmtProDAO.listMutEvalRslt(vo);
            resultVO.setReturnList(returnList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
        }
        return resultVO;
    }

    // 과제 대상자 루브릭 점수 채점 취소
    @Override
    public void cancelMutEvalRslt(AsmtVO vo) throws Exception {
        asmtProIndiDAO.canecelTargetMutScore(vo);
        asmtProDAO.deleteMutEvalRsltByStdNo(vo);
    }

    /*****************************************************
     * 상호평가 목록 조회
     * @param vo
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<AsmtVO> listMutEval(AsmtVO vo) throws Exception {
        return asmtDAO.listMutEval(vo);
    }

    // 교수자가 미제출 과제 대리등록
    @Override
    public void serInsertAsmnt(AsmtVO vo) throws Exception {

        String sbmsnStscd = "SUBMIT";

        AsmtVO Vo = asmtStuIndiDAO.selectObject(vo);
        Vo.setSbmsnStscd(sbmsnStscd);

        if("Y".equals(vo.getTeamAsmtStngyn())) {

            List<AsmtVO> tList = asmtStuTeamDAO.selectTeamList(vo);

            for(int i = 0; i < tList.size(); i++) {
                vo.setAsmtSbmsnId(tList.get(i).getAsmtSbmsnId());
                vo.setUserId(tList.get(i).getUserId());
                vo.setUserId(tList.get(i).getUserId());

                if(!"".equals(StringUtil.nvl(tList.get(i).getFileIds()))) {
                    String[] delFileIds = tList.get(i).getFileIds().split(",");
                    vo.setDelFileIds(delFileIds);
                }

                this.insertFileInfo(vo, vo.getAsmtSbmsnId(), i == tList.size() - 1 ? "Y" : "N");

                asmtStuIndiDAO.updateTargetSer(vo);
                asmtStuIndiDAO.updateTargetFile(vo);

//                vo.setHstyCd(IdGenerator.getNewId("HYST"));
                asmtStuIndiDAO.insertTargetHsty(vo);
            }

        } else {
            this.insertFileInfo(vo, Vo.getAsmtSbmsnId(), "Y");

            asmtStuIndiDAO.updateTargetSer(Vo);
            asmtStuIndiDAO.updateTargetFile(Vo);

//            Vo.setHstyCd(IdGenerator.getNewId("HYST"));
//            vo.setFileRegDttm(Vo.getModDttm());
        }
    }

    // 교수자가 미제출 과제 일괄 대리등록
    @Override
    public void serInsertAsmntBatch(HttpServletRequest request, AsmtVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        String asmntCd = vo.getAsmtId();
        String[] indvAsmtList = StringUtil.nvl(vo.getIndvAsmtList()).split(",");

        if(ValidationUtils.isEmpty(crsCreCd)
                || ValidationUtils.isEmpty(asmntCd)
                || ValidationUtils.isEmpty(indvAsmtList)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw processException("common.system.error");
        }

        AsmtVO avo = asmtDAO.selectAsmnt(vo);
        String teamAsmntCfgYn = StringUtil.nvl(avo.getTeamAsmtStngyn(), "N");

        if("Y".equals(teamAsmntCfgYn)) {
            // 팀 과제에서 사용불가능 합니다.
            throw processException("asmnt.alert.unable.team");
        }

        // 미제출자 목록 조회
        AsmtVO asmtVO = new AsmtVO();
        asmtVO.setCrsCreCd(crsCreCd);
        asmtVO.setAsmtId(asmntCd);
        asmtVO.setSqlForeach(indvAsmtList);
        List<AsmtVO> list = asmtStuIndiDAO.selectAsmntJoinUserList(asmtVO);

        for(AsmtVO asmtVO2 : list) {
            if(!"NO".equals(StringUtil.nvl(asmtVO2.getSbmsnStscd(), "NO"))) {
                // 미제출자만 선택하세요.
                throw processException("asmnt.alert.select.no.submit.user");
            } else {
                asmtVO = new AsmtVO();
                asmtVO.setCrsCreCd(crsCreCd);
                asmtVO.setAsmtId(asmntCd);
                asmtVO.setTeamAsmtStngyn(teamAsmntCfgYn);
                asmtVO.setUserId(asmtVO2.getUserId());

                this.serInsertAsmnt(asmtVO);

                try {
                    // 강의실 활동 로그 등록
                    logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_ASSIGNMENT, "[" + avo.getAsmtTtl() + "] [" + asmtVO2.getUserId() + "] 과제 일괄 제출처리");
                } catch(Exception e) {

                }
            }
        }
    }

    // 미제출 처리
    @Override
    public void editNoSubmit(AsmtVO vo) throws Exception {
        String asmntCd = vo.getAsmtId();
        String asmntSendCd = vo.getAsmtSbmsnId();
        String mdfrId = vo.getMdfrId();

        if(ValidationUtils.isEmpty(asmntCd) || ValidationUtils.isEmpty(asmntSendCd) || ValidationUtils.isEmpty(mdfrId)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw processException("common.system.error");
        }

        AsmtVO asmtVO = new AsmtVO();
        asmtVO.setAsmtId(asmntCd);
        asmtVO = asmtProDAO.selectObject(asmtVO);

        if(asmtVO == null) {
            throw processException("asmt.alert.not.exists.asmn"); // 과제 정보를 찾을 수 없습니다.
        }

        String teamAsmntCfgYn = asmtVO.getTeamAsmtStngyn();

        if("Y".equals(StringUtil.nvl(teamAsmntCfgYn))) {
            AsmtVO asmtVO2 = new AsmtVO();
            asmtVO2.setAsmtId(asmntCd);
            asmtVO2.setAsmtSbmsnId(asmntSendCd);

            List<AsmtVO> tList = asmtStuTeamDAO.selectTeamList(asmtVO2);

            for(AsmtVO teamAsmtVO : tList) {
                String fileIds = teamAsmtVO.getFileIds();
                String sbmsnStscd = teamAsmtVO.getSbmsnStscd();

                if("".equals(StringUtil.nvl(fileIds))) {
                    if(!"SUBMIT".equals(StringUtil.nvl(sbmsnStscd))) {
                        // 교수가 제출처리한 학생만 미제출처리를 할 수 있습니다.
                        throw processException("asmnt.alert.invalid.user.no.submit");
                    }

                    AsmtVO stuUpdateAsmtVO = new AsmtVO();
                    stuUpdateAsmtVO.setAsmtId(asmntCd);
                    stuUpdateAsmtVO.setAsmtSbmsnId(teamAsmtVO.getAsmtSbmsnId());
                    stuUpdateAsmtVO.setSbmsnStscd("NO");
                    stuUpdateAsmtVO.setMdfrId(mdfrId);
                    asmtStuIndiDAO.revertTarget(stuUpdateAsmtVO);
                    asmtStuIndiDAO.revertTargetFile(stuUpdateAsmtVO);
                } else {
                    // 제출한 파일이 있어 미제출처리를 할 수 없습니다.
                    throw processException("asmnt.alert.revert.no.submit.file.exist");
                }
            }
        } else {
            AsmtVO stuAsmtVO = new AsmtVO();
            stuAsmtVO.setAsmtId(asmntCd);
            stuAsmtVO.setAsmtSbmsnId(asmntSendCd);
            stuAsmtVO = asmtStuIndiDAO.selectAsmntJoinUser(stuAsmtVO);

            if(stuAsmtVO == null) {
                // 과제 제출 정보를 찾을 수 없습니다.
                throw processException("asmnt.alert.not.exists.asmnt.join.user");
            }

//            int fileCnt = stuAsmtVO.getFileCnt();
            // 임시처리
            int fileCnt = 0;

            String sbmsnStscd = stuAsmtVO.getSbmsnStscd();

            if(fileCnt == 0) {
                if(!"SUBMIT".equals(StringUtil.nvl(sbmsnStscd))) {
                    // 교수가 제출처리한 학생만 미제출처리를 할 수 있습니다.
                    throw processException("asmnt.alert.invalid.user.no.submit");
                }

                AsmtVO stuUpdateAsmtVO = new AsmtVO();
                stuUpdateAsmtVO.setAsmtId(asmntCd);
                stuUpdateAsmtVO.setAsmtSbmsnId(asmntSendCd);
                stuUpdateAsmtVO.setSbmsnStscd("NO");
                stuUpdateAsmtVO.setMdfrId(mdfrId);
                asmtStuIndiDAO.revertTarget(stuUpdateAsmtVO);
                asmtStuIndiDAO.revertTargetFile(stuUpdateAsmtVO);
            } else {
                // 제출한 파일이 있어 미제출처리를 할 수 없습니다.
                throw processException("asmnt.alert.revert.no.submit.file.exist");
            }
        }
    }

    public FileVO insertFileInfo(AsmtVO vo, String nSn, String delYn) throws Exception {

        FileVO fVo = new FileVO();
        fVo.setOrgId(vo.getOrgId());
        fVo.setUserId(vo.getUserId());
        fVo.setRepoCd("ASMNT");
        fVo.setFilePath(vo.getUploadPath());
        fVo.setFileBindDataSn(nSn);
        fVo.setUploadFiles(vo.getUploadFiles());
        fVo.setDelFileIds(vo.getDelFileIds());
        fVo.setOrginDelYn(delYn);

        sysFileService.insertFileInfo(fVo);

        return fVo;
    }
}
