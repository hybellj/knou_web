package knou.lms.asmt2.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.util.*;
import knou.lms.asmt2.dao.AsmtDAO;
import knou.lms.asmt2.dao.AsmtProfIndivDAO;
import knou.lms.asmt2.dao.AsmtProfTeamDAO;
import knou.lms.asmt2.service.AsmtService;
import knou.lms.asmt2.vo.*;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.service.ExamService;
import knou.lms.exam.vo.ExamVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.subject.vo.SubjectVO;
import org.apache.commons.lang.StringUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.net.URLEncoder;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service("asmt2Service")
public class AsmtServiceImpl extends EgovAbstractServiceImpl implements AsmtService {

    @Resource(name="asmt2DAO")
    private AsmtDAO asmtDAO;
    @Resource(name="asmt2ProfIndivDAO")
    private AsmtProfIndivDAO asmtProfIndivDAO;
    @Resource(name="attachFileService")
    private AttachFileService attachFileService;
    @Resource(name="asmt2ProfTeamDAO")
    private AsmtProfTeamDAO asmtProfTeamDAO;

    @Resource(name="examService")
    private ExamService examService;


    /**
     * 과제목록 페이징
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> asmtListPaging(AsmtVO vo) throws Exception {
        ProcessResultVO<EgovMap> processResultVO = new ProcessResultVO<>();
        // 페이지 정보 설정
        PageInfo pageInfo = new PageInfo(vo);

        List<EgovMap> asmtList = asmtDAO.asmtListPaging(vo);

        // 페이지 전체 건수정보 설정
        pageInfo.setTotalRecord(asmtList);

        processResultVO.setReturnList(asmtList);
        processResultVO.setPageInfo(pageInfo);

        return processResultVO;
    }

    /**
     * 성적반영비율 수정
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<AsmtVO> mrkRfltrtModify(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();

        try {
            String[] asmtArray = vo.getAsmtArray();
            String[] mrkRfltrtArray = vo.getMrkRfltrtArray();

            if(asmtArray == null || mrkRfltrtArray == null) {
                resultVO.setResult(-1);
                resultVO.setMessage("성적반영비율 수정 대상이 없습니다.");
                return resultVO;
            }

            if(asmtArray.length != mrkRfltrtArray.length) {
                resultVO.setResult(-1);
                resultVO.setMessage("성적반영비율 수정 데이터가 올바르지 않습니다.");
                return resultVO;
            }

            for(int i = 0; i < asmtArray.length; i++) {
                vo.setAsmtId(asmtArray[i]);
                vo.setMrkRfltrt(mrkRfltrtArray[i]);
                asmtDAO.mrkRfltrtModify(vo);
            }

            resultVO.setResult(1);
            resultVO.setMessage("수정하였습니다.");
            resultVO.setReturnVO(vo);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정하지 못하였습니다.");
        }

        return resultVO;
    }

    /**
     * 성적공개여부 수정
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<AsmtVO> mrkOynModify(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            asmtDAO.mrkOynModify(vo);

            resultVO.setResult(1);
            resultVO.setMessage("수정하였습니다.");
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정하지 못하였습니다.");
        }
        return resultVO;
    }

    /**
     * 재제출 후보자 목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> resbmsnCandidateList(AsmtVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        resultVO.setReturnList(asmtProfIndivDAO.resbmsnCandidateList(vo));
        return resultVO;
    }

    /**
     * 재제출 대상 목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> resbmsnTrgtList(AsmtVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        resultVO.setReturnList(asmtProfIndivDAO.resbmsnTrgtList(vo));
        return resultVO;
    }

    /**
     * 교수 과제 재제출 수정
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void profAsmtResbmsnModify(AsmtVO vo) throws Exception {
        EgovMap asmtInfo = asmtDAO.asmtSelect(vo);
        String extdSbmsnPrmyn = (String) asmtInfo.get("extdSbmsnPrmyn");
        String extdSbmsnEdttm = (String) asmtInfo.get("extdSbmsnEdttm");

        if("Y".equals(StringUtil.nvl(extdSbmsnPrmyn)) && ValidationUtils.isNotEmpty(extdSbmsnEdttm)) {
            String resbmsnSdttm = vo.getResbmsnSdttm();
            String resbmsnEdttm = vo.getResbmsnEdttm();

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
            dateFormat.setLenient(false);

            Date extdSbmsnEndDate = dateFormat.parse(extdSbmsnEdttm);
            Date resbmsnStartDate = dateFormat.parse(resbmsnSdttm);
            Date resbmsnEndDate = dateFormat.parse(resbmsnEdttm);

            if(!(extdSbmsnEndDate.before(resbmsnStartDate) && extdSbmsnEndDate.before(resbmsnEndDate))) {
                SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                String[] argu = {outputFormat.format(extdSbmsnEndDate)};
                // 지각 제출 사용중 입니다.\n지각 제출 일시 [{0}] 이후의 날짜를 입력하세요.
                throw processException("asmnt.alert.invalid.range.resend.dttm", argu);
            }
        }

        // 재제출정보 수정
        asmtDAO.asmtResbmsnModify(vo);


        String[] userIdArray = Arrays.stream(StringUtil.nvl(vo.getIndvAsmtList()).split(","))
                .map(String::trim)
                .filter(ValidationUtils::isNotEmpty)
                .toArray(String[]::new);

        AsmtTrgtVO asmtTrgtVO = new AsmtTrgtVO();
        asmtTrgtVO.setAsmtId(vo.getAsmtId());
        asmtTrgtVO.setUserIdArray(userIdArray);
        asmtTrgtVO.setMdfrId(vo.getMdfrId());

        // 기존 재제출 대상 해제(선택자 제외)
        asmtDAO.resetResbmsnTarget(asmtTrgtVO);

        // 선택 대상 재제출 설정
        if(userIdArray.length > 0) {
            asmtDAO.applyResbmsnTarget(asmtTrgtVO);
        }

        // 선택 대상 점수 초기화
        if(userIdArray.length > 0) {
            asmtDAO.resetResbmsnScore(asmtTrgtVO);
        }
    }

    /**
     * 재제출관리여부
     *
     * @param asmtMap
     * @return
     * @throws Exception
     */
    @Override
    public String resbmsnMngyn(EgovMap asmtMap) throws Exception {
        String asmtSbmsnEdttm = (String) asmtMap.get("asmtSbmsnEdttm");   // 기본 제출 종료일시
        String extdSbmsnPrmyn = (String) asmtMap.get("extdSbmsnPrmyn");   // 연장제출 여부
        String extdSbmsnEdttm = (String) asmtMap.get("extdSbmsnEdttm");   // 연장 제출 종료일시

        if(ValidationUtils.isEmpty(asmtSbmsnEdttm)) {
            return "N";
        }

        String now = DateTimeUtil.getCurrentString(); // yyyyMMddHHmmss

        // 연장제출 사용 시 → 연장 종료 기준
        if("Y".equals(StringUtil.nvl(extdSbmsnPrmyn))) {

            if(ValidationUtils.isEmpty(extdSbmsnEdttm)) {
                return "N";
            }

            return now.compareTo(extdSbmsnEdttm) > 0 ? "Y" : "N";
        }

        // 연장제출 미사용 → 기본 종료 기준
        return now.compareTo(asmtSbmsnEdttm) > 0 ? "Y" : "N";
    }

    /**
     * 과제 삭제
     *
     * @param asmtVO
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> asmtDelete(AsmtVO asmtVO) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        // 대체과제 삭제
        if(asmtVO.getAsmtGbncd().contains("SBST")) {
            ExamVO examVO = new ExamVO();
            examVO.setAsmtId(asmtVO.getAsmtId());
            examService.deleteExamSbst(examVO);
        }
        // 하위 부과제 및 대상자 삭제
        deleteSubAsmtList(asmtVO);
        asmtDAO.asmtSbmsnTrgtDelete(asmtVO);

        // 과제 삭제
        asmtDAO.asmtDelete(asmtVO);
        // 성적반영비율 수정
        this.resetAsmtMrkRfltrt(asmtVO);

        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * 성적반영비율 재정렬
     * 재정렬 대상
     * = 같은 SBJCT_ID
     * + 삭제 안 된 과제
     * + 상위과제
     * + 대체과제 제외(ASMT_GBNCD not like '%SBST%')
     *
     * @param asmtVO
     * @throws Exception
     */
    @Override
    public void resetAsmtMrkRfltrt(AsmtVO asmtVO) throws Exception {

        asmtDAO.resetMrkRfltrt(asmtVO);

    }

    /**
     * 루브릭 내용 수정 시 해당 루브릭을 사용하는 과제 평가점수 초기화
     *
     * @param asmtVO
     * @throws Exception
     */
    @Override
    public void resetAsmtEvlScrByRubricModify(AsmtVO asmtVO) throws Exception {
        if(asmtVO == null || StringUtil.isNull(asmtVO.getRubricId())) {
            return;
        }

        asmtDAO.resetAsmtEvlScrByRubricModify(asmtVO);
    }

