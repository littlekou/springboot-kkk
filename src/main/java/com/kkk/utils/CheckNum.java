
package com.kkk.utils;

import org.apache.commons.lang3.StringUtils;

public class CheckNum {

	public static Boolean checkNum(String code) {
		if (StringUtils.isNotEmpty(code)) {
			return "[0-9]+".matches(code);
		}
		return false;
	}
	public static String getPrice(String str){
		if(!str.contains(".")){
			return null;
		}
		int i = str.lastIndexOf(".");
		String preString = str.substring(0, i);
		String lastString = str.substring(i);
		String replace = preString.replace(".", "");
		return replace.concat(lastString);
	}

}
