package com.pay.globe_pay.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public User getUser(String id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("User not found"));
    }

    public BigDecimal getUserBalance(String id) {
        return getUser(id).getBalance();
    }

    public void updateBalance(String id, BigDecimal newBalance) {
        User user = getUser(id);
        user.setBalance(newBalance);
        userRepository.save(user);
    }
}

