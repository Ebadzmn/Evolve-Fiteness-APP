import 'package:fitness_app/data/repositories/fake_checkin_repository.dart';

import '../../entities/checkin_entities/check_in_entity.dart';

class GetCheckInInitialUseCase {
  final FakeCheckInRepository repo;
  GetCheckInInitialUseCase(this.repo);
  Future<CheckInEntity> call() => repo.loadInitial();
}
