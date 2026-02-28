package knou.lms.asmt.service;

import knou.framework.vo.FileVO;
import knou.lms.asmt.vo.AsmtVO;
import knou.lms.common.vo.ProcessResultVO;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface AsmtProService {

    // 과제 조회
    public AsmtVO select(AsmtVO vo) throws Exception;

    // 다건 조회
    public List<AsmtVO> list(AsmtVO vo) throws Exception;

    // 페이징 조회
    public ProcessResultVO<AsmtVO> listPaging(AsmtVO vo) throws Exception;


    // 과제 조회
    public ProcessResultVO<AsmtVO> selectAsmnt(AsmtVO vo) throws Exception;

    // 단건 조회
    public ProcessResultVO<AsmtVO> selectObject(AsmtVO vo) throws Exception;

    // 다건 조회
    public ProcessResultVO<AsmtVO> selectList(AsmtVO vo) throws Exception;

    // 페이징 조회
    public ProcessResultVO<AsmtVO> selectListPaging(AsmtVO vo) throws Exception;

    // 이전 과제 목록 조회
    public ProcessResultVO<AsmtVO> selectPrevAsmntList(AsmtVO vo) throws Exception;

    // 분반 목록 조회
    public List<AsmtVO> selectDeclsList(AsmtVO vo) throws Exception;

    // 과제 등록
    public void insertAsmnt(AsmtVO vo) throws Exception;

    // 과제 복사
    public void copyAsmnt(AsmtVO vo) throws Exception;

    // 과제 수정
    public void updateAsmnt(AsmtVO vo) throws Exception;

    // 과제 성적공개여부 수정
    public ProcessResultVO<AsmtVO> updateScoreOpen(AsmtVO vo) throws Exception;

    // 과제 성적반영비율 수정
    public ProcessResultVO<AsmtVO> updateScoreRatio(AsmtVO vo) throws Exception;

    // 과제 삭제
    public ProcessResultVO<AsmtVO> deleteAsmnt(AsmtVO vo) throws Exception;

    // 과제 대상자 조회
    public ProcessResultVO<AsmtVO> selectTargetIndi(AsmtVO vo) throws Exception;

    // 과제 제재출 수정
    public void updateResend(AsmtVO vo) throws Exception;

    // (개인)참여자 조회
    public ProcessResultVO<AsmtVO> selectJoinIndi(AsmtVO vo) throws Exception;

    // (개인)성적 수정
    public void updateScoreIndi(AsmtVO vo) throws Exception;

    // (개인)성적 일괄 수정
    public void updateScoreIndiBatch(HttpServletRequest request, List<AsmtVO> list) throws Exception;

    // (개인)메모 수정
    public ProcessResultVO<AsmtVO> updateMemoIndi(AsmtVO vo) throws Exception;

    // (개인)우수과제 선정
    public ProcessResultVO<AsmtVO> updateBestIndi(AsmtVO vo) throws Exception;

    // (팀)참여자 조회
    public ProcessResultVO<AsmtVO> selectJoinTeam(AsmtVO vo) throws Exception;

    // 과목 목록 조회
    public ProcessResultVO<AsmtVO> selectCrsCreList(AsmtVO vo) throws Exception;

    // 팀 목록 조회
    public ProcessResultVO<AsmtVO> selectTeamList(AsmtVO vo) throws Exception;

    // 피드백 조회
    public ProcessResultVO<AsmtVO> selectFdbk(AsmtVO vo) throws Exception;

    // 피드백 저장
    public ProcessResultVO<AsmtVO> insertFdbk(AsmtVO vo) throws Exception;

    // 피드백 수정
    public ProcessResultVO<AsmtVO> updateFdbk(AsmtVO vo) throws Exception;

    // 피드백 삭제
    public ProcessResultVO<AsmtVO> deleteFdbk(AsmtVO vo) throws Exception;

    // 이전과제 제출파일 조회
    public ProcessResultVO<AsmtVO> selectPrevAsmntFiles(AsmtVO vo) throws Exception;

    // 참여이력 조회
    public AsmtVO selectAsmntJoinUser(AsmtVO vo) throws Exception;

    // 제출이력 목록 조회
    public ProcessResultVO<AsmtVO> selectSubmitHystList(AsmtVO vo) throws Exception;

    // 엑셀 업로드(엑셀 성적등록)
    public ProcessResultVO<AsmtVO> uploadExcel(AsmtVO vo) throws Exception;

    // 선택 대상자 과제 파일다운로드  (미사용)
    public ProcessResultVO<AsmtVO> getAsmntFileDown(AsmtVO vo) throws Exception;

    // 선택 대상자 과제 파일다운로드
    public List<FileVO> getAsmntZipFileDown(AsmtVO vo) throws Exception;

    // 시험 과제 등록, 수정
    public ProcessResultVO<AsmtVO> examAsmntManage(AsmtVO vo, HttpServletRequest request) throws Exception;

    // 추가 수강생 확인
    public void chkNewStd(AsmtVO vo) throws Exception;

    // 피드백 수정
    public void setScoreRatio(AsmtVO vo) throws Exception;

    // 과제 댓글 목록 조회
    public ProcessResultVO<AsmtVO> listCmnt(AsmtVO vo) throws Exception;

    // 과제 댓글 등록
    public ProcessResultVO<AsmtVO> insertCmnt(AsmtVO vo) throws Exception;

    // 과제 댓글 수정
    public ProcessResultVO<AsmtVO> updateCmnt(AsmtVO vo) throws Exception;

    // 루브릭 수정
    public ProcessResultVO<AsmtVO> updateMutEval(AsmtVO vo) throws Exception;

    // 과제 루브릭 저장
    public void insertMutEvalRslt(AsmtVO vo) throws Exception;

    // 과제 루브릭 평가 연결 목록 조회
    public ProcessResultVO<AsmtVO> listMutEvalRslt(AsmtVO vo) throws Exception;

    // 과제 대상자 루브릭 점수 채점 취소
    public void cancelMutEvalRslt(AsmtVO vo) throws Exception;

    /*****************************************************
     * 상호평가 목록 조회
     * @param vo
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> listMutEval(AsmtVO vo) throws Exception;

    // 교수자가 미제출 과제 대리등록
    public void serInsertAsmnt(AsmtVO vo) throws Exception;

    // 교수자가 미제출 과제 일괄 대리등록
    public void serInsertAsmntBatch(HttpServletRequest request, AsmtVO vo) throws Exception;

    // 미제출 처리
    public void editNoSubmit(AsmtVO vo) throws Exception;
}
