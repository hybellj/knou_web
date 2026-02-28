package knou.framework.util;

import java.util.Calendar;
import java.util.UUID;

import knou.framework.common.IdPrefixType;

/**
 * @Class Name 	: IdGen.java
 * @Description : IdGen Class

 * <pre>
 * 사용 예:
 * String id = IdGenUtil.genNewId(IdPrefixType.CMCOD);
 *
 * 업무코드는 {@link IdPrefixType} enum을 통해 관리되며,
 * 각 코드의 의미는 getDescription()으로 확인할 수 있습니다.
 *
 * 예시:
 * IdPrefixType.CMCOD.getDescription(); // "공통코드"
 * </pre>
 * @Modification Information
 * @
 * @  수정일      	수정자            수정내용
 * @ ---------   	---------   	-------------------------------
 * @ 2025.11.13		jinkoon			최초생성
 *
 * @author jinkoon
 * @since 2025.11.13
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MEDIOPIA All right reserved.
 */

public class IdGenUtil {

	private static StringBuffer newId;

	public IdGenUtil() {
		super();
	}

	/**
	 * 테이블 ID 생성

	 *
	 * @param 	idPrefixType (모듈명, 5자 이내)
	 * @return
	 */
	public synchronized static String genNewId(IdPrefixType idPrefixType) throws Exception {
		newId = new StringBuffer();
		if ( idPrefixType == null ) {
			throw new Exception ("업무코드 정보가 없습니다.");
		}
		String code = idPrefixType.getCode();
		if ( code.length() < 3 || code.length() > 5) {
			throw new Exception ("업무코드의 길이는 3~5글자입니다.");
		}

		code = code.toUpperCase();
		newId.append(code.length() == 3 ? code + "00" : code.length() == 4 ? code + "0"  : code );

		Calendar calendar = Calendar.getInstance();

		newId.append(String.format("%02d",calendar.get(Calendar.YEAR) % 2000));
		newId.append(String.format("%02d",calendar.get(Calendar.MONTH)+1));
		newId.append(String.format("%02d",calendar.get(Calendar.DAY_OF_MONTH)));
		newId.append(String.format("%02d",calendar.get(Calendar.HOUR_OF_DAY)));
		newId.append(String.format("%02d", calendar.get(Calendar.MINUTE)));
		newId.append(String.format("%02d", calendar.get(Calendar.SECOND)));
		newId.append(String.format("%03d", calendar.get(Calendar.MILLISECOND)));

		newId.append(UUID.randomUUID().toString().replace("-", "").substring(0, 10));

		return newId.toString();
	}
}
/*
 * genNewId(String bizCode) 메쏘드에서 bizCode를 전달하면 해당 bizCode로 시작하는 ID를 생성하여 return 합니다.
 *
 * 테이블ID 그룹코드 - bizCode
 * SR - 설문, SRVY 설문, SRPPR 설문지, SRQN 설문문항, SRQS 설문출제, SRVW 설문보기항목, SREVL 설문평가, SRPCT 설문참여, SRRSP 설문응답
 * LN - 학습, (별도 테이블아이디 없으나 정의만 함, LNRT 학습진도율, LNSTP 학습중단위험지수 )
 * ST - 통계, (별도 테이블아이디 없으나 정의만 함, STSBJ 과목별통계, STATN 주차별수강통계, STAOT 주차별누계수강통계 )
 * TE - 팀,  TEAM 팀, (별도 테이블아이디 없으나 정의만 함 TEMBR 팀멤버)
 * SM - 세미나, SMNR 세미나, SMATN 세미나참석, SMPRE 세미나사전등록, SMZTK 세미나줌토큰
 * EV - 평가, EVSCR 평가점수, EVOPR 운영평가
 * MT - 상호, MTEVL 상호평가, MTEVQ 상호평가문항, MTEVR 상호평가결과
 * AT - 첨부파일, ATFL 첨부파일, ATREP 첨부파일저장소, ATBOX 첨부파일함, ATMXS 첨부파일최대크기
 * SE - 세션, SESS 세션
 * BT - 배치, BACH 배치, BTEXR 배치실행기록
 * SY - 시스템, SYJSC 시스템작업일정, SYJSE 시스템작업일정예외, SYJSR 스템작업일정예외기록
 * AU - 권한, AUTH 권한, AUTGR 권한그룹
 * DL - 자료연계, DLAIS 학사정보시스템자료연계
 * LO - 로그, LOMSG 로그메시지, LODLA 로그학사시스템학기자료연계, LOPRV 로그인개인정보조회, LOACT 로그사용자활동
 * US - 사용자, 	USFIL 사용자프로필, USVRF 사용자본인확인, USSNS 사용자SNS연결, USLGH 사용자로그인이력, USCRA 사용자콘텐츠반응
 * 				USCHG 사용자정보변경이력, USACR 사용자학적, USEXC 사용자학점교류, USTKN 사용자토큰, USAUT 사용자권한
 * 				USTPW 사용자임시비밀번호, USCTT 사용자연락처
 * QB - 문제은행, 	QBQSN 문제은행문항, QBQSR 문제은행문항정답, QBQVW 문제은행보기항목
 * QS - 문항, QSTN 문항, QSVW 보기항목, QSTNS 문제출제
 * TK - 응시, TKEXM 시험응시, TKRST 시험응시결과, TKANS 시험응시답안, TKOAT 시험응시서약
 * EX - 시험, EXBSC 시험기본, EXDTL 시험상세, EXPPR 시험지, EXABS 시험결시, EXSPT 시험지원신청, EXTGT 시험대상분반
 * MR - 성적, 	MRK 성적, MRABS 성적결시반영비율, MRSET 성적항목설정, MRCVS 성적환산등급, MROBJ 성적이의신청, MRRLT 성적상대평가기준비율
 * 				MRSBJ 성적과목, MRSBD 성적과목상세, MRACT 성적누계
 * AS - 과제, ASMT 과제, ASSBM 과제제출, ASCMT 과제댓글, ASFL 과제파일, ASFDK 과제피드백, ASEVL 과제평가, ASMEV 과제상호평가, ASMER 과제상호평가결과
 * BB - 게시판, BBS 게시판, BBATC 게시판게시글, BBCMT 게시판게시글댓글, BBOPT 게시판옵션, BBAIR 게시판게시글조회기록, BBAOP 게시판게시글옵션, BBFVR 게시판게시글좋아요
 * DS - 토론, DSCS 토론, DSPTC 토론참여, DSATC 토론게시글, DSCMT 토론댓글, DSFDK 토론피드백, DSMEV 토론상호평가
 * AT - 수강, ATDLC 수강, ATSBJ 수강과목, ATMMO 수강메모
 * SB - 과목,		SBJCT 과목, SBLCS 과목강의일정, SBLCC 과목강의차시, SBCON 과목강의콘텐츠, SBPRF 과목교수, SBMXS 과목첨부파일최대크기,
 * 				SBMEV 과목성적평가비율, SBMED 과목성적평가비율상세, SBLCP 과목강의콘텐츠페이지, SBLCF 과목강의콘텐츠파일,
 * 				SBSCH 과목일정
 * OR - 기관, ORG 기관, ORCIP 기관접속허용아이피, ORTML 기관템플릿, ORSCO 기관학기기수, ORSCS 기관학기기수일정
 * CR - 과정, CRS 과정,
 * CM - 공통, CMOPT 공통옵션, CMCOD 공통코드, CMTHM 공통테마,
 * WG - 위젯, WGET 위젯, WGUSE 위젯사용,
 * MN - 메뉴, MENU 메뉴, MNUSE 메뉴사용, MNOPT 메뉴옵션, MNLYT 메뉴레이아웃,
 * MS - 메시지, 	MSG 메시지, MSSNG 메시지발신, MSAT 메시지첨부파일, MSTGT 메시지수신대상자, MSTGP 메시지수신자그룹, MSRCV 메시지수신자
 * 				MSTML 메시지탬플릿
 */