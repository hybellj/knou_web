package knou.lms.sch.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.sch.vo.PopupNoticeVO;

@Mapper("popupNoticeDAO")
public interface PopupNoticeDAO {
	
    /***************************************************** 
     * 팝업공지 정보 조회
     * @param vo
     * @return PopupNoticeVO
     * @throws Exception
     ******************************************************/
    public PopupNoticeVO select(PopupNoticeVO vo) throws Exception;
    
    /***************************************************** 
     * 팝업공지 목록 조회
     * @param vo
     * @return List<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    public List<PopupNoticeVO> list(PopupNoticeVO vo) throws Exception;
    
    /***************************************************** 
     * 팝업공지 페이징 목록 조회
     * @param vo
     * @return List<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    public List<PopupNoticeVO> listPaging(PopupNoticeVO vo) throws Exception;
    
    /***************************************************** 
     * 팝업공지 목록 수 조회
     * @param vo
     * @return ProcessResultVO<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    public int count(PopupNoticeVO vo) throws Exception;
    
    /***************************************************** 
     * 팝업공지 상위 목록 조회
     * @param vo
     * @return List<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    public List<PopupNoticeVO> listTop(PopupNoticeVO vo) throws Exception;
    
    /***************************************************** 
     * 팝업공지 등록
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void insert(PopupNoticeVO vo) throws Exception;
    
    /***************************************************** 
     * 팝업공지 위치 크기 등록
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void insertPstnSize(PopupNoticeVO vo) throws Exception;
    
    /***************************************************** 
     * 팝업공지 수정
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void update(PopupNoticeVO vo) throws Exception;
    
    /***************************************************** 
     * 팝업공지 위치 크기 수정
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void updatePstnSize(PopupNoticeVO vo) throws Exception;
    
    /***************************************************** 
     * 팝업공지 사용여부 수정
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void updateUseYn(PopupNoticeVO vo) throws Exception;
    
    /***************************************************** 
     * 팝업공지 삭제
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void delete(PopupNoticeVO vo) throws Exception;

    /***************************************************** 
     * 활성 팝업공지 정보 조회
     * @param vo
     * @return PopupNoticeVO
     * @throws Exception
     ******************************************************/
    public PopupNoticeVO selectAcitvePop(PopupNoticeVO vo) throws Exception;
}
