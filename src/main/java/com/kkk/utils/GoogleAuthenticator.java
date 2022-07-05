package com.kkk.utils;

import com.kkk.common.Constants;
import org.apache.commons.codec.binary.Base32;
import org.apache.commons.codec.binary.Base64;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

public class GoogleAuthenticator {

    // 来自谷歌文档，不用修改
    private static final int SECRET_SIZE = 10;
    // 产生密钥的种子
    private static final String SEED = "N%U%cls36e7Ab!@#asd34nB4%9%Nmo2ai1IC9@54n06aY";
    // 安全哈希算法（Secure Hash Algorithm）
    private static final String RANDOM_NUMBER_ALGORITHM = "SHA1PRNG";

    /**
     * 生成密钥
     *
     */
    public static String generateSecretKey() {
        SecureRandom sr;
        try {
            sr = SecureRandom.getInstance(RANDOM_NUMBER_ALGORITHM);
            sr.setSeed(Base64.decodeBase64(SEED));
            byte[] buffer = sr.generateSeed(SECRET_SIZE);
            Base32 codec = new Base32();
            byte[] bEncodedKey = codec.encode(buffer);
            return new String(bEncodedKey);
        } catch (NoSuchAlgorithmException e) {
            // should never occur... configuration error
        }
        return null;
    }

    /**
     * 校验验证码
     */
    public static Boolean check_code(String secret, long code, long timeMsec){
        Base32 codec = new Base32();
        try{
            secret = RSAUtils.decryptByRSA(secret,RSAUtils.getPrivateKey(Constants.privateKey));
        }catch (Exception e){
            e.printStackTrace();
        }
        byte[] decodedKey = codec.decode(secret);
        long t = (timeMsec / 1000L) / 30L;
        //可偏移的时间 -- 3*30秒的验证时间（客户端30秒生成一次验证码）
        Integer window_size = 3;
        for (int i = -window_size; i <= window_size; ++i) {
            long hash;
            try {
                hash = verify_code(decodedKey, t + i);
            } catch (Exception e) {
                e.printStackTrace();
                throw new RuntimeException(e.getMessage());
            }
            System.out.println(hash);
            if (hash == code) {
                return true;
            }
        }
        return false;
    }

    /**
     * 生成验证码
     *
     */
    private static int verify_code(byte[] key, long t) throws NoSuchAlgorithmException, InvalidKeyException {
        byte[] data = new byte[8];
        long value = t;
        for (int i = 8; i-- > 0; value >>>= 8) {
            data[i] = (byte) value;
        }
        SecretKeySpec signKey = new SecretKeySpec(key, "HmacSHA1");
        Mac mac = Mac.getInstance("HmacSHA1");
        mac.init(signKey);
        byte[] hash = mac.doFinal(data);
        int offset = hash[20 - 1] & 0xF;
        // We're using a long because Java hasn't got unsigned int.
        long truncatedHash = 0;
        for (int i = 0; i < 4; ++i) {
            truncatedHash <<= 8;
            // We are dealing with signed bytes:
            // we just keep the first byte.
            truncatedHash |= (hash[offset + i] & 0xFF);
        }
        truncatedHash &= 0x7FFFFFFF;
        truncatedHash %= 1000000;
        return (int) truncatedHash;
    }
}
