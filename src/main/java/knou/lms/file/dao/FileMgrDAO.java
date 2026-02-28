package knou.lms.file.dao;

import java.util.List;

import knou.lms.file.vo.CrsSizeMgrVO;
import knou.lms.file.vo.FileSizeMgrVO;
import knou.lms.file.vo.LmsTermVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper("fileMgrDAO")
public interface FileMgrDAO {
    
    /*****************************************************
     *권한 그룹별 용량제한 리스트 조회
     * 
     * @param vo
     * @return List<FileSizeMgrVO>
     * @throws Exception
     ******************************************************/
    public List<FileSizeMgrVO> listAuthGrpSizeLimit(FileSizeMgrVO vo) throws Exception;

    /*****************************************************
     *사용자별 용량관리 리스트의 카운트 한다.
     * 
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectUserSizeLimitCount(FileSizeMgrVO vo) throws Exception;

    /*****************************************************
     *사용자별 용량제한 리스트 조회
     * 
     * @param vo
     * @return List<FileSizeMgrVO>
     * @throws Exception
     ******************************************************/
    public List<FileSizeMgrVO> listUserSizeLimitPageing(FileSizeMgrVO vo) throws Exception;

    /*****************************************************
     *권한 그룹의 용량 변경.
     * 
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateAuthGrpSizeLimit(FileSizeMgrVO vo) throws Exception;

    /*****************************************************
     *사용자의 용량 변경.
     * 
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateUserSizeLimit(FileSizeMgrVO vo) throws Exception;

    /***************************************************** 
     *학기 목록를 조회한다.
     * @param vo
     * @return
     * @throws Exception
     ******************************************************/ 
    public List<LmsTermVO> listLmsTerm(LmsTermVO vo) throws Exception;

    /*****************************************************
     *과목별 용량관리 리스트의 카운트 한다.
     * 
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectCrsSizeLimitCount(CrsSizeMgrVO vo) throws Exception;

    /*****************************************************
     *과목별 용량제한 리스트 조회
     * 
     * @param vo
     * @return List<FileSizeMgrVO>
     * @throws Exception
     ******************************************************/
    public List<CrsSizeMgrVO> listCrsSizeLimitPageing(CrsSizeMgrVO vo) throws Exception;

    /*****************************************************
     *과목의 용량 변경.
     * 
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateCrsSizeLimit(CrsSizeMgrVO vo) throws Exception;

    /***************************************************** 
     *과목별 용량제한 초기 설정 리스트 조회
     * @param vo
     * @return
     * @throws Exception
     ******************************************************/ 
    public List<CrsSizeMgrVO> listDefaultCrsSizeLimit(CrsSizeMgrVO vo) throws Exception;

    /***************************************************** 
     *과목별 초기 용량 설정 변경
     * @param vo
     * @throws Exception
     ******************************************************/ 
    
    public void updateDefaultCrsSizeLimit(CrsSizeMgrVO vo) throws Exception;
}
