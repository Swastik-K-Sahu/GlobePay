package com.pay.globe_pay.Transaction;

import com.pay.globe_pay.Currency.ExchangeRateService;
import com.pay.globe_pay.Saga.TransactionEvent;
import com.pay.globe_pay.User.User;
import com.pay.globe_pay.User.UserService;
import org.apache.coyote.BadRequestException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class TransactionService {
    @Autowired
    private TransactionRepository transactionRepo;
    @Autowired private UserService userService;
    @Autowired private ExchangeRateService exchangeRateService;
    @Autowired private KafkaTemplate<String, TransactionEvent> kafkaTemplate;

    public void initiateTransfer(TransferRequest request) throws BadRequestException {
        if (request.getSenderId().equals(request.getRecipientId()))
            throw new BadRequestException("Cannot send to self");

        User sender = userService.getUser(request.getSenderId());
        User recipient = userService.getUser(request.getRecipientId());

        if (!request.getSourceCurrency().equals(sender.getCurrency()) ||
                !request.getTargetCurrency().equals(recipient.getCurrency())) {
            throw new BadRequestException("Invalid currency route");
        }

        BigDecimal rate = exchangeRateService.getExchangeRate(request.getSourceCurrency(), request.getTargetCurrency());
        BigDecimal converted = request.getAmount().multiply(rate);

        if (sender.getBalance().compareTo(request.getAmount()) < 0) {
            throw new BadRequestException("Insufficient funds");
        }

        // Create event and send to Kafka
        TransactionEvent event = new TransactionEvent(
                UUID.randomUUID().toString(), request.getSenderId(), request.getRecipientId(),
                request.getAmount(), converted, rate, request.getSourceCurrency(), request.getTargetCurrency()
        );

        kafkaTemplate.send("transaction-saga-start", event);
    }
    public List<TransactionView> getTransactionHistory(String userId) {
        List<Transaction> transactions = transactionRepo.findBySenderIdOrRecipientId(userId, userId);

        return transactions.stream().map(tx -> {
            boolean isSender = tx.getSenderId().equals(userId);
            String counterparty = isSender ? tx.getRecipientId() : tx.getSenderId();
            String direction = isSender ? "SENT" : "RECEIVED";

            return new TransactionView(
                    direction,
                    tx.getType(),
                    tx.getOriginalAmount(),
                    tx.getConvertedAmount(),
                    isSender ? tx.getSourceCurrency() : tx.getTargetCurrency(),
                    counterparty,
                    tx.getTimestamp()
            );
        }).collect(Collectors.toList());
    }

}

