import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() =>
      MaterialPageRoute(builder: (_) => const HomePage());

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            print("DEBUG : state: $state");
            if (state is HomeLoading) {
              return const CircularProgressIndicator();
            }

            if (state is HomeError) {
              return Text(
                state.message,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              );
            }

            if (state is HomeLoaded) {
              return Text(
                'Bonjour ${state.pseudo}',
                style: Theme.of(context).textTheme.headlineSmall,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
