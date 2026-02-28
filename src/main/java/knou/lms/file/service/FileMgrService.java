package knou.lms.file.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.file.vo.CrsSizeMgrVO;
import knou.lms.file.vo.FileSizeMgrVO;
import knou.lms.file.vo.LmsTermVO;

public interface FileMgrService {

    /***************************************************** 
     *권한 그룹별 용량제한 리스트 조회
     * @param vo
     * @return
     * @throws Exception
     ******************************************************/ 
    public  List<FileSizeMgrVO> listAuthGrpSizeLimit(FileSizeMgrVO vo) throws Exception;

    /*****************************************************
     *사용자별 용량제한 리스트 조회(페이징 적용)
     * @param vo
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultListVO
     * @throws Exception
     ******************************************************/
    public  ProcessResultListVO<FileSizeMgrVO> listUserSizeLimitPageing(FileSizeMgrVO vo, int pageIndex, int listScale, int pageScale) throws Exception;

    /***************************************************** 
     *권한 그룹의 용량 변경.
     * @param vo
     * @throws Exception
     ******************************************************/ 
    public  void updateAuthGrpSizeLimit(FileSizeMgrVO vo) throws Exception;

    /***************************************************** 
     *사용자의 용량 변경.
     * @param vo
     * @throws Exception
     ******************************************************/ 
    public  void updateUserSizeLimit(FileSizeMgrVO vo) throws Exception;

    /***************************************************** 
     *학기 목록를 조회한다.
     * @param vo
     * @return
     * @throws Exception
     ******************************************************/ 
    public  List<LmsTermVO> listLmsTerm(LmsTermVO vo) throws Exception;

    /*****************************************************
     *과목별 용량제한 리스트 조회(페이징 적용)
     * @param vo
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultListVO
     * @throws Exception
     ******************************************************/
    public  ProcessResultListVO<CrsSizeMgrVO> listCrsSizeLimitPageing(CrsSizeMgrVO vo, int pageIndex, int listScale, int pageScale) throws Exception;

    /***************************************************** 
     *과목의 용량 변경.
     * @param vo
     * @throws Exception
     ******************************************************/ 
    public  void updateCrsSizeLimit(CrsSizeMgrVO vo) throws Exception;

    /***************************************************** 
     *과목별 용량제한 초기 설정 리스트 조회
     * @param vo
     * @return List<CrsSizeMgrVO>
     * @throws Exception
     ******************************************************/ 
    public  List<CrsSizeMgrVO> listDefaultCrsSizeLimit(CrsSizeMgrVO vo) throws Exception;

    /***************************************************** 
     *과목별 초기 용량 설정 변경
     * @param vo
     * @throws Exception
     ******************************************************/ 
    public  void updateDefaultCrsSizeLimit(CrsSizeMgrVO vo) throws Exception;
}