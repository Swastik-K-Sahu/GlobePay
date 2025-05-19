package com.pay.globe_pay.Common;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class TransferRequest {
    private String senderId;
    private String recipientId;
    private BigDecimal amount;
    private String sourceCurrency;
    private String targetCurrency;
}

