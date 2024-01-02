import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BudgetScreen(),
    );
  }
}

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  TextEditingController budgetController = TextEditingController();
  TextEditingController expensesController = TextEditingController();
  TextEditingController expensesTitleController = TextEditingController();
  TextEditingController expensesAmountController = TextEditingController();
  double budget = 0;
  double expenses = 0;
  double balance = 0;
  List<Expense> expenseList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des budgets'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomCard(
                title: 'Budget',
                child: TextFormField(
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Entrez le budget',
                  ),
                ),
              ),
              CustomCard(
                title: 'Dépenses',
                child: Column(
                  children: [
                    ExpenseList(expenseList, removeExpense),
                    ElevatedButton(
                      onPressed: () => _showAddExpenseDialog(context),
                      child: Text('Ajouter une dépense'),
                    ),
                  ],
                ),
              ),
              CustomCard(
                title: 'Solde',
                child: Text(
                  '$balance FCFA',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: updateBalance,
                child: Text('Mettre à jour le solde'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateBalance() {
    setState(() {
      budget = double.tryParse(budgetController.text) ?? 0;
      double totalExpenses = expenseList.fold(
          0, (previousValue, element) => previousValue + element.amount);
      balance = budget - totalExpenses;
    });
  }

  void addExpense(String title, double amount) {
    setState(() {
      expenseList.add(Expense(title: title, amount: amount));
    });
  }

  void removeExpense(int index) {
    setState(() {
      expenseList.removeAt(index);
    });
  }

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une dépense'),
          content: Column(
            children: [
              TextFormField(
                controller: expensesTitleController,
                decoration:
                    InputDecoration(labelText: 'Intitulé de la dépense'),
              ),
              TextFormField(
                controller: expensesAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Montant de la dépense'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String title = expensesTitleController.text;
                double amount =
                    double.tryParse(expensesAmountController.text) ?? 0;
                addExpense(title, amount);
                Navigator.of(context).pop();
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final Widget child;

  CustomCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: Container(
        color: Color.fromARGB(255, 6, 112, 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 8.0),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class Expense {
  String title;
  double amount;

  Expense({required this.title, required this.amount});
}

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final Function(int) onRemove;

  ExpenseList(this.expenses, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(expenses[index].title),
          subtitle: Text('${expenses[index].amount} FCFA'),
          textColor: Colors.white,
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              onRemove(index);
            },
          ),
        );
      },
    );
  }
}
