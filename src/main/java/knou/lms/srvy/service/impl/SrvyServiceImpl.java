package knou.lms.srvy.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.srvy.dao.SrvyDAO;
import knou.lms.srvy.dao.SrvyGrpDAO;
import knou.lms.srvy.dao.SrvyTrgtDAO;
import knou.lms.srvy.service.SrvyService;
import knou.lms.srvy.vo.SrvyGrpVO;
import knou.lms.srvy.vo.SrvyTrgtVO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.team.dao.TeamDAO;
import knou.lms.team.vo.TeamVO;

@Service("srvyService")
public class SrvyServiceImpl extends ServiceBase implements SrvyService {

	@Resource(name="srvyDAO")
	private SrvyDAO srvyDAO;

	@Resource(name="srvyTrgtDAO")
	private SrvyTrgtDAO srvyTrgtDAO;

	@Resource(name="srvyGrpDAO")
	private SrvyGrpDAO srvyGrpDAO;

	@Resource(name="teamDAO")
	private TeamDAO teamDAO;

	/**
     * 교수설문목록조회
     *
     * @param sbjctId	 	과목아이디
     * @param searchValue  	검색내용(설문명)
     * @return 설문목록 페이징
     * @throws Exception
     */
	@Override
	public ProcessResultVO<EgovMap> profSrvyListPaging(SrvyVO vo) throws Exception {
		PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<EgovMap> srvyList = srvyDAO.profSrvyListPaging(vo);

        if(srvyList.size() > 0) {
            paginationInfo.setTotalRecordCount(((BigDecimal)srvyList.get(0).get("totalCnt")).intValue());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        resultVO.setReturnList(srvyList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
	}

	/**
     * 설문등록
     *
     * @param SrvyVO				설문정보
     * @param Map<String, String>	부가정보
     * @throws Exception
     */
	@Override
	public SrvyVO srvyRegist(SrvyVO vo, Map<String, String> subMap) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> subSrvys = mapper.readValue(subMap.get("subSrvysStr"), new TypeReference<List<Map<String, Object>>>() {});	// 학습그룹부과제정보
		List<String> sbjctIds = new ArrayList<>(Arrays.asList(subMap.get("sbjctIds").split(",")));												// 분반과목아이디목록
		List<String> lrnGrpIds = new ArrayList<>(Arrays.asList(subMap.get("lrnGrpIds").split(",")));											// 학습그룹아이디:과목아이디목록
		List<String> byteamSubsrvyUseyns = Arrays.asList(subMap.get("byteamSubsrvyUseyns").split(","));											// 팀별부설문사용여부:과목아이디목록

		String mrkOyn = vo.getMrkOyn();
        if("Y".equals(mrkOyn)) {
            int mrkOynReshCnt = srvyDAO.sbjctMrkOynSrvyCntSelect(vo.getSbjctId(), null);	// 과목성적공개설문수조회
            if(mrkOynReshCnt > 0) {
                vo.setMrkOyn("N");
            }
        }

		// 설문등록
		vo.setSrvyId(IdGenUtil.genNewId(IdPrefixType.SRVY));
		if(byteamSubsrvyUseyns != null) {
			vo.setByteamSubsrvyUseyn(byteamSubsrvyUseyns.stream().anyMatch(item -> item.contains(vo.getSbjctId())) ? "Y" : "N");
		} else {
			vo.setByteamSubsrvyUseyn("N");
		}
		srvyDAO.srvyRegist(vo);

		// 팀 설문
		if("Y".equals(subMap.get("srvyTeamyn"))) {
			Map<Object, Map<String, Object>> idMap = subSrvys.stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
			for(String lrnGrp : lrnGrpIds) {
				if(lrnGrp.split(":")[1].equals(vo.getSbjctId())) {
					TeamVO teamVO = new TeamVO();
                    teamVO.setTeamCtgrCd(lrnGrp.split(":")[0]);
                    List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀목록조회
                    for(TeamVO team : teamList) {
                    	SrvyVO subSrvyVO = mapper.convertValue(vo, SrvyVO.class);
                    	subSrvyVO.setSrvyId(IdGenUtil.genNewId(IdPrefixType.SRVY));
                    	subSrvyVO.setUpSrvyId(vo.getSrvyId());
                        Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                        if(target != null) {
                        	subSrvyVO.setSrvyTtl((String) target.get("ttl"));
                        	subSrvyVO.setSrvyCts((String) target.get("cts"));
                        }
                        srvyDAO.srvyRegist(subSrvyVO);	// 설문등록

                        SrvyTrgtVO trgtVO = new SrvyTrgtVO();
                        trgtVO.setSrvyTrgtrId(IdGenUtil.genNewId(IdPrefixType.SRTGT));
                        trgtVO.setTeamId(team.getTeamId());
                        trgtVO.setSrvyId(subSrvyVO.getSrvyId());
                        trgtVO.setRgtrId(vo.getRgtrId());
                        srvyTrgtDAO.srvyTrgtRegist(trgtVO);	// 설문대상등록
                    }
				}
			}
			// 등록 과목아이디 목록 삭제
			lrnGrpIds.removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
		}

        if("LCTR_SRVY".equals(vo.getSrvyGbncd())) {
            srvyMrkRfltrtModify(vo);	// 설문 성적반영비율 수정
        }

        // 분반 등록
        if("Y".equals(vo.getDvclasRegyn())) {
        	String srvyId = vo.getSrvyId();
        	sbjctIds.removeIf(item -> item.equals(vo.getSbjctId()));	// 설문등록 분반 목록 제거

        	SrvyGrpVO grpVO = new SrvyGrpVO();
        	grpVO.setSrvyGrpId(IdGenUtil.genNewId(IdPrefixType.SRGRP));
        	grpVO.setSrvyGrpnm("설문그룹");
        	grpVO.setRgtrId(vo.getRgtrId());
        	srvyGrpDAO.srvyGrpRegist(grpVO);	// 설문그룹등록
        	vo.setSrvyGrpId(grpVO.getSrvyGrpId());
        	vo.setMrkRfltrt(null);
        	srvyDAO.srvyModify(vo);	// 설문수정

        	for(String sbjctId : sbjctIds) {
        		vo.setSrvyId(IdGenUtil.genNewId(IdPrefixType.SRVY));
                vo.setSbjctId(sbjctId);
                if(byteamSubsrvyUseyns != null) {
                    vo.setByteamSubsrvyUseyn(byteamSubsrvyUseyns.stream().anyMatch(item -> item.contains(sbjctId)) ? "Y" : "N");
                } else {
                    vo.setByteamSubsrvyUseyn("N");
                }
                if("Y".equals(mrkOyn)) {
                    int mrkOynReshCnt = srvyDAO.sbjctMrkOynSrvyCntSelect(vo.getSbjctId(), null);	// 과목성적공개설문수조회
                    if(mrkOynReshCnt > 0) {
                        vo.setMrkOyn("N");
                    } else {
                    	vo.setMrkOyn("Y");
                    }
                }

                srvyDAO.srvyRegist(vo);

                // 팀 설문
                if("Y".equals(subMap.get("srvyTeamyn"))) {
                    Map<Object, Map<String, Object>> idMap = subSrvys.stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
                    for(String lrnGrp : lrnGrpIds) {
                        if(lrnGrp.split(":")[1].equals(sbjctId)) {
                            TeamVO teamVO = new TeamVO();
                            teamVO.setTeamCtgrCd(lrnGrp.split(":")[0]);
                            List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀 목록 조회
                            for(TeamVO team : teamList) {
                            	SrvyVO subSrvyVO = mapper.convertValue(vo, SrvyVO.class);
                            	subSrvyVO.setSrvyId(IdGenUtil.genNewId(IdPrefixType.SRVY));
                            	subSrvyVO.setUpSrvyId(vo.getSrvyId());
                                Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                                if(target != null) {
                                	subSrvyVO.setSrvyTtl((String) target.get("ttl"));
                                	subSrvyVO.setSrvyCts((String) target.get("cts"));
                                }
                                srvyDAO.srvyRegist(subSrvyVO);	// 설문등록

                                SrvyTrgtVO trgtVO = new SrvyTrgtVO();
                                trgtVO.setSrvyTrgtrId(IdGenUtil.genNewId(IdPrefixType.SRTGT));
                                trgtVO.setTeamId(team.getTeamId());
                                trgtVO.setSrvyId(subSrvyVO.getSrvyId());
                                trgtVO.setRgtrId(vo.getRgtrId());
                                srvyTrgtDAO.srvyTrgtRegist(trgtVO);	// 설문대상등록
                            }
                        }
                    }
                }

                if("LCTR_SRVY".equals(vo.getSrvyGbncd())) {
                    srvyMrkRfltrtModify(vo);	// 설문 성적반영비율 수정
                }
            }
        	vo.setSrvyId(srvyId);
        }

        return vo;
	}

	/**
     * 설문수정
     *
     * @param SrvyVO				설문정보
     * @param Map<String, String>	부가정보
     * @throws Exception
     */
	@Override
	public SrvyVO srvyModify(SrvyVO vo, Map<String, String> subMap) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> subSrvys = mapper.readValue(subMap.get("subSrvysStr"), new TypeReference<List<Map<String, Object>>>() {});	// 학습그룹부과제정보
		List<String> sbjctIds = new ArrayList<>(Arrays.asList(subMap.get("sbjctIds").split(",")));												// 분반과목아이디목록
		List<String> lrnGrpIds = new ArrayList<>(Arrays.asList(subMap.get("lrnGrpIds").split(",")));											// 학습그룹아이디:과목아이디목록
		List<String> byteamSubsrvyUseyns = Arrays.asList(subMap.get("byteamSubsrvyUseyns").split(","));											// 팀별부설문사용여부:과목아이디목록

		String mrkOyn = vo.getMrkOyn();
        if("Y".equals(mrkOyn)) {
            int mrkOynReshCnt = srvyDAO.sbjctMrkOynSrvyCntSelect(vo.getSbjctId(), vo.getSrvyId());	// 과목성적공개설문수조회
            if(mrkOynReshCnt > 0) {
                vo.setMrkOyn("N");
            }
        }

        EgovMap bfrSrvy = srvyDAO.srvySelect(vo);	// 기존설문정보조회

		if(byteamSubsrvyUseyns != null) {
			vo.setByteamSubsrvyUseyn(byteamSubsrvyUseyns.stream().anyMatch(item -> item.contains(vo.getSbjctId())) ? "Y" : "N");
		} else {
			vo.setByteamSubsrvyUseyn("N");
		}
		vo.setMrkRfltrt(null);
		srvyDAO.srvyModify(vo); // 설문수정

		// 기존 팀 설문
		if("SRVY_TEAM".equals(StringUtil.nvl(bfrSrvy.get("srvyGbn")))) {
			// 신규 팀 설문
			if("Y".equals(subMap.get("srvyTeamyn"))) {
				Map<Object, Map<String, Object>> idMap = subSrvys.stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
				for(String lrnGrp : lrnGrpIds) {
                    if(lrnGrp.split(":")[1].equals(vo.getSbjctId())) {
                    	String lrnGbnId = lrnGrp.split(":")[0];							// 신규 학습그룹아이디
                        String bfrLrnGbnId = StringUtil.nvl(bfrSrvy.get("lrnGrpId"));	// 기존 학습그룹아이디

                        TeamVO teamVO = new TeamVO();
                    	teamVO.setTeamCtgrCd(lrnGrp.split(":")[0]);
                    	List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀 목록 조회

                        // 학습그룹 불일치시
                        if(!lrnGbnId.equals(bfrLrnGbnId)) {
                        	srvyTrgtDAO.srvyTrgtrDelete(vo.getSrvyId());	// 기존 설문대상 삭제
                        	srvyDAO.subSrvyDelete(vo.getSrvyId());			// 기존 팀설문 삭제

                        	for(TeamVO team : teamList) {
                        		SrvyVO subSrvyVO = mapper.convertValue(vo, SrvyVO.class);
                        		subSrvyVO.setSrvyId(IdGenUtil.genNewId(IdPrefixType.SRVY));
                        		subSrvyVO.setUpSrvyId(vo.getSrvyId());
                        		Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                        		if(target != null) {
                        			subSrvyVO.setSrvyTtl((String) target.get("ttl"));
                        			subSrvyVO.setSrvyCts((String) target.get("cts"));
                        		}
                        		srvyDAO.srvyRegist(subSrvyVO);	// 설문등록

                        		SrvyTrgtVO trgtVO = new SrvyTrgtVO();
                        		trgtVO.setSrvyTrgtrId(IdGenUtil.genNewId(IdPrefixType.SRTGT));
                        		trgtVO.setTeamId(team.getTeamId());
                        		trgtVO.setSrvyId(subSrvyVO.getSrvyId());
                        		trgtVO.setRgtrId(vo.getRgtrId());
                        		srvyTrgtDAO.srvyTrgtRegist(trgtVO);	// 설문대상등록
                        	}
                        // 학습그룹 일치시
                        } else {
                        	List<EgovMap> srvyTemList = srvyDAO.srvyTeamList(vo.getSrvyId());
                        	for(TeamVO team : teamList) {
                        		SrvyVO subSrvyVO = mapper.convertValue(vo, SrvyVO.class);
                        		subSrvyVO.setUpSrvyId(vo.getSrvyId());
                        		Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                        		if(target != null) {
                        			subSrvyVO.setSrvyTtl((String) target.get("ttl"));
                        			subSrvyVO.setSrvyCts((String) target.get("cts"));
                        		}
                        		String srvyId = srvyTemList.stream()
                                	    .filter(map -> team.getTeamId().equals(map.get("teamId")))
                                	    .map(map -> String.valueOf(map.get("srvyId")))
                                	    .findFirst()
                                	    .orElse(null);
                        		subSrvyVO.setSrvyId(srvyId);
                        		srvyDAO.srvyModify(subSrvyVO);	// 설문수정
                        	}
                        }
                    }
                }
				// 등록 과목아이디 목록 삭제
				lrnGrpIds.removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
			// 신규 일반 설문
			} else {
				srvyTrgtDAO.srvyTrgtrDelete(vo.getSrvyId());	// 기존 설문대상 삭제
            	srvyDAO.subSrvyDelete(vo.getSrvyId());			// 기존 팀설문 삭제
			}
		// 기존 일반 설문
		} else {
			// 신규 팀 설문
			if("Y".equals(subMap.get("srvyTeamyn"))) {
				Map<Object, Map<String, Object>> idMap = subSrvys.stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));

				for(String lrnGrp : lrnGrpIds) {
					if(lrnGrp.split(":")[1].equals(vo.getSbjctId())) {
						TeamVO teamVO = new TeamVO();
	                    teamVO.setTeamCtgrCd(lrnGrp.split(":")[0]);
	                    List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀목록조회
	                    for(TeamVO team : teamList) {
	                    	SrvyVO subSrvyVO = mapper.convertValue(vo, SrvyVO.class);
	                    	subSrvyVO.setSrvyId(IdGenUtil.genNewId(IdPrefixType.SRVY));
	                    	subSrvyVO.setUpSrvyId(vo.getSrvyId());
	                        Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
	                        if(target != null) {
	                        	subSrvyVO.setSrvyTtl((String) target.get("ttl"));
	                        	subSrvyVO.setSrvyCts((String) target.get("cts"));
	                        }
	                        srvyDAO.srvyRegist(subSrvyVO);	// 설문등록

	                        SrvyTrgtVO trgtVO = new SrvyTrgtVO();
	                        trgtVO.setSrvyTrgtrId(IdGenUtil.genNewId(IdPrefixType.SRTGT));
	                        trgtVO.setTeamId(team.getTeamId());
	                        trgtVO.setSrvyId(subSrvyVO.getSrvyId());
	                        trgtVO.setRgtrId(vo.getRgtrId());
	                        srvyTrgtDAO.srvyTrgtRegist(trgtVO);	// 설문대상등록
	                    }
					}
				}
				// 등록 과목아이디 목록 삭제
				lrnGrpIds.removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
			}
		}

		if("LCTR_SRVY".equals(vo.getSrvyGbncd())) {
            srvyMrkRfltrtModify(vo);	// 설문 성적반영비율 수정
        }

		// 분반 수정
		if("Y".equals(vo.getDvclasRegyn())) {
        	sbjctIds.removeIf(item -> item.equals(vo.getSbjctId()));	// 설문등록 분반 목록 제거

        	for(String sbjctId : sbjctIds) {
                vo.setSbjctId(sbjctId);
                vo.setSrvyId(srvyDAO.srvyIdSelect(vo));			// 설문아이디 조회
                EgovMap dvclasBfrSrvy = srvyDAO.srvySelect(vo);	// 기존 설문 조회

                if(byteamSubsrvyUseyns != null) {
                    vo.setByteamSubsrvyUseyn(byteamSubsrvyUseyns.stream().anyMatch(item -> item.contains(sbjctId)) ? "Y" : "N");
                } else {
                    vo.setByteamSubsrvyUseyn("N");
                }
                if("Y".equals(mrkOyn)) {
                    int mrkOynReshCnt = srvyDAO.sbjctMrkOynSrvyCntSelect(vo.getSbjctId(), vo.getSrvyId());	// 과목성적공개설문수조회
                    if(mrkOynReshCnt > 0) {
                        vo.setMrkOyn("N");
                    } else {
                    	vo.setMrkOyn("Y");
                    }
                }
                srvyDAO.srvyModify(vo);	// 설문 수정

                // 기존 팀 설문
                if("SRVY_TEAM".equals(StringUtil.nvl(dvclasBfrSrvy.get("srvyGbn")))) {
        			// 신규 팀 설문
        			if("Y".equals(subMap.get("srvyTeamyn"))) {
        				Map<Object, Map<String, Object>> idMap = subSrvys.stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
        				for(String lrnGrp : lrnGrpIds) {
                            if(lrnGrp.split(":")[1].equals(vo.getSbjctId())) {
                            	String lrnGbnId = lrnGrp.split(":")[0];							// 신규 학습그룹아이디
                                String bfrLrnGbnId = StringUtil.nvl(bfrSrvy.get("lrnGrpId"));	// 기존 학습그룹아이디

                                TeamVO teamVO = new TeamVO();
                            	teamVO.setTeamCtgrCd(lrnGrp.split(":")[0]);
                            	List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀 목록 조회

                                // 학습그룹 불일치시
                                if(!lrnGbnId.equals(bfrLrnGbnId)) {
                                	srvyTrgtDAO.srvyTrgtrDelete(vo.getSrvyId());	// 기존 설문대상 삭제
                                	srvyDAO.subSrvyDelete(vo.getSrvyId());			// 기존 팀설문 삭제

                                	for(TeamVO team : teamList) {
                                		SrvyVO subSrvyVO = mapper.convertValue(vo, SrvyVO.class);
                                		subSrvyVO.setSrvyId(IdGenUtil.genNewId(IdPrefixType.SRVY));
                                		subSrvyVO.setUpSrvyId(vo.getSrvyId());
                                		Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                                		if(target != null) {
                                			subSrvyVO.setSrvyTtl((String) target.get("ttl"));
                                			subSrvyVO.setSrvyCts((String) target.get("cts"));
                                		}
                                		srvyDAO.srvyRegist(subSrvyVO);	// 설문등록

                                		SrvyTrgtVO trgtVO = new SrvyTrgtVO();
                                		trgtVO.setSrvyTrgtrId(IdGenUtil.genNewId(IdPrefixType.SRTGT));
                                		trgtVO.setTeamId(team.getTeamId());
                                		trgtVO.setSrvyId(subSrvyVO.getSrvyId());
                                		trgtVO.setRgtrId(vo.getRgtrId());
                                		srvyTrgtDAO.srvyTrgtRegist(trgtVO);	// 설문대상등록
                                	}
                                // 학습그룹 일치시
                                } else {
                                	List<EgovMap> srvyTemList = srvyDAO.srvyTeamList(vo.getSrvyId());
                                	for(TeamVO team : teamList) {
                                		SrvyVO subSrvyVO = mapper.convertValue(vo, SrvyVO.class);
                                		subSrvyVO.setUpSrvyId(vo.getSrvyId());
                                		Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                                		if(target != null) {
                                			subSrvyVO.setSrvyTtl((String) target.get("ttl"));
                                			subSrvyVO.setSrvyCts((String) target.get("cts"));
                                		}
                                		String srvyId = srvyTemList.stream()
                                        	    .filter(map -> team.getTeamId().equals(map.get("teamId")))
                                        	    .map(map -> String.valueOf(map.get("srvyId")))
                                        	    .findFirst()
                                        	    .orElse(null);
                                		subSrvyVO.setSrvyId(srvyId);
                                		srvyDAO.srvyModify(subSrvyVO);	// 설문수정
                                	}
                                }
                            }
                        }
        				// 등록 과목아이디 목록 삭제
        				lrnGrpIds.removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
        			// 신규 일반 설문
        			} else {
        				srvyTrgtDAO.srvyTrgtrDelete(vo.getSrvyId());	// 기존 설문대상 삭제
                    	srvyDAO.subSrvyDelete(vo.getSrvyId());			// 기존 팀설문 삭제
        			}
        		// 기존 일반 설문
                } else {
                	// 신규 팀 설문
        			if("Y".equals(subMap.get("srvyTeamyn"))) {
        				Map<Object, Map<String, Object>> idMap = subSrvys.stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));

        				for(String lrnGrp : lrnGrpIds) {
        					if(lrnGrp.split(":")[1].equals(vo.getSbjctId())) {
        						TeamVO teamVO = new TeamVO();
        	                    teamVO.setTeamCtgrCd(lrnGrp.split(":")[0]);
        	                    List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀목록조회
        	                    for(TeamVO team : teamList) {
        	                    	SrvyVO subSrvyVO = mapper.convertValue(vo, SrvyVO.class);
        	                    	subSrvyVO.setSrvyId(IdGenUtil.genNewId(IdPrefixType.SRVY));
        	                    	subSrvyVO.setUpSrvyId(vo.getSrvyId());
        	                        Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
        	                        if(target != null) {
        	                        	subSrvyVO.setSrvyTtl((String) target.get("ttl"));
        	                        	subSrvyVO.setSrvyCts((String) target.get("cts"));
        	                        }
        	                        srvyDAO.srvyRegist(subSrvyVO);	// 설문등록

        	                        SrvyTrgtVO trgtVO = new SrvyTrgtVO();
        	                        trgtVO.setSrvyTrgtrId(IdGenUtil.genNewId(IdPrefixType.SRTGT));
        	                        trgtVO.setTeamId(team.getTeamId());
        	                        trgtVO.setSrvyId(subSrvyVO.getSrvyId());
        	                        trgtVO.setRgtrId(vo.getRgtrId());
        	                        srvyTrgtDAO.srvyTrgtRegist(trgtVO);	// 설문대상등록
        	                    }
        					}
        				}
        				// 등록 과목아이디 목록 삭제
        				lrnGrpIds.removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
        			}
                }
            }
		}

		vo.setSrvyId(StringUtil.nvl(bfrSrvy.get("srvyId")));

		return vo;
	}

	/**
     * 설문성적반영비율수정
     *
     * @param sbjctId		과목개설아이디
     * @param mdfrId		수정자아이디
     * @throws Exception
     */
    @Override
    public void srvyMrkRfltrtModify(SrvyVO vo) throws Exception {
    	List<SrvyVO> srvyList = srvyDAO.mrkRfltSrvyList(vo);	// 성적반영 설문 목록 조회
        if(srvyList.size() > 0) {
            int totalMrk = 100;
            int mrkRfltrt = (int) (totalMrk / srvyList.size());
            for(int i = 0; i < srvyList.size(); i++) {
                if(i == srvyList.size() - 1) {
                    mrkRfltrt = totalMrk;
                }
                totalMrk -= mrkRfltrt;
                SrvyVO srvyVO = srvyList.get(i);
                srvyVO.setMrkRfltrt(mrkRfltrt);
                srvyVO.setMdfrId(vo.getMdfrId());
            }
            srvyDAO.srvyMrkRfltrtListModify(srvyList);
        }
    }

    /**
	 * 과목성적공개설문수조회
	 *
	 * @param sbjctId	과목아이디
	 * @throws Exception
	 */
	@Override
	public Integer sbjctMrkOynSrvyCntSelect(SrvyVO vo) throws Exception {
		return srvyDAO.sbjctMrkOynSrvyCntSelect(vo.getSbjctId(), null);
	}

	/**
     * 설문세부정보수정
     *
     * @param SrvyVO	설문정보
     * @throws Exception
     */
	@Override
	public void srvyDtlModify(SrvyVO vo) throws Exception {
		srvyDAO.srvyModify(vo);
	}

	/**
	 * 설문성적반영비율목록수정
	 *
	 * @param List<SrvyVO>
	 * @throws Exception
	 */
	@Override
	public void srvyMrkRfltrtListModify(List<SrvyVO> list) throws Exception {
		srvyDAO.srvyMrkRfltrtListModify(list);
	}

	/**
	* 설문그룹과목목록조회
	*
	* @param srvyId 	설문아이디
	* @return 과목 목록
	* @throws Exception
	*/
	@Override
	public List<EgovMap> srvyGrpSbjctList(String srvyId) throws Exception {
		return srvyDAO.srvyGrpSbjctList(srvyId);
	}

	/**
	* 설문조회
	*
	* @param SrvyVO
	* @return 설문정보
	* @throws Exception
	*/
	@Override
	public EgovMap srvySelect(SrvyVO vo) throws Exception {
		return srvyDAO.srvySelect(vo);
	}

	/**
	* 설문학습그룹부과제목록조회
	*
	* @param lrnGrpId 	학습그룹아이디
	* @param srvyId 	설문아이디
	* @return 설문부과제목록
	* @throws Exception
	*/
	@Override
	public List<EgovMap> srvyLrnGrpSubAsmtList(Map<String, Object> params) throws Exception {
		return srvyDAO.srvyLrnGrpSubAsmtList(params);
	}

	/**
	* 교수권한과목설문목록조회
	*
	* @param userId 		교수아이디
	* @param smstrChrtId 	학기기수아이디
	* @param sbjctId 		과목아이디
	* @param searchValue 	검색내용(설문명)
	* @return 설문목록
	* @throws Exception
	*/
	@Override
	public List<EgovMap> profAuthrtSbjctSrvyList(Map<String, Object> params) throws Exception {
	    return srvyDAO.profAuthrtSbjctSrvyList(params);
	}

	/**
     * 설문삭제
     *
     * @param srvyId		설문아이디
     * @param mdfrId		수정자아이디
     * @throws Exception
     */
	@Override
	public void srvyDelete(SrvyVO vo) throws Exception {
		// 1. 설문삭제여부수정
		srvyDAO.srvyModify(vo);

		// 2. 하위설문삭제여부수정
		srvyDAO.subSrvyDelynModify(vo);
	}

	/**
	* 설문팀목록조회
	*
	* @param srvyId 	설문아이디
	* @return 설문팀목록
	* @throws Exception
	*/
	@Override
	public List<EgovMap> srvyTeamList(String srvyId) throws Exception {
		return srvyDAO.srvyTeamList(srvyId);
	}

	/**
	* 설문팀문제출제완료여부조회
	*
	* @param srvyId 	설문아이디
	* @throws Exception
	*/
	@Override
	public Boolean srvyTeamQstnsCmptnynSelect(String srvyId) throws Exception {
		return srvyDAO.srvyTeamQstnsCmptnynSelect(srvyId);
	}

	/**
	* 문제가져오기설문목록조회
	*
    * @param sbjctId 		과목이이디
	* @return 설문목록
	* @throws Exception
	*/
	@Override
	public List<SrvyVO> qstnCopySrvyList(String sbjctId) throws Exception {
		return srvyDAO.qstnCopySrvyList(sbjctId);
	}

	/**
     * 설문문제출제완료수정
     *
     * @param upSrvyId   	상위설문아이디
     * @param srvyId   		설문아이디
     * @param srvyGbncd   	설문팀구분코드 ( SRVY_TEAM, SRVY )
     * @param searchGubun 	수정상태 ( save, edit )
     * @param searchKey 	( bsc, dtl )
     * @throws Exception
     */
	@Override
	public void srvyQstnsCmptnModify(SrvyVO vo) throws Exception {
		vo.setSrvyQstnsCmptnyn("edit".equals(StringUtil.nvl(vo.getSearchGubun())) ? "M" : "Y");
		String upSrvyId = vo.getUpSrvyId();
		String srvyGbn = vo.getSrvyGbncd();
		vo.setUpSrvyId("");
		vo.setSrvyGbncd("");

    	// 팀설문 and 상위설문시
    	if("SRVY_TEAM".equals(srvyGbn) && "bsc".equals(vo.getSearchKey())) {
    		vo.setSrvyId(upSrvyId);
    	}

    	// 설문수정
    	srvyDAO.srvyModify(vo);
	}

}
