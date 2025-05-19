package com.pay.globe_pay.Transaction;

import com.pay.globe_pay.Common.TransferRequest;
import lombok.RequiredArgsConstructor;
import org.apache.coyote.BadRequestException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/transactions")
@RequiredArgsConstructor
public class TransactionController {

    private final TransactionService transactionService;

    @PostMapping("/send")
    public ResponseEntity<String> sendMoney(@RequestBody TransferRequest req) throws BadRequestException {
        transactionService.initiateTransfer(req);
        return ResponseEntity.ok("Transaction initiated");
    }

    @GetMapping("/history/{userId}")
    public ResponseEntity<List<TransactionView>> getTransactionHistory(@PathVariable String userId) {
        return ResponseEntity.ok(transactionService.getTransactionHistory(userId));
    }
}

