package knou.lms.rubricmng.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.rubricmng.vo.RubricMngVO;

@Mapper("rubricMngDAO")
public interface RubricMngDAO {

    /*****************************************************
     * 기관 목록 조회
     * @param vo
     * @return List<RubricMngVO>
     ******************************************************/
    public List<RubricMngVO> listOrg(RubricMngVO vo);

    /*****************************************************
     * 루브릭 등록
     * @param vo
     ******************************************************/
    public void rubricRegist(RubricMngVO vo);

    /*****************************************************
     * 루브릭 문항 등록
     * @param vo
     ******************************************************/
    public void rubricQstnRegist(RubricMngVO vo);

    /*****************************************************
     * 루브릭 문항 보기항목 등록
     * @param vo
     ******************************************************/
    public void rubricVwitmRegist(RubricMngVO vo);

    /*****************************************************
     * 루브릭 목록 조회
     * @param vo
     * @return List<RubricMngVO>
     ******************************************************/
    public List<RubricMngVO> listRubricPaging(RubricMngVO vo);

    /*****************************************************
     * 루브릭 목록 건수 조회
     * @param vo
     * @return int
     ******************************************************/
    public int countRubric(RubricMngVO vo);

    /*****************************************************
     * 루브릭 기본정보 조회
     * @param vo
     * @return RubricMngVO
     ******************************************************/
    public RubricMngVO selectRubricRegistInfo(RubricMngVO vo);

    /*****************************************************
     * 등록 화면 기본정보 조회
     * @param vo
     * @return RubricMngVO
     ******************************************************/
    public RubricMngVO selectRegisterInfo(RubricMngVO vo);

    /*****************************************************
     * 루브릭 문항/평가등급 정보 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    public List<EgovMap> listRubricInfo(RubricMngVO vo);

    /*****************************************************
     * 루브릭 수정
     * @param vo
     ******************************************************/
    public void rubricModify(RubricMngVO vo);

    /*****************************************************
     * 루브릭 사용여부 수정
     * @param vo
     ******************************************************/
    public void rubricUseynModify(RubricMngVO vo);

    /*****************************************************
     * 루브릭 삭제
     * @param vo
     ******************************************************/
    public void rubricDelete(RubricMngVO vo);

    /*****************************************************
     * 루브릭 문항 삭제
     * @param vo
     ******************************************************/
    public void rubricQstnDelete(RubricMngVO vo);

    /*****************************************************
     * 루브릭 문항 보기항목 삭제
     * @param vo
     ******************************************************/
    public void rubricVwitmDelete(RubricMngVO vo);
}
