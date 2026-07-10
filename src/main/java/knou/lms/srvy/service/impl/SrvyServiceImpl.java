package knou.lms.srvy.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.exam.dao.ExamDAO;
import knou.lms.srvy.dao.SrvyDAO;
import knou.lms.srvy.dao.SrvyGrpDAO;
import knou.lms.srvy.dao.SrvyQstnDAO;
import knou.lms.srvy.dao.SrvyQstnVwitmLvlDAO;
import knou.lms.srvy.dao.SrvyTrgtDAO;
import knou.lms.srvy.dao.SrvyVwitmDAO;
import knou.lms.srvy.dao.SrvypprDAO;
import knou.lms.srvy.service.SrvyService;
import knou.lms.srvy.vo.SrvyGrpVO;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyQstnVwitmLvlVO;
import knou.lms.srvy.vo.SrvyTrgtVO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.vo.SrvyVwitmVO;
import knou.lms.srvy.vo.SrvypprVO;
import knou.lms.srvy.web.view.SrvyPageInfo;
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

	@Resource(name="srvypprDAO")
	private SrvypprDAO srvypprDAO;

	@Resource(name="srvyQstnDAO")
	private SrvyQstnDAO srvyQstnDAO;

	@Resource(name="srvyVwitmDAO")
	private SrvyVwitmDAO srvyVwitmDAO;

	@Resource(name="srvyQstnVwitmLvlDAO")
	private SrvyQstnVwitmLvlDAO srvyQstnVwitmLvlDAO;

	@Resource(name="examDAO")
	private ExamDAO examDAO;

    @Override
    public List<EgovMap> admAllSrvyList(int limitTop) {
        return srvyDAO.admAllSrvyList(limitTop);
    }

    /**
     * 교수설문목록조회
     *
     * @param sbjctId	 	과목아이디
     * @param searchValue  	검색내용(설문명)
     * @return 설문목록 페이징
     */
	@Override
	public ResultDTO<EgovMap> profSrvyListPaging(SrvyPageInfo pageInfo) {
		ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(srvyDAO.profSrvyListPaging(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
     * 설문등록
     *
     * @param SrvyVO				설문정보
     * @param Map<String, String>	부가정보
     */
	@Override
	public SrvyVO srvyRegist(SrvyVO vo, Map<String, String> subMap) {
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> subSrvys = new ArrayList<Map<String,Object>>();
		try {
			subSrvys = mapper.readValue(subMap.get("subSrvysStr"), new TypeReference<List<Map<String, Object>>>() {});		// 팀그룹부과제정보
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		List<String> sbjctIds = new ArrayList<>(Arrays.asList(subMap.get("sbjctIds").split(",")));							// 분반과목아이디목록
		List<String> teamGrpIds = new ArrayList<>(Arrays.asList(subMap.get("teamGrpIds").split(",")));						// 팀그룹아이디:과목아이디목록
		List<String> byteamSubsrvyUseyns = Arrays.asList(subMap.get("byteamSubsrvyUseyns").split(","));						// 팀별부설문사용여부:과목아이디목록

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
			// 팀설문등록
			teamSrvyRegist(subSrvys, teamGrpIds, vo, vo.getSbjctId(), mapper);
			// 등록 과목아이디 목록 삭제
			teamGrpIds.removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
		} else {
			// 이전 설문 가져오기 문항 복사
			if(!"".equals(vo.getSearchValue())) {
				srvyQstnCopy(vo);
			}
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

                String lctrWknoSchdlId = examDAO.otherSbjctLctrWknoSelect(sbjctId, vo.getLctrWknoSchdlId());
                vo.setLctrWknoSchdlId(lctrWknoSchdlId);
                srvyDAO.srvyRegist(vo);

                // 팀 설문
                if("Y".equals(subMap.get("srvyTeamyn"))) {
                	// 팀설문등록
                	teamSrvyRegist(subSrvys, teamGrpIds, vo, sbjctId, mapper);
                } else {
                	// 이전 설문 가져오기 문항 복사
        			if(!"".equals(vo.getSearchValue())) {
        				srvyQstnCopy(vo);
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
     */
	@Override
	public SrvyVO srvyModify(SrvyVO vo, Map<String, String> subMap) {
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> subSrvys = new ArrayList<Map<String,Object>>();
		try {
			subSrvys = mapper.readValue(subMap.get("subSrvysStr"), new TypeReference<List<Map<String, Object>>>() {});							// 팀그룹부과제정보
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		List<String> sbjctIds = new ArrayList<>(Arrays.asList(subMap.get("sbjctIds").split(",")));												// 분반과목아이디목록
		List<String> teamGrpIds = new ArrayList<>(Arrays.asList(subMap.get("teamGrpIds").split(",")));											// 팀그룹아이디:과목아이디목록
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
				// 팀설문수정
				teamSrvyModify(subSrvys, teamGrpIds, vo, bfrSrvy, mapper);
				// 등록 과목아이디 목록 삭제
				teamGrpIds.removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
			// 신규 일반 설문
			} else {
				srvyQstnDelete(vo);								// 기존 설문 문항 삭제
				srvyTrgtDAO.srvyTrgtrDelete(vo.getSrvyId());	// 기존 설문대상 삭제
            	srvyDAO.subSrvyDelete(vo.getSrvyId());			// 기존 팀설문 삭제
			}
		// 기존 일반 설문
		} else {
			// 신규 팀 설문
			if("Y".equals(subMap.get("srvyTeamyn"))) {
				// 기존 설문 문항 삭제
				srvyQstnDelete(vo);
				// 팀설문등록
            	teamSrvyRegist(subSrvys, teamGrpIds, vo, vo.getSbjctId(), mapper);
				// 등록 과목아이디 목록 삭제
				teamGrpIds.removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
			} else {
				// 이전 설문 가져오기 문항 복사
				if(!"".equals(vo.getSearchValue())) {
					srvyQstnCopy(vo);
				}
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
                String lctrWknoSchdlId = examDAO.otherSbjctLctrWknoSelect(sbjctId, vo.getLctrWknoSchdlId());
                vo.setLctrWknoSchdlId(lctrWknoSchdlId);
                srvyDAO.srvyModify(vo);	// 설문 수정

                // 기존 팀 설문
                if("SRVY_TEAM".equals(StringUtil.nvl(dvclasBfrSrvy.get("srvyGbn")))) {
        			// 신규 팀 설문
        			if("Y".equals(subMap.get("srvyTeamyn"))) {
        				// 팀설문수정
        				teamSrvyModify(subSrvys, teamGrpIds, vo, bfrSrvy, mapper);
        				// 등록 과목아이디 목록 삭제
        				teamGrpIds.removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
        			// 신규 일반 설문
        			} else {
        				srvyQstnDelete(vo);								// 기존 설문 문항 삭제
        				srvyTrgtDAO.srvyTrgtrDelete(vo.getSrvyId());	// 기존 설문대상 삭제
                    	srvyDAO.subSrvyDelete(vo.getSrvyId());			// 기존 팀설문 삭제
        			}
        		// 기존 일반 설문
                } else {
                	// 신규 팀 설문
        			if("Y".equals(subMap.get("srvyTeamyn"))) {
        				// 기존 설문 문항 삭제
        				srvyQstnDelete(vo);
        				// 팀설문등록
                    	teamSrvyRegist(subSrvys, teamGrpIds, vo, vo.getSbjctId(), mapper);
        				// 등록 과목아이디 목록 삭제
        				teamGrpIds.removeIf(item -> item.split(":")[1].equals(vo.getSbjctId()));
        			} else {
        				// 이전 설문 가져오기 문항 복사
        				if(!"".equals(vo.getSearchValue())) {
        					srvyQstnCopy(vo);
        				}
        			}
                }
            }
		}

		vo.setSrvyId(StringUtil.nvl(bfrSrvy.get("srvyId")));

		return vo;
	}

	// 팀설문등록
	private void teamSrvyRegist(List<Map<String, Object>> subSrvys, List<String> teamGrpIds, SrvyVO vo, String sbjctId, ObjectMapper mapper) {
		Map<Object, Map<String, Object>> idMap = subSrvys.stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
		for(String teamGrp : teamGrpIds) {
			if(teamGrp.split(":")[1].equals(sbjctId)) {
				TeamVO teamVO = new TeamVO();
                teamVO.setTeamCtgrCd(teamGrp.split(":")[0]);
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

                    // 이전 설문 가져오기 문항 복사
            		if(!"".equals(subSrvyVO.getSearchValue())) {
            			srvyQstnCopy(subSrvyVO);
            		}
                }
			}
		}
	}

	// 팀설문수정
	private void teamSrvyModify(List<Map<String, Object>> subSrvys, List<String> teamGrpIds, SrvyVO vo, EgovMap bfrSrvy, ObjectMapper mapper) {
		Map<Object, Map<String, Object>> idMap = subSrvys.stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
		for(String teamGrp : teamGrpIds) {
            if(teamGrp.split(":")[1].equals(vo.getSbjctId())) {
            	String teamGrpId = teamGrp.split(":")[0];						// 신규 팀그룹아이디
                String bfrTeamGrpId = StringUtil.nvl(bfrSrvy.get("teamGrpId"));	// 기존 팀그룹아이디

                TeamVO teamVO = new TeamVO();
            	teamVO.setTeamCtgrCd(teamGrp.split(":")[0]);
            	List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀 목록 조회

                // 팀그룹 불일치시
                if(!teamGrpId.equals(bfrTeamGrpId)) {
                	srvyQstnDelete(vo);								// 기존 설문 문항 삭제
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

                		// 이전 설문 가져오기 문항 복사
                		if(!"".equals(subSrvyVO.getSearchValue())) {
                			srvyQstnCopy(subSrvyVO);
                		}
                	}
                // 팀그룹 일치시
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

                		// 이전 설문 가져오기 문항 복사
                		if(!"".equals(subSrvyVO.getSearchValue())) {
                			srvyQstnCopy(subSrvyVO);
                		}
                	}
                }
            }
        }
	}

	/**
     * 설문성적반영비율수정
     *
     * @param sbjctId		과목개설아이디
     * @param mdfrId		수정자아이디
     */
    @Override
    public void srvyMrkRfltrtModify(SrvyVO vo) {
    	List<SrvyVO> srvyList = srvyDAO.mrkRfltSrvyList(vo);	// 성적반영 설문 목록 조회
        if(srvyList.size() > 0) {
        	BigDecimal totalMrk = new BigDecimal("100");
            BigDecimal mrkRfltrt = totalMrk.divide(BigDecimal.valueOf(srvyList.size()), 2, RoundingMode.FLOOR);
            for(int i = 0; i < srvyList.size(); i++) {
                if(i == srvyList.size() - 1) {
                    mrkRfltrt = totalMrk;
                }
                totalMrk = totalMrk.subtract(mrkRfltrt);
                SrvyVO smnrVO = srvyList.get(i);
                smnrVO.setMrkRfltrt(mrkRfltrt);
                smnrVO.setMdfrId(vo.getMdfrId());
            }
            srvyDAO.srvyMrkRfltrtListModify(srvyList);
        }
    }

    /**
	 * 과목성적공개설문수조회
	 *
	 * @param sbjctId	과목아이디
	 */
	@Override
	public Integer sbjctMrkOynSrvyCntSelect(SrvyVO vo) {
		return srvyDAO.sbjctMrkOynSrvyCntSelect(vo.getSbjctId(), null);
	}

	/**
     * 설문세부정보수정
     *
     * @param SrvyVO	설문정보
     */
	@Override
	public void srvyDtlModify(SrvyVO vo) {
		srvyDAO.srvyModify(vo);
	}

	/**
	 * 설문성적반영비율목록수정
	 *
	 * @param List<SrvyVO>
	 */
	@Override
	public void srvyMrkRfltrtListModify(List<SrvyVO> list) {
		srvyDAO.srvyMrkRfltrtListModify(list);
	}

	/**
	* 설문그룹과목목록조회
	*
	* @param srvyId 	설문아이디
	* @return 과목 목록
	*/
	@Override
	public List<EgovMap> srvyGrpSbjctList(String srvyId) {
		return srvyDAO.srvyGrpSbjctList(srvyId);
	}

	/**
	* 설문조회
	*
	* @param SrvyVO
	* @return 설문정보
	*/
	@Override
	public EgovMap srvySelect(SrvyVO vo) {
		return srvyDAO.srvySelect(vo);
	}

	/**
	* 설문팀그룹부설문목록조회
	*
	* @param teamGrpId 	팀그룹아이디
	* @param srvyId 	설문아이디
	* @return 설문부설문목록
	*/
	@Override
	public List<EgovMap> srvyTeamGrpSubSrvyList(Map<String, Object> params) {
		return srvyDAO.srvyTeamGrpSubSrvyList(params);
	}

	/**
	* 교수권한과목설문목록조회
	*
	* @param userId 		교수아이디
	* @param smstrChrtId 	학기기수아이디
	* @param sbjctId 		과목아이디
	* @param searchValue 	검색내용(설문명)
	* @return 설문목록
	*/
	@Override
	public List<EgovMap> profAuthrtSbjctSrvyList(SrvyVO vo) {
	    return srvyDAO.profAuthrtSbjctSrvyList(vo);
	}

	/**
     * 설문삭제
     *
     * @param srvyId		설문아이디
     * @param mdfrId		수정자아이디
     */
	@Override
	public void srvyDelete(SrvyVO vo) {
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
	*/
	@Override
	public List<EgovMap> srvyTeamList(String srvyId) {
		return srvyDAO.srvyTeamList(srvyId);
	}

	/**
	* 설문팀문제출제완료여부조회
	*
	* @param srvyId 	설문아이디
	*/
	@Override
	public Boolean srvyTeamQstnsCmptnynSelect(String srvyId) {
		return srvyDAO.srvyTeamQstnsCmptnynSelect(srvyId);
	}

	/**
	* 문제가져오기설문목록조회
	*
    * @param sbjctId 		과목이이디
	* @return 설문목록
	*/
	@Override
	public List<SrvyVO> qstnCopySrvyList(String sbjctId) {
		return srvyDAO.qstnCopySrvyList(sbjctId);
	}

	/**
     * 설문문제출제완료수정
     *
     * @param upSrvyId   	상위설문아이디
     * @param srvyId   		설문아이디
     * @param srvyGbncd   	설문구분코드 ( SRVY_TEAM, SRVY )
     * @param searchGubun 	수정상태 ( save, edit )
     * @param searchKey 	( bsc, dtl )
     */
	@Override
	public void srvyQstnsCmptnModify(SrvyVO vo) {
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

	@Override
	public List<EgovMap> bySubjectSrvyList(SrvyVO vo) {
		return srvyDAO.bySubjectSrvyList(vo);
	}

	/**
     * 학생설문목록조회
     *
     * @param sbjctId	 	과목아이디
     * @param searchValue  	검색내용(설문명)
     * @return 학생설문목록페이징
     */
	@Override
	public ResultDTO<EgovMap> stdntSrvyListPaging(SrvyPageInfo pageInfo) {
        ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(srvyDAO.stdntSrvyListPaging(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
	* 학생설문조회
	*
    * @param sbjctId 	과목아이디
    * @param srvyId 	설문아이디
    * @param upSrvyId 	상위설문아이디
    * @param userId 	사용자아이디
	* @return 설문정보
	*/
	@Override
	public EgovMap stdntSrvySelect(SrvyVO vo) {
		return srvyDAO.stdntSrvySelect(vo);
	}

	/**
	* 관리자설문강의평가목록페이징
	*
	* @param dgrsYr			학위연도
    * @param smstrChrtId	학기기수아이디
    * @param orgId     		기관아이디
	* @param searchValue 	검색내용(제목)
	* @param listScale	 	페이지크기
	* @return 설문강의평가목록 페이징
	*/
	@Override
	public ResultDTO<EgovMap> admSrvyLctrEvlListPaging(SrvyPageInfo pageInfo) {
        ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(srvyDAO.admSrvyLctrEvlListPaging(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
	* 설문강의평가미등록과목목록
	*
	* @param orgId 			기관아이디
	* @param smstrChrtId 	학기기수아이디
	* @param srvyTycd 		설문유형코드
	* @return 강의평가미등록과목 목록
	*/
	@Override
	public List<EgovMap> srvyLctrEvlNRegistSbjctList(Map<String, Object> params) {
		return srvyDAO.srvyLctrEvlNRegistSbjctList(params);
	}

	/**
     * 설문강의평가등록
     *
     * @param SrvyVO 		설문정보
     * @param sbjctIds 		과목아이디목록
     * @return SrvyVO
     */
	@Override
	public SrvyVO srvyLctrEvlRegist(SrvyVO vo, Map<String, String> subMap) {
		ObjectMapper mapper = new ObjectMapper();
		List<String> sbjctIds = new ArrayList<>(Arrays.asList(subMap.get("sbjctIds").split(",")));	// 과목아이디목록

		// 일괄등록용 목록
    	List<SrvyVO> srvyList = new ArrayList<SrvyVO>();	// 설문목록

		vo.setSrvyId(IdGenUtil.genNewId(IdPrefixType.SRVY));
		srvyList.add(vo);

		for(String sbjctId : sbjctIds) {
			SrvyVO copySrvy = mapper.convertValue(vo, SrvyVO.class);
			copySrvy.setUpSrvyId(vo.getSrvyId());
			copySrvy.setSrvyId(IdGenUtil.genNewId(IdPrefixType.SRVY));
			copySrvy.setSbjctId(sbjctId);
			srvyList.add(copySrvy);
		}

		if(srvyList.size() > 0) srvyDAO.srvyBulkRegist(srvyList); 	// 설문일괄등록

		// 이전 강의평가 가져오기 문항 복사
		if(!"".equals(vo.getSearchValue())) {
			srvyQstnCopy(vo);
		}

		return vo;
	}

	/**
     * 설문강의평가수정
     *
     * @param SrvyVO 		설문정보
     * @param sbjctIds 		과목아이디목록
     * @return SrvyVO
     */
	@Override
	public SrvyVO srvyLctrEvlModify(SrvyVO vo, Map<String, String> subMap) {
		ObjectMapper mapper = new ObjectMapper();
		List<String> sbjctIds = new ArrayList<>(Arrays.asList(subMap.get("sbjctIds").split(",")));	// 과목아이디목록

		// 설문수정
		srvyDAO.srvyModify(vo);

		// 하위설문삭제
		srvyDAO.subSrvyDelete(vo.getSrvyId());

		// 일괄등록용 목록
    	List<SrvyVO> srvyList = new ArrayList<SrvyVO>();	// 설문목록
    	for(String sbjctId : sbjctIds) {
			SrvyVO copySrvy = mapper.convertValue(vo, SrvyVO.class);
			copySrvy.setUpSrvyId(vo.getSrvyId());
			copySrvy.setSrvyId(IdGenUtil.genNewId(IdPrefixType.SRVY));
			copySrvy.setSbjctId(sbjctId);
			srvyList.add(copySrvy);
		}

    	if(srvyList.size() > 0) srvyDAO.srvyBulkRegist(srvyList); 	// 설문일괄등록

		// 이전 강의평가 가져오기 문항 복사
		if(!"".equals(vo.getSearchValue())) {
			srvyQstnCopy(vo);
		}

		return vo;
	}

	/**
	* 설문강의평가조회
	*
	* @param srvyId	 	설문아이디
	* @return 설문강의평가정보
	*/
	@Override
	public EgovMap srvyLctrEvlSelect(SrvyVO vo) {
		return srvyDAO.srvyLctrEvlSelect(vo);
	}

	/**
     * 설문강의평가등록과목목록
     *
     * @param srvyId	 설문아이디
     * @return 설문강의평가등록과목목록
     */
	@Override
	public List<EgovMap> srvyLctrEvlRegistSbjctList(SrvyVO vo) {
		return srvyDAO.srvyLctrEvlRegistSbjctList(vo);
	}

	/**
     * 가져오기설문강의평가목록
     *
     * @param orgId 		기관아이디
	 * @param smstrChrtId 	학기기수아이디
	 * @param srvyTrgtGbncd 설문대상구분코드
	 * @param searchValue 	검색어 ( 강의평가제목 )
     * @return 가져오기설문강의평가목록
     */
	@Override
	public List<EgovMap> copySrvyLctrEvlList(Map<String, Object> params) {
		return srvyDAO.copySrvyLctrEvlList(params);
	}

	// 설문문항삭제
	private void srvyQstnDelete(SrvyVO vo) {
		srvyQstnVwitmLvlDAO.srvyQstnListVwitmLvlAllDelete(vo);	// 설문문항목록보기항목레벨전체삭제
		srvyVwitmDAO.srvyQstnListVwitmAllDelete(vo);			// 설문문항목록보기항목전체삭제
		srvyQstnDAO.srvyQstnAllDelete(vo);						// 설문문항전체삭제
		srvypprDAO.srvypprAllDelete(vo);						// 설문지전체삭제
	}

	// 설문문항복사
	private void srvyQstnCopy(SrvyVO vo) {
		srvyQstnDelete(vo);	// 설문문항삭제

		List<SrvypprVO> pprList = srvypprDAO.srvypprList(vo.getSearchValue(), "");	// 설문지목록
		List<SrvyQstnVO> qstnList = new ArrayList<SrvyQstnVO>();					// 설문문항목록
		List<SrvyVwitmVO> vwitmList = new ArrayList<SrvyVwitmVO>();					// 설문보기항목목록
		List<SrvyQstnVwitmLvlVO> lvlList = new ArrayList<SrvyQstnVwitmLvlVO>();		// 설문문항보기항목목록

		AtomicInteger srvySeqno = new AtomicInteger(1);	// 설문지순번

		// 설문지목록
		for(SrvypprVO ppr : pprList) {
			String newSrvypprId = IdGenUtil.genNewId(IdPrefixType.SRPPR);
			String oldSrvypprId = ppr.getSrvypprId();

			AtomicInteger qstnSeqno = new AtomicInteger(1);	// 문항순번
			// 설문문항목록
			srvyQstnDAO.srvypprQstnList(oldSrvypprId).forEach(qstn -> {
				String newSrvyQstnId = IdGenUtil.genNewId(IdPrefixType.SRQN);
				String oldSrvyQstnId = qstn.getSrvyQstnId();

				AtomicInteger vwitmSeqno = new AtomicInteger(1);	// 보기항목순번
				// 설문보기항목목록
				srvyVwitmDAO.srvyVwitmList(oldSrvyQstnId).forEach(vwitm -> {
					vwitm.setSrvyVwitmId(IdGenUtil.genNewId(IdPrefixType.SRVW));
					vwitm.setSrvyQstnId(newSrvyQstnId);
					vwitm.setRgtrId(vo.getRgtrId());
					vwitm.setVwitmSeqno(vwitmSeqno.getAndIncrement());
					vwitmList.add(vwitm);
				});

				AtomicInteger lvlSeqno = new AtomicInteger(1);	// 레벨순번
				// 설문문항보기항목목록
				srvyQstnVwitmLvlDAO.srvyQstnVwitmLvlList(oldSrvyQstnId).forEach(lvl -> {
					lvl.setSrvyQstnVwitmLvlId(IdGenUtil.genNewId(IdPrefixType.SRQVL));
					lvl.setSrvyQstnId(newSrvyQstnId);
					lvl.setRgtrId(vo.getRgtrId());
					lvl.setLvlSeqno(lvlSeqno.getAndIncrement());
					lvlList.add(lvl);
				});

				qstn.setSrvyQstnId(newSrvyQstnId);
				qstn.setSrvypprId(newSrvypprId);
				qstn.setRgtrId(vo.getRgtrId());
				qstn.setQstnSeqno(qstnSeqno.getAndIncrement());
				qstnList.add(qstn);
			});

			ppr.setSrvypprId(newSrvypprId);
			ppr.setSrvyId(vo.getSrvyId());
			ppr.setRgtrId(vo.getRgtrId());
			ppr.setSrvySeqno(srvySeqno.getAndIncrement());
		}

		// 설문지일괄등록
		if(pprList.size() > 0) srvypprDAO.srvypprBulkRegist(pprList);
		if(qstnList.size() > 0) srvyQstnDAO.srvyQstnBulkRegist(qstnList);
		if(vwitmList.size() > 0) srvyVwitmDAO.srvyVwitmBulkRegist(vwitmList);
		if(lvlList.size() > 0) srvyQstnVwitmLvlDAO.srvyQstnVwitmLvlBulkRegist(lvlList);
	}

	/**
	* 관리자설문강의평가결과목록페이징
	*
    * @param srvyId			설문아이디
    * @param orgId  		기관아이디
    * @param smstrChrtId	학기기수아이디
    * @param sbjctId		과목아이디
    * @param srvyPtcp		참여여부
    * @param searchValue	검색어 ( 이름, 학번 )
	* @return 설문강의평가결과목록 페이징
	*/
	@Override
	public ResultDTO<EgovMap> admSrvyLctrEvlRsltList(SrvyPageInfo pageInfo) {
        ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(srvyDAO.admSrvyLctrEvlRsltListPaging(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
	* 관리자전체설문목록페이징
	*
	* @param dgrsYr			학위연도
    * @param smstrChrtId	학기기수아이디
    * @param orgId     		기관아이디
	* @param searchValue 	검색내용(제목)
	* @param listScale	 	페이지크기
	* @return 전체설문목록 페이징
	*/
	@Override
	public ResultDTO<EgovMap> admSrvyListPaging(SrvyPageInfo pageInfo) {
        ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(srvyDAO.admSrvyListPaging(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
	* 관리자전체설문조회
	*
    * @param srvyId		설문아이디
	* @return 전체설문정보
	*/
	@Override
	public EgovMap admSrvySelect(SrvyVO vo) {
		return srvyDAO.admSrvySelect(vo);
	}

	/**
     * 관리자전체설문등록
     *
     * @param SrvyVO 		설문정보
     * @return SrvyVO
     */
	@Override
	public SrvyVO admSrvyRegist(SrvyVO vo) {
		vo.setSrvyId(IdGenUtil.genNewId(IdPrefixType.SRVY));

		// 설문등록
		srvyDAO.srvyRegist(vo);

		// 설문대상등록
		SrvyTrgtVO trgtVO = new SrvyTrgtVO();
		trgtVO.setSrvyTrgtrId(IdGenUtil.genNewId(IdPrefixType.SRTGT));
		trgtVO.setSrvyId(vo.getSrvyId());
		trgtVO.setSrvyTrgtTycd(vo.getSearchKey());
		trgtVO.setRgtrId(vo.getRgtrId());
		srvyTrgtDAO.srvyTrgtRegist(trgtVO);

		// 이전 전체설문 가져오기 문항 복사
		if(!"".equals(vo.getSearchValue())) {
			srvyQstnCopy(vo);
		}

		return vo;
	}

	@Override
	public SrvyVO admSrvyModify(SrvyVO vo) {
		// 설문수정
		srvyDAO.srvyModify(vo);

		// 설문대상유형코드수정
		SrvyTrgtVO trgtVO = new SrvyTrgtVO();
		trgtVO.setSrvyId(vo.getSrvyId());
		trgtVO.setSrvyTrgtTycd(vo.getSearchKey());
		trgtVO.setMdfrId(vo.getMdfrId());
		srvyTrgtDAO.srvyTrgtTycdModify(trgtVO);

		// 이전 전체설문 가져오기 문항 복사
		if(!"".equals(vo.getSearchValue())) {
			srvyQstnCopy(vo);
		}

		return vo;
	}

	/**
     * 가져오기전체설문목록
     *
     * @param orgId 		기관아이디
     * @param dgrsYr	 	학위연도
	 * @param smstrChrtId 	학기기수아이디
	 * @param srvyTrgtTycd 	설문대상유형코드
	 * @param searchValue 	검색어 ( 전체설문제목 )
     * @return 가져오기전체설문목록
     */
	@Override
	public List<EgovMap> copySrvyList(Map<String, Object> params) {
		return srvyDAO.copySrvyList(params);
	}

	/**
	* 관리자전체설문결과목록페이징
	*
    * @param srvyId			설문아이디
    * @param orgId  		기관아이디
    * @param smstrChrtId	학기기수아이디
    * @param srvyTrgtTycd	설문대상유형코드
    * @param srvyPtcp		참여여부
    * @param searchValue	검색어 ( 이름, 학번 )
	* @return 전체설문결과목록 페이징
	*/
	@Override
	public ResultDTO<EgovMap> admSrvyRsltList(SrvyPageInfo pageInfo) {
        ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(srvyDAO.admSrvyRsltListPaging(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
	* 학생대시보드설문강의평가목록조회
	*
    * @param dgrsYr			학위연도
    * @param orgId			기관아이디
    * @param smstrChrtId	학기기수아이디
    * @param sbjctId		과목아이디
	* @return 설문강의평가목록
	*/
	@Override
	public List<EgovMap> stdntMainSrvyLctrEvlList(Map<String, Object> params) {
		return srvyDAO.stdntMainSrvyLctrEvlList(params);
	}

	/**
	* 학생설문강의평가조회
	*
    * @param srvyId			설문아이디
    * @param upSrvyId		상위설문아이디
    * @param userId			사용자아이디
	* @return 학생설문강의평가
	*/
	@Override
	public EgovMap stdntSrvyLctrEvlSelect(SrvyVO vo) {
		return srvyDAO.stdntSrvyLctrEvlSelect(vo);
	}

	/**
	* 대상전체설문목록페이징
	*
	* @param dgrsYr			학위연도
    * @param smstrChrtId	학기기수아이디
    * @param orgId     		기관아이디
	* @param searchValue 	검색내용(제목)
	* @param searchText   	사용자유형코드
	* @param listScale	 	페이지크기
	* @return 전체설문목록 페이징
	*/
	@Override
	public ResultDTO<EgovMap> trgtWholSrvyListPaging(SrvyPageInfo pageInfo) {
		ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(srvyDAO.trgtWholSrvyListPaging(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
	* 대상전체설문조회
	*
	* @param srvyId		설문아이디
	* @param userId		사용자아이디
	* @return 대상전체설문
	*/
	@Override
	public EgovMap trgtWholSrvySelect(SrvyVO vo) {
		return srvyDAO.trgtWholSrvySelect(vo);
	}

	/**
	* 학생설문강의평가목록페이징
	*
    * @param sbjctId   		과목아이디
	* @param searchValue 	검색내용(제목)
	* @param listScale	 	페이지크기
	* @return 학생설문강의평가목록 페이징
	*/
	@Override
	public ResultDTO<EgovMap> stdntSrvyLctrEvlListPaging(SrvyPageInfo pageInfo) {
		ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(srvyDAO.stdntSrvyLctrEvlListPaging(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
     * 설문강의평가과목참여목록
     *
     * @param srvyId	 설문아이디
     * @param userId	 사용자아이디
     * @return 설문강의평가과목참여목록
     */
	@Override
	public List<EgovMap> srvyLctrEvlSbjctPtcpList(SrvyVO vo) {
		return srvyDAO.srvyLctrEvlSbjctPtcpList(vo);
	}

}