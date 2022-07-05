package com.kkk.utils;

import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;


public class PCAddress {
	static Logger logger = Logger.getLogger(PCAddress.class);
	public static String getIpAddress(HttpServletRequest request) {
		String ip = request.getHeader("X-Forwarded-For");
		if (!checkIp(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (!checkIp(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");//
		}
		if (!checkIp(ip)) {
			ip = request.getRemoteAddr();//
		}
		return ip;
	}
	
	private static boolean checkIp(String ip) {
		if (ip == null || ip.length() == 0 || "unkown".equalsIgnoreCase(ip)) {
			return false;
		}
		return true;
	}

}
