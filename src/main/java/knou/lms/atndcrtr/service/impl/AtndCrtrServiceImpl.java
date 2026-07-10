package knou.lms.atndcrtr.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.atndcrtr.dao.AtndCrtrDAO;
import knou.lms.atndcrtr.service.AtndCrtrService;
import knou.lms.atndcrtr.vo.AtndCrtrVO;
import knou.lms.common.vo.ProcessResultVO;

@Service("atndCrtrService")
public class AtndCrtrServiceImpl extends ServiceBase implements AtndCrtrService {

    @Resource(name = "atndCrtrDAO")
    private AtndCrtrDAO atndCrtrDAO;

    /*****************************************************
     * 출석점수 기준관리 목록 조회
     * @param vo
     * @return ProcessResultVO<AtndCrtrVO>
     ******************************************************/
    @Override
    public ProcessResultVO<AtndCrtrVO> listPaging(AtndCrtrVO vo) {
        ProcessResultVO<AtndCrtrVO> resultVO = new ProcessResultVO<AtndCrtrVO>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totalCount = atndCrtrDAO.count(vo);
        paginationInfo.setTotalRecordCount(totalCount);

        resultVO.setReturnList(atndCrtrDAO.listPaging(vo));
        resultVO.setPageInfo(paginationInfo);
        resultVO.setResultSuccess();
        return resultVO;
    }

    /*****************************************************
     * 기관 목록 조회
     * @param vo
     * @return List<AtndCrtrVO>
     ******************************************************/
    @Override
    public List<AtndCrtrVO> listOrg(AtndCrtrVO vo) {
        return atndCrtrDAO.listOrg(vo);
    }

    /*****************************************************
     * 학기(기수) 목록 조회
     * @param vo
     * @return List<AtndCrtrVO>
     ******************************************************/
    @Override
    public List<AtndCrtrVO> listHaksaTerm(AtndCrtrVO vo) {
        return atndCrtrDAO.listHaksaTerm(vo);
    }

    /*****************************************************
     * 출석점수 기준관리 상세 조회
     * @param vo
     * @return AtndCrtrVO
     ******************************************************/
    @Override
    public AtndCrtrVO select(AtndCrtrVO vo) {
        AtndCrtrVO result = atndCrtrDAO.select(vo);
        if (result != null) {
            result.setDtlList(atndCrtrDAO.listDtl(result));
            applyWeekCrtr(result);
            applyScoreFields(result);
        }
        return result;
    }

    /*****************************************************
     * 이전 기준 학기 조회
     * @param vo
     * @return AtndCrtrVO
     ******************************************************/
    @Override
    public AtndCrtrVO selectPrev(AtndCrtrVO vo) {
        validateOrgTerm(vo);
        // 선택한 기관/년도/학기보다 이전인 학기 중, 기준이 존재하는 가장 최근 학기를 조회한다.
        AtndCrtrVO result = atndCrtrDAO.selectPrev(vo);
        if (result != null) {
            result.setDtlList(atndCrtrDAO.listDtl(result));
            applyWeekCrtr(result);
            applyScoreFields(result);
        }
        return result;
    }

    /*****************************************************
     * 출석점수 기준관리 저장
     * @param vo
     ******************************************************/
    @Override
    public void save(AtndCrtrVO vo) {
        AtndCrtrVO target = resolveTargetTerm(vo);
        List<AtndCrtrVO> dtlList = parseScoreList(vo);
        AtndCrtrVO weekCrtr = parseWeekCrtr(vo);

        vo.setSmstrChrtId(target.getSmstrChrtId());

        // 상단 출결기준/진도율 기준은 화면상 학기 공통값처럼 보이지만,
        // 실제 저장은 해당 학기 과목 전체의 TB_LMS_BYWKNO_ATTNDNC_CRTR를
        // 삭제 후 동일 값으로 다시 등록하는 구조이다.
        atndCrtrDAO.deleteDtl(vo);
        atndCrtrDAO.deleteWeekCrtr(vo);

        for (AtndCrtrVO dtl : dtlList) {
            dtl.setCrtrStngId(IdGenerator.getNewId("ASCS"));
            dtl.setSmstrChrtId(target.getSmstrChrtId());
            dtl.setRgtrId(vo.getRgtrId());
            dtl.setMdfrId(vo.getMdfrId());
            atndCrtrDAO.insertDtl(dtl);
        }

        List<AtndCrtrVO> subjectList = atndCrtrDAO.listSubject(vo);
        // 상단 기준은 학기기수에 속한 활성 과목 전체에 동일 값으로 반영한다.
        for (AtndCrtrVO subject : subjectList) {
            AtndCrtrVO subjectCrtr = new AtndCrtrVO();
            subjectCrtr.setBywknoAttndncCrtrId(IdGenerator.getNewId("BWAC"));
            subjectCrtr.setSbjctId(subject.getSbjctId());
            subjectCrtr.setAtndMinPrgrt(weekCrtr.getAtndMinPrgrt());
            subjectCrtr.setLateMinPrgrt(weekCrtr.getLateMinPrgrt());
            subjectCrtr.setLateRecgRate(weekCrtr.getLateRecgRate());
            subjectCrtr.setAbsentRecgRate(weekCrtr.getAbsentRecgRate());
            subjectCrtr.setRgtrId(vo.getRgtrId());
            subjectCrtr.setMdfrId(vo.getMdfrId());
            atndCrtrDAO.insertWeekCrtr(subjectCrtr);
        }
    }

