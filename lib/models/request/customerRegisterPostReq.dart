// To parse this JSON data, do
//
//     final customersRegisterPostRequest = customersRegisterPostRequestFromJson(jsonString);

import 'dart:convert';

CustomersRegisterPostRequest customersRegisterPostRequestFromJson(String str) => CustomersRegisterPostRequest.fromJson(json.decode(str));

String customersRegisterPostRequestToJson(CustomersRegisterPostRequest data) => json.encode(data.toJson());

class CustomersRegisterPostRequest {
    String fullname;
    String phone;
    String email;
    String image;
    String password;

    CustomersRegisterPostRequest({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
        required this.password,
    });

    factory CustomersRegisterPostRequest.fromJson(Map<String, dynamic> json) => CustomersRegisterPostRequest(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
    };
}
