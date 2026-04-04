package knou.lms.forum2.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.forum2.vo.DscsAtclVO;
import knou.lms.forum2.vo.DscsCmntVO;

@Mapper("dscsCmntDAO")
public interface DscsCmntDAO {

    public void insertCmnt(DscsCmntVO vo) throws Exception;
    public void updateCmnt(DscsCmntVO vo) throws Exception;
    public void deleteCmnt(DscsCmntVO vo) throws Exception;
    public void hideCmnt(DscsCmntVO vo) throws Exception;
	public List<DscsCmntVO> cmntList(DscsAtclVO vo) throws Exception;
	public DscsCmntVO forumCmntSelect(DscsCmntVO vo) throws Exception;
}
