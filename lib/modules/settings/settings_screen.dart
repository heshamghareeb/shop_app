import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/shop_cubit.dart';
import '../../layout/cubit/shop_states.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';


class SettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;

        nameController.text = model.data!.name;
        emailController.text = model.data!.email;
        phoneController.text = model.data!.phone;

        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children:
                  [
                    if(state is ShopLoadingUpdateUserState)
                      const LinearProgressIndicator(),
                    const SizedBox(height: 20.0),
                    TextFormFieldForSettings(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'name must not be empty';
                        }

                        return null;
                      },
                        label: 'Name',
                        prefix: const Icon(Icons.person),

                    ),
                    const SizedBox(height: 20.0),
                    TextFormFieldForSettings(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'email must not be empty';
                        }

                        return null;
                      },
                      label: 'Email Address',
                      prefix: Icon(Icons.email),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormFieldForSettings(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'phone must not be empty';
                        }

                        return null;
                      },
                      label: 'Phone',
                      prefix: const Icon(Icons.phone),
                    ),
                    const SizedBox(height: 20.0),
                    defaultButton(
                      function: ()
                      {
                        if(formKey.currentState!.validate())
                        {
                          ShopCubit.get(context).updateUserData(
                            name: nameController.text,
                            phone: phoneController.text,
                            email: emailController.text,
                          );
                        }
                      },
                      text: 'update',
                    ),
                    const SizedBox(height: 20.0),
                    defaultButton(
                      function: () {
                        signOut(context);
                      },
                      text: 'Logout',
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}