    /*****************************************************
     * 출석점수 기준관리 삭제
     * @param vo
     ******************************************************/
    @Override
    public void delete(AtndCrtrVO vo) {
        AtndCrtrVO target = resolveTargetTerm(vo);
        vo.setSmstrChrtId(target.getSmstrChrtId());
        atndCrtrDAO.deleteDtl(vo);
        atndCrtrDAO.deleteWeekCrtr(vo);
    }

    /*****************************************************
     * 출결기준 및 진도율 설정 적용
     * @param vo
     ******************************************************/
    private void applyWeekCrtr(AtndCrtrVO vo) {
        AtndCrtrVO weekCrtr = atndCrtrDAO.selectWeekCrtr(vo);
        if (weekCrtr == null) {
            // 등록되지 않은 기준은 기본값으로 대체하지 않고 빈 상태로 둔다.
            return;
        }

        vo.setBywknoAttndncCrtrId(weekCrtr.getBywknoAttndncCrtrId());
        vo.setAtndMinPrgrt(weekCrtr.getAtndMinPrgrt());
        vo.setLateMinPrgrt(weekCrtr.getLateMinPrgrt());
        vo.setLateRecgRate(weekCrtr.getLateRecgRate());
        vo.setAbsentRecgRate(weekCrtr.getAbsentRecgRate());
    }

    /*****************************************************
     * 하단 출석점수 표시값 적용
     * @param vo
     ******************************************************/
    private void applyScoreFields(AtndCrtrVO vo) {
        clearScoreFields(vo);
        if (vo.getDtlList() == null || vo.getDtlList().isEmpty()) {
            return;
        }

        // 하단 점수표는 신규 3행 구조(출석/지각/결석)만 지원한다.
        // 기존 구간형 데이터는 화면에서 비워두고 신규 구조로 다시 입력한다.
        if (!isFixedScoreShape(vo.getDtlList())) {
            return;
        }

        for (AtndCrtrVO dtl : vo.getDtlList()) {
            if (dtl == null || dtl.getCrtrSeq() == null) {
                continue;
            }

            if (1 == dtl.getCrtrSeq()) {
                vo.setAttendanceScore(dtl.getScore());
            } else if (2 == dtl.getCrtrSeq()) {
                vo.setLateScore(dtl.getScore());
            } else if (3 == dtl.getCrtrSeq()) {
                vo.setAbsenceScore(dtl.getScore());
            }
        }
    }

    /*****************************************************
     * 하단 출석점수 표시값 초기화
     * @param vo
     ******************************************************/
    private void clearScoreFields(AtndCrtrVO vo) {
        vo.setPlayRateRecgYn("Y");
        vo.setAttendanceScore(null);
        vo.setLateScore(null);
        vo.setAbsenceScore(null);
    }

    /*****************************************************
     * 하단 점수표 신규 3행 구조 여부 확인
     * @param dtlList
     * @return boolean
     ******************************************************/
    private boolean isFixedScoreShape(List<AtndCrtrVO> dtlList) {
        if (dtlList == null || dtlList.size() != 3) {
            return false;
        }

        boolean attendance = false;
        boolean late = false;
        boolean absence = false;

        for (AtndCrtrVO dtl : dtlList) {
            if (dtl == null || dtl.getCrtrSeq() == null || dtl.getStartRate() == null || dtl.getEndRate() == null) {
                return false;
            }

            if (1 == dtl.getCrtrSeq().intValue()
                    && Float.compare(dtl.getStartRate(), 100F) == 0
                    && Float.compare(dtl.getEndRate(), 100F) == 0) {
                attendance = true;
            } else if (2 == dtl.getCrtrSeq().intValue()
                    && Float.compare(dtl.getStartRate(), 50F) == 0
                    && Float.compare(dtl.getEndRate(), 50F) == 0) {
                late = true;
            } else if (3 == dtl.getCrtrSeq().intValue()
                    && Float.compare(dtl.getStartRate(), 0F) == 0
                    && Float.compare(dtl.getEndRate(), 0F) == 0) {
                absence = true;
            } else {
                return false;
            }
        }

        return attendance && late && absence;
    }

