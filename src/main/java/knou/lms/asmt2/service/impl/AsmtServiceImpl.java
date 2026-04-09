package knou.lms.asmt2.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.lms.asmt2.dao.AsmtDAO;
import knou.lms.asmt2.dao.AsmtProfIndivDAO;
import knou.lms.asmt2.service.AsmtService;
import knou.lms.asmt2.vo.AsmtSubDtlVO;
import knou.lms.asmt2.vo.AsmtTrgtVO;
import knou.lms.asmt2.vo.AsmtVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import org.apache.commons.lang.StringUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service("asmt2Service")
public class AsmtServiceImpl extends EgovAbstractServiceImpl implements AsmtService {

    @Resource(name="asmt2DAO")
    private AsmtDAO asmtDAO;
    @Resource(name="asmt2ProfIndivDAO")
    private AsmtProfIndivDAO asmtProfIndivDAO;
    @Resource(name="attachFileService")
    private AttachFileService attachFileService;


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
     * 과제 조회
     *
     * @param asmtVO
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<AsmtVO> asmtSelect(AsmtVO asmtVO) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        EgovMap rvo = asmtDAO.asmtSelect(asmtVO);
        resultVO.setReturnVO(rvo);
        return resultVO;
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
    public List<EgovMap> lrnGrpTeamList(AsmtVO vo) throws Exception {
        return asmtDAO.lrnGrpTeamList(vo);
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
            // saveMainAsmtFiles(registVO);

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

        /*
         * 팀과제가 아니면 학습그룹 초기화
         */
        if("Y".equals(StringUtils.defaultString(vo.getTeamAsmtStngyn()))) {
            registVO.setLrnGrpId(resolveLrnGrpIdBySbjctId(vo, sbjctId));
        } else {
            registVO.setLrnGrpId("");
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

        return registVO;
    }

    /**
     * 과제 유형별 대상자 등록
     */
    private void registAsmtTarget(AsmtVO vo) throws Exception {

        if("Y".equals(StringUtils.defaultString(vo.getIndvAsmtyn()))) {
            indvAsmtTrgtRegist(vo);
            return;
        }

        if("Y".equals(StringUtils.defaultString(vo.getTeamAsmtStngyn()))) {
            if(!hasSubAsmtSetting(vo, vo.getSbjctId())) {
                teamAsmtTrgtRegist(vo, vo.getSbjctId());
            }
            return;
        }

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
            return;
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

            /*
             * 팀 대상 등록
             */
            AsmtTrgtVO trgtVO = new AsmtTrgtVO();
            trgtVO.setAsmtSbmsnTrgtId(IdGenUtil.genNewId(IdPrefixType.ASTRG));
            trgtVO.setAsmtId(subVO.getAsmtId());
            trgtVO.setUserId(null);
            trgtVO.setTeamId(detailVO.getTeamId());
            trgtVO.setRgtrId(upAsmtVO.getUserId());

            trgtList.add(trgtVO);

            /*
             * TODO 부과제 첨부파일 저장
             */
            //saveSubAsmtFiles(subVO, detailVO);
        }

        if(!trgtList.isEmpty()) {
            asmtDAO.asmtTrgtListRegist(trgtList);
        }
    }

