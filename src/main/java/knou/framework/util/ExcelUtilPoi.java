package knou.framework.util;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.map.ListOrderedMap;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.Comment;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.DataValidation;
import org.apache.poi.ss.usermodel.DataValidationConstraint;
import org.apache.poi.ss.usermodel.DataValidationConstraint.OperatorType;
import org.apache.poi.ss.usermodel.DataValidationHelper;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.RichTextString;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellRangeAddressList;
import org.apache.poi.util.Units;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import knou.framework.common.CommConst;
import knou.framework.vo.FileVO;

/**
 * @author hexma
 */
public class ExcelUtilPoi {

	/**
	 *
	 */
    
	public ExcelUtilPoi() {
		super();
	}

	/*public Object newInstance(String className)
	{
		Object instance = null;

		ClassLoader loader = FileUtil.class.getClassLoader();
		try
		{
			//instance = Class.forName(className).newInstance();
			instance = loader.loadClass(className).newInstance();

		} catch(ClassNotFoundException cnfe)
		{
			cnfe.printStackTrace();

		} catch(IllegalAccessException iae)
		{
			iae.printStackTrace();

		} catch(InstantiationException ie)
		{
			ie.printStackTrace();

		}

		return instance;

	}*/
	
	/**
	 * 클래스명에 대한 클래스를 리턴
	 *
	 * 설명 : medi-common-core 모듈은 자신의 vo 만 인식할 수 있다.
	 *      그러므로 각 모듈에서 @Override 하여 사용해야 해당 모듈의 vo 를  함수 simpleGrid, simpleBigGrid 에서 사용 가능
	 * @param String  클래스명
	 * @return Object
	 */
	public Object getClassForName(String className)
	{
		Class cls = null;
        try {
        	cls = Class.forName(className);
		} catch (ClassNotFoundException e1) {
			e1.printStackTrace();
		}

		return cls;

	}	
	
	public String getFormatString(String str, String formatter, HashMap<String, Object> formatOptions) {
		
	    String defaultValue = ""; 
	    
		switch(formatter) {
		
		   case "number" :
			   
			    String pattern = "#,###";
			    try {
				    
			    	if( formatOptions != null) {
				    	pattern = StringUtil.nvl(formatOptions.get("pattern"),pattern);
				    	defaultValue = StringUtil.nvl(formatOptions.get("defaultValue"));
				    }
			    	
				    DecimalFormat df = new DecimalFormat(pattern);
				    str = df.format(Double.parseDouble(str.replaceAll(",", "")));
				
			    }catch(java.lang.NumberFormatException e) {
			        str = StringUtil.nvl(defaultValue,str);
			    }catch(Exception e) {
			    	str = StringUtil.nvl(defaultValue,str);
			    }
			   
			    break;
		   case "date"	:
			    
			   String srcformat = "yyyyMMddHHmmss";
			   String newformat = "yyyy.MM.dd(HH:mm:ss)";
			   
               try {
				   
            	   if( formatOptions != null) {
            		   srcformat = StringUtil.nvl(formatOptions.get("srcformat"),srcformat);
            		   newformat = StringUtil.nvl(formatOptions.get("newformat"),newformat);
            		   defaultValue = StringUtil.nvl(formatOptions.get("defaultValue"));
           	       }
            	   
            	   str = DateTimeUtil.convertDateFormat(str,srcformat,newformat,"");
            	   
                }catch(Exception e) {
                	str = StringUtil.nvl(defaultValue,str);
			    }

			    break;
			/*default :
				str = "";*/
		
		}
		
		return str;
	}
	
	public String getMethodVal(Map<String, String> cellvalueMap, String method, HashMap<String, Object> methodOptions) {
		
		String defaultValue = "";
		String str = "";
		
		switch(method) {
		
		   case "conCat" :
			  
			   
			   if( methodOptions != null) { 
				   try {
					   
						   List<String> args = (List<String>) methodOptions.get("args");
						   defaultValue = StringUtil.nvl(methodOptions.get("defaultValue"));
						   
						   for(String arg:args) {
							   
							   try {
								   String[] strs = arg.split(":");
								   
								   if("id".equals(strs[0])) {
									   str += StringUtil.nvl(cellvalueMap.get(strs[1]));
								   }else {
									   str += StringUtil.nvl(strs[1]);
								   }
							   }catch(Exception e) {
								   str = StringUtil.nvl(str,defaultValue);
							   }
							   
							   
						   }
					   
						   str = StringUtil.nvl(str,defaultValue);
					   
				   }catch(Exception e) {
					   str = StringUtil.nvl(str,defaultValue);
				   }
			   }
			   
			   break;
			    
		/*default :
			str = "";*/
		
		}
		
		
		return str;
	}
	
	//엑셀 '데이터 유효성 검사' 기능을 구현
	public void setValidat(int firstRow, int lastRow, int j, Sheet worksheet, String validat, HashMap<String, Object> validatOptions) {
		
		DataValidationHelper validationHelper = worksheet.getDataValidationHelper();
		DataValidationConstraint constraint = null;
		CellRangeAddressList addressList = new CellRangeAddressList(firstRow, lastRow, j, j);
		DataValidation dataValidation = null;
        
        switch (validat) {
        
         case "integer": //정수
         case "decimal": //소수점
         case "textLength": //텍스트 길이
			  
			   if (validatOptions != null) {
				   
				   int operatorType = OperatorType.BETWEEN;
				   
				   String operatorTypeNm = StringUtil.nvl(validatOptions.get("operatorType"));
				   switch(operatorTypeNm) {
				      case "BETWEEN": // 해당범위
				    	   operatorType = OperatorType.BETWEEN;
					       break;
				      case "NOT_BETWEEN": //제외범위
				    	   operatorType = OperatorType.NOT_BETWEEN;
					       break;
				      case "EQUAL": // =
				    	   operatorType = OperatorType.EQUAL;
					       break;
				      case "NOT_EQUAL": // <>
				    	   operatorType = OperatorType.NOT_EQUAL;
					       break;
				      case "GREATER_THAN": // >
				    	   operatorType = OperatorType.GREATER_THAN;
					       break;
				      case "LESS_THAN":  // <
				    	   operatorType = OperatorType.LESS_THAN;
					       break;
				      case "GREATER_OR_EQUAL": // >=
				    	   operatorType = OperatorType.GREATER_OR_EQUAL;
					       break;
				      case "LESS_OR_EQUAL": // <=
				    	   operatorType = OperatorType.LESS_OR_EQUAL;
					       break;
				   }
				   
				   String formula1 = StringUtil.nvl(validatOptions.get("formula1"),"0");
				   String formula2 = StringUtil.nvl(validatOptions.get("formula2"),"0");
				   
				   if( "integer".equals(validat)) { //정수
					   constraint = validationHelper.createIntegerConstraint(operatorType, formula1, formula2);
				   }else if("decimal".equals(validat)) { //소수점
					   constraint = validationHelper.createDecimalConstraint(operatorType, formula1, formula2);
				   }else if("textLength".equals(validat)) { //텍스트 길이
					   constraint = validationHelper.createTextLengthConstraint(operatorType, formula1, formula2);
				   }
				   
			   }
			   
			   break;
        
          /*case "formulaList": //목록(공식에 의한 값) // 엑셀버전에 따라 사용할 수 있는 공식이 다르니 사용시 주의, 추후 기능 필요한 경우 주석해제하여 사용
        	                    // ex) [ xlsx 인 경우 ] formula1:"=$B$6:$C$6"
        	                    //     [  xls 인 경우 ] formula1: "$B$7:$C$7"
			  
			   if (validatOptions != null) {
				     
				    String listFormula = StringUtil.nvl(validatOptions.get("formula1"));
				    constraint = validationHelper.createFormulaListConstraint(listFormula);
			   }
			   
			   break;*/

		   case "explicitList": //목록(명시적인 값)
			  
			   if (validatOptions != null) {
				    List<String> list = (List<String>) validatOptions.get("formula1");
				    String[] listOfValues = list.toArray(new String[list.size()]);
				    constraint = validationHelper.createExplicitListConstraint(listOfValues );
					
			   }
			   
			   break;
		   	
        }
        
        dataValidation = validationHelper.createValidation(constraint, addressList);
		dataValidation.setShowPromptBox(false);
		dataValidation.setShowErrorBox(false);
		
		//설명 박스
		Map<String, Object> promptBox = (HashMap<String, Object>) validatOptions.get("promptBox");
		if (promptBox != null) {
			dataValidation.setShowPromptBox(true);
			dataValidation.createPromptBox(StringUtil.nvl(promptBox.get("title")), StringUtil.nvl(promptBox.get("text")));
		}
		
		//에러 박스
		Map<String, Object> errorBox = (HashMap<String, Object>) validatOptions.get("errorBox");
		if (errorBox != null) {
			dataValidation.setShowErrorBox(true);
			dataValidation.createErrorBox(StringUtil.nvl(errorBox.get("title")), StringUtil.nvl(errorBox.get("text")));
		}
		
		worksheet.addValidationData(dataValidation);	
	}
	
