package knou.lms.evalwgtmng.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.common.dto.ResultDTO;
import knou.lms.evalwgtmng.vo.EvalWgtMngVO;

public interface EvalWgtMngService {

    /*****************************************************
     * 평가비중관리 목록 조회
     * @param pageInfo
     * @return ResultDTO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ResultDTO<EgovMap> listEvalWgtMng(PageInfo pageInfo) throws Exception;

    /*****************************************************
     * 평가비중관리 과목 목록 조회
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listEvalWgtMngSubject(EvalWgtMngVO vo) throws Exception;

    /*****************************************************
     * 평가비중관리 과목 정보 조회
     * @param vo
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectEvalWgtMngSubject(EvalWgtMngVO vo) throws Exception;

    /*****************************************************
     * 평가비중관리 분반 목록 조회
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listEvalWgtMngDvclasSubject(EvalWgtMngVO vo) throws Exception;

    /*****************************************************
     * 평가비중관리 평가항목 목록 조회
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listEvalWgtMngItem(EvalWgtMngVO vo) throws Exception;

    /*****************************************************
     * 평가비중관리 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    public void saveEvalWgtMng(EvalWgtMngVO vo) throws Exception;

    /*****************************************************
     * 평가비중관리 엑셀 업로드
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int evalWgtMngExcelUpload(EvalWgtMngVO vo) throws Exception;
}
