package com.kkk.entity.bo;


import lombok.Data;

import java.io.Serializable;

/**
 * 单例返回
 */
@Data
public class ReturnData implements Serializable {

	/**
	 * 操作代码 1:成功 ,0:失败
	 */
	private Integer code;

	private String msg;

	private Object obj;
	public ReturnData(){
	}

	private static ReturnData returnData;

	//单例
//	public static ReturnData getReturn(int code,String msg) {
//		if (returnData == null) {//避免不必要的同步
//			synchronized (ReturnData.class) {
//				if (returnData == null) {//为null的时候创建实例
//					returnData = new ReturnData(code,msg);
//				}
//			}
//		}
//		return returnData;
//	}

	public static ReturnData getReturn(int code,String msg) {
		return returnData = new ReturnData(code,msg);
	}

	public ReturnData(Integer code, String msg){
		this.code=code;
		this.msg=msg;
	}


}
