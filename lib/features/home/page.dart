part of 'imports.dart';

class HomePage extends GetView<_Controller> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Text("Center"),
        ),
      ),
    );
  }
}
