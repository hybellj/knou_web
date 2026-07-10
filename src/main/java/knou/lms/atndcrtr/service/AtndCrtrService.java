package knou.lms.atndcrtr.service;

import java.util.List;

import knou.lms.atndcrtr.vo.AtndCrtrVO;
import knou.lms.common.vo.ProcessResultVO;

public interface AtndCrtrService {

    /*****************************************************
     * 출석점수 기준관리 목록 조회
     * @param vo
     * @return ProcessResultVO<AtndCrtrVO>
     ******************************************************/
    public ProcessResultVO<AtndCrtrVO> listPaging(AtndCrtrVO vo);

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
     * 이전 기준 조회
     * @param vo
     * @return AtndCrtrVO
     ******************************************************/
    public AtndCrtrVO selectPrev(AtndCrtrVO vo);

    /*****************************************************
     * 출석점수 기준관리 저장
     * @param vo
     ******************************************************/
    public void save(AtndCrtrVO vo);

    /*****************************************************
     * 출석점수 기준관리 삭제
     * @param vo
     ******************************************************/
    public void delete(AtndCrtrVO vo);
}
