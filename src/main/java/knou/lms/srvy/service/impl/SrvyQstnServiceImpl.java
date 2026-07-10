package knou.lms.srvy.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.srvy.dao.SrvyQstnDAO;
import knou.lms.srvy.dao.SrvyQstnVwitmLvlDAO;
import knou.lms.srvy.dao.SrvyVwitmDAO;
import knou.lms.srvy.dao.SrvypprDAO;
import knou.lms.srvy.service.SrvyQstnService;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyQstnVwitmLvlVO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.vo.SrvyVwitmVO;
import knou.lms.srvy.vo.SrvypprVO;

@Service("srvyQstnService")
public class SrvyQstnServiceImpl extends ServiceBase implements SrvyQstnService {

	@Resource(name="srvyQstnDAO")
	private SrvyQstnDAO srvyQstnDAO;

	@Resource(name="srvypprDAO")
	private SrvypprDAO srvypprDAO;

	@Resource(name="srvyVwitmDAO")
	private SrvyVwitmDAO srvyVwitmDAO;

	@Resource(name="srvyQstnVwitmLvlDAO")
	private SrvyQstnVwitmLvlDAO srvyQstnVwitmLvlDAO;

	@Resource(name="attachFileService")
	private AttachFileService attachFileService;

	@Resource(name="cmmnCdService")
	private CmmnCdService cmmnCdService;

	/**
	 * 설문문항목록조회
	 *
	 * @param srvyId		설문아이디
	 * @param searchType	조회유형
	 * @return 설문문항목록
	 */
	@Override
	public List<EgovMap> srvyQstnList(String srvyId, String searchType) {
		return srvyQstnDAO.srvyQstnList(srvyId, searchType);
	}

	/**
	 * 설문지문항목록조회
	 *
	 * @param srvypprId		설문지아이디
	 * @return 설문지문항목록
	 */
	@Override
	public List<SrvyQstnVO> srvypprQstnList(String srvypprId) {
		return srvyQstnDAO.srvypprQstnList(srvypprId);
	}

	/**
	 * 설문지문항삭제
	 *
	 * @param srvypprId		설문지아이디
	 */
	@Override
	public void srvypprQstnDelete(String srvypprId) {
		srvyQstnDAO.srvypprQstnDelete(srvypprId);
	}

	/**
	* 설문문항등록
	*
	* @param SrvyQstnVO
	*/
	@Override
	public SrvyQstnVO srvyQstnRegist(SrvyQstnVO vo) {
		vo.setSrvyQstnId(IdGenUtil.genNewId(IdPrefixType.SRQN));
		srvyQstnDAO.srvyQstnRegist(vo);
		return vo;
	}

	/**
	* 설문문항수정
	*
	* @param SrvyQstnVO
	*/
	@Override
	public void srvyQstnModify(SrvyQstnVO vo) {
		srvyQstnDAO.srvyQstnModify(vo);
	}

	/**
	* 설문문항삭제
	*
	* @param SrvyQstnVO
	*/
	@Override
	public void srvyQstnDelete(SrvyQstnVO vo) {
		// 설문문항삭제여부수정
		srvyQstnDAO.srvyQstnModify(vo);

		// 설문문항미삭제순번수정
		srvyQstnDAO.srvyQstnDelNSeqnoModify(vo);
	}

	/**
	 * 설문문항조회
	 *
	 * @param srvypprId		설문지아이디
	 * @param srvyQstnId	설문문항아이디
	 * @return 설문문항
	 */
	@Override
	public SrvyQstnVO srvyQstnSelect(SrvyQstnVO vo) {
		return srvyQstnDAO.srvyQstnSelect(vo);
	}

	/**
     * 문항순번수정
     *
     * @param srvypprId 	설문지아이디
     * @param qstnSeqno 	변경할 문항순번
     * @param searchKey 	문항순번
     */
	@Override
	public void qstnSeqnoModify(SrvyQstnVO vo) {
		srvyQstnDAO.qstnSeqnoModify(vo);
	}

