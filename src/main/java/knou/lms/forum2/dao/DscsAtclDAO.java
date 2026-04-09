package knou.lms.forum2.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.forum2.vo.DscsAtclVO;
import knou.lms.forum2.vo.DscsMutVO;

@Mapper("dscsAtclDAO")
public interface DscsAtclDAO {

    public int countAtcl(DscsAtclVO vo) throws Exception;
    public int count(DscsAtclVO vo) throws Exception;
    public List<DscsAtclVO> listPageing(DscsAtclVO vo) throws Exception;
    public void insertAtcl(DscsAtclVO vo) throws Exception;
    public DscsAtclVO selectAtcl(DscsAtclVO vo) throws Exception;
    public void updateAtcl(DscsAtclVO vo) throws Exception;
    public void deleteAtcl(DscsAtclVO vo) throws Exception;
    public void hideAtcl(DscsAtclVO vo) throws Exception;
//    public DscsAtclVO selectMutResult(DscsAtclVO vo) throws Exception;
/*
    public List<DscsAtclVO> selectAtclUserList(DscsMutVO vo) throws Exception;*/
    public List<DscsAtclVO> listAtcl(DscsAtclVO vo) throws Exception;
	public int myAtclCnt(DscsAtclVO vo) throws Exception;
    public List<DscsAtclVO> listAtclExcel(DscsAtclVO vo) throws Exception;

}
