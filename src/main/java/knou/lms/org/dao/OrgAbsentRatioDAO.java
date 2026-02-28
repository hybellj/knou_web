package knou.lms.org.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.org.vo.OrgAbsentRatioVO;

@Mapper("orgAbsentRatioDAO")
public interface OrgAbsentRatioDAO {
    
    /*****************************************************
     * TODO 결시원 성적비율 리스트 조회
     * @param OrgAbsentRatioVO
     * @return List<OrgAbsentRatioVO>
     * @throws Exception
     ******************************************************/
    public List<OrgAbsentRatioVO> list(OrgAbsentRatioVO vo) throws Exception;
    
    /*****************************************************
     * TODO 결시원 성적비율 정보 조회
     * @param OrgAbsentRatioVO
     * @return OrgAbsentRatioVO
     * @throws Exception
     ******************************************************/
    public OrgAbsentRatioVO select(OrgAbsentRatioVO vo) throws Exception;
    
    /*****************************************************
     * TODO 결시원 성적비율 등록
     * @param OrgAbsentRatioVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(OrgAbsentRatioVO vo) throws Exception;
    
    /*****************************************************
     * TODO 결시원 성적비율 수정
     * @param OrgAbsentRatioVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void update(OrgAbsentRatioVO vo) throws Exception;
    
    /*****************************************************
     * TODO 결시원 성적비율 삭제
     * @param OrgAbsentRatioVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delete(OrgAbsentRatioVO vo) throws Exception;

}
