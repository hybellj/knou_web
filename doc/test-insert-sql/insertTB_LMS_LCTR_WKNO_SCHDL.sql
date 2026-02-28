BEGIN
  FOR i IN 1..16 LOOP
    INSERT INTO DEV_LMS.TB_LMS_LCTR_WKNO_SCHDL
    (
      LCTR_WKNO_SCHDL_ID,
      SBJCT_ID,
      LCTR_PLANDOC_ID,
      LCTR_WKNO,
      LCTR_WKNO_CD,
      LCTR_WKNONM,
      LCTR_WKNO_EXPLN,
      LCTR_WKNO_SEQ,
      LCTR_GOAL,
      LCTR_CTS,
      LCTR_OTLN,
      LCTR_REF_DATA,
      LCTR_WKNO_SYMD,
      LCTR_WKNO_EYMD,
      ATNDC_RCG_SYMD,
      ATNDC_RCG_EYMD,
      LCTR_TOC_LRN_SCNDS,
      OYN,
      DELYN,
      RGTR_ID,
      REG_DTTM,
      MDFR_ID,
      MOD_DTTM
    )
    VALUES
    (
      'WKNO' || LPAD(i, 3, '0'),           -- LCTR_WKNO_SCHDL_ID
      'SBJCT20260001',                     -- SBJCT_ID
      'PLAN001',                           -- LCTR_PLANDOC_ID
      i,                                   -- LCTR_WKNO
      'WK' || LPAD(i, 2, '0'),              -- LCTR_WKNO_CD
      i || '주차',                          -- LCTR_WKNONM
      i || '주차 강의 설명',                -- LCTR_WKNO_EXPLN
      i,                                   -- LCTR_WKNO_SEQ
      i || '주차 학습목표',                 -- LCTR_GOAL
      i || '주차 학습내용',                 -- LCTR_CTS
      i || '주차 개요',                     -- LCTR_OTLN
      i || '주차 참고자료',                 -- LCTR_REF_DATA
      TO_CHAR(DATE '2026-01-01' + (i-1)*7, 'YYYYMMDD'), -- 시작일
      TO_CHAR(DATE '2026-01-07' + (i-1)*7, 'YYYYMMDD'), -- 종료일
      TO_CHAR(DATE '2026-01-01' + (i-1)*7, 'YYYYMMDD'), -- 출석 시작
      TO_CHAR(DATE '2026-01-07' + (i-1)*7, 'YYYYMMDD'), -- 출석 종료
      3600,                                -- LCTR_TOC_LRN_SCNDS (1시간)
      'Y',                                 -- OYN
      'N',                                 -- DELYN
      'admin',                             -- RGTR_ID
      SYSDATE,                             -- REG_DTTM
      'admin',                             -- MDFR_ID
      SYSDATE                              -- MOD_DTTM
    );
  END LOOP;

  COMMIT;
END;
/