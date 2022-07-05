package com.kkk;

import com.github.pagehelper.PageHelper;
import org.apache.ibatis.plugin.Interceptor;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.Properties;

@SpringBootApplication
@MapperScan("com.kkk.dao")
public class KkkApplication {
    public static void main(String[] args) {
        SpringApplication.run(KkkApplication.class, args);
        System.out.println("启动成功");
    }

}
