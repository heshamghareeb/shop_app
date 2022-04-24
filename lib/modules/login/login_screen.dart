import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/modules/login/login_cubit/cubit.dart';
import 'package:shop_app/modules/login/login_cubit/states.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/components/constants.dart';

import '../../shared/components/components.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatelessWidget
{
  final formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginStates>(
        listener: (context, state) {
          if(state is ShopLoginSuccessState){
            if(state.loginModel.status){
              token = state.loginModel.data!.token;
              CacheHelper.saveData(
                  key: 'token',
                  value: state.loginModel.data!.token,
              );
              navigateAndFinish(context, const HomeLayout());
            }else{
              showToast(
                  state: ToastStates.ERROR,
                  text: state.loginModel.message
              );
            }
          }
        },
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LOGIN',style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black
                        )),
                        Text('Login now to browse our hot offers',style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.grey
                        )),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'please enter your emailadress';
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: ShopLoginCubit.get(context).isPassword,
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'password is too short';
                            }},
                          onFieldSubmitted: (value){
                            if(formKey.currentState!.validate()){
                              ShopLoginCubit.get(context).userLogin(
                                  email: _emailController.text,
                                  password: _passwordController.text
                              );
                            }
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: (){
                                  ShopLoginCubit.get(context)
                                      .changePasswordVisibility();
                                },
                                icon: Icon(ShopLoginCubit.get(context).suffix,)
                            ),
                            labelText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                              function: (){
                                if(formKey.currentState!.validate()){
                                  ShopLoginCubit.get(context).userLogin(
                                      email: _emailController.text,
                                      password: _passwordController.text
                                  );
                                }
                              },
                              text: 'Login',
                              isUpperCase: true),
                          fallback: (context) => const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            defaultTextButton(
                              text: 'register',
                              function: (){
                                navigateTo(
                                  context,
                                  ShopRegisterScreen(),
                                );
                              },
                            ),
                          ],)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      );
  }
}

















