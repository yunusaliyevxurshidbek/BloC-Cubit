import 'package:bloc_cubit/bloc/home_cubit.dart';
import 'package:bloc_cubit/views/item_of_random_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_state.dart';
import '../models/random_user_list_res.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit homeCubit;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.onLoadRandomUserList();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent <=
          scrollController.offset) {
        homeCubit.onLoadRandomUserList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 232, 232, 1),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Random User - SetState"),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(


        //! Scroll paytida agar buildWhen ishlatilmasa yana boshiga qaytib qoladi backendan data olgandan so'ng
        buildWhen: (previous,current){
          return current is HomeRandomUserListState;
        },


        builder: (BuildContext context, HomeState state) {
          if (state is HomeErrorState) {
            return viewOfError(state.errorMessage);
          }
          if (state is HomeRandomUserListState) {
            var userList = state.userList;
            return viewOfRandomUserList(userList);
          }

          return viewOfLoading();
        },
      ),
    );
  }

  Widget viewOfError(String err) {
    return Center(
      child: Text("Could not fetch your data"),
    );
  }

  Widget viewOfLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget viewOfRandomUserList(List<RandomUser> userList) {
    return ListView.builder(
      controller: scrollController,
      itemCount: userList.length,
      itemBuilder: (context, index) {
        return itemOfRandomUser(userList[index], index);
      },
    );
  }
}
