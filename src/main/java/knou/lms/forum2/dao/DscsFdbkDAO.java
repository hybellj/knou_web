package knou.lms.forum2.dao;

import knou.lms.forum2.vo.DscsFdbkVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("dscsFdbkDAO")
public interface DscsFdbkDAO {

    public List<EgovMap> dscsFdbkList(DscsFdbkVO vo) throws Exception;
    public void insertDscsFdbk(DscsFdbkVO vo) throws Exception;
    public void updateDscsFdbk(DscsFdbkVO vo) throws Exception;
    public void deleteDscsFdbk(DscsFdbkVO vo) throws Exception;
    public void insertDscsAllFdbk(DscsFdbkVO vo) throws Exception;
    public List<DscsFdbkVO> selectFdbk(DscsFdbkVO vo) throws Exception;
    public void insertFdbk(DscsFdbkVO vo) throws Exception;
    public void updateFdbk(DscsFdbkVO vo) throws Exception;
    public void deleteFdbk(DscsFdbkVO vo) throws Exception;
    public int cntFdbk(DscsFdbkVO vo) throws Exception;
}