	/**
     * 교수문항복사설문문항목록조회
     *
     * @param srvypprId 	설문지아이디
     * @return 설문문항목록
     */
	@Override
	public List<EgovMap> profQstnCopySrvyQstnList(SrvyQstnVO vo) {
		return srvyQstnDAO.profQstnCopySrvyQstnList(vo);
	}

	/**
	* 설문문항가져오기
	*
	* @param copySrvyQstnId	복사설문문항아이디
	* @param srvyId 		설문아이디
	*/
	@Override
	public void srvyQstnCopy(List<Map<String, Object>> list) {
		// 1. 설문지등록
		SrvypprVO srvyppr = new SrvypprVO();
		srvyppr.setSrvypprId(IdGenUtil.genNewId(IdPrefixType.SRPPR));
		srvyppr.setSrvyId((String) list.get(0).get("srvyId"));
		srvyppr.setSrvyTtl("문항가져오기용설문지");
		srvyppr.setSrvyCts("문항가져오기용설문지생성");
		srvyppr.setRgtrId((String) list.get(0).get("rgtrId"));
		srvypprDAO.srvypprRegist(srvyppr);

		// 2. 설문문항가져오기
		for(Map<String, Object> map : list) {
	 		map.put("srvyQstnId", IdGenUtil.genNewId(IdPrefixType.SRQN));
	 		map.put("srvypprId", srvyppr.getSrvypprId());
		}
	 	srvyQstnDAO.srvyQstnCopy(list);

	 	// 3. 설문보기항목가져오기
	 	srvyVwitmDAO.srvyVwitmCopy(list);

	 	// 4. 설문문항보기항목레벨가져오기
	 	srvyQstnVwitmLvlDAO.srvyQstnVwitmLvlCopy(list);
	}