    /**
     * 과제 메모 수정
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void asmtMemoModify(AsmtEvlVO vo) throws Exception {
        List<String> userIdList = new ArrayList<>();

        if("TEAM".equals(vo.getSaveTargetType()) && !StringUtil.isNull(vo.getUserIds())) {
            userIdList = Arrays.stream(vo.getUserIds().split(","))
                    .map(String::trim)
                    .filter(s -> !StringUtil.isNull(s))
                    .distinct()
                    .collect(Collectors.toList());
        } else {
            userIdList.add(vo.getUserId());
        }

        for(String userId : userIdList) {
            AsmtEvlVO item = new AsmtEvlVO();

            item.setAsmtId(vo.getAsmtId());
            item.setUserId(userId);
            item.setTeamId(vo.getTeamId());
            item.setEvlMemo(vo.getEvlMemo());
            item.setRgtrId(vo.getRgtrId());
            item.setMdfrId(vo.getMdfrId());

            if(StringUtil.isNull(item.getAsmtEvlId())) {
                item.setAsmtEvlId(IdGenUtil.genNewId(IdPrefixType.ASEVL));
            }

            /*
             * 팀 저장이면 기존 메모 뒤에 append
             * 개인 저장이면 textarea 값으로 replace
             */
            if("TEAM".equals(vo.getSaveTargetType())) {
                asmtProfIndivDAO.asmtMemoAppendModify(item);
            } else {
                asmtProfIndivDAO.asmtMemoModify(item);
            }
        }
    }

    /**
     * 이전과제제출목록
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> prevAsmtSbmsnList(AsmtVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        List<EgovMap> prevAsmtSbmsnList = asmtProfIndivDAO.prevAsmtSbmsnList(vo);
        for(EgovMap sbmsnList : prevAsmtSbmsnList) {
            // 첨부파일
            if(Integer.parseInt(sbmsnList.get("fileCnt").toString()) > 0) {
                AtflVO atflVO = new AtflVO();
                atflVO.setRefId((String) sbmsnList.get("asmtSbmsnId"));

                List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
                sbmsnList.put("fileList", fileList);
            }
        }
        resultVO.setReturnList(prevAsmtSbmsnList);

        return resultVO;
    }

    /**
     * 우수과제 일괄 수정
     *
     * @param exlnList
     * @throws Exception
     */
    @Override
    public void asmtExlnBulkModify(List<AsmtEvlVO> exlnList) throws Exception {
        if(exlnList == null || exlnList.isEmpty()) {
            throw new IllegalArgumentException("우수과제 대상자가 없습니다.");
        }

        for(AsmtEvlVO item : exlnList) {
            if(item == null) {
                throw new IllegalArgumentException("우수과제 대상자가 없습니다.");
            }

            if("Y".equals(item.getExlnAsmtyn()) && StringUtil.isNull(item.getAsmtSbmsnId())) {
                throw new IllegalArgumentException("과제 미제출 학습자는 우수과제로 선정할 수 없습니다.");
            }

            if(StringUtil.isNull(item.getAsmtEvlId())) {
                item.setAsmtEvlId(IdGenUtil.genNewId(IdPrefixType.ASEVL));
            }
        }

        asmtProfIndivDAO.asmtExlnBulkModify(exlnList);

    }

    /**
     * 우수과제 수정
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void asmtExlnModify(AsmtEvlVO vo) throws Exception {
        asmtProfIndivDAO.asmtExlnModify(vo);

    }


    /**
     * 과제 조회
     *
     * @param asmtVO
     * @return
     * @throws Exception
     */
    @Override
    public EgovMap asmtSelect(AsmtVO asmtVO) throws Exception {

        EgovMap rvo = asmtDAO.asmtSelect(asmtVO);

        if(rvo == null) {
            throw processException("common.system.error");
        }
        normalizeSbmsnFileMimeTycd(rvo);
        putAllowedFileTypes(rvo);

        // 첨부파일 목록 조회
        AtflVO atflVO = new AtflVO();
        atflVO.setAtflRepoId(CommConst.REPO_ASMT);
        atflVO.setRefId(asmtVO.getAsmtId());

        rvo.put("fileList", attachFileService.selectAtflListByRefId(atflVO));

        return rvo;
    }

    /**
     * 분만 목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> dvclasList(AsmtVO vo) throws Exception {
        return asmtDAO.dvclasList(vo);
    }

    /**
     * 학습그룹 팀 목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> teamGrpTeamList(AsmtVO vo) throws Exception {
        List<EgovMap> subAsmtList = asmtDAO.teamGrpTeamList(vo);

        for(EgovMap map : subAsmtList) {
            // 첨부파일
            if(map.get("fileCnt") != null && Integer.parseInt(map.get("fileCnt").toString()) > 0) {
                AtflVO atflVO = new AtflVO();
                atflVO.setAtflRepoId(CommConst.REPO_ASMT);
                atflVO.setRefId(map.get("asmtId").toString());

                List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
                map.put("fileList", fileList);
            }
        }
        return subAsmtList;
    }

    /**
     * 개별 수강생 목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> indivStdList(AsmtVO vo) throws Exception {
        return asmtProfIndivDAO.indivStdList(vo);
    }

    /**
     * 개별 과제 제출 대상자 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> indivSbmsnTrgt(AsmtVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        if("OBJECT".equals(vo.getSearchType())) {
        } else if("LIST".equals(vo.getSearchType())) {
            resultVO.setReturnList(asmtProfIndivDAO.indivSbmsnTrgtList(vo));
        } else if("PAGE".equals(vo.getSearchType())) {

        }
        return resultVO;
    }

    /**
     * 교수 과제 등록
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void profAsmtRegist(AsmtVO vo) throws Exception {
        /*
         * 	→ 과제그룹 등록
         * 	→ 분반별(과목아이디) 반복 등록
         * 		→ 상위과제 등록
         * 		→ 첨부파일 처리
         * 		→ 루브릭 연결
         * 		→ 대상자 등록
         * 			→ 개별과제
         * 			→ 팀과제
         * 				→ 일반 팀과제
         * 				→ 부과제 사용 팀과제
         * 			→ 일반과제(전체 수강생)
         * 		→ 부과제 등록
         * 		→ 성적반영비율 처리
         */

        List<AsmtVO> dvclasInfoList = resolveTargetDvclasList(vo);

        if(dvclasInfoList.isEmpty()) {
            throw new IllegalArgumentException("등록할 분반정보가 없습니다.");
        }

        // 분반동시등록여부 설정
        vo.setDvclasCncrntRegyn(dvclasInfoList.size() > 1 ? "Y" : "N");

        // 과제 그룹 등록
        vo.setAsmtGrpId(IdGenUtil.genNewId(IdPrefixType.ASGRP));
        asmtDAO.asmtGrpRegist(vo);

        for(AsmtVO dvclasInfo : dvclasInfoList) {
            String sbjctId = dvclasInfo.getSbjctId();
            String dvclasNo = dvclasInfo.getDvclasNo();

            AsmtVO registVO = buildRegistAsmtVO(vo, sbjctId, dvclasNo);

            /*
             * =========================================================
             * 상위 과제 등록
             * =========================================================
             */
            asmtDAO.asmtRegist(registVO);

            /*
             * =========================================================
             * TODO 첨부파일 저장
             * =========================================================
             */
            saveMainAsmtFiles(registVO);

            /*
             * =========================================================
             * TODO 루브릭 연결 저장
             * =========================================================
             */
            //saveRubricRelation(registVO);

            /*
             * =========================================================
             * 유형별 대상자 등록
             * =========================================================
             */
            registAsmtTarget(registVO);

            /*
             * =========================================================
             * 팀 부과제 등록
             * =========================================================
             */
            if("Y".equals(StringUtils.defaultString(registVO.getTeamAsmtStngyn()))
                    && hasSubAsmtSetting(registVO, sbjctId)) {
                teamSubAsmtListRegist(registVO, vo.getSubAsmtDtlList());
            }

            //성적반영비율 처리
            this.resetAsmtMrkRfltrt(registVO);
        }
    }

    /**
     * 교수 과제 수정
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void profAsmtModify(AsmtVO vo) throws Exception {

        /*
         * =========================================================
         * 현재 DB 상태 조회
         * =========================================================
         */
        EgovMap currentVO = asmtDAO.asmtSelect(vo);

        String oldIndvAsmtyn = StringUtils.defaultString((String) currentVO.get("indvAsmtyn"));
        String oldTeamAsmtStngyn = StringUtils.defaultString((String) currentVO.get("teamAsmtStngyn"));
        String oldAsmtPrctcyn = StringUtils.defaultString((String) currentVO.get("asmtPrctcyn"));
        String oldAsmtGbncd = StringUtils.defaultString((String) currentVO.get("asmtGbncd"));
        String oldTeamGrpId = StringUtils.defaultString((String) currentVO.get("teamGrpId"));
        String oldByteamAsmtUseyn = StringUtils.defaultString((String) currentVO.get("byteamAsmtUseyn"));
        String oldMrkRfltyn = StringUtils.defaultString((String) currentVO.get("mrkRfltyn"));

        /*
         * =========================================================
         * 과제 구분은 수정 불가
         * - 기존 DB 값 유지
         * =========================================================
         */
        vo.setIndvAsmtyn(oldIndvAsmtyn);
        vo.setTeamAsmtStngyn(oldTeamAsmtStngyn);
        vo.setAsmtPrctcyn(oldAsmtPrctcyn);
        vo.setAsmtGbncd(oldAsmtGbncd);


        /*
         * =========================================================
         * 팀과제인 경우에만 학습그룹 / 팀별과제사용여부 처리
         * =========================================================
         */
        if("Y".equals(oldTeamAsmtStngyn)) {

            String newTeamGrpId = resolveTeamGrpIdBySbjctId(vo, vo.getSbjctId());
            String newByteamAsmtUseyn = resolveByteamAsmtUseyn(vo, vo.getSbjctId());

            if(StringUtils.isBlank(newTeamGrpId)) {
                newTeamGrpId = oldTeamGrpId;
            }

            /*
             * 체크박스 파라미터가 아예 안 넘어온 경우 기존값 유지
             */
            if(vo.getByteamAsmtUseyns() == null || vo.getByteamAsmtUseyns().length == 0) {
                newByteamAsmtUseyn = oldByteamAsmtUseyn;
            }

            vo.setTeamGrpId(newTeamGrpId);
            vo.setByteamAsmtUseyn(StringUtils.defaultIfEmpty(newByteamAsmtUseyn, "N"));

        } else {
            vo.setTeamGrpId(null);
            vo.setByteamAsmtUseyn("N");
        }


        /*
         * =========================================================
         * 옵션값 보정
         * =========================================================
         */
        if("N".equals(StringUtils.defaultString(vo.getExtdSbmsnPrmyn()))) {
            vo.setExtdSbmsnSdttm(null);
            vo.setExtdSbmsnEdttm(null);
        }

        if("N".equals(StringUtils.defaultString(vo.getSbasmtOstdOyn()))) {
            vo.setSbasmtOstdOpenSdttm(null);
            vo.setSbasmtOstdOpenEdttm(null);
        }

        normalizeAsmtOptions(vo);

        /*
         * =========================================================
         * 상위과제 수정
         * =========================================================
         */
        asmtDAO.asmtModify(vo);


        // 첨부파일
        saveMainAsmtFiles(vo);


        /*
         * =========================================================
         * 기존 상위과제 제출대상 삭제
         * =========================================================
         */
        asmtDAO.asmtSbmsnTrgtDelete(vo);

        /*
         * =========================================================
         * 유형별 후처리
         * =========================================================
         */
        if("Y".equals(oldIndvAsmtyn)) {

            /*
             * 개별과제
             * - 개별 대상 재등록
             */
            indvAsmtTrgtRegist(vo);

        } else if("Y".equals(oldTeamAsmtStngyn)) {

            if("Y".equals(StringUtils.defaultString(vo.getByteamAsmtUseyn()))) {
                /*
                 * 팀과제 + 팀별부과제 사용
                 * - 상위과제 대상자 없음
                 * - 부과제 sync
                 */
                syncTeamSubAsmtList(vo, vo.getSubAsmtDtlList());
            } else {
                /*
                 * 일반 팀과제
                 * - 기존 부과제 제거
                 * - 팀 대상 재등록
                 */
                deleteSubAsmtList(vo);
                teamAsmtTrgtRegist(vo, vo.getSbjctId());
            }

        } else {
            /*
             * 전체과제
             * - 전체 수강생 대상 재등록
             */
            allStdAsmtTrgtRegist(vo);
        }

        /*
         * 성적반영 여부 변경 시 반영비율 재계산
         */
        if(!oldMrkRfltyn.equals(StringUtils.defaultString(vo.getMrkRfltyn()))) {
            this.resetAsmtMrkRfltrt(vo);
        }

    }

    /**
     * 이전과제 가져오기 학기기수 목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> asmtCopySmstrChrtList(AsmtVO vo) throws Exception {
        return asmtDAO.asmtCopySmstrChrtList(vo);
    }

    /**
     * 이전과제 가져오기 과목 목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> asmtCopySbjctList(AsmtVO vo) throws Exception {
        return asmtDAO.asmtCopySbjctList(vo);
    }

    /**
     * 이전과제 가져오기 과제 목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> asmtCopyList(AsmtVO vo) throws Exception {
        return asmtDAO.asmtCopyList(vo);
    }

    /**
     * 과제평가 목록
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> asmtEvlList(AsmtVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        if("OBJECT".equals(vo.getSearchType())) {
            EgovMap item = asmtDAO.asmtEvlSelect(vo);
            putSbmsnFileList(item);
            putRubricEvlList(item);
            resultVO.setReturnVO(item);
        } else if("LIST".equals(vo.getSearchType())) {
            List<EgovMap> list = asmtDAO.asmtEvlList(vo);
            for(EgovMap item : list) {
                putSbmsnFileList(item);
            }
            resultVO.setReturnList(list);
        } else if("PAGE".equals(vo.getSearchType())) {

        }
        return resultVO;
    }

    /**
     * 루브릭 평가 상세를 화면 구조에 맞게 문항 단위로 묶는다.
     */
    private void putRubricEvlList(EgovMap item) throws Exception {
        if(item == null || StringUtil.isNull((String) item.get("rubricId"))) {
            return;
        }

        AsmtRubricEvlVO paramVO = new AsmtRubricEvlVO();
        paramVO.setAsmtId((String) item.get("asmtId"));
        paramVO.setUserId((String) item.get("userId"));
        paramVO.setRubricId((String) item.get("rubricId"));

        List<EgovMap> rowList = asmtDAO.asmtRubricEvlList(paramVO);
        List<EgovMap> rubricList = new ArrayList<>();
        Map<String, EgovMap> qstnMap = new HashMap<>();

        for(EgovMap row : rowList) {
            String rubricQstnId = (String) row.get("rubricQstnId");
            EgovMap qstn = qstnMap.get(rubricQstnId);

            if(qstn == null) {
                qstn = new EgovMap();
                qstn.put("rubricQstnId", rubricQstnId);
                qstn.put("rubricQstnTtl", row.get("rubricQstnTtl"));
                qstn.put("evlrt", row.get("evlrt"));
                qstn.put("rubricVwitmList", new ArrayList<EgovMap>());

                qstnMap.put(rubricQstnId, qstn);
                rubricList.add(qstn);
            }

            EgovMap rubricVwitm = new EgovMap();
            rubricVwitm.put("rubricVwitmId", row.get("rubricVwitmId"));
            rubricVwitm.put("rubricVwitmTtl", row.get("rubricVwitmTtl"));
            rubricVwitm.put("rubricVwitmPnt", row.get("rubricVwitmPnt"));
            rubricVwitm.put("selectedYn", row.get("selectedYn"));
            ((List<EgovMap>) qstn.get("rubricVwitmList")).add(rubricVwitm);
        }

        item.put("rubricList", rubricList);
    }

    /**
     * 평가 목록/상세에서 제출 과제 미리보기와 다운로드에 사용할 TOBE 첨부파일 정보를 보강한다.
     */
    private void putSbmsnFileList(EgovMap item) throws Exception {
        if(item == null || item.get("asmtSbmsnId") == null || StringUtil.isNull(String.valueOf(item.get("asmtSbmsnId")))) {
            return;
        }

        AtflVO atflVO = new AtflVO();
        atflVO.setAtflRepoId(CommConst.REPO_ASMT);
        atflVO.setRefId(String.valueOf(item.get("asmtSbmsnId")));

        item.put("fileList", buildViewFileList(attachFileService.selectAtflListByRefId(atflVO)));
    }

    /**
     * 미리보기/다운로드 UI에서 공통으로 사용하는 제출 파일 표시 정보를 만든다.
     */
    private List<EgovMap> buildViewFileList(List<AtflVO> atflList) throws Exception {
        List<EgovMap> fileList = new ArrayList<>();

        if(atflList == null || atflList.isEmpty()) {
            return fileList;
        }

        for(AtflVO atfl : atflList) {
            EgovMap fileMap = new EgovMap();
            fileMap.put("atflId", atfl.getAtflId());
            fileMap.put("filenm", atfl.getFilenm());
            fileMap.put("fileNm", atfl.getFilenm());
            fileMap.put("fileExt", atfl.getFileExt());
            fileMap.put("fileSize", atfl.getFileSize());
            fileMap.put("encDownParam", atfl.getEncDownParam());
            // 화면에서는 iframe src로 사용할 공통 사이냅 뷰어 URL만 사용한다.
            if(isSynapViewerFile(atfl)) {
                fileMap.put("synapView", buildSynapViewUrl(atfl));
            }
            if(!StringUtil.isNull(atfl.getFilePath()) && !StringUtil.isNull(atfl.getFileSavnm())) {
                fileMap.put("fileView", CommConst.WEBDATA_CONTEXT + atfl.getFilePath() + "/" + atfl.getFileSavnm());
            }
            if(!StringUtil.isNull(atfl.getThmbFilePath()) && !StringUtil.isNull(atfl.getThmbFilenm())) {
                fileMap.put("thumbView", CommConst.WEBDATA_CONTEXT + atfl.getThmbFilePath() + "/" + atfl.getThmbFilenm());
            }
            fileList.add(fileMap);
        }

        return fileList;
    }

    private boolean isSynapViewerFile(AtflVO atfl) {
        if(atfl == null || !"Y".equals(CommConst.SYNAP_DOC_VIEWER_USE_YN) || StringUtil.isNull(atfl.getAtflId())) {
            return false;
        }

        String fileExt = StringUtil.nvl(atfl.getFileExt()).toLowerCase();
        return Arrays.asList(CommConst.DOC_CONVERT_EXTS).contains(fileExt);
    }

    private String buildSynapViewUrl(AtflVO atfl) throws Exception {
        // 실제 파일 경로는 클라이언트에 노출하지 않고, 파일 식별자인 atflId만 전달한다.
        return "/common/synapView.do?atflId=" + URLEncoder.encode(atfl.getAtflId(), "UTF-8");
    }

    /**
     * 교수 과제 제출파일 ZIP 다운로드 대상 파일 목록
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> asmtSbmsnZipFileList(AsmtVO vo) throws Exception {
        List<String> userIdList = Arrays.stream(StringUtil.nvl(vo.getUserIds()).split(","))
                .map(String::trim)
                .filter(ValidationUtils::isNotEmpty)
                .distinct()
                .collect(Collectors.toList());

        List<String> asmtSbmsnIdList = Arrays.stream(StringUtil.nvl(vo.getAsmtSbmsnIds()).split(","))
                .map(String::trim)
                .filter(ValidationUtils::isNotEmpty)
                .distinct()
                .collect(Collectors.toList());
        List<EgovMap> fileList = new ArrayList<>();

        for(String userId : userIdList) {
            vo.setUserId(userId);
            EgovMap target = asmtDAO.asmtEvlSelect(vo);
            if(target == null) {
                continue;
            }

            String asmtSbmsnId = (String) target.get("asmtSbmsnId");
            if(!asmtSbmsnIdList.contains(asmtSbmsnId)) {
                continue;
            }

            AtflVO atflVO = new AtflVO();
            atflVO.setAtflRepoId(CommConst.REPO_ASMT);
            atflVO.setRefId(asmtSbmsnId);

            List<AtflVO> atflList = attachFileService.selectAtflListByRefId(atflVO);
            int fileSeq = 1;
            for(AtflVO atfl : atflList) {
                String fileNamePattern = "[:\\\\/%*?:|\"<>]";
                String usernm = StringUtil.nvl((String) target.get("usernm")).replaceAll(fileNamePattern, "");
                String stdntNo = StringUtil.nvl((String) target.get("stdntNo")).replaceAll(fileNamePattern, "");
                String fileExt = StringUtil.nvl(atfl.getFileExt());
                String downloadFileName = usernm + "_" + stdntNo + (fileSeq > 1 ? "_" + fileSeq : "") + (fileExt.isEmpty() ? "" : "." + fileExt);

                EgovMap fileMap = new EgovMap();
                fileMap.put("atfl", atfl);
                fileMap.put("downloadFileName", downloadFileName);
                fileList.add(fileMap);
                fileSeq++;
            }
        }

        return fileList;
    }

    /**
     * 교수 과제 엑셀 성적 업로드
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void asmtScrExcelUpload(AsmtVO vo) throws Exception {
        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        List<String> fileIdList = new ArrayList<>();

        if(uploadFileList.isEmpty()) {
            return;
        }

        try {
            for(AtflVO atflVO : uploadFileList) {
                atflVO.setRefId(vo.getAsmtId());
                atflVO.setRgtrId(vo.getRgtrId());
                atflVO.setMdfrId(vo.getMdfrId());
                atflVO.setAtflRepoId(CommConst.REPO_ASMT);
                fileIdList.add(atflVO.getAtflId());
            }
            attachFileService.insertAtflList(uploadFileList);

            HashMap<String, Object> map = new HashMap<>();
            map.put("startRaw", 4);
            map.put("excelGrid", vo.getExcelGrid());
            map.put("atflVO", uploadFileList.get(0));
            map.put("searchKey", "excelUpload");

            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            List<Map<String, Object>> excelList = (List<Map<String, Object>>) excelUtilPoi.simpleReadGrid(map);

            vo.setSearchType("LIST");
            List<EgovMap> targetList = asmtDAO.asmtEvlList(vo);
            Map<String, EgovMap> targetMap = new HashMap<>();
            for(EgovMap target : targetList) {
                Object userId = target.get("userId");
                if(userId != null && ValidationUtils.isNotEmpty(String.valueOf(userId).trim())) {
                    targetMap.put(String.valueOf(userId).trim(), target);
                }
            }

            List<AsmtEvlVO> evlList = new ArrayList<>();
            for(Map<String, Object> excelRow : excelList) {
                Object userIdObj = excelRow.get("B");
                Object scrObj = excelRow.get(excelRow.containsKey("F") ? "F" : "E");

                if(userIdObj == null || scrObj == null || ValidationUtils.isEmpty(String.valueOf(userIdObj).trim())) {
                    continue;
                }

                EgovMap target = targetMap.get(String.valueOf(userIdObj).trim());
                if(target == null) {
                    continue;
                }

                String scrText = String.valueOf(scrObj).trim().replace(",", "");
                if(ValidationUtils.isEmpty(scrText)) {
                    continue;
                }

                AsmtEvlVO item = new AsmtEvlVO();
                item.setAsmtId((String) target.get("asmtId"));
                item.setUserId((String) target.get("userId"));
                item.setTeamId((String) target.get("teamId"));
                item.setAsmtSbmsnId((String) target.get("asmtSbmsnId"));
                item.setSbmsnStscd((String) target.get("sbmsnStscd"));
                item.setAsmtEvlId((String) target.get("asmtEvlId"));
                item.setScr(new BigDecimal(scrText));
                item.setScoreType("batch");
                item.setRgtrId(vo.getRgtrId());
                item.setMdfrId(vo.getMdfrId());
                evlList.add(item);
            }

            if(!evlList.isEmpty()) {
                profAsmtEvlScrBulkModify(evlList);
            }
        } finally {
            if(!fileIdList.isEmpty()) {
                attachFileService.deleteAtflByAtflIds(fileIdList.toArray(new String[0]));
            }
        }
    }

    /**
     * 교수 과제 평가 점수 일괄 수정
     *
     * @param list
     * @throws Exception
     */
    @Override
    public void profAsmtEvlScrBulkModify(List<AsmtEvlVO> list) throws Exception {
        for(AsmtEvlVO asmtEvlVO : list) {
            String asmtEvlId = asmtEvlVO.getAsmtEvlId();
            if(StringUtil.isNull(asmtEvlId)) {
                asmtEvlVO.setAsmtEvlId(IdGenUtil.genNewId(IdPrefixType.ASEVL));
            }
        }

        asmtDAO.asmtEvlScrBulkModify(list);
    }

    /**
     * 교수 과제 평가 점수 개별 수정
     *
     * @param asmtEvlVO
     * @throws Exception
     */
    @Override
    public void profAsmtEvlScrModify(AsmtEvlVO asmtEvlVO) throws Exception {
        String asmtEvlId = asmtEvlVO.getAsmtEvlId();
        if(StringUtil.isNull(asmtEvlId)) {
            asmtEvlVO.setAsmtEvlId(IdGenUtil.genNewId(IdPrefixType.ASEVL));
        }

        if(StringUtil.isNull(asmtEvlVO.getAsmtSbmsnId())) {
            AsmtSbmsnVO sbmsnParamVO = new AsmtSbmsnVO();
            sbmsnParamVO.setAsmtId(asmtEvlVO.getAsmtId());
            sbmsnParamVO.setUserId(asmtEvlVO.getUserId());

            EgovMap lastMap = asmtProfIndivDAO.lastAsmtSbmsnSelect(sbmsnParamVO);
            if(lastMap != null) {
                asmtEvlVO.setAsmtSbmsnId((String) lastMap.get("asmtSbmsnId"));
                asmtEvlVO.setSbmsnStscd((String) lastMap.get("sbmsnStscd"));

                if(StringUtil.isNull(asmtEvlVO.getTeamId())) {
                    asmtEvlVO.setTeamId((String) lastMap.get("teamId"));
                }
            }
        }
        asmtDAO.asmtEvlScrModify(asmtEvlVO);
    }


    /**
     * 과제제출이력 목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> asmtSbmsnHistList(AsmtVO vo) throws Exception {
        List<EgovMap> list = asmtProfIndivDAO.asmtSbmsnHistList(vo);

        for(EgovMap item : list) {

            String asmtSbmsnId = (String) item.get("asmtSbmsnId");

            if(asmtSbmsnId != null && !"".equals(asmtSbmsnId)) {
                AtflVO atflVO = new AtflVO();
                atflVO.setRefId(asmtSbmsnId);

                item.put("fileList", buildViewFileList(attachFileService.selectAtflListByRefId(atflVO)));
            }
        }

        return list;
    }

    /**
     * 과제 이지그레이더 점수 수정
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void asmtEzgScrModify(AsmtEvlVO vo) throws Exception {
        List<String> userIdList = new ArrayList<>();

        if(!StringUtil.isNull(vo.getUserIds())) {
            userIdList = Arrays.stream(vo.getUserIds().split(","))
                    .map(String::trim)
                    .filter(s -> !StringUtil.isNull(s))
                    .distinct()
                    .toList();
        } else if(!StringUtil.isNull(vo.getUserId())) {
            userIdList.add(vo.getUserId());
        }

        if(userIdList.isEmpty()) {
            return;
        }

        List<AsmtEvlVO> evlList = new ArrayList<>();

        for(String userId : userIdList) {
            AsmtEvlVO item = new AsmtEvlVO();

            item.setAsmtId(vo.getAsmtId());
            item.setUserId(userId);
            item.setScr(vo.getScr());
            item.setScoreType(vo.getScoreType());
            item.setRgtrId(vo.getRgtrId());
            item.setMdfrId(vo.getMdfrId());

            /*
             * 사용자별 마지막 제출 ID 조회
             */
            AsmtSbmsnVO sbmsnParamVO = new AsmtSbmsnVO();
            sbmsnParamVO.setAsmtId(vo.getAsmtId());
            sbmsnParamVO.setUserId(userId);

            EgovMap lastMap = asmtProfIndivDAO.lastAsmtSbmsnSelect(sbmsnParamVO);

            if(lastMap != null) {
                item.setAsmtSbmsnId((String) lastMap.get("asmtSbmsnId"));
                item.setSbmsnStscd((String) lastMap.get("sbmsnStscd"));
                item.setTeamId((String) lastMap.get("teamId"));
            } else {
                item.setAsmtSbmsnId(null);
                item.setTeamId(vo.getTeamId());
            }

            evlList.add(item);
        }

        profAsmtEvlScrBulkModify(evlList);

    }

    /**
     * 과제 이지그레이더 루브릭 평가 저장
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void asmtEzgRubricEvlSave(AsmtRubricEvlVO vo) throws Exception {
        if((StringUtil.isNull(vo.getUserIds()) && StringUtil.isNull(vo.getUserId())) || StringUtil.isNull(vo.getRubricVwitmIds())) {
            return;
        }

        List<String> rubricVwitmIdList = Arrays.stream(vo.getRubricVwitmIds().split(","))
                .map(String::trim)
                .filter(ValidationUtils::isNotEmpty)
                .distinct()
                .collect(Collectors.toList());

        if(rubricVwitmIdList.isEmpty()) {
            return;
        }

        vo.setRubricVwitmIdList(rubricVwitmIdList);
        List<AsmtRubricEvlVO> scoreList = asmtDAO.asmtRubricEvlScoreList(vo);
        if(scoreList.size() != rubricVwitmIdList.size()) {
            throw new IllegalArgumentException("루브릭 평가 정보가 올바르지 않습니다.");
        }

        Map<String, AsmtRubricEvlVO> scoreMap = new HashMap<>();
        for(AsmtRubricEvlVO scoreVO : scoreList) {
            scoreMap.put(scoreVO.getRubricVwitmId(), scoreVO);
        }

        BigDecimal totalScore = BigDecimal.ZERO;
        int validScoreCount = 0;

        for(String rubricVwitmId : rubricVwitmIdList) {
            AsmtRubricEvlVO scoreVO = scoreMap.get(rubricVwitmId);
            if(scoreVO == null || scoreVO.getMaxRubricVwitmPnt() == null || BigDecimal.ZERO.compareTo(scoreVO.getMaxRubricVwitmPnt()) == 0) {
                continue;
            }

            BigDecimal evlScr = scoreVO.getRubricVwitmPnt()
                    .divide(scoreVO.getMaxRubricVwitmPnt(), 10, RoundingMode.HALF_UP)
                    .multiply(scoreVO.getEvlrt())
                    .setScale(0, RoundingMode.FLOOR);
            totalScore = totalScore.add(evlScr);
            validScoreCount++;
        }

        if(validScoreCount == 0) {
            return;
        }

        AsmtEvlVO evlVO = new AsmtEvlVO();
        evlVO.setAsmtId(vo.getAsmtId());
        evlVO.setUserId(vo.getUserId());
        evlVO.setUserIds(vo.getUserIds());
        evlVO.setTeamId(vo.getTeamId());
        evlVO.setScr(totalScore);
        evlVO.setRgtrId(vo.getRgtrId());
        evlVO.setMdfrId(vo.getMdfrId());
        asmtEzgScrModify(evlVO);
    }

    /**
     * 과제 이지그레이더 우수과제 수정
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void asmtEzgExlnModify(AsmtEvlVO vo) throws Exception {
        if("Y".equals(vo.getExlnAsmtyn())) {
            /*
             * 선정은 제출 과제만 가능
             */
            AsmtSbmsnVO sbmsnParamVO = new AsmtSbmsnVO();
            sbmsnParamVO.setAsmtId(vo.getAsmtId());
            sbmsnParamVO.setUserId(vo.getUserId());

            EgovMap lastMap = asmtProfIndivDAO.lastAsmtSbmsnSelect(sbmsnParamVO);

            if(lastMap == null) {
                throw new IllegalArgumentException("과제 미제출 학습자는 우수과제로 선정할 수 없습니다.");
            }

            vo.setAsmtSbmsnId((String) lastMap.get("asmtSbmsnId"));

            if(StringUtil.isNull(vo.getTeamId())) {
                vo.setTeamId((String) lastMap.get("teamId"));
            }

            List<AsmtEvlVO> exlnList = new ArrayList<>();
            exlnList.add(vo);

            asmtExlnBulkModify(exlnList);

        } else {
            /*
             * 취소는 기존 UPDATE 재사용
             */
            asmtExlnModify(vo);
        }

    }

    /**
     * 팀별 부과제 동기화
     * - 기존 asmtId 있으면 수정
     * - 없으면 신규 등록
     * - 화면에서 빠진 기존 부과제는 삭제
     */
    private void syncTeamSubAsmtList(AsmtVO upAsmtVO, List<AsmtSubDtlVO> subAsmtDtlList) throws Exception {

        List<AsmtVO> dbSubAsmtList = asmtDAO.subAsmtList(upAsmtVO);
        List<String> reqAsmtIdList = new ArrayList<>();

        if(subAsmtDtlList != null) {
            for(AsmtSubDtlVO detailVO : subAsmtDtlList) {

                if(detailVO == null) {
                    continue;
                }

                /*
                 * 현재 상위과제의 분반 데이터만 처리
                 */
                if(!upAsmtVO.getSbjctId().equals(StringUtils.defaultString(detailVO.getSbjctId()))) {
                    continue;
                }

                if(StringUtils.isBlank(detailVO.getTeamId())) {
                    continue;
                }

                /*
                 * =========================================================
                 * 기존 부과제 수정
                 * =========================================================
                 */
                if(StringUtils.isNotBlank(detailVO.getAsmtId())) {

                    AsmtVO subVO = new AsmtVO();
                    subVO.setAsmtId(detailVO.getAsmtId());
                    subVO.setUpAsmtId(upAsmtVO.getAsmtId());
                    subVO.setSbjctId(upAsmtVO.getSbjctId());
                    subVO.setDvclasNo(detailVO.getDvclasNo());
                    subVO.setAsmtTtl(detailVO.getAsmtTtl());
                    subVO.setAsmtCts(detailVO.getAsmtCts());
                    subVO.setRgtrId(upAsmtVO.getUserId());
                    subVO.setMdfrId(upAsmtVO.getUserId());

                    asmtDAO.subAsmtModify(subVO);

                    /*
                     * 부과제 대상 재설정
                     */
                    asmtDAO.asmtSbmsnTrgtDelete(subVO);

                    AsmtVO paramVO = new AsmtVO();
                    paramVO.setTeamGrpId(upAsmtVO.getTeamGrpId());
                    paramVO.setTeamId(detailVO.getTeamId());

                    List<AsmtTrgtVO> teamList = asmtDAO.teamTrgtList(paramVO);
                    if(teamList == null || teamList.isEmpty()) {
                        throw new IllegalArgumentException("팀 부과제 대상자가 없습니다.");
                    }

                    List<AsmtTrgtVO> trgtList = buildAsmtTrgtList(subVO.getAsmtId(), teamList, upAsmtVO.getUserId(), true);

                    if(trgtList.isEmpty()) {
                        throw new IllegalArgumentException("팀 부과제 대상자가 없습니다.");
                    }
                    asmtDAO.asmtTrgtListRegist(trgtList);

                    saveSubAsmtFiles(subVO, detailVO);

                    reqAsmtIdList.add(subVO.getAsmtId());

                } else {

                    /*
                     * =========================================================
                     * 신규 부과제 등록
                     * =========================================================
                     */
                    AsmtVO subVO = new AsmtVO();
                    subVO.setAsmtId(IdGenUtil.genNewId(IdPrefixType.ASMT));
                    subVO.setUpAsmtId(upAsmtVO.getAsmtId());
                    subVO.setAsmtGrpId(upAsmtVO.getAsmtGrpId());
                    subVO.setSbjctId(upAsmtVO.getSbjctId());
                    subVO.setDvclasNo(detailVO.getDvclasNo());
                    subVO.setAsmtTtl(detailVO.getAsmtTtl());
                    subVO.setAsmtCts(detailVO.getAsmtCts());
                    subVO.setRgtrId(upAsmtVO.getUserId());
                    subVO.setMdfrId(upAsmtVO.getUserId());

                    asmtDAO.subAsmtByCopyRegist(subVO);


                    AsmtVO paramVO = new AsmtVO();
                    paramVO.setTeamGrpId(upAsmtVO.getTeamGrpId());
                    paramVO.setTeamId(detailVO.getTeamId());

                    List<AsmtTrgtVO> teamList = asmtDAO.teamTrgtList(paramVO);
                    if(teamList == null || teamList.isEmpty()) {
                        throw new IllegalArgumentException("팀 부과제 대상자가 없습니다.");
                    }

                    List<AsmtTrgtVO> trgtList = buildAsmtTrgtList(subVO.getAsmtId(), teamList, upAsmtVO.getUserId(), true);
                    if(trgtList.isEmpty()) {
                        throw new IllegalArgumentException("팀 부과제 대상자가 없습니다.");
                    }
                    asmtDAO.asmtTrgtListRegist(trgtList);

                    saveSubAsmtFiles(subVO, detailVO);

                    reqAsmtIdList.add(subVO.getAsmtId());
                }
            }
        }

        /*
         * =========================================================
         * 화면에서 제거된 기존 부과제 삭제
         * =========================================================
         */
        if(dbSubAsmtList != null) {
            for(AsmtVO dbVO : dbSubAsmtList) {
                if(!reqAsmtIdList.contains(dbVO.getAsmtId())) {
                    asmtDAO.asmtSbmsnTrgtDelete(dbVO);

                    deleteAsmtFilesByRefId(dbVO.getAsmtId());

                    asmtDAO.asmtDelete(dbVO);
                }
            }
        }
    }

    /**
     * 분반별 등록용 과제 VO 생성
     */
    private AsmtVO buildRegistAsmtVO(AsmtVO vo, String sbjctId, String dvclasNo) throws Exception {

        AsmtVO registVO = new AsmtVO();
        BeanUtils.copyProperties(vo, registVO);

        registVO.setAsmtId(IdGenUtil.genNewId(IdPrefixType.ASMT));
        registVO.setSbjctId(sbjctId);
        registVO.setDvclasNo(dvclasNo);
        registVO.setRgtrId(vo.getUserId());

        // 분반별 팀별과제사용여부 세팅
        registVO.setByteamAsmtUseyn(resolveByteamAsmtUseyn(vo, sbjctId));

        /*
         * 팀과제가 아니면 학습그룹 초기화
         */
        if("Y".equals(StringUtils.defaultString(vo.getTeamAsmtStngyn()))) {
            registVO.setTeamGrpId(resolveTeamGrpIdBySbjctId(vo, sbjctId));
        } else {
            registVO.setTeamGrpId("");
        }

        /*
         * 연장제출 미사용 시 초기화
         */
        if("N".equals(StringUtils.defaultString(vo.getExtdSbmsnPrmyn()))) {
            registVO.setExtdSbmsnSdttm(null);
            registVO.setExtdSbmsnEdttm(null);
        }

        /*
         * 과제읽기 허용 미사용 시 초기화
         */
        if("N".equals(StringUtils.defaultString(vo.getSbasmtOstdOyn()))) {
            registVO.setSbasmtOstdOpenSdttm(null);
            registVO.setSbasmtOstdOpenEdttm(null);
        }

        normalizeAsmtOptions(registVO);

        return registVO;
    }

    /**
     * 과제 옵션 보정
     *
     * @param vo 과제
     */
    private void normalizeAsmtOptions(AsmtVO vo) {
        if("Y".equals(StringUtils.defaultString(vo.getAsmtPrctcyn()))) {
            vo.setSbasmtTycd("FILE");
            vo.setSbmsnFileMimeTycd(normalizeCommaCodes(vo.getSbmsnFileMimeTycd()));
        } else {
            vo.setExlnAsmtDwldyn("N");
            if("INPUT_TEXT".equals(StringUtils.defaultString(vo.getSbasmtTycd()))) {
                vo.setSbmsnFileMimeTycd("");
            } else {
                vo.setSbmsnFileMimeTycd(normalizeCommaCodes(vo.getSbmsnFileMimeTycd()));
            }
        }

        if("Y".equals(StringUtils.defaultString(vo.getIndvAsmtyn()))) {
            vo.setMrkRfltyn("N");
            vo.setTeamAsmtStngyn("N");
            vo.setTmbrIndivSbmsnPrmyn("N");
            vo.setByteamAsmtUseyn("N");
        }

        if(!"Y".equals(StringUtils.defaultString(vo.getTeamAsmtStngyn()))) {
            vo.setTmbrIndivSbmsnPrmyn("N");
            vo.setByteamAsmtUseyn("N");
        }

        if(!"Y".equals(StringUtils.defaultString(vo.getExtdSbmsnPrmyn()))) {
            vo.setExtdSbmsnSdttm(null);
            vo.setExtdSbmsnEdttm(null);
            vo.setExtdSbmsnMrkRfltrt(null);
        }

        if(!"Y".equals(StringUtils.defaultString(vo.getSbasmtOstdOyn()))) {
            vo.setSbasmtOstdOpenSdttm(null);
            vo.setSbasmtOstdOpenEdttm(null);
        }
    }

    /**
     * 콤마로 전달되는 코드값은 화면 상태에 따라 중복/빈 토큰이 섞일 수 있어 저장 직전에 보정한다.
     */
    private String normalizeCommaCodes(String value) {
        if(StringUtils.isBlank(value)) {
            return "";
        }

        return Arrays.stream(value.split(","))
                .map(StringUtils::trim)
                .filter(StringUtils::isNotBlank)
                .distinct()
                .collect(Collectors.joining(","));
    }

    private void normalizeSbmsnFileMimeTycd(EgovMap map) {
        if(map == null || map.get("sbmsnFileMimeTycd") == null) {
            return;
        }

        map.put("sbmsnFileMimeTycd", normalizeCommaCodes((String) map.get("sbmsnFileMimeTycd")));
    }

    private void putAllowedFileTypes(EgovMap map) {
        if(map == null) {
            return;
        }

        String sbasmtTycd = StringUtils.defaultString((String) map.get("sbasmtTycd"));
        String fileTypeCodes = StringUtils.defaultString((String) map.get("sbmsnFileMimeTycd"));
        if(!"FILE".equals(sbasmtTycd) || StringUtils.isBlank(fileTypeCodes) || "all".equals(fileTypeCodes)) {
            map.put("allowedFileTypes", "*");
            return;
        }

        Set<String> allowedExtSet = buildAllowedFileExtSet(fileTypeCodes);
        map.put("allowedFileTypes", allowedExtSet.isEmpty() ? "*" : StringUtils.join(allowedExtSet, ","));
    }

    /**
     * 과제 유형별 대상자 등록
     */
    private void registAsmtTarget(AsmtVO vo) throws Exception {

        // 개별일 때
        if("Y".equals(StringUtils.defaultString(vo.getIndvAsmtyn()))) {
            indvAsmtTrgtRegist(vo);
            return;
        }

        // 팀일 때
        if("Y".equals(StringUtils.defaultString(vo.getTeamAsmtStngyn()))) {
            // 부과제아닐 때 - 부과제일 때 부과제 처리에서 셋팅
            if(!hasSubAsmtSetting(vo, vo.getSbjctId())) {
                teamAsmtTrgtRegist(vo, vo.getSbjctId());
            }
            return;
        }

        // 전체대상
        allStdAsmtTrgtRegist(vo);
    }

    /**
     * 팀별 부과제 등록
     *
     * @param upAsmtVO       상위과제
     * @param subAsmtDtlList 부과제상세목록
     * @throws Exception
     */
    private void teamSubAsmtListRegist(AsmtVO upAsmtVO, List<AsmtSubDtlVO> subAsmtDtlList) throws Exception {

        if(subAsmtDtlList == null || subAsmtDtlList.isEmpty()) {
            throw new IllegalArgumentException("팀 부과제 정보가 없습니다.");
        }

        List<AsmtTrgtVO> trgtList = new ArrayList<>();

        for(AsmtSubDtlVO detailVO : subAsmtDtlList) {

            if(detailVO == null) {
                continue;
            }

            /*
             * 현재 상위과제의 분반 데이터만 처리
             */
            if(!upAsmtVO.getSbjctId().equals(StringUtils.defaultString(detailVO.getSbjctId()))) {
                continue;
            }

            if(StringUtils.isBlank(detailVO.getTeamId())) {
                continue;
            }

            AsmtVO paramVO = new AsmtVO();
            paramVO.setTeamGrpId(upAsmtVO.getTeamGrpId());
            paramVO.setTeamId(detailVO.getTeamId());

            List<AsmtTrgtVO> teamList = asmtDAO.teamTrgtList(paramVO);

            if(teamList == null || teamList.isEmpty()) {
                continue;
            }

            AsmtVO subVO = new AsmtVO();
            subVO.setAsmtId(IdGenUtil.genNewId(IdPrefixType.ASMT));
            subVO.setUpAsmtId(upAsmtVO.getAsmtId());
            subVO.setAsmtGrpId(upAsmtVO.getAsmtGrpId());
            subVO.setSbjctId(upAsmtVO.getSbjctId());
            subVO.setDvclasNo(detailVO.getDvclasNo());
            subVO.setAsmtTtl(StringUtils.defaultString(detailVO.getAsmtTtl()));
            subVO.setAsmtCts(StringUtils.defaultString(detailVO.getAsmtCts()));
            subVO.setRgtrId(upAsmtVO.getUserId());

            /*
             * 상위과제 기준 복사 등록
             */
            asmtDAO.subAsmtByCopyRegist(subVO);

            trgtList.addAll(buildAsmtTrgtList(subVO.getAsmtId(), teamList, upAsmtVO.getUserId(), true));

            saveSubAsmtFiles(subVO, detailVO);
        }

        if(trgtList.isEmpty()) {
            throw new IllegalArgumentException("팀 부과제 대상자가 없습니다.");
        }

        asmtDAO.asmtTrgtListRegist(trgtList);
    }

    /**
     * sbjctId 기준 학습그룹 ID 조회
     * - teamGrpIds 값 형식: teamGrpId:sbjctId
     *
     * @param vo
     * @param sbjctId
     * @return
     */
    private String resolveTeamGrpIdBySbjctId(AsmtVO vo, String sbjctId) {
        if(StringUtils.isBlank(sbjctId)) {
            return "";
        }

        String[] teamGrpIds = vo.getTeamGrpIds();

        if(teamGrpIds == null) {
            return "";
        }

        for(String item : teamGrpIds) {
            if(StringUtils.isBlank(item)) {
                continue;
            }

            String[] token = item.split(":");
            if(token.length < 2) {
                continue;
            }

            if(sbjctId.equals(token[1])) {
                return token[0];
            }
        }

        return "";
    }

    /**
     * 등록 대상 분반 목록
     */
    private List<AsmtVO> resolveTargetDvclasList(AsmtVO vo) {

        List<AsmtVO> result = new ArrayList<>();

        if(vo.getDvclasInfoList() == null || vo.getDvclasInfoList().isEmpty()) {
            return result;
        }

        for(AsmtVO dvclasInfo : vo.getDvclasInfoList()) {
            if(dvclasInfo == null) continue;

            String sbjctId = StringUtils.defaultString(dvclasInfo.getSbjctId());
            if(StringUtils.isBlank(sbjctId)) continue;

            result.add(dvclasInfo);
        }

        return result;
    }

    /**
     * 부과제 설정 여부 확인
     *
     * @param vo
     * @param sbjctId
     * @return
     */
    private boolean hasSubAsmtSetting(AsmtVO vo, String sbjctId) {

        String[] byteamAsmtUseyns = vo.getByteamAsmtUseyns();

        if(byteamAsmtUseyns == null) {
            return false;
        }

        for(String item : byteamAsmtUseyns) {
            if(StringUtils.isBlank(item)) {
                continue;
            }

            String[] token = item.split(":");
            if(token.length < 2) {
                continue;
            }

            if("Y".equals(token[0]) && sbjctId.equals(token[1])) {
                return true;
            }
        }

        return false;
    }

    /**
     * 분반별 팀별과제사용여부 계산
     */
    private String resolveByteamAsmtUseyn(AsmtVO vo, String sbjctId) {

        String[] byteamAsmtUseyns = vo.getByteamAsmtUseyns();

        if(byteamAsmtUseyns == null || byteamAsmtUseyns.length == 0) {
            return "N";
        }

        for(String item : byteamAsmtUseyns) {
            if(StringUtils.isBlank(item)) {
                continue;
            }

            String[] arr = item.split(":");
            if(arr.length < 2) {
                continue;
            }

            String useYn = StringUtils.defaultString(arr[0]);
            String itemSbjctId = StringUtils.defaultString(arr[1]);

            if(sbjctId.equals(itemSbjctId) && "Y".equals(useYn)) {
                return "Y";
            }
        }

        return "N";
    }

    /**
     * 일반 팀 과제 제출 대상 등록
     *
     * @param vo
     * @param sbjctId
     * @throws Exception
     */
    private void teamAsmtTrgtRegist(AsmtVO vo, String sbjctId) throws Exception {
        String teamGrpId = resolveTeamGrpIdBySbjctId(vo, sbjctId);

        if(StringUtils.isBlank(teamGrpId)) {
            teamGrpId = vo.getTeamGrpId();
        }

        if(StringUtils.isBlank(teamGrpId)) {
            throw new IllegalArgumentException("학습그룹 정보가 없습니다.");
        }

        AsmtVO paramVO = new AsmtVO();
        paramVO.setTeamGrpId(teamGrpId);


        List<AsmtTrgtVO> teamMbrList = asmtDAO.teamTrgtList(paramVO);
        if(teamMbrList == null || teamMbrList.isEmpty()) {
            throw new IllegalArgumentException("학습그룹 팀원이 없습니다.");
        }

        List<AsmtTrgtVO> insertList = buildAsmtTrgtList(vo.getAsmtId(), teamMbrList, vo.getUserId(), true);

        if(!insertList.isEmpty()) {
            asmtDAO.asmtTrgtListRegist(insertList);
        }
    }

    /**
     * 전체 수강생 과제 제출 대상 등록
     *
     * @param vo
     */
    private void allStdAsmtTrgtRegist(AsmtVO vo) throws Exception {

        List<AsmtTrgtVO> stdList = asmtDAO.allStdTrgtList(vo);
        if(stdList == null || stdList.isEmpty()) {
            return;
        }

        List<AsmtTrgtVO> insertList = buildAsmtTrgtList(vo.getAsmtId(), stdList, vo.getUserId(), false);

        if(!insertList.isEmpty()) {
            asmtDAO.asmtTrgtListRegist(insertList);
        }
    }

    /**
     * 개별 과제 제출 대상 등록
     *
     * @param vo
     * @throws Exception
     */
    private void indvAsmtTrgtRegist(AsmtVO vo) throws Exception {
        if(StringUtils.isBlank(vo.getIndvAsmtList())) {
            throw new IllegalArgumentException("개별 과제 대상자가 없습니다.");
        }

        String[] userIdArray = vo.getIndvAsmtList().split(",");
        List<AsmtTrgtVO> insertList = new ArrayList<>();
        for(String userId : userIdArray) {
            if(StringUtils.isBlank(userId)) {
                continue;
            }

            AsmtTrgtVO trgtVO = new AsmtTrgtVO();
            trgtVO.setAsmtSbmsnTrgtId(IdGenUtil.genNewId(IdPrefixType.ASTRG));
            trgtVO.setAsmtId(vo.getAsmtId());
            trgtVO.setTeamId(null);
            trgtVO.setUserId(userId.trim());
            trgtVO.setRgtrId(vo.getUserId());

            insertList.add(trgtVO);
        }

        if(!insertList.isEmpty()) {
            asmtDAO.asmtTrgtListRegist(insertList);
        } else {
            throw new IllegalArgumentException("개별 과제 대상자가 없습니다.");
        }

    }

    /**
     * 과제 제출 대상 목록 생성
     *
     * @param asmtId
     * @param sourceList
     * @param rgtrId
     * @param includeTeamId
     * @return
     */
    private List<AsmtTrgtVO> buildAsmtTrgtList(String asmtId, List<AsmtTrgtVO> sourceList, String rgtrId, boolean includeTeamId) {
        List<AsmtTrgtVO> trgtList = new ArrayList<>();

        if(sourceList == null || sourceList.isEmpty()) {
            return trgtList;
        }

        for(AsmtTrgtVO item : sourceList) {
            if(item == null || StringUtils.isBlank(item.getUserId())) {
                continue;
            }

            AsmtTrgtVO trgtVO = new AsmtTrgtVO();
            trgtVO.setAsmtSbmsnTrgtId(IdGenUtil.genNewId(IdPrefixType.ASTRG));
            trgtVO.setAsmtId(asmtId);
            trgtVO.setUserId(item.getUserId());
            trgtVO.setTeamId(includeTeamId ? item.getTeamId() : null);
            trgtVO.setRgtrId(rgtrId);

            trgtList.add(trgtVO);
        }

        return trgtList;
    }

    /**
     * 하위 부과제 목록 삭제
     *
     * @param upAsmtVO 상위 과제
     * @throws Exception
     */
    private void deleteSubAsmtList(AsmtVO upAsmtVO) throws Exception {
        List<AsmtVO> subAsmtList = asmtDAO.subAsmtList(upAsmtVO);

        if(subAsmtList == null || subAsmtList.isEmpty()) {
            return;
        }

        for(AsmtVO subVO : subAsmtList) {
            asmtDAO.asmtSbmsnTrgtDelete(subVO);
            deleteAsmtFilesByRefId(subVO.getAsmtId());
            asmtDAO.asmtDelete(subVO);
        }
    }

    /**
     * 상위 과제 첨부 저장
     */
    private void saveMainAsmtFiles(AsmtVO vo) throws Exception {

        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        // 첨부파일
        if(!uploadFileList.isEmpty()) {
            for(AtflVO atflVO : uploadFileList) {
                atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
                atflVO.setRefId(vo.getAsmtId());
                atflVO.setRgtrId(vo.getRgtrId());
                atflVO.setMdfrId(vo.getMdfrId());
                atflVO.setAtflRepoId(CommConst.REPO_ASMT);
            }
            attachFileService.insertAtflList(uploadFileList);
        }

        // 첨부파일 삭제
        attachFileService.deleteAtflByAtflIds(vo.getDelFileIds());

    }

    /**
     * 부과제 첨부 저장
     */
    private void saveSubAsmtFiles(AsmtVO subVO, AsmtSubDtlVO detailVO) throws Exception {

        if(detailVO == null) {
            return;
        }

        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(detailVO.getUploadFiles(), detailVO.getUploadPath());
        // 첨부파일
        if(!uploadFileList.isEmpty()) {
            for(AtflVO atflVO : uploadFileList) {
                atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
                atflVO.setRefId(subVO.getAsmtId());
                atflVO.setRgtrId(subVO.getRgtrId());
                atflVO.setMdfrId(subVO.getMdfrId());
                atflVO.setAtflRepoId(CommConst.REPO_ASMT);
            }
            attachFileService.insertAtflList(uploadFileList);
        }

        // 첨부파일 삭제
        attachFileService.deleteAtflByAtflIds(detailVO.getDelFileIds());
    }

    /**
     * 과제 첨부파일 전체 삭제
     *
     * @param asmtId
     * @throws Exception
     */
    private void deleteAsmtFilesByRefId(String asmtId) throws Exception {
        if(StringUtils.isBlank(asmtId)) {
            return;
        }

        AtflVO atflVO = new AtflVO();
        atflVO.setAtflRepoId(CommConst.REPO_ASMT);
        atflVO.setRefId(asmtId);

        List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
        if(fileList == null || fileList.isEmpty()) {
            return;
        }

        String[] atflIds = new String[fileList.size()];
        for(int i = 0; i < fileList.size(); i++) {
            atflIds[i] = fileList.get(i).getAtflId();
        }

        attachFileService.deleteAtflByAtflIds(atflIds);
    }


    /**
     * 루브릭 연결 저장
     */
    private void saveRubricRelation(AsmtVO vo) throws Exception {

        if(!"RUBRIC_SCR".equals(StringUtils.defaultString(vo.getEvlScrTycd()))) {
            return;
        }

        if(StringUtils.isBlank(vo.getRubricId())) {
            return;
        }

        /*
         * TODO 루브릭 관계 저장 DAO 연결
         */
    }

    @Override
    public List<EgovMap> bySubjectAsmtList(SubjectVO vo) {
        return asmtDAO.bySubjectAsmtList(vo);
    }

    /**
     * 학생 과제 목록 페이징
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> stdntAsmtListPaging(AsmtVO vo) throws Exception {
        ProcessResultVO<EgovMap> processResultVO = new ProcessResultVO<>();
        // 페이지 정보 설정
        PageInfo pageInfo = new PageInfo(vo);

        List<EgovMap> asmtList = asmtDAO.stdntAsmtListPaging(vo);

        // 페이지 전체 건수정보 설정
        pageInfo.setTotalRecord(asmtList);

        processResultVO.setReturnList(asmtList);
        processResultVO.setPageInfo(pageInfo);

        return processResultVO;

    }

    @Override
    public int mrkRfltrtSingleModify(AsmtVO vo) {
        return asmtDAO.mrkRfltrtModify(vo);
    }

    /**
     * 학생 과제 상세 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> stdntAsmtView(AsmtVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        EgovMap asmtMap = asmtDAO.stdntAsmtView(vo);

        if(asmtMap != null) {
            normalizeSbmsnFileMimeTycd(asmtMap);
            putAllowedFileTypes(asmtMap);

            AtflVO atflVO = new AtflVO();
            atflVO.setAtflRepoId(CommConst.REPO_ASMT);
            atflVO.setRefId((String) asmtMap.get("asmtId"));
            asmtMap.put("fileList", attachFileService.selectAtflListByRefId(atflVO));
        }

        resultVO.setReturnVO(asmtMap);
        return resultVO;
    }

    /**
     * 학생 과제 알림 정보 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> stdntAsmtAlimInfo(AsmtVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        resultVO.setReturnVO(asmtDAO.stdntAsmtAlimInfo(vo));
        return resultVO;
    }

    /**
     * 학생 과제 제출목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> stdntAsmtSbmsnList(AsmtVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        List<EgovMap> sbmsnList = asmtDAO.stdntAsmtSbmsnList(vo);

        for(EgovMap item : sbmsnList) {
            String asmtSbmsnId = (String) item.get("asmtSbmsnId");
            if(!StringUtil.isNull(asmtSbmsnId) && Integer.parseInt(item.get("fileCnt").toString()) > 0) {
                AtflVO atflVO = new AtflVO();
                atflVO.setAtflRepoId(CommConst.REPO_ASMT);
                atflVO.setRefId(asmtSbmsnId);
                item.put("fileList", attachFileService.selectAtflListByRefId(atflVO));
            }
        }

        resultVO.setReturnList(sbmsnList);
        return resultVO;
    }

    /**
     * 학생 우수과제 목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> stdntExlnAsmtList(AsmtVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        List<EgovMap> exlnAsmtList = asmtDAO.stdntExlnAsmtList(vo);

        for(EgovMap item : exlnAsmtList) {
            String asmtSbmsnId = (String) item.get("asmtSbmsnId");
            if(!StringUtil.isNull(asmtSbmsnId) && Integer.parseInt(item.get("fileCnt").toString()) > 0) {
                AtflVO atflVO = new AtflVO();
                atflVO.setAtflRepoId(CommConst.REPO_ASMT);
                atflVO.setRefId(asmtSbmsnId);
                item.put("fileList", attachFileService.selectAtflListByRefId(atflVO));
            }
        }

        resultVO.setReturnList(exlnAsmtList);
        return resultVO;
    }

    /**
     * 학생 과제 제출 등록
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> stdntAsmtSbmsnRegist(AsmtSbmsnVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
        EgovMap asmtInfo = asmtDAO.stdntAsmtView(toAsmtParam(vo));

        if(asmtInfo == null) {
            throw processException("common.system.error");
        }

        /* 제출 가능 기간 및 제출상태 코드 판단 */
        String asmtPrgrsSts = StringUtils.defaultString((String) asmtInfo.get("asmtPrgrsSts"));
        if(!"PROGRESS".equals(asmtPrgrsSts) && !"EXT_PROGRESS".equals(asmtPrgrsSts) && !"RESBMSN_PROGRESS".equals(asmtPrgrsSts)) {
            throw processException("asmnt.alert.not.send.date");
        }

        String sbasmtTycd = StringUtils.defaultString((String) asmtInfo.get("sbasmtTycd"));
        String sbmsnTycd = "INPUT_TEXT".equals(sbasmtTycd) ? "INPUT_TEXT" : "FILE";
        String sbmsnStscd = resolveStdntSbmsnStscd(asmtPrgrsSts);

        vo.setAsmtId((String) asmtInfo.get("targetAsmtId"));
        vo.setTeamId((String) asmtInfo.get("teamId"));
        vo.setSbmsnTycd(sbmsnTycd);
        vo.setSbmsnStscd(sbmsnStscd);

        /*
         * 제출대상 테이블 기준으로 저장 대상 조회
         */
        List<EgovMap> targetList = asmtDAO.stdntAsmtSbmsnTargetList(vo);
        if(targetList.isEmpty()) {
            throw processException("common.system.error");
        }

        List<AtflVO> uploadFileList = "INPUT_TEXT".equals(sbmsnTycd)
                ? new ArrayList<>()
                : FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        validateStdntSbmsnFileTypes(uploadFileList, (String) asmtInfo.get("sbmsnFileMimeTycd"));

        String representativeSbmsnId = null;
        for(EgovMap target : targetList) {
            /* 개인/팀원별 제출 row 저장 */
            AsmtSbmsnVO targetVO = copySbmsnVO(vo);
            targetVO.setUserId((String) target.get("userId"));
            targetVO.setTeamId((String) target.get("teamId"));

            if("INPUT_TEXT".equals(sbmsnTycd)) {
                /* 직접입력 과제는 학생별 마지막 제출 row를 갱신 */
                EgovMap prevSbmsn = asmtProfIndivDAO.lastAsmtSbmsnSelect(targetVO);
                if(prevSbmsn == null) {
                    targetVO.setAsmtSbmsnId(IdGenUtil.genNewId(IdPrefixType.ASSBM));
                    asmtDAO.stdntAsmtSbmsnRegist(targetVO);
                } else {
                    targetVO.setAsmtSbmsnId((String) prevSbmsn.get("asmtSbmsnId"));
                    asmtDAO.stdntAsmtSbmsnModify(targetVO);
                }
            } else {
                /* 파일 과제는 제출 이력을 유지하기 위해 매 제출마다 신규 row 등록 */
                targetVO.setAsmtSbmsnId(IdGenUtil.genNewId(IdPrefixType.ASSBM));
                asmtDAO.stdntAsmtSbmsnRegist(targetVO);
                saveStdntSbmsnFiles(targetVO, uploadFileList);
            }

            if(vo.getUserId().equals(targetVO.getUserId())) {
                representativeSbmsnId = targetVO.getAsmtSbmsnId();
            }
        }

        EgovMap returnVO = new EgovMap();
        returnVO.put("asmtSbmsnId", representativeSbmsnId);
        resultVO.setReturnVO(returnVO);

        /* TODO 메시지/PUSH 발송 처리 */
        return resultVO;
    }

    /**
     * 강의주차일정 목록 + 현재주차
     * 현재주차 없을 시 마지막 주차를 현재주차로 셋팅
     *
     * @param vo
     * @return
     */
    @Override
    public List<EgovMap> lctrWknoSchdlList(AsmtVO vo) {

        List<EgovMap> wknoList = asmtDAO.lctrWknoSchdlList(vo);

        boolean hasCurrentWkno = wknoList.stream()
                .anyMatch(wkno -> "Y".equals(wkno.get("currWknoYn")));

        if(!hasCurrentWkno && !wknoList.isEmpty()) {
            wknoList.getLast().put("currWknoYn", "Y");
        }

        return wknoList;
    }

    /**
     * JSP 업로더 제한과 별개로 서버에서도 과제에 설정된 제출 가능 형식을 검증한다.
     */
    private void validateStdntSbmsnFileTypes(List<AtflVO> uploadFileList, String sbmsnFileMimeTycd) {
        if(uploadFileList == null || uploadFileList.isEmpty()) {
            return;
        }

        String fileTypeCodes = normalizeCommaCodes(sbmsnFileMimeTycd);
        if(StringUtils.isBlank(fileTypeCodes) || "all".equals(fileTypeCodes)) {
            return;
        }

        Set<String> allowedExtSet = buildAllowedFileExtSet(fileTypeCodes);
        if(allowedExtSet.isEmpty()) {
            return;
        }

        for(AtflVO uploadFile : uploadFileList) {
            String fileExt = StringUtils.lowerCase(StringUtils.defaultString(uploadFile.getFileExt())).replace(".", "");
            if(!allowedExtSet.contains(fileExt)) {
                throw new IllegalArgumentException("제출 가능한 파일 형식이 아닙니다. (" + uploadFile.getFilenm() + ")");
            }
        }
    }

    /**
     * 제출 형식 코드와 실제 확장자 목록을 같은 기준으로 매핑한다.
     */
    private Set<String> buildAllowedFileExtSet(String fileTypeCodes) {
        Set<String> allowedExtSet = new LinkedHashSet<>();

        for(String code : normalizeCommaCodes(fileTypeCodes).split(",")) {
            switch(code) {
                case "img":
                    allowedExtSet.addAll(Arrays.asList("jpg", "jpeg", "gif", "png"));
                    break;
                case "pdf":
                case "pdf2":
                    allowedExtSet.add("pdf");
                    break;
                case "txt":
                case "soc":
                    allowedExtSet.add("txt");
                    break;
                case "hwp":
                    allowedExtSet.addAll(Arrays.asList("hwp", "hwpx"));
                    break;
                case "doc":
                    allowedExtSet.addAll(Arrays.asList("doc", "docx"));
                    break;
                case "ppt":
                case "ppt2":
                    allowedExtSet.addAll(Arrays.asList("ppt", "pptx"));
                    break;
                case "xls":
                    allowedExtSet.addAll(Arrays.asList("xls", "xlsx"));
                    break;
                case "zip":
                    allowedExtSet.add("zip");
                    break;
                default:
                    break;
            }
        }

        return allowedExtSet;
    }

    /**
     * 학생 제출상태 코드 반환
     *
     * @param asmtPrgrsSts
     * @return
     */
    private String resolveStdntSbmsnStscd(String asmtPrgrsSts) {
        if("RESBMSN_PROGRESS".equals(asmtPrgrsSts)) {
            return "RESBMSN_CMPTN";
        }

        if("EXT_PROGRESS".equals(asmtPrgrsSts)) {
            return "EXTD_SBMSN_CMPTN";
        }

        return "SBMSN_CMPTN";
    }

    /**
     * 학생 과제 제출 파일 저장
     *
     * @param vo
     * @param uploadFileList
     * @throws Exception
     */
    private void saveStdntSbmsnFiles(AsmtSbmsnVO vo, List<AtflVO> uploadFileList) throws Exception {
        if(!uploadFileList.isEmpty()) {
            List<AtflVO> sbmsnFileList = new ArrayList<>();
            for(AtflVO uploadFile : uploadFileList) {
                sbmsnFileList.add(copyStdntSbmsnFile(uploadFile, vo));
            }
            attachFileService.insertAtflList(sbmsnFileList);
        }
    }

    /**
     * 학생 제출 첨부파일 복사본 생성
     *
     * @param uploadFile
     * @param vo
     * @return
     */
    private AtflVO copyStdntSbmsnFile(AtflVO uploadFile, AsmtSbmsnVO vo) {
        AtflVO atflVO = new AtflVO();
        BeanUtils.copyProperties(uploadFile, atflVO);
        atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
        atflVO.setRefId(vo.getAsmtSbmsnId());
        atflVO.setRgtrId(vo.getRgtrId());
        atflVO.setMdfrId(vo.getMdfrId());
        atflVO.setAtflRepoId(CommConst.REPO_ASMT);
        return atflVO;
    }

    /**
     * 과제 조회 파라미터 변환
     *
     * @param vo
     * @return
     */
    private AsmtVO toAsmtParam(AsmtSbmsnVO vo) {
        AsmtVO asmtVO = new AsmtVO();
        asmtVO.setOrgId(vo.getOrgId());
        asmtVO.setUserId(vo.getUserId());
        asmtVO.setAsmtId(vo.getAsmtId());
        return asmtVO;
    }

    /**
     * 제출 저장 파라미터 복사
     *
     * @param vo
     * @return
     */
    private AsmtSbmsnVO copySbmsnVO(AsmtSbmsnVO vo) {
        AsmtSbmsnVO targetVO = new AsmtSbmsnVO();
        targetVO.setOrgId(vo.getOrgId());
        targetVO.setAsmtId(vo.getAsmtId());
        targetVO.setTeamId(vo.getTeamId());
        targetVO.setSbmsnTycd(vo.getSbmsnTycd());
        targetVO.setSbmsnCts(vo.getSbmsnCts());
        targetVO.setSbmsnTxt(vo.getSbmsnTxt());
        targetVO.setSbmsnStscd(vo.getSbmsnStscd());
        targetVO.setCntnIp(vo.getCntnIp());
        targetVO.setRgtrId(vo.getRgtrId());
        targetVO.setMdfrId(vo.getMdfrId());
        targetVO.setUploadFiles(vo.getUploadFiles());
        targetVO.setUploadPath(vo.getUploadPath());
        return targetVO;
    }
}
