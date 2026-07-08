package com.app.eventhallmanager;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class EventHallManagerApplication {

	public static void main(String[] args) {
		SpringApplication.run(EventHallManagerApplication.class, args);
	}

}
