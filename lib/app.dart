import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'features/quote/data/datasources/quote_remote_data_source.dart';
import 'features/quote/data/repositories/quote_repository_impl.dart';
import 'features/quote/domain/usecases/get_quote.dart';
import 'features/quote/presentation/bloc/quote_bloc.dart';
import 'features/quote/presentation/screens/quote_screen.dart';
import 'core/network/network_info.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => NetworkInfoImpl(Connectivity()),
        ),
        RepositoryProvider(
          create: (context) => QuoteRemoteDataSourceImpl(
            client: http.Client(),
          ),
        ),
        RepositoryProvider(
          create: (context) => QuoteRepositoryImpl(
            remoteDataSource: context.read<QuoteRemoteDataSourceImpl>(),
            networkInfo: context.read<NetworkInfoImpl>(),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => QuoteBloc(
          getRandomQuote: GetRandomQuote(
            context.read<QuoteRepositoryImpl>(),
          ),
        ),
        child: MaterialApp(
          title: 'Quote App with BLoC',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 2,
            ),
          ),
          home: const QuoteScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}