package knou.lms.atndcrtr.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.atndcrtr.vo.AtndCrtrVO;

@Mapper("atndCrtrDAO")
public interface AtndCrtrDAO {

    /*****************************************************
     * 출석점수 기준관리 목록 조회
     * @param vo
     * @return List<AtndCrtrVO>
     ******************************************************/
    public List<AtndCrtrVO> listPaging(AtndCrtrVO vo);

    /*****************************************************
     * 출석점수 기준관리 목록 건수 조회
     * @param vo
     * @return int
     ******************************************************/
    public int count(AtndCrtrVO vo);

    /*****************************************************
     * 기관 목록 조회
     * @param vo
     * @return List<AtndCrtrVO>
     ******************************************************/
    public List<AtndCrtrVO> listOrg(AtndCrtrVO vo);

    /*****************************************************
     * 학기(기수) 목록 조회
     * @param vo
     * @return List<AtndCrtrVO>
     ******************************************************/
    public List<AtndCrtrVO> listHaksaTerm(AtndCrtrVO vo);

    /*****************************************************
     * 출석점수 기준관리 상세 조회
     * @param vo
     * @return AtndCrtrVO
     ******************************************************/
    public AtndCrtrVO select(AtndCrtrVO vo);

    /*****************************************************
     * 기관/년도/학기 기준 학기기수 조회
     * @param vo
     * @return AtndCrtrVO
     ******************************************************/
    public AtndCrtrVO selectByOrgTerm(AtndCrtrVO vo);

    /*****************************************************
     * 이전 기준 학기 조회
     * @param vo
     * @return AtndCrtrVO
     ******************************************************/
    public AtndCrtrVO selectPrev(AtndCrtrVO vo);

    /*****************************************************
     * 출석점수 기준비율 목록 조회
     * @param vo
     * @return List<AtndCrtrVO>
     ******************************************************/
    public List<AtndCrtrVO> listDtl(AtndCrtrVO vo);

    /*****************************************************
     * 출결기준 및 진도율 설정 조회
     * @param vo
     * @return AtndCrtrVO
     ******************************************************/
    public AtndCrtrVO selectWeekCrtr(AtndCrtrVO vo);

    /*****************************************************
     * 학기기수별 과목 목록 조회
     * @param vo
     * @return List<AtndCrtrVO>
     ******************************************************/
    public List<AtndCrtrVO> listSubject(AtndCrtrVO vo);

    /*****************************************************
     * 출석점수 기준비율 삭제
     * @param vo
     ******************************************************/
    public void deleteDtl(AtndCrtrVO vo);

    /*****************************************************
     * 출석점수 기준비율 등록
     * @param vo
     ******************************************************/
    public void insertDtl(AtndCrtrVO vo);

    /*****************************************************
     * 출결기준 및 진도율 설정 삭제
     * @param vo
     ******************************************************/
    public void deleteWeekCrtr(AtndCrtrVO vo);

    /*****************************************************
     * 출결기준 및 진도율 설정 등록
     * @param vo
     ******************************************************/
    public void insertWeekCrtr(AtndCrtrVO vo);
}
