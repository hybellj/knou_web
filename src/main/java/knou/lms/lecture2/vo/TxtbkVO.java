package knou.lms.lecture2.vo;

import knou.lms.common.vo.DefaultVO;

public class TxtbkVO extends DefaultVO {
    private String txtbkId;     // 교재아이디
    private String sbjctId;     // 과목아이디
    private String txtbkGbncd;  // 교재구분코드
    private String txtbkGbnnm;  // 교재구분명
    private String txtbknm;     // 교재명
    private String isbn;        // ISBN
    private String wrtr;        // 저자
    private String pblshr;      // 출판사

    public String getTxtbkId() {
        return txtbkId;
    }

    public void setTxtbkId(String txtbkId) {
        this.txtbkId = txtbkId;
    }

    @Override
    public String getSbjctId() {
        return sbjctId;
    }

    @Override
    public void setSbjctId(String sbjctId) {
        this.sbjctId = sbjctId;
    }

    public String getTxtbkGbncd() {
        return txtbkGbncd;
    }

    public void setTxtbkGbncd(String txtbkGbncd) {
        this.txtbkGbncd = txtbkGbncd;
    }

    public String getTxtbkGbnnm() {
        return txtbkGbnnm;
    }

    public void setTxtbkGbnnm(String txtbkGbnnm) {
        this.txtbkGbnnm = txtbkGbnnm;
    }

    public String getTxtbknm() {
        return txtbknm;
    }

    public void setTxtbknm(String txtbknm) {
        this.txtbknm = txtbknm;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getWrtr() {
        return wrtr;
    }

    public void setWrtr(String wrtr) {
        this.wrtr = wrtr;
    }

    public String getPblshr() {
        return pblshr;
    }

    public void setPblshr(String pblshr) {
        this.pblshr = pblshr;
    }
}
