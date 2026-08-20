import 'package:fitness_app/data/repositories/fake_checkin_repository.dart';
import '../../entities/checkin_entities/old_check_in_entity.dart';

class GetCheckInHistoryUseCase {
  final FakeCheckInRepository repo;
  GetCheckInHistoryUseCase(this.repo);
  Future<OldCheckInEntity?> call(int skip) => repo.getOldCheckIn(skip);
}
