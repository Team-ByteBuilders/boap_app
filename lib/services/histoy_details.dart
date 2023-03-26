class HistoryDetails{
  final String balance;
  final List<PaymentDetails> history;

  HistoryDetails({required this.balance,required this.history});
}

enum Payment{
  sent,
  received
}

class PaymentDetails{
 final Payment status;
 final String amount;
 final String upi;

 PaymentDetails({
   required this.status,
   required this.amount,
   required this.upi
});
}