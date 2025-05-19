final Map<String, WidgetBuilder> appRoutes = {
  '/': (_) => HomeScreen(userId: "USER_ID_HERE"),
  '/send': (_) => SendPaymentScreen(
    senderId: 'USER_ID',
    senderCurrency: 'USD',
    senderBalance: 5000.0,
  ),
};
