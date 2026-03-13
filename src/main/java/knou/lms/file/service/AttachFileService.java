package knou.lms.file.service;

import java.util.List;

import knou.lms.file.vo.AtflRepoVO;
import knou.lms.file.vo.AtflVO;

/**
 * 첨부파일 서비스
 */
public interface AttachFileService {

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
     * 첨부파일 목록 저장
     * @param List<AtflVO>
     *****************************************************/
    public void insertAtflList(List<AtflVO> fileList) throws Exception;

	/*****************************************************
     * 첨부파일 삭제 (by atflIds)
     * @param String[]
     *****************************************************/
    public void deleteAtflByAtflIds(String[] atflIds) throws Exception;

    /*****************************************************
     * 첨부파일 삭제
     * @param AtflVO
     *****************************************************/
    public void deleteAtfl(AtflVO vo) throws Exception;

    /*****************************************************
     * 첨부파일저장소목록조회
     * @return List<AtflRepoVO>
     * @throws Exception
     ******************************************************/
    public List<AtflRepoVO> selectAtflRepoList() throws Exception;
}
