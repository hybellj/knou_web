package knou.lms.forum2.service;

import java.util.List;

import knou.lms.forum2.vo.DscsCmntVO;

public interface DscsCmntService {

    public void insertCmnt(DscsCmntVO vo) throws Exception;
    public void updateCmnt(DscsCmntVO vo) throws Exception;
    public void deleteCmnt(DscsCmntVO vo) throws Exception;
    public void hideCmnt(DscsCmntVO vo) throws Exception;
    public DscsCmntVO forumCmntSelect(DscsCmntVO vo) throws Exception;

}
