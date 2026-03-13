package knou.lms.forum2.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.forum.vo.ForumAtclVO;
import knou.lms.forum.vo.ForumCmntVO;

@Mapper("forum2CmntDAO")
public interface ForumCmntDAO {

    public void insertCmnt(ForumCmntVO vo) throws Exception;
    public void updateCmnt(ForumCmntVO vo) throws Exception;
    public void deleteCmnt(ForumCmntVO vo) throws Exception;
	public List<ForumCmntVO> cmntList(ForumAtclVO vo) throws Exception;
	public ForumCmntVO forumCmntSelect(ForumCmntVO vo) throws Exception;
}
