package com.kkk.utils;

import com.kkk.common.Constants;
import org.springframework.util.DigestUtils;

import java.util.Random;

public class PwdUtils {

    private final String base = "abcdefghijklmnopqrstuvwxyz";
    private final String chart = ":;@!#$%*()?";

    public String getPwd(){
        return base.charAt(new Random().nextInt(base.length()))+""+base.charAt(new Random().nextInt(base.length()))+""+chart.charAt(new Random().nextInt(chart.length()))+(int)((Math.random()*9+1)*100000);
    }

    public String encryption(String pwd,String account){
        return DigestUtils.md5DigestAsHex((DigestUtils.md5DigestAsHex(pwd.getBytes())+account+ Constants.SYSTEMKEY).getBytes());
    }

}
