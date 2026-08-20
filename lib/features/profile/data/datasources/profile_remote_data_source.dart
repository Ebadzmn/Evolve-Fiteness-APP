import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/apiUrls/api_urls.dart';
import '../../../../core/network/api_client.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> fetchProfile();
  Future<ProfileModel> updateProfileImage(File image);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProfileModel> fetchProfile() async {
    final response = await apiClient.get('${ApiUrls.baseUrl}/profile');

    if (response.data['success'] == true) {
      return ProfileModel.fromJson(response.data['data']);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }

  @override
  Future<ProfileModel> updateProfileImage(File image) async {
    final formData = FormData.fromMap(
      {
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      },
    );

    final response = await apiClient.patch(
      ApiUrls.updateProfileUrl,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    if (response.data['success'] == true) {
      return ProfileModel.fromJson(response.data['data']);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }
}
