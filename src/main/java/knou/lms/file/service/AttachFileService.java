package knou.lms.file.service;

import java.util.List;

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


}
