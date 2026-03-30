package knou.lms.lecture2.dao;

import knou.lms.lecture2.vo.LctrPlandocVO;
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

    public List<TxtbkVO> txtbkList(String sbjctId) throws Exception;

    public int txtbkRegist(TxtbkVO txtbkVO) throws Exception;

    public int allTxtbkDelete(String sbjctId) throws Exception;
}