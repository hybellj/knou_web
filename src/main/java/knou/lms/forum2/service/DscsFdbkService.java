package knou.lms.forum2.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsFdbkVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface DscsFdbkService {

    public List<EgovMap> dscsFdbkList(DscsFdbkVO vo) throws Exception;
    public void insertDscsFdbk(DscsFdbkVO vo) throws Exception;
    public void updateDscsFdbk(DscsFdbkVO vo) throws Exception;
    public void deleteDscsFdbk(DscsFdbkVO vo) throws Exception;
    public void insertDscsAllFdbk(DscsFdbkVO vo) throws Exception;
    public List<DscsFdbkVO> selectFdbk(DscsFdbkVO vo) throws Exception;
    public ProcessResultVO<DscsFdbkVO> insertFdbk(DscsFdbkVO vo) throws Exception;
    public ProcessResultVO<DscsFdbkVO> updateFdbk(DscsFdbkVO vo) throws Exception;
    public ProcessResultVO<DscsFdbkVO> deleteFdbk(DscsFdbkVO vo) throws Exception;
    public int cntFdbk(DscsFdbkVO vo) throws Exception;
}
