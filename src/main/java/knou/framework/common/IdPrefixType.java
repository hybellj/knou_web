package knou.framework.common;


/**
 * 시스템 전역 BizCode Enum
 * 테이블 prefix 코드 + 의미를 enum으로 관리해 오타 방지 및 자동완성 지원
 */
public enum IdPrefixType {
    // 설문
    SR("SR", "설문"),
    SRVY("SRVY", "설문"),
    SRPPR("SRPPR", "설문지"),
    SRQN("SRQN", "설문문항"),
    SRQS("SRQS", "설문출제"),
    SRVW("SRVW", "설문보기항목"),
    SREVL("SREVL", "설문평가"),
    SRPCT("SRPCT", "설문참여"),
    SRRSP("SRRSP", "설문응답"),
    SRTGT("SRTGT", "설문대상"),
    SRGRP("SRGRP", "설문그룹"),
    SRQVL("SRQVL", "설문문항보기항목레벨"),

    // 학습
    LN("LN", "학습"),
    LNRT("LNRT", "학습진도율"),
    LNSTP("LNSTP", "학습중단위험지수"),

    // 통계
    ST("ST", "통계"),
    STSBJ("STSBJ", "과목별통계"),
    STATN("STATN", "주차별수강통계"),
    STAOT("STAOT", "주차별누계수강통계"),

    // 팀
    TE("TE", "팀"),
    TEAM("TEAM", "팀"),
    TEMBR("TEMBR", "팀멤버"),

    // 세미나
    SM("SM", "세미나"),
    SMNR("SMNR", "세미나"),
    SMATN("SMATN", "세미나참석"),
    SMPRE("SMPRE", "세미나사전등록"),
    SMZTK("SMZTK", "세미나줌토큰"),

    // 평가
    EV("EV", "평가"),
    EVSCR("EVSCR", "평가점수"),
    EVOPR("EVOPR", "운영평가"),

    // 상호평가
    MT("MT", "상호"),
    MTEVL("MTEVL", "상호평가"),
    MTEVQ("MTEVQ", "상호평가문항"),
    MTEVR("MTEVR", "상호평가결과"),

    // 첨부파일
    AT("AT", "첨부파일"),
    ATFL("ATFL", "첨부파일"),
    ATREP("ATREP", "첨부파일저장소"),
    ATBOX("ATBOX", "첨부파일함"),
    ATMXS("ATMXS", "첨부파일최대크기"),

    // 세션
    SE("SE", "세션"),
    SESS("SESS", "세션"),

    // 배치
    BT("BT", "배치"),
    BACH("BACH", "배치"),
    BTEXR("BTEXR", "배치실행기록"),

    // 시스템
    SY("SY", "시스템"),
    SYJSC("SYJSC", "시스템작업일정"),
    SYJSE("SYJSE", "시스템작업일정예외"),
    SYJSR("SYJSR", "시스템작업일정예외기록"),

    // 권한
    AU("AU", "권한"),
    AUTH("AUTH", "권한"),
    AUTGR("AUTGR", "권한그룹"),

    // 자료연계
    DL("DL", "자료연계"),
    DLAIS("DLAIS", "학사정보시스템자료연계"),

    // 로그
    LO("LO", "로그"),
    LOMSG("LOMSG", "로그메시지"),
    LODLA("LODLA", "로그학사시스템학기자료연계"),
    LOPRV("LOPRV", "로그인개인정보조회"),
    LOACT("LOACT", "로그사용자활동"),

    // 사용자
    US("US", "사용자"),
    USFIL("USFIL", "사용자프로필"),
    USVRF("USVRF", "사용자본인확인"),
    USSNS("USSNS", "사용자SNS연결"),
    USLGH("USLGH", "사용자로그인이력"),
    USCRA("USCRA", "사용자콘텐츠반응"),
    USCHG("USCHG", "사용자정보변경이력"),
    USACR("USACR", "사용자학적"),
    USEXC("USEXC", "사용자학점교류"),
    USTKN("USTKN", "사용자토큰"),
    USAUT("USAUT", "사용자권한"),
    USTPW("USTPW", "사용자임시비밀번호"),
    USCTT("USCTT", "사용자연락처"),
    USTHS("USTHS", "사용자전화번호변경이력"),

    // 문제은행
    QB("QB", "문제은행"),
    QBCTG("QBCTG", "문제은행분류"),
    QBQSN("QBQSN", "문제은행문항"),
    QBQSR("QBQSR", "문제은행문항정답"),
    QBQVW("QBQVW", "문제은행보기항목"),

    // 문항
    QS("QS", "문항"),
    QSTN("QSTN", "문항"),
    QSVW("QSVW", "보기항목"),
    QSTNS("QSTNS", "문제출제"),

    // 응시
    TK("TK", "응시"),
    TKEXM("TKEXM", "시험응시"),
    TKHTR("TKHTR", "시험응시이력"),
    TKRST("TKRST", "시험응시결과"),
    TKANS("TKANS", "시험응시답안"),
    TKOAT("TKOAT", "시험응시서약"),

