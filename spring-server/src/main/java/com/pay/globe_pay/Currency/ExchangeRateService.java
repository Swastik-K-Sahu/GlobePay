package com.pay.globe_pay.Currency;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.util.Map;

@Service
public class ExchangeRateService {
    private static final String API_URL = "https://api.exchangerate-api.com/v4/latest/";

    public BigDecimal getExchangeRate(String from, String to) {
        if (from.equals(to)) return BigDecimal.ONE;

        RestTemplate restTemplate = new RestTemplate();
        String url = API_URL + from;

        try {
            ResponseEntity<Map> response = restTemplate.getForEntity(url, Map.class);
            Map<String, Object> rates = (Map<String, Object>) response.getBody().get("rates");

            return new BigDecimal(rates.get(to).toString());
        } catch (Exception e) {
            throw new RuntimeException("Failed to fetch exchange rate");
        }
    }
}

