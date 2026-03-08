package knou.lms.file.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.file.vo.AtflRepoVO;
import knou.lms.file.vo.AtflVO;

@Mapper("attachFileDAO")
public interface AttachFileDAO {

    /*****************************************************
     * 첨부파일조회
     * @param AtflVO
     * @return AtflVO
     * @throws Exception
     ******************************************************/
    public AtflVO selectAtfl(AtflVO vo) throws Exception;

    /*****************************************************
     * 첨부파일목록조회 (by RefId)
     * @param AtflVO
     * @return List<AtflVO>
     * @throws Exception
     ******************************************************/
    public List<AtflVO> selectAtflListByRefId(AtflVO vo) throws Exception;

    /*****************************************************
     * 첨부파일목록저장
     * @param List<AtflVO>
     * @throws Exception
     ******************************************************/
    public void insertAtflList(List<AtflVO> fileList) throws Exception;

    /*****************************************************
     * 첨부파일 삭제
     * @param AtflVO
     ******************************************************/
    public void deleteAtfl(AtflVO vo) throws Exception;

    /*****************************************************
     * 첨부파일저장소목록조회
     * @return List<AtflRepoVO>
     * @throws Exception
     ******************************************************/
    public List<AtflRepoVO> selectAtflRepoList() throws Exception;
}