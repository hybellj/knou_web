package knou.lms.evalwgtmng.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.evalwgtmng.vo.EvalWgtMngVO;
import knou.lms.mrk.vo.MarkItemSettingVO;

@Mapper("evalWgtMngDAO")
public interface EvalWgtMngDAO {

    /*****************************************************
     * 평가비중관리 목록 건수 조회
     * @param pageInfo
     * @return int
     ******************************************************/
    public int countEvalWgtMng(PageInfo pageInfo);

    /*****************************************************
     * 평가비중관리 목록 조회
     * @param pageInfo
     * @return List<EgovMap>
     ******************************************************/
    public List<EgovMap> listEvalWgtMng(PageInfo pageInfo);

    /*****************************************************
     * 평가비중관리 과목 목록 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    public List<EgovMap> listEvalWgtMngSubject(EvalWgtMngVO vo);

    /*****************************************************
     * 평가비중관리 과목 정보 조회
     * @param vo
     * @return EgovMap
     ******************************************************/
    public EgovMap selectEvalWgtMngSubject(EvalWgtMngVO vo);

    /*****************************************************
     * 평가비중관리 분반 목록 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    public List<EgovMap> listEvalWgtMngDvclasSubject(EvalWgtMngVO vo);

    /*****************************************************
     * 평가비중관리 평가항목 목록 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    public List<EgovMap> listEvalWgtMngItem(EvalWgtMngVO vo);

    /*****************************************************
     * 평가비중관리 엑셀 과목 매칭 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    public List<EgovMap> listEvalWgtMngExcelSubjectMatch(EvalWgtMngVO vo);

    /*****************************************************
     * 평가비중관리 평가항목 저장
     * @param vo
     * @return int
     ******************************************************/
    public int mergeEvalWgtMngItem(MarkItemSettingVO vo);
}
