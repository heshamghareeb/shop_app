import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/home_layout.dart';
import '../../network/local/cache_helper.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import 'cuibt/register_cubit.dart';
import 'cuibt/states.dart';

class ShopRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  ShopRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (kDebugMode) {
            print('listener');
          }
          if (state is ShopRegisterSuccessState) {
            if (state.loginModel.status) {
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data!.token,
              ).then((value) {
                token = state.loginModel.data!.token;

                navigateAndFinish(
                  context,
                  const HomeLayout(),
                );
              });
            } else {
              showToast(
                text: state.loginModel.message,
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                      'REGISTER',
                      style:
                      Theme
                          .of(context)
                          .textTheme
                          .headline4!
                          .copyWith(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Register now to browse our hot offers',
                      style:
                      Theme
                          .of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'please enter your name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('User Name'),
                        prefix: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'please enter your email address';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('Email Address'),
                        prefix: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      onFieldSubmitted: (value) {},
                      obscureText:
                      ShopRegisterCubit
                          .get(context)
                          .isPassword,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'password is too short';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          suffixIcon: Icon(ShopRegisterCubit.get(context).suffix) != null
                              ? IconButton(
                            onPressed: () {
                              ShopRegisterCubit.get(context).changePasswordVisibility();},
                            icon: Icon(ShopRegisterCubit.get(context).suffix),
                          )
                              : null,
                          label: const Text('Password'),
                      prefix: const Icon(Icons.lock_outline),
                    ),

                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'please enter your phone number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text('Phone'),
                      prefix: Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  ConditionalBuilder(
                    condition: state is! ShopRegisterLoadingState,
                    builder: (context) =>
                        defaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              ShopRegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                          text: 'register',
                          isUpperCase: true,
                        ),
                    fallback: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                  ],
                ),
              ),
            ),
          ),)
          ,
          );
        },
      ),
    );
  }
}
