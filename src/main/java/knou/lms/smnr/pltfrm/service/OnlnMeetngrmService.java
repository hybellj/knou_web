package knou.lms.smnr.pltfrm.service;

import knou.lms.smnr.pltfrm.vo.OnlnMeetngrmVO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmUserVO;
import knou.lms.smnr.vo.SmnrVO;

public interface OnlnMeetngrmService {

	/**
     * 온라인회의실등록
     *
     * @param pltfrmGbncd		플랫폼구분코드
     * @param smnrId			세미나아이디
     * @param OnlnPltfrmUserVO	온라인플랫폼사용자
     * @param Object
     * @throws Exception
     */
	public OnlnMeetngrmVO onlnMeetngrmRegist(String pltfrmGbncd, String smnrId, OnlnPltfrmUserVO user, Object obj) throws Exception;

	/**
     * 온라인회의실수정
     *
     * @param pltfrmGbncd		플랫폼구분코드
     * @param SmnrVO			세미나정보
     * @throws Exception
     */
	public void onlnMeetngrmModify(String pltfrmGbncd, SmnrVO vo) throws Exception;

}
