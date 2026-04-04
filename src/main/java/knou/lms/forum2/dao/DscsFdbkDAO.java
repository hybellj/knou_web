package knou.lms.forum2.dao;

import knou.lms.forum2.vo.DscsFdbkVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("dscsFdbkDAO")
public interface DscsFdbkDAO {

    public List<EgovMap> forumFdbkList(DscsFdbkVO vo) throws Exception;
    public void insertForumFdbk(DscsFdbkVO vo) throws Exception;
    public void updateForumFdbk(DscsFdbkVO vo) throws Exception;
    public void deleteForumFdbk(DscsFdbkVO vo) throws Exception;
    public void insertForumAllFdbk(DscsFdbkVO vo) throws Exception;
    public List<DscsFdbkVO> selectFdbk(DscsFdbkVO vo) throws Exception;
    public void insertFdbk(DscsFdbkVO vo) throws Exception;
    public void updateFdbk(DscsFdbkVO vo) throws Exception;
    public void deleteFdbk(DscsFdbkVO vo) throws Exception;
    public int cntFdbk(DscsFdbkVO vo) throws Exception;

}
