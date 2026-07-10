package knou.lms.crs.rubric.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.rubric.vo.RubricVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface RubricService {
    // 루브릭 등록
    public RubricVO rubricRegist(RubricVO vo);

    // 루브릭 목록 페이징
    public ProcessResultVO<RubricVO> listRubricPaging(RubricVO vo);

    // 루브릭 가져오기 목록
    public List<RubricVO> importRubricList(RubricVO vo);

    // 루브릭 등록정보 조회
    public RubricVO selectRubricRegistInfo(RubricVO vo);

    // 등록자 정보 조회
    public RubricVO selectRegisterInfo(RubricVO vo);

    // 루브릭 문항정보 목록 조회
    public List<EgovMap> listRubricInfo(RubricVO vo);

    // 루브릭 수정
    public RubricVO rubricModify(RubricVO vo);

    // 루브릭 사용여부 수정
    public void rubricUseynModify(RubricVO vo);

    // 루브릭 삭제
    public void rubricDelete(RubricVO vo);
}
