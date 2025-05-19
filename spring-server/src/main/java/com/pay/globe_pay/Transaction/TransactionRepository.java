package com.pay.globe_pay.Transaction;

import java.util.List;

public interface TransactionRepository extends MongoRepository<Transaction, String> {
    List<Transaction> findBySenderIdOrRecipientId(String senderId, String recipientId);
}

