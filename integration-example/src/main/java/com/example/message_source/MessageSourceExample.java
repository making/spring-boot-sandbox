package com.example.message_source;

import java.util.concurrent.TimeUnit;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.integration.channel.QueueChannel;
import org.springframework.integration.config.EnableIntegration;
import org.springframework.integration.dsl.IntegrationFlow;
import org.springframework.integration.dsl.IntegrationFlows;
import org.springframework.integration.dsl.Pollers;
import org.springframework.integration.dsl.SourcePollingChannelAdapterSpec;

@SpringBootApplication
@EnableIntegration
public class MessageSourceExample {

	private final CounterMessageSource input;

	public MessageSourceExample(CounterMessageSource input) {
		this.input = input;
	}

	@Bean
	public QueueChannel output() {
		return new QueueChannel();
	}

	@Bean
	public IntegrationFlow flow() {
		return IntegrationFlows.from(input, this::configurePoller)
				.channel(output())
				.get();
	}

	private void configurePoller(SourcePollingChannelAdapterSpec c) {
		c.poller(Pollers.fixedRate(100, TimeUnit.MILLISECONDS));
	}
}
