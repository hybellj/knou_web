package knou.lms.file.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.lms.file.dao.FileMgrDAO;
import knou.lms.file.service.FileMgrService;

import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.file.vo.CrsSizeMgrVO;
import knou.lms.file.vo.FileSizeMgrVO;
import knou.lms.file.vo.LmsTermVO;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("fileMgrService")
public class FileMgrServiceImpl extends EgovAbstractServiceImpl implements FileMgrService {

    /** Mapper */
    @Resource(name = "fileMgrDAO")
    private FileMgrDAO fileMgrDAO;

    /*****************************************************
     * <p>
     *권한 그룹별 용량제한 리스트 조회
     * <p>
     * 권한 그룹별 용량제한 리스트 조회
     *
     * @param vo
     * @return List<FileSizeMgrVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<FileSizeMgrVO> listAuthGrpSizeLimit(FileSizeMgrVO vo) throws Exception {
        return fileMgrDAO.listAuthGrpSizeLimit(vo);
    }

    /*****************************************************
     * <p>
     *사용자별 용량제한 리스트 조회(페이징 적용).
     * <p>
     * 사용자별 용량제한 리스트 조회(페이징 적용)
     *
     * @param vo
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultListVO<FileSizeMgrVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultListVO<FileSizeMgrVO> listUserSizeLimitPageing(FileSizeMgrVO vo, int pageIndex, int listScale, int pageScale) throws Exception {
        
        ProcessResultListVO<FileSizeMgrVO> resultList = new ProcessResultListVO<FileSizeMgrVO>();

        try {
            
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());

            // 전체 목록 수
            int totalCount = fileMgrDAO.selectUserSizeLimitCount(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            vo.setTotalCnt(paginationInfo.getLastRecordIndex());
            
            List<FileSizeMgrVO> limitList = fileMgrDAO.listUserSizeLimitPageing(vo);

            resultList.setResult(1);
            resultList.setReturnList(limitList);
            resultList.setPageInfo(paginationInfo);
        } catch(Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }

    /*****************************************************
     * <p>
     *권한 그룹의 용량 변경.
     * <p>
     * 권한 그룹의 용량 변경.
     *
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void updateAuthGrpSizeLimit(FileSizeMgrVO vo) throws Exception {
        
        fileMgrDAO.updateAuthGrpSizeLimit(vo);
    }

    /*****************************************************
     * <p>
     *사용자의 용량 변경.
     * <p>
     * 사용자의 용량 변경.
     *
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void updateUserSizeLimit(FileSizeMgrVO vo) throws Exception {
        
        fileMgrDAO.updateUserSizeLimit(vo);
    }

    /*****************************************************
     * <p>
     *학기 목록를 조회한다.
     * <p>
     * 학기 목록를 조회한다.
     *
     * @param vo
     * @return List<LmsTermVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LmsTermVO> listLmsTerm(LmsTermVO vo) throws Exception {
        return fileMgrDAO.listLmsTerm(vo);
    }

    /*****************************************************
     * <p>
     *과목별 용량제한 리스트 조회(페이징 적용).
     * <p>
     * 과목별 용량제한 리스트 조회(페이징 적용)
     *
     * @param vo
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultListVO<FileSizeMgrVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultListVO<CrsSizeMgrVO> listCrsSizeLimitPageing(CrsSizeMgrVO vo, int pageIndex, int listScale, int pageScale) throws Exception {
        
        ProcessResultListVO<CrsSizeMgrVO> resultList = new ProcessResultListVO<CrsSizeMgrVO>();

        try {
            
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());

            // 전체 목록 수
            int totalCount = fileMgrDAO.selectCrsSizeLimitCount(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            List<CrsSizeMgrVO> limitList = fileMgrDAO.listCrsSizeLimitPageing(vo);

            resultList.setResult(1);
            resultList.setReturnList(limitList);
            resultList.setPageInfo(paginationInfo);
        } catch(Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }

    /*****************************************************
     * <p>
     *과목의 용량 변경.
     * <p>
     * 사용자의 용량 변경.
     *
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void updateCrsSizeLimit(CrsSizeMgrVO vo) throws Exception {
        fileMgrDAO.updateCrsSizeLimit(vo);
    }

    /*****************************************************
     * <p>
     *과목별 용량제한 초기 설정 리스트 조회
     * <p>
     * 과목별 용량제한 초기 설정 리스트 조회
     *
     * @param vo
     * @return List<CrsSizeMgrVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<CrsSizeMgrVO> listDefaultCrsSizeLimit(CrsSizeMgrVO vo) throws Exception {
        return fileMgrDAO.listDefaultCrsSizeLimit(vo);
    }

    /*****************************************************
     * <p>
     *과목별 초기 용량 설정 변경
     * <p>
     * 과목별 초기 용량 설정 변경
     *
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void updateDefaultCrsSizeLimit(CrsSizeMgrVO vo) throws Exception {
        fileMgrDAO.updateDefaultCrsSizeLimit(vo);
    }

}
