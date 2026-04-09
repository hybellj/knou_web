package knou.lms.forum2.service;

import java.util.List;


import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsAtclVO;
import knou.lms.forum2.vo.DscsMutVO;

public interface DscsAtclService {

    public int forumAtclCount(DscsAtclVO vo) throws Exception;
    public abstract ProcessResultVO<DscsAtclVO> listPageing(DscsAtclVO vo) throws Exception;
    public void insertAtcl(DscsAtclVO vo, String teamId) throws Exception;
    public DscsAtclVO selectAtcl(DscsAtclVO vo) throws Exception;
    public void updateAtcl(DscsAtclVO vo) throws Exception;
    public void deleteAtcl(DscsAtclVO vo) throws Exception;
    public void hideAtcl(DscsAtclVO vo) throws Exception;
    public List<DscsAtclVO> forumAtclList(DscsAtclVO vo) throws Exception;
	public int myAtclCnt(DscsAtclVO vo) throws Exception;
    public List<DscsAtclVO> forumAtclExcalList(DscsAtclVO vo) throws Exception;

}
