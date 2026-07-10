package knou.lms.crs.rubric.dao;

import knou.lms.crs.rubric.vo.RubricVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("rubricDAO")
public interface RubricDAO {
    // 루브릭 등록
    public void rubricRegist(RubricVO vo);

    // 루브릭 문항 등록
    public void rubricQstnRegist(RubricVO vo);

    // 루브릭 보기항목 등록
    public void rubricVwitmRegist(RubricVO vo);

    // 루브릭 목록 페이징
    public List<RubricVO> listRubricPaging(RubricVO vo);

    // 루브릭 목록 카운트
    public int countRubric(RubricVO vo);

    // 루브릭 가져오기 목록
    public List<RubricVO> importRubricList(RubricVO vo);

    // 루브릭 등록정보 조회
    public RubricVO selectRubricRegistInfo(RubricVO vo);

    // 등록자 정보 조회
    public RubricVO selectRegisterInfo(RubricVO vo);

    // 루브릭 문항정보 목록 조회
    public List<EgovMap> listRubricInfo(RubricVO vo);

    // 루브릭 수정
    public void rubricModify(RubricVO vo);

    // 루브릭 사용여부 수정
    public void rubricUseynModify(RubricVO vo);

    // 상위 루브릭ID 수정
    public void upRubricIdModify(RubricVO vo);

    // 루브릭 삭제
    public void rubricDelete(RubricVO vo);

    // 루브릭 문항 삭제
    public void rubricQstnDelete(RubricVO vo);

    // 루브릭 보기항목 삭제
    public void rubricVwitmDelete(RubricVO vo);
}
