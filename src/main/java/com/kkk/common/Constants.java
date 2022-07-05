package com.kkk.common;


public class Constants {
	
	/**
	 * 上传文件总目录
	 */
	public static String UPLOAD = "/tomcat/images/";
	public static String img_pre = "/images/";
	public static String IMAGE_PRE = "/uploadFiles/";

	public static String certPath ="/tomcat/cert/";
	public static String cert_pre = "/cert/";

	public static final String toForm = "toForm";
	public static String submitForm = "submitForm";
	public static String stoken = "stoken";
	public static final String formMsg = "请不要重复提交！";

	//密码加密字符串
	public static String SYSTEMKEY="abc";

	public static final int FIXED_DB =7;

	public static final String DEFAULT_LISTENER="[{\"appName\":\"支付宝\",\"orderNumberPattern\":\"\",\"orderAmountPattern\":\"([d.]+)元\",\"packageName\":\"com.eg.android.AlipayGphone\",\"PlayType\":4},{\"appName\":\"微信\",\"orderNumberPattern\":\"\",\"orderAmountPattern\":\"([d.]+)元\",\"packageName\":\"com.tencent.mm\",\"PlayType\":5},{\"appName\":\"eCardPlay\",\"orderNumberPattern\":\"订单:([d.]+)\",\"orderAmountPattern\":\"([d.]+)元\",\"packageName\":\"com.buybal.buybalpay.nxy.fkepay\",\"PlayType\":6}]";


	//conf配置文件
	public static String SPRING_REDIS_HOST;

	public static String COPYRIGHT;

	public static String TRANSFER_URL;
	public static String BANKINFOR_URL;
	public static String LOGIN_STATUS;


	public static String publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCTCz2TiofLGQLBzZc2u022kbRZmaKKRZdGeEwH8StyaanKgY6K07UREQgsYb3uNJ+Umf6umuuGLWfarekcFgF1y8ItY2KaMtTConfyD+5XIsMZVFgwMxzACF1Xph0q4Zs8q2cMGTeNOC0SCV7RNS0KdW8JWpGwEMBJELtTqdVIxwIDAQAB";
	public static String privateKey = "MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAJMLPZOKh8sZAsHNlza7TbaRtFmZoopFl0Z4TAfxK3JpqcqBjorTtRERCCxhve40n5SZ/q6a64YtZ9qt6RwWAXXLwi1jYpoy1MKid/IP7lciwxlUWDAzHMAIXVemHSrhmzyrZwwZN404LRIJXtE1LQp1bwlakbAQwEkQu1Op1UjHAgMBAAECgYB4UA8vBH89b5Zw6n4ae0EH68oMMgfraStwrodPTEZHVCtoFX+DGdwiPbRZVBQqroYP+byIMxwY6lf6dqewolTIRPlzJWS9ucXZzzf7fbxfODBsATH3XLUdBP8Mz2AvUu8eVtVvkdL7H+8VkKir+ftFkDAWRi0lxGXTmo/LEZuPSQJBANgeN394+Eea9F0eLSdTqD2C2zxEnvQAt82kpYcgJKDvig1Mi1sArW47l5jepVVyAQGsBsrFj0+XiVpyBkZlu3MCQQCuLdg6z5DEl11+ITKkWGBXHAaJBYO+Avb9XCkwaewjTGpfLq5UUqUrHlVD1o4fB2GabIGkNZPw0hcF716/8xBdAkBIqeg5COBZmwT8ZhACgAM6I0w5OE1FdxRVpT0ucKVAIyoEjK7yOwkU3h57fKiUUQ97k255MPGdbjL1YQ8xDjV3AkBlXOKYHxEVhyzuaO1qvM+cAgA/n0jyvBD2krqZpRq51A+XQrhK9CmQtT9Tkjn1DrubPYgYguGMZQbm+k1+kTo1AkAWHDhBLpacmJnDwq0NLlwZosktsA6AtHccYAWPfmsoxReWTjNSnz4PxoaRNkYzvP663S6vy8uEaTZ0SfVRKl7w";

}
