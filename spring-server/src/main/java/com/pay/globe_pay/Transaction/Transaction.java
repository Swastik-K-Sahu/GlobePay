package com.pay.globe_pay.Transaction;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Document("transactions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Transaction {
    @Id private String id;

    private String senderId;
    private String recipientId;

    private BigDecimal originalAmount;
    private BigDecimal convertedAmount;
    private BigDecimal exchangeRate;

    private String sourceCurrency;
    private String targetCurrency;

    private TransactionType type;
    private LocalDateTime timestamp;
    private String status;
}

