package com.pay.globe_pay.Saga;

import com.pay.globe_pay.Transaction.Transaction;
import com.pay.globe_pay.Transaction.TransactionRepository;
import com.pay.globe_pay.Transaction.TransactionType;
import com.pay.globe_pay.User.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
@RequiredArgsConstructor
public class SagaOrchestrator {
    private final UserService userService;
    private final TransactionRepository transactionRepository;

    @KafkaListener(topics = "transaction-saga-start")
    public void handleTransaction(TransactionEvent event) {
        try {
            userService.updateBalance(event.getSenderId(),
                    userService.getUserBalance(event.getSenderId()).subtract(event.getOriginalAmount()));

            userService.updateBalance(event.getRecipientId(),
                    userService.getUserBalance(event.getRecipientId()).add(event.getConvertedAmount()));

            Transaction tx = new Transaction(
                    event.getTransactionId(), event.getSenderId(), event.getRecipientId(),
                    event.getOriginalAmount(), event.getConvertedAmount(), event.getExchangeRate(),
                    event.getSourceCurrency(), event.getTargetCurrency(), TransactionType.SENT,
                    LocalDateTime.now(), "COMPLETED"
            );

            transactionRepository.save(tx);
        } catch (Exception e) {

        }
    }
}