	/**
	* 설문문항엑셀샘플데이터
	*
	* @param srvyId 	설문아이디
	* @param excelGrid 	엑셀그리드
	*/
	@Override
	public HashMap<String, Object> srvyQstnExcelSampleData(SrvyVO vo) {
		List<EgovMap> resultList = new ArrayList<EgovMap>();

		// 페이지1
		EgovMap p1 = page("1", "페이지1", "페이지1입니다.");

		// 페이지1 문항1 - 단일선택형
		EgovMap q = question(p1, "1", "ONE_CHC", "문항1", "문항1입니다", "Y", "Y", "Y");
		addChoice(q, "1", "문항1_보기1", "2", "N");
		resultList.add(q);
		resultList.add(choice("2", "문항1_보기2", "3",    "N"));
		resultList.add(choice("3", "문항1_보기3", "NEXT", "N"));
		resultList.add(choice("4", "문항1_보기4", "END",  "N"));
		resultList.add(choice("5", null,        "END",  "Y"));

		// 페이지1 문항2 - 다중선택형
		q = question(new EgovMap(), "2", "MLT_CHC", "문항2", "문항2입니다", "N", "N", "Y");
		addChoice(q, "1", "문항2_보기1", null, "N");
		resultList.add(q);
		resultList.add(choice("2", "문항2_보기2", null, "N"));
		resultList.add(choice("3", "문항2_보기3", null, "N"));
		resultList.add(choice("4", "문항2_보기4", null, "N"));
		resultList.add(choice("5", null,        null, "Y"));

		// 페이지1 문항3 - OX선택형
		q = question(new EgovMap(), "3", "OX_CHC", "문항3", "문항3입니다", "N", "N", "N");
		addChoice(q, "1", "O", null, null);
		resultList.add(q);
		resultList.add(choice("2", "X", null, null));

		// 페이지1 문항4 - 서술형 (보기 없음)
		resultList.add(question(new EgovMap(), "4", "LONG_TEXT", "문항4", "문항4입니다", "Y", "N", "N"));

		// 페이지1 문항5 - 레벨형
		EgovMap q5 = question(new EgovMap(), "5", "LEVEL", "문항5", "문항5입니다", "Y", "N", "N");
		q5.put("lvl", "1|매우그렇다|5, 2|그렇다|4, 3|그저그렇다|3, 4|아니다|2, 5|매우 아니다|1");
		addChoice(q5, "1", "문항5_보기1", null, null);
		resultList.add(q5);
		resultList.add(choice("2", "문항5_보기2", null, null));

		// 페이지2
		EgovMap p2 = page("2", "페이지2", "페이지2입니다");

		// 페이지2 문항1 - OX선택형
		q = question(p2, "1", "OX_CHC", "문항2_1", "문항2_1입니다", "Y", "Y", "N");
		addChoice(q, "1", "O", "3",   null);
		resultList.add(q);
		resultList.add(choice("2", "X", "END", null));

		// 페이지2 문항2 - 다중선택형
		q = question(new EgovMap(), "2", "MLT_CHC", "문항2_2", "문항2_2입니다", "Y", "N", "N");
		addChoice(q, "1", "문항2_2_보기1", null, null);
		resultList.add(q);
		resultList.add(choice("2", "문항2_2_보기2", null, null));
		resultList.add(choice("3", "문항2_2_보기3", null, null));

		// 페이지3
		EgovMap p3 = page("3", "페이지3", "페이지3입니다");

		// 페이지3 문항1 - 단일선택형
		q = question(p3, "1", "ONE_CHC", "문항3_1", "문항3_1입니다", "N", "N", "N");
		addChoice(q, "1", "문항3_1_보기1", null, null);
		resultList.add(q);
		resultList.add(choice("2", "문항3_1_보기2", null, null));
		resultList.add(choice("3", "문항3_1_보기3", null, null));

		// 페이지3 문항2 - 서술형 (보기 없음)
		resultList.add(question(new EgovMap(), "2", "LONG_TEXT", "문항3_2", "문항3_2입니다", "N", "N", "N"));

        String[] searchValues = {
                  "⊙ 주의사항 : 엑셀로 문항 등록시 기존 등록된 설문 문항은 삭제됩니다."
                , "1. 페이지순번 : 정수로 1부터 시작"
                , "2. 페이지명 : 최대 50자 이내"
                , "3. 문항순번 : 페이지 단위로, 정수로 1부터 시작. 페이지가 넘어가면 다시 1부터 시작"
                , "4. 문항답변유형코드 : 단일선택형(ONE_CHC), 다중선택형(MLT_CHC), OX선택형(OX_CHC), 레벨형(LEVEL), 서술형(LONG_TEXT)"
                , "5. 문항명 : 최대 100자 이내"
                , "6. 문항내용 : 입력하지 않아도 됨"
                , "7. 필수답변여부 : Y이면 참여자가 반드시  해당문에 대한  답변을 해야함"
                , "8. 페이지점프여부 : 해당문항에 대한  답변을 할때, 선택한 보기(선택지)에 따라 특정페이지로 이동 또는 설문종료 등의 처리를 할 것인지  여부,\r\n" +
                		"한 페이지당 하나의 문항만 설정가능, 단일선택형(ONE_CHC), 다중선택형(MLT_CHC), OX선택형(OX_CHC)에서만 설정가능"
                , "9. 기타입력사용여부 : 문항답변유형코드가 단일선택형(ONE_CHC), 다중선택형(MLT_CHC) 일 경우에 주어진 보기(선택지) 이외의 기타 의견을 입력할 수 있도록 할것인지 여부"
                , "10. 레벨 : 문항 유형이 레벨형 일때만 입력.\r\n" +
                        "아래 예시에서 \"1|매우그렇다|5\" 는 하나의 레벨인데,\r\n" +
                        "\"1\"은 레벨의 순번이고, \"매우 그렇다\"는 레벨내용이고, \"5\"는 레벨 점수이다.\r\n" +
                        "(레벨은 반드시  \"레벨순번|레벨명|레벨점수\" 이 3개의 정보로 이루어 져야 한다.)\r\n" +
                        "레벨은 최대 10개를 입력될 수 있으며 레벨과 레벨 사이에 \",\"로 구분하면 된다."
                , "11. 보기항목순번 : 문항 단위로, 정수로 1부터 시작. 문항이 넘어가면  다시 1부터 시작"
                , "12. 보기항목내용 : 최대 100자 이내. 기타의견 보기일 경우에는 빈칸으로 입력"
                , "13. 점프페이지 : 문항정보 중 페이지점프여부가 'Y'인 문항의 보기에만 설정한다.\r\n" +
                        "입력하지 않아도 됨(입력하지 않으면 NEXT로 처리됨).\r\n" +
                        "문항보기를 선택했을 때 특정 페이지로 이동하고자 한다면 특정 페이지 번호를 입력하고, \r\n" +
                        "설문을 종료하고자 한다면 \"END\"를 입력하고 다음페이지로 이동하고자 한다면 \"NEXT\"를 입력하면 된다.\r\n" +
                        "(아래 예제에서 2페이지로 이동하는 것과 NEXT로 이동하는 것은 동일하게 2페이지로 이동한다. NEXT 페이지가 2페이지이기 때문)"
                , "14. 기타의견여부 : 문항정보 중  기타의견입력가능여부가  \"Y\"로 설정되었을 경우에만 설정하면 됨.\r\n" +
                        "기타의견여부가 \"Y\"인 문항보기는 보기항목내용이 없어야 함."
        };

        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "설문 문항 엑셀 업로드 양식");
        map.put("sheetName", "sample");
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", resultList);