	//말풍선
	public void setMemo(int rowNum, int j, Sheet worksheet, HashMap<String, Object> memo) {
		
		String excelType = "";
		if(worksheet instanceof HSSFSheet) {
			excelType = "HSSF";
		}else if(worksheet instanceof XSSFSheet){
			excelType = "XSSF";
		}else if(worksheet instanceof SXSSFSheet){
			excelType = "SXSSF";
		}
		
		//폰트 설정(말풍선)
		Font fontMemo = worksheet.getWorkbook().createFont();
		fontMemo.setFontName("Tahoma"); //글씨체
		fontMemo.setFontHeight((short)(16*10)); //사이즈
		fontMemo.setBold(true);
		
		int memoRowSize = Integer.parseInt(StringUtil.nvl(memo.get("rowSize"),"2"));
		int memoColSize = Integer.parseInt(StringUtil.nvl(memo.get("colSize"),"2"));
		String memoText = StringUtil.nvl(memo.get("text"));
	
		CreationHelper ch = worksheet.getWorkbook().getCreationHelper();
	    ClientAnchor anchor = ch.createClientAnchor();
	    
	    anchor.setCol1(j+1);                 
	    anchor.setDx1(("HSSF".equals(excelType))?10*15:10*Units.EMU_PER_PIXEL); // plus 10 px     
	    anchor.setCol2(j+memoColSize);                          
	    anchor.setDx2(("HSSF".equals(excelType))?10*15:10*Units.EMU_PER_PIXEL); // plus 10 px    
	    anchor.setRow1(rowNum-1);                                
	    anchor.setDy1(("HSSF".equals(excelType))?10*15:10*Units.EMU_PER_PIXEL); // plus 10 px
	    anchor.setRow2(rowNum + memoRowSize);                               
	    anchor.setDy2(("HSSF".equals(excelType))?10*15:10*Units.EMU_PER_PIXEL); // plus 10 px
	    
	    Drawing drawing = worksheet.createDrawingPatriarch();
		Comment comment = drawing.createCellComment(anchor);
		
		RichTextString rtStr = ch.createRichTextString(memoText);
		rtStr.applyFont(fontMemo);
	    comment.setString(rtStr);
	    comment.setAuthor("author");
	    
	    //---[ SXSSF 인 경우 필요 ]---
	    comment.setRow(rowNum);
	    comment.setColumn(j);
	    //------------------------
	    
	    worksheet.getRow(rowNum).getCell(j).setCellComment(comment);
				
	}

/*	
   [사용예1]
	var excelGrid = {
	           colModel:[
			               {label:'No.',   name:'lineNo',  align:'center', width:'1000'},
			               {label:'이름',   name:'userNm',   align:'left',   width:'5000', defaultValue:'이름없음'},
			               {label:'수강인원', name:'cnt'    , align:'right',  width:'5000', prefix:'앞첨자', suffix:'뒷첨자'},
			               {label:'수강상태', name:'enrlSts', align:'center',  width:'3000', codes:{E:'신청',S:'승인',N:'반려',D:'삭제'}},
			               {label:'날짜',    name:'regDttm', align:'center',  width:'7000', formatter:'date', formatOptions:{srcformat:'yyyyMMddHHmmss', newformat:'yyyy.MM.dd(HH:mm:ss)', defaultValue:'-'}},
			               {label:'금액',    name:'price'   , align:'right',  width:'8000',  suffix:'원' ,formatter:'number', formatOptions:{pattern:'#,###.#####', defaultValue:'0.00'}},
	                     ]
   };
   
   [ 사용예2 : footerRow 존재]
	var excelGrid = {
			   footerRow : 'true',  
			   footerRowColspan:[ 
				                  {firstCol:0, lastCol:2},
				                  {firstCol:3, lastCol:6}
			                    ],
	           colModel:[
			               {label:'No.',       name:'lineNo',  align:'center',  width:'1000',   footer:{prefix:'합 계(colspan(0~2))', suffix:'', type:'', align:'left'}},
			               {label:'이름',       name:'userNm',   align:'left',   width:'5000'},
			               {label:'아이디',      name:'stdNo',   align:'left',    width:'5000'},
			               {label:'학과',        name:'deptNm',  align:'left',   width:'5000',   footer:{prefix:'합 계(colspan(3~6)', suffix:'', type:'', align:'right'}},
			               {label:'수강상태',     name:'enrlSts', align:'center',  width:'3000',  codes:{E:'신청',S:'승인',N:'반려',D:'삭제'}},
			               {label:'휴대전화번호',  name:'mobile',  align:'center',  width:'5000',  prefix:'(010)', suffix:'(...)'},
			               {label:'이메일',      name:'email',   align:'left',    width:'7000'},
			               {label:'합계(sum)',   name:'score',  align:'right',   width:'7000',   suffix:'원', formatter:'number', formatOptions:{pattern:'#,###.#####', defaultValue:'0.00'}, footer:{prefix:'(총)', suffix:'(원)', type:'sum'}},
			               {label:'갯수(count)', name:'score',  align:'right',   width:'7000',   footer:{prefix:'(Total)', suffix:'(원)', type:'count'}},
			               {label:'평균(avg)',   name:'score',  align:'right',   width:'7000',   footer:{prefix:'(평균)',   suffix:'(원)', type:'avg'}},
			               {label:'최소(min)',   name:'score',  align:'right',   width:'7000',   footer:{prefix:'(최소)',   suffix:'(원)', type:'min'}},
			               {label:'최대(max)',   name:'score',  align:'right',   width:'7000',   footer:{prefix:'(최대)',   suffix:'(원)', type:'max'}}
	                     ]
    };
    
   [ 사용예3 : 엑셀 헤더(headerRow) 에 대한 colspan]
	var excelGrid = {
			   headerRowColspan:[ 
				                  {firstCol:1, lastCol:2},
				                  {firstCol:3, lastCol:5}
			                    ],
			   parentHeaderRowColspan: [
			                       {firstCol:1, lastCol:2, label: '라벨1'},
			                       {firstCol:3, lastCol:4, label: '라벨2'},
			                    ],
	           colModel:[
			               {label:'No.',   name:'lineNo', align:'center',  width:'1000'},
			               {label:'기간',   name:'from',   align:'center',  width:'5000', defaultValue:'2021.07.01'},
			               {label:'기간',   name:'to',     align:'center',  width:'5000', defaultValue:'2021.07.31' },
			               {label:'그룹',   name:'group1', align:'center',  width:'5000', defaultValue:'A'},
			               {label:'그룹',   name:'group2', align:'center',  width:'5000', defaultValue:'B'},
			               {label:'그룹',   name:'group3', align:'center',  width:'5000', defaultValue:'C'},
	                     ]
    };    
    
    [사용예4: 컬럼 연산(method 옵션)]
	var excelGrid = {
	           colModel:[
	                       {id:'from', label:'시작일', name:'from', align:'center',  width:'7000', defaultValue:'2021.07.01'},
					       {id:'to',   label:'종료일', name:'to',   align:'center',  width:'7000', defaultValue:'2021.07.31'},
				           {           label:'시작일~종료일', name:'fromTo', align:'center',  width:'10000', method :'conCat', methodOptions:{args:['id:from','str: ~ ','id:to']} },
				           {           label:'문자열더하기', name:'tempStr', align:'left',  width:'10000', method :'conCat', methodOptions:{args:['str:철수가','str: 지하철을 타고 ','str:학교에', 'str:간다.']} },
	                     ]
   };
   
   [ 사용예5: 엑셀 '데이터 유효성 검사'(validat 옵션)]
		var excelGrid = {
		           colModel:[
		        	           {label:'No.',                          name:'lineNo',  align:'center',  width:'1000'},
		        	           {label:'리스트',                         name:'validat', align:'left',    width:'5000', validat:'explicitList', validatOptions:{formula1:['리스트1','리스트2','리스트3'], promptBox:{title:'리스트컬럼',text:'해당하는 값만 허용'}, errorBox:{title:'입력에러',text:'리스트의 값을 선택하세요.'}}},  
				               
				               {label:'',                             name:'empt',    align:'center',  width:'1000'},
				               {label:'BETWEEN(integer)',             name:'validat', align:'right',   width:'7000', validat:'integer',    validatOptions:{operatorType:'BETWEEN',          formula1:'10',   formula2:'20',   promptBox:{title:'유효값',text:'10~20 사이 정수'},    errorBox:{title:'입력에러',text:'10~20 사이 정수만 넣으세요.'}}},
				               {label:'NOT_BETWEEN(integer)',         name:'validat', align:'right',   width:'7000', validat:'integer',    validatOptions:{operatorType:'NOT_BETWEEN',      formula1:'10',   formula2:'20',   promptBox:{title:'유효값',text:'10~20 제외 정수'},    errorBox:{title:'입력에러',text:'10~20 제외 정수만 넣을 수 있습니다.'}}},
				               {label:'EQUAL(integer)',               name:'validat', align:'right',   width:'7000', validat:'integer',    validatOptions:{operatorType:'EQUAL',            formula1:'10',                    promptBox:{title:'유효값',text:'10만 가능'},         errorBox:{title:'입력에러',text:'10만 넣으세요.'}}},
				               {label:'NOT_EQUAL(integer)',           name:'validat', align:'right',   width:'7000', validat:'integer',    validatOptions:{operatorType:'NOT_EQUAL',        formula1:'10',                    promptBox:{title:'유효값',text:'10제외 정수만 가능'},   errorBox:{title:'입력에러',text:'10제외 정수만 가능합니다.'}}},
				               {label:'GREATER_THAN(integer)',        name:'validat', align:'right',   width:'7000', validat:'integer',    validatOptions:{operatorType:'GREATER_THAN',     formula1:'10',                    promptBox:{title:'유효값',text:'10 보다 큰 정수'},     errorBox:{title:'입력에러',text:'10 보다 큰 정수만 넣으세요.'}}},
				               {label:'LESS_THAN(integer)',           name:'validat', align:'right',   width:'7000', validat:'integer',    validatOptions:{operatorType:'LESS_THAN',        formula1:'10',                    promptBox:{title:'유효값',text:'10 보다 작은 정수'},    errorBox:{title:'입력에러',text:'10 보다 작은 정수만 넣으세요.'}}},
				               {label:'GREATER_OR_EQUAL(integer)',    name:'validat', align:'right',   width:'7000', validat:'integer',    validatOptions:{operatorType:'GREATER_OR_EQUAL', formula1:'10',                    promptBox:{title:'유효값',text:'10 이상 정수'},       errorBox:{title:'입력에러',text:'10 이상 정수만 넣으세요.'}}},
				               {label:'LESS_OR_EQUAL(integer)',       name:'validat', align:'right',   width:'7000', validat:'integer',    validatOptions:{operatorType:'LESS_OR_EQUAL',    formula1:'10',                    promptBox:{title:'유효값',text:'10 이하 정수'},       errorBox:{title:'입력에러',text:'10 이하 정수만 넣으세요.'}}},
				               
				               {label:'',                             name:'empt',    align:'center',  width:'1000'},
				               {label:'BETWEEN(decimal)',             name:'validat', align:'right',   width:'7000', validat:'decimal',    validatOptions:{operatorType:'BETWEEN',          formula1:'10.5', formula2:'20.5', promptBox:{title:'유효값',text:'10.5~20.5 사이 실수'}, errorBox:{title:'입력에러',text:'10.5~20.5 사이 실수만 넣으세요.'}}},
				               {label:'NOT_BETWEEN(decimal)',         name:'validat', align:'right',   width:'7000', validat:'decimal',    validatOptions:{operatorType:'NOT_BETWEEN',      formula1:'10.5', formula2:'20.5', promptBox:{title:'유효값',text:'10.5~20.5 제외 실수'}, errorBox:{title:'입력에러',text:'10.5~20.5 제외 실수만 넣을 수 있습니다.'}}},
				               {label:'EQUAL(decimal)',               name:'validat', align:'right',   width:'7000', validat:'decimal',    validatOptions:{operatorType:'EQUAL',            formula1:'10.5',                  promptBox:{title:'유효값',text:'10.5만 가능'},        errorBox:{title:'입력에러',text:'10.5만 넣으세요.'}}},
				               {label:'NOT_EQUAL(decimal)',           name:'validat', align:'right',   width:'7000', validat:'decimal',    validatOptions:{operatorType:'NOT_EQUAL',        formula1:'10.5',                  promptBox:{title:'유효값',text:'10.5제외 실수만 가능'},  errorBox:{title:'입력에러',text:'10.5제외 실수만 가능합니다.'}}},
				               {label:'GREATER_THAN(decimal)',        name:'validat', align:'right',   width:'7000', validat:'decimal',    validatOptions:{operatorType:'GREATER_THAN',     formula1:'10.5',                  promptBox:{title:'유효값',text:'10.5 보다 큰 실수'},    errorBox:{title:'입력에러',text:'10.5 보다 큰 실수만 넣으세요.'}}},
				               {label:'LESS_THAN(decimal)',           name:'validat', align:'right',   width:'7000', validat:'decimal',    validatOptions:{operatorType:'LESS_THAN',        formula1:'10.5',                  promptBox:{title:'유효값',text:'10.5 보다 작은 실수'},  errorBox:{title:'입력에러',text:'10.5 보다 작은 실수만 넣으세요.'}}},
				               {label:'GREATER_OR_EQUAL(decimal)',    name:'validat', align:'right',   width:'7000', validat:'decimal',    validatOptions:{operatorType:'GREATER_OR_EQUAL', formula1:'10.5',                  promptBox:{title:'유효값',text:'10.5 이상 실수'},      errorBox:{title:'입력에러',text:'10.5 이상 실수만 넣으세요.'}}},
				               {label:'LESS_OR_EQUAL(decimal)',       name:'validat', align:'right',   width:'7000', validat:'decimal',    validatOptions:{operatorType:'LESS_OR_EQUAL',    formula1:'10.5',                  promptBox:{title:'유효값',text:'10.5 이하 실수'},      errorBox:{title:'입력에러',text:'10.5 이하 실수만 넣으세요.'}}},
				               
				               {label:'',                          	  name:'empt',    align:'center',  width:'1000'},
				               {label:'BETWEEN(textLength)',    	  name:'validat', align:'left',    width:'7000', validat:'textLength', validatOptions:{operatorType:'BETWEEN',          formula1:'2',    formula2:'3',    promptBox:{title:'유효값',text:'글자길이 2~3'},        errorBox:{title:'입력에러',text:'글자길이 2~3만 입력 가능합니다.'}}},
				               {label:'NOT_BETWEEN(textLength)',      name:'validat', align:'left',    width:'7000', validat:'textLength', validatOptions:{operatorType:'NOT_BETWEEN',      formula1:'2',    formula2:'3',    promptBox:{title:'유효값',text:'글자길이 2~3 입력 못함'}, errorBox:{title:'입력에러',text:'글자길이 2~3 은 입력하지 못합니다.'}}},
				               {label:'EQUAL(textLength)',            name:'validat', align:'left',    width:'7000', validat:'textLength', validatOptions:{operatorType:'EQUAL',            formula1:'2',                     promptBox:{title:'유효값',text:'글자길이 2'},          errorBox:{title:'입력에러',text:'글자길이 2 만 가능합니다.'}}},
				               {label:'NOT_EQUAL(textLength)',        name:'validat', align:'left',    width:'7000', validat:'textLength', validatOptions:{operatorType:'NOT_EQUAL',        formula1:'2',                     promptBox:{title:'유효값',text:'글자길이 2는 불가능'},    errorBox:{title:'입력에러',text:'글자길이 2는 넣지 못합니다.'}}},
				               {label:'GREATER_THAN(textLength)',     name:'validat', align:'left',    width:'7000', validat:'textLength', validatOptions:{operatorType:'GREATER_THAN',     formula1:'2',                     promptBox:{title:'유효값',text:'글자길이 2 보다 큰값'},   errorBox:{title:'입력에러',text:'글자길이 2 보다 커야 합니다.'}}},
				               {label:'LESS_THAN(textLength)',        name:'validat', align:'left',    width:'7000', validat:'textLength', validatOptions:{operatorType:'LESS_THAN',        formula1:'2',                     promptBox:{title:'유효값',text:'글자길이 2 보다 작은값'}, errorBox:{title:'입력에러',text:'글자길이 2 보다 작아야 합니다.'}}},
				               {label:'GREATER_OR_EQUAL(textLength)', name:'validat', align:'left',    width:'7000', validat:'textLength', validatOptions:{operatorType:'GREATER_OR_EQUAL', formula1:'2',                     promptBox:{title:'유효값',text:'글자길이 2 이상'},      errorBox:{title:'입력에러',text:'글자길이 2 이상 입력하세요.'}}},
				               {label:'LESS_OR_EQUAL(textLength)',    name:'validat', align:'left',    width:'7000', validat:'textLength', validatOptions:{operatorType:'LESS_OR_EQUAL',    formula1:'2',                     promptBox:{title:'유효값',text:'글자길이 2 이하'},      errorBox:{title:'입력에러',text:'글자길이 2 이하 입력하세요.'}}},
		                     ]
	    };
	     
    [ 사용예6: 헤더 말풍선(headerMemo 옵션)] validatOptions 의 promptBox 를 사용하면 모든 셀에 설명박스가 나타나므로, promptBox 대신 headerMemo 사용을 권함
    
		var excelGrid = {
		           colModel:[
		                       {label:'No.',               name:'lineNo',  align:'center',  width:'1000'},
		        	           {label:'BETWEEN(integer)',  name:'validat', align:'right',   width:'7000',  headerMemo:{rowSize:'1',colSize:'2',text:'[유효값]\n10~20 사이 정수'}, validat:'integer',  validatOptions:{operatorType:'BETWEEN', formula1:'10', formula2:'20', errorBox:{title:'입력에러',text:'10~20 사이 정수만 넣으세요.'}}},
		                     ]
	    };	    
   
   
    [ 사용예7 : 엑셀 업로드에 사용하려면 colums 옶션을 추가한다.]
    var excelExampleGrid = {
        colModel:[
		               {label:'학번',		name:'userId',	  align:'left',	 width:'5000' ,colums:'A'},
		               {label:'평가점수',	name:'evalScore', align:'right', width:'5000' ,colums:'B'}
                  ]
    };
    
    ===================================================================================================================================================================
    footerRow : 'true'     // 합계,갯수,평균,최소,최대 값을 마지막 행에 추가할 때 사용 
                              
    footerRowColspan : []  //footerRow 가 true 인 경우 사용, footerRow 의 column span 을 결정한다.
                             firstCol, lastCol 을 key 값으로 가지는 Map 의 배열로 구성
                             
    headerRowColspan : []  //엑셀 헤더(headerRow) 의 column span 을 결정한다.
                             firstCol, lastCol 을 key 값으로 가지는 Map 의 배열로 구성                             
    parentHeaderRowColspan : []  //엑셀 헤더(headerRow) 의 column span 을 결정한다.
                             firstCol, lastCol, label 을 key 값으로 가지는 Map 의 배열로 구성     
    colMOdel:[]            //엑셀 출력할 column 에 대한 속성
                            {id:'', label:'',   name:'',   align:'', width:'', defaultValue:'' ,prefix:'', suffix:'', footer:{prefix:'', suffix:'', type:'', align:''},  codes:{code1:'val1',code2:'val2', ...}, formatter:'', formatOptions:{}, colums:'', method:'', methodOptions:{}, headerMemo:{}, validat:'', validatOptions{} },
                            
                            [id]     : method 옵션을 사용하여 컬럼 연산이 필요할 때 사용 ( 중복 id 사용 불가능 )
                            [label]  : 엑셀 헤더(headerRow)에 출력할 글자
                            [name]   : 출력할 쿼리 column 을 mapping ( 중복 name 사용 가능)
                            [align]  : 정렬(left, center, right)
                            [width]  : column 폭 길이
                            [defaultValue]  : 디폴트값
                                           formatOptions 과 같이 사용하는 경우,  formatOptions 의 defaultValue 우선순위가 높다. 
                                           methodOptions 과 같이 사용하는 경우,  methodOptions 의 defaultValue 우선순위가 높다. 
                                
                            [prefix] : 앞첨자
                            [suffix] : 뒷첨자
                            
                            [footer] : footerRow 가 true 인 경우 사용
                              prefix : 앞첨자
                              suffix : 뒷첨자
                              type   : 계산방식(sum, count, avg, min, max)
                              align  : 정렬(left, center, right) , footer 에서 정의한 align 이 외부의 align 보다 우선 적용된다.
                              
                            [codes]
                              name 에 설정된 column 이 코드값이 경우, 그 코드값에 대한 코드명을 가지고 온다.
                                                    예를 들어                      
                              {label:'수강상태', name:'enrlSts', align:'center',  width:'3000',  codes:{E:'신청',S:'승인',N:'반려',D:'삭제'}},
                              
                                                      인 경우, enrlSts 의 값이 S 인 경우 '승인' 으로 출력된다.
                                                      
                            [formatter] : number, date 두가지 옵션이 있으며 숫자와 날짜의 포맷 설정
                            
                                    number : 숫자를 기본 포맷으로 변경(천단위 컴마(#,###))                      , formatOptions 을 사용하여 포맷 변경 가능
                                    date   : yyyyMMddHHmmss 형식의 날짜를 yyyy.MM.dd(HH:mm:ss) 형식으로 변경  , formatOptions 을 사용하여 포맷 변경 가능
                                           
                            [formatOptions] : formatter 에 대한 세부 옵션 설정
                                
                                (사용예1, 숫자) formatter:'number', formatOptions:{pattern:'#,###.#####', defaultValue:'0.00'}
                                             //pattern 은 자바 DecimalFormat 객체의 pattern 사용
                               
                                
                                (사용예2, 날짜) formatter:'date', formatOptions:{srcformat:'yyyyMMddHHmmss', newformat:'yyyy.MM.dd(HH:mm:ss)', defaultValue:'-'}
                                             //srcformat, newformat 은 SimpleDateFormat 의 pattern 사용
                            
                            [method] : methodOptions 을 바탕으로 컬럼 연산 수행, 연산하고자 하는 컬럼에 id 값을 부여할 것
                            
                                       conCat : 원하는 컬럼 및 문자열을 더한다. 사용예는 아래 methodOptions 에서 확인
                                           
                            [methodOptions] : method 에 대한 세부 옵션 설정
                                
                                (사용예1, conCat ) methodOptions:{args:['id:from','str: ~ ','id:to'], defaultValue:''}
                                
                                                 args 는  'id:컬럼', 또는 'str:원하는문자열' 로 이루어진 배열이다.
                                
                                                 {id:'from', label:'시작일', name:'from', align:'center',  width:'7000', defaultValue:'2021.07.01'},
					                             {id:'to',   label:'종료일', name:'to',   align:'center',  width:'7000', defaultValue:'2021.07.31'},
				                                 {           label:'시작일~종료일', name:'fromTo', align:'center',  width:'10000', method :'conCat', methodOptions:{args:['id:from','str: ~ ','id:to']} },
                               
                                                                                      위의 예에서 args:['id:from','str: ~ ','id:to'] 인데, 이것은 form ~ to 형식으로 문자열을 더한다. 
                                                                                      
                                                                                      다음과 같이 임의의 조합이 가능하다.
                                                                                      
                                                   args:['id:from','str: ~ ','id:to']
                                                   args:['str:철수가','str: 지하철을 타고 ','str:학교에', 'str:간다.']
                                                                                      
                            [headerMemo] : 엑셀 header 에 말풍선 삽입 ( 사용예6 참고)
                                           
                                           headerMemo:{rowSize:'1',colSize:'2',text:'[유효값]\n10~20 사이 정수'}
                                           [rowSize] : 말풍선 가로 길이(디폴트 : 2), 자연수 입력( 정확하진 않지만 대충 행의 수라 생각하자.)
                                           [colSize] : 말풍선 세로 길이(디폴트 : 2), 자연수 입력(1~2 정도추천, colSize 만큼의 엑셀 열을 점령한다.)
                                           [text]    : 메모내용, \n 을 사용하여 줄바꿈 가능
                                           
                                           
                            [validat] : 엑셀 '데이터 유효성 검사' 옵션 ( 사용예5 참고 )
                                       explicitList, integer, decimal, textLength 값이 올 수 있다.
                                       formulaList 은 현재 미사용으로 주석 처리 해둠. ( 위에 정의된 setValidat() 함수 참고)                        
                            
                            [validatOptions] : validat 에 대한 세부 옵션 설정 ( 사용예5 참고 )
                                       
                                      [operatorType] : validat 값이  integer, decimal, textLength 인 경우만 사용, 아래의 7 가지값이 가능
                                                 
                                                 [BETWEEN]     : formula1 <= 값  <= formula2
                                                 [NOT_BETWEEN] : ( 값 < formula1 ) or ( formula2 < 값 )
                                                 [EQUAL]       : formula1 = 값
                                                 [GREATER_THAN]: 값 > formula1 
                                                 [LESS_THAN]        : 값 < formula1
                                                 [GREATER_OR_EQUAL] : 값 >= formula1
                                                 [LESS_OR_EQUAL]    : 값 <= formula1
                                                 
                                      [formula1]  : 유효값1
                                      [formula2]  : 유효값2
                                      [promptBox] : 설명박스(셀 클릭시 나타나는 설명박스), 옵션이 존재하지 않으면 설명박스는 나타나지 않는다. 
                                      [errorBox]  : 에러박스 (잘못된 값을 입력시 나나탐),  옵션이 존재하지 않으면 에러박스는 나타나지 않는다.
                                
                            [colums]  : 엑셀 업로드시 사용, 엑셀에서의 데이터 읽을 세로 컬럼 명칭
                            [wrapText]: "true" // 셀에 여러줄로 표시
*/   
   @SuppressWarnings("unchecked")
   public Workbook simpleGrid(HashMap<String, Object> map)  {
	    String title = StringUtil.nvl(map.get("title"));
	    String sheetName = StringUtil.nvl(map.get("sheetName"),"sheet1");
	    String[] searchValues = (String[]) map.get("searchValues");
	    String excelGrid = StringUtil.nvl(map.get("excelGrid"));
        List<?> list = (List<?>) map.get("list");
        
        Map<String, Object> excelGridMap = null;
		try {
			excelGridMap = (HashMap<String, Object>) JsonUtil.jsonToMap(excelGrid);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		String footerRow = StringUtil.nvl(excelGridMap.get("footerRow"));
		List footerRowColspanList = null;
		if("true".equals(footerRow) && excelGridMap.get("footerRowColspan") != null) {
			footerRowColspanList = (List) excelGridMap.get("footerRowColspan");
		}
		List headerRowColspanList = (List) excelGridMap.get("headerRowColspan");
		List parentHeaderRowColspanList = (List) excelGridMap.get("parentHeaderRowColspan");
        List colModelList = (List) excelGridMap.get("colModel");
        
        
        Object obj = null;
        String className = "";
        Class cls = null;
        
        if(list != null && list.size() > 0) {
    		obj = list.get(0);
        	className = obj.getClass().getName();
        	cls = (Class) getClassForName(className);
        }
        
        /*Class cls = null;
        try {
			cls = Class.forName(className);
		} catch (ClassNotFoundException e1) {
			e1.printStackTrace();
		}*/
			
	    Method meth = null;
	    HashMap<String, Object> footerRowColspanInfo = null;
	    HashMap<String, Object> headerRowColspanInfo = null;
	    HashMap<String, Object> parnetHeaderRowRowspanInfo = null;
	    HashMap<String, Object> columnInfo = null;
	    HashMap<String, Object> codes = null;
	    HashMap<String, Object> footer = null;
	    HashMap<String, String> cellvalueMap = new HashMap<String, String>();
	    
	    String align = "";
	    String wrapText = "";
	    String prefix = "";
	    String suffix = "";
	    String cellvalue = "";
	    String type = "";
       
        int colSize = colModelList.size();
        double[][] footerVal = new double[2][colSize];
        String[][] footerValText = new String[2][colSize];
        List<Integer> methodColList = new ArrayList<Integer>();
        List<Integer> validatColList = new ArrayList<Integer>();
	   
        String ext = StringUtil.nvl(map.get("ext"));
	    if(StringUtil.isNull(ext)) {
		   ext = ".xlsx";
	    }
	
	    Workbook workbook = null;
		if(".xls".equals(ext)) {
			workbook = new HSSFWorkbook();
		}else if(".xlsx".equals(ext)){
			workbook = new XSSFWorkbook();
		}else if(".xlsx(big)".equals(ext)){
			workbook = new SXSSFWorkbook();
			ext = ".xlsx";
		}
	   
	    Sheet worksheet = null;
		Row row = null;
		
		//폰트 설정
		Font fontTitle = workbook.createFont();
		//fontTitle.setFontName("나눔고딕"); //글씨체
		fontTitle.setFontHeight((short)(16*25)); //사이즈
		fontTitle.setBold(true);		
		
		//폰트 설정
		Font font1 = workbook.createFont();
		font1.setFontName("나눔고딕"); //글씨체
		font1.setFontHeight((short)(16*10)); //사이즈
		font1.setBold(true);
		
		// 셀 스타일 및 폰트 설정
		CellStyle styleTitle = workbook.createCellStyle();
		//정렬
		styleTitle.setAlignment(HorizontalAlignment.CENTER);     
		styleTitle.setVerticalAlignment(VerticalAlignment.CENTER);
		
		//테두리 선 (우,좌,위,아래)
		styleTitle.setBorderRight(BorderStyle.NONE);
		styleTitle.setBorderLeft(BorderStyle.NONE);
		styleTitle.setBorderTop(BorderStyle.NONE);
		styleTitle.setBorderBottom(BorderStyle.NONE);
		styleTitle.setFont(fontTitle);
		
		// 셀 스타일 및 폰트 설정
		CellStyle styleSearchLeft = workbook.createCellStyle();
		//정렬
		styleSearchLeft.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
		styleSearchLeft.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
		//테두리 선 (우,좌,위,아래)
		styleSearchLeft.setBorderRight(BorderStyle.NONE);
		styleSearchLeft.setBorderLeft(BorderStyle.NONE);
		styleSearchLeft.setBorderTop(BorderStyle.NONE);
		styleSearchLeft.setBorderBottom(BorderStyle.NONE);
		//styleSearchLeft.setFont(font1);
		
		// 셀 스타일 및 폰트 설정
		HSSFCellStyle styleHeaderHSS = null;
		XSSFCellStyle styleHeaderXSS = null;
		if(workbook instanceof HSSFWorkbook) {
			styleHeaderHSS = (HSSFCellStyle) workbook.createCellStyle();
			//정렬
			styleHeaderHSS.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
			styleHeaderHSS.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
			//배경색
			styleHeaderHSS.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			styleHeaderHSS.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			styleHeaderHSS.setFont(font1);
			
		}else if(workbook instanceof XSSFWorkbook || workbook instanceof SXSSFWorkbook){
			styleHeaderXSS = (XSSFCellStyle) workbook.createCellStyle();
			//정렬
			styleHeaderXSS.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
			styleHeaderXSS.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
			//배경색
			styleHeaderXSS.setFillForegroundColor(new XSSFColor(new java.awt.Color(192, 192, 192) )); //회색
			//styleHeaderXSS.setFillForegroundColor(new XSSFColor(new java.awt.Color(178, 235, 244) ));
			//styleHeaderXSS.setFillForegroundColor(new XSSFColor(new java.awt.Color(245, 249, 251) )); // jsp 그리드 헤더 색
			styleHeaderXSS.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			styleHeaderXSS.setFont(font1);
		}
		
		// 셀 스타일 및 폰트 설정
		CellStyle styleLeft = workbook.createCellStyle();
		//정렬
		styleLeft.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
		styleLeft.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
		
		// 셀 스타일 및 폰트 설정
		CellStyle styleCenter = workbook.createCellStyle();
		//정렬
		styleCenter.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
		styleCenter.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
				
		// 셀 스타일 및 폰트 설정
		CellStyle styleRight = workbook.createCellStyle();
		//정렬
		styleRight.setAlignment(HorizontalAlignment.RIGHT); //오른쪽 정렬
		styleRight.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
		
	    // 새로운 sheet를 생성한다.
	    worksheet = workbook.createSheet(sheetName.replaceAll("[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]", ""));
	    
	    // 칼럼 길이 설정
	    for(int j=0;j<colModelList.size();j++) {
    		columnInfo = (HashMap<String, Object>) colModelList.get(j);
    		worksheet.setColumnWidth(j, StringUtil.nvl(columnInfo.get("width"), 0));
    	}
	    
	    int rowNum = -1;
	    
	    // TITLE
	    row = worksheet.createRow(++rowNum);
	    for(int j=0;j<colSize;j++) {
	    	row.createCell(j).setCellValue(title); row.getCell(j).setCellStyle(styleTitle);
	    }
	    // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
	    if(colSize>1) {
	    	worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, colSize-1));
	    }
	    
	    
	    // 빈행
	    row = worksheet.createRow(++rowNum);
	    for(int j=0;j<colSize;j++) {
	    	row.createCell(j).setCellValue(""); //row.getCell(j).setCellStyle(styleTitle);
	    }
	    // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
	    if(colSize>1) {
	        worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, colSize-1));
	    }
	    
	    // 검색조건
	    if(searchValues != null) {
		    for(int i=0;i<searchValues.length;i++) {	
		    	
		    	row = worksheet.createRow(++rowNum);
			    row.createCell(0).setCellValue(searchValues[i]); row.getCell(0).setCellStyle(styleSearchLeft);
			    for(int j=1;j<colSize;j++) {
			    	row.createCell(j).setCellValue(""); row.getCell(j).setCellStyle(styleSearchLeft);
			    }
			    // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
			    if(colSize>1) {
			    	worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, colSize-1));
			    }
			    
		    }
	    
		    // 빈행
		    row = worksheet.createRow(++rowNum);
		    for(int j=0;j<colSize;j++) {
		    	row.createCell(j).setCellValue(""); //row.getCell(j).setCellStyle(styleTitle);
		    }
		    // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
		    if(colSize>1) {
		    	worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, colSize-1));
		    }
	    }
	    
	    // 헤더(headerRow) 설정
	 
	    // 부모 헤더 옵션
	    Row parentRow = null;
        if(parentHeaderRowColspanList != null) {
            parentRow = worksheet.createRow(++rowNum);
        }
        
        row = worksheet.createRow(++rowNum);
        
        //row.setHeight((short)400);
	    for(int j=0;j<colModelList.size();j++) {
    		columnInfo = (HashMap<String, Object>) colModelList.get(j);
    		row.createCell(j).setCellValue(StringUtil.nvl(columnInfo.get("label"))); 
    		if(workbook instanceof HSSFWorkbook) {
    		    row.getCell(j).setCellStyle(styleHeaderHSS);
    		}else if(workbook instanceof XSSFWorkbook || workbook instanceof SXSSFWorkbook){
    			row.getCell(j).setCellStyle(styleHeaderXSS);
    		}
    		
    		//headerMemo 옵션이 존재(말풍선)
			if(columnInfo.get("headerMemo") != null) {
				setMemo(rowNum, j ,worksheet,(HashMap<String, Object>) columnInfo.get("headerMemo"));
			}
    		
    	}
	    // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
    	if(headerRowColspanList != null) {
	    	for(int j=0;j<headerRowColspanList.size();j++) {
	    		headerRowColspanInfo = (HashMap<String, Object>) headerRowColspanList.get(j);
	            int firstCol = StringUtil.nvl(headerRowColspanInfo.get("firstCol"),0);
	            int lastCol = StringUtil.nvl(headerRowColspanInfo.get("lastCol"),0);
	            
	            worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, firstCol, lastCol));
	        }	    		
    	}
    	
    	// 부모 헤더 옵션
        if(parentHeaderRowColspanList != null && parentRow != null) {
            int parentRowNum = rowNum - 1;
            CellStyle styleParentHeader = workbook.createCellStyle();
            
            styleParentHeader.setFont(font1);
            styleParentHeader.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
            styleParentHeader.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
            try {
                Set<Integer> parentMergeSet = new HashSet<>();
                
                for(int j=0;j<parentHeaderRowColspanList.size();j++) {
                    parnetHeaderRowRowspanInfo = (HashMap<String, Object>) parentHeaderRowColspanList.get(j);
                    int firstCol = StringUtil.nvl(parnetHeaderRowRowspanInfo.get("firstCol"), 0);
                    int lastCol = StringUtil.nvl(parnetHeaderRowRowspanInfo.get("lastCol"), 0);
                    String label = StringUtil.nvl(parnetHeaderRowRowspanInfo.get("label"));
                    worksheet.addMergedRegion(new CellRangeAddress(parentRowNum, parentRowNum, firstCol, lastCol));
                    parentRow.createCell(firstCol).setCellValue(label);
                    parentRow.getCell(firstCol).setCellStyle(styleParentHeader);
                    
                    for(int k = firstCol; k <= lastCol; k++) {
                        parentMergeSet.add(k);
                    }
                }
                
                int cellLen = row.getLastCellNum();
                CellStyle styleChildHeader = workbook.createCellStyle();
                styleChildHeader.setFont(font1);
                styleChildHeader.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
                styleChildHeader.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
                styleChildHeader.setBorderBottom(BorderStyle.THIN);
                for(int j=0; j < cellLen; j++) {
                    row.getCell(j).setCellStyle(styleChildHeader);
                }
                
                for(int j=0; j < cellLen; j++) {
                    if(!parentMergeSet.contains(j)) {
                        String label = row.getCell(j).getStringCellValue();
                        CellRangeAddress mergedRegion = new CellRangeAddress(rowNum - 1, rowNum, j, j);
                        worksheet.addMergedRegion(mergedRegion);
                        Row firstRow = worksheet.getRow(mergedRegion.getFirstRow());
                        firstRow.createCell(mergedRegion.getFirstColumn()).setCellValue(label);
                        firstRow.getCell(mergedRegion.getFirstColumn()).setCellStyle(styleChildHeader);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
	    // list
	    if(list != null) {
		    for(int i=0;i<list.size();i++) {
		    	obj = list.get(i);
		    	
		    	row = worksheet.createRow(++rowNum);
		    	
		    	for(int j=0;j<colModelList.size();j++) {
		    		columnInfo = (HashMap<String, Object>) colModelList.get(j);
		    		try {
		    			if(obj instanceof Map) {
		    	        
		    			}else { // if( obj instanceof DefaultVO){
		    				try {
		    				   meth = cls.getDeclaredMethod("get"+StringUtil.upperCaseFirst(StringUtil.nvl(columnInfo.get("name"))));
		    				}catch (NoSuchMethodException e) { // method 가 없는 경우 super class 에서 method 존재 검사
		    				   meth = null;
		    				   Class clsSuper = (Class) obj.getClass().getGenericSuperclass();
		    				  while( clsSuper.getName() != "java.lang.Object" && meth == null) {
		    					 try {
		    						 meth = clsSuper.getDeclaredMethod("get"+StringUtil.upperCaseFirst(StringUtil.nvl(columnInfo.get("name"))));
		    					 }catch (NoSuchMethodException e2) {
		    						 //e2.printStackTrace();
		    						 meth = null;
		    						 clsSuper = (Class) clsSuper.getGenericSuperclass();
		    					 }
		    				   }
		    				}
		    	        }
		    		
						try {
							if(obj instanceof Map) { // 에러지점
								cellvalue = StringUtil.nvl(
										// 형변환 오류로 인한 수정
										// ((ListOrderedMap) obj).get(StringUtil.nvl(columnInfo.get("name")))
										((Map) obj).get(StringUtil.nvl(columnInfo.get("name")))
										, StringUtil.nvl(columnInfo.get("defaultValue")) 
										);
			    	        }else { // if( obj instanceof DefaultVO){
			    	        	if(meth != null) {
			    	        	    cellvalue = StringUtil.nvl(meth.invoke(obj), StringUtil.nvl(columnInfo.get("defaultValue")));
			    	        	}else {
			    	        		cellvalue = StringUtil.nvl(columnInfo.get("defaultValue"));
			    	        	}
			    	        }
							
							//footer 옵션이 존재 
							if("true".equals(footerRow) && columnInfo.get("footer") != null) {
								footer = (HashMap<String, Object>) columnInfo.get("footer");
								
								type = StringUtil.nvl(footer.get("type"));
								if("sum".equals(type) || "avg".equals(type)) { // 합계,평균
									if(i == 0) {
										footerVal[0][j] = 0;
									}
									footerVal[0][j] += Double.parseDouble(StringUtil.nvl(cellvalue.replaceAll(",", ""),"0"));
									footer.put("footerVal", footerVal[0][j]);
									//columnInfo.put("footer", footer);
									//colModelList.set(j, columnInfo);
								}else if("min".equals(type) || "max".equals(type)) {
									int reversal = 0;
									
									if("max".equals(type)) {
										reversal = 1;
									}
									if(i == 0) {
										try {
											footerVal[0][j] = Double.parseDouble(cellvalue.replaceAll(",", "")); //이전행 값
											footerValText[0][j]= "";
										}catch(Exception e) {
											footerValText[0][j]= "nodata";
										}
									}
									
									try {
										footerVal[1][j] = Double.parseDouble(cellvalue.replaceAll(",", "")); //현재행 값
										footerValText[1][j]= "";
									}catch(Exception e) {
										footerValText[1][j]= "nodata";
									}
									
									if( "".equals(footerValText[0][j]) && "".equals(footerValText[1][j]) ) {
										footerVal[0][j] = footerVal[0+reversal][j] < footerVal[1-reversal][j] ? footerVal[0][j] : footerVal[1][j];
										footerValText[0][j]= "";
										footer.put("footerVal",footerVal[0][j]);
									}else if("nodata".equals(footerValText[0][j]) && "".equals(footerValText[1][j])){
										footerVal[0][j] = footerVal[1][j];
										footerValText[0][j]= "";
										footer.put("footerVal",footerVal[0][j]);
									}else if("".equals(footerValText[0][j]) && "nodata".equals(footerValText[1][j])) {
										footerValText[0][j]= "";
										footer.put("footerVal",footerVal[0][j]);
									}else if("nodata".equals(footerValText[0][j]) && "nodata".equals(footerValText[1][j])) {
										footer.put("footerVal","");
									}
									
								}
								
							}
							
							//codes 옵션이 존재하면 해당하는 코드에 대한 명을 리턴
							if(columnInfo.get("codes") != null) {
								codes = (HashMap<String, Object>) columnInfo.get("codes");
								cellvalue = StringUtil.nvl(codes.get(cellvalue),StringUtil.nvl(columnInfo.get("defaultValue"))); //코드값으로부터 코드명을 얻는다.
							}
							
							//formatter 옵션이 존재
							if(columnInfo.get("formatter") != null) {
								cellvalue = getFormatString(cellvalue, StringUtil.nvl(columnInfo.get("formatter")), (HashMap<String, Object>) columnInfo.get("formatOptions"));
							}
							
							if(!"".equals(cellvalue)) {
								prefix = StringUtil.nvl(columnInfo.get("prefix")); //앞첨자
								suffix = StringUtil.nvl(columnInfo.get("suffix")); //뒷첨자
							}else {
								prefix = "";
								suffix = "";
							}
							
							//method 옵션이 존재
							if(i==0 && columnInfo.get("method") != null) {
								methodColList.add(j);
							}
							
							// validat 옵션이 존재
							if (i == 0 && columnInfo.get("validat") != null) {
								validatColList.add(j);
							}
							
							if(!"".equals(StringUtil.nvl(columnInfo.get("id")))) {
								cellvalueMap.put(StringUtil.nvl(columnInfo.get("id")), cellvalue);
							}
							
							//if("formula".equals(columnInfo.get("valueType"))){ // 엑셀버전에 따라 사용할 수 있는 공식이 다르니 사용시 주의, 추후 기능 필요한 경우 주석해제하여 사용
								//row.createCell(j).setCellFormula(prefix+cellvalue+suffix); // ex) row.createCell(j).setCellFormula("IF(C6="값1","code1", IF(C6="값2","code2", "없음"))");  
							//}else {
								row.createCell(j).setCellValue(prefix+cellvalue+suffix);
							//}
							
							align = StringUtil.nvl(columnInfo.get("align"));
							wrapText = StringUtil.nvl(columnInfo.get("wrapText"));
							
							styleLeft.setWrapText(true);
							
							if("left".equals(align)) {
							    if("true".equals(wrapText)) {
							        styleLeft.setWrapText(true);
							    }
								row.getCell(j).setCellStyle(styleLeft);
							}else if("center".equals(align)) {
							    if("true".equals(wrapText)) {
							        styleCenter.setWrapText(true);
                                }
								row.getCell(j).setCellStyle(styleCenter);
							}else if("right".equals(align)) {
							    if("true".equals(wrapText)) {
							        styleRight.setWrapText(true);
                                }
								row.getCell(j).setCellStyle(styleRight);
							}else {
							    if("true".equals(wrapText)) {
							        styleCenter.setWrapText(true);
                                }
								row.getCell(j).setCellStyle(styleCenter);
							}
							
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						} catch (IllegalArgumentException e) {
							e.printStackTrace();
						} catch (InvocationTargetException e) {
							e.printStackTrace();
						}
					} catch (SecurityException e) {
						e.printStackTrace();
					}
		    		
		    	}
		    	
		    	//method 처리
		    	for(int j: methodColList) {
		    		columnInfo = (HashMap<String, Object>) colModelList.get(j);
		    		
		    		cellvalue = getMethodVal(cellvalueMap, StringUtil.nvl(columnInfo.get("method")), (HashMap<String, Object>) columnInfo.get("methodOptions"));
		    		cellvalue = StringUtil.nvl(cellvalue, StringUtil.nvl(columnInfo.get("defaultValue")));
		    		
		    		if(!"".equals(cellvalue)) {
						prefix = StringUtil.nvl(columnInfo.get("prefix")); //앞첨자
						suffix = StringUtil.nvl(columnInfo.get("suffix")); //뒷첨자
					}else {
						prefix = "";
						suffix = "";
					}
		    		
		    		
		    		row.getCell(j).setCellValue(prefix+cellvalue+suffix);
		    		
		    	}
		    	
		    }
		    
		    // validat 처리
 			for (int j : validatColList) {
 				columnInfo = (HashMap<String, Object>) colModelList.get(j);
 				
 				// [데이터 유효성 검사] list 에 표시
 				setValidat(rowNum-list.size()+1,rowNum, j ,worksheet, StringUtil.nvl(columnInfo.get("validat")),(HashMap<String, Object>) columnInfo.get("validatOptions"));
 				
 			}
		 			
	    }
	    
	    //footerRow
	    if("true".equals(footerRow)) {
	    	
	    	row = worksheet.createRow(++rowNum);
	    	
	    	for(int j=0;j<colModelList.size();j++) {
	    		
	    		columnInfo = (HashMap<String, Object>) colModelList.get(j);
	    		
	    		prefix = "";
	    		suffix = "";
	    		align = "";
	    		type = "";
	    		cellvalue = "";
	    		
	    		//footer 옵션이 존재
				if(columnInfo.get("footer") != null) {
					footer = (HashMap<String, Object>) columnInfo.get("footer");
					
					prefix = StringUtil.nvl(footer.get("prefix"));
					suffix = StringUtil.nvl(footer.get("suffix"));
					align = StringUtil.nvl(footer.get("align"));
					type = StringUtil.nvl(footer.get("type"));
					
					if(list != null && list.size() > 0) {
						if("sum".equals(type) || "min".equals(type) || "max".equals(type)) {
							cellvalue = StringUtil.nvl(footer.get("footerVal"),"0");
						}else if("count".equals(type)) {
							cellvalue = Integer.toString(list.size());
						}else if("avg".equals(type)) {
							cellvalue = Double.toString(Double.parseDouble(StringUtil.nvl(footer.get("footerVal"),"0"))/list.size());
						}
						
						//formatter 옵션이 존재
						if(columnInfo.get("formatter") != null) {
							cellvalue = getFormatString(cellvalue, StringUtil.nvl(columnInfo.get("formatter")), (HashMap<String, Object>) columnInfo.get("formatOptions"));
						}
					}else {
						cellvalue = "";
					}
				}
				
	    		row.createCell(j).setCellValue(prefix+cellvalue+suffix);
				
				align = "".equals(align) ? StringUtil.nvl(columnInfo.get("align")) : align;
				if("left".equals(align)) {
					row.getCell(j).setCellStyle(styleLeft);
				}else if("center".equals(align)) {
					row.getCell(j).setCellStyle(styleCenter);
				}else if("right".equals(align)) {
					row.getCell(j).setCellStyle(styleRight);
				}else {
					row.getCell(j).setCellStyle(styleCenter);
				}
	    		
	    	}
	    	
		    // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
	    	if(footerRowColspanList != null) {
		    	for(int j=0;j<footerRowColspanList.size();j++) {
		    		footerRowColspanInfo = (HashMap<String, Object>) footerRowColspanList.get(j);
		            int firstCol = StringUtil.nvl(footerRowColspanInfo.get("firstCol"),0);
		            int lastCol = StringUtil.nvl(footerRowColspanInfo.get("lastCol"),0);
		            
		            worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, firstCol, lastCol));
		        }	    		
	    	}
	    
	    }
	    
	    return workbook;
	}
   
   //simpleGrid 에 기능 통합했으니 이 함수를 사용하는곳은 모두 simpleGrid 로 수정 후, simpleBigGrid 는 삭제할 것
   //map.put("ext", ".xlsx(big)"); 옵션을 주고 simpleGrid 를 사용하면 됨.
   @SuppressWarnings("unchecked")
public Workbook simpleBigGrid(HashMap<String, Object> map)  {
       
       String title = StringUtil.nvl(map.get("title"));
       String sheetName = StringUtil.nvl(map.get("sheetName"),"sheet1");
       String[] searchValues = (String[]) map.get("searchValues");
       String excelGrid = StringUtil.nvl(map.get("excelGrid"));
       List<?> list = (List<?>) map.get("list");
       
       Map<String, Object> excelGridMap = null;
       try {
           excelGridMap = (HashMap<String, Object>) JsonUtil.jsonToMap(excelGrid);
       } catch (Exception e) {
           e.printStackTrace();
       }
       
	   String footerRow = StringUtil.nvl(excelGridMap.get("footerRow"));
	   List footerRowColspanList = null;
	   if("true".equals(footerRow) && excelGridMap.get("footerRowColspan") != null) {
	    	footerRowColspanList = (List) excelGridMap.get("footerRowColspan");
	   }
	   List headerRowColspanList = (List) excelGridMap.get("headerRowColspan");
	   List parentHeaderRowColspanList = (List) excelGridMap.get("parentHeaderRowColspan");
       List colModelList = (List) excelGridMap.get("colModel");
       
       
       Object obj = null;
       String className = "";
       Class cls = null;
       if(list != null && list.size() > 0) {
   		obj = list.get(0);
       	className = obj.getClass().getName();
       	cls = (Class) getClassForName(className);
       }
       
       Method meth = null;
       HashMap<String, Object> footerRowColspanInfo = null;
       HashMap<String, Object> headerRowColspanInfo = null;
       HashMap<String, Object> parnetHeaderRowRowspanInfo = null;
       HashMap<String, Object> columnInfo = null;
       HashMap<String, Object> codes = null;
       HashMap<String, Object> footer = null;
       HashMap<String, String> cellvalueMap = new HashMap<String, String>();
       
       String align = "";
       String prefix = "";
       String suffix = "";
       String cellvalue = "";
       String type = "";
      
       int colSize = colModelList.size();
       double[][] footerVal = new double[2][colSize];
       String[][] footerValText = new String[2][colSize];
       List<Integer> methodColList = new ArrayList<Integer>();
       List<Integer> validatColList = new ArrayList<Integer>();
      
       String ext = StringUtil.nvl(map.get("ext"));
       if(StringUtil.isNull(ext)) {
          ext = ".xlsx";
       }
   
       SXSSFWorkbook workbook = new SXSSFWorkbook();
       SXSSFSheet worksheet = null;
       SXSSFRow row = null;
       
       //폰트 설정
       Font fontTitle = workbook.createFont();
       //fontTitle.setFontName("나눔고딕"); //글씨체
       fontTitle.setFontHeight((short)(16*25)); //사이즈
       fontTitle.setBold(true);        
       
       //폰트 설정
       Font font1 = workbook.createFont();
       font1.setFontName("나눔고딕"); //글씨체
       font1.setFontHeight((short)(16*10)); //사이즈
       font1.setBold(true);
       
       // 셀 스타일 및 폰트 설정
       CellStyle styleTitle = workbook.createCellStyle();
       //정렬
       styleTitle.setAlignment(HorizontalAlignment.CENTER);     
       styleTitle.setVerticalAlignment(VerticalAlignment.CENTER);
       //배경색
       //styleTitle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex()); //채우기 선택 
       //styleTitle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
       //테두리 선 (우,좌,위,아래)
       styleTitle.setBorderRight(BorderStyle.NONE);
       styleTitle.setBorderLeft(BorderStyle.NONE);
       styleTitle.setBorderTop(BorderStyle.NONE);
       styleTitle.setBorderBottom(BorderStyle.NONE);
       styleTitle.setFont(fontTitle);
       
       // 셀 스타일 및 폰트 설정
       CellStyle styleSearchLeft = workbook.createCellStyle();
       // 줄바꿈
       styleSearchLeft.setWrapText(true);
       //정렬
       styleSearchLeft.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
       styleSearchLeft.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
       //배경색
       //styleSearchLeft.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
       //styleSearchLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);
       //테두리 선 (우,좌,위,아래)
       styleSearchLeft.setBorderRight(BorderStyle.NONE);
       styleSearchLeft.setBorderLeft(BorderStyle.NONE);
       styleSearchLeft.setBorderTop(BorderStyle.NONE);
       styleSearchLeft.setBorderBottom(BorderStyle.NONE);
       //styleSearchLeft.setFont(font1);
       
       // 셀 스타일 및 폰트 설정
       CellStyle styleHeaderSXSS = (CellStyle) workbook.createCellStyle();
       //정렬
       styleHeaderSXSS.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
       styleHeaderSXSS.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
       //배경색
       styleHeaderSXSS.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
       styleHeaderSXSS.setFillPattern(FillPatternType.SOLID_FOREGROUND);
       //테두리 선 (우,좌,위,아래)
       //styleHeaderXSS.setBorderRight(HSSFCellStyle.BORDER_THIN);
       //styleHeaderXSS.setBorderLeft(HSSFCellStyle.BORDER_THIN);
       //styleHeaderXSS.setBorderTop(HSSFCellStyle.BORDER_THIN);
       //styleHeaderXSS.setBorderBottom(HSSFCellStyle.BORDER_THIN);
       styleHeaderSXSS.setFont(font1);
       
       // 셀 스타일 및 폰트 설정
       CellStyle styleLeft = workbook.createCellStyle();
       //정렬
       styleLeft.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
       styleLeft.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
       //배경색
       //styleLeft.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
       //styleLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);
       //테두리 선 (우,좌,위,아래)
       //styleLeft.setBorderRight(HSSFCellStyle.BORDER_THIN);
       //styleLeft.setBorderLeft(HSSFCellStyle.BORDER_THIN);
       //styleLeft.setBorderTop(HSSFCellStyle.BORDER_THIN);
       //styleLeft.setBorderBottom(HSSFCellStyle.BORDER_THIN);
       //styleLeft.setFont(font1);
       
       // 셀 스타일 및 폰트 설정
       CellStyle styleCenter = workbook.createCellStyle();
       //정렬
       styleCenter.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
       styleCenter.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
       //배경색
       //styleCenter.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
       //styleCenter.setFillPattern(FillPatternType.SOLID_FOREGROUND);
       //테두리 선 (우,좌,위,아래)
       //styleCenter.setBorderRight(HSSFCellStyle.BORDER_THIN);
       //styleCenter.setBorderLeft(HSSFCellStyle.BORDER_THIN);
       //styleCenter.setBorderTop(HSSFCellStyle.BORDER_THIN);
       //styleCenter.setBorderBottom(HSSFCellStyle.BORDER_THIN);
       //styleCenter.setFont(font1);       
       
       // 셀 스타일 및 폰트 설정
       CellStyle styleRight = workbook.createCellStyle();
       //정렬
       styleRight.setAlignment(HorizontalAlignment.RIGHT); //오른쪽 정렬
       styleRight.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
       //배경색
       //styleRight.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
       //styleRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);
       //테두리 선 (우,좌,위,아래)
       //styleRight.setBorderRight(HSSFCellStyle.BORDER_THIN);
       //styleRight.setBorderLeft(HSSFCellStyle.BORDER_THIN);
       //styleRight.setBorderTop(HSSFCellStyle.BORDER_THIN);
       //styleRight.setBorderBottom(HSSFCellStyle.BORDER_THIN);
       //천단위 쉼표, 금액
       //styleRight.setDataFormat(HSSFDataFormat.getBuiltinFormat("#,##0"));
       //styleRight.setFont(font1);
       
       
       // 새로운 sheet를 생성한다.
       worksheet = workbook.createSheet(sheetName);
       
       
       // 칼럼 길이 설정
       for(int j=0;j<colModelList.size();j++) {
           columnInfo = (HashMap<String, Object>) colModelList.get(j);
           worksheet.setColumnWidth(j, StringUtil.nvl(columnInfo.get("width"), 0));
       }
      
       
       int rowNum = -1;
       
       // TITLE
       row = worksheet.createRow(++rowNum);
       for(int j=0;j<colSize;j++) {
           row.createCell(j).setCellValue(title); row.getCell(j).setCellStyle(styleTitle);
       }
       // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
       if(colSize>1) {
           worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, colSize-1));
       }
       
       
       // 빈행
       row = worksheet.createRow(++rowNum);
       for(int j=0;j<colSize;j++) {
           row.createCell(j).setCellValue(""); //row.getCell(j).setCellStyle(styleTitle);
       }
       // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
       if(colSize>1) {
           worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, colSize-1));
       }
       
       
       // 검색조건
       if(searchValues != null) {
	       for(int i=0;i<searchValues.length;i++) {    
	           
	           row = worksheet.createRow(++rowNum);
	           row.createCell(0).setCellValue(searchValues[i]); row.getCell(0).setCellStyle(styleSearchLeft);
	           for(int j=1;j<colSize;j++) {
	               row.createCell(j).setCellValue(""); row.getCell(j).setCellStyle(styleSearchLeft);
	           }
	           // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
	           if(colSize>1) {
	               worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, colSize-1));
	           }
	           // 행 높이 조정
	           int rowHeight = searchValues[i].split("\r\n").length;
	           if(rowHeight > 1) {
	               row.setHeightInPoints(worksheet.getDefaultRowHeightInPoints() * (rowHeight + 1) * 1f);
	           }
	           
	       }
       
	       // 빈행
	       row = worksheet.createRow(++rowNum);
	       for(int j=0;j<colSize;j++) {
	           row.createCell(j).setCellValue(""); //row.getCell(j).setCellStyle(styleTitle);
	       }
	       // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
	       if(colSize>1) {
	           worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, colSize-1));
	       }
       }
       
       
       // 헤더(headerRow) 설정
       
       // 부모 헤더 옵션
       Row parentRow = null;
       if(parentHeaderRowColspanList != null) {
           parentRow = worksheet.createRow(++rowNum);
       }
       
       row = worksheet.createRow(++rowNum);
       //row.setHeight((short)400);
       for(int j=0;j<colModelList.size();j++) {
           columnInfo = (HashMap<String, Object>) colModelList.get(j);
           row.createCell(j).setCellValue(StringUtil.nvl(columnInfo.get("label"))); 
           row.getCell(j).setCellStyle(styleHeaderSXSS);
       }
	    // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
   	   if(headerRowColspanList != null) {
	        	for(int j=0;j<headerRowColspanList.size();j++) {
		    		headerRowColspanInfo = (HashMap<String, Object>) headerRowColspanList.get(j);
		            int firstCol = StringUtil.nvl(headerRowColspanInfo.get("firstCol"),0);
		            int lastCol = StringUtil.nvl(headerRowColspanInfo.get("lastCol"),0);
		            
		            worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, firstCol, lastCol));
	            }	    		
   	    }
   	   
   	   // 부모 헤더 옵션
       if(parentHeaderRowColspanList != null && parentRow != null) {
           int parentRowNum = rowNum - 1;
           CellStyle styleParentHeader = workbook.createCellStyle();
           
           styleParentHeader.setFont(font1);
           styleParentHeader.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
           styleParentHeader.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
           try {
               Set<Integer> parentMergeSet = new HashSet<>();
               
               for(int j=0;j<parentHeaderRowColspanList.size();j++) {
                   parnetHeaderRowRowspanInfo = (HashMap<String, Object>) parentHeaderRowColspanList.get(j);
                   int firstCol = StringUtil.nvl(parnetHeaderRowRowspanInfo.get("firstCol"), 0);
                   int lastCol = StringUtil.nvl(parnetHeaderRowRowspanInfo.get("lastCol"), 0);
                   String label = StringUtil.nvl(parnetHeaderRowRowspanInfo.get("label"));
                   worksheet.addMergedRegion(new CellRangeAddress(parentRowNum, parentRowNum, firstCol, lastCol));
                   parentRow.createCell(firstCol).setCellValue(label);
                   parentRow.getCell(firstCol).setCellStyle(styleParentHeader);
                   
                   for(int k = firstCol; k <= lastCol; k++) {
                       parentMergeSet.add(k);
                   }
               }
               
               int cellLen = row.getLastCellNum();
               CellStyle styleChildHeader = workbook.createCellStyle();
               styleChildHeader.setFont(font1);
               styleChildHeader.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
               styleChildHeader.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
               styleChildHeader.setBorderBottom(BorderStyle.THIN);
               for(int j=0; j < cellLen; j++) {
                   row.getCell(j).setCellStyle(styleChildHeader);
               }
               
               for(int j=0; j < cellLen; j++) {
                   if(!parentMergeSet.contains(j)) {
                       String label = row.getCell(j).getStringCellValue();
                       CellRangeAddress mergedRegion = new CellRangeAddress(rowNum - 1, rowNum, j, j);
                       worksheet.addMergedRegion(mergedRegion);
                       Row firstRow = worksheet.getRow(mergedRegion.getFirstRow());
                       firstRow.createCell(mergedRegion.getFirstColumn()).setCellValue(label);
                       firstRow.getCell(mergedRegion.getFirstColumn()).setCellStyle(styleChildHeader);
                   }
               }
           } catch (Exception e) {
               e.printStackTrace();
           }
       }
       
       
       // list
       if(list != null) {
	       for(int i=0;i<list.size();i++) {
	           obj = list.get(i);
	           
	           row = worksheet.createRow(++rowNum);
	           
	           for(int j=0;j<colModelList.size();j++) {
	               columnInfo = (HashMap<String, Object>) colModelList.get(j);
	               try {
	                   
	                   if(obj instanceof Map) {
	                   
	                   }else { // if( obj instanceof DefaultVO){
	                       try {
	                          meth = cls.getDeclaredMethod("get"+StringUtil.upperCaseFirst(StringUtil.nvl(columnInfo.get("name"))));
	                       }catch (NoSuchMethodException e) { // method 가 없는 경우 super class 에서 method 존재 검사
	                          meth = null;
	                          Class clsSuper = (Class) obj.getClass().getGenericSuperclass();
	                         while( clsSuper.getName() != "java.lang.Object" && meth == null) {
	                            try {
	                                meth = clsSuper.getDeclaredMethod("get"+StringUtil.upperCaseFirst(StringUtil.nvl(columnInfo.get("name"))));
	                            }catch (NoSuchMethodException e2) {
	                                //e2.printStackTrace();
	                                meth = null;
	                                clsSuper = (Class) clsSuper.getGenericSuperclass();
	                            }
	                          }
	                       }
	                   }
	               
	                   try {
	                       
							//prefix = StringUtil.nvl(columnInfo.get("prefix")); //앞첨자
							//suffix = StringUtil.nvl(columnInfo.get("suffix")); //뒷첨자
							
	                	    if(obj instanceof Map) {
								cellvalue = StringUtil.nvl(((ListOrderedMap) obj).get(StringUtil.nvl(columnInfo.get("name"))), StringUtil.nvl(columnInfo.get("defaultValue")) );
			    	        }else { // if( obj instanceof DefaultVO){
			    	        	if(meth != null) {
			    	        	    cellvalue = StringUtil.nvl(meth.invoke(obj), StringUtil.nvl(columnInfo.get("defaultValue")));
			    	        	}else {
			    	        		cellvalue = StringUtil.nvl(columnInfo.get("defaultValue"));
			    	        	}
			    	        }
							
							//footer 옵션이 존재
							if("true".equals(footerRow) && columnInfo.get("footer") != null) {	
								footer = (HashMap<String, Object>) columnInfo.get("footer");
								
								type = StringUtil.nvl(footer.get("type"));
								if("sum".equals(type) || "avg".equals(type)) { // 합계,평균
									if(i == 0) {
										footerVal[0][j] = 0;
									}
									footerVal[0][j] += Double.parseDouble(StringUtil.nvl(cellvalue.replaceAll(",", ""),"0"));
									footer.put("footerVal", footerVal[0][j]);
									//columnInfo.put("footer", footer);
									//colModelList.set(j, columnInfo);
								}else if("min".equals(type) || "max".equals(type)) {
									int reversal = 0;
									
									if("max".equals(type)) {
										reversal = 1;
									}
									if(i == 0) {
										try {
											footerVal[0][j] = Double.parseDouble(cellvalue.replaceAll(",", "")); //이전행 값
											footerValText[0][j]= "";
										}catch(Exception e) {
											footerValText[0][j]= "nodata";
										}
									}
									
									try {
										footerVal[1][j] = Double.parseDouble(cellvalue.replaceAll(",", "")); //현재행 값
										footerValText[1][j]= "";
									}catch(Exception e) {
										footerValText[1][j]= "nodata";
									}
									
									if( "".equals(footerValText[0][j]) && "".equals(footerValText[1][j]) ) {
										footerVal[0][j] = footerVal[0+reversal][j] < footerVal[1-reversal][j] ? footerVal[0][j] : footerVal[1][j];
										footerValText[0][j]= "";
										footer.put("footerVal",footerVal[0][j]);
									}else if("nodata".equals(footerValText[0][j]) && "".equals(footerValText[1][j])){
										footerVal[0][j] = footerVal[1][j];
										footerValText[0][j]= "";
										footer.put("footerVal",footerVal[0][j]);
									}else if("".equals(footerValText[0][j]) && "nodata".equals(footerValText[1][j])) {
										footerValText[0][j]= "";
										footer.put("footerVal",footerVal[0][j]);
									}else if("nodata".equals(footerValText[0][j]) && "nodata".equals(footerValText[1][j])) {
										footer.put("footerVal","");
									}
									//columnInfo.put("footer", footer);
									//colModelList.set(j, columnInfo);
								}
								
							}						
							
							//codes 옵션이 존재하면 해당하는 코드에 대한 명을 리턴
							if(columnInfo.get("codes") != null) {
								codes = (HashMap<String, Object>) columnInfo.get("codes");
								cellvalue = StringUtil.nvl(codes.get(cellvalue),StringUtil.nvl(columnInfo.get("defaultValue"))); //코드값으로부터 코드명을 얻는다.
							}
							
							//formatter 옵션이 존재
							if(columnInfo.get("formatter") != null) {
								cellvalue = getFormatString(cellvalue, StringUtil.nvl(columnInfo.get("formatter")), (HashMap<String, Object>) columnInfo.get("formatOptions"));
							}
							
							if(!"".equals(cellvalue)) {
								prefix = StringUtil.nvl(columnInfo.get("prefix")); //앞첨자
								suffix = StringUtil.nvl(columnInfo.get("suffix")); //뒷첨자
							}else {
								prefix = "";
								suffix = "";
							}
							
							//method 옵션이 존재
							if(i==0 && columnInfo.get("method") != null) {
								methodColList.add(j);
							}
							
							// validat 옵션이 존재
							if (i == 0 && columnInfo.get("validat") != null) {
								validatColList.add(j);
							}
							
							if(!"".equals(StringUtil.nvl(columnInfo.get("id")))) {
								cellvalueMap.put(StringUtil.nvl(columnInfo.get("id")), cellvalue);
							}
							
							//if("formula".equals(columnInfo.get("valueType"))){ // 엑셀버전에 따라 사용할 수 있는 공식이 다르니 사용시 주의, 추후 기능 필요한 경우 주석해제하여 사용
							    //row.createCell(j).setCellFormula(prefix+cellvalue+suffix); // ex) row.createCell(j).setCellFormula("IF(C6="값1","code1", IF(C6="값2","code2", "없음"))");
							//}else {
								row.createCell(j).setCellValue(prefix+cellvalue+suffix);
							//}
							
							align = StringUtil.nvl(columnInfo.get("align"));
							if("left".equals(align)) {
								row.getCell(j).setCellStyle(styleLeft);
							}else if("center".equals(align)) {
								row.getCell(j).setCellStyle(styleCenter);
							}else if("right".equals(align)) {
								row.getCell(j).setCellStyle(styleRight);
							}else {
								row.getCell(j).setCellStyle(styleCenter);
							}
	                       
	                   } catch (IllegalAccessException e) {
	                       e.printStackTrace();
	                   } catch (IllegalArgumentException e) {
	                       e.printStackTrace();
	                   } catch (InvocationTargetException e) {
	                       e.printStackTrace();
	                   }
	               } catch (SecurityException e) {
	                   e.printStackTrace();
	               }
	               
	           }
	           
		    	//method 처리
		    	for(int j: methodColList) {
		    		columnInfo = (HashMap<String, Object>) colModelList.get(j);
		    		
		    		cellvalue = getMethodVal(cellvalueMap, StringUtil.nvl(columnInfo.get("method")), (HashMap<String, Object>) columnInfo.get("methodOptions"));
		    		cellvalue = StringUtil.nvl(cellvalue, StringUtil.nvl(columnInfo.get("defaultValue")));
		    		
		    		if(!"".equals(cellvalue)) {
						prefix = StringUtil.nvl(columnInfo.get("prefix")); //앞첨자
						suffix = StringUtil.nvl(columnInfo.get("suffix")); //뒷첨자
					}else {
						prefix = "";
						suffix = "";
					}
		    		
		    		
		    		row.getCell(j).setCellValue(prefix+cellvalue+suffix);
		    		
		    	}	           
	       }
	       
		   // validat 처리
		   for (int j : validatColList) {
			   columnInfo = (HashMap<String, Object>) colModelList.get(j);
				
			   // [데이터 유효성 검사] list 에 표시
			   setValidat(rowNum-list.size()+1,rowNum, j ,worksheet, StringUtil.nvl(columnInfo.get("validat")),(HashMap<String, Object>) columnInfo.get("validatOptions"));
				
		   }
			
       }
       
	    //footerRow
	    if("true".equals(footerRow)) {
	    	
	    	row = worksheet.createRow(++rowNum);
	    	
	    	for(int j=0;j<colModelList.size();j++) {
	    		
	    		columnInfo = (HashMap<String, Object>) colModelList.get(j);
	    		
	    		prefix = "";
	    		suffix = "";
	    		align = "";
	    		type = "";
	    		cellvalue = "";
	    		
	    		//footer 옵션이 존재
				if(columnInfo.get("footer") != null) {
					footer = (HashMap<String, Object>) columnInfo.get("footer");
					
					prefix = StringUtil.nvl(footer.get("prefix"));
					suffix = StringUtil.nvl(footer.get("suffix"));
					align = StringUtil.nvl(footer.get("align"));
					type = StringUtil.nvl(footer.get("type"));
					
					if(list != null && list.size() > 0) {
						if("sum".equals(type) || "min".equals(type) || "max".equals(type)) {
							cellvalue = StringUtil.nvl(footer.get("footerVal"),"0");
						}else if("count".equals(type)) {
							cellvalue = Integer.toString(list.size());
						}else if("avg".equals(type)) {
							cellvalue = Double.toString(Double.parseDouble(StringUtil.nvl(footer.get("footerVal"),"0"))/list.size());
						}
						
						//formatter 옵션이 존재
						if(columnInfo.get("formatter") != null) {
							cellvalue = getFormatString(cellvalue, StringUtil.nvl(columnInfo.get("formatter")), (HashMap<String, Object>) columnInfo.get("formatOptions"));
						}	
						
					}else {
						cellvalue = "";
					}
				}
				
	    		row.createCell(j).setCellValue(prefix+cellvalue+suffix);
				
				align = "".equals(align) ? StringUtil.nvl(columnInfo.get("align")) : align;
				if("left".equals(align)) {
					row.getCell(j).setCellStyle(styleLeft);
				}else if("center".equals(align)) {
					row.getCell(j).setCellStyle(styleCenter);
				}else if("right".equals(align)) {
					row.getCell(j).setCellStyle(styleRight);
				}else {
					row.getCell(j).setCellStyle(styleCenter);
				}
	    		
	    	}
	    	
		    // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
	    	if(footerRowColspanList != null) {
		    	for(int j=0;j<footerRowColspanList.size();j++) {
		    		footerRowColspanInfo = (HashMap<String, Object>) footerRowColspanList.get(j);
		            int firstCol = StringUtil.nvl(footerRowColspanInfo.get("firstCol"),0);
		            int lastCol = StringUtil.nvl(footerRowColspanInfo.get("lastCol"),0);
		            
		            worksheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, firstCol, lastCol));
		        }	    		
	    	}
	    
	    }       
       
       return workbook;
   }
   
   public List<?> simpleReadGrid(HashMap<String, Object> map) throws Exception  {
       String excelGrid = StringUtil.nvl(map.get("excelGrid"));
       int fileSn = Integer.parseInt(StringUtil.nvl(map.get("fileSn"),"0"));
       int startRaw = Integer.parseInt(StringUtil.nvl(map.get("startRaw"),"1"));
       FileVO fileVO = (FileVO) map.get("fileVO");

       Map<String, Object> excelGridMap = null;
       try {
           excelGridMap = (HashMap<String, Object>) JsonUtil.jsonToMap(excelGrid);
       } catch (Exception e) {
           e.printStackTrace();
       }
       
       List colModelList = (List) excelGridMap.get("colModel");
       
       //파일 풀경로 찾기
       String filePath = CommConst.FILE_STORAGE_PATH;
       if("excelUpload".equals(map.get("searchKey"))) {
           filePath = CommConst.WEBDATA_PATH;
       }
       if(fileVO != null) {
           if("contents".equals(fileVO.getFileType())){
               filePath = CommConst.CONTENTS_STORAGE_PATH;
           }
           filePath += fileVO.getSaveFilePath();
       }
       
       //파일 풀경로를 토대로 읽어올 경로 찾기
       File saveFile = new File(filePath);
       filePath = saveFile.getPath();
       String[] filePathArr = filePath.split("\\\\");
       filePath = saveFile.getPath().replace(filePathArr[filePathArr.length-1], "");
       
       //엑셀 읽기
       ExcelReadOption excelReadOption = new ExcelReadOption();
       excelReadOption.setStartRow(startRaw);                      //읽기 시작 로우 (컬럼다음줄,데이터 시작줄)
       if(colModelList != null) {
           for(int j=0;j<colModelList.size();j++) {
               HashMap<String, Object> columnInfo = (HashMap<String, Object>) colModelList.get(j);
               excelReadOption.setOutputColumns(StringUtil.nvl(columnInfo.get("colums")));                 //엑셀에서의 데이터 읽을 세로 컬럼 명칭 
           }
       }
       
       //String fileNm = StringUtil.nvl(fileVO.getFileNm());     //엑셀 이름
       excelReadOption.setFilePath(saveFile.getPath());        //엑셀 경로
       
       ExcelRead excelRead = new ExcelRead();
       List<?> qstnList = excelRead.read(excelReadOption);
       
       //처리 후 파일 삭제
       FileUtil.delFile(filePath, filePathArr[filePathArr.length-1]);

       return qstnList;
   }
}
