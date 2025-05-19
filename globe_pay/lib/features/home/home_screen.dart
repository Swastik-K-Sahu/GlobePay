class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..loadUser(userId),
      child: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          if (vm.error.isNotEmpty) {
            return Center(child: Text("Error: ${vm.error}"));
          }
          if (vm.user == null) return CircularProgressIndicator();

          return Scaffold(
            appBar: AppBar(title: Text("GlobePay")),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome, ${vm.user!.name}", style: Theme.of(context).textTheme.headline6),
                  Text("Balance: ${vm.user!.balance.toStringAsFixed(2)} ${vm.user!.currency}"),
                  SizedBox(height: 20),
                  Text("Transaction History", style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: vm.transactions.length,
                      itemBuilder: (context, index) {
                        final tx = vm.transactions[index];
                        return ListTile(
                          leading: Icon(tx.direction == TransactionDirection.sent ? Icons.arrow_upward : Icons.arrow_downward),
                          title: Text("${tx.amount} ${tx.currency}"),
                          subtitle: Text("${tx.direction.name.toUpperCase()} to/from ${tx.counterparty}"),
                          trailing: Text(DateFormat.yMMMd().format(tx.timestamp)),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
