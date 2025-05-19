package com.pay.globe_pay.Transaction;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TransactionView {
    private String direction; // SENT or RECEIVED
    private TransactionType type;
    private BigDecimal amount;
    private BigDecimal convertedAmount;
    private String currency;
    private String counterparty;
    private LocalDateTime timestamp;
}

