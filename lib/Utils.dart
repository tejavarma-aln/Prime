class Utils {
  static var groups = <String>[
    "Sundry Debtors",
    "Sundry Creditors",
    "Indirect Expense",
    "Indirect Income",
    "Sales Accounts",
    "Bank Accounts",
    "Cash-In-Hand"
  ];

  static bool parseDouble(String d) {
    if (double.tryParse(d) != null) {
      return true;
    }
    return false;
  }
}