    /**
     * sbjctId 기준 학습그룹 ID 조회
     * - lrnGrpIds 값 형식: lrnGrpId:sbjctId
     *
     * @param vo
     * @param sbjctId
     * @return
     */
    private String resolveLrnGrpIdBySbjctId(AsmtVO vo, String sbjctId) {

        String[] lrnGrpIds = vo.getLrnGrpIds();

        if(lrnGrpIds == null) {
            return "";
        }

        for(String item : lrnGrpIds) {
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
     * 일반 팀 과제 제출 대상 등록
     *
     * @param vo
     * @param sbjctId
     * @throws Exception
     */
    private void teamAsmtTrgtRegist(AsmtVO vo, String sbjctId) throws Exception {
        String lrnGrpId = resolveLrnGrpIdBySbjctId(vo, sbjctId);

        if(StringUtils.isBlank(lrnGrpId)) {
            return;
        }

        AsmtVO paramVO = new AsmtVO();
        paramVO.setLrnGrpId(lrnGrpId);


        List<AsmtTrgtVO> teamList = asmtDAO.teamTrgtList(paramVO);
        List<AsmtTrgtVO> insertList = new ArrayList<>();

        for(AsmtTrgtVO item : teamList) {
            AsmtTrgtVO trgtVO = new AsmtTrgtVO();
            trgtVO.setAsmtSbmsnTrgtId(IdGenUtil.genNewId(IdPrefixType.ASTRG));
            trgtVO.setAsmtId(vo.getAsmtId());
            trgtVO.setUserId(null);
            trgtVO.setTeamId(item.getTeamId());
            trgtVO.setRgtrId(vo.getUserId());

            insertList.add(trgtVO);
        }

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
        List<AsmtTrgtVO> insertList = new ArrayList<>();

        if(stdList == null || stdList.isEmpty()) {
            return;
        }

        for(AsmtTrgtVO item : stdList) {
            if(StringUtils.isBlank(item.getUserId())) {
                continue;
            }

            AsmtTrgtVO trgtVO = new AsmtTrgtVO();
            trgtVO.setAsmtSbmsnTrgtId(IdGenUtil.genNewId(IdPrefixType.ASTRG));
            trgtVO.setAsmtId(vo.getAsmtId());
            trgtVO.setTeamId(null);
            trgtVO.setUserId(item.getUserId());
            trgtVO.setRgtrId(vo.getUserId());

            insertList.add(trgtVO);
        }

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
        }

    }

    /**
     * 상위 과제 첨부 저장
     */
    private void saveMainAsmtFiles(AsmtVO vo) throws Exception {

        if(StringUtils.isBlank(vo.getUploadFiles())) {
            return;
        }

        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        for(AtflVO atflVO : uploadFileList) {
            atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
            atflVO.setRefId(vo.getAsmtId());
            atflVO.setRgtrId(vo.getRgtrId());
            atflVO.setMdfrId(vo.getMdfrId());
            atflVO.setAtflRepoId(CommConst.REPO_ASMT);
        }
        if(!uploadFileList.isEmpty()) {
            attachFileService.insertAtflList(uploadFileList);
        }
    }

    /**
     * 부과제 첨부 저장
     */
    private void saveSubAsmtFiles(AsmtVO subVO, AsmtSubDtlVO detailVO) throws Exception {

        if(detailVO == null) {
            return;
        }

        if(StringUtils.isBlank(detailVO.getUploadFiles())) {
            return;
        }

        List<AtflVO> teamFiles = FileUtil.getUploadAtflList(
                detailVO.getUploadFiles(), detailVO.getUploadPath());
        for(AtflVO atflVO : teamFiles) {
            atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
            atflVO.setRefId(subVO.getAsmtId());
            atflVO.setRgtrId(subVO.getRgtrId());
            atflVO.setMdfrId(subVO.getMdfrId());
            atflVO.setAtflRepoId(CommConst.REPO_ASMT);
        }
        if(!teamFiles.isEmpty()) {
            attachFileService.insertAtflList(teamFiles);
        }
    }

    /**
     * 부과제 첨부 삭제
     */
    private void deleteSubAsmtFiles(AsmtVO vo) throws Exception {
        /*
         * TODO 공통 파일 서비스 연결
         */
    }

    /**
     * 루브릭 연결 저장
     */
    private void saveRubricRelation(AsmtVO vo) throws Exception {

        if(!"RUBRIC_SCR".equals(StringUtils.defaultString(vo.getEvlScrTycd()))) {
            return;
        }

        if(StringUtils.isBlank(vo.getRublicId())) {
            return;
        }

        /*
         * TODO 루브릭 관계 저장 DAO 연결
         */
    }

}
