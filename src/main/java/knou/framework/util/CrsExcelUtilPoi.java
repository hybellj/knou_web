package knou.framework.util;

import knou.framework.util.ExcelUtilPoi;

/**
 * @author hexma
 */
public class CrsExcelUtilPoi extends ExcelUtilPoi {

	/**
	 *
	 */
	public CrsExcelUtilPoi() {
		super();
	}
	
	@Override
	public Object getClassForName(String className)	{
		Class<?> cls = null;
        try {
        	cls = Class.forName(className);
		} catch (ClassNotFoundException e1) {
			e1.printStackTrace();
		}

		return cls;

	}
	
}