        return map;
	}

	/**
	* 설문문항엑셀업로드
	*
	* @param srvyId 		설문아이디
    * @param uploadFiles 	파일목록
    * @param uploadPath 	파일경로
    * @param excelGrid 		엑셀그리드
	*/
	@Override
	public ResultDTO<SrvyVO> srvyQstnExcelUpload(SrvyVO vo) {
		ResultDTO<SrvyVO> resultDTO = new ResultDTO<SrvyVO>();

		List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        List<String> fileIdList = new ArrayList<>();

        // 첨부파일
        if (uploadFileList.size() > 0) {
        	for (AtflVO atflVO : uploadFileList) {
        		atflVO.setRefId(vo.getSrvyId());
        		atflVO.setRgtrId(vo.getRgtrId());
        		atflVO.setMdfrId(vo.getRgtrId());
        		atflVO.setAtflRepoId(CommConst.REPO_SRVY);
        		fileIdList.add(atflVO.getAtflId());
        	}

        	// 첨부파일 저장
        	attachFileService.insertAtflList(uploadFileList);
        }

        AtflVO atflVO = uploadFileList.get(0);

        //엑셀 읽기위한 정보값 세팅
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("startRaw", 20);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("atflVO", atflVO);
        map.put("searchKey", "excelUpload");

		//엑셀 리더
		ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		try {
			list = (List<Map<String, Object>>) excelUtilPoi.simpleReadGrid(map);

			// 첨부파일 삭제
			attachFileService.deleteAtflByAtflIds(fileIdList.toArray(new String[0]));
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		if(list.size() > 0) {
			// 설문지번호 중복확인
			List<String> srvySeqnoList = list.stream()
					.map(qstn -> qstn.get("A"))
					.filter(v -> v != null && !v.toString().isEmpty())
					.map(Object::toString)
					.collect(Collectors.toList());

			boolean hasDuplicate = srvySeqnoList.size() != new HashSet<>(srvySeqnoList).size();
			if(hasDuplicate) {
				Set<String> seen = new HashSet<>();
				Set<String> duplicates = srvySeqnoList.stream()
						.filter(v -> !seen.add(v))
						.collect(Collectors.toSet());

				resultDTO.setResultFailed();
				resultDTO.setMessage(duplicates + " 페이지 번호는 중복 입력된 번호입니다.");
				return resultDTO;
			}

			// 문항검사
			String srvySeqno = "";
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> qstn = list.get(i);
				if(hasValue(qstn, "A")) {
					srvySeqno = str(qstn, "A");

					String qstnRspnsTycd = str(qstn, "E");
					int srvyMvmnUseynCnt = 0;
					if(("ONE_CHC".equals(qstnRspnsTycd) || "MLT_CHC".equals(qstnRspnsTycd)) || "OX_CHC".equals(qstnRspnsTycd)) {
						String srvyMvmnUseyn = str(qstn, "I");
						if("Y".equals(srvyMvmnUseyn)) srvyMvmnUseynCnt++;

						for(int k = i + 1; k < list.size(); k++) {
							String nextQstn = str(list.get(k), "A");
							if (!"".equals(nextQstn)) break;
							if(hasValue(list.get(k), "E")) {
								qstnRspnsTycd = str(list.get(k), "E");
							}
							// 단일, 다중, OX선택형
							if(("ONE_CHC".equals(qstnRspnsTycd) || "MLT_CHC".equals(qstnRspnsTycd)) || "OX_CHC".equals(qstnRspnsTycd)) {
								srvyMvmnUseyn = str(list.get(k), "I");
								if("Y".equals(srvyMvmnUseyn)) srvyMvmnUseynCnt++;
							}
						}
					}
					if(srvyMvmnUseynCnt > 1) {
						resultDTO.setResultFailed();
						resultDTO.setMessage("페이지별 페이지점프여부는 1개만 등록 할 수 있습니다.");
						return resultDTO;
					}
				}

				if(hasValue(qstn, "D")) {
					String qstnRspnsTycd = str(qstn, "E");
					// 문항답변유형코드 빈값
					if ("".equals(qstnRspnsTycd)) {
						resultDTO.setResultFailed();
						resultDTO.setMessage((i+20) + "번 줄의 문항답변유형코드를 입력해주세요.");
						return resultDTO;
					}

					// 문항답변유형코드 목록 조회
					List<CmmnCdVO> qstnRspnsTycdList = new ArrayList<CmmnCdVO>();
					try {
						qstnRspnsTycdList = cmmnCdService.listCode(vo.getOrgId(), "QSTN_RSPNS_TYCD").getReturnList();
					} catch (Exception e) {
						System.out.println(e.getMessage());
					}
					qstnRspnsTycdList.removeIf(item -> "QUIZ".equals(item.getGrpcd()) || item.getCdSeqno() == 0);
					// 문항답변유형코드일치여부
					boolean isMatched = qstnRspnsTycdList.stream()
							.anyMatch(cd -> cd.getCd().contains(qstnRspnsTycd));
					if(!isMatched) {
						resultDTO.setResultFailed();
						resultDTO.setMessage((i+20) + "번 줄의 문항답변유형코드가 일치하지 않습니다.");
						return resultDTO;
					}

					// 레벨형
					if("LEVEL".equals(qstnRspnsTycd)) {
						String lvl = str(qstn, "K");
						// 레벨 빈값
						if("".equals(lvl)) {
							resultDTO.setResultFailed();
							resultDTO.setMessage((i+20) + "번 줄의 레벨을 입력해주세요.");
							return resultDTO;
						}

						String[] lvlList = lvl.split("\\,");
						// 레벨 개수 불일치
						if(lvlList.length > 10) {
							resultDTO.setResultFailed();
							resultDTO.setMessage((i+20) + "번 줄의 레벨수가 일치하지 않습니다.");
							return resultDTO;
						}

						for(String lvlStr : lvlList) {
							String[] lvlItemList = lvlStr.split("\\|");
							if(lvlItemList.length != 3) {
								resultDTO.setResultFailed();
								resultDTO.setMessage((i+20) + "번 줄의 레벨이 올바르지 않습니다.");
								return resultDTO;
							}

							try {
								Integer.parseInt(lvlItemList[2]);
							} catch(Exception e) {
								resultDTO.setResultFailed();
								resultDTO.setMessage((i+20) + "번 줄의 레벨점수는 숫자로 입력해야 합니다.");
								return resultDTO;
							}
						}
					}

					// 단일, 다중선택형 ( 기타입력사용인경우 )
					String etcInptUseyn = str(qstn, "J");
					if(("ONE_CHC".equals(qstnRspnsTycd) || "MLT_CHC".equals(qstnRspnsTycd)) && "Y".equals(etcInptUseyn)) {
						String etcInptyn = str(qstn, "O");
						String qstnSeqno = str(qstn, "D");
						if("".equals(etcInptyn)) {
							resultDTO.setResultFailed();
							resultDTO.setMessage((i+20) + "번 줄의 기타입력여부가 없습니다.");
							return resultDTO;
						}

						int etcInptynCnt = 0;	// 기타입력여부 Y 카운트
						if("Y".equals(etcInptyn)) etcInptynCnt++;
						for(int k = i + 1; k < list.size(); k++) {
							String nextQstn = str(list.get(k), "E");
							if (!"".equals(nextQstn)) break;
							etcInptyn = str(list.get(k), "O");
							if("".equals(etcInptyn)) {
								resultDTO.setResultFailed();
								resultDTO.setMessage((k+20) + "번 줄의 기타입력여부가 없습니다.");
								return resultDTO;
							}
							if("Y".equals(etcInptyn)) etcInptynCnt++;
						}
						if(etcInptynCnt == 0) {
							resultDTO.setResultFailed();
							resultDTO.setMessage(srvySeqno + "페이지 " + qstnSeqno + "번 문항에 기타입력여부가 없습니다.");
							return resultDTO;
						} else if(etcInptynCnt > 1) {
							resultDTO.setResultFailed();
							resultDTO.setMessage(srvySeqno + "페이지 " + qstnSeqno + "번 문항에 기타입력여부는 1개만 등록 할 수 있습니다.");
							return resultDTO;
						}
					}
				}
			}

			// 기존 설문문항목록보기항목레벨전체삭제
			srvyQstnVwitmLvlDAO.srvyQstnListVwitmLvlAllDelete(vo);

			// 기존 설문문항목록보기항목전체삭제
			srvyVwitmDAO.srvyQstnListVwitmAllDelete(vo);

			// 기존 설문문항전체삭제
			srvyQstnDAO.srvyQstnAllDelete(vo);

			// 기존 설문지전체삭제
			srvypprDAO.srvypprAllDelete(vo);

			// 설문문항 등록용 for문
			String srvypprId = "";
			String qstnRspnsTycd = "";
			// 일괄등록용 목록
			List<SrvypprVO> pprList = new ArrayList<SrvypprVO>();					// 설문지목록
			List<SrvyQstnVO> qstnList = new ArrayList<SrvyQstnVO>();				// 설문문항목록
			List<SrvyVwitmVO> vwitmList = new ArrayList<SrvyVwitmVO>();				// 설문보기항목목록
			List<SrvyQstnVwitmLvlVO> lvlList = new ArrayList<SrvyQstnVwitmLvlVO>();	// 설문문항보기항목레벨목록
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> qstn = list.get(i);
				// 설문지
				if(hasValue(qstn, "A")) {
					SrvypprVO pprVO = new SrvypprVO();
					srvypprId = IdGenUtil.genNewId(IdPrefixType.SRPPR);
					pprVO.setSrvypprId(srvypprId);
					pprVO.setSrvyId(vo.getSrvyId());
					pprVO.setSrvyTtl(str(qstn, "B"));
					pprVO.setSrvyCts(str(qstn, "C"));
					pprVO.setSrvySeqno(Integer.parseInt(str(qstn, "A")));
					pprVO.setRgtrId(vo.getRgtrId());
					pprList.add(pprVO);
				}

				// 설문문항
				if(hasValue(qstn, "D")) {
					qstnRspnsTycd 			= str(qstn, "E");	// 문항답변유형코드
					String etcInptUseyn 	= "ONE_CHC".equals(qstnRspnsTycd) || "MLT_CHC".equals(qstnRspnsTycd) ? str(qstn, "J") : "N";	// 기타입력사용여부
					String srvyMvmnUseyn	= "ONE_CHC".equals(qstnRspnsTycd) || "MLT_CHC".equals(qstnRspnsTycd) || "OX_CHC".equals(qstnRspnsTycd) ? str(qstn, "I") : "N";	// 설문이동사용여부
					SrvyQstnVO qstnVO = new SrvyQstnVO();
					String srvyQstnId = IdGenUtil.genNewId(IdPrefixType.SRQN);
					qstnVO.setSrvyQstnId(srvyQstnId);
					qstnVO.setSrvypprId(srvypprId);
					qstnVO.setQstnGbncd("GENERAL");
					qstnVO.setQstnRspnsTycd(qstnRspnsTycd);
					qstnVO.setQstnSeqno(Integer.parseInt(str(qstn, "D")));
					qstnVO.setQstnTtl(hasValue(qstn, "F") ? str(qstn, "F") : str(qstn, "D")+"문항");
					qstnVO.setQstnCts(hasValue(qstn, "G") ? str(qstn, "G") : str(qstn, "D")+"문항 내용");
					qstnVO.setEsntlRspnsyn(str(qstn, "H"));
					qstnVO.setEtcInptUseyn(etcInptUseyn);
					qstnVO.setSrvyMvmnUseyn(srvyMvmnUseyn);
					qstnVO.setRgtrId(vo.getRgtrId());
					qstnList.add(qstnVO);

					// 설문보기항목
					for(int k = i; k < list.size(); k++) {
						String nextQstn = str(list.get(k), "E");
						if (!"".equals(nextQstn) && k > i) break;
						// 서술형 아닌경우
						if(!"LONG_TEXT".equals(qstnRspnsTycd)) {
							String etcInptyn = hasValue(list.get(k), "O") ? str(list.get(k), "O") : "N";
							SrvyVwitmVO vwitmVO = new SrvyVwitmVO();
							vwitmVO.setSrvyVwitmId(IdGenUtil.genNewId(IdPrefixType.SRVW));
							vwitmVO.setSrvyQstnId(srvyQstnId);
							vwitmVO.setVwitmGbncd("TXT");
							vwitmVO.setVwitmCts("Y".equals(etcInptyn) ? "ETC" : str(list.get(k), "M"));
							vwitmVO.setVwitmSeqno(Integer.parseInt(str(list.get(k), "L")));
							vwitmVO.setMvmnSrvypprId(hasValue(list.get(k), "N") ? str(list.get(k), "N") : null);
							vwitmVO.setEtcInptyn(etcInptyn);
							vwitmVO.setRgtrId(vo.getRgtrId());
							vwitmList.add(vwitmVO);
						}
					}

					// 설문문항보기항목레벨 ( 레벨형 )
					if("LEVEL".equals(qstnRspnsTycd)) {
						String lvlStr = str(qstn, "K");
						for(String lvl : lvlStr.split("\\,")) {
							String[] lvls = lvl.split("\\|");
							SrvyQstnVwitmLvlVO lvlVO = new SrvyQstnVwitmLvlVO();
							lvlVO.setSrvyQstnVwitmLvlId(IdGenUtil.genNewId(IdPrefixType.SRQVL));
							lvlVO.setSrvyQstnId(srvyQstnId);
							lvlVO.setLvlSeqno(Integer.parseInt(lvls[0].trim()));
							lvlVO.setLvlCts(lvls[1].trim());
							lvlVO.setLvlScr(Integer.parseInt(lvls[2].trim()));
							lvlVO.setRgtrId(vo.getRgtrId());
							lvlList.add(lvlVO);
						}
					}
				}
			}

			// 설문보기항목 다음설문지아이디 변경용 map
			Map<Integer, String> srvypprMap = pprList.stream()
					.collect(Collectors.toMap(SrvypprVO::getSrvySeqno, SrvypprVO::getSrvypprId));

			// 설문보기항목 다음설문지아이디 치환
			for (SrvyVwitmVO vwitm : vwitmList) {
				try {
					int keyId = Integer.parseInt(vwitm.getMvmnSrvypprId());
					String pprId = srvypprMap.get(keyId);
					if (pprId != null) {
						vwitm.setMvmnSrvypprId(pprId);
					}
				} catch(NumberFormatException e) {
				}
			}

			if(pprList.size() > 0) srvypprDAO.srvypprBulkRegist(pprList);					// 설문지일괄등록
			if(qstnList.size() > 0) srvyQstnDAO.srvyQstnBulkRegist(qstnList);				// 설문문항일괄등록
			if(vwitmList.size() > 0) srvyVwitmDAO.srvyVwitmBulkRegist(vwitmList);			// 설문보기항목일괄등록
			if(lvlList.size() > 0) srvyQstnVwitmLvlDAO.srvyQstnVwitmLvlBulkRegist(lvlList);	// 설문문항보기항목레벨일괄등록
		}

		resultDTO.setResultSuccess();
        return resultDTO;
	}

	private String str(Map<String, Object> map, String key) {
		Object obj = map.get(key);
		return (obj != null) ? obj.toString().trim() : "";
	}

	private boolean hasValue(Map<String, Object> map, String key) {
	    return !str(map, key).isEmpty();
	}

	private EgovMap page(String seqno, String ttl, String cts) {
	    EgovMap m = new EgovMap();
	    m.put("srvySeqno", seqno);	// 설문지순번
	    m.put("srvyTtl",   ttl);	// 설문지제목
	    m.put("srvyCts",   cts);	// 설문지내용
	    return m;
	}

	private EgovMap question(EgovMap base, String seqno, String tycd, String ttl, String cts, String esntl, String mvmn, String etc) {
		base.put("qstnSeqno",      seqno);	// 문항순번
		base.put("qstnRspnsTycd",  tycd);	// 문항답변유형코드
		base.put("qstnTtl",        ttl);	// 문항제목
		base.put("qstnCts",        cts);	// 문항내용
		base.put("esntlRspnsyn",   esntl);	// 필수답변여부
		base.put("srvyMvmnUseyn",  mvmn);	// 설문이동사용여부
		base.put("etcInptUseyn",   etc);	// 기타입력사용여부
		return base;
	}

	private EgovMap choice(String seqno, String cts, String mvmn, String etcInpt) {
	    EgovMap m = new EgovMap();
	    m.put("vwitmSeqno", seqno);								// 보기항목순번
	    if (cts    != null) m.put("vwitmCts",     cts);			// 보기항목내용
	    if (mvmn   != null) m.put("mvmnSrvypprId", mvmn);		// 이동설문지아이디
	    if (etcInpt!= null) m.put("etcInptyn",    etcInpt);		// 기타입력여부
	    return m;
	}

	private void addChoice(EgovMap map, String seqno, String cts, String mvmn, String etcInptyn) {
	    map.put("vwitmSeqno", seqno);
	    if (cts      != null) map.put("vwitmCts",      cts);
	    if (mvmn     != null) map.put("mvmnSrvypprId", mvmn);
	    if (etcInptyn!= null) map.put("etcInptyn",     etcInptyn);
	}

}