    // 시험
    EX("EX", "시험"),
    EXBSC("EXBSC", "시험기본"),
    EXDTL("EXDTL", "시험상세"),
    EXPPR("EXPPR", "시험지"),
    EXABS("EXABS", "시험결시"),
    EXSPT("EXSPT", "시험지원신청"),
    EXTGT("EXTGT", "시험대상자"),
    EXGRP("EXGRP", "시험그룹"),
    EXSBS("EXSBS", "시험대체"),

    // 성적
    MR("MR", "성적"),
    MRK("MRK", "성적"),
    MRABS("MRABS", "성적결시반영비율"),
    MRSET("MRSET", "성적항목설정"),
    MRCVS("MRCVS", "성적환산등급"),
    MROBJ("MROBJ", "성적이의신청"),
    MRRLT("MRRLT", "성적상대평가기준비율"),
    MRSBJ("MRSBJ", "성적과목"),
    MRSBD("MRSBD", "성적과목상세"),
    MRACT("MRACT", "성적누계"),

    // 과제
    AS("AS", "과제"),
    ASMT("ASMT", "과제"),
    ASSBM("ASSBM", "과제제출"),
    ASTRG("ASTRG", "과제제출대상"),
    ASCMT("ASCMT", "과제댓글"),
    ASFL("ASFL", "과제파일"),
    ASFDK("ASFDK", "과제피드백"),
    ASEVL("ASEVL", "과제평가"),
    ASMEV("ASMEV", "과제상호평가"),
    ASMER("ASMER", "과제상호평가결과"),
    ASGRP("ASGRP", "과제그룹"),

    // 게시판
    BB("BB", "게시판"),
    BBS("BBS", "게시판"),
    BBATC("BBATC", "게시판게시글"),
    BBCMT("BBCMT", "게시판게시글댓글"),
    BBOPT("BBOPT", "게시판옵션"),
    BBAIR("BBAIR", "게시판게시글조회기록"),
    BBAOP("BBAOP", "게시판게시글옵션"),
    BBFVR("BBFVR", "게시판게시글좋아요"),

    // 토론
    DS("DS", "토론"),
    DSCS("DSCS", "토론"),
    DSGRP("DSGRP", "토론그룹"),
    DSPTC("DSPTC", "토론참여"),
    DSATC("DSATC", "토론게시글"),
    DSCMT("DSCMT", "토론댓글"),
    DSFDK("DSFDK", "토론피드백"),
    DSMEV("DSMEV", "토론상호평가"),

    // 수강
    ATDLC("ATDLC", "수강"),
    ATSBJ("ATSBJ", "수강과목"),
    ATMMO("ATMMO", "수강메모"),

    // 과목
    SB("SB", "과목"),
    SBJCT("SBJCT", "과목"),
    SBLCS("SBLCS", "과목강의일정"),
    SBLCC("SBLCC", "과목강의차시"),
    SBCON("SBCON", "과목강의콘텐츠"),
    SBPRF("SBPRF", "과목교수"),
    SBMXS("SBMXS", "과목첨부파일최대크기"),
    SBMEV("SBMEV", "과목성적평가비율"),
    SBMED("SBMED", "과목성적평가비율상세"),
    SBLCP("SBLCP", "과목강의콘텐츠페이지"),
    SBLCF("SBLCF", "과목강의콘텐츠파일"),
    SBSCH("SBSCH", "과목일정"),

    // 기관
    OR("OR", "기관"),
    ORG("ORG", "기관"),
    ORCIP("ORCIP", "기관접속허용아이피"),
    ORTML("ORTML", "기관템플릿"),
    ORSCO("ORSCO", "기관학기기수"),
    ORSCS("ORSCS", "기관학기기수일정"),

    // 과정
    CR("CR", "과정"),
    CRS("CRS", "과정"),

    // 공통
    CM("CM", "공통"),
    CMOPT("CMOPT", "공통옵션"),
    CMCOD("CMCOD", "공통코드"),
    CMTHM("CMTHM", "공통테마"),

    // 위젯
    WG("WG", "위젯"),
    WGET("WGET", "위젯"),
    WGUSE("WGUSE", "위젯사용"),

    // 메뉴
    MN("MN", "메뉴"),
    MENU("MENU", "메뉴"),
    MNUSE("MNUSE", "메뉴사용"),
    MNOPT("MNOPT", "메뉴옵션"),
    MNLYT("MNLYT", "메뉴레이아웃"),

    // 메시지
    MS("MS", "메시지"),
    MSG("MSG", "메시지"),
    MBL("MBL", "모바일"),
    EML("EML", "이메일"),
    SHRTNT("SHRTNT", "쪽지"),
    MSSNG("MSSNG", "메시지발신"),
    MSAT("MSAT", "메시지첨부파일"),
    MSTGT("MSTGT", "메시지수신대상자"),
    MSTGP("MSTGP", "메시지수신자그룹"),
    MSRCV("MSRCV", "메시지수신자"),
    MSTML("MSTML", "메시지탬플릿"),
    AAMSG("AAMSG", "자동알림메시지"),
    AATGT("AATGT", "자동알림메시지대상"),
    MSCOS("MSCOS","메지시발신비용"),
    // 교재
    TB("TB", "교재"),
    TBK("TBK", "교재"),

    // 팝업공지
    PNTC("PNTC", "팝업공지");

    private final String code;
    private final String description;

    IdPrefixType(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public String getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }
}
