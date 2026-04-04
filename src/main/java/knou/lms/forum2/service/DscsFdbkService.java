package knou.lms.forum2.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsFdbkVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface DscsFdbkService {

    public List<EgovMap> forumFdbkList(DscsFdbkVO vo) throws Exception;
    public void insertForumFdbk(DscsFdbkVO vo) throws Exception;
    public void updateForumFdbk(DscsFdbkVO vo) throws Exception;
    public void deleteForumFdbk(DscsFdbkVO vo) throws Exception;
    public void insertForumAllFdbk(DscsFdbkVO vo) throws Exception;
    public List<DscsFdbkVO> selectFdbk(DscsFdbkVO vo) throws Exception;
    public ProcessResultVO<DscsFdbkVO> insertFdbk(DscsFdbkVO vo) throws Exception;
    public ProcessResultVO<DscsFdbkVO> updateFdbk(DscsFdbkVO vo) throws Exception;
    public ProcessResultVO<DscsFdbkVO> deleteFdbk(DscsFdbkVO vo) throws Exception;
    public int cntFdbk(DscsFdbkVO vo) throws Exception;

}