    /*****************************************************
     * 저장 대상 학기기수 조회
     * @param vo
     * @return AtndCrtrVO
     ******************************************************/
    private AtndCrtrVO resolveTargetTerm(AtndCrtrVO vo) {
        AtndCrtrVO target;
        if (!isBlank(vo.getSmstrChrtId())) {
            target = atndCrtrDAO.select(vo);
        } else {
            validateOrgTerm(vo);
            target = atndCrtrDAO.selectByOrgTerm(vo);
        }

        if (target == null) {
            throw new BadRequestUrlException("선택한 기관/학년도/학기 정보를 찾을 수 없습니다.");
        }

        vo.setSmstrChrtId(target.getSmstrChrtId());
        vo.setOrgId(target.getOrgId());
        vo.setHaksaYear(target.getHaksaYear());
        vo.setHaksaTerm(target.getHaksaTerm());
        vo.setDgrsYr(target.getHaksaYear());
        vo.setDgrsSmstrChrt(target.getHaksaTerm());
        return target;
    }

    /*****************************************************
     * 기관/년도/학기 유효성 검증
     * @param vo
     ******************************************************/
    private void validateOrgTerm(AtndCrtrVO vo) {
        if (isBlank(vo.getOrgId())) {
            throw new BadRequestUrlException("기관을 선택해 주세요.");
        }
        if (isBlank(vo.getHaksaYear())) {
            throw new BadRequestUrlException("학년도를 선택해 주세요.");
        }
        if (isBlank(vo.getHaksaTerm())) {
            throw new BadRequestUrlException("학기(기수)를 선택해 주세요.");
        }
    }

        /*****************************************************
     * 하단 출석점수 3행 구조 파싱
     * @param vo
     * @return List<AtndCrtrVO>
     ******************************************************/
    private List<AtndCrtrVO> parseScoreList(AtndCrtrVO vo) {
        List<AtndCrtrVO> list = new ArrayList<AtndCrtrVO>();
        // 하단 점수는 신규 고정 3행 구조로 저장한다.
        list.add(createScoreRow(1, 100F, 100F, vo.getAttendanceScore(), "출석 점수"));
        list.add(createScoreRow(2, 50F, 50F, vo.getLateScore(), "지각 점수"));
        list.add(createScoreRow(3, 0F, 0F, vo.getAbsenceScore(), "결석 점수"));
        return list;
    }

    /*****************************************************
     * 하단 출석점수 행 생성
     * @param seq
     * @param startRate
     * @param endRate
     * @param score
     * @param label
     * @return AtndCrtrVO
     ******************************************************/
    private AtndCrtrVO createScoreRow(int seq, Float startRate, Float endRate, Float score, String label) {
        if (score == null) {
            throw new BadRequestUrlException(label + "를 입력해 주세요.");
        }
        if (score < 0F) {
            throw new BadRequestUrlException(label + "는 0 이상으로 입력해 주세요.");
        }

        AtndCrtrVO dtl = new AtndCrtrVO();
        dtl.setCrtrSeq(seq);
        dtl.setStartRate(startRate);
        dtl.setEndRate(endRate);
        dtl.setScore(score);
        return dtl;
    }

    /*****************************************************
     * 출결기준 및 진도율 설정 파싱
     * @param vo
     * @return AtndCrtrVO
     ******************************************************/
    private AtndCrtrVO parseWeekCrtr(AtndCrtrVO vo) {
        AtndCrtrVO weekCrtr = new AtndCrtrVO();
        weekCrtr.setAtndMinPrgrt(validateRange(vo.getAtndMinPrgrt(), "학습기간 내 진도율"));
        weekCrtr.setLateMinPrgrt(validateRange(vo.getLateMinPrgrt(), "지각 인정기간 내 진도율"));
        weekCrtr.setLateRecgRate(validateRange(vo.getLateRecgRate(), "지각기간 내 진도 인정률"));
        weekCrtr.setAbsentRecgRate(validateRange(vo.getAbsentRecgRate(), "결석/지각기간 내 진도 인정률"));
        return weekCrtr;
    }

    /*****************************************************
     * 출결기준 및 진도율 설정 범위 검증
     * @param value
     * @param label
     * @return Float
     ******************************************************/
    private Float validateRange(Float value, String label) {
        if (value == null) {
            throw new BadRequestUrlException(label + "을 입력해 주세요.");
        }
        if (value < 0F || value > 100F) {
            throw new BadRequestUrlException(label + "은 0부터 100 사이로 입력해 주세요.");
        }
        return value;
    }

    private boolean isBlank(String value) {
        return StringUtil.nvl(value).trim().length() == 0;
    }
}
