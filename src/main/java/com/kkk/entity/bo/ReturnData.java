package com.kkk.entity.bo;


import lombok.Data;

@Data
public class ReturnData {

	/**
	 * 操作代码 1:成功 ,0:失败
	 */
	private Integer code=1;
	
	private String msg;
	
	private Object obj;
	
	public ReturnData(){
	}
	
	public ReturnData(Integer code, String msg){
		this.code=code;
		this.msg=msg;
	}
	

}
