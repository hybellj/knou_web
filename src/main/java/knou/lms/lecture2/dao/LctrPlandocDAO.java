package knou.lms.lecture2.dao;

import knou.lms.lecture2.vo.LctrPlandocVO;
import knou.lms.lecture2.vo.LectureScheduleVO;
import knou.lms.lecture2.vo.RltmExamVO;
import knou.lms.lecture2.vo.TxtbkVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("lctrPlandocDAO")
public interface LctrPlandocDAO {

    public List<EgovMap> lctrPlandocList(LctrPlandocVO lctrPlandocVO) throws Exception;

    public List<EgovMap> lctrPlandocListPaging(LctrPlandocVO lctrPlandocVO) throws Exception;

    public LctrPlandocVO lctrPlandocSelect(String sbjctId) throws Exception;

    public int lctrPlandocModify(LctrPlandocVO lctrPlandocVO) throws Exception;

    public int lctrPlandocRegist(LctrPlandocVO lctrPlandocVO) throws Exception;

    int lctrWknoSchdlDeleteByPlandocId(String lctrPlandocId) throws Exception;

    int rltmExamDeleteByPlandocId(String lctrPlandocId) throws Exception;

    int lctrPlandocDelete(String lctrPlandocId) throws Exception;

    List<EgovMap> admSbjctSchdlListForPlandocRegist(String sbjctId) throws Exception;

    int lctrWknoSchdlRegistFromSbjctSchdl(LectureScheduleVO lectureScheduleVO) throws Exception;

    public List<TxtbkVO> txtbkList(String sbjctId) throws Exception;

    public int txtbkRegist(TxtbkVO txtbkVO) throws Exception;

    public int allTxtbkDelete(String sbjctId) throws Exception;

    List<EgovMap> stdntLctrPlandocList(LctrPlandocVO lctrPlandocVO);

    List<EgovMap> stdntLctrPlandocListPaging(LctrPlandocVO lctrPlandocVO);

    List<EgovMap> stdntOrgList(LctrPlandocVO planParamVO);

    List<EgovMap> stdntSbjctList(LctrPlandocVO planParamVO);

    List<EgovMap> profOrgList(LctrPlandocVO planParamVO);

    List<EgovMap> profSbjctList(LctrPlandocVO planParamVO);

    List<EgovMap> admLctrPlandocList(LctrPlandocVO lctrPlandocVO);

    List<EgovMap> admLctrPlandocListPaging(LctrPlandocVO lctrPlandocVO);

    List<EgovMap> admOrgList(LctrPlandocVO planParamVO);

    List<EgovMap> admSbjctList(LctrPlandocVO planParamVO);

    List<RltmExamVO> rltmExamList(String lctrPlandocId);

    RltmExamVO rltmExamSelect(RltmExamVO rltmExamVO);

    int rltmExamRegist(RltmExamVO rltmExamVO);

    int rltmExamModify(RltmExamVO rltmExamVO);
}
