import 'package:fitness_app/data/repositories/fake_checkin_repository.dart';

import '../../entities/checkin_entities/check_in_entity.dart';

class SaveCheckInUseCase {
  final FakeCheckInRepository repo;
  SaveCheckInUseCase(this.repo);
  Future<String?> call(
    CheckInEntity data, {
    List<Map<String, String>>? answers,
  }) => repo.save(data, answers: answers);
}